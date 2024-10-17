# Installation
Navigate into the folder and run ./install.sh while connected to a k8s cluster

# What is it?
It demonstrates how well third party tool signals integrate into Dynatrace. For doing that, we use kyverno, a common policy management tool for k8s. Furthermore, we create a policy that requires the "dt.owner" annotation to be set in a certain namespace. Within this namespace, we run artificial workloads that violate this rules. As a consequence, kyverno emits warning events to the violating workload, that can be found in the k8s app in the warning signals columns. Additionally, the kyverno metrics workload are scraped for prometheus metrics by annotating them correctly. 