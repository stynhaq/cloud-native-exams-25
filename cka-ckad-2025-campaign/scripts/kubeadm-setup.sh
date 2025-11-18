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
# Set Operating System Architecture

# Disable swap space persistently
(sudo crontab -l 2>/dev/null) | sudo crontab - || true

if [ "$K8S_OS_ARCH" == "$(arch)" ]; then
  echo "Architecture is $K8S_AARCH_PRETTY"
  if ["$K8S_OS_VERSION" == "Ubuntu"]; then
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
  echo "Architecture Unnkown"
fi