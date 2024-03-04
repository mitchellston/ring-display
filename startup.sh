$(dirname "$0")/update.sh

# Start docker containers
(cd "$(dirname "$0")/run" && docker-compose build && docker-compose up -d)

# check if cron is installed and install it if not (for debian based systems and mac)
if ! [ -x "$(command -v cron)" ]; then
  if [ -x "$(command -v apt-get)" ]; then
    apt-get update
    apt-get install -y cron
  elif [ -x "$(command -v brew)" ]; then
    brew install cron
  else
    echo 'Error: cron is not installed and we cannot install it' >&2
    (cd "$(dirname "$0")/run" && docker-compose down)
    exit 1
  fi
fi

# Create a cron job that runs every 1 hour to update the modules and restart the container if necessary
(crontab -l 2>/dev/null; echo "0 * * * * $(dirname "$0")/update.sh") | crontab -