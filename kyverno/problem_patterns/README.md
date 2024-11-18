# Kyverno based Problem Patterns

> [!WARNING]
> These problem patterns require Kyverno, which can be installed with settings to match the problem patterns in the `kyverno_installation` [folder](../kyverno_installation/README.md).

## Summary
These Kyverno based problem patterns show how well a third party tool can send signals and integrate with Dynatrace. Kyverno is a common policy management tool for k8s.

This helm chart can be deployed with up to three different Kyverno policies:
* A policy that requires the "dt.owner" annotation to be set in a certain namespace. 
* A policy that requires memory/cpu requests to be set on the workload.
* A policy that requires a team to be set in the workload annotations.

A namespace can be defined, which runs a "reporting" workload that violates the enabled policies. The Kyverno metrics workload are scraped for prometheus metrics by annotating them correctly. As a consequence, Kyverno emits warning events for the violating workload, that can be found in the k8s app in the warning signals columns. 

The kyverno problem patterns based in this repo require Kyverno. This folder contains a `values.yaml` file with the correct configuration and annotations needed for the problem patterns to appear in a Dynatrace tenant:
```
require_ownership_label_pattern:
  enabled: true
require_annotations_pattern:
  enabled: true
require_requests_pattern:
  enabled: true
```

## Installation
Simply run a `helm upgrade` command from the root of this repository:
```shell
helm upgrade --install kyverno-problem-patterns ./kyverno/problem_patterns --namespace problem-patterns --create-namespace
```

## Removal
Helm uninstall will remove the resources but leave the namespace. Be careful with deleting that as there might be other problem-patterns depending on it. 
```shell
helm uninstall kyverno-problem-patterns --namespace problem-patterns
```