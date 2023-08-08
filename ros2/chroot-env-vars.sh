#!/bin/bash

# [ -z "${VAR}" ] && echo "unset" || echo "set"
[ -z "${SOURCED_CHROOT_ENV_VARS_SH}" ] || return

readonly DEBIAN_MIRROR='http://deb.debian.org/debian'
readonly DEBIAN_SECURITY_MIRROR='http://security.debian.org/debian-security'
readonly DEBIAN_12_SUITE='bookworm'
readonly DEBIAN_12_SECURITY_SUITE="${DEBIAN_12_SUITE}-security"
readonly DEBIAN_ARM32_KERNEL_PACKAGE='linux-image-armmp'
readonly DEBIAN_ARM64_KERNEL_PACKAGE='linux-image-arm64'

readonly UBUNTU_MAIN_MIRROR='http://archive.ubuntu.com/ubuntu'
readonly UBUNTU_MAIN_SECURITY_MIRROR='http://security.ubuntu.com/ubuntu'
readonly UBUNTU_PORT_MIRROR='http://ports.ubuntu.com/ubuntu-ports'
readonly UBUNTU_PORT_SECURITY_MIRROR="${UBUNTU_PORT_MIRROR}"
readonly UBUNTU_2004_SUITE='focal'
readonly UBUNTU_2004_SECURITY_SUITE="${UBUNTU_2004_SUITE}-security"
readonly UBUNTU_2204_SUITE='jammy'
readonly UBUNTU_2204_SECURITY_SUITE="${UBUNTU_2204_SUITE}-security"
readonly UBUNTU_2004_ARM32_KERNEL_PACKAGE='linux-generic-hwe-20.04'
readonly UBUNTU_2004_ARM64_KERNEL_PACKAGE='linux-generic-hwe-20.04'
readonly UBUNTU_2204_ARM32_KERNEL_PACKAGE='linux-generic-hwe-22.04'
readonly UBUNTU_2204_ARM64_KERNEL_PACKAGE='linux-generic-hwe-22.04'
readonly UBUNTU_ARM32_KERNEL_PACKAGE="${UBUNTU_2204_ARM32_KERNEL_PACKAGE}"
readonly UBUNTU_ARM64_KERNEL_PACKAGE="${UBUNTU_2204_ARM64_KERNEL_PACKAGE}"

readonly DEBOOTSTRAP_MIRROR="${UBUNTU_PORT_MIRROR}"
readonly DEBOOTSTRAP_SECURITY_MIRROR="${UBUNTU_PORT_SECURITY_MIRROR}"
readonly DEBOOTSTRAP_SUITE="${UBUNTU_2204_SUITE}"
readonly DEBOOTSTRAP_SECURITY_SUITE="${UBUNTU_2204_SECURITY_SUITE}"

readonly ARM32_KERNEL_PACKAGE="${UBUNTU_ARM32_KERNEL_PACKAGE}"
readonly ARM64_KERNEL_PACKAGE="${UBUNTU_ARM64_KERNEL_PACKAGE}"

readonly ARM32_ARCH='armhf'
readonly ARM64_ARCH='arm64'

readonly QEMU_USER_STATIC_ARM32_LOCATION='/usr/bin/qemu-arm-static'
readonly QEMU_USER_STATIC_ARM64_LOCATION='/usr/bin/qemu-aarch64-static'

readonly ARM32_CHROOT="${DEBOOTSTRAP_SUITE}-${ARM32_ARCH}"
readonly ARM64_CHROOT="${DEBOOTSTRAP_SUITE}-${ARM64_ARCH}"

readonly ARM32_CHROOT_CACHE="$(pwd)/cache/${DEBOOTSTRAP_SUITE}-${ARM32_ARCH}"
readonly ARM64_CHROOT_CACHE="$(pwd)/cache/${DEBOOTSTRAP_SUITE}-${ARM64_ARCH}"

readonly CHROOTED_USER='softex'
readonly CHROOTED_USER_PASSWORD='softex'

readonly UNSET_WARNING="is unset or empty"

echo "DEBOOTSTRAP_MIRROR=${DEBOOTSTRAP_MIRROR:?${UNSET_WARNING}}"
echo "DEBOOTSTRAP_SUITE=${DEBOOTSTRAP_SUITE:?${UNSET_WARNING}}"

echo "ARM32_CHROOT=${ARM32_CHROOT:?${UNSET_WARNING}}"
echo "ARM64_CHROOT=${ARM64_CHROOT:?${UNSET_WARNING}}"

echo "ARM32_CHROOT_CACHE=${ARM32_CHROOT_CACHE:?${UNSET_WARNING}}"
echo "ARM64_CHROOT_CACHE=${ARM64_CHROOT_CACHE:?${UNSET_WARNING}}"

echo "ARM32_KERNEL_PACKAGE=${ARM32_KERNEL_PACKAGE:?${UNSET_WARNING}}"
echo "ARM64_KERNEL_PACKAGE=${ARM64_KERNEL_PACKAGE:?${UNSET_WARNING}}"

echo "CHROOTED_USER=${CHROOTED_USER:?${UNSET_WARNING}}"
echo "CHROOTED_USER_PASSWORD=${CHROOTED_USER_PASSWORD:?${UNSET_WARNING}}" > /dev/null

if mkdir -p "${ARM32_CHROOT}"; then
	echo "Created '${ARM32_CHROOT}'"
else
	echo "Failed to create '${ARM32_CHROOT}'"
fi
if mkdir -p "${ARM64_CHROOT}"; then
	echo "Created '${ARM64_CHROOT}'"
