#!/usr/bin/env bash
user="jiaqi1.xu"
home="/home/${user}"
port=1715
servers="dw.cloud1 dw.cloud2 dw.cloud3 dw.cloud4 dw.cloud5"
for server in ${servers}; do
ssh -tt ${user}@${server} -p ${port} << remotessh
for process in \$(jps | grep -v Jps | awk '{print \$1}')
do
echo \${process}
kill -9 \${process}
done;
exit
remotessh
done