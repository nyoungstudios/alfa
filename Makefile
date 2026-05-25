.PHONY: all help build clean clean-cache clean-all lint fix

all: build

help:
	@echo 'help - Show this message'
	@echo 'build - compiles an alfa executable for the current operating system and architecture'
	@echo 'alfa_linux_armv7 - cross compiles an alfa executable for linux armv7'
	@echo 'alfa_linux_aarch64 - cross compiles an alfa executable for linux aarch64'
	@echo 'alfa_linux_riscv64 - cross compiles an alfa executable for linux riscv64'
	@echo 'clean - remove native and cross compiled alfa executables'
	@echo 'clean-cache - remove dart package files'
	@echo 'clean-all - runs clean and clean cache'
	@echo 'lint - runs the dart linter'
	@echo 'fix - applies the dart linting changes'

BIN_NAME := $(shell ./get_executable_name.sh)
SRCS := $(shell find bin lib -name '*.dart')

$(BIN_NAME): $(SRCS)
	dart compile exe bin/alfa.dart -o $(BIN_NAME)

build: $(BIN_NAME)

alfa_linux_armv7: $(SRCS)
	dart compile exe bin/alfa.dart --target-os linux --target-arch arm -o alfa_linux_armv7

alfa_linux_aarch64: $(SRCS)
	dart compile exe bin/alfa.dart --target-os linux --target-arch arm64 -o alfa_linux_aarch64

alfa_linux_riscv64: $(SRCS)
	dart compile exe bin/alfa.dart --target-os linux --target-arch riscv64 -o alfa_linux_riscv64

clean:
	rm -f $(BIN_NAME) alfa_linux_armv7 alfa_linux_aarch64 alfa_linux_riscv64

clean-cache:
	rm -rf .dart_tool .packages pubspec.lock

clean-all: clean clean-cache

lint:
	@dart analyze --fatal-infos

fix:
	@dart fix --apply
