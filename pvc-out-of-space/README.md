# Problem-Pattern 'pvc-out-of-space'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.1.0-informational?style=flat)

## Overview
This chart will deploy `zot` (container registry) in the defined `Namespace`. Using `kaniko` in a `CronJob` we will push an image every 15 minutes until the `PersistentVolume` is full.\
Every evening the images are deleted by another `CronJob` which frees up the space on the `PersistentVolume`.

We are deploying multiple resources (`CronJobs`, `ServiceAccount`, `Secrets`,`ConfigMap`) in the default "problem-patterns" `Namespace` (unless updated in the [values.yaml](values.yaml)).\
All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we fill up a volume by constantly (by default: every 15 minutes) pushing images to the deployed container registry. Eventually the volume is full and the jobs that push the images will start to fail.\
This can potentially raise an alert if the workload is monitored.

Unfortunately the used capacity cannot be checked using something as simple as `kubectl`.\
The ability to check the actual usage might be limited depending on the storage provisioner. For cloud-based storage solutions (e.g., AWS EBS, GCP PD), you might need to use the cloud provider's monitoring tools to get detailed usage statistics.\
If the above methods are not providing the necessary details, consider integrating a monitoring tool which can be configured to gather detailed storage metrics, including `PVC` usage.

## Installation
After building the dependency for `zot` simply run a `helm upgrade` command from the root of this repository:
```shell
helm dependency build ./pvc-out-of-space
helm upgrade --install --dependency-update pvc-out-of-space ./pvc-out-of-space --namespace pvc-out-of-space --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore. 
```shell
helm uninstall pvc-out-of-space --namespace pvc-out-of-space
kubectl delete namespace pvc-out-of-space
```

## Dependency
We are using the `zot` helm chart as a dependency for this deployment. Any required configuration for this demo can be found in the [values.yaml](values.yaml).\
Please refer to the [official documentation](https://zotregistry.dev) for configurations that you might need. 

- [GitHub - project-zot/zot](https://github.com/project-zot/zot)