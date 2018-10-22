# configmap

## create configmap from literal

create configmap ``config-1`` by kubectl CLI

```
$ kubectl create configmap config-1 --from-literal=host=1.1.1.1 --from-literal=port=3000
```

or use yaml file to do the same thing:

```
$ kubectl apply -f configmap_from-literal.yml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-1
  namespace: default
data:
  host: 1.1.1.1
  port: "3000"
```

```
$ kubectl get configmap
NAME       DATA      AGE
config-1   2         5s
```

## create configmap from file

create configmap ``config-2`` from CLI

```
$ kubectl create configmap config-2 --from-file=./nginx.conf
configmap "config-2" created
```

```
$ kubectl get configmap
NAME       DATA      AGE
config-1   2         1m
config-2   1         4s
```

## using configmap by env

```
$ kubectl apply -f configmap_pod_env.yml
```

and go to pod container to check the env

```
$ kubectl exec busybox-1 -it sh
# echo $HOST
1.1.1.1
# echo $PORT
3000
```

## using configmap by volume

```
$ kubectl apply -f configmap_pod_volume.yml
```

and go to pod container to check the config file.

```
$ kubectl exec busybox-2 -it sh
# cd /etc/config
# ls
nginx.conf
```
