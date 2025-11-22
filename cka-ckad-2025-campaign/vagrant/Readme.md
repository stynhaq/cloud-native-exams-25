# Vagrant setup

1. Ensure the vagrant binary is installed.
2. Ensure that the Vagrant VMware utility is installed
3. Also, ensure that the VMware plugin is installed using `vagrant plugin install vagrant-vmware-desktop`
4. Ensure VMware workstation or Fusion is instslled and running

Vagrant binary is available on [Vagrant Binary Download](https://developer.hashicorp.com/vagrant/install). Choose the right setup for your operating system architecture.

The Vagrant utility can be downloaded from [Vagrant VMware Utility](https://developer.hashicorp.com/vagrant/install/vmware). Also, select for your computer architecture.

Finally, install the VMware plugin as provided in item #4 above.

## IP Addressing on Apple Mac

| Hostname     | IP Address        | FQDN                             | Description    |
| ------------ | ----------------- | -------------------------------- | -------------- |
| control1-k8s | 172.16.247.100/24 | control1-k8s.host3.africodes.com | Control Node 1 |
| worker1-k8s  | 172.16.247.101/24 | worker1-k8s.host3.africodes.com  | Worker Node 1  |
| worker2-k8s  | 172.16.247.102/24 | worker2-k8s.host3.africodes.com  | Worker Node 2  |

## Prerequisites

- CRI (containerd)
- CNI (Calico Operator)
- kubelet on Worker Nodes
- kubeadm on Control Node
- kubectl on Control Node
- OpenSSL x509 Server on Control Node
