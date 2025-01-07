# Problem-Pattern 'frequent-restarts-for-workloads'
![ChartVersion](https://img.shields.io/badge/ChartVersion-0.1.0-informational?style=flat)

## Overview
This helm chart installs a cronjob and the RBAC resources necessary to trigger the restart of specified workload.

### Use-Case
The use case for this problem pattern is restarting workloads in the official opentelemetry demo, using an extra sidecar container and liveness probe.

The sidecar container and liveness probe must be added to the workload before this helm chart is effective, this chart only includes the cronjob and necessary RBAC resources needed to trigger the restarts.

The sidecar container is simply an extra container:
```
  - name: restart-container
    image: 'docker.io/library/httpd:latest'
    imagePullPolicy: IfNotPresent
```

The liveness probe is added to the main container, and checks the port from the restart-container is reachable. This leads to a restart of the main container if the httpd process is stopped:
```
...
  livenessProbe:
    failureThreshold: 2
    httpGet:
      port: 80
    initialDelaySeconds: 65
    periodSeconds: 10
```

The command to stop httpd in the container is initiated by a `CronJob` in the [template/cronjob.yaml](template/cronjob.yaml) file. By default the schedule will trigger at 10:00, 10:01 & 10:02 UTC (`0,1,2 10 * * *`). Each trigger of the `CronJob` results in a failed liveness probe. This failure causes the container to restart. The command and schedule can be adjusted in the [values.yaml](values.yaml) file.

All cronjob and RBAC components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

## Installation
Please ammend the value.yaml file with the relevant workload name. In this example we want to restart the `astroshop-recommendationservice` deployment in the `astro-shop-demo` namespace.

values.yaml:
```
faultInjection:
  workloadName: "astroshop-recommendationservice"
  workloadType: "deployment"
  workloadNamespace: "astroshop"
  containerName: "restart-container"
  command: /usr/local/apache2/bin/httpd -k stop
  schedule:
    killProcess: "0,1,2 10 * * *"
```

The following command will install the problem pattern (the liveness probe must be done manually on the specified workload).
```shell
helm upgrade --install frequent-restarts-for-workloads ./frequent-restarts-for-workloads --namespace problem-patterns --create-namespace
```

## Removal
To uninstall:
```shell
helm uninstall frequent-restarts-for-workloads --namespace problem-patterns
```