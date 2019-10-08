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

################################################################################


# according to Qcom this legacy value improves first launch latencies
setprop dalvik.vm.heapminfree 2m

# virtual memory
write /proc/sys/vm/swappiness 100
write /proc/sys/vm/dirty_background_ratio 4
write /proc/sys/vm/dirty_ratio 10
write /proc/sys/vm/dirty_writeback_centisecs 3000

# lmk
write /sys/module/lowmemorykiller/parameters/minfree "18432,23040,27648,32256,36864,46080"

# backlight dimmer
write /sys/module/mdss_fb/parameters/backlight_dimmer 1

# default smp affinity
write f > /proc/irq/default_smp_affinity

# io_sched
write /sys/block/mmcblk0/queue/scheduler cfq
write /sys/block/mmcblk0/queue/iostats 0

# set default schedTune value for foreground/top-app
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/foreground/schedtune.boost 5
write /dev/stune/top-app/schedtune.boost 10
write /dev/stune/top-app/schedtune.prefer_idle 1

# disable thermal bcl hotplug to switch governor
write /sys/module/msm_thermal/core_control/enabled 0
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode disable

# ensure at most one A57 is online when thermal hotplug is disabled
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu5/online 1

# switch to schedfreq
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor "schedutil"

# re-enable thermal and BCL hotplug
write /sys/module/msm_thermal/core_control/enabled 1
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode enable

