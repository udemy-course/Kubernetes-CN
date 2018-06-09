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

```bash
sudo kubeadm init --pod-network-cidr 10.244.0.0/16
```

## Reference 

[https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/](https://blog.tekspace.io/setup-kubernetes-cluster-on-centos-7/
)