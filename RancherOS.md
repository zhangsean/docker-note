# Rancher OS

RancherOS系统镜像[下载地址](https://github.com/rancher/os)

新建虚拟机，光驱挂载rancheros.iso镜像，启动系统
此时RancherOS是从光盘启动的，并且rancher账号已自动登录
```
rancher@rancher $
```
执行以下命令生成ssh秘钥
```
rancher@rancher $ ssh-keygen -t rsa
cp .ssh/id_rsa.pub .ssh/authorized_keys
scp .ssh/id_rsa root@192.168.1.6:/root/
```
用`ip addr`命令查看 *IP地址*

Xshell 用上面的 *id_rsa* 私钥通过ssh连接上面的 *IP地址* 即可远程登录到rancher

开始安装RancherOS到硬盘
```
cat .ssh/id_rsa.pub #查看id_rsa.pub 文件内容
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc008sjby03bDODhvU1/cXn+oouNRdzrVtOgVpwlSz4QwWS4Fk22w39KGWB9NXnc3Dg5mnis4Ony+v0FvANp2yQKJq4YUUMar2F/e350rAb6Bp1M+gk50zf7mFjG9SciW71DpejPzzFun1HxPCipa0FMFIG3sn3eOgoRrLRJoSrJogMRIZVy0VPi7vNoMcOwqApXxqoC4ncKnmrqlcfeqokJ8qu/i177m35kMv3ixh9BzsUo+O/Bge72Zx/sgrtxoR/KCzbXt3VYIxtKfNkZshqqnRkRFTMNmndEVTuSIZiV61YhBX6af7LfrKpr/0cII+J8DEfL7AjMq2GH1wrFJ7 rancher@rancher
```
```
vi cloud-config.yml #编辑文件，按照以下格式把id_rsa.pub的内容粘贴进来
```
```
ssh_authorized_keys:
- ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc008sjby03bDODhvU1/cXn+oouNRdzrVtOgVpwlSz4QwWS4Fk22w39KGWB9NXnc3Dg5mnis4Ony+v0FvANp2yQKJq4YUUMar2F/e350rAb6Bp1M+gk50zf7mFjG9SciW71DpejPzzFun1HxPCipa0FMFIG3sn3eOgoRrLRJoSrJogMRIZVy0VPi7vNoMcOwqApXxqoC4ncKnmrqlcfeqokJ8qu/i177m35kMv3ixh9BzsUo+O/Bge72Zx/sgrtxoR/KCzbXt3VYIxtKfNkZshqqnRkRFTMNmndEVTuSIZiV61YhBX6af7LfrKpr/0cII+J8DEfL7AjMq2GH1wrFJ7 rancher@rancher  
```
```
:wq #保存退出
```
查看本地磁盘
```
sudo fdisk -l
/dev/sda
```
把rancheros安装到硬盘
```
sudo ros install -c cloud-config.yml -d /dev/sda
```
输入y确认安装
如果有错误，很可能是网络原因，多试几次

配置
```
sudo ros c set rancher.docker.insecure_registry ["http://10.0.1.6"]
sudo ros c set rancher.docker.registry_mirror "http://10.0.1.6"
sudo ros c get rancher.docker
```