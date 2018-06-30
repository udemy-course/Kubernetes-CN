# Kubernetes Service ClusterIP

Kubernetes的service有三种类型：ClusterIP，NodePort，LoadBalancer，今天我们来看看ClusterIP。

## 创建Deployment

首先我们先创建一个Deployment，这个Deployment是一个Python实现的HTTP服务，请求这个Web Server的时候，会发回给我们这个server的hostname（如果是container，那就是container的hostname）。

这个Deployment有四个Replica。

```bash
$ more deployment_python_http.yml
apiVersion:  apps/v1
kind: Deployment
metadata:
  name: service-test
spec:
  replicas: 4
  selector:
    matchLabels:
      app: service_test_pod
  template:
    metadata:
      labels:
        app: service_test_pod
    spec:
      containers:
      - name: simple-http
        image: python:2.7
        imagePullPolicy: IfNotPresent
        command: ["/bin/bash"]
        args: ["-c", "echo \"<p>Hello from $(hostname)</p>\" > index.html; python -m SimpleHTTPServer 8080"]
        ports:
        - name: http
          containerPort: 8080
$ kubectl create -f deployment_python_http.yml
deployment.apps "service-test" created
```

创建完我们看到pod是这样的；

```bash
$ kubectl get pod -o wide
NAME                            READY     STATUS    RESTARTS   AGE       IP          NODE
service-test-54b5b4b547-8l9s4   1/1       Running   0          1m        10.36.0.0   ks8-node2
service-test-54b5b4b547-c2t85   1/1       Running   0          1m        10.36.0.1   ks8-node2
service-test-54b5b4b547-nxn9z   1/1       Running   0          1m        10.40.0.1   k8s-node1
service-test-54b5b4b547-vlpff   1/1       Running   0          1m        10.40.0.0   k8s-node1
```

这四个pod IP我们都可以在k8s cluster任意一个节点上访问,每一个都会返回自己的container name。

```bash
$ curl 10.36.0.0:8080
<p>Hello from service-test-54b5b4b547-8l9s4</p>
```

## 创建Service

通过kubectl expose给刚才这个deployment创建一个service，端口绑定为8088.

```bash
kubectl expose deployment service-test --port 8088 --target-port=8080
service "service-test" exposed
```

这样，就给我们生成了一个类型为ClusterIP的service，这个service有一个Cluster IP，其实就一个VIP。

```bash
kubectl get service -o wide
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE       SELECTOR
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP    1d        <none>
service-test   ClusterIP   10.101.90.210   <none>        8088/TCP   11s       app=service_test_pod
```

首先我们可以通过这个Cluster IP加端口8088访问我们的deployment。

```bash
$ for i in `seq 4`; do curl 10.101.90.210:8088; done
<p>Hello from service-test-54b5b4b547-nxn9z</p>
<p>Hello from service-test-54b5b4b547-vlpff</p>
<p>Hello from service-test-54b5b4b547-vlpff</p>
<p>Hello from service-test-54b5b4b547-nxn9z</p>
```

并且我们发现，这个VIP实现了负载均衡，每次返回的hostname不同。

## VIP和负载均衡的实现

为什么我们访问VIP就能访问我们的四个pod，并且还做了负载均衡呢？下面我们就看一下，

其实呢，我们刚才创建这个deployment，service的时候，k8s集群下面的几个部件参与了相关的工作。

- apiserver kubectl命令向apiserver发送创建service的命令，apiserver接收到请求以后将数据存储到etcd中。
- kube-proxy kubernetes的每个节点中都有一个叫做kube-proxy的进程，这个进程负责感知service，pod的变化，并将变化的信息写入本地的iptables中。
- iptables 使用NAT等技术将virtualIP的流量转至endpoint中。

那么IPtable到底是如何转发我们的流量的呢，我们到任意一台k8s节点运行 ``sudo iptables -L -v -n -t nat``

首先找到我们的ClusterIP 10.101.90.210,发现他在一个iptables chain中

```bash
Chain KUBE-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-MARK-MASQ  tcp  --  *      *      !172.100.0.0/16       10.101.90.210        /* default/service-test: cluster IP */ tcp dpt:8088
    0     0 KUBE-SVC-LY73ZDGF4KGO4YFJ  tcp  --  *      *       0.0.0.0/0            10.101.90.210        /* default/service-test: cluster IP */ tcp dpt:8088
```

这个chain类似一个链条，那么访问10.101.90.210:8088的流量到底怎么被转发了呢，我们需要看一下 ``KUBE-SVC-LY73ZDGF4KGO4YFJ`` 这个Chain， 找到这个chain

```bash
Chain KUBE-SVC-LY73ZDGF4KGO4YFJ (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-SEP-YOQWVZZ4NQDNEBVN  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/service-test: */ statistic mode random probability 0.25000000000
    0     0 KUBE-SEP-WHOFXZ2VQXEUUKVO  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/service-test: */ statistic mode random probability 0.33332999982
    0     0 KUBE-SEP-3TBKTCTGJZ27RFOH  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/service-test: */ statistic mode random probability 0.50000000000
    0     0 KUBE-SEP-6LDVTIHDBDOU3D3G  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/service-test: */
```

这个Chain比较有意思，过来的流量它按照随机的概率，分别以0.25000000000， 0.33332999982，0.50000000000的概率，转发到这三个Chain，这三个Chain其实就是我们的pod，那为啥有一个pod不会被转发呢，这个应该是负载均衡的配置，最大几个负载均衡的问题。

我们随便拿出一个


```bash
Chain KUBE-SEP-WHOFXZ2VQXEUUKVO (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-MARK-MASQ  all  --  *      *       10.36.0.1            0.0.0.0/0            /* default/service-test: */
    0     0 DNAT       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/service-test: */ tcp to:10.36.0.1:8080
```

好的，那经过这么一转发，我们的流量就可以转发到正确的pod上了，不知道大家明白没有。