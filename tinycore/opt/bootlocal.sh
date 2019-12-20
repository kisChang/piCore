#!/bin/sh

# Start serial terminal
#/usr/sbin/startserialtty &
/opt/startserialtty &

# Set CPU frequency governor to ondemand (default is performance)
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Load modules
/sbin/modprobe i2c-dev

# ------ Put other system startup commands below this line
# conn wifi
/usr/local/bin/wifi.sh -a 2>&1 > /tmp/wifi.log

#init JDK
JAVA_HOME=/home/tc/jre
PATH=$JAVA_HOME/bin:$PATH

/home/tc/start-run.sh
