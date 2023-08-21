#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda1' '/'

#!mkdir -p 'push-to-home.d'

<!. ./env-vars.sh > /dev/null; echo "copy-in 'prepare-naoqi-requirements.sh' '/home/${VM_USER}'"

echo ""

echo "Unmounting..."
umount-all

echo "Done"

exit
