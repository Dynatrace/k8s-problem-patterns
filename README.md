# k8s-problem-patterns
[![GitHub license](https://img.shields.io/github/license/kubernetes/ingress-nginx.svg)](https://github.com/Dynatrace/k8s-problem-patterns/blob/main/LICENSE)
![GitHub contribution](https://img.shields.io/badge/contributions-welcome-orange.svg)

> [!WARNING]
> The deployments provided here are **purposely malfunctioning**.\
> They should not be used in production and are meant to be used for demos.

We required a reliable way to create unhealthy states in our clusters to showcase [Dynatrace](https://www.dynatrace.com)'s monitoring capabilities.\
Feedback and contributions are welcome.

| Problem Pattern                                  | Description                                                                        |
| ------------------------------------------------ | ---------------------------------------------------------------------------------- |
| [exceeded-quota](exceeded-quota/README.md)       | a deployment that violates a specified resource quota when scaled up               |
| [frequent-restarts](frequent-restarts/README.md) | periodic restart of a ingress-nginx pod                                            |
| [kyverno](kyverno/README.md)                     | third party (policy) tool emmitting warning signals and prometheus metrics         |
| [node-pressure](node-pressure/README.md)         | allocate RAM on a specified node using stress-ng until the system is out-of-memory |
| [pending-pod](pending-pod/README.md)             | pods in pending state due to insufficient resources                                |
| [pvc-out-of-space](pvc-out-of-space/README.md)   | container registry that will be filled up over time to exceed the limit on the pvc |
| [terminating-pod](terminating-pod/README.md)     | pod in terminating state due to a misconfigured finalizer                          |
| [unhealthy-pod](unhealthy-pod/README.md)         | pod in unhealthy/unready state due to misconfigured `ConfigMap`                    |

New problem-patterns will be added over time and we plan to improve and adjust all of them in the near future.\
Feel free to share ideas with us!
