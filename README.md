# GCP VMs and kubeadm for Kubernetes

```bash
sudo apt-get install netcat-traditional
nc 127.0.0.1 6443 -zv -w 2
```

```bash
kubemaster = {
  "name" = "kubemaster"
  "ssh_command" = "gcloud compute ssh kubemaster --zone=us-central1-a"
  "vm_external_ip" = "35.193.161.8"
  "vm_internal_ip" = "192.168.56.2"
}
kubenode = [
  {
    "name" = "kubenode01"
    "ssh_command" = "gcloud compute ssh kubenode01 --zone=us-central1-a"
    "vm_external_ip" = "34.69.127.64"
    "vm_internal_ip" = "192.168.56.3"
  },
  {
    "name" = "kubenode02"
    "ssh_command" = "gcloud compute ssh kubenode02 --zone=us-central1-a"
    "vm_external_ip" = "35.222.140.75"
    "vm_internal_ip" = "192.168.56.4"
  },
]
```




## all nodes

### disable swap
```bash
sudo swapoff -a
```
### dependencies
```bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
### runtime
```bash
sudo apt-get install -y containerd
```
### main packages
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet
```
### cgroup driver config
```bash
ps -p 1
# should return systemd which means the init process is systemd and thus our cgroup driver must be systemd as well
# defaults to systemd for kubelet

sudo mkdir -p /etc/containerd/
containerd config default 
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

### ip fwd
```bash
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i '/#net.ipv4.conf.all.rp_filter=1/a net.ipv4.ip_forward=1' /etc/sysctl.conf
```

## control plane
```bash
sudo kubeadm init  \
  --apiserver-advertise-address=192.168.56.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --upload-certs \
  --v=5
  ```

### CNI Plugin
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

## worker
```bash
kubeadm join 192.168.56.2:6443 --token xqpvo6.u9pp5ge9a9rfcstm \
        --discovery-token-ca-cert-hash sha256:d08d35fe6ca6449a6f1728b675dfcf559604feafaea6de4430338c24de51298d
```

