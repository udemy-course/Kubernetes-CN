# Replicaset

## create deployment

```bash
$ kubectl apply -f nginx_deployment.yml
deployment.apps "nginx-deployment-test" created
```

describe and get the relicaset event

```bash
$ kubectl describe deployment nginx-deployment-test
Name:                   nginx-deployment-test
Namespace:              default
CreationTimestamp:      Wed, 27 Jun 2018 00:51:10 +0800
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision=1
                        kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"nginx-deployment-test","namespace":"default"},"spec":{"replicas":4,"se...
Selector:               app=nginx
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
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
NewReplicaSet:   nginx-deployment-test-75675f5897 (4/4 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  8h    deployment-controller  Scaled up replica set nginx-deployment-test-75675f5897 to 4
```

## scale and check the replicaset event

```bash
$ kubectl scale --current-replicas=4 --replicas=6 deployment/nginx-deployment-test
deployment.extensions "nginx-deployment-test" scaled
```

```bash
$ kubectl describe deployment nginx-deployment-test
Name:                   nginx-deployment-test
Namespace:              default
CreationTimestamp:      Wed, 27 Jun 2018 00:51:10 +0800
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision=1
                        kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"nginx-deployment-test","namespace":"default"},"spec":{"replicas":4,"se...
Selector:               app=nginx
Replicas:               6 desired | 6 updated | 6 total | 6 available | 0 unavailable
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
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-test-75675f5897 (6/6 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  8h    deployment-controller  Scaled up replica set nginx-deployment-test-75675f5897 to 4
  Normal  ScalingReplicaSet  8h    deployment-controller  Scaled up replica set nginx-deployment-test-75675f5897 to 6
```

## check rollout status

```bash
kubectl rollout status deployment nginx-deployment-test
```

rollout history

```bash
$ kubectl rollout history deployment nginx-deployment-test
deployments "nginx-deployment-test"
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
$ kubectl rollout history deployment nginx-deployment-test --revision 2
deployments "nginx-deployment-test" with revision #2
Pod Template:
  Labels:	app=nginx
	pod-template-hash=703038527
  Containers:
   nginx:
    Image:	nginx:1.9.1
    Port:	80/TCP
    Host Port:	0/TCP
    Environment:	<none>
    Mounts:	<none>
  Volumes:	<none>

```

## rollout undo

```bash
$ kubectl rollout undo deployment nginx-deployment-test
deployment.apps "nginx-deployment-test"
```