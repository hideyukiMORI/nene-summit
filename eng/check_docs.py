"""必須文書と相対リンク。製品コードの合否は conformance、整形、lint、build、test が見る。"""
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

REQUIRED = (
    "README.md", "README.ja.md", "AGENTS.md", "LICENSE", "CONTRIBUTING.md", "SECURITY.md",
    ".cursor/rules/00-project.mdc", ".cursor/rules/10-swift.mdc",
    ".cursor/rules/20-docs.mdc", ".cursor/rules/30-git.mdc",
    ".swift-version", ".swift-format", ".swiftlint.yml", "Package.swift",
    ".githooks/commit-msg",
    "Sources/NeNeSummitCore/ModuleIdentity.swift",
    "Tests/NeNeSummitCoreTests/ModuleIdentityTests.swift",
    "eng/validate-commit-message.py", "eng/test_validate_commit_message.py",
    "eng/install-tools.sh", "eng/install-swift.sh", "eng/swiftlint.lock", "eng/swift.lock",
    "eng/swift-sources.sh", "eng/swift-strict.sh", "eng/lint.sh",
    "eng/conformance.py", "eng/test_conformance.py", "eng/test_tool_rules.py",
    "docs/README.md", "docs/CURSOR_HANDOFF.md", "docs/REQUIREMENTS.md", "docs/APPROACH.md",
    "docs/ARCHITECTURE_CONSTITUTION.md", "docs/PROJECT_LAYOUT.md", "docs/CODING_RULES.md",
    "docs/QUALITY_GATES.md", "docs/DEVELOPMENT_WORKFLOW.md", "docs/COMMIT_CONVENTIONS.md",
    "docs/GLOSSARY.md", "docs/ASSET_POLICY.md", "docs/PRIVACY.md", "docs/REFERENCES.md",
    "docs/adr/README.md", "docs/adr/0002-swift-strict-subset.md",
    "docs/adr/0003-measured-toolchain.md",
    "docs/waivers/README.md", "docs/quality/gate-proofs.md",
    "docs/todo/current.md",
)
IGNORED = {".git", ".build", ".swiftpm", ".tools", "__pycache__"}


def check(root: Path) -> list[str]:
    root = root.resolve()
    errors = []
    for name in REQUIRED:
        path = root / name
        if not path.is_file() or not path.read_text(encoding="utf-8").strip():
            errors.append(f"DOC-001: missing or empty {name}")
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        if any(part in IGNORED for part in relative.parts) or not path.is_file():
            continue
        if path.suffix not in {".md", ".mdc"}:
            continue
        content = path.read_text(encoding="utf-8")
        content = re.sub(r"```.*?```", "", content, flags=re.S)
        for target in re.findall(r"\[[^\]]*\]\(([^)]+)\)", content):
            target = target.strip().strip("<>")
            url = urlsplit(target)
            if url.scheme or url.netloc or not url.path:
                continue
            resolved = (path.parent / unquote(url.path)).resolve()
            if not resolved.is_relative_to(root) or not resolved.exists():
                errors.append(f"DOC-001: {relative}: missing or outside-repository link {target}")
    return errors


if __name__ == "__main__":
    failures = check(Path(__file__).resolve().parents[1])
    if failures:
        print("\n".join(failures), file=sys.stderr)
        sys.exit(1)
    print("PASS: required documents and relative links.")
