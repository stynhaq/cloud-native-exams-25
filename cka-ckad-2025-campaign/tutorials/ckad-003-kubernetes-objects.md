# Kubernetes Objects

Kubernetes deploy workloads in form of pods. Pods are the smallest unit of workload in a kubernetes cluster and it is usually made up of one or more containers.

Other basic kubernetes primitives include:

- ReplicaSet
- Deployment
- Namespaces

Namespaces are logical containers within the cluster for the kubernetes resources like Pods and Deployements

By default, all resources are created in the `default` name space if none is specified if context is not switched. To switch context to a defined namespace called prod, use the command `kubectl config set-context $(kubectl config current-context) --namespace=prod`
