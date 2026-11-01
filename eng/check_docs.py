"""Small, documentation-only bootstrap gate. Product gates must replace its guard in P0."""
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

REQUIRED = (
    "README.md", "README.ja.md", "AGENTS.md", "LICENSE", "CONTRIBUTING.md", "SECURITY.md",
    ".cursor/rules/00-project.mdc", ".cursor/rules/10-swift.mdc",
    "docs/README.md", "docs/CURSOR_HANDOFF.md", "docs/REQUIREMENTS.md", "docs/APPROACH.md",
    "docs/ARCHITECTURE_CONSTITUTION.md", "docs/PROJECT_LAYOUT.md", "docs/CODING_RULES.md",
    "docs/QUALITY_GATES.md", "docs/DEVELOPMENT_WORKFLOW.md", "docs/COMMIT_CONVENTIONS.md",
    "docs/GLOSSARY.md", "docs/ASSET_POLICY.md", "docs/PRIVACY.md", "docs/REFERENCES.md",
    "docs/adr/README.md", "docs/waivers/README.md", "docs/quality/gate-proofs.md",
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
        if path.suffix == ".swift":
            errors.append(f"DOC-002: {relative}: implement product gates in P0 before adding Swift")
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
    print("PASS: documentation bootstrap only; Swift build/game/terminal gates are not implemented.")
