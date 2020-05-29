#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

# macro to write pids to system-background cpuset
function writepid_sbg() {
    until [ ! "$1" ]; do
        echo -n $1 > /dev/cpuset/system-background/tasks;
        shift;
    done;
}

################################################################################


# according to Qcom this legacy value improves first launch latencies
setprop dalvik.vm.heapminfree 2m

# scheduler
write /proc/sys/kernel/sched_small_task 20
get-set-forall /sys/devices/system/cpu/*/sched_mostly_idle_nr_run 3
get-set-forall /sys/devices/system/cpu/*/sched_mostly_idle_load 20

# virtual memory
write /proc/sys/vm/swappiness 100
write /proc/sys/vm/dirty_background_ratio 4
write /proc/sys/vm/dirty_ratio 10
write /proc/sys/vm/dirty_writeback_centisecs 3000

# backlight dimmer
write /sys/module/mdss_fb/parameters/backlight_dimmer 1

# default smp affinity
write f > /proc/irq/default_smp_affinity

# io_sched
write /sys/block/mmcblk0/queue/scheduler cfq

# Free memory cache
write /proc/sysrq-trigger s
write /proc/sys/vm/drop_caches 3

# cpu-boost
write /sys/module/cpu_boost/parameters/input_boost_enabled 1
write /sys/module/cpu_boost/parameters/input_boost_ms 98
write /sys/module/cpu_boost/parameters/input_boost_freq "0:1248000"

# enable eis
setprop persist.camera.eis.enable 1
setprop persist.camera.is_type 4

# lmk
write /sys/module/lowmemorykiller/parameters/minfree "18432,23040,27648,32256,49408,63488"

RMT_STORAGE=`pidof rmt_storage`
QMUXD=`pidof qmuxd`
QTI=`pidof qti`
NETMGRD=`pidof netmgrd`
THERMAL_ENGINE=`pidof thermal-engine`
LOC_LAUNCHER=`pidof loc_launcher`
CNSS_DAEMON=`pidof cnss-daemon`
QSEECOMD=`pidof qseecomd`
TIME_DAEMON=`pidof time_daemon`
CND=`pidof cnd`
IMSQMIDAEMON=`pidof imsqmidaemon`
IMSDATADAEMON=`pidof imsdatadaemon`

writepid_sbg $RMT_STORAGE
writepid_sbg $QMUXD
writepid_sbg $QTI
writepid_sbg $NETMGRD
writepid_sbg $THERMAL_ENGINE
writepid_sbg $LOC_LAUNCHER
writepid_sbg $CNSS_DAEMON
writepid_sbg $QSEECOMD
writepid_sbg $TIME_DAEMON
writepid_sbg $CND
writepid_sbg $IMSQMIDAEMON
writepid_sbg $IMSDATADAEMON
