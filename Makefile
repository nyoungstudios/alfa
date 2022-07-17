all: build

help:
	@echo 'help - Show this message'
	@echo 'clean - remove dart package files'
	@echo 'build - compiles an alfa executable'

clean:
	@rm -rf .dart_tool
	@rm -rf .packages
	@rm -rf pubspec.lock

build:
	dart compile exe bin/alfa.dart -o alfa
