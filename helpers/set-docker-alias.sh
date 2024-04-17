# if docker-compose does not exist, use a docker-compose alias to docker compose
if ! [ -x "$(command -v docker-compose)" ]; then
    if [ -x "$(command -v docker)" ]; then
        alias docker-compose='docker compose'
    else
        echo 'Error: docker-compose is not installed and we cannot install it' >&2
        exit 1
    fi
fi
