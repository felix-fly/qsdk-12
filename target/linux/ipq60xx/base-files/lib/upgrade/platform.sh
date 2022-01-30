. /lib/functions.sh
. /lib/upgrade/common.sh

RAMFS_COPY_BIN="/usr/bin/dumpimage /bin/mktemp /usr/sbin/mkfs.ubifs
	/usr/sbin/ubiattach /usr/sbin/ubidetach /usr/sbin/ubiformat /usr/sbin/ubimkvol
	/usr/sbin/ubiupdatevol /usr/bin/basename /bin/rm /usr/bin/find
	/usr/sbin/mkfs.ext4"

print_sections() {
	local img=$1
	dumpimage -l ${img} | awk '/^ Image.*(.*)/ { print gensub(/Image .* \((.*)\)/,"\\1", $0) }'
}

platform_check_image() {
	return 0;
}

platform_do_upgrade() {
	local board=$(board_name)

	# verify some things exist before erasing
	if [ ! -e $1 ]; then
		echo "Error: Can't find $1 after switching to ramfs, aborting upgrade!"
		reboot
	fi

	for sec in $(print_sections $1); do
		if [ ! -e /tmp/${sec}.bin ]; then
			echo "Error: Cant' find ${sec} after switching to ramfs, aborting upgrade!"
			reboot
		fi
	done

	case "$board" in
	qcom,ipq6018-ap-cp01-c1 |\
	qcom,ipq6018-ap-cp01-c2 |\
	qcom,ipq6018-ap-cp01-c3 |\
	qcom,ipq6018-ap-cp01-c4 |\
	qcom,ipq6018-ap-cp01-c5 |\
	qcom,ipq6018-ap-cp02-c1 |\
	qcom,ipq6018-db-cp01 |\
	qcom,ipq6018-db-cp02)
		nand_do_upgrade "$1"
		;;
	qcom,ipq6018-ap-cp03-c1)
		CI_ROOTPART="rootfs"
		nand_do_upgrade "$1"
		;;
	esac

	echo "Upgrade failed!"
	return 1;
}

