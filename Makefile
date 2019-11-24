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

start-services:
	docker-compose -f stack.yml up