else
	echo "Failed to create '${ARM64_CHROOT}'"
fi

if mkdir -p "${ARM32_CHROOT_CACHE}"; then
	echo "Created '${ARM32_CHROOT_CACHE}'"
else
	echo "Failed to create '${ARM32_CHROOT_CACHE}'"
fi
if mkdir -p "${ARM64_CHROOT_CACHE}"; then
	echo "Created '${ARM64_CHROOT_CACHE}'"
else
	echo "Failed to create '${ARM64_CHROOT_CACHE}'"
fi

run_debootstrap() {
	local -r CHROOT_LOCATION="$1"
	local -r ARCH="$2"
	local -r CACHE="$3"
	local -r SUITE="$4"
	local -r MIRROR="$5"
	local -r KERNEL_TYPE="$6"

	echo "Bootstraping './${CHROOT_LOCATION}'"

	if debootstrap --arch="${ARCH}" --cache-dir="${CACHE}" "${SUITE}" "./${CHROOT_LOCATION}" "${MIRROR}"; then
		echo "Initial ${KERNEL_TYPE} system installed"
	else
		echo "Failed to install ${KERNEL_TYPE} initial system"
	fi
}

copy_qemu_user_static() {
	local -r QEMU_USER_STATIC_LOCATION="$1"
	local -r QEMU_USER_STATIC_CHROOT_LOCATION="$2"
	local -r KERNEL_TYPE="$3"

	if cp "${QEMU_USER_STATIC_LOCATION}" "${QEMU_USER_STATIC_CHROOT_LOCATION}"; then
		echo "Configured ${KERNEL_TYPE} emulation"
	else
		echo "Failed to configure ${KERNEL_TYPE} emulation"
	fi
}

mount_chroot() {
	local -r CHROOT_LOCATION="$1"

	for i in '/dev/pts' '/proc' '/sys'; do
		if mount --bind "${i}" "./${CHROOT_LOCATION}${i}"; then
			echo "Bind-mounted ${i} to ${CHROOT_LOCATION}${i}"
		else
			echo "Failed to bind mount ${i} to ${CHROOT_LOCATION}${i}"
		fi
	done
}

unmount_chroot() {
	local -r CHROOT_LOCATION="$1"

	for i in '/dev/pts' '/proc' '/sys'; do
		if umount "./${CHROOT_LOCATION}${i}"; then
			echo "Unmounted ${i} from ${CHROOT_LOCATION}${i}"
		else
			echo "Failed to unmount ${i} from ${CHROOT_LOCATION}${i}"
		fi
	done
}

run_on_chroot() {
	local -r args=("$@")

	local -r CHROOT_LOCATION="${args[0]}"
	local -r CHROOT_USERSPEC="${args[1]}"
	local -r CHROOT_COMMAND=("${args[@]:2}")

	mount_chroot "${CHROOT_LOCATION}"

	echo "Running '${CHROOT_COMMAND[*]}'"

	if chroot --userspec="${CHROOT_USERSPEC}" "${CHROOT_LOCATION}" "${CHROOT_COMMAND[@]}"; then
		echo "Executed '${CHROOT_COMMAND[*]}' on '${CHROOT_LOCATION}'"
	else
		echo "Failed to execute '${CHROOT_COMMAND[*]}' on '${CHROOT_LOCATION}'"
	fi

	unmount_chroot "${CHROOT_LOCATION}"
}

fix_permissions() {
	local -r FILE="$1"

	local permission
	local ret
	permission="$(stat --format='%#04a' "${FILE}")"
	ret="$?"

	if (( ret == 0 )); then
		if [[ "${permission}" =~ ..00 ]]; then
			echo "Will fix '${FILE}' permissions"
			if chmod 644 "${FILE}"; then
				echo "Fixed '${FILE}' permissions"
			else
				echo "Failed to fix '${FILE}' permission"
			fi
		else
			echo "File '${FILE}' has good permissions"
		fi
	else
		echo "Could not check the permissions of '${FILE}'"
	fi
}

create_chrooted_user() {
	local -r CHROOT_LOCATION="$1"
	local -r NEW_USER="$2"
	local -r NEW_USER_UID="$3"
	local -r NEW_PASSWORD="$4"

	run_on_chroot "${CHROOT_LOCATION}" 'root' useradd --home-dir "/home/${NEW_USER}" --skel '/etc/skel' --create-home --shell '/bin/bash' --groups 'sudo' --uid "${NEW_USER_UID}" "${NEW_USER}"
	printf "#!/bin/bash\nchpasswd <<< %s:%s" "${NEW_USER}" "${NEW_PASSWORD}" > "${CHROOT_LOCATION}/set-${NEW_USER}-password.sh"
	chmod 744 "${CHROOT_LOCATION}/set-${NEW_USER}-password.sh"
	run_on_chroot "${CHROOT_LOCATION}" 'root' "./set-${NEW_USER}-password.sh"
	rm "${CHROOT_LOCATION}/set-${NEW_USER}-password.sh"
}

add_security_repo() {
	local -r CHROOT_LOCATION="$1"
	local -r SECURITY_MIRROR="$2"
	local -r SECURITY_SUITE="$3"

	printf "deb %s %s main" "${SECURITY_MIRROR}" "${SECURITY_SUITE}" >> "${CHROOT_LOCATION}/etc/apt/sources.list"

	run_on_chroot "${CHROOT_LOCATION}" 'root' apt update
	run_on_chroot "${CHROOT_LOCATION}" 'root' apt full-upgrade --yes
}

readonly SOURCED_CHROOT_ENV_VARS_SH=1
