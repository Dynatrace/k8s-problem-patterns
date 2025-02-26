# Kyverno for Problem Patterns

####

## Summary
The kyverno problem patterns based in this repo require Kyverno. This folder contains a `values.yaml` file with the correct configuration and annotations needed for the problem patterns to appear in a Dynatrace tenant.

The most import items configured are:
* A background scan interval of 5 minutes to ensure we always have a recent event.
* The correct annotations on the controllers so that the metrics are scraped and ingested into Dynatrace.

## Installation
Using helm, we can install the kyverno release that has been verified with our problem patterns, by following these steps:
* Add the helm repo with `helm repo add kyverno https://kyverno.github.io/kyverno/`
* Update the repo with `helm repo update`
* Install Kyverno from the root of this repository with `helm install kyverno kyverno/kyverno -n kyverno -f ./kyverno/kyverno-installation/values.yaml --create-namespace --atomic --version 3.3.3`

## Removal
To remove kyverno, run the following command: 
```shell
helm uninstall kyverno --namespace kyverno
```