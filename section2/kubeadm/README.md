# Setup Three Nodes K8s Cluster with Kubeadm

## Prepare Three Nodes

Create three nodes Centos7 machines through `Vagrant`

```bash
vagrant up
```

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

First, removing the `$KUBELET_NETWORK_ARGS` in `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`

Start Kubelet

```bash
sudo systemctl enable kubelet && sudo systemctl start kubelet
```

### kubeadm init on master node

```bash
sudo kubeadm init --pod-network-cidr 10.244.0.0/16
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

```bash
kubectl get pods --all-namespaces
```

## Join worker node

Please use sudo join

```bash
sudo kubeadm join 192.168.205.120:6443 --token cg0znx.fm8foahujt843qr1 --discovery-token-ca-cert-hash sha256:ef4a20514c20203f3dc53942fc54867e195d7328e3543d9ee5269176a440bf1c
```

After that, we can get three nodes ouput on master node

```bash
[vagrant@k8s-master ~]$ kubectl get nodes
NAME         STATUS    ROLES     AGE       VERSION
k8s-master   Ready     master    16h       v1.10.4
k8s-node1    Ready     <none>    16h       v1.10.4
k8s-node2    Ready     <none>    16h       v1.10.4
[vagrant@k8s-master ~]$
```

## Reference

[https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/](https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/
)