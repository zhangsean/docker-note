# Rancher K8S
### Rancher v1.6.11-rc3
### K8S v1.8.2-rancher1

* Required Images list
```
rancher/server:v1.6.11-rc3
rancher/agent:v1.2.7-rc2
rancher/k8s:v1.8.2-rancher1
rancher/kubernetes-agent:v0.6.6
rancher/network-manager:v0.7.13
rancher/net:v0.13.2
rancher/lb-service-rancher:v0.7.10
rancher/kubectld:v0.8.5
rancher/dns:v0.15.3
rancher/metadata:v0.9.5
rancher/kubernetes-auth:v0.0.8
rancher/healthcheck:v0.3.3
rancher/etcd:v3.0.17-4
rancher/etcd:holder
rancher/etc-host-updater:v0.0.3
rancher/scheduler:v0.8.2
rancher/net:holder
```

* K8S internal Images from `registry.cn-shenzhen.aliyuncs.com/rancher_cn/`
```
pause-amd64:3.0
k8s-dns-sidecar-amd64:1.14.5
k8s-dns-kube-dns-amd64:1.14.5
k8s-dns-dnsmasq-nanny-amd64:1.14.5
heapster-influxdb-amd64:v1.3.3
heapster-grafana-amd64:v4.4.3
kubernetes-dashboard-amd64:v1.6.3
heapster-amd64:v1.4.0
tiller:v2.6.1
```

* Edit `/etc/hosts` on every node
```
hostnamectl set-hostname node145
cat >> /etc/hosts << EOF
10.0.1.145  node145
10.0.1.146  node146
EOF
```

* Disable swap on every node
```
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab
reboot
```

* Clean Old Rancher state
```
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
rm -rf /var/lib/rancher/state/
rm -rf /var/etcd/
```

* Prepare k8s images to local registry
```
for tag in server:v1.6.11-rc3 agent:v1.2.7-rc2 k8s:v1.8.2-rancher1 kubernetes-agent:v0.6.6 network-manager:v0.7.13 net:v0.13.2 lb-service-rancher:v0.7.10 kubectld:v0.8.5 dns:v0.15.3 metadata:v0.9.5 kubernetes-auth:v0.0.8 healthcheck:v0.3.3 etcd:v3.0.17-4 etcd:holder etc-host-updater:v0.0.3 scheduler:v0.8.2 net:holder; do docker pull rancher/$tag && docker tag rancher/$tag hub.local.com/rancher/$tag && docker push hub.local.com/rancher/$tag; done;
for tag in pause-amd64:3.0 heapster-influxdb-amd64:v1.3.3 heapster-amd64:v1.3.0-beta.1 heapster-grafana-amd64:v4.0.2 k8s-dns-kube-dns-amd64:1.14.5 k8s-dns-dnsmasq-nanny-amd64:1.14.5 k8s-dns-sidecar-amd64:1.14.5 kubernetes-dashboard-amd64:v1.6.1; do docker pull registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag && docker tag registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag hub.local.com/google_containers/$tag && docker push hub.local.com/google_containers/$tag; done;
for tag in tiller:v2.3.0; do docker pull registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag && docker tag registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag hub.local.com/kubernetes-helm/$tag && docker push hub.local.com/kubernetes-helm/$tag; done;
```

* Pull k8s images to agent
```
for tag in agent:v1.2.7-rc2 k8s:v1.8.2-rancher1 kubernetes-agent:v0.6.6 network-manager:v0.7.13 net:v0.13.2 lb-service-rancher:v0.7.10 kubectld:v0.8.5 dns:v0.15.3 metadata:v0.9.5 kubernetes-auth:v0.0.8 healthcheck:v0.3.3 etcd:v3.0.17-4 etc-host-updater:v0.0.3 scheduler:v0.8.2 net:holder; do docker pull hub.local.com/rancher/$tag && docker tag hub.local.com/rancher/$tag rancher/$tag; done;
for tag in pause-amd64:3.0 heapster-influxdb-amd64:v1.3.3 heapster-amd64:v1.3.0-beta.1 heapster-grafana-amd64:v4.0.2 k8s-dns-kube-dns-amd64:1.14.5 k8s-dns-dnsmasq-nanny-amd64:1.14.5 k8s-dns-sidecar-amd64:1.14.5 kubernetes-dashboard-amd64:v1.6.1; do docker pull hub.local.com/google_containers/$tag; done;
docker pull hub.local.com/kubernetes-helm/tiller:v2.3.0
```

* Run Rancher Server
```
docker run -itd -p 80:8080 --restart=unless-stopped --name rancher-server hub.local.com/rancher/server:v1.6.11-rc3 && docker logs -f rancher-server
```
* Login to Rancher Dashboard

* Edit System Setting
> registry.default=`hub.local.com`

* Add Environment Template and edit setting:
> Private Registry for Add-Ons and Pod Infra Container Image
`hub.local.com`
>Pod Infra Container Image
`google_containers/pause-amd64:3.0`

* Add Kubernetes Environments

* Switch to Hosts panel and Add Host

* Ensure K8s status
```
kubectl get po -n kube-system
kubectl describe po kubernetes-dashboard-2253801924-wk3lr -n kube-system
```

* Check kubelet container logs
