# Ubuntu Docker image for development

Ubuntu with clang, make and valgrind


## Usage

Create the following alias in Bash:  
_Replace `$IP` with you current local IP address or set the IP env var._

```bash
# --mount type=bind,source=`pwd`,destination=/test is equvialent to -v $PWD:/test
alias linux='docker run --rm -ti \
--name valgrind \
--mount type=bind,source=$PWD,destination=/test \
-e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix \
-w /test \
valgrind bash'
```

Then you can run the image using `linux`. The current terminal working directory will be mounted as /test folder in the container and set as working directory.


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
