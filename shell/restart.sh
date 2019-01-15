#!/bin/bash
# -------------------------------------------------------------------------------
# Filename:    restart.sh
# Revision:    1.0
# Date:        2018-5-11
# Author:      tommy
# Email:       jiaqi7282545@gmail.com
# Website:     https://yibanguaiqi.github.io/
# Description: script to restart the spring boot app
# -------------------------------------------------------------------------------
# Copyright:   2009 (c) xujiaqi
# License:     GPL

# If any changes are made to this script, please mail me a copy of the changes
# -------------------------------------------------------------------------------
#Version 1.0
#The first one
set -e
# 切换目录
cd $(dirname $(readlink -f "$0"))/..
# 设置环境变量
source /etc/profile
if [[ ! -n ${JAVA_HOME} ]]; then
  echo "JAVA_HOME IS NULL"
  exit 1
fi

# 通过DNS服务器解析域名
for ((COUNTER=0; COUNTER<10; ++COUNTER))
do
    gatewaytwo=$(/sbin/route | grep default | awk '{print $2}' | awk -F '.' '{print $1"."$2}')
    hostip=$(/sbin/ifconfig | grep "inet addr" | grep ${gatewaytwo}| awk '{print $2}' | awk -F ':' '{print $2}')
    if [[ ${COUNTER} -eq 10 ]]; then
        echo "cannot get hostname by dns server"
        exit 1
    elif [[ ${hostip} =~ ^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]]; then
        tmp=$(host ${hostip} | awk '{print $5}')
        hostname=${tmp%?}
        break
    fi
done
# 脚本变量: 启动restart 脚本的参数 1. product 2. dev
profile=$1
if ${profile} = "product"; then
    monitor="-javaagent:/usr/local/src/tingyun/tingyun-agent-java.jar"
fi
app_name="${PWD##*/}.jar"
# 分配内存
ram="-Xmx1G -Xmx1G"
# 日志目录
log_dir="logs"
# remote debug
debug_opts="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888"
jvm_opts="-server -Xloggc:$log_dir/gc.logs -Dlog.logdir=$log_dir \
-XX:-PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+UseConcMarkSweepGC \
-XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:+HeapDumpOnOutOfMemoryError"

# 结束之前的进程
for process in $(jps | grep ${app_name/%-[0-9].[0-9].[0-9].jar/} | awk '{print $1}')
do
  kill ${process}
done
# 判断是否进程已经停止
until [[ $(jps | grep ${app_name/%-[0-9].[0-9].[0-9].jar/} | awk '{print $1}' | wc -l) -eq 0 ]]
do
    sleep 1
done
# -------------------变动---------------------- #
java_args="--hostname=${hostname}"
nohup java ${monitor} ${jvm_opts} -jar ./${app_name} ${java_args} >/dev/null 2>&1 &
echo "True"