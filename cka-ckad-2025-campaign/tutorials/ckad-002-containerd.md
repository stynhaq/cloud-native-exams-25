# Containerd

Containerd is a CNCF graduated project that is a available as a CNI for the kubernetes cluster. This means, it allows administrators and developers run pods (which in turn are containers).

Containerd is exposed on the socket `unix:///run/containerd/containerd.sock`

Containerd comes with a CLI utility - `ctr` which is not very user-friendly but can provide low-level information about containerd. It is intended to be used for debugging containerd and does not have an excellent user experience.

The alternate tool `nerdctl` is designed to be a more human-friendly high level too for interacting with containerd.

The `nerdctl` provides a Docker-like CLI for containerd, also providing support for Docker Compose.

Another important tool is the CLI command `crictl` which works for the kubernetes cluster and is not CRI-specific unlike `nerdctl`. `crictl` provides a CLI for CRI-compatible container runtimes and is used to inspect and debug container runtimes (not designed to be used to create and manage containers)
