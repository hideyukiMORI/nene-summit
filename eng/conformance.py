#!/usr/bin/env python3
"""記述規約のうち、字句と設定ファイルで見られる部分。

文字列リテラルとコメントは空白にする。文字列補間の中はコードとして見ない。
"""

import json
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

SKIP_DIRS = {".git", ".build", ".tools", ".swiftpm", "__pycache__"}
FORBIDDEN_SUFFIXES = ("Manager", "Helper", "Utils", "Util", "Common")
FORBIDDEN_IMPORTS = ("Foundation", "FoundationEssentials", "Dispatch", "XCTest", "CoreFoundation", "Glibc")
TYPE_RE = re.compile(
    r"^(?:(?:public|private|internal|fileprivate|open|final|indirect)\s+)*"
    r"(?:struct|enum|class|actor|protocol)\s+([A-Za-z_][A-Za-z0-9_]*)",
    re.M,
)
TARGET_RE = re.compile(r"\.(?:target|testTarget|executableTarget)\(")
WARNINGS = ".treatAllWarnings(as: .error)"
EXISTENTIAL = '.enableUpcomingFeature("ExistentialAny")'


@dataclass(frozen=True)
class Violation:
    rule: str
    path: str
    line: int
    message: str

    def render(self) -> str:
        return f"{self.rule} {self.path}:{self.line}: {self.message}"


def strip_swift(src: str) -> str:
    out: list[str] = []
    i = 0
    n = len(src)
    while i < n:
        if src.startswith("//", i):
            while i < n and src[i] != "\n":
                out.append(" ")
                i += 1
            continue
        if src.startswith("/*", i):
            while i < n and not src.startswith("*/", i):
                out.append("\n" if src[i] == "\n" else " ")
                i += 1
            if src.startswith("*/", i):
                out.extend("  ")
                i += 2
            continue
        if src[i] == '"':
            quote = '"""' if src.startswith('"""', i) else '"'
            out.extend(" " * len(quote))
            i += len(quote)
            while i < n and not src.startswith(quote, i):
                if src[i] == "\\" and i + 1 < n:
                    out.extend("  ")
                    i += 2
                    continue
                out.append("\n" if src[i] == "\n" else " ")
                i += 1
            if src.startswith(quote, i):
                out.extend(" " * len(quote))
                i += len(quote)
            continue
        out.append(src[i])
        i += 1
    return "".join(out)


def line_of(text: str, index: int) -> int:
    return text.count("\n", 0, index) + 1


