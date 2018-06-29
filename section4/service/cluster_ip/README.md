# Service - ClusterIP

## Create Service for pod

Frist create a pod with label.

```bash
$ more pod_nginx.yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
$ kubectl create -f pod_nginx.yml
pod "nginx" created
$ kubectl create -f service_pod_nginx.yml
service "service-nginx" created
```

check service

```bash
$ kubectl get svc -o wide
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE       SELECTOR
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP   1d        <none>
service-nginx  ClusterIP   10.106.5.165   <none>        80/TCP    42m       app=web
```

## create service for deployment

## check iptables

```bash
sudo iptables -L -v -n -t nat
```
