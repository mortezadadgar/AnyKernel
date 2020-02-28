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

# scheduler
write /proc/sys/kernel/sched_small_task 20

# virtual memory
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
