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
node_arr="k8s-sh-redis010144064209 k8s-sh-redis010144067088 k8s-sh-redis010144066181 k8s-sh-redis010144079135 k8s-sh-redis010144079068 k8s-sh-redis010144072163 k8s-sh-redis010144066085 k8s-sh-redis010144065116 k8s-sh-redis010144079149 k8s-sh-redis010144070158"
for i in $node_arr;
do
  ip=`kuberedisalish get node $i -owide | tail -n +2| awk '{print $6}'`
  result_str="${result_str} ${ip}"
done
echo "${result_str}"
