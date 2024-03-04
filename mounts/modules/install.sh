# Function to checkout a git version
version_checkout() {
    # Check if the version is specified
    if [ ! -z "$1" ]; then
        # Checkout the version
        (cd "$(dirname "$0")/$2" && git checkout $1)
    fi
}

# Load the modules file to get the git urls
while read -r module; do
    # Skip empty lines and comments
    if [ -z "$module" ] || [[ "$module" =~ ^# ]] ; then
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
        else
            version_checkout $version $name
            # Pull the latest changes
            (cd "$(dirname "$0")/$name" && git pull)
        fi
    else 
        # Clone the module into the modules directory
        (cd "$(dirname "$0")" && git clone $url $name)
        version_checkout $version $name
    fi
done < $(dirname "$0")/modules

# Remove all modules that are not in the modules file and not the default modules (/default)
for module in $(ls $(dirname "$0") | grep -v default | grep -v install.sh | grep -v modules ); do
    if ! grep -q $module $(dirname "$0")/modules; then
        echo "Removing $module"
        rm -rf $(dirname "$0")/$module
    fi
done

# Install all the dependencies
find "$(dirname "$0")" -iname 'package.json' -not -path '*/node_modules/*' -exec dirname {} \; | while IFS= read -r directory; do
  npm cache clean --force
  echo "Installing dependencies for $directory"
  (cd "$directory" && yarn install --ignore-scripts)
  echo "Done installing dependencies for $directory"
done