# Kyverno based Problem Patterns

## Summary
These Kyverno based problem patterns show how well a third party tool can send signals and integrate with Dynatrace. Kyverno is a common policy management tool for k8s.

This helm chart can be deployed with up to three different Kyverno policies:
* A policy that requires the "dt.owner" annotation to be set in a certain namespace. 
* A policy that requires memory/cpu requests to be set on the workload.
* A policy that requires a team to be set in the workload annotations.

A namespace can be defined, which runs a "reporting" workload that violates the enabled policies. The Kyverno metrics workload are scraped for prometheus metrics by annotating them correctly. As a consequence, Kyverno emits warning events for the violating workload, that can be found in the k8s app in the warning signals columns. 

The kyverno problem patterns based in this repo require Kyverno. This folder contains a `values.yaml` file with the correct configuration and annations needed for the problem patters to appear in a Dynatrace tenant.

The most import items configured are:
* A background scan interval of 5 minutes to ensure we always have a recent event.
* The correct annotations on the controllers so that the metrics are scraped and ingested into Dynatrace.

## Installation
Using helm, we can install the latest kyverno release by following these steps:
* Add the helm repo with `helm repo add kyverno https://kyverno.github.io/kyverno/`
* Update the repo with `helm repo update``
* Install Kyverno with `helm install kyverno kyverno/kyverno -n kyverno -f values.yaml --create-namespace --atomic`
