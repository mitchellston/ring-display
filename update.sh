# check if there are any changes on origin
if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
    echo "There are changes on origin"
    git pull
    echo "Pulled the latest changes"
    (cd "$(dirname "$0")/run" && docker-compose down && docker-compose build && docker-compose up -d)
fi

# Check if there are any changes in the modules
CHANGES=false
while read -r module; do
    # Skip empty lines and comments
    if [ -z "$module" ] || [[ "$module" =~ ^# ]] ; then
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
done < $(dirname "$0")/mounts/modules/modules

# If there are changes, update the modules and restart the container
if [ "$CHANGES" = true ]; then
    echo "There are changes in the modules"
    (cd "$(dirname "$0")/mounts/modules" && ./install.sh)
    (cd "$(dirname "$0")/run" && docker-compose down && docker-compose build && docker-compose up -d)
fi