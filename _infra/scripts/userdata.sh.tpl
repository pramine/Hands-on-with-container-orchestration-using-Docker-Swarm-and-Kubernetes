#### - Put the custom install bits into this file
#### - you'll see the output of these, if you hop on to the instance and check out /var/log/cloud-init-output.log
#### - No need for #!/bin/bash

echo "============== My Custom Install Script =============="
HOST=$(hostname)
echo "Prepping stuff on instance $${HOST} for user: ${username} "

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

#DOCKER
curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=18.06.0~ce~3-0~ubuntu containerd.io
sudo usermod -aG docker ubuntu
sudo systemctl enable docker

#K8S
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF >/tmp/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo mv /tmp/kubernetes.list /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo systemctl enable kubelet