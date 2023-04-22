#!/bin/bash

export ETCDCTL_API=3
export ETCDCTL_CACERT='/etc/kubernetes/pki/etcd/ca.crt'
export ETCDCTL_CERT='/etc/kubernetes/pki/apiserver-etcd-client.crt'
export ETCDCTL_KEY='/etc/kubernetes/pki/apiserver-etcd-client.key'
export ETCDCTL_ENDPOINTS='https://127.0.0.1:2379'