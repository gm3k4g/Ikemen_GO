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
BINARY_NAME=Ikemen_GO
# Executable name for Windows
BINARY_WIN32=$(BINARY_NAME)_Win_x86.exe
# Executable name for Windows 64-bit
BINARY_WIN64=$(BINARY_NAME)_Win_x64.exe
# Executable name for Linux
BINARY_UNIX=$(BINARY_NAME)_linux
# Executable name for Mac
BINARY_DARWIN=$(BINARY_NAME)_mac

.PHONY: all clean rm_all

help: ## Show this help message; Display available commands in terminal
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: linux windows darwin ## !!UNFINISHED!! Build for all platforms 

linux_nobin: linux # Build for Linux platform. The binaries go in the root directory. (x86_64) 
	cp -a ./bin/* .
	rm -rf ./bin

# build.sh
#export GOPATH=$PWD/go
#export CGO_ENABLED=1
linux: deps_unix ikemen_cmd_unix ## Build for Linux platform. The binaries go in the bin directory. (x86_64)
	mkdir -p ./bin/
	mkdir -p ./script/
	env GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./bin/$(BINARY_UNIX) ./src # \
#	-trimpath \
#	-buildmode=pie \
#	-mod=readonly \
#	-modcacherw \
#	-ldflags "-extldflags \"${LDFLAGS}\"" \
#	.

	chmod +x ./bin/$(BINARY_UNIX)
	#cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command
	mv ./Ikemen_GO.command ./bin/Ikemen_GO.command
	cp -r ./script/ ./bin/script/
	cp -r ./data/ ./bin/data/


linux_HOME: # linux # !!UNFINISHED!! Install everything under the $HOME directory 

windows_32: deps_win ## !!UNFINISHED!! Build for Windows platform. The binaries go in the bin directory.(x86)

		#export GOOS=windows
		#export GOARCH=386
	    #export CC=i686-w64-mingw32-gcc
	    #export CXX=i686-w64-mingw32-g++
	    #BINARY_NAME="Ikemen_GO_Win_x86.exe";
		#IS_WINDOWS="1"	
		$(GOBUILD) -ldflags "-H windowsgui" -o ./bin/$(BINARY_WIN32) ./src

windows_64: deps_win ## !!UNFINISHED!! Build for Windows platform. The binaries go in the bin directory. (x86_64)
	#export GOOS=windows
	#export CC=x86_64-w64-mingw32-gcc
	#export CXX=x86_64-w64-mingw32-g++
	#BINARY_NAME="Ikemen_GO_Win_x64.exe";
	#IS_WINDOWS="1"
	#
	#@echo off
	#cd ..
	#set GOPATH=%cd%/go
	#set CGO_ENABLED=1
	#set GOOS=windows
	if not exist go.mod (
		echo Missing dependencies, please run get.cmd
		echo.
		pause
		exit
	)
	if not exist bin (
		MKDIR bin
	) 

	echo Building Ikemen GO...
	echo.

	#go build -ldflags -H windowsgui -o ./bin/$BINARY_NAME ./src
	#go build -ldflags -H=windowsgui -o ./bin/$(BINARY_WIN64) ./src 
	$(GOBUILD) -ldflags -H=windowsgui -o ./bin/$(BINARY_WIN64) ./src

	echo.
	pause

darwin: ## !!UNFINISHED!! Build for Darwin platform. The binaries go in the bin directory. (x86_64)
	#$(DARWIN)

#"mac") 
#export GOOS=darwin
#export CC=o64-clang 
#export CXX=o64-clang++
#BINARY_NAME="Ikemen_GO_mac"; 

#go build -o ./bin/$BINARY_NAME ./src
#$(GOBUILD) -o ./bin/$(BINARY_UNIX) ./src
#$(LINUX): deps_unix
	#mkdir -p ./bin
	#env GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./bin/$(BINARY_UNIX) ./src
	#chmod +x ./bin/$(BINARY_UNIX)
	#cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command
	#cp -r ./script/ ./bin/script/
	#cp -r ./data/ ./bin/data/

# ($WINDOWS):
#	env 

# docker_build.sh
#TODO: put everything under seperate directives

 ## Dependencies are Ikemen_GO_plus source code, and docker.
docker: ## !!UNFINISHED!! Use a docker image to build for Windows/Linux/OS X.
	mkdir -p ./bin

	@echo "------------------------------------------------------------"
	docker run --rm -e OS=linux -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x get.sh'

	@echo "------------------------------------------------------------"
	echo "Building linux binary..."
	docker run --rm -e OS=linux -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x build_crossplatform.sh' 

	@echo "------------------------------------------------------------"
	@echo "Building windows binary..."
	docker run --rm -e OS=windows -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x build_crossplatform.sh' 

	@echo "------------------------------------------------------------"
	@echo "Building mac binary..."
	docker run --rm -e OS=mac -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

# appveyor_docker_build.sh
# TODO
## Dependencies are Ikemen_GO_plus source code, and docker.
appveyor_docker: ## !!UNFINISHED!! Use a docker image to build for Windows/Linux/OS X, with appveyor
	if [ ! -d ./bin ]; then\
		mkdir bin;\
	fi
	@echo "------------------------------------------------------------"
	docker run --rm -e OS=linux -v $(pwd):/code -i windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x get.sh'

	@echo "------------------------------------------------------------"
	@echo "Building linux binary..."
	docker run --rm -e OS=linux -v $(pwd):/code -i windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

	@echo "------------------------------------------------------------"
	@echo "Building mac binary..."
	docker run --rm -e OS=mac -v $(pwd):/code -i windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

	@echo "------------------------------------------------------------"
	@echo "Building windows x86 binary..."
	docker run --rm -e OS=windows32 -v $(pwd):/code -i windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

	# We copy the Windres files so we can have a icon files
	cp 'windres/Ikemen_Cylia_x64.syso' 'src/Ikemen_Cylia_x64.syso'

	echo "------------------------------------------------------------"
	echo "Building windows x64 binary..."
	docker run --rm -e OS=windows -v $(pwd):/code -i windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

# appveyor_pack_release.sh
# TODO
appveyor_pack_release: #
	curl -SLO https://kcat.strangesoft.net/openal-binaries/openal-soft-1.20.0-bin.zip
	mkdir -p ./bin

	7z x ./openal-soft-1.20.0-bin.zip
	mv openal-soft-1.20.0-bin AL_Temp_416840
	mv ./AL_Temp_416840/bin/Win64/soft_oal.dll ./bin/soft_oal_x64.dll
	mv ./AL_Temp_416840/bin/Win32/soft_oal.dll ./bin/soft_oal_x86.dll
	rm -rf AL_Temp_416840
	rm openal-soft-1.20.0-bin.zip

	#cp ./build/Ikemen_GO.command ./bin/Ikemen_GO.command 
	cp ./Ikemen_GO.command ./bin/Ikemen_GO.command 
	cp ./License.txt ./bin/License.txt

	if [ ! -d ./Ikemen_GO-Elecbyte-Screenpack ]; then\
		git clone https://github.com/Windblade-GR01/Ikemen_GO-Elecbyte-Screenpack.git;\
	fi
	mv ./Ikemen_GO-Elecbyte-Screenpack/chars ./bin/chars
	mv ./Ikemen_GO-Elecbyte-Screenpack/data ./bin/data
	mv ./Ikemen_GO-Elecbyte-Screenpack/font ./bin/font
	mv ./Ikemen_GO-Elecbyte-Screenpack/stages ./bin/stages
	rm -rf Ikemen_GO-Elecbyte-Screenpack

	rsync -a ./external ./bin/
	rsync -a ./data ./bin/

	cd bin

	mkdir -p ./bin/save
	mkdir -p ./bin/sound
	mkdir -p ./bin/save/replays

	mv ./bin/soft_oal_x86.dll ./bin/OpenAL32.dll
	mv ./bin/Ikemen_GO_Win_x86.exe ./bin/Ikemen_GO.exe

	# change everything else below to be within ./bin
	7z a -tzip ./release/Ikemen_GO_Win_x86.zip ./chars ./data ./font ./save ./external sound ./stages License.txt 'Ikemen_GO.exe' 'OpenAL32.dll'
	7z a -tzip ./release/Ikemen_GO_Win_x86_Binaries_only.zip ./external License.txt 'Ikemen_GO.exe' 'OpenAL32.dll'

	mv ./Ikemen_GO.exe ./Ikemen_GO_Win_x86.exe
	mv ./OpenAL32.dll ./soft_oal_x86.dll

	mv ./Ikemen_GO_Win_x64.exe ./Ikemen_GO.exe
	mv ./soft_oal_x64.dll ./OpenAL32.dll

	7z a -tzip ./release/Ikemen_GO_Win_x64.zip ./chars ./data ./font ./save ./external sound ./stages License.txt 'Ikemen_GO.exe' 'OpenAL32.dll'
	7z a -tzip ./release/Ikemen_GO_Win_x64_Binaries_only.zip ./external License.txt 'Ikemen_GO.exe' 'OpenAL32.dll'

	mv ./Ikemen_GO.exe ./Ikemen_GO_Win_x64.exe
	mv ./OpenAL32.dll ./soft_oal_x64.dll

	7z a -tzip ./release/Ikemen_GO_Mac.zip ./chars ./data ./font ./save ./external sound ./stages License.txt Ikemen_GO.command Ikemen_GO_mac
	7z a -tzip ./release/Ikemen_GO_Mac_Binaries_only.zip ./external License.txt Ikemen_GO.command Ikemen_GO_mac

	7z a -tzip ./release/Ikemen_GO_Linux.zip ./chars ./data ./font ./save ./external sound ./stages License.txt Ikemen_GO.command Ikemen_GO_linux
	7z a -tzip ./release/Ikemen_GO_Linux_Binaries_only.zip ./external License.txt Ikemen_GO.command Ikemen_GO_linux

# pack_release.sh:
# Package binaries only(?) into archives
# TODO
pack_release: # 
	curl -SLO https://kcat.strangesoft.net/openal-binaries/openal-soft-1.20.0-bin.zip
	mkdir -p ./bin

	7z x ./openal-soft-1.20.0-bin.zip
	mv openal-soft-1.20.0-bin AL_Temp_416840
	mv ./AL_Temp_416840/bin/Win64/soft_oal.dll ./bin/soft_oal_x64.dll
	mv ./AL_Temp_416840/bin/Win32/soft_oal.dll ./bin/soft_oal_x86.dll
	rm -rf AL_Temp_416840
	rm openal-soft-1.20.0-bin.zip

	cd bin
	mkdir -p release

	7z a -tzip ./release/Ikemen_GO_Win_x86.zip ../script ../data 'Ikemen_GO_Win_x86.exe' 'soft_oal_x86.dll'
	7z rn ./release/Ikemen_GO_Win_x86.zip 'Ikemen_GO_Win_x86.exe' 'Ikemen_GO.exe'
	7z rn ./release/Ikemen_GO_Win_x86.zip 'soft_oal_x86.dll' 'OpenAL32.dll'

	7z a -tzip ./release/Ikemen_GO_Win_x64.zip ../script ../data 'Ikemen_GO_Win_x64.exe' 'soft_oal_x64.dll'
	7z rn ./release/Ikemen_GO_Win_x64.zip 'Ikemen_GO_Win_x64.exe' 'Ikemen_GO.exe'
	7z rn ./release/Ikemen_GO_Win_x64.zip 'soft_oal_x64.dll' 'OpenAL32.dll'

	7z a -tzip ./release/Ikemen_GO_Mac.zip ../script ../data Ikemen_GO.command Ikemen_GO_mac
	7z a -tzip ./release/Ikemen_GO_Linux.zip ../script ../data Ikemen_GO.command Ikemen_GO_linux

install: ## !!UNFINISHED!! Install (?)
	@echo "Nil"

# build_crossplatform.sh
# TODO
crossplatform: #
	#export GOPATH=$PWD/go
	#export CGO_ENABLED=1
	IS_WINDOWS="0"

	if [ "$IS_WINDOWS" = "1" ]; then
		go build -ldflags "-H windowsgui" -o ./bin/$BINARY_NAME ./src
	else
		go build -o ./bin/$BINARY_NAME ./src
	fi

	chmod +x ./bin/$BINARY_NAME

# get.sh
#export GOPATH=$PWD/go
#export CGO_ENABLED=1
deps_unix: # Get the necessary dependencies (linux)
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


# get.cmd
# TODO
# will this work?
deps_win: # Get necessary dependencies (windows)
	@echo off
	cd ..
	set GOPATH=%cd%/go
	set CGO_ENABLED=1
	set GOOS=windows

	echo Downloading dependencies...
	echo. 

	if not exist go.mod (
		go mod init github.com/Windblade-GR01/Ikemen_GO/src
		echo. 
	)

	go get -u github.com/yuin/gopher-lua
	go get -u github.com/go-gl/glfw/v3.3/glfw
	go get -u github.com/go-gl/gl/v2.1/gl
	go get -u github.com/timshannon/go-openal/openal
	go get -u github.com/Windblade-GR01/glfont
	go get -u github.com/flopp/go-findfont
	go get -u github.com/faiface/beep
	go get -u github.com/hajimehoshi/go-mp3@v0.2.1
	go get -u github.com/hajimehoshi/oto@v0.5.4
	go get -u github.com/pkg/errors
	go get -u github.com/jfreymuth/oggvorbis
	go get -u github.com/sqweek/dialog

	echo. 
	pause

# Using 'echo', create the file `Ikemen_GO.command` in the current directory
ikemen_cmd_unix: #creates Ikemen_GO.command file
	#if [ ! -f ./$(BINARY_NAME).command ]; then\
		touch ./$(BINARY_NAME).command #;\
		echo -n -e "#!/bin/bash\
		\rcd \$$(dirname \$$0)\n\
		\rcase \"\$$OSTYPE\" in\
		    \r\tdarwin*) #echo \"It's a Mac!!\" ;\
		    \r\t\tchmod +x Ikemen_GO_mac\
		    \r\t\t./Ikemen_GO_mac\
		        \r\t\t;;\
		    \r\tlinux*)\
		        \r\t\tchmod +x Ikemen_GO_linux\
		        \r\t\t./Ikemen_GO_linux\
		     \r\t ;;\
		    \r\t*) echo \"System not recognized\"; exit 1 ;;\
		\resac" > ./$(BINARY_NAME).command #;\
	#fi

version: ## Display version of IKEMEN (using git tags, but.. not annotated tags?)
	@echo $(VERSION)

clean: rm_exec ## Cleans up (removes binaries from root directory, and removes the ./bin and ./release directories).
	rm -rf ./bin
	rm -rf ./release

rm_everything: rm_mod rm_git rm_dir # Removes all 'unnecessary' things, i.e. .mod and .sum files, src, go, external, windres directories, etc. Do NOT use this for cleaning up. (Actually, do NOT touch this at all.)

# Remove binaries in root directory
rm_exec:
	rm -f ./$(BINARY_UNIX)
	#rm -f ./$(BINARY_NAME).command
	rm -f ./$(BINARY_DARWIN)
	rm -f ./$(BINARY_WIN64)
	rm -rf ./save
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
	rm -rf ./.git
	rm -rf ./go
	rm -rf ./src
	rm -rf ./bin
	rm -rf ./windres
	rm -rf ./external
	rm -rf ./script
	rm -rf ./save
	#rm -rf build