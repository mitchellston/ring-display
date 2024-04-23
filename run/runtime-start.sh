# Disable screen blanking
xset s 0
xset -dpms
xset q
# Install the modules
/opt/magic_mirror/modules/install.sh
# Sleep for 10 seconds to allow the modules to install
sleep 10
# Start the MagicMirror
npm run start
