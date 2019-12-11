#!/usr/bin/env bash

###
# Bash script to easily start Docker pokusew/devbuntu image
# see https://github.com/pokusew/devbuntu#usage
###

linux_print_help() {
	echo "Starts Docker devbuntu container and mounts the current working directory as /test."
	echo "Usage: $(basename "$0") [options] [docker options]"
	echo "Options:"
	echo "  -h > print help and exit"
	echo "  -f > do not mount the current working directory"
	echo "  -i <image> -> run this image instead of pokusew/devbuntu:latest"
	echo "  -c <entrypoint> -> run this program instead of bash"
	echo "  -g <your local IP address> -> enable X11 forwarding, see https://github.com/pokusew/devbuntu#gui-applications"
	echo "  -n <name> -> use custom container name"
}

x11_display_ip=""
mount=1
container_name="linux"
image="pokusew/devbuntu:latest"
entrypoint="bash"
docker_options=()

# parse options
#   see print_help() above
#   notes:
#     -h > print help and exit with code 0, all other following flags are ingored
#     unknown option > print help and exit with code 1
while getopts ":hfi:c:g:n:" opt; do
	case $opt in
	f)
		mount=0
		;;
	n)
		container_name="$OPTARG"
		;;
	i)
		image="$OPTARG"
		;;
	c)
		entrypoint="$OPTARG"
		;;
	g)
		x11_display_ip="$OPTARG"
		;;
	h)
		linux_print_help
		exit 0
		;;
	?)
		# forward unrecognzed options to docker run
		# echo "Unrecognzed option -${OPTARG}" >&2
		docker_options+=("-$OPTARG")
		;;
	esac
done

# consider remaining arguments as direct docker options
shift $((OPTIND - 1))
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
