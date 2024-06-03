# Problem-Pattern 'frequent-restarts'
## Overview
This chart will deploy `ingress-nginx` in the given namespace. The controller will be artificially restarted by a cron job.\
By default the pkill will happen at 10:00, 10:01 & 10:02 UTC (`0,1,2 10 * * *`).

Each trigger of the cron job results in a failed readiness probe. This failure causes the container to restart.
The cron job and its required service account will be deployed in the default "problem-patterns" namespace (unless updated in the [values.yaml](values.yaml)). All other components will adhere to the specified `--namespace` in the `helm upgrade --install` command.

## Install
Simply run a helm install command from the root of this project:
```shell
# first off we need to acquire the necessary files for our ingress-nginx dependency
helm dependency build ./frequent-restarts
helm upgrade --install frequent-restarts ./frequent-restarts --namespace frequent-restarts --create-namespace
```

## Remove
```shell
helm uninstall frequent-restarts --namespace frequent-restarts
kubectl delete namespace frequent-restarts
```

## Dependency
We are using the `ingress-nginx` helm chart as a dependency for this deployment. No special configurations are in place or needed for this demo.\
Please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/) for configurations that you might need. 

- [GitHub - kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx)