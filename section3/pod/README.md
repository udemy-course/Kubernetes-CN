# Pod 

## create pod

create pod through yml file

```bash
$ kubectl create -f nginx_busybox.yml
pod "nginx-busybox" created
```

## get pod list

```bash
$ kubectl get pods
NAME            READY     STATUS    RESTARTS   AGE
nginx-busybox   2/2       Running   0          57s
```

## get pod detail

we use use describe or get pod with `-o` option to display more information about this pod

```bash
$ kubectl describe pod nginx-busybox
```

```bash
$ kubectl get pods nginx-busybox -o wide
NAME            READY     STATUS    RESTARTS   AGE       IP           NODE
nginx-busybox   2/2       Running   0          3m        172.17.0.4   minikube
```

here `-o` we can use `wide`, `json`, `yaml`, etc.

## get into pod(container)

```bash
$ kubectl exec nginx-busybox -it sh
Defaulting container name to nginx.
Use 'kubectl describe pod/nginx-busybox -n default' to see all of the containers in this pod.
#
#
#
```

## delete pod

```bash
$ kubectl delete -f nginx_busybox.yml
pod "nginx-busybox" deleted
```
