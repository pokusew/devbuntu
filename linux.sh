#!/usr/bin/env bash

###
# Bash script to easily start Docker pokusew/devbuntu image
# see https://github.com/pokusew/devbuntu#usage
###

# ASCII color sequences
# credits: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# see also: https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
# to get all 256 colors:
#   for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done
red=$(tput setaf 1)
reset=$(tput sgr0)

print_help() {
	name=$(basename "$0")
	echo "Starts Docker devbuntu container and mounts the current working directory as /test."
	echo "Usage: $name [options] [-- docker options]"
	echo "Options:"
	echo "  -h, --help > print help and exit"
	echo "  -v, --version > print version and exit"
	echo "  -n, --name <name> -> use custom container name"
	echo "  -nm, --no-mount > do not mount the current working directory"
	echo "  -i, --image <image> -> run this image instead of pokusew/devbuntu:latest"
	echo "  -c, --entrypoint <entrypoint> -> run this program instead of bash"
	echo "  -x, --x11-ip <your local IP address> -> enable X11 forwarding, see https://github.com/pokusew/devbuntu#gui-applications"
	echo "Examples:"
	echo "  $name -n test -- --security-opt seccomp=unconfined -p 0.0.0.0:8080:8080/tcp -p 127.0.0.1:12345:12345/tcp"
	echo "   > runs container with name test with custom docker run options (all options after \"--\" are passed directly to the docker run)"
}

container_name="linux"
mount=1
image="pokusew/devbuntu:latest"
entrypoint="bash"
x11_display_ip=""
docker_options=()

# parse CLI options:
# - adapted "Getting options" from https://devhints.io/bash
# - previously getopts was used, but it does not allow much customization
# - all options after "--" are passed directly to the docker run
# - -h, --help > print help and exit with code 0, all other following flags are ingored
while [[ $1 =~ ^- && ! "$1" == "--" ]]; do

	case $1 in
	-h | --help)
		print_help
		exit 0
		;;
	-v | --version)
		echo "linux devbuntu runner v0.0.1"
		echo "homepage: https://github.com/pokusew/devbuntu"
		exit 0
		;;
	-n | --name)
		shift
		container_name="$1"
		;;
	-nm | --no-mount)
		mount=0
		;;
	-i | --image)
		shift
		image="$1"
		;;
	-c | --entrypoint)
		shift
		entrypoint="$1"
		;;
	-x | --x11-ip)
		shift
		x11_display_ip="$1"
		;;
	*)
		echo "${red}Unknown option ${1}${reset}"
		print_help
		exit 1
		;;
	esac

	# move to the next option
	shift

done
# skip options divider
if [[ $1 == "--" ]]; then shift; fi
# consider remaining arguments as direct docker options
if [ $# -gt 0 ]; then
	docker_options+=("$@")
fi

docker_run_args=(
	"--rm"
	"-ti"
)

docker_run_args+=("--name")
docker_run_args+=("$container_name")

docker_run_args+=("-e")
docker_run_args+=("PS_NAME=${container_name^}") # uppercase the first letter

if [[ $mount -eq 1 ]]; then
	# --mount type=bind,source=$PWD,destination=/test is equivalent to -v $PWD:/test
	docker_run_args+=("--mount")
	docker_run_args+=("type=bind,source=$PWD,destination=/test")
	docker_run_args+=("-w")
	docker_run_args+=("/test")
fi

if [[ -n $x11_display_ip ]]; then
	docker_run_args+=("-e")
	docker_run_args+=("DISPLAY=$x11_display_ip:0")
	docker_run_args+=("-v")
	docker_run_args+=("/tmp/.X11-unix:/tmp/.X11-unix")
fi

docker_options_str=""
if [ ${#docker_options} -gt 0 ]; then
	docker_options_str=" ${docker_options[*]}"
fi

echo "Running: docker run ${docker_run_args[*]}${docker_options_str} $image $entrypoint"

# see https://docs.docker.com/engine/reference/run/
docker run "${docker_run_args[@]}" "${docker_options[@]}" "$image" "$entrypoint"
