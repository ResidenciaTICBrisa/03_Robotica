#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda2' '/'

#!mkdir -p 'push-to-home.d'

<!. ./env-vars.sh > /dev/null; echo "copy-in 'prepare-naoqi-requirements.sh' '/home/${VM_USER}'"

<!. ./env-vars.sh > /dev/null; echo "copy-in 'install-naov6.sh' '/home/${VM_USER}'"
<!. ./env-vars.sh > /dev/null; echo "copy-in 'naov6-qibuild.xml' '/home/${VM_USER}'"

echo ""

echo "Unmounting..."
umount-all

echo "Done"

exit
