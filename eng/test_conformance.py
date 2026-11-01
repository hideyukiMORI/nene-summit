"""規約検査の正例と反例。"""

import unittest
from pathlib import Path

from conformance import violations

FORMAT = '{ "version": 1, "indentation": { "spaces": 4 }, "lineLength": 120 }\n'
LINT = "strict: true\nonly_rules:\n  - force_unwrapping # SWF-004\n"
MAKEFILE = "format:\n\tswift-format lint --strict --configuration .swift-format\nlint:\n\tswiftlint --config .swiftlint.yml\n"
MANIFEST = """\
// swift-tools-version: 6.2
import PackageDescription
let package = Package(
    name: "Fixture",
    targets: [
        .target(
            name: "NeNeSummitCore",
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
"""
SOURCE = "struct Marker {\n    let value: Int\n}\n"


class ConformanceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = __import__("tempfile").TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.write(".swift-format", FORMAT)
        self.write(".swiftlint.yml", LINT)
        self.write("Makefile", MAKEFILE)
        self.write("Package.swift", MANIFEST)
        self.write("Sources/NeNeSummitCore/Marker.swift", SOURCE)

    def write(self, relative, text):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")

    def rules(self):
        return {item.rule for item in violations(self.root)}

    def test_valid_tree_is_quiet(self):
        self.assertEqual(violations(self.root), [])

    def test_rejects_forbidden_suffix(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct MarkerManager {}\n")
        self.assertIn("CNF-001", self.rules())

    def test_rejects_second_top_level_type(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {}\nstruct Other {}\n")
        self.assertIn("CNF-002", self.rules())

    def test_rejects_throws_in_sources(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {\n    func load() throws {}\n}\n")
        self.assertIn("CNF-003", self.rules())

    def test_allows_throws_in_tests(self):
        self.write("Tests/NeNeSummitCoreTests/MarkerTests.swift", "func load() throws {}\n")
        self.assertNotIn("CNF-003", self.rules())

    def test_rejects_foundation_import(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "import Foundation\nstruct Marker {}\n")
        self.assertIn("CNF-004", self.rules())

    def test_rejects_xctest_import(self):
        self.write("Tests/NeNeSummitCoreTests/MarkerTests.swift", "import XCTest\n")
        self.assertIn("CNF-004", self.rules())

    def test_ignores_import_inside_comment(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "// import Foundation\nstruct Marker {}\n")
        self.assertEqual(violations(self.root), [])

    def test_rejects_async(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {\n    func load() async {}\n}\n")
        self.assertIn("CNF-005", self.rules())

    def test_rejects_any(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {\n    let value: Any\n}\n")
        self.assertIn("CNF-006", self.rules())

    def test_rejects_disable_without_waiver(self):
        self.write(
            "Sources/NeNeSummitCore/Marker.swift",
            "struct Marker {\n    // swiftlint:disable:next force_unwrapping\n    let value = 1\n}\n",
        )
        self.assertIn("CNF-007", self.rules())

    def test_rejects_format_rules_key(self):
        self.write(".swift-format", '{ "version": 1, "indentation": { "spaces": 4 }, "lineLength": 120, "rules": {} }\n')
        self.assertIn("CNF-008", self.rules())

    def test_rejects_lint_exclusion(self):
        self.write(".swiftlint.yml", "strict: true\nexcluded:\n  - Sources\nonly_rules:\n  - force_unwrapping # SWF-004\n")
        self.assertIn("CNF-009", self.rules())

    def test_rejects_manifest_without_warnings_as_errors(self):
        self.write("Package.swift", MANIFEST.replace(", .enableUpcomingFeature(\"ExistentialAny\")", ""))
        self.assertIn("CNF-010", self.rules())

    def test_rejects_public_var(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {\n    public var value: Int\n}\n")
        self.assertIn("CNF-011", self.rules())

    def test_rejects_unsafe_outside_terminal(self):
        self.write("Sources/NeNeSummitCore/Marker.swift", "struct Marker {\n    func raw() { unsafeBitCast(0, to: Int.self) }\n}\n")
        self.assertIn("CNF-012", self.rules())


if __name__ == "__main__":
    unittest.main()
