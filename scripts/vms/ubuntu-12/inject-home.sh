#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda2' '/'

!mkdir -p 'push-to-home.d/tests'

echo "Copying from 'push-to-home.d' to '/home/icpc'"
copy-in 'push-to-home.d/' '/home/icpc'

echo ""

echo "Unmounting..."
umount-all

echo "Done"

exit
