#!/bin/bash

apt-get update

#install Docker
apt-get update
apt install docker.io -y
usermod -aG docker ubuntu
systemctl restart docker

#install Java for Jenkins
apt-get update
apt install fontconfig openjdk-17-jre -y 

#install Jenkins
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install jenkins -y
usermod -a -G docker jenkins


#Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update

#Install kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

#Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin


#permit ubutu accesss for jenkins
usermod -a -G ubuntu jenkins