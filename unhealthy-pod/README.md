# Problem-Pattern 'unhealthy-pod'

## Overview

This chart will create a simple `Deployment` with a `webserver` workload in the defined `Namespace`. The created Pod has a mounted `configMap` that includes a key that determines if the readiness probe fails. The liveness probe will always succeed, therefore leaving the Pod in a permanent unhealthy state without restarting it.
A `Cronjob` is created that regularly (default: every minute) changes the key in the `ConfigMap` between the "bad" and the "good" value. This happens by first changing to the "good" value and after `.Values.faultInjection.toggler.sleep` to the "bad" value. The intention is that it seems like someone "just" changed the `ConfigMap` and broke the webserver as a result.

The `CronJob` and the required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case

In this demo we create a pod that is stuck in an unhealthy (not ready) state. This is achieved by a misconfigured value in a mounted `ConfigMap`.\
The `ConfigMap` will always look like it has just been changed to the "wrong" value.
Due to some delay in Kubernetes, the changed value will not be immediately visible in the Pod.

```shell
$ kubectl get pod -n unhealthy-pod
NAME                             READY   STATUS    RESTARTS   AGE
unhealthy-pod-69dddd9cd6-p24rn   0/1     Running   0          3m51s
```

## Installation

Simply run a `helm upgrade` command from the root of this repository:

```shell
helm upgrade --install unhealthy-pod ./unhealthy-pod --namespace unhealthy-pod --create-namespace
```

## Removal

Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.

> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore.

```shell
helm uninstall unhealthy-pod --namespace unhealthy-pod
kubectl delete namespace unhealthy-pod
```
