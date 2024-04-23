# set -euo pipefail

# Function to checkout a git version
version_checkout() {
    (cd "$(dirname "$0")/$2" && git fetch --all)
    # Check if local and origin are the same
    ORIGIN_HASH="$(cd $(dirname "$0")/$2 && git rev-parse $(git branch -r --sort=committerdate | tail -1))"
    LOCK_HASH="$(cd $(dirname "$0")/$2 && git rev-parse HEAD)"
    if [ "$LOCK_HASH" != "$ORIGIN_HASH" ]; then
        echo "Version mismatch for $2"
        (cd "$(dirname "$0")/$2" && git reset --hard && git pull)
        (cd "$(dirname "$0")/$2" && yarn install --ignore-scripts)
    else
        echo "Version match for $2"
    fi
    echo "Origin hash: $ORIGIN_HASH"
    echo "Lock hash: $LOCK_HASH"

    # Check if the version is specified
    if [ ! -z "$1" ]; then
        # Checkout the version and at commit to lock file with the module name
        (cd "$(dirname "$0")/$2" && git checkout $1)
    fi
}

# Load the modules file to get the git urls
while read -r module; do
    # Skip empty lines and comments
    if [ -z "$module" ] || [[ "$module" =~ ^# ]]; then
        continue
    fi
    echo $module
    # Split by space and get the first element
    url=$(echo $module | awk '{print $1}')
    name=$(echo $module | awk '{print $2}')
    version=$(echo $module | awk '{print $3}')
    # if module already exists.
    if [ -d "$(dirname "$0")/$name" ]; then
        # check if the module is the right git repo
        if [ "$(cd $(dirname "$0")/$name && git remote get-url origin)" != "$url" ]; then
            rm -rf "$(dirname "$0")/$name"
            # Clone the module into the modules directory
            (cd "$(dirname "$0")" && git clone $url $name)
            (cd "$(dirname "$0")/$name" && yarn install --ignore-scripts)
            version_checkout $version $name $url
        else
            version_checkout $version $name $url
        fi
    else
        # Clone the module into the modules directory
        (cd "$(dirname "$0")" && git clone $url $name)
        (cd "$(dirname "$0")/$name" && yarn install --ignore-scripts)
        version_checkout $version $name $url
    fi
done <$(dirname "$0")/modules

# Remove all modules that are not in the modules file and not the default modules (/default)
for module in $(ls $(dirname "$0") | grep -v default | grep -v install.sh | grep -v modules); do
    if ! grep -q $module $(dirname "$0")/modules; then
        echo "Removing $module"
        rm -rf $(dirname "$0")/$module
    fi
done
