#!/bin/bash

echo "Disabling swap..."
sudo swapoff -a

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

echo "Adding Kubernetes apt repo and key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Installing containerd..."
sudo apt-get update
sudo apt-get install -y containerd

echo "Configuring containerd to use systemd cgroup driver..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml > /dev/null
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "Installing kubelet, kubeadm, kubectl..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Enabling and starting kubelet..."
sudo systemctl enable --now kubelet


echo "Enabling IPv4 forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
# Ensure IP forwarding persists on reboot
if ! grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf; then
  echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
fi


