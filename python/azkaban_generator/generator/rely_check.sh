#!/bin/bash
dependencies=$1
wait_time=$2
ls /opt/python34env/bin/activate
source /opt/python34env/bin/activate
/opt/python34env/bin/python ../generator/rely_check.py ${dependencies} ${wait_time}
