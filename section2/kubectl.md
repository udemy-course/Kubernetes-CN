# Kubectl

## Auto Completion

For example, zsh

```bash
source <(kubectl completion zsh)
```

more information, please refer

```bash
kubectl completion -h
```

## Context

Get current context.

```bash
 kubectl config get-contexts
CURRENT   NAME             CLUSTER           AUTHINFO        NAMESPACE
          minikube         minikube          minikube
*         vagrant-coreos   default-cluster   default-admin
```

change context

```bash
kubectl config set current-context <context-name>
```
