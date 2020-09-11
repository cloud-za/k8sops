#!/bin/bash

#disable firewall
systemctl disable firewalld
systemctl stop firewalld

#disable selinux
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

#disable swap
swapoff -a
sed -i "s/.*swap.*/#&/" /etc/fstab

#modify sysctl
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.netfilter.nf_conntrack_max=2310720

kernel.msgmnb=65536
kernel.msgmax=65536
kernel.shmmni=4096
kernel.shmmax=8589934592
kernel.shmall=8589934592
kernel.sem=250 32000 100 128

net.core.somaxconn=65535
net.core.rmem_default=8388608
net.core.wmem_default=8388608
net.core.rmem_max=33554432
net.core.wmem_max=33554432
net.core.dev_weight=512
net.core.optmem_max=262144
net.core.netdev_budget=1024
net.core.netdev_max_backlog=300000
net.ipv4.udp_mem=262144 327680 393216

net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_max_tw_buckets=3600
net.ipv4.tcp_max_orphans=327680
net.ipv4.tcp_orphan_retries=3
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_max_syn_backlog=16384
net.ipv4.ip_conntrack_max=65536
net.ipv4.tcp_timestamps=0
EOF

sysctl --system

#config aliyun k8s 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all -y && yum makecache -y && yum repolist -y
