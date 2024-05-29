# Problem-Pattern 'pending-pod'
This chart will install a deployment that utilizes resources specified in [values.yaml](values.yaml) to result in a pending-pod situation. A cron-job takes care of scaling the deployment up and down accordingly.\
The cron-jobs as well as the serviceaccount will be deployed in the "problem-patterns" namespace. Anything else will respect the specified `--namespace` in the `helm install` command. 

In order to make this a valid demo, you will need to ensure the requests/replicas are suitable for your node size.
>**Example:**\
>A node with *2 CPUs* will be able to run 4 workloads requesting *450m* each (=*1800m* total) but will not have enough resources available to spawn a 5th replica.

Please decide yourself which requests and replicas make most sense for your own environment and adjust the [values.yaml](values.yaml) accordingly.

## Install
Simply run a helm install command from the root of this project:
```shell
helm install pending-pod --namespace pending-pod --create-namespace ./pending-pod
```

## Remove
```shell
helm uninstall pending-pod --namespace pending-pod
```