set -euo pipefail

export DISPLAY=":$(xauth list | grep $(hostname) | awk '{print $1}' | cut -d ':' -f 2)"

DOCKER_COMPOSE_PATH=""
if ! [ -x "$(command -v docker-compose)" ]; then
    if [ -x "$(command -v docker)" ]; then
        DOCKER_COMPOSE_PATH="$(command -v docker) compose"
    else
        echo 'Error: docker-compose is not installed and we cannot install it' >&2
        exit 1
    fi
else
    DOCKER_COMPOSE_PATH="$(command -v docker-compose)"
fi
# if --dev is passed do not reset and pull the latest changes and check if $1 is bound
if [ "${1-}" = "--dev" ]; then
    git reset --hard
    # pull the latest changes from the git repo and if there are any changes, restart the container (if there are no change git pull returns "Already up to date.")
    if [[ "$(git pull)" != "Already up to date." ]]; then
        (cd "$(dirname "$0")/run" && $DOCKER_COMPOSE_PATH down && $DOCKER_COMPOSE_PATH build && $DOCKER_COMPOSE_PATH up -d)
    fi
fi

# Check if there are any changes in the modules
CHANGES=false
while read -r module; do
    # Skip empty lines and comments
    if [ -z "$module" ] || [[ "$module" =~ ^# ]]; then
        continue
    fi
    # Split by space and get the first element
    url=$(echo $module | awk '{print $1}')
    name=$(echo $module | awk '{print $2}')
    version=$(echo $module | awk '{print $3}')
    # if module already exists.
    if [ -d "$(dirname "$0")/mounts/modules/$name" ]; then
        # check if the module is the right git repo
        if [ "$(cd $(dirname "$0")/mounts/modules/$name && git remote get-url origin)" != "$url" ]; then
            rm -rf "$(dirname "$0")/mounts/modules/$name"
            CHANGES=true
        else
            # Check if there are any changes
            if [ $(cd $(dirname "$0")/mounts/modules/$name && git rev-parse HEAD) != $(cd $(dirname "$0")/mounts/modules/$name && git rev-parse @{u}) ]; then
                CHANGES=true
            fi
        fi
    else
        CHANGES=true
    fi
done <$(dirname "$0")/mounts/modules/modules

# If there are changes, update the modules and restart the container
if [ "$CHANGES" = true ]; then
    echo "There are changes in the modules"
    (cd "$(dirname "$0")/run" && $DOCKER_COMPOSE_PATH down && $DOCKER_COMPOSE_PATH build && $DOCKER_COMPOSE_PATH up -d)
fi
