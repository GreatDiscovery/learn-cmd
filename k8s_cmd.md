### docker+k8s命令合集

| 作用                      | 命令                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 备注                                                                                                                                                                                                      |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| pod扩缩容                  | kubectl scale --current-replicas=0  --replicas=2 deployment/corvus-base-jiayuan-test-1-1                                                                                                                                                                                                                                                                                                                                                                      |                                                                                                                                                                                                         |
| 查询某个节点上的所有pod           | kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node>                                                                                                                                                                                                                                                                                                                                                                               | 驱逐(evicted) Pods &mdash; Cloud Atlas 0.1 文档                                                                                                                                                             |
| jsonpath提取信息            | kuberedis4e get pod  k8redis-jiayun-test-7-7-0-0 -o jsonpath='{ .metadata.labels}'                                                                                                                                                                                                                                                                                                                                                                            |                                                                                                                                                                                                         |
| 在mac上拉取调试debug          | docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh                                                                                                                                                                                                                                                                                                                                                                                     |                                                                                                                                                                                                         |
| 查看pod api资源             | kubectl api-resources                                                                                                                                                                                                                                                                                                                                                                                                                                         |                                                                                                                                                                                                         |
| 解析kubeconfig证书内容        | [参考](#k8s1)                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 查看k8s用户具有哪些权限 https://blog.51cto.com/u_15287666/5805955                                                                                                                                                 |
| 从k8s从拷贝文件               | kubectl cp <namespace>/<pod_name>:<container_path> <local_path>                                                                                                                                                                                                                                                                                                                                                                                               | 注意不要加前缀 /                                                                                                                                                                                               |
| 一批pod执行某个命令             | file(k8s2.sh)                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                         |
| 利用debug命令快速创建debug pod  | 1. 节点上新建一个debug pod :kubectl debug node/mynode -it --image=ubuntu; <br/>2. 创建一个pod可以共享target的命令空间，需要开启shareProcessNamespace,否则会失败，kubectl debug -it ephemeral-demo --image=busybox:1.28 --target=ephemeral-demo  <br/> 3. copy一个pod，但是需要注意资源要足够，否则建不出来，kubectl debug myapp -it --image=ubuntu --share-processes --copy-to=myapp-debug <br/>4. debug一个pod:kubectl debug -it web-548f6458b5-l8tjx --image=busybox:1.28 --target=hello-app,注意target指定的是pod中的一个容器 | [官方文档](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/kubectl-node-debug/); [临时容器](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container-example) |
| 查找有pod的deployment       | kuberedisnew get deployments -o jsonpath='{range .items[?(@.status.replicas > 0)]}{.metadata.name}{"\n"}{end}'                                                                                                                                                                                                                                                                                                                                                |                                                                                                                                                                                                         |
| 通过overlays2工作路径查找docker | docker ps -q\| xargs docker inspect --format '{{.State.Pid}}, {{.Id}}, {{.Name}}, {{.GraphDriver.Data.WorkDir}}' \| grep bff25099a59b0fc8addd06f9223872f2904256f0432b3c3c47b58faef167115f1                                                                                                                                                                                                                                                                    |                                                                                                                                                                                                         |

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
