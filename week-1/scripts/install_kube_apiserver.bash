#!/bin/bash

KUBE_APISERVER_VER=$(curl -L -s https://dl.k8s.io/release/stable.txt)
DOWNLOAD_URL=https://dl.k8s.io/release

curl -L ${DOWNLOAD_URL}/${KUBE_APISERVER_VER}/bin/linux/amd64/kube-apiserver -o /root/bin/kube-apiserver

chmod +x /root/bin/kube-apiserver