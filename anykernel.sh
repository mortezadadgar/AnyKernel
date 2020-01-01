# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Shadow Kernel for the Samsung Tab A 10.1 by @mr.ace
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=gta3xlwifi
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/13500000.dwmmc0/by-name/boot;
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

# end ramdisk changes

write_boot;
## end install
