FROM ubuntu:22.04

# DEBIAN_FRONTEND 환경 변수를 noninteractive로 설정하여 패키지 설치시 상호작용을 최소화합니다.
ENV DEBIAN_FRONTEND=noninteractive

# 패키지 리스트 업데이트 후 openssl, apt-transport-https, ca-certificates, curl 패키지를 설치합니다.
RUN apt update && apt install -y openssl apt-transport-https ca-certificates curl

# Kubernetes 패키지를 다운로드하는 데 사용되는 GPG 키를 다운로드합니다.
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Kubernetes를 설치하기 위한 저장소를 추가합니다.
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# Kubernetes 클러스터 관리 도구인 kubectl과 kubeadm을 설치합니다.
RUN apt update && apt install -y kubectl kubeadm

# bash-completion을 설치하고, kubectl 자동 완성 기능을 활성화합니다.
RUN apt install -y bash-completion && \
    echo 'source /etc/bash_completion' >> ~/.bashrc && \
    echo 'source <(kubectl completion bash)' >> ~/.bashrc

# /root/bin 디렉토리를 PATH 환경 변수에 추가합니다.
ENV PATH="$PATH:/root/bin"

# etcdctl을 사용하여 etcd에 연결할 때 API 버전을 3으로 설정합니다.
ENV ETCDCTL_API=3

# etcd에 SSL 연결을 설정할 때 사용되는 CA 인증서 파일의 경로를 설정합니다.
ENV ETCDCTL_CACERT='/etc/kubernetes/pki/etcd/ca.crt'

#etcd에 SSL 연결을 설정할 때 사용되는 클라이언트 인증서 파일의 경로를 설정합니다.
ENV ETCDCTL_CERT='/etc/kubernetes/pki/apiserver-etcd-client.crt'

# etcd에 SSL 연결을 설정할 때 사용되는 클라이언트 키 파일의 경로를 설정합니다.
ENV ETCDCTL_KEY='/etc/kubernetes/pki/apiserver-etcd-client.key'

# etcdctl이 연결할 etcd 엔드포인트의 URL을 설정합니다.
ENV ETCDCTL_ENDPOINTS='https://127.0.0.1:2379'

# Kubernetes API 서버에 연결할 때 사용되는 kubeconfig 파일의 경로를 설정합니다.
ENV KUBECONFIG='/etc/kubernetes/admin.conf'

# Set working directory to /root
WORKDIR /root