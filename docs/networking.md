# Networking

<a name="vm-network"></a>
## VM network settings

The default box private network IP is `192.168.10.10`.
To map additional IP addresses for use with multiple projects open `vagrant.yml` and ucomment respective lines:

```yaml
hosts:
    - ip: 192.168.10.11
    - ip: 192.168.10.12
    - ip: 192.168.10.13
```

Project specific `<IP>:<port>` mapping for containers is done in via docker-compose in `docker-compose.yml`

<a name="vhost-proxy"></a>
## vhost-proxy

As an alternative to using dedicated IPs for different projects a built-in vhost-proxy container can be used.  
It binds to `192.168.10.10:80` (the default box IP address) and routes web requests based on the `Host` header.

### How to use
- Set `vhost_proxy: true` in your vagrant.yml file and do a 'vagrant reload'
- Set the `VIRTUAL_HOST` environment variable for the web container in your setup (e.g. `VIRTUAL_HOST=example.com`)
- Add an entry in your hosts file (e.g. `/etc/hosts`) to point the domain to the default box IP (`192.168.10.10`)
  - As an alternative see [Wildcard DNS](#dns) instructions below
- Multiple domain names can be separated by comas: `VIRTUAL_HOST=example.com,www.example.com`

Example docker run

```
docker run --name nginx -d -e "VIRTUAL_HOST=example.com" nginx:latest
```

Example docker-compose.yml entry

```
# Web node
web:
  image: nginx:latest
  ports:
    - "80"
  environment:
    - VIRTUAL_HOST=example.com
```

Example hosts file entry

```
192.168.10.10  example.com
```

It is completely fine to use both the vhost-proxy approach and the dedicated IPs approach concurently:
 - `"80"` - expose port "80", docker will randomly pick an available port on the Docker Host
 - `"192.168.10.11:80:80"` - dedicated IP:port mapping

<a name="dns"></a>
## DNS and service discovery

### DNS resolution

The built-in `dns` container can be used to resolve all `*.drude` domain names to `192.168.10.10` (VM's primary IP address), where vhost-proxy listens on port 80.

**Mac**

```
sudo mkdir -p /etc/resolver
echo -e "\n# .drude domain resolution\nnameserver 192.168.10.10" | sudo tee -a  /etc/resolver/drude
```

**Windows**

On Windows add `192.168.10.10` as the primary DNS server and your LAN/ISP/Google DNS as secondary.


### Service discovery

The built-in `dns` container can also be used for local DNS based service discovery.  
You can define an arbitrary domain name via the `DOMAIN_NAME` environment variable for any container and it will be resolved to the internal IP address of that container.

**Example**

```
docker run --name nginx -d -e "DOMAIN_NAME=my-project.web.docker" nginx:latest
docker run busybox ping my-project.web.docker -c 1
```

```
PING my_project.web.docker (172.17.42.8): 56 data bytes
64 bytes from 172.17.42.8: seq=0 ttl=64 time=0.052 ms
...

```

Multiple domain names can be separated by comas: `DOMAIN_NAME=my-project.web.docker,www.my-project.web.docker`
