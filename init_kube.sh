#!/bin/bash
set -e
echo "export TERM=xterm-256color" > /root/.bashrc
echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc
echo 'source <(kubectl completion bash)' >> /root/.bashrc
echo 'complete -F __start_kubectl k kc' >> /root/.bashrc
echo 'source /opt/kubectl-aliases/.kubectl_aliases' >> /root/.bashrc
echo "alias cls=clear kc=kubectl kcsys='kubectl -n kube-system' kcr='kubectl -n radiance' rm='rm -i' cp='cp -i' mv='mv -i'"  >> /root/.bashrc
echo "Welcome to Radiance web terminal, try kubectl --help."
rm -rf /root/.kube
mkdir -p /root/.kube
echo -e "$1" | envsubst  > /root/.kube/config
exec /bin/bash
