alias vi="vim"
alias kubectl="k3s kubectl"
alias k=kubectl
complete -F __start_kubectl k
alias crictl="k3s crictl"
source /etc/profile.d/bash_completion.sh
source <(kubectl completion bash)
eval "$(starship init bash)"
export KUBE_EDITOR="vim"
export PS1="\h $ "
export PAGER=less