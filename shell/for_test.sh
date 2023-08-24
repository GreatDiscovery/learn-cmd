#!/bin/bash

#给一个数组，循环执行命令，把所有结果追加到字符串中，用空格分开
arr="1 2 3 4 5"
result=""
for i in $arr;
do
#  result="${result} ${i}"
#  echo "$result"
  echo $i
done

# 根据node_name查node_ip，用于很多node，一次无法全部查出来
result_str=""
node_arr="k8s-sh-redis010144077017 k8s-sh-redis010144076206"
for i in $node_arr;
do
  ip=`kuberedisalish get node k8s-sh-redis010144077017 -owide | tail -n +2| awk '{print $6}'`
  result_str="${result_str} ${ip}"
done
echo "${result_str}"