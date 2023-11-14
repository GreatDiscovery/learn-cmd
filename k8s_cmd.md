### docker+k8s命令合集

| 作用               | 命令                                                                                       | 备注                                                      |
|------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------|
| pod扩缩容           | kubectl scale --current-replicas=0  --replicas=2 deployment/corvus-base-jiayuan-test-1-1 |                                                         |
| 查询某个节点上的所有pod    | kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node>          | 驱逐(evicted) Pods &mdash; Cloud Atlas 0.1 文档             |
| jsonpath提取信息     | kuberedis4e get pod  k8redis-jiayun-test-7-7-0-0 -o jsonpath='{ .metadata.labels}'       |                                                         |
| 在mac上拉取调试debug   | docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh                |                                                         |
| 查看pod api资源      | kubectl api-resources                                                                    |                                                         |
| 解析kubeconfig证书内容 | [参考](#k8s1)                                                                              | 查看k8s用户具有哪些权限 https://blog.51cto.com/u_15287666/5805955 |
| 从k8s从拷贝文件        | kubectl cp <namespace>/<pod_name>:<container_path> <local_path>                          | 注意不要加前缀 /                                               |
| 一批pod执行某个命令      | file(k8s2.sh)                                                                            |                                                         |

### etcd命令

| 作用           | 命令                                                                                                                                                                               | 备注                                                  |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------|
| etcd连接       | etcdctl  --endpoints 127.0.0.1:2379 --cacert=/run/config/pki/etcd/server.crt --cert=/run/config/pki/etcd/peer.crt --key=/run/config/pki/etcd/peer.key get / --prefix --keys-only | 不同版本客户端的参数可能略有不同，查看help调整参数，参数值可以从docker inspect里获取 |
| 快速启动一个单点etcd | [参考](#etcd1)                                                                                                                                                                     |                                                     |

#### k8s1

```shell
cat ~/.kube/config | python3 -c 'import yaml, sys; print(yaml.safe_load(sys.stdin)["users"][0]["user"]["client-certificate-data"])'|base64 -d| openssl x509 -noout -text
```

#### etcd1

```shell
docker run -d \
  -p 12379:2379 \
  -p 12380:2380 \
  -v /Users/jiayun/Downloads/tmp/data:/etcd-data/member \
  --name exam-etcd \
   quay.io/coreos/etcd:latest \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new
  #--log-level info \
  #--logger zap \
 # --log-outputs stderr
 
 # 执行etcd命令
 etcdctl --endpoints=http://127.0.0.1:2379 set test_key hello_world
```
