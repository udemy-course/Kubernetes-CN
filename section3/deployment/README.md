# Deployment

## Create a Deployment

```bash
$ kubectl create -f nginx_depolyment.yml
deployment.apps "nginx-deployment" created
```

## Get deployment

Get deployment and pod information

```bash
$ kubectl get deployment
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2         2         2            2           12s
$ kubectl get deployment -o wide
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE       CONTAINERS   IMAGES        SELECTOR
nginx-deployment   2         2         2            2           40s       nginx        nginx:1.7.9   app=nginx
$ kubectl get pod -l app=nginx
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-75675f5897-bwz4j   1/1       Running   0          1m
nginx-deployment-75675f5897-z626w   1/1       Running   0          1m
```

also can use describe

```bash
$ kubectl describe deployment nginx-deployment
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Tue, 26 Jun 2018 23:15:17 +0800
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision=1
Selector:               app=nginx
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:1.7.9
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-75675f5897 (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  3m    deployment-controller  Scaled up replica set nginx-deployment-75675f5897 to 2
```

## keep desired pod state

```bash
$ kubectl get pod -l app=nginx
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-75675f5897-bwz4j   1/1       Running   0          3m
nginx-deployment-75675f5897-z626w   1/1       Running   0          3m
$ kubectl delete pod nginx-deployment-75675f5897-bwz4j
pod "nginx-deployment-75675f5897-bwz4j" deleted
$ kubectl get pod -l app=nginx
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-75675f5897-6fdvh   1/1       Running   0          <invalid>
nginx-deployment-75675f5897-z626w   1/1       Running   0          4m
$ kubectl get pod -l app=nginx
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-75675f5897-6fdvh   1/1       Running   0          0s
nginx-deployment-75675f5897-z626w   1/1       Running   0          4m
```

## Updating the deployment

```yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.8 # Update the version of nginx from 1.7.9 to 1.8
        ports:
        - containerPort: 80
```

```bash
$ kubectl apply -f nginx_depolyment_update.yml
depolyment "nginx-deployment" updated
```

## Scaling the application by increasing the replica count

```bash
$ kubectl apply -f nginx_depolyment_scale.yml
depolyment "nginx-deployment" updated
```

```bash
$ kubectl get pods -l app=nginx
NAME                               READY     STATUS    RESTARTS   AGE
nginx-deployment-148880595-4zdqq   1/1       Running   0          25s
nginx-deployment-148880595-6zgi1   1/1       Running   0          25s
nginx-deployment-148880595-fxcez   1/1       Running   0          2m
nginx-deployment-148880595-rwovn   1/1       Running   0          2m
```

## Delete a Deployment

```bash
$ kubectl delete deployment nginx-deployment
depolyment "nginx-deployment" deleted
```
