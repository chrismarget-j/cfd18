## Server Links

| server | interface | interface | switch         |
|--------|-----------|-----------|----------------|
| s1     | eth1      | ge-0/0/3  | rack_001_leaf1 |
| s2     | eth1      | ge-0/0/3  | rack_002_leaf1 |
| s3     | eth1      | ge-0/0/2  | rack_003_leaf1 |
| s4     | eth1      | ge-0/0/2  | rack_001_leaf1 |
| s4     | eth2      | ge-0/0/2  | rack_002_leaf1 |

## Install Tailscale on each VM
```shell
sudo apt-get update && \
sudo apt-get install -y ca-certificates && \
curl -fsSL https://tailscale.com/install.sh | sh && \
sudo tailscale up
```

## Create SSH Key
```shell
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_cfd18
```

## Configure Local SSH Client
```shell
for i in $(seq 0 3)
do
  host=s$(($i+1))
  echo -n "Host $host\n Hostname localhost-$i\n User admin\n IdentityFile ~/.ssh/id_ed25519_cfd18\n\n"
done >> ~/.ssh/config
```

## Copy SSH Key To Server
```shell
for i in $(seq 4)
do
  ssh-copy-id -i ~/.ssh/id_ed25519_cfd18.pub s$i
done
```
