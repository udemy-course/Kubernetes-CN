# Kops install Kubernetes cluster on Amazon AWS


## 准备工作


### 1. 虚拟机的创建

因为kops只支持在MAC和Linux上使用，所以本课程采用Linux，通过Vagrant创建的CentOS 7 Linux， 这样就能保证不管大家是Windows还是MAC，都有一个统一的实验环境。

使用本文件夹里的vagrantfile进行虚机的创建。然后SSH到虚机里。

```bash
$ vagrant up
$ vagrant status
Current machine states:

kops-host                 running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
$ vagrant ssh kops-host
[vagrant@kops-host ~]$
```

这个虚拟机帮我们安装好了三个工具，一个kops，一个aws命令行，一个kubectl

```bash
[vagrant@kops-host ~]$ kops version
Version 1.8.1 (git-94ef202)
[vagrant@kops-host ~]$ aws --version
aws-cli/1.14.56 Python/2.7.5 Linux/3.10.0-693.11.6.el7.x86_64 botocore/1.9.9
[vagrant@kops-host ~]$
```

### 2. AWS 的准备工作

http://aws.amazon.com 创建账号（需要绑定信用卡）。



### 3. kops start


SSH key

```
ssh-keygen -f .ssh/id_rsa
```

```
kops create cluster --name=k8s.imooc.link --state=s3://kops.k8s.imooc.link --zones=us-west-1a --node-count=2 --node-size=t2.medium --master-size=t2.medium --dns-zone=k8s.imooc.link
```



