# Problem-Pattern 'terminating-pod'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.1.0-informational?style=flat)

## Overview
This chart will create a simple `Deployment` with a `nginx` workload in the defined `Namespace`. The `Pods` are created with a non-existent finalizer.\
Immediately after the chart installation a scale-down `Job` will be triggered to create a `Pod` stuck in terminating-state.\
By default the scenario will be reset by 3 `CronJobs`which are running at 20:00, 20:10 & 20:20 UTC.\
The first one removes the `metadata.finalizer` from the stuck pod. The next one scales the deployment up to 3 and finally the third `CronJob` scales back down to 2 to get a pod stuck in terminating state again. 

The `CronJobs` and the required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we create a pod that is stuck in terminating state. This is achieved by a misconfigured finalizer in the pod spec.\
This scenario will be cleaned up and re-created once a day automatically. The terminating pod can potentially raise an alert if the workload is monitored.
```shell
$ kubectl get pods -n terminating-pod
NAME                                    READY   STATUS        RESTARTS   AGE
webserver-deployment-547fddf988-8xhzd   1/1     Running       0          34m
webserver-deployment-547fddf988-rhlmf   1/1     Running       0          34m
webserver-deployment-547fddf988-v84hq   0/1     Terminating   0          33m
```

## Installation
Simply run a `helm upgrade` command from the root of this repository:
```shell
helm upgrade --install terminating-pod ./terminating-pod --namespace terminating-pod --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.\
Furthermore we will need to manually remove the finalizer that causes the terminating pod in the first place. This is achieved by the lengthy `kubectl` command provided below.
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore. 
```shell
helm uninstall terminating-pod --namespace terminating-pod
kubectl get pods -n terminating-pod -l demo=terminating-pod -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 -I {} kubectl patch pod {} -n terminating-pod --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
kubectl delete namespace terminating-pod
```
