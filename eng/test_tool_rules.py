"""整形・lint・警告エラー化の正例と反例。道具が無いときは失敗する。"""

import subprocess
import tempfile
import textwrap
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LINT = ROOT / ".tools" / "swiftlint"
CONFIG = ROOT / ".swiftlint.yml"
FORMAT = ROOT / ".swift-format"


def run(command, cwd):
    return subprocess.run(command, cwd=cwd, capture_output=True, text=True)


class ToolRuleTests(unittest.TestCase):
    def setUp(self):
        if not LINT.is_file():
            self.fail("SwiftLint が .tools/swiftlint に無い。make tools を先に実行する")

    def lint(self, source):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "Sample.swift"
            path.write_text(source, encoding="utf-8")
            return run(
                [str(LINT), "lint", "--strict", "--quiet", "--no-cache", "--config", str(CONFIG), str(path)],
                cwd=temporary,
            )

    def test_clean_source_passes_lint(self):
        result = self.lint("struct Sample {\n    let value: Int\n}\n")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("Skipping enabled rule", result.stdout + result.stderr)

    def test_each_enabled_rule_rejects_its_sample(self):
        samples = {
            "cyclomatic_complexity": "func f(_ n: Int) -> Int {\n"
            + "".join(f"    if n > {i} {{ return {i} }}\n" for i in range(12))
            + "    return n\n}\n",
            "function_body_length": "func f() {\n" + "".join(f"    let value{i} = {i}\n" for i in range(70)) + "}\n",
            "function_parameter_count": "func f(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int) -> Int { a + b + c + d + e }\n",
            "nesting": "func outer() {\n    func middle() {\n        func inner() {\n            func deeper() {\n                let value = 1\n                _ = value\n            }\n        }\n    }\n}\n",
            "file_length": "".join(f"let value{i} = {i}\n" for i in range(420)),
            "type_body_length": "struct Sample {\n" + "".join(f"    let value{i} = {i}\n" for i in range(320)) + "}\n",
            "force_unwrapping": "func f(_ value: Int?) -> Int { value! }\n",
            "implicitly_unwrapped_optional": "let value: Int! = 1\n",
            "discouraged_optional_boolean": "let value: Bool? = nil\n",
            "discouraged_optional_collection": "let value: [Int]? = nil\n",
            "force_cast": "func f(_ value: Any) -> Int { value as! Int }\n",
            "force_try": "func f() throws -> Int { 1 }\nlet value = try! f()\n",
            "large_tuple": "let value: (Int, Int, Int) = (1, 2, 3)\n",
            "fallthrough": "func f(_ value: Int) -> Int {\n    switch value {\n    case 0:\n        fallthrough\n    default:\n        return value\n    }\n}\n",
            "superfluous_disable_command": "// swiftlint:disable:next force_unwrapping\nlet value = 1\n",
            "blanket_disable_command": "// swiftlint:disable force_unwrapping\nlet value = 1\n",
        }
        enabled = [
            line.split("#", 1)[0].strip().lstrip("-").strip()
            for line in CONFIG.read_text(encoding="utf-8").splitlines()
            if line.strip().startswith("- ")
        ]
        self.assertEqual(sorted(samples), sorted(enabled))
        for rule, source in samples.items():
            result = self.lint(source)
            output = result.stdout + result.stderr
            self.assertNotEqual(result.returncode, 0, rule)
            self.assertIn(rule, output, output)

    def test_format_rejects_a_long_line_and_accepts_the_product_sources(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "Sample.swift"
            path.write_text("let value = \"" + ("a" * 130) + "\"\n", encoding="utf-8")
            rejected = run(
                ["swift-format", "lint", "--strict", "--configuration", str(FORMAT), str(path)],
                cwd=ROOT,
            )
            self.assertNotEqual(rejected.returncode, 0, rejected.stdout + rejected.stderr)
        listed = run(["eng/swift-sources.sh"], cwd=ROOT)
        self.assertEqual(listed.returncode, 0, listed.stderr)
        files = [item for item in listed.stdout.split("\0") if item]
        accepted = run(
            ["swift-format", "lint", "--strict", "--configuration", str(FORMAT), *files],
            cwd=ROOT,
        )
        self.assertEqual(accepted.returncode, 0, accepted.stdout + accepted.stderr)

    def test_unused_binding_fails_the_same_manifest_settings(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "Package.swift").write_text(
                textwrap.dedent(
                    """\
                    // swift-tools-version: 6.2
                    import PackageDescription
                    let package = Package(
                        name: "Probe",
                        targets: [
                            .target(
                                name: "Probe",
                                swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
                            ),
                        ],
                        swiftLanguageModes: [.v6]
                    )
                    """
                ),
                encoding="utf-8",
            )
            source = root / "Sources" / "Probe"
            source.mkdir(parents=True)
            (source / "Probe.swift").write_text(
                "func unusedBinding() -> Int {\n    let unused = 1\n    return 0\n}\n",
                encoding="utf-8",
            )
            failed = run(["swift", "build"], cwd=root)
            self.assertNotEqual(failed.returncode, 0)
            self.assertIn("never used", failed.stdout + failed.stderr)
            (source / "Probe.swift").write_text("func ready() -> Int {\n    return 0\n}\n", encoding="utf-8")
            built = run(["swift", "build"], cwd=root)
            self.assertEqual(built.returncode, 0, built.stdout + built.stderr)


if __name__ == "__main__":
    unittest.main()