def files(root: Path) -> list[Path]:
    listed = subprocess.run(
        ["git", "-C", str(root), "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
        capture_output=True,
        text=True,
    )
    if listed.returncode == 0 and (root / ".git").exists():
        names = [Path(name) for name in listed.stdout.split("\0") if name]
        return [name for name in names if (root / name).is_file()]
    found: list[Path] = []
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        if any(part in SKIP_DIRS for part in relative.parts) or not path.is_file():
            continue
        found.append(relative)
    return found


def violations(root: Path) -> list[Violation]:
    root = root.resolve()
    found: list[Violation] = []
    found.extend(config_violations(root))
    found.extend(manifest_violations(root))
    for relative in files(root):
        if relative.suffix != ".swift":
            continue
        raw = (root / relative).read_text(encoding="utf-8")
        code = strip_swift(raw)
        found.extend(swift_violations(relative, raw, code))
    return found


def config_violations(root: Path) -> list[Violation]:
    found: list[Violation] = []
    format_path = root / ".swift-format"
    if not format_path.is_file():
        found.append(Violation("CNF-008", ".swift-format", 1, "整形の正本が無い"))
    else:
        try:
            data = json.loads(format_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as err:
            found.append(Violation("CNF-008", ".swift-format", 1, f"JSON として読めない: {err}"))
        else:
            extra = set(data) - {"version", "indentation", "lineLength"}
            if extra:
                found.append(Violation("CNF-008", ".swift-format", 1, f"許さない鍵: {', '.join(sorted(extra))}"))
            indentation = data.get("indentation", {})
            if not isinstance(indentation, dict) or set(indentation) - {"spaces"}:
                found.append(Violation("CNF-008", ".swift-format", 1, "indentation は spaces だけ"))
    lint_files = [path for path in files(root) if path.name in {".swiftlint.yml", ".swiftlint.yaml"}]
    if lint_files != [Path(".swiftlint.yml")]:
        found.append(Violation("CNF-009", ".swiftlint.yml", 1, "SwiftLint の設定はルートの .swiftlint.yml 一つ"))
    lint_path = root / ".swiftlint.yml"
    if lint_path.is_file():
        for number, line in enumerate(lint_path.read_text(encoding="utf-8").splitlines(), start=1):
            stripped = line.strip()
            if re.match(r"(excluded|disabled_rules|opt_in_rules|baseline)\s*:", stripped):
                found.append(Violation("CNF-009", ".swiftlint.yml", number, f"{stripped.split(':')[0]} は置かない"))
            if stripped.startswith("- ") and "#" not in line:
                found.append(Violation("CNF-009", ".swiftlint.yml", number, "only_rules の行に # SWF-NNN が無い"))
        text = lint_path.read_text(encoding="utf-8")
        if "strict: true" not in text or "only_rules:" not in text:
            found.append(Violation("CNF-009", ".swiftlint.yml", 1, "strict: true と only_rules が要る"))
    makefile = root / "Makefile"
    if makefile.is_file():
        text = makefile.read_text(encoding="utf-8")
        if "--configuration .swift-format" not in text:
            found.append(Violation("CNF-008", "Makefile", 1, "swift-format は --configuration .swift-format で呼ぶ"))
        if "--config .swiftlint.yml" not in text:
            found.append(Violation("CNF-009", "Makefile", 1, "swiftlint は --config .swiftlint.yml で呼ぶ"))
    return found


def manifest_violations(root: Path) -> list[Violation]:
    path = root / "Package.swift"
    if not path.is_file():
        return [Violation("CNF-010", "Package.swift", 1, "manifest が無い")]
    text = path.read_text(encoding="utf-8")
    count = len(TARGET_RE.findall(text))
    found: list[Violation] = []
    if count == 0:
        found.append(Violation("CNF-010", "Package.swift", 1, "target が無い"))
    if text.count(WARNINGS) < count or text.count(EXISTENTIAL) < count:
        found.append(Violation("CNF-010", "Package.swift", 1, "各 target に警告のエラー化と ExistentialAny が要る"))
    if "swiftLanguageModes: [.v6]" not in text:
        found.append(Violation("CNF-010", "Package.swift", 1, "言語モードは Swift 6"))
    if ".package(" in text:
        found.append(Violation("CNF-010", "Package.swift", 1, "製品の外部パッケージは置かない"))
    return found


def swift_violations(relative: Path, raw: str, code: str) -> list[Violation]:
    found: list[Violation] = []
    path = str(relative)
    types = list(TYPE_RE.finditer(code))
    if len(types) > 1:
        found.append(Violation("CNF-002", path, line_of(code, types[1].start()), "最上位の型は 1 つ"))
    elif len(types) == 1 and types[0].group(1) != relative.stem:
        found.append(Violation("CNF-002", path, line_of(code, types[0].start()), "ファイル名を型名に合わせる"))
    for match in types:
        name = match.group(1)
        if name.endswith(FORBIDDEN_SUFFIXES):
            found.append(Violation("CNF-001", path, line_of(code, match.start()), f"型名の語尾 {name} は使わない"))
    target = relative.parts[1] if len(relative.parts) >= 3 and relative.parts[0] in {"Sources", "Tests"} else ""
    product = relative.parts[0] == "Sources" if relative.parts else False
    for match in re.finditer(r"^\s*import\s+(?:@\w+\s+)?(\w+)", code, re.M):
        imported = match.group(1)
        if imported in FORBIDDEN_IMPORTS and not (imported == "Glibc" and target.endswith("Terminal")):
            found.append(Violation("CNF-004", path, line_of(code, match.start()), f"{imported} は import しない"))
    if product:
        for match in re.finditer(r"\b(?:throw|throws|try|catch)\b", code):
            found.append(Violation("CNF-003", path, line_of(code, match.start()), "製品コードで例外を使わない"))
    for match in re.finditer(r"\b(?:async|await|actor|Task)\b", code):
        found.append(Violation("CNF-005", path, line_of(code, match.start()), "並行の語を使わない"))
    for match in re.finditer(r"\bAny(?:Object|Hashable|Class)?\b", code):
        found.append(Violation("CNF-006", path, line_of(code, match.start()), "Any 系で型を代用しない"))
    for match in re.finditer(r"\b(?:public\s+var|open\s+(?:class|func|var))\b", code):
        found.append(Violation("CNF-011", path, line_of(code, match.start()), "公開の可変格納と open を使わない"))
    if not target.endswith("Terminal"):
        for token in ("unsafeBitCast", "UnsafeMutablePointer", "UnsafePointer", "UnsafeRawPointer", "withUnsafe", "Unmanaged"):
            for match in re.finditer(re.escape(token), code):
                found.append(Violation("CNF-012", path, line_of(code, match.start()), f"{token} は Terminal だけ"))
    lines = raw.splitlines()
    for number, line in enumerate(lines, start=1):
        if "swift-format-ignore" in line or "swiftlint:disable" in line:
            specific = "swiftlint:disable:next" in line or "swiftlint:disable:this" in line
            if not specific or re.search(r"\ball\b", line):
                found.append(Violation("CNF-007", path, number, "抑制は行単位の next/this だけで、all は不可"))
                continue
            previous = lines[number - 2] if number > 1 else ""
            if "Waiver: WVR-" not in previous:
                found.append(Violation("CNF-007", path, number, "抑制の直前行に Waiver: WVR-NNNN が要る"))
    return found


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    found = violations(root)
    for item in found:
        print(item.render(), file=sys.stderr)
    if found:
        print(f"conformance: {len(found)} 件", file=sys.stderr)
        return 1
    print("conformance: 0 件")
    return 0


if __name__ == "__main__":
    sys.exit(main())
