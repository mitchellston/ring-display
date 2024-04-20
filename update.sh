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

git fetch --all
# Check if local and origin are the same
ORIGIN_HASH="$(cd $(dirname "$0") && git rev-parse $(git branch -r --sort=committerdate | tail -1))"
LOCK_HASH="$(cd $(dirname "$0") && git rev-parse HEAD)"
if [ "$LOCK_HASH" != "$ORIGIN_HASH" ]; then
    echo "Version mismatch for ring-display"
    git reset --hard
    git pull
    (cd "$(dirname "$0")/run" && $DOCKER_COMPOSE_PATH down && $DOCKER_COMPOSE_PATH build && $DOCKER_COMPOSE_PATH up -d)
else
    echo "Version match for ring-display"
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
            (cd "$(dirname "$0")/mounts/modules/$name" && git fetch --all)
            # Check if local and origin are the same
            ORIGIN_HASH="$(cd $(dirname "$0")/mounts/modules/$name && git rev-parse $(git branch -r --sort=committerdate | tail -1))"
            LOCK_HASH="$(cd $(dirname "$0")/mounts/modules/$name && git rev-parse HEAD)"
            # Check if there are any changes for the module on the origin
            if [ "$LOCK_HASH" != "$ORIGIN_HASH" ]; then
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
