### Makefile for building IKEMEN
### Help from https://sohlich.github.io/post/go_makefile/
### as well as http://www.codershaven.com/multi-platform-makefile-for-go/

# Loads of unfinished things, they'll be finished soon.

## Go parameters:
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOMOD=$(GOCMD) mod
# for getting packages, etc.
GOGET=$(GOCMD) get
# version of project
VERSION=$(shell git describe --tags --always --long --dirty)

### Executable names
EXEC_NAME=Ikemen_GO
# Executable name for Windows
EXEC_WIN 	=$(EXEC_NAME)_win.exe
# Executable name for Linux
EXEC_UNIX=$(EXEC_NAME)_linux# _unix
# Executable name for Darwin
EXEC_DARWIN=$(EXEC_NAME)_darwin

.PHONY: all clean rm_all

help: ## Show this help message; Display available commands in terminal
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: linux windows darwin ## !!UNFINISHED!! Build for all platforms 

linux: deps ## Build for Linux platform. (x86_64) 
	mkdir -p ./bin
	mkdir -p ./script
	env GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./bin/$(EXEC_UNIX) ./src
	chmod +x ./bin/$(EXEC_UNIX)
	cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command
	cp -r ./script/ ./bin/script/
	cp -r ./data/ ./bin/data/
	cp -a ./bin/* .
	rm -rf ./bin

linux_bin: deps ## Build for Linux platform, and keep it within ./bin/
	mkdir -p ./bin/
	mkdir -p ./script/
	env GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./bin/$(EXEC_UNIX) ./src
	chmod +x ./bin/$(EXEC_UNIX)
	cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command


linux_HOME: # linux ## !!UNFINISHED!! Install everything under the $HOME directory 

windows: ## !!UNFINISHED!! Build for Windows platform. (x86_64) 
	#$(WINDOWS)

darwin: ## !!UNFINISHED!! Build for Darwin platform. (x86_64) 
	#$(DARWIN)

#$(LINUX): deps
	#mkdir -p ./bin
	#env GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./bin/$(EXEC_UNIX) ./src
	#chmod +x ./bin/$(EXEC_UNIX)
	#cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command
	#cp -r ./script/ ./bin/script/
	#cp -r ./data/ ./bin/data/

# ($WINDOWS):
#	env 

appveyor_docker_build: ## Use a docker image to build for Windows/Linux/OS X. ## Dependencies are Ikemen_GO_plus source code, and docker.
	if [ ! -d ./bin ]; then\
		mkdir bin;\
	fi


deps: ## Get the necessary dependencies.
	@echo "Getting dependencies.."
	if [ ! -f ./go.mod ]; then \
		$(GOMOD) init github.com/Windblade-GR01/Ikemen_GO/src; \
		@echo ""; \
    fi
	$(GOGET) -u github.com/yuin/gopher-lua
	$(GOGET) -u github.com/go-gl/glfw/v3.3/glfw
	$(GOGET) -u github.com/go-gl/gl/v2.1/gl
	$(GOGET) -u github.com/timshannon/go-openal/openal
	$(GOGET) -u github.com/Windblade-GR01/glfont
	$(GOGET) -u github.com/flopp/go-findfont
	$(GOGET) -u github.com/faiface/beep
	$(GOGET) -u github.com/hajimehoshi/go-mp3@v0.2.1
	$(GOGET) -u github.com/hajimehoshi/oto@v0.5.4
	$(GOGET) -u github.com/pkg/errors
	$(GOGET) -u github.com/jfreymuth/oggvorbis
	$(GOGET) -u github.com/sqweek/dialog

version: ## Display version of IKEMEN (using git tags, but.. not annotated tags?)
	@echo $(VERSION)

clean: rm_exec ## Cleans up (only the binaries).
	rm -rf ./save/

rm_all: ## Removes all things, i.e. binaries, .mod and .sum files, the bin, src, go, external, windres directories, etc. Do NOT use this for cleaning up. (Actually, do NOT touch this.)
	rm_exec
	rm_mod
	rm_git
	rm_dir

# Remove binaries
rm_exec:
	rm -f ./$(EXEC_UNIX)
	rm -f ./$(EXEC_NAME).command
	rm -f ./$(EXEC_DARWIN)
	rm -f ./$(EXEC_WIN)

# Remove binaries--from within ./bin/
rm_exec_bin:
	rm -f ./bin/$(EXEC_UNIX)/
	rm -f ./bin/$(EXEC_NAME).command/
	rm -f ./bin/$(EXEC_DARWIN)/
	rm -f ./bin/$(EXEC_WIN)/

# Remove .mod and .sum
rm_mod:
	rm -f ./go.mod/
	rm -f ./go.sum/

# Remove .git files
rm_git:
	rm -f ./.gitattributes/
	rm -f ./.gitignore/

# Remove directories
rm_dir:
	rm -rf ./.git/
	rm -rf ./go/
	rm -rf ./src/
	rm -rf ./bin/
	rm -rf ./windres/
	rm -rf ./external/
	rm -rf ./script/
	#rm -rf build