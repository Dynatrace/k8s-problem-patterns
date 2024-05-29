# k8s-problem-patterns

## Exceed-quota pattern
### Deploy pattern (workload will be deployed to exceed-quota namespace)
```
helm upgrade exceeded-quota ./exceeded-quota --install --namespace <target_namespace> --create-namespace
```
### Deploy pattern (set namespace where workload will be deployed)
```
helm upgrade exceeded-quota ./exceeded-quota --install --namespace <target_namespace> --create-namespace --set workloadNamespace=<workload_namespace>
```

## Terminating Pod pattern
This pattern starts a simple nginx Workload with a non-existant finalizer. The default number of replicas is 3
The deployment is immedieatly scaled down to 2 replicas. This way one pod get's stuck in terminating pod state.

There are three additional CronJobs that reset the pattern by 
- removing the finalizer from the pending pod
- scaling the up deployment to 3 replicas
- scaling the down the deployment to 2 replicas.

### Usage
This example creates the workload (nginx deployment) in the terminating-pod namespace and the other resources like jobs and serviceaccount in the problem-patterns namespace.
```
helm upgrade terminating-pod ./terminating-pod --install --namespace terminating-pod --create-namespace --set problemPatternsNs=problem-patterns
```