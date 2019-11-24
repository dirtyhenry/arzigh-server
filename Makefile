install:
	brew bundle

open:
	vapor xcode

build:
	swift build

test:
	swift test

package:
	swift build -c release
