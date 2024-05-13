#!/bin/bash

# 声明关联数组
declare -A my_map

# 设置键值对
my_map["key1"]="value1"
my_map["key2"]="value2"

# 访问值
echo "Value for key1: ${my_map["key1"]}"
echo "Value for key2: ${my_map["key2"]}"

# 遍历关联数组
echo "All key-value pairs:"
for key in "${!my_map[@]}"; do
    echo "Key: $key, Value: ${my_map[$key]}"
done
