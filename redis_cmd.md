### redis运维命令

| 作用                                                      | 命令                                                                                                                                                                          | 备注                                                                                                                                                                   |
|---------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unlink和del都是删除key，但是unlink不阻塞，对于超过10000的大key，优先使用unlink | unlink key                                                                                                                                                                  | https://segmentfault.com/a/1190000041352023                                                                                                                          |
| 查看redis key位于哪个slot，位于哪个node的脚本                         | cluster keyslot $1                                                                                                                                                          | [代码](#code1) :任意指定一个key获取该key所处在哪个node节点_weixin_33890499的博客-CSDN博客                                                                                                   |
| 扫描未设置ttl的key的脚本                                         | scan扫描后处理                                                                                                                                                                   | [code2](#code2)                                                                                                                                                      |
| 扫描某个key的个数                                              | scan扫描后处理                                                                                                                                                                   | scan.py                                                                                                                                                              |
| 查看总共有多少个key                                             | dbsize                                                                                                                                                                      |                                                                                                                                                                      |
| 查看客户端来源ip                                               | monitor                                                                                                                                                                     | 会打印ip/命令                                                                                                                                                             |
| 查看客户端ip                                                 | CLIENT LIST                                                                                                                                                                 | 这个只能看到slave和kubeproxy的ip                                                                                                                                             |
| (测试环境)批量删除key                                           | redis-cli keys "user*" \| xargs redis-cli del                                                                                                                               |                                                                                                                                                                      |
| 查看某个key占用多少内存                                           | redis-memory-for-key   -s 10.90.104.168  -p 6379 corr_cache_v5.q= / debug object corr_cache_v5.q= / memory usage corr_cache_v5.q=                                           |                                                                                                                                                                      |
| 查看某类key占用多少内存                                           | rdb -c memory ./1.rdb > redis_memory_report.csv                                                                                                                             | https://segmentfault.com/q/1010000010575235                                                                                                                          |
| 设置redis参数                                               | for ip in `redis-cli -h 10.146.206.239 cluster nodes  \| awk '{print $2}' \| awk -F":" '{print $1}'`; do redis-cli -h $ip config set cluster-slave-validity-factor 0 ; done |                                                                                                                                                                      |
| 如何查看热key                                                | 1. redis-cli --hotkeys 2. redis-faina                                                                                                                                       | [code3](#code3)                                                                                                                                                      |
| 查看客户端ip列表                                               | client list                                                                                                                                                                 |                                                                                                                                                                      |
| redis-cli常用的用法，一些非常实用的功能                                | 1. 插入数据 2. 连续执行命令 3. monitor 4. 连续执行相同命令 5. 连续统计redis信息--stat 6. --bigkeys大key扫描 7. 监视redis的延迟  8. slave模式，可以接收来自master的命令                                                  | [[地址](https://redis.com.cn/topics/rediscli.html)]                                                                                                                    |
| 对每一个pod进行操作                                             |                                                                                                                                                                             | [code4](#code4)                                                                                                                                                      |
| redis把一个节点加入到集群里                                        | sredo_flushall;cluster reset;cluster meet 10.91.26.214 ip port;cluster replicate c89f00bdf0b01b45067f6cb2f3ffb86ee5fc4eee;                                                  |                                                                                                                                                                      |
| client-output-buffer-limit作用                            | client-output-buffer-limit normal 0 0 0;client-output-buffer-limit slave 256mb 64mb 60;client-output-buffer-limit pubsub 8mb 2mb 60                                         | 对于普通客户端来说，限制为0，也就是不限制。因为普通客户端通常采用阻塞式的消息应答模式，何谓阻塞式呢？如：发送请求，等待返回，再发送请求，再等待返回。这种模式下，通常不会导致Redis服务器输出缓冲区的堆积膨胀；对于slave客户端来说，大小限制是256M，持续性限制是当客户端缓冲区大小持续60秒超过64M，则关闭客户端连接。 |
| 集群模式下如何执行集群管理相关的命令                                      | redis-cli --cluster help，比如常见的forget一个节点redis-cli  --cluster call 192.168.8.101:6381   cluster  forget  <xxx_node_id>                                                       | [集群故障恢复思路](#https://blog.itpub.net/30393770/viewspace-2886078/)                                                                                                      |
| 如何使用redis-trib.rb脚本                                     | 改命令本质上还是封装了redis-cli的管理集群的命令，包括创建集群、修复集群、检查集群、迁移slot等                                                                                                                       | [网址](#https://developer.aliyun.com/article/574044)                                                                                                                   |

#### code1

```shell
#获取指定的key在哪个slot上，该key可以是存在的或者不存在的均可。
key_slot=`redis-cli -h 5.5.5.101 -p 29001 -a abc123 -c cluster keyslot $1`

#获取node和slot的分布，输出格式如下，开始的#是注释，并非有效数据
#5.5.5.101|0-5461
#5.5.5.102|5462-10922 
#5.5.5.103|10923-16383
node_slot=`redis-cli -h 5.5.5.101 -p 29001 -a abc123 -c cluster nodes | grep master | awk -F' |:' '{print $2"|"$NF}'`

#判断是否找到对应的slot
find_tag=0
for i in $node_slot
do
    node_ip=`echo $i | awk -F '[|]' '{print $1}'`
    start_slot=`echo $i | awk -F '[|]' '{print $2}' | awk -F '[-]' '{print $1}'`
    end_slot=`echo $i | awk -F '[|]' '{print $2}' | awk -F '[-]' '{print $2}'`
    for((j=$start_slot;j<=$end_slot;j++))
    do
        if [[ $j == $key_slot ]];then
            echo $node_ip
            find_tag=1
        fi
    done
    if [[ $find_tag == 1 ]];then
        #找到后，退出循环，因为slot不会有重复的
        break
    fi
done

```

#### code2

```shell
#!/bin/bash

db_ip=10.212.130.209
db_port=6379
cursor=0
cnt=100
new_cursor=0

redis-cli -h $db_ip -p $db_port -c scan $cursor count $cnt > scan_tmp_result
new_cursor=`sed -n '1p' scan_tmp_result`
sed -n '2,$p' scan_tmp_result > scan_result
cat scan_result |while read line
do
    ttl_result=`redis-cli -h $db_ip -p $db_port  ttl $line`
    if [[ $ttl_result == -1 ]];then
        echo $line >> no_ttl.log
    fi
done


while [ $cursor -ne $new_cursor ]
do
    redis-cli -h $db_ip -p $db_port -c scan $new_cursor count $cnt > scan_tmp_result
    new_cursor=`sed -n '1p' scan_tmp_result`
    sed -n '2,$p' scan_tmp_result > scan_result
    cat scan_result |while read line
    do
        ttl_result=`redis-cli -h $db_ip -p $db_port -c ttl $line`
        if [[ $ttl_result == -1 ]];then
            echo $line >> no_ttl.log
        fi
    done
done
rm -rf scan_tmp_result
rm -rf scan_result
```

#### code3

1. redis-cli hotkeys
2. 如何使用redis-faina？
   下载redis-faina代码，redis-cli -p 6490 MONITOR | head -n <NUMBER OF LINES TO ANALYZE> | ./redis-faina.py [options]
   ，进行分析
3. 使用延迟检测，查看redis延迟
   latency monitoring: [网址](https://redis.io/docs/management/optimization/latency-monitor/)
   CONFIG SET latency-monitor-threshold 100
   CONFIG SET latency-monitor-threshold 0 // turn off
   LATENCY LATEST - returns the latest latency samples for all events.
   LATENCY DOCTOR - replies with a human-readable latency analysis report.

#### code4

```shell
# 先读取所有pod | awk提取某一列信息，这里的NR是行号 | xargs输入参数，-n表示每次输入一个, -I 表示需要替换的字符串， 也就是从标准输入里读取一个参数，替换大括号里的内容
kubectl get pod -l label_cluster=k8redis-xxx -o wide |  awk 'NR>1{print $6}' | xargs -n 1 -I {} redis-cli -h {} config set cluster-node-timeout 30000 &
```