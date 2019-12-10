# devbuntu

[![Docker Hub](https://img.shields.io/badge/docker%20hub-pokusew%2Fdevbuntu-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/pokusew/devbuntu)

Ubuntu Docker image for development and experiments, useful especially on macOS


## What's included

**Ubuntu version: [19.10 (rolling)](https://hub.docker.com/_/ubuntu/?tab=tags&page=1&name=rolling)**

* based on the official [ubuntu:rolling](https://hub.docker.com/_/ubuntu/?tab=tags&page=1&name=rolling) Docker image, but unminimized for interactive usage
* **man pages**
* **git**
* **preconfigured Bash** with [bash-powerline](https://github.com/riobard/bash-powerline), [hstr](https://github.com/dvorka/hstr) and some other tweaks
* **basic utils**: curl, wget, ping, zip
* **C development**: **clang** (set as default, available also under the _cc_ alias), make, valgrind, gcc
* **ARM development**: preconfigured gcc, arm-linux-gnueabihf-* commands (gcc-multilib-arm-linux-gnueabihf)
* **MIPS development**: preconfigured gcc, mips-* commands
* **Node.js**: [nvm](https://github.com/creationix/nvm), Node.js 10.x, [yarn](https://yarnpkg.com/), npm

see [Dockerfile](/Dockerfile) for complete overview


## Installation

Docker image name: `pokusew/devbuntu:latest`

You can run image directly, but please specify entrypoint (for example bash).
For the most convenient usage, see [Usage](#usage) section below.

## Usage


Add the following Bash function to your Bash config file (`~/.bashrc`, `~/.bash_profile`):  

```bash
# --mount type=bind,source=$PWD,destination=/test is equivalent to -v $PWD:/test
function linux() {

	options="$*"

	# see https://docs.docker.com/engine/reference/run/
	cmd="docker run"
	cmd+=" --rm"
	cmd+=" -ti"
	cmd+=" --name valgrind"
	cmd+=" --mount type=bind,source=$PWD,destination=/test"
	
	# uncomment the following line if you want to use GUI apps through macOS XQuartz X11
	# also replace $IP with you current local IP address or set the IP env var
	# cmd+=" -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix"
	
	cmd+=" -w /test"

	if [[ ${options} != "" ]];
	then
		cmd+=" ${options}"
	fi

	cmd+=" pokusew/devbuntu:latest bash"

	echo "Running: ${cmd}"

	${cmd}

}
```

**Then you can run the image using:** 

```bash
linux
```

or you can pass any `docker run` arguments as well:

```bash
linux -p 5000:5000/udp
```

In any case, **the current terminal working directory** will be mounted as `/test` folder in the container and set as **working directory**.


## GUI applications

Is possible to run GUI apps in the container and use the host's OS X11 server to render the windows.

Inside the container run:

```bash
apt-get install nvidia-340 mesa-utils
apt-get install gedit dbus-x11 # so we can test GUI works
```

In macOS, install [XQuartz](https://www.xquartz.org/) (you can use brew cask to install it).

Then run this to enable some features that will make it work with our Docker image:
```bash
defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
```

see https://askubuntu.com/a/938574 (https://askubuntu.com/questions/771000/ssh-from-my-mac-into-ubuntu-x-forwarding-not-working-correctly) for more info

Start XQuartz and run:
_Replace `$IP` with you current local IP address or set the IP env var._

```bash
DISPLAY=$IP:0 xhost + $IP
```

This will enable remote access to XQuartz's X11 server from the specified IP address.

**Related links:**
- [Running GUI applications using Docker for Mac](https://sourabhbajaj.com/blog/2017/02/07/gui-applications-docker-mac/) guide


## Useful commands in the container

valgrind with some good options enabled:
```
valgrind --leak-check=full --track-origins=yes program-to-test
```


## MIPS development with [QtMips](https://github.com/cvut/QtMips)

[QtMips](https://github.com/cvut/QtMips) is MIPS CPU emulator. It is a multi-platform app, which can run on macOS.
However no builds for macOS are provided, so you have to build QtMips yourselves or you can use my build.

**Update:** Currently, I am working on automatized and improved builds for macOS. Once it is finished,
the changes will be (hopefully) merged into the official [cvut/QtMips](https://github.com/cvut/QtMips) repository.

See [pokusew/QtMips#macos-build](https://github.com/pokusew/QtMips/tree/macos-build) for progress.  
**See [pokusew/QtMips Azure Pipelines builds](https://dev.azure.com/pokusew/QtMips/_build?definitionId=1) for the new builds.**

> ### Old QtMips builds for macOS
> see [qtmips-builds's README](/qtmips-builds/README.md)

Once you have QtMips running on your macOS, you need to build your source codes (MIPS assembler or C) to ELF files which can be read and executed by QtMips.

You can setup cross-build using your favourite compiler, or your can use pokusew/devbuntu Docker image for it.

If you have a correctly configured Makefile which uses mips-gcc, use can just run `make` inside the container and you do not have to bother with any setup.
