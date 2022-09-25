.PHONY: help clean rename lint fix

all: build rename

help:
	@echo 'help - Show this message'
	@echo 'clean - remove dart package files'
	@echo 'build - compiles an alfa executable'

clean:
	@rm -rf .dart_tool
	@rm -rf .packages
	@rm -rf pubspec.lock

alfa:
	dart compile exe bin/alfa.dart -o alfa

build: alfa

rename: build
	@./rename.sh

lint:
	@dart analyze --fatal-infos

fix:
	@dart fix --apply
