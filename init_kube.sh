#!/bin/bash
set -e
echo "export TERM=xterm-256color" >> /root/.bashrc
echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc
echo 'source <(kubectl completion bash)' >> /root/.bashrc
echo 'complete -F __start_kubectl k' >> /root/.bashrc
echo "alias cls=clear kc=kubectl kcsys='kubectl -n kube-system' kcr='kubectl -n radiance'"
echo "Welcome to Radiance web terminal, try kubectl --help."
echo 'source /opt/kubectl-aliases/.kubectl_aliases' >> /root/.bashrc
rm -rf /root/.kube
mkdir -p /root/.kube
echo -e "$1" | envsubst  > /root/.kube/config
exec /bin/bash
