#!/bin/bash
#K8S_AARCH_PRETTY=$(hostnamectl | grep Architecture | sed -e "s/Architecture://g" | cut -f6 -d " ")
K8S_OS_ARCH=$(uname -p)
K8S_AARCH_PRETTY=$(hostnamectl | grep Architecture | sed -e "s/Architecture://g" | tr -d " ")
K8S_OS_VERSION=$(cat /etc/os-release | grep ^NAME  | sed -e 's/NAME="//g' | tr -d '"')
CONTAINERD_VERSION="2.2.0"
RUN_C_VERSION="1.3.3"
CNI_PLUGIN_VERSION="1.8.0"
NERDCTL_VERSION="2.2.0"
CRICTL_VERSION="1.34.0"
KUBEADM_VERSION="1.33"
KUBECTL_VERSION="1.33"
KUBELET_VERSION="1.33"
POD_CIDR="10.250.0.0/16"
CONTROL_PLANE_ENDPOINT="control-k8s"

# Disable swap space persistently
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# Set Operating System Architecture
if [ "$K8S_OS_ARCH" == "$(arch)" ]; then
     if [ "$K8S_OS_ARCH" == "x86_64" ]; then
          K8S_AARCH_PRETTY="amd64"
   fi
  echo "Architecture is $K8S_AARCH_PRETTY"

  if [ "$K8S_OS_VERSION" == "Ubuntu" ]; then
    # Create a temporary file in user's home directory to work from
    wget -nc https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz
    sudo tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz
    wget -nc https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
    #sudo mv containerd.service /usr/local/lib/systemd/system/containerd.service 
    # Containerd recommendation but fails in Ubuntu. Below works
    sudo mv containerd.service /etc/systemd/system/containerd.service 
    sudo systemctl daemon-reload
    sudo systemctl enable --now containerd
    sudo mkdir -p /etc/containerd/
    sudo bash -c "containerd config default >  /etc/containerd/config.toml"
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml 
    sudo systemctl restart containerd



    # Check logic, if systemd runs well, clean up downloaded files

    # Install Runc
    echo "<--- Step 2. Installing Runc --->"
    wget -nc https://github.com/opencontainers/runc/releases/download/v$RUN_C_VERSION/runc.$K8S_AARCH_PRETTY
    sudo install -m 755 runc.$K8S_AARCH_PRETTY /usr/local/sbin/runc

    echo "<--- Step 3. Installing CNI plugins --->"
    wget -nc https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGIN_VERSION/cni-plugins-linux-$K8S_AARCH_PRETTY-v$CNI_PLUGIN_VERSION.tgz
    sudo mkdir -p /opt/cni/bin
    sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-$K8S_AARCH_PRETTY-v$CNI_PLUGIN_VERSION.tgz
    rm -f cni-plugins-linux-$K8S_AARCH_PRETTY-v$CNI_PLUGIN_VERSION.tgz

    #Nerdctl install
    wget -nc https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-$NERDCTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz
    sudo tar Cxzvf /usr/local/bin nerdctl-$NERDCTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz
    rm -f nerdctl-$NERDCTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz

    # CRICTL Download
    wget -nc https://github.com/kubernetes-sigs/cri-tools/releases/download/v$CRICTL_VERSION/crictl-v$CRICTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz
    sudo tar Czxvf /usr/local/bin crictl-v$CRICTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz 
    rm -f crictl-v$CRICTL_VERSION-linux-$K8S_AARCH_PRETTY.tar.gz 
    #Configuring the systemd cgroup driver 
    # Change [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc.options]
    #  "SystemdCgroup = false" to  "SystemdCgroup = true" on the /etc/containerd/config.toml

  fi
  else
  echo "Architecture Unknown or not yet supported"
  # RHEL based logic to be added
  exit 1
fi

if [ "$K8S_OS_VERSION" == "Ubuntu" ]; then
# Kubernetes Components
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg bash-completion
if [ ! -d /etc/apt/keyrings ]; then
 sudo mkdir -p -m 755 /etc/apt/keyrings
fi
if [ -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
  rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi
curl -fsSL https://pkgs.k8s.io/core:/stable:/v"$KUBEADM_VERSION"/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes Apt repo
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v'"$KUBEADM_VERSION"'/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet


# Enable Netfilter 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Change IP Address of ETH0 Interface to Static IP
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.145.20/24
      routes:
        - to: default
          via: 192.168.145.2
      nameservers:
        addresses: 
          - 8.8.8.8
EOF

sudo chmod 600 /etc/netplan/*.yaml
sudo rm -f /etc/netplan/50-cloud-init.yaml
sudo netplan apply -f /etc/netplan/01-netcfg.yaml

# Apply sysctl params without reboot
sudo sysctl --system

sudo kubeadm init --control-plane-endpoint $CONTROL_PLANE_ENDPOINT --pod-network-cidr $POD_CIDR

# CNI Setup. Logic to be added to Select Calico or Cilium. 
# If Calico, option of either using eBPF or iptables as dataplane
else
  echo "OS Version Unknown or not yet supported"
  # RHEL based logic to be added
  exit 1
fi