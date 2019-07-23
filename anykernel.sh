# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Shadow Kernel for the Nexus 5x by @mr.ace
do.devicecheck=1
do.modules=0
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


## AnyKernel install
dump_boot;


# begin ramdisk changes

# fstab.bullhead
insert_line fstab.bullhead "data           f2fs" after "data           ext4" "/dev/block/platform/soc.0/f9824900.sdhci/by-name/userdata     /data           f2fs    nosuid,nodev,noatime,discard,fsync_mode=nobarrier,background_gc=off wait,check,quota,formattable,encryptable=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata";
patch_fstab fstab.bullhead none swap flags "zramsize=533413200" "zramsize=1066826400";

# init.exec.rc
insert_line init.bullhead.rc "init.exec.rc" after "import init.bullhead.ramdump.rc" "import init.exec.rc";

# end ramdisk changes


write_boot;
## end install

