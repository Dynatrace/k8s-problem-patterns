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