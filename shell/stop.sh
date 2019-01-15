#!/usr/bin/env bash

set -e
# 获取bin文件目录
bin_dir=$(dirname $(readlink -f "$0"))
cd ${bin_dir}/..
echo $(pwd)

# 脚本变量
app_name="${PWD##*/}"
app_location="${HOME}/${app_name}/lib/${app_name}.jar"

# 结束之前的进程
for process in `ps ux | grep ${app_location} | grep -v grep | grep -v PPID | awk '{print $2}'`
do
  echo "kill "${process}
  kill ${process}
done

# 判断是否进程已经停止
NUM=0
until [ ${NUM} -eq 1 ]
do
    NUM=$(ps aux | grep ${app_location} | awk '{print $2}' | wc -l)
    echo ${NUM}
    sleep 1
done