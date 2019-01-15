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
# Copyright:   2018 (c) xujiaqi
# License:     GPL

# If any changes are made to this script, please mail me a copy of the changes
# -------------------------------------------------------------------------------
#Version 1.0
#The first one , can monitor the system memory
#Version 1.1
#Modify the method of the script ,more fast
set -e
# 切换目录
cd $(dirname $(readlink -f "$0"))/..
# 设置环境变量

app_name="${PWD##*/}.jar"
# 日志目录
log_dir="~/.logs/${PWD##*/}"
mkdir -p ${log_dir}

# remote debug
debug_opts="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888"
jvm_opts="-Dlog.logdir=$log_dir \
            -Xlog:startuptime,gc*,task*=debug:file=$log_dir/jvm%p_%t.log:t,u,hn,tg:filesize=1M,filecount=5 \
            -XX:+HeapDumpOnOutOfMemoryError \
            -XX:HeapDumpPath=$log_dir/heapdump-%p.hprof \
            -XX:+UseG1GC \
            -Xms4G -Xmx4G"
# 脚本变量: 启动restart 脚本的参数 1. product 2. dev
profile=$1
if [[ "$profile" = "product" ]]; then
    jvm_opts="-javaagent:/usr/local/src/tingyun/tingyun-agent-java.jar ${jvm_opts}"
fi
# 结束之前的进程
for process in $(jps | grep ${app_name/%-[0-9].[0-9].[0-9].jar/} | awk '{print $1}')
do
  kill -9 ${process}
done
# 判断是否进程已经停止
until [[ $(jps | grep ${app_name/%-[0-9].[0-9].[0-9].jar/} | awk '{print $1}' | wc -l) -eq 0 ]]
do
    sleep 1
done
if [ "$profile" != "" ]; then
    java_args="--spring.profiles.active=${profile}"
fi
# -------------------变动---------------------- #
nohup java ${jvm_opts} -jar ./${app_name} ${java_args} >/dev/null 2>&1 &
echo "True"