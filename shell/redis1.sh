#!/bin/bash

# manipulate redis pod
source ~/.bashrc
shopt -s expand_aliases
pod_ips=$(kubectl get pod -l label_cluster=k8redis-sns-user-count-new-v1-sh4-1 -owide --no-headers | awk '{print $6}')
for ip in $pod_ips; do
  result=$(redis-cli -h "$ip" -p 6379 role | head -n 2)
  if [[ $result =~ 'master' ]]; then
    echo "$ip"
  fi
done
