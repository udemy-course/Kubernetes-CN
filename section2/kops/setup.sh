#/bin/sh

# install some tools
sudo yum install -y vim telnet bind-utils wget

# install kops

wget https://github.com/kubernetes/kops/releases/download/1.9.1/kops-linux-amd64
mv kops-linux-amd64 kops
sudo mv kops /usr/local/bin/
sudo chmod +x /usr/local/bin/kops

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# install python pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
rm -rf get-pip.py

# install aws cli
sudo pip install awscli
