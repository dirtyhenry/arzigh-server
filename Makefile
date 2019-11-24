install:
	brew bundle
	vapor xcode

build:
	swift build

test:
	swift test

package:
	swift build -c release
