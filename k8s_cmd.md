### docker+k8s命令合集

| 作用             | 命令                                                                                       | 备注                                          |
|----------------|------------------------------------------------------------------------------------------|---------------------------------------------|
| pod扩缩容         | kubectl scale --current-replicas=0  --replicas=2 deployment/corvus-base-jiayuan-test-1-1 |                                             |
| 查询某个节点上的所有pod  | kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node>          | 驱逐(evicted) Pods &mdash; Cloud Atlas 0.1 文档 |
| jsonpath提取信息   | kuberedis4e get pod  k8redis-jiayun-test-7-7-0-0 -o jsonpath='{ .metadata.labels}'       |                                             |
| 在mac上拉取调试debug | docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh                |                                             |

