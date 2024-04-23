# Disable screen blanking
xset s 0
xset -dpms
xset q
# Install the modules
/opt/magic_mirror/modules/install.sh
# Sleep for 30 seconds to allow the modules to install and not interfere with the network of the MagicMirror
sleep 30
# Start the MagicMirror
npm run start
