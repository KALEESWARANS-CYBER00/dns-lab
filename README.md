# DNS Lab

This lab demonstrates a full DNS resolution workflow using Docker.

## Containers

| Container   | Role                     | IP Address       |
|------------|-------------------------|----------------|
| auth-dns   | Authoritative DNS        | 172.25.0.10    |
| rec-dns    | Recursive Resolver       | 172.25.0.20    |
| dns-client | Client (testing)         | 172.25.0.30    |

## Setup

```bash
chmod +x install.sh
./install.sh
````

* The client will have `dnsutils` installed and will query the recursive resolver.
* TTL caching and iterative resolution can be tested using `dig`.

## Example Queries (inside client)

```bash
dig @172.25.0.20 www.labcyberdoom.local A
dig @172.25.0.20 mail.labcyberdoom.local MX
dig @172.25.0.20 blog.labcyberdoom.local A
```

## Optional: Monitor queries (inside rec-dns)

```bash
docker exec -it rec-dns bash
apt update && apt install -y tcpdump
tcpdump -i any port 53 -vv
```

## Author / Contact

* [LinkedIn](https://www.linkedin.com/in/kaleeswarans25)
* [GitHub](https://github.com/KALEESWARANS-CYBER00/)

