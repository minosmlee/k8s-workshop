

## 실습용 Docker 이미지 생성

``` bash
> docker build -t week-1 .
```

## 실습용 디렉토리 생성

``` bash
> mkdir bin cert_k8s
```

## 도커 컨테이너 실행 및 접속

``` bash
> docker run -v $(pwd)/cert_k8s:/etc/kubernetes -v $(pwd)/bin:/root/bin -v $(pwd)/scripts:/scripts -it --rm --add-host="test.kubernetes.local:127.0.0.1" week-1 bash
```


## 인증서 설치

``` bash
> kubeadm init phase certs all --apiserver-cert-extra-sans test.kubernetes.local
```

- `apiserver-advertise-address`
  - SANs 에 추가할 IP 주소
- `apiserver-cert-extra-sans`
  - SANs 에 추가적으로 추가할 DNS 혹은 IP 주소
- `config`
  - https://github.com/kubernetes/kubernetes/blob/master/cmd/kubeadm/app/apis/kubeadm/v1beta3/types.go#L104-L106
- `service-cidr` `service-dns-domain`
  - 대부분의 컨트롤러들은 Service 에 부여된 도메인, 혹은 ClusterIP 를 사용해서 kube-apiserver 와 통신하므로 kube-apiserver SANs 에 해당 내용도 추가될 필요가 있다.


## etcd 설치 및 기동

``` bash
> bash /scripts/install_etcd.bash
> bash /scripts/run_etcd.bash
> source /scripts/etcd_env.bash
```

#### 실행 옵션 설명

- --advertise-client-urls
  - etcd 서버가 사용할 클라이언트 URL을 지정합니다. 이 경우에는 https://127.0.0.1:2379로 지정되어 있습니다.
- --listen-client-urls
  - etcd 서버가 수신 대기할 클라이언트 URL을 지정합니다. 이 경우에는 https://127.0.0.1:2379로 지정되어 있습니다.
- --listen-peer-urls
  - etcd 서버가 수신 대기할 피어 URL을 지정합니다. 이 경우에는 https://127.0.0.1:2380로 지정되어 있습니다.
- --initial-advertise-peer-urls
  - etcd 클러스터의 초기 피어 URL을 지정합니다. 이 경우에는 https://127.0.0.1:2380으로 지정되어 있습니다.
- --initial-cluster
  - etcd 클러스터의 초기 구성을 지정합니다. 이 경우에는 master=https://127.0.0.1:2380으로 지정되어 있습니다.
- --client-cert-auth
  - 클라이언트가 인증서를 사용하여 연결해야 하는지 여부를 지정합니다. 이 경우에는 true로 지정되어 있습니다.
- --trusted-ca-file
  - etcd 서버가 신뢰하는 인증서의 CA 파일을 지정합니다.
- --cert-file
  - etcd 서버의 인증서 파일을 지정합니다.
- --key-file
  - etcd 서버의 키 파일을 지정합니다.
- --peer-client-cert-auth
  - 피어 노드가 인증서를 사용하여 연결해야 하는지 여부를 지정합니다. 이 경우에는 true로 지정되어 있습니다.
- --peer-trusted-ca-file
  - etcd 피어 노드가 신뢰하는 인증서의 CA 파일을 지정합니다.
- --peer-cert-file
  - etcd 피어 노드의 인증서 파일을 지정합니다.
- --peer-key-file
  - etcd 피어 노드의 키 파일을 지정합니다.
- --data-dir
  - etcd 서버의 데이터 디렉토리를 지정합니다.
- --name
  - etcd 서버의 이름을 지정합니다.
- --snapshot-count
  - etcd 서버가 스냅샷을 생성하는 빈도를 지정합니다. 이 경우에는 10000으로 지정되어 있습니다.


#### etcd 설치 확인 및 테스트

``` bash
> etcdctl member list
a874c87fd42044f, started, master, https://127.0.0.1:2380, https://127.0.0.1:2379, false

> etcdctl put foo bar
> etcdctl put foo2 bar2
> etcdctl get --prefix foo
```

