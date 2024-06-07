# Problem-Pattern 'pending-pod'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.1.0-informational?style=flat)

## Overview
This chart will install a `Deployment` that results in a pending-pod situation by scaling beyond available resources. Requests and limits can be customized in [values.yaml](values.yaml). A `CronJob` takes care of scaling the deployment up and down accordingly.\
By default the scale down will happen daily at 04:00, 12:00 & 20:00 UTC (`0 4,12,20 * * *`). The scale up will happen daily at 00:00, 08:00 & 16:00 UTC (`0 0,8,16 * * *`).\
These schedules can be adjusted in the [values.yaml](values.yaml) file.

The `CronJob` and its required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

In order to make this a valid demo, you will need to ensure the requests/replicas are suitable for your node size.
>**Example:**\
>A node with *2 CPUs* will be able to run 4 workloads requesting *450m* each (=*1800m* total) but will not have enough resources available to spawn a 5th replica.\
>**Keep in mind** there's most likely some overhead of already running workloads which should also be taken into account.

### Use-Case
In this demo we are creating a pending-pod scenario by scaling our workload beyond the node's available resources. The scaling is scheduled to happen 3 times a day with 4 hours in between scale up and scale down.\
With this we can ensure a re-occuring issue which can be used to potentially raise an alert if the workload is monitored.
```shell
$ kubectl get pods -n pending-pod
NAME                            READY   STATUS    RESTARTS   AGE
mail-service-755455c999-2d4g4   1/1     Running   0          8h
mail-service-755455c999-7m884   1/1     Running   0          8h
mail-service-755455c999-dnbtz   0/1     Pending   0          12m44s
mail-service-755455c999-h2nf7   1/1     Running   0          8h
mail-service-755455c999-rw6zn   1/1     Running   0          8h
```

## Installation
Simply run a `helm upgrade` command from the root of this repository:
```shell
helm upgrade --install pending-pod ./pending-pod --namespace pending-pod --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore.
```shell
helm uninstall pending-pod --namespace pending-pod
kubectl delete namespace pending-pod
```
