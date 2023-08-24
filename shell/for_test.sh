#!/bin/bash

#给一个数组，循环执行命令，把所有结果追加到字符串中，用空格分开

arr="1 2 3 4 5"
result=""
for i in $arr;
do
  result="${result} ${i}"
  echo "$result"
done
