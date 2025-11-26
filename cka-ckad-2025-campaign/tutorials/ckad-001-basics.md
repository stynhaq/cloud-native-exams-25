# The Kubernetes Architecture

A Kubernetes cluster consists of the Control (or Master), and Worker Nodes.
The control nodes contain the key components that Kubernetes need to operate. The control plane node(s) host the engine of the kubernetes system. The Kubernetes control can be a single or multi-node cluster where more than one node host the kubernetes control components to provide high availability and disaster recovery.

## Kubernetes Control Node

The Core components of the Control Node cluster include:

- API Server (kube api-server)
- Controller (kube controller)
- ETCD (Distributed Data store)
- Scheduler (kube scheduler)

The API server is the frontend for the kubernetes cluster. The requests and interactions with the cluster would usually first interact with the API server which then routes the request to the appropriate kubernetes component.

The ETCD is a distributed key store that uses the Paxos algorithm for Consensus. It serves as the database of the kubernetes cluster, also providing a lock functionality in a multi-node control cluster.

The scheduler is responsible for scheduling workloads on the right nodes.

The kube-controller ensures the entire cluster is working as expected.

These components are the core of the Kubernetes system and must be part of every Control node setup.

Other critical components can be categorized into the following:

- Kubelet
- Service Discovery
- Container Runtime Interface
- Container Network Interface

Service Discovery provides name resolution capabilities within the cluster. This provides DNS or DNS-like capabilities to the cluster for use with components like Service or other name resoulution requirements. _Core DNS_ is the implementation for Service Discovery in typical kubernetes cluster.

Container Runtime Interface (CRI) allows the underlying pods to be run and scheduled on the cluster. Popular implementations include containerd and CRI-O. The idea of the CRI is to decouple the container Enginer from Kubernetes such that any runtime that complies with the Open Container Initiative (OCI) standard should be able to work with Kubernetes.

The OCI defines two components for the CRI that must be adhered to be compliant. These are:

- imagespec
- runtimespec

The imagespec defines how the image is built while the runtimespec defines the runtime requirements for the container.

The container runtime interfaces are exposed on the following interfaces

| Container Runtime | UNIX Interface                         |
| ----------------- | -------------------------------------- |
| Docker (Shim)     | unix:///var/run/dockershim.sock        |
| Containerd        | unix:///run/containerd/containerd.sock |
| CRI-O             | unix:///run/crio/crio.sock             |
| CRI-Dockerd       | unix:///var/run/cri-dockerd.sock       |

The Container Network Interface (CNI) is a non-core Kubernetes component that provides overlay routing in the Kubernetes cluster. The CNI, like the CRI is not implemented by Kubernetes but is required for the networking to work. The pods in a kubernetes cluster are assigned IP Addresses from the Pod CIDR allocated to the CNI. The CNI can support advanced features like BGP, VXLAN, Network Policy, Load Balancing, and so on.

The CNI can typically use any of the following data planes; iptables, nftables, or eBPF.

Popular CNI implementations including Flannel, Calico, Weave, and Cilium.

Kubernetes by default places a taint on the control node to avoid production workload from being scheduled on it. This is important because under normal circumstances in production networks, the control node should not run workloads.

## Worker Node

The kubernetes worker nodes run the actual workloads. In a single-node kubernetes cluster where there the node serves both control and worker functionality, the taint on the control node needs to be removed.

The control and worker node contains the kubelet, an agent which connects the container runtime with the kubernetes API server to allow for interactions with the cluster.

The node also containers the kube proxy for networking functionality

## Managing a Kubernetes Cluster

The `kubectl` commandline utility is used to maintain the kubernetes cluster, some few commands to get started include:

```bash
kubectl get pods
kubectl cluster-info
kubectl get nodes
```
