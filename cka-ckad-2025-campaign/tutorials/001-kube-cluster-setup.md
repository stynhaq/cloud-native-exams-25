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
