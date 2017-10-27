# Rancher K8S
### Rancher Server v1.6.10
### Rancher Agent v1.2.6

* Required Images list
```
rancher/server:v1.6.10
rancher/agent:v1.2.6
rancher/k8s:v1.7.7-rancher1
rancher/kubernetes-agent:v0.6.6
rancher/network-manager:v0.7.8
rancher/net:v0.11.9
rancher/lb-service-rancher:v0.7.10
rancher/kubectld:v0.8.3
rancher/dns:v0.15.3
rancher/metadata:v0.9.4
rancher/kubernetes-auth:v0.0.8
rancher/healthcheck:v0.3.3
rancher/etcd:v2.3.7-13
rancher/etc-host-updater:v0.0.3
rancher/scheduler:v0.8.2
rancher/net:holder
```
* K8S internal Images from `registry.cn-shenzhen.aliyuncs.com/rancher_cn/`
```
pause-amd64:3.0
heapster-influxdb-amd64:v1.3.3
heapster-amd64:v1.3.0-beta.1
heapster-grafana-amd64:v4.0.2
k8s-dns-kube-dns-amd64:1.14.5
k8s-dns-dnsmasq-nanny-amd64:1.14.5
k8s-dns-sidecar-amd64:1.14.5
kubernetes-dashboard-amd64:v1.6.1
tiller:v2.3.0
```

* Edit `/etc/hosts` on every node
```
10.0.1.132  agent132
10.0.1.137  agent137
```

* Clean Old Rancher state
```
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
rm -rf /var/lib/rancher/state/
```

* Prepare k8s images to local registry
```
for tag in server:v1.6.10 agent:v1.2.6 k8s:v1.7.7-rancher1 kubernetes-agent:v0.6.6 network-manager:v0.7.8 net:v0.11.9 lb-service-rancher:v0.7.10 kubectld:v0.8.3 dns:v0.15.3 metadata:v0.9.4 kubernetes-auth:v0.0.8 healthcheck:v0.3.3 etcd:v2.3.7-13 etc-host-updater:v0.0.3 scheduler:v0.8.2 net:holder; do docker pull rancher/$tag && docker tag rancher/$tag hub.local.com/rancher/$tag && docker push hub.local.com/rancher/$tag; done;
for tag in pause-amd64:3.0 heapster-influxdb-amd64:v1.3.3 heapster-amd64:v1.3.0-beta.1 heapster-grafana-amd64:v4.0.2 k8s-dns-kube-dns-amd64:1.14.5 k8s-dns-dnsmasq-nanny-amd64:1.14.5 k8s-dns-sidecar-amd64:1.14.5 kubernetes-dashboard-amd64:v1.6.1; do docker pull registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag && docker tag registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag hub.local.com/google_containers/$tag && docker push hub.local.com/google_containers/$tag; done;
for tag in tiller:v2.3.0; do docker pull registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag && docker tag registry.cn-shenzhen.aliyuncs.com/rancher_cn/$tag hub.local.com/kubernetes-helm/$tag && docker push hub.local.com/kubernetes-helm/$tag; done;
```

* Pull k8s images to agent
```
for tag in agent:v1.2.6 k8s:v1.7.7-rancher1 kubernetes-agent:v0.6.6 network-manager:v0.7.8 net:v0.11.9 lb-service-rancher:v0.7.10 kubectld:v0.8.3 dns:v0.15.3 metadata:v0.9.4 kubernetes-auth:v0.0.8 healthcheck:v0.3.3 etcd:v2.3.7-13 etc-host-updater:v0.0.3 scheduler:v0.8.2 net:holder; do docker pull hub.local.com/rancher/$tag && docker tag hub.local.com/rancher/$tag rancher/$tag; done;
for tag in pause-amd64:3.0 heapster-influxdb-amd64:v1.3.3 heapster-amd64:v1.3.0-beta.1 heapster-grafana-amd64:v4.0.2 k8s-dns-kube-dns-amd64:1.14.5 k8s-dns-dnsmasq-nanny-amd64:1.14.5 k8s-dns-sidecar-amd64:1.14.5 kubernetes-dashboard-amd64:v1.6.1; do docker pull hub.local.com/google_containers/$tag; done;
docker pull hub.local.com/kubernetes-helm/tiller:v2.3.0
```

* Run Rancher Server
```
docker run -itd -p 80:8080 --restart=unless-stopped --name rancher-server hub.local.com/rancher/server:v1.6.10 && docker logs -f rancher-server
```
* Login to Rancher Dashboard

* Edit System Setting
> registry.default=`hub.local.com`

* Add Environment Template and edit setting:
> Private Registry for Add-Ons and Pod Infra Container Image
`hub.local.com`
> Pod Infra Container Image
`google_containers/pause-amd64:3.0`

* Add Kubernetes Environments

* Switch to Hosts panel and Add Host

* Ensure K8s status
```
kubectl get po -n kube-system
kubectl describe po kubernetes-dashboard-2253801924-wk3lr -n kube-system
```

* Check kubelet container logs
