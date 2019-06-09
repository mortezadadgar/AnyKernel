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

# disable thermal bcl hotplug to switch governor
write /sys/module/msm_thermal/core_control/enabled 0
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode disable
bcl_hotplug_mask=`get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_mask 0`
bcl_hotplug_soc_mask=`get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask 0`

# some files in /sys/devices/system/cpu are created after the restorecon of
# /sys/. These files receive the default label "sysfs".
restorecon -R /sys/devices/system/cpu

# ensure at most one A57 is online when thermal hotplug is disabled
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu5/online 0

# files in /sys/devices/system/cpu4 are created after enabling cpu4.
# These files receive the default label "sysfs".
# Restorecon again to give new files the correct label.
restorecon -R /sys/devices/system/cpu

# Little cluster
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor interactive
restorecon -R /sys/devices/system/cpu # must restore after interactive
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 0
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 120
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 0
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads "85 600000:45 787200:50 960000:60 1248000:80"
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 20000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 60000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis 80000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack 30000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 0

# big cluster
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor interactive
restorecon -R /sys/devices/system/cpu # must restore after interactive
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay "20000 960000:40000 1248000:20000"
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load 90
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq 960000
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads "90 1248000:95"
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate 40000
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 20000
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis 80000
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack 48000
write /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy 0

# plugin remaining A57s
write /sys/devices/system/cpu/cpu5/online 1

# cpu-boost
write /sys/module/cpu_boost/parameters/input_boost_freq "0:960000 4:0"
write /sys/module/cpu_boost/parameters/input_boost_ms 180

# devfreq
get-set-forall /sys/class/devfreq/qcom,cpubw*/governor bw_hwmon
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent 20
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps 30
get-set-forall /sys/class/devfreq/qcom,mincpubw*/governor cpufreq

# scheduler
write /proc/sys/kernel/sched_small_task 30

# re-enable thermal and BCL hotplug
write /sys/module/msm_thermal/core_control/enabled 1
get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_mask $bcl_hotplug_mask
get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask $bcl_hotplug_soc_mask
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode enable

# virtual memory
write /proc/sys/vm/swappiness 100
write /proc/sys/vm/dirty_background_ratio 4
write /proc/sys/vm/dirty_ratio 10
write /proc/sys/vm/dirty_writeback_centisecs 3000

# lmk
write /sys/module/lowmemorykiller/parameters/minfree "18432,23040,27648,32256,36864,46080"

# backlight dimmer
write /sys/module/mdss_fb/parameters/backlight_dimmer 1
