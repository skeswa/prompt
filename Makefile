DIR := ${CURDIR}

install:
	@if [ -e "$(HOME)/.prompt" ] ; \
	then \
		echo "FATAL: Could not symlink 'skeswa/prompt' to '~/.prompt' since '~/.prompt' already exists"; \
		exit 1; \
	fi;

	@echo "# Symlinking 'skeswa/prompt' to '~/.prompt'"
	@ln -s "$(DIR)" "$(HOME)/.prompt"

	@# Run install script
	@./install.bash

	@echo "# 'skeswa/prompt' installation complete!"
	@exit 0

.PHONY: install
