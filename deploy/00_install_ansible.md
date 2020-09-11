#CentOS update kernel

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml -y

grub2-set-default 0
reboot

uname -r


#Ansible

sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible

ssh-keygen
ssh-copy-id root@192.168.101.150:

sudo vi /etc/ansible/hosts
================================================
[k8s-all]
k8smaster ansible_ssh_host=192.168.101.150
k8snode1  ansible_ssh_host=192.168.101.151
k8snode2  ansible_ssh_host=192.168.101.152
k8snode3  ansible_ssh_host=192.168.101.153

[k8s-master]
k8smaster ansible_ssh_host=192.168.101.150

[k8s-node]
k8snode1  ansible_ssh_host=192.168.101.151
k8snode2  ansible_ssh_host=192.168.101.152
k8snode3  ansible_ssh_host=192.168.101.153

================================================




sudo mkdir /etc/ansible/group_vars
sudo nano /etc/ansible/group_vars/k8s-all

###add file with --- ####
---
ansible_ssh_user: root


ansible -m ping all
ansible -m ping k8s-master
ansible -m ping k8snode1:k8snode2

ansible -m shell -a 'free -m' k8snode1

