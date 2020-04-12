# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Shadow Kernel for the Nexus 5x by @mr.ace
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1

do.cleanuponabort=0
device.name1=bullhead
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/soc.0/f9824900.sdhci/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

# Shadow Banner
ui_print " ____  _   _    _    ____   _____        __"
ui_print "/ ___|| | | |  / \  |  _ \ / _ \ \      / /"
ui_print "\___ \| |_| | / _ \ | | | | | | \ \ /\ / / "
ui_print " ___) |  _  |/ ___ \| |_| | |_| |\ V  V /  "
ui_print "|____/|_| |_/_/   \_\____/ \___/  \_/\_/   "
ui_print "                                           "
ui_print " ____                                      "
ui_print "| __ ) _   _                               "
ui_print "|  _ \| | | |                              "
ui_print "| |_) | |_| |                              "
ui_print "|____/ \__, |                              "
ui_print "       |___/                               "
ui_print " __  __           _    ____ _____          "
ui_print "|  \/  |_ __     / \  / ___| ____|         "
ui_print "| |\/| | '__|   / _ \| |   |  _|           "
ui_print "| |  | | |     / ___ \ |___| |___          "
ui_print "|_|  |_|_|    /_/   \_\____|_____|         "      

## AnyKernel install
dump_boot;


# begin ramdisk changes


# fstab.bullhead
patch_fstab fstab.bullhead /data ext4 options "noatime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic,inode_readahead_blks=8" "noatime,nosuid,nodev,barrier=1,data=writeback,nomblk_io_submit,noauto_da_alloc,errors=panic,inode_readahead_blks=8,commit=300";
patch_fstab fstab.bullhead /data ext4 options "lazytime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic,inode_readahead_blks=8" "noatime,nosuid,nodev,barrier=1,data=writeback,nomblk_io_submit,noauto_da_alloc,errors=panic,inode_readahead_blks=8,commit=300";
patch_fstab fstab.bullhead /data ext4 flags "wait,check,encryptable=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata" "latemount,wait,check,encryptable=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata"
patch_fstab fstab.bullhead /data ext4 flags "wait,check,=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata" "latemount,wait,check,=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata"
patch_fstab fstab.bullhead /cache ext4 options "lazytime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic" "noatime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic"
patch_fstab fstab.bullhead none swap flags "zramsize=533413200" "zramsize=1066826400";

# init.exec.rc
insert_line init.bullhead.rc "init.exec.rc" after "import init.bullhead.ramdump.rc" "import init.exec.rc";

# init.bullhead.rc
replace_section init.bullhead.rc "service atfwd" " " "service #atfwd /system/bin/ATFWD-daemon\n    disabled\n    class #late_start\n    user system\n    group system radio\n";
insert_line init.bullhead.rc "/dev/cpuset/camera-daemon" after "write /proc/sys/vm/page-cluster 0" "\n    mkdir /dev/cpuset/camera-daemon\n    write /dev/cpuset/camera-daemon/cpus 0\n    write /dev/cpuset/camera-daemon/mems 0\n    chown system system /dev/cpuset/camera-daemon\n    chown system system /dev/cpuset/camera-daemon/tasks\n    chmod 0664 /dev/cpuset/camera-daemon/tasks"
insert_line init.bullhead.rc "/dev/cpuset/camera-daemon/cpus" after "write /dev/cpuset/top-app/cpus 0-5" "    write /dev/cpuset/camera-daemon/cpus 0-3"
replace_section init.bullhead.rc "service qcamerasvr" " " "service qcamerasvr /vendor/bin/mm-qcamera-daemon\n    class late_start\n    user camera\n    group camera system inet input graphics\n    writepid /dev/cpuset/camera-daemon/tasks\n"


# end ramdisk changes


write_boot;
## end install

