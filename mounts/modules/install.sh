# Load the modules file to get the git urls
while read -r module; do
    echo $module
    # Split by space and get the first element
    url=$(echo $module | awk '{print $1}')
    name=$(echo $module | awk '{print $2}')
    # if module already exists.
    if [ -d "$(dirname "$0")/$name" ]; then
        # check if the module is the right git repo
        if [ "$(cd $(dirname "$0")/$name && git remote get-url origin)" != "$url" ]; then
            rm -rf "$(dirname "$0")/$name"
        else
            # Pull the latest changes
            (cd "$(dirname "$0")/$name" && git pull)
        fi
    else 
        # Clone the module into the modules directory
        (cd "$(dirname "$0")" && git clone $module)
    fi
done < $(dirname "$0")/modules

# Remove all modules that are not in the modules file and not the default modules (/default)
for module in $(ls $(dirname "$0") | grep -v default | grep -v install.sh | grep -v modules ); do
    if ! grep -q $module $(dirname "$0")/modules; then
        echo "Removing $module"
        rm -rf $(dirname "$0")/$module
    fi
done