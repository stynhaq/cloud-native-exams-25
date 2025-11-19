# Setup of Kubernetes Cluster

Ensure that Swap is disabled persistently
`sudo swapoff -a`
To make it persistent on reboot, either do

```bash
sudo crontab -e
@reboot /sbin/crontab -a
```

Or

```bash
sudo swapoff -a
(crontab -l 2>/dev/null) | sudo crontab - || true
```

`select-editor` - to change default crontab editor

kubeadm init --control-plane-endpoint control-k8s --pod-network-cidr 10.250.0.0/16

`cat /etc/netplan/01-netcfg.yaml`

```yaml
version: 2
ethernets:
  eth0:
    addresses:
      - 172.16.147.100/24
    routes:
      - to: default
        via: 172.16.147.2
    nameservers:
      addresses:
        - 8.8.8.8
```

```bash
sudo -c "cat <<EOF > /etc/netplan/01-netcfg.yaml
version: 2
ethernets:
  eth0:
    addresses:
      - 172.16.147.100/24
    routes:
      - to: default
        via: 172.16.147.2
    nameservers:
      addresses:
        - 8.8.8.8
EOF
"
```

```bash
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 172.16.147.100/24
      routes:
        - to: default
          via: 172.16.147.2
      nameservers:
        addresses:
          - 8.8.8.8
EOF
```

```bash
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

kubeadm join control-k8s:6443 --token 16s53e.hfjpurqrm5cobzxo \
 --discovery-token-ca-cert-hash sha256:cd3fc1ff75b1d1bc98991a5edf0fbab42dc95de3f810c29664c8f813657b654b \
 --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join control-k8s:6443 --token 16s53e.hfjpurqrm5cobzxo \
 --discovery-token-ca-cert-hash sha256:cd3fc1ff75b1d1bc98991a5edf0fbab42dc95de3f810c29664c8f813657b654b
```
