# Problem-Pattern 'exceeded-quota'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.1.0-informational?style=flat)

## Overview
This chart will impose a `ResourceQuota` in the defined `Namespace`. The deployment will be scaled up using a `CronJob` to exceed the given quota.\
By default the first scale up (2->3) will happen at 02:00 UTC, the second (3->4 replicas) at 05:15 UTC - this will exceed the `ResourceQuota`. 
At 05:30 UTC the `Deployment` will be scaled back to 2 replicas.\
These schedules can be adjusted in [jobs.yaml](templates/cronjobs.yaml). 

The `CronJob` and its required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we attempt to scale a deployment up in two steps. Initially we are scaling up by 1 replica which is within the quota's restrictions.\
A few hours after that we try to scale up by 1 again which is beyond the restrictions imposed by the quota. The deployment cannot be scaled up any further and we end up with a kubernetes event that can potentially raise an alert if the workload is monitored.\
To fully utilize this demo you might want to adjust the schedule according to your needs.
```shell
$ kubectl get events -n exceeded-quota
LAST SEEN   TYPE      REASON              OBJECT                                 MESSAGE
5m44s       Normal    ScalingReplicaSet   deployment/exceeded-quota              Scaled up replica set exceeded-quota-6f54cdfd7b to 2
4m38s       Normal    ScalingReplicaSet   deployment/exceeded-quota              Scaled up replica set exceeded-quota-6f54cdfd7b to 3 from 2
4m20s       Normal    ScalingReplicaSet   deployment/exceeded-quota              Scaled up replica set exceeded-quota-6f54cdfd7b to 4 from 3
4m04s       Warning   FailedCreate        replicaset/exceeded-quota-6f54cdfd7b   Error creating: pods "exceeded-quota-6f54cdfd7b-tchhp" is forbidden: exceeded quota: exceeded-quota, requested: requests.memory=100Mi, used: requests.memory=300Mi, limited: requests.memory=310Mi
```

## Installation
Simply run a helm install command from the root of this repository:
```shell
helm upgrade --install exceeded-quota ./exceeded-quota --namespace exceeded-quota --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.\
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore. 
```shell
helm uninstall exceeded-quota --namespace exceeded-quota
kubectl delete namespace exceeded-quota
```
