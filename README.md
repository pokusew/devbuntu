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

To download or upgrade the image run: `docker pull pokusew/devbuntu:latest`

You can run image directly, but please specify entrypoint (for example bash).
For the most convenient usage, see [Usage](#usage) section below.


## Usage

You can run the devbuntu very easily using the provided simple Bash wrapper script `linux`.

❗️**Note:** **Bash 5+** is required to run the wrapper script `linux`. macOS contains only **Bash 3.x** by default.
    See [Upgrading Bash on macOS](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba).

To easily install the `linux` command, copy and paste into your terminal the following code:
```bash
cd ~ # change into the home directory
mkdir -p bin # create bin folder if not exists
cd bin
curl https://raw.githubusercontent.com/pokusew/devbuntu/master/linux.sh > linux
chmod +x linux
echo 'export PATH="$PATH:~/bin"' >> ~/.bashrc # add ~/bin to PATH
echo 'export PATH="$PATH:~/bin"' >> ~/.bash_profile # add ~/bin to PATH
```

_Alternatively: You can manually download [linux.sh](https://github.com/pokusew/devbuntu/blob/master/linux.sh) and use it as you wish._

After that, reopen your terminal window. Now you when you type `linux -h` or `linux --help`
you should get the following output:

    Starts Docker devbuntu container and mounts the current working directory as /test.
    Usage: linux [options] [-- docker options]
    Options:
      -h, --help > print help and exit
      -v, --version > print version and exit
      -n, --name <name> -> use custom container name
      -nm, --no-mount > do not mount the current working directory
      -i, --image <image> -> run this image instead of pokusew/devbuntu:latest
      -c, --entrypoint <entrypoint> -> run this program instead of bash
      -x, --x11-ip <your local IP address> -> enable X11 forwarding, see https://github.com/pokusew/devbuntu#gui-applications
    Examples:
      linux -n test -- --security-opt seccomp=unconfined -p 0.0.0.0:8080:8080/tcp -p 127.0.0.1:12345:12345/tcp
       > runs container with name test with custom docker run options (all options after "--" are passed directly to the docker run)

**As you can read in the help output, you can run the image using:** 

```bash
linux
```

or you can pass any `docker run` arguments after `--` as well:

```bash
linux -- -p 5000:5000/udp
```

By default, **the current terminal working directory** will be mounted
as `/test` folder in the container and set as **working directory**. You can disable it with the `-nm` / `--no-mount` option.


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
Builds for macOS are provided (built using [Azure Pipelines](https://dev.azure.com/qtmips/QtMips/_build/latest?definitionId=1&branchName=master)) 
and **can be downloaded from 📦 [QtMips's GitHub Releases](https://github.com/cvut/QtMips/releases)**. 

Once you have QtMips running on your macOS, you have several options how to build and run your code:
* If you have only a basic assembly code, QtMips's [integrated assembler](https://github.com/cvut/QtMips#integrated-assembler) might work for you.
* Or you can build your source codes (MIPS assembler or C) using ...
    * a) ... GCC cross-build toolchain (might be difficult to set up)
    * b) Or you can build the sources inside a pokusew/devbuntu Docker container which contains
            preconfigured gcc for MIPS (mips-* commands). If you have a correctly configured Makefile which uses mips-gcc,
            use can just run `make` inside the container and you do not have to bother with any setup.
            Or if you want and know how to do it, you can use docker exec from Makefile to invoke the mips-elf-gcc in the running container.
