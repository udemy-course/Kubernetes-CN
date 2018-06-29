# Setup Three Nodes K8s Cluster with Kubeadm

## Prepare Three Nodes

Create three nodes Centos7 machines on google cloud platform.


Then check all three nodes have installed `kubeadm`, `kubelet` and `kubectl`, and Docker is running.

```bash
➜  kubeadm git:(master) ✗ vagrant status
Current machine states:

k8s-master                running (virtualbox)
k8s-node1                 running (virtualbox)
k8s-node2                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
➜  kubeadm git:(master) ✗ vagrant ssh k8s-master
Last login: Sat Jun  9 14:00:35 2018 from 10.0.2.2
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[vagrant@k8s-master ~]$
[vagrant@k8s-master ~]$
[vagrant@k8s-master ~]$
[vagrant@k8s-master ~]$ which kubeadm
/usr/bin/kubeadm
[vagrant@k8s-master ~]$ which kubelet
/usr/bin/kubelet
[vagrant@k8s-master ~]$ which kubectl
/usr/bin/kubectl
[vagrant@k8s-master ~]$
[vagrant@k8s-master ~]$ sudo docker version
Client:
 Version:         1.13.1
 API version:     1.26
 Package version: docker-1.13.1-63.git94f4240.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      94f4240/1.13.1
 Built:           Fri May 18 15:44:33 2018
 OS/Arch:         linux/amd64

Server:
 Version:         1.13.1
 API version:     1.26 (minimum version 1.12)
 Package version: docker-1.13.1-63.git94f4240.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      94f4240/1.13.1
 Built:           Fri May 18 15:44:33 2018
 OS/Arch:         linux/amd64
 Experimental:    false
[vagrant@k8s-master ~]$
```

## Configuring Kubernetes Master node

### Start kubelet in three nodes

First, removing the `$KUBELET_NETWORK_ARGS` in `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf` in all three nodes and start Kubelet

```bash
sudo vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl enable kubelet && sudo systemctl start kubelet
```

### kubeadm init on master node

```bash
sudo kubeadm init --pod-network-cidr 172.100.0.0/16 --apiserver-advertise-address 192.168.205.120
```

Output

```bash
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token a2dc82.7e936a7ba007f01e 10.0.0.7:6443 --discovery-token-ca-cert-hash sha256:30aca9f9c04f829a13c925224b34c47df0a784e9ba94e132a983658a70ee2914
```

Please follow the output. and after all is done, we can get all pods running

On master node:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

install network addon

```bash
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

Check if all pod are running. then it's OK.

```bash
$ kubectl get pod --all-namespaces
NAMESPACE     NAME                                 READY     STATUS    RESTARTS   AGE
kube-system   etcd-k8s-master                      1/1       Running   0          2h
kube-system   kube-apiserver-k8s-master            1/1       Running   0          2h
kube-system   kube-controller-manager-k8s-master   1/1       Running   0          2h
kube-system   kube-dns-86f4d74b45-jdgct            3/3       Running   0          2h
kube-system   kube-proxy-88kck                     1/1       Running   0          2h
kube-system   kube-scheduler-k8s-master            1/1       Running   0          2h
kube-system   weave-net-t6wzf                      2/2       Running   0          45s
```

## Join worker node

Please use sudo join

```bash
sudo kubeadm join 192.168.205.120:6443 --token buzfuy.8q20f1gleefqjnor --discovery-token-ca-cert-hash sha256:6844c346b1de821d48747e7a3fd6dc6e408ebbc9018553de85f6704949c03b85
```

After that, we can get three nodes ouput on master node

```bash
[vagrant@k8s-master ~]$ kubectl get node
NAME         STATUS    ROLES     AGE       VERSION
k8s-master   Ready     master    5m        v1.10.5
k8s-node1    Ready     <none>    40s       v1.10.5
k8s-node2    Ready     <none>    13s       v1.10.5
```

all pod are ok include flannel

```bash
$ kubectl get pod --all-namespaces
NAMESPACE     NAME                                 READY     STATUS    RESTARTS   AGE
kube-system   etcd-k8s-master                      1/1       Running   0          2h
kube-system   kube-apiserver-k8s-master            1/1       Running   0          2h
kube-system   kube-controller-manager-k8s-master   1/1       Running   0          2h
kube-system   kube-dns-86f4d74b45-jdgct            3/3       Running   0          2h
kube-system   kube-proxy-5jd2z                     1/1       Running   0          1m
kube-system   kube-proxy-88kck                     1/1       Running   0          2h
kube-system   kube-proxy-jpcwg                     1/1       Running   0          34s
kube-system   kube-scheduler-k8s-master            1/1       Running   0          2h
kube-system   weave-net-87n66                      2/2       Running   0          1m
kube-system   weave-net-kkgq6                      2/2       Running   0          34s
kube-system   weave-net-t6wzf                      2/2       Running   0          3m
```


## Reference

[https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/](https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/
)