.PHONY: bootstrap check

bootstrap:
	@python3 -c 'import sys; assert sys.version_info >= (3, 10), "Python 3.10+ required"'
	@git --version
	@echo "Documentation bootstrap only; no Swift tools or global Git settings changed."

check:
	python3 -m unittest discover -s eng -p 'test_*.py' -v
	python3 eng/check_docs.py
