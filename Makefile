.PHONY: bootstrap check tools commits format lint conformance build test

BASE ?= origin/main
SWIFTLINT := .tools/swiftlint

bootstrap: tools
	@python3 -c 'import sys; assert sys.version_info >= (3, 10), "Python 3.10+ required"'
	@git --version
	@git config core.hooksPath .githooks
	@echo "Local core.hooksPath=.githooks. SwiftLint is in .tools. No global Git settings changed."

tools:
	eng/install-tools.sh

check: tools commits
	python3 -m unittest discover -s eng -p 'test_*.py' -v
	python3 eng/check_docs.py
	python3 eng/conformance.py
	$(MAKE) format
	$(MAKE) lint
	$(MAKE) build
	$(MAKE) test

commits:
	@if git rev-parse --verify "$(BASE)^{commit}" >/dev/null 2>&1; then \
		python3 eng/validate-commit-message.py --range "$(BASE)..HEAD"; \
	else \
		echo "GIT-003: $(BASE) が無いので HEAD の履歴を検査する"; \
		python3 eng/validate-commit-message.py --range "HEAD"; \
	fi

format:
	eng/swift-sources.sh | xargs -0 -r swift-format lint --strict --configuration .swift-format

lint:
	eng/lint.sh $(SWIFTLINT) --config .swiftlint.yml

conformance:
	python3 eng/conformance.py

build:
	eng/swift-strict.sh swift build
	eng/swift-strict.sh swift build -c release

test:
	eng/swift-strict.sh swift test
	eng/swift-strict.sh swift test -c release
