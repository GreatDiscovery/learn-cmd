#!/bin/bash

source ~/.bashrc
shopt -s expand_aliases
pods=$(kubectl get pod -l label_cluster=k8redis-search-ads-sug-alish-1 --no-headers | awk '{print $1}')
for pod in $pods; do
  kubectl exec -it "$pod" -c k8redis-search-ads-sug-alish-1 -- bash -c "ls /redis-cluster/dump_k8redis*"
done
