#!/bin/bash
cd "$(dirname "$0")"
# from here https://kyverno.io/docs/installation/methods/
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
# scale for high-avail
kubectl scale --replicas=3 -n kyverno deployment/@kyverno-admission-controller
# decrease scan interval from default 1h, to 5min, so warning events are constantly visible.
kubectl patch deployment -n kyverno kyverno-reports-controller --patch-file ./patch_kyverno_bg_scan_interval.yaml
#kubectl apply -f ./require_annotation.yaml
#kubectl apply -f ./require_requests.yaml
kubectl apply -f ./require_dt_ownership_label.yaml

kubectl create namespace finance
#TODO add annotation for triggering kyverno
kubectl apply -f workload.yaml -n finance
kubectl label namespace finance --overwrite dynatrace.com/ownership-required=
kubectl label namespace online-boutique --overwrite dynatrace.com/ownership-required=
# kubectl annotate namespace finance --overwrite policies.kyverno.io/annotation_required-
kubectl annotate namespace finance --overwrite app=finance
kubectl annotate service kyverno-background-controller-metrics --namespace kyverno metrics.dynatrace.com/path=/metrics metrics.dynatrace.com/port=8000 metrics.dynatrace.com/scrape=true
kubectl annotate service kyverno-cleanup-controller-metrics --namespace kyverno metrics.dynatrace.com/path=/metrics metrics.dynatrace.com/port=8000 metrics.dynatrace.com/scrape=true
kubectl annotate service kyverno-reports-controller-metrics --namespace kyverno metrics.dynatrace.com/path=/metrics metrics.dynatrace.com/port=8000 metrics.dynatrace.com/scrape=true
kubectl annotate service kyverno-svc-metrics --namespace kyverno metrics.dynatrace.com/path=/metrics metrics.dynatrace.com/port=8000 metrics.dynatrace.com/scrape=true
