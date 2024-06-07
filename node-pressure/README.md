# Problem-Pattern 'node-pressure'
![ChartVersion](https://img.shields.io/badge/ChartVersion-1.1.0-informational?style=flat)

## Overview
This chart will deploy a pod running a [script](files/script.sh) that fills up the hosts memory using `stress-ng`.\
By default we will fill up to 16GB of memory (`--vm-bytes`) with a single worker (`--vm`). This can be adjusted in [script.sh](files/script.sh) if needed. 

All components will be deployed to the specified `--namespace` in the `helm upgrade --install` command.

### Use-Case
In this demo we are allocating memory on the node to the point where the OS will get into a out-of-memory (OOM) situation. The kernel will kill the workload as it's identified as the problem source automatically.\
The process will be spawned over and over again and will cause a continuous oom-kill, respawn loop. This behaviour can potentially raise an alert if the workload is monitored.

```shell
$ kubectl describe node -l demo=node-pressure
[...]
Events:
Type     Reason      Age                     From            Message
Warning  SystemOOM   3m57s                   kubelet         System OOM encountered, victim process: stress-ng-vm, pid: 3103923
Warning  OOMKilling  3m56s                   kernel-monitor  Out of memory: Killed process 3103923 (stress-ng-vm) total-vm:15791416kB, anon-rss:14369596kB, file-rss:4kB, shmem-rss:36kB, UID:0 pgtables:28184kB oom_score_adj:1000
Warning  SystemOOM   2m13s (x16 over 3m50s)  kubelet         (combined from similar events): System OOM encountered, victim process: stress-ng-vm, pid: 3106306
Warning  OOMKilling  2m13s (x16 over 3m50s)  kernel-monitor  (combined from similar events): Out of memory: Killed process 3106306 (stress-ng-vm) total-vm:15791416kB, anon-rss:14360328kB, file-rss:4kB, shmem-rss:36kB, UID:0 pgtables:28168kB oom_score_adj:1000
  ```

## Installation
Simply run a `helm upgrade` command from the root of this repository:
```shell
helm upgrade --install node-pressure ./node-pressure --namespace node-pressure --create-namespace
```

## Removal
Helm uninstall will get rid of everything but the namespaces. Thus we need to issue a kubectl delete manually to finish the cleanup.
> [!NOTE]  
> The `faultInjection.namespace` will be left regardless. It is used by many of our charts, so we will not delete it.\
> Please remove it manually when you are sure it's not needed anymore. 
```shell
helm uninstall node-pressure --namespace node-pressure
kubectl delete namespace node-pressure
```

## Dependency
We are using the `stress-ng` tool to cause memory pressure on the host. More details on the usage of this tool can be found in [Ubuntu Wiki](https://wiki.ubuntu.com/Kernel/Reference/stress-ng) or on GitHub.

- [GitHub - ColinIanKing/stress-ng](https://github.com/ColinIanKing/stress-ng)