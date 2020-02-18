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