# Troubleshooting

## Use Journactl to see status of Kublet

`sudo journalctl -u kubelet | grep kube-apiserver`

## To reset the kubeadm cluster

`sudo kubeadm reset`
