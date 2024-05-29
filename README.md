# k8s-problem-patterns

## Exceed-quota pattern
### Deploy pattern (workload will be deployed to exceeded-quota namespace, supporting resources by default to problem-patterns namespace)
```
helm upgrade exceeded-quota ./exceeded-quota --install --namespace <workload_namespace> --create-namespace
```
### Deploy pattern (set namespace where supporting resources will be deployed)
```
helm upgrade exceeded-quota ./exceeded-quota --install --namespace <workload_namespace> --create-namespace --set alternativeNamespace=<problem_patterns_namespace>
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
helm upgrade terminating-pod ./terminating-pod --install --namespace terminating-pod --create-namespace --set alternativeNamespace=problem-patterns
```

## PVC out of space pattern
This pattern uses a vendor neutral OCI registry called zotregistry (a CNCF sandbox project). Zotregistry is simple, but powerful enough to support production-ready features like permissions and automatic garbage collection. A cronjob pushes a large image using Kaniko at regular intervals, and another cronjob clears these images once a day at 23:45 UTC.

### Deploy pattern, namespace for workloads can be selected and supporting resources like cronjobs will be in the problem-patterns namespace.
```
helm upgrade pvc-out-of-space ./pvc-out-of-space \
  --install \
  --namespace <target namespace for zot workload> \
  --create-namespace
```
### Deploy pattern with custom problem patterns namespace and a 5G pvc
```
helm upgrade pvc-out-of-space ./pvc-out-of-space \
  --install \
  --namespace <target namespace for zot workload> \
  --set alternativeNamespace=<problem-patterns-ns> \
  --set zot.pvc.storage=5G \
  --create-namespace
```