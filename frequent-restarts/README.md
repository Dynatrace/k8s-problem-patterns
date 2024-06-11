# Problem-Pattern 'frequent-restarts'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.2.0-informational?style=flat)

## Overview
This chart will deploy `ingress-nginx` in the defined`Namespace`. The controller will be restarted by a `CronJob`.\
By default the pkill will happen at 10:00, 10:01 & 10:02 UTC (`0,1,2 10 * * *`). This can be adjusted in the [values.yaml](values.yaml) file.\
Each trigger of the `CronJob` results in a failed readiness probe. This failure causes the container to restart.

The `CronJob` and its required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we want to force a pod to be restarted a few times. This will increase the restart count on the pod as well as potentially raise an alert if the workload is monitored.\
To fully utilize this demo you might want to adjust the schedule according to your needs. 
```shell
$ kubectl get pod -l app.kubernetes.io/name=ingress-nginx -n frequent-restarts
NAME                                                          READY   STATUS    RESTARTS       AGE
frequent-restarts-ingress-nginx-controller-748ff659db-gmmhj   1/1     Running   3 (11h ago)   19h
```

## Installation
After building the dependency for `ingress-nginx` simply run a `helm upgrade` command from the root of this repository:
```shell
helm dependency build ./frequent-restarts
helm upgrade --install --dependency-update frequent-restarts ./frequent-restarts --namespace frequent-restarts --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore. 
```shell
helm uninstall frequent-restarts --namespace frequent-restarts
kubectl delete namespace frequent-restarts
```

## Dependency
We are using the `ingress-nginx` helm chart as a dependency for this deployment. No special configurations are in place or needed for this demo.\
Please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/) for configurations that you might need. 

- [GitHub - kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx)