### redis运维命令

| 作用                                                      | 命令                 | 备注                                                                 |
|---------------------------------------------------------|--------------------|--------------------------------------------------------------------|
| unlink和del都是删除key，但是unlink不阻塞，对于超过10000的大key，优先使用unlink | unlink key         | https://segmentfault.com/a/1190000041352023                        |
| 查看redis key位于哪个slot，位于哪个node的脚本                         | cluster keyslot $1 | [代码](#code1) :任意指定一个key获取该key所处在哪个node节点_weixin_33890499的博客-CSDN博客 |
|                                                         |                    |                                                                    |
|                                                         |                    |                                                                    |
|                                                         |                    |                                                                    |

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