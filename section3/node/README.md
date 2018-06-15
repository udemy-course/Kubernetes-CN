# Node

## Get all Nodes

list

```bash
kubectl get node
```

## get node information as json/yaml format

```bash
kubectl get node -o yaml
kubectl get node -o json
kubectl get node -o wide
```

## describe a node

```bash
kubectl describe node xxxxxx
```

## check node labels

```bash
kubectl get node --show-labels
NAME           STATUS                     ROLES     AGE       VERSION   LABELS
172.17.8.101   Ready,SchedulingDisabled   <none>    16h       v1.10.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=172.17.8.101
172.17.8.102   Ready                      <none>    16h       v1.10.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=172.17.8.102
172.17.8.103   Ready                      <none>    16h       v1.10.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=172.17.8.103
```

## set/delete label for node

add a label called `env` and with value `test`

```bash
kubectl label node 172.17.8.103 env=test
```

use `-` to delete a node label called `env`

```bash
kubectl label node 172.17.8.103 env-
```

## overwrite label

```bash
kubectl label node 172.17.8.101 kubernetes.io/hostname=c1 --overwrite
```

## Set Role

```bah
kubectl label node 172.17.8.101 node-role.kubernetes.io/master=
kubectl label node 172.17.8.102 node-role.kubernetes.io/worker=
kubectl label node 172.17.8.103 node-role.kubernetes.io/worker=
```
