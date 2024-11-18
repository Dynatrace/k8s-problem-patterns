# Problem-Pattern 'frequent-restarts-for-workloads'
![ChartVersion](https://img.shields.io/badge/ChartVersion-0.1.0-informational?style=flat)

## Overview
This chart can be used to frequently restart a named workload. Some workloads use custom containers which do not always have the necessary binaries to kill their main process. For that reason, we assume the target workload has a livenessprobe, which will terminate the container if a file "/tmp/restart" is present. This can be achieved by adding the following to the manifest:
```
    livenessProbe:
      exec:
        command:
        - test
        - '!'
        - -f
        - /tmp/restart
      failureThreshold: 1
      periodSeconds: 5
      successThreshold: 1
      timeoutSeconds: 1
```

The controller will be restarted by a `CronJob`.\
By default the schedule will trigger at 10:00, 10:01 & 10:02 UTC (`0,1,2 10 * * *`). This can be adjusted in the [values.yaml](values.yaml) file.\
Each trigger of the `CronJob` results in a failed liveness probe. This failure causes the container to restart.

The `CronJob` and its required `ServiceAccount` will be deployed in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we want to force a defined workload to be restarted a few times. This will increase the restart count on the pod as well as potentially raise an alert if the workload is monitored.\
To fully utilize this demo you might want to adjust the schedule according to your needs. 

## Installation
Please ammend the value.yaml file with the relevant workload name. In this example we want to restart the `my-otel-demo-recommendationService` deployment in the `astro-shop-demo` namespace.

values.yaml:
```
faultInjection:
  workloadName: "my-otel-demo-recommendationservice"
  workloadType: "deployment"
  workloadNamespace: "astro-shop-demo"
  namespace: problem-patterns
  schedule:
    killProcess: "0,1,2 10 * * *"
```

The following command will install the problem pattern (the liveness probe must be done manually on the specified workload).
```shell
helm upgrade --install frequent-restarts ./frequent-restarts-for-workloads --values /frequent-restarts-for-workloads/values.yaml --namespace frequent-restarts --create-namespace
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
