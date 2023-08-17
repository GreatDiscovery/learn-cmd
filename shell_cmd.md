### linux常用命令

| 作用                                                                                      | 命令                                                                                  | 备注                                             |
|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|------------------------------------------------|
| 用来在文本里统计平均数                                                                             | cat z \| awk '{sum+=$1} END {print "Average = ", sum/NR}'                           | 常用的awk使用方法：https://blog.51cto.com/alex/6164853 |
| Shell trap是一种在shell脚本中处理异常退出的方法。它可以捕获脚本中的退出信号，并执行相应的操作。例如，您可以使用shell trap来清理脚本中使用的变量或资源 | shell trap                                                                          | [代码](#code1)                                   |
| 查找大文件                                                                                   | du -h /var --max-depth=1 \| sort -hr \| head -n 10                                  |                                                |
| 进入docker命名空间内                                                                           | nsenter -m -u -i -n -p -t  16354 bash                                               |                                                |
| 常用的dns命令                                                                                | dig/host：解析ip; nslookup domain [dns-server]，指定dns服务器进行查询                            |                                                |
| 网络抓包                                                                                    | ngrep port 12345 -n 200 -c 200 -q -t                                              \| grep -B 5  -i mget                             |                                                |
| 空格转换行                                                                                   | kuberedis4e get pod  k8redis-jiayun-test-7-7-0-0 -o jsonpath='{ .metadata.labels}'  | tr " "  "\n"                                   |                                                |
|                                                                                         |                                                                                     |                                                |

#### code1

```shell
# 定义退出信号
trap 'exit cleanup' INT QUIT TERM

#执行脚本
echo "This is a shell script."

#清理操作
function cleanup {
echo "Cleaning up..."
}
```