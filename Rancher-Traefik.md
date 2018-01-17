# Rancher Traefik
### Key images list
> Rancher Server v1.6.12
> Rancher Agent v1.2.7

### Steps
* Website service lables
```
traefik.enable=true
traefik.port=3000
traefik.frontend.rule=Host:nginx.local.com
```

* Make sure domain ***nginx.local.com*** refer to the server IP which running traefik.
* Visit your websit using URL [http://nginx.local.com](http://nginx.local.com/) now.
