# Docker Local Registry

## Local Registry
```
docker run -itd -p 80:5000 --restart=unless-stopped --name registry -v /opt/registry:/var/lib/registry registry
```

## Registry Web
create file *registry-web-config.yml*
```
registry:
  # Docker registry url
  url: http://registry:5000/v2
  # Docker registry fqdn
  name: hub.local.com
  # To allow image delete, should be false
  readonly: false
  auth:
    # Disable authentication
    enabled: false
```

```
docker run -itd -p 88:8080 --name registry-web --link registry -v $PWD/registry-web-config.yml:/conf/config.yml:ro hyper/docker-registry-web
```

## Clean unused images

* Enable delete images in registry
```
docker exec -it registry sh
vi /etc/docker/registry/config.yml
```
Add following property to registry config file
```
storage:
  delete:
    enabled: true
```

* View Registry Web for image detail and delete unused images

* collect disk space in registry
```
docker exec -it registry sh
registry garbage-collect /etc/docker/registry/config.yml
du -sch
```

## Registry Frontend
Not recommended as following reasons:
> registry-frontend cannot start on docker 17.05.0-ce
> registry-frontend cannot delete docker images in web frontend

```
docker run -itd -p 88:8080 --restart=unless-stopped -e ENV_DOCKER_REGISTRY_HOST=hub.local.com -e ENV_DOCKER_REGISTRY_PORT=80 hub.local.com/konradkleine/docker-registry-frontend:v2
```