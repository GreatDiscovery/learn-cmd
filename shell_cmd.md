### linux常用命令

| 作用                                                                                      | 命令                                                                                                           | 备注                                                                                                                                  |
|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| 用来在文本里统计平均数                                                                             | cat z \| awk '{sum+=$1} END {print "Average = ", sum/NR}'                                                    | 常用的awk使用方法：https://blog.51cto.com/alex/6164853                                                                                      |
| Shell trap是一种在shell脚本中处理异常退出的方法。它可以捕获脚本中的退出信号，并执行相应的操作。例如，您可以使用shell trap来清理脚本中使用的变量或资源 | shell trap                                                                                                   | [代码](#code1)                                                                                                                        |
| 查找大文件                                                                                   | du -h /var --max-depth=1 \| sort -hr \| head -n 10                                                           | du -hs /var/lib/containerd/指定文件查询数据量大小                                                                                              |
| du和df统计信息不一致的问题，查找未被回收的文件                                                               | lsof -s \| \|sort -nr -k7 \|less                                                                             | [参考](https://blog.csdn.net/yiifaa/article/details/78847871)                                                                         |
| 进入docker命名空间内                                                                           | nsenter -m -u -i -n -p -t  16354 bash                                                                        |                                                                                                                                     |
| 常用的dns命令                                                                                | dig/host：解析ip; nslookup domain [dns-server]，指定dns服务器进行查询                                                     |                                                                                                                                     |
| 网络抓包                                                                                    | ngrep port 12345 -n 200 -c 200 -q -t                                              \| grep -B 5  -i mget      |                                                                                                                                     |
| 空格转换行                                                                                   | kuberedis4e get pod  k8redis-jiayun-test-7-7-0-0 -o jsonpath='{ .metadata.labels}'                           | tr " "  "\n"                                                                                                                        |                                                |
| grep按照单词匹配                                                                              | grep -w 1.1.1.1                                                                                              |                                                                                                                                     |
| shell脚本中中允许使用别名                                                                         | source ~/.bashrc;shopt -s expand_aliases                                                                     | [参考](https://cloud.tencent.com/developer/article/1862172)                                                                           |
| 清空一个文件                                                                                  | truncate -s 0 15.rdb                                                                                         |                                                                                                                                     |
| 安装网络工具ifconfig/ip/ping                                                                  | apt-get install net-tools;apt-get install iputils-ping;apt-get install iproute2;apt-get install bridge-utils |                                                                                                                                     |
| ip类命令                                                                                   | ip addr/ip link等操作                                                                                           | [参考](#code2)                                                                                                                        |
| iptables命令                                                                              | iptables -vnL --line，只查看filter表的chain                                                                        | [防火墙原理，朱双印老哥的文档非常清理](https://www.zsythink.net/archives/1199) , [iptables使用](https://wangchujiang.com/linux-command/c/iptables.html) |
| 监控查不出来的，可以看下syslog，或者journalctl -u查系统日志，实在不行，可以看一些机器上的监控组件的采集日志                         | journalctl -u xxx或者dmesg -T                                                                                  |                                                                                                                                     |
| 在一个文件以root用户也无法删除时，需要改变文件的i属性                                                           | lsattr -a ~/.ssh/authorized_keys、chattr -i ~/.ssh/authorized_keys                                            |                                                                                                                                     |

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

#### code2

```shell
$ ip link add dev bridge_home type bridge
$ ip address add 10.0.0.1/24 dev bridge_home

$ ip netns add netns_dustin
$ mkdir -p /etc/netns/netns_dustin
$ echo "nameserver 114.114.114.114" | tee -a /etc/netns/netns_dustin/resolv.conf
$ ip netns exec netns_dustin ip link set dev lo up
$ ip link add dev veth_dustin type veth peer name veth_ns_dustin
$ ip link set dev veth_dustin master bridge_home
$ ip link set dev veth_dustin up
$ ip link set dev veth_ns_dustin netns netns_dustin
$ ip netns exec netns_dustin ip link set dev veth_ns_dustin up
$ ip netns exec netns_dustin ip address add 10.0.0.11/24 dev veth_ns_dustin
```