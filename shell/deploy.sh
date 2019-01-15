#!/usr/bin/env bash
set -e
mvn -T 16 clean package -Dmaven.test.skip=true
app_name=$(basename $(find -maxdepth 2 -name "$(basename $(pwd))*" -type d))
user="jiaqi1.xu"
home="/home/${user}"
app_dir="${home}/${app_name}"
local_dir="target/${app_name}/${app_name}"
port=1715
servers="dw.cloud4 dw.cloud5"

function deploy(){
    ssh ${user}@${server} -p ${port} "mkdir -p ${app_dir}"
    if [ "$1" = "all" ]; then
        echo "scp all libs"
        ssh ${user}@${server} -p ${port} "rm -rf ${app_dir}/lib"
        scp -P ${port} -r ${local_dir} ${user}@${server}:~
    else
        echo "scp single libs"
        scp -P ${port}  ${local_dir}/lib/${app_name}.jar ${user}@${server}:${app_name}/lib
        scp -P ${port}  ${local_dir}/bin/restart.sh ${user}@${server}:${app_name}/bin
    fi
    # 执行启动脚本
    ssh ${user}@${server} -p ${port} "cd ${app_dir} ; bash  ${app_dir}/bin/restart.sh $1"
}
for server in ${servers}; do
    deploy $1
done