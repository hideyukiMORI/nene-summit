"""Positive and negative proofs for the small bootstrap checker."""
from pathlib import Path
import tempfile
import unittest
from check_docs import REQUIRED, check


class DocumentationGateTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        for name in REQUIRED:
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("# Fixture\n", encoding="utf-8")

    def test_valid_documentation(self):
        (self.root / "README.md").write_text(
            "[Guide](AGENTS.md) [External](https://example.com/)\n", encoding="utf-8"
        )
        self.assertEqual(check(self.root), [])

    def test_missing_required_document(self):
        (self.root / "AGENTS.md").unlink()
        self.assertTrue(any("DOC-001: missing or empty AGENTS.md" in e for e in check(self.root)))

    def test_broken_relative_link(self):
        (self.root / "README.md").write_text("[Broken](missing.md)\n", encoding="utf-8")
        self.assertTrue(any("DOC-001:" in e and "missing.md" in e for e in check(self.root)))

    def test_outside_repository_link(self):
        (self.root / "README.md").write_text("[Outside](../outside.md)\n", encoding="utf-8")
        self.assertTrue(any("DOC-001:" in e and "outside-repository" in e for e in check(self.root)))

    def test_swift_source_requires_product_gates(self):
        path = self.root / "Sources" / "NeNeSummitCore" / "State.swift"
        path.parent.mkdir(parents=True)
        path.write_text("struct State {}\n", encoding="utf-8")
        self.assertTrue(any("DOC-002:" in e for e in check(self.root)))

    def test_manifest_requires_product_gates(self):
        (self.root / "Package.swift").write_text("// Manifest\n", encoding="utf-8")
        self.assertTrue(any("DOC-002:" in e for e in check(self.root)))
