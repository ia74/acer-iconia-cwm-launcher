#!/bin/bash

is_valid_trigger() {
    local valid=( 1 2 3 4 )
    local value=$1
    for elem in "${valid[@]}"; do
        [[ $value == $elem ]] && return 0
    done
    return 1
}

if is_valid_trigger "$1"; then
    echo "(*) Initializing trigger $1!"
    if [ "$1" = "1" ]; then
        # Trigger 1
        ./platform-tools/fastboot flash /tmp/recovery.zip ./recovery.zip
        ./platform-tools/fastboot flash /tmp/recovery.launcher ./recovery.launcher
        ./platform-tools/fastboot flash /sbin/adbd ./fbrl.trigger
        ./platform-tools/fastboot oem startftm
    fi
    
    if [ "$1" = "2" ]; then
        # Trigger 2
        ./platform-tools/fastboot flash /tmp/recovery.zip ./recovery.zip
        ./platform-tools/fastboot flash /tmp/recovery.launcher ./recovery.launcher
        ./platform-tools/fastboot flash /system/bin/cp ./fbrl.trigger
        ./platform-tools/fastboot oem backup_factory
    fi

    if [ "$1" = "3" ]; then
        # Trigger 3
        ./platform-tools/fastboot flash /tmp/recovery.zip ./recovery.zip
        ./platform-tools/fastboot flash /tmp/recovery.launcher ./recovery.launcher
        ./platform-tools/fastboot flash /sbin/partlink ./fbrl.trigger
        ./platform-tools/fastboot oem stop_partitioning
    fi
    
    if [ "$1" = "4" ]; then
        # Trigger 4
        ./platform-tools/fastboot flash /tmp/recovery.zip ./recovery.zip
        ./platform-tools/fastboot flash /tmp/recovery.launcher ./recovery.launcher
        ./platform-tools/fastboot oem start_partitioning
        ./platform-tools/fastboot flash /system/bin/logcat ./fbrl.trigger
        ./platform-tools/fastboot oem stop_partitioning
    fi
    echo "(!) Trigger complete. CWM should appear on your tablet soon."
    
else
    echo "You need to select a trigger! List: 1, 2, 3, 4"
    echo "Use the command like this: ./trigger 4"
    echo "Trigger Descriptions---"
    echo "1: startftm exploit"
    echo "2: backup_factory exploit"
    echo "3: stop_partitioning exploit"
    echo "4: replace logcat exploit"
fi
exit 1