## kube-apiserver 설치 및 기동

``` bash
> bash /scripts/istall_kube_apiserver.bash
> bash /scripts/run_kube_apiserver.bash
```

#### 실행 옵션 설명

- --client-ca-file
  - API 서버가 인증하는 클라이언트의 인증서 파일을 지정합니다.
- --tls-cert-file
  - API 서버의 TLS 인증서 파일을 지정합니다.
- --tls-private-key-file
  - API 서버의 TLS 비공개 키 파일을 지정합니다.
- --etcd-cafile
  - API 서버가 etcd 서버와 통신할 때 사용하는 인증서의 CA 파일을 지정합니다.
- --etcd-certfile
  - API 서버가 etcd 서버와 통신할 때 사용하는 클라이언트 인증서 파일을 지정합니다.
- --etcd-keyfile
  - API 서버가 etcd 서버와 통신할 때 사용하는 클라이언트 키 파일을 지정합니다.
- --etcd-servers
  - etcd 서버의 엔드포인트를 지정합니다. 이 경우에는 https://127.0.0.1:2379으로 지정되어 있습니다.
- --kubelet-preferred-address-types
  - kubelet이 사용하는 우선 순위 주소 타입을 지정합니다. 이 경우에는 InternalIP,ExternalIP,Hostname으로 지정되어 있습니다.
- --kubelet-client-certificate
  - API 서버가 kubelet과 통신할 때 사용하는 클라이언트 인증서 파일을 지정합니다.
- --kubelet-client-key
  - API 서버가 kubelet과 통신할 때 사용하는 클라이언트 키 파일을 지정합니다.
- --proxy-client-cert-file
  - API 서버가 프록시와 통신할 때 사용하는 클라이언트 인증서 파일을 지정합니다.
- --proxy-client-key-file
  - API 서버가 프록시와 통신할 때 사용하는 클라이언트 키 파일을 지정합니다.
- --requestheader-allowed-names
  - API 서버가 허용하는 요청 헤더 이름을 지정합니다. 이 경우에는 front-proxy-client로 지정되어 있습니다.
- --requestheader-client-ca-file
  - API 서버가 허용하는 클라이언트 인증서 파일을 지정합니다.
- --requestheader-extra-headers-prefix
  - API 서버가 추가하는 요청 헤더의 접두사를 지정합니다.
- --requestheader-group-headers
  - API 서버가 추가하는 그룹 헤더의 이름을 지정합니다.
- --requestheader-username-headers
  - API 서버가 추가하는 사용자 이름 헤더의 이름을 지정합니다.
- --allow-privileged
  - API 서버에서 특권 컨테이너를 허용할지 여부를 지정합니다.
- --authorization-mode
  - API 서버에서 사용하는 인가 모드를 지정합니다. 이 경우에는 `Node,RBAC`으로 지정되어 있습니다.
- --enable-admission-plugins
  - API 서버에서 활성화할 Admission Controller 플러그인을 지정합니다. 이 경우에는 NodeRestriction으로 지정되어 있습니다.
- --enable-bootstrap-token-auth
  - 부트스트랩 토큰 인증을 사용할지 여부를 지정합니다.
- --secure-port
  - API 서버에서 사용하는 보안 포트를 지정합니다. 이 경우에는 6443으로 지정되어 있습니다.
- --service-account-issuer
  - Kubernetes API 서버에서 발급한 서비스 계정 토큰의 발행자를 지정합니다.
- --service-account-key-file
  - 서비스 계정 토큰의 공개 키 파일을 지정합니다.
- --service-account-signing-key-file
  - 서비스 계정 토큰 서명 키 파일을 지정합니다.
- --service-cluster-ip-range
  - Kubernetes 서비스 클러스터 IP 대역을 지정합니다. 이 경우에는 10.96.0.0/12로 지정되어 있습니다.

#### kube-apiserver 설치 확인 및 테스트

``` bash
> kubeadm init phase kubeconfig admin --control-plane-endpoint test.kubernetes.local
> kubectl version -o yaml
```