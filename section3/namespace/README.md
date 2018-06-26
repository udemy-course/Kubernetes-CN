# Namespace

## get all namesapce

```bash
$ kubectl get namespace
NAME          STATUS    AGE
default       Active    1d
kube-public   Active    1d
kube-system   Active    1d
```

## create namespace

```bash
% kubectl create namespace demo
namespace "demo" created
```

## delete namespace

Please makesure there are no resources within this namespace you want to delete.

```bash
$ kubectl delete namespace demo
namespace "demo" deleted
```

## create pod with namespace

```bash
$ more nginx_namespace.yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: demo
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
$ 
```

```bash
$ kubectl create -f nginx_namespace.yml
Error from server (NotFound): error when creating "nginx_namespace.yml": namespaces "demo" not found
$ kubectl create namespace demo
namespace "demo" created
$ kubectl create -f nginx_namespace.yml
pod "nginx" created
```

## get pod with namespace

```bash
$ kubectl get pod --namespace demo
NAME      READY     STATUS    RESTARTS   AGE
nginx     1/1       Running   0          6m
```

## create our own context

```bash
$ kubectl config set-context demo --user=minikube --cluster=minikube --namespace=demo
Context "demo" created.
$ kubectl config get-contexts
CURRENT   NAME       CLUSTER    AUTHINFO   NAMESPACE
          demo       minikub    minikube   demo
*         minikube   minikube   minikube
$ kubectl config use-context demo
Switched to context "demo".
```

Now we create a pod without namespace will in demo namespace by default.
