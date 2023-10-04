### Intro

### Tested

Tested on MacOS 13.6 with Terraform 1.5.7. I've probably done something which complicates setup using Windows machines.

### Prerequisites
- An instance of [Apstra CloudLabs](https://cloudlabs.apstra.com/) *Juniper Customer Lab* AOS_4.1.2_OB up and running.
- [Github](https://github.com) account with a [trusted ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) on your workstation.
- A [Tailscale](https://tailscale.com) account. Your workstation needs to be attached to the tailnet. If you don't have one, it's a trivial setup.
- [Terraform installed](https://developer.hashicorp.com/terraform/downloads) on your workstation.
- Git installed on your workstation.

### Workstation Setup
1. Clone this repo, and change directory into it, and set a variable so we can find our way back here:
   ```shell
   git clone https://github.com/chrismarget-j/cfd18
   cd cfd18
   CFD18=`pwd`
   ```
2. Link the SSH private key trusted by github (the file without a `.pub` suffix) to the place this project expects to
   find it:
   ```shell
   ln -s ~/.ssh/<key_file> ${CFD18}/.ssh_key
   ```
   The ssh key winds up trusted by the servers in CloudLabs and we use it only when authenticating with them. The key
   will never leave your workstation, nor be copied into any other file.
3. Add the following to your ~/.ssh/config for the CloudLabs virtual servers:
   ```
   Host s1 s2 s3 s4
     User admin
     StrictHostKeyChecking no
     UserKnownHostsFile /dev/null
     IdentityFile ~/.ssh/<github_ssh_private_key>
   ```
4. Add Apstra API reachability info to your environment. The username and password are on the CloudLabs
topology info page under *Predefined & Quick Actions* -> *Apstra UI*, and the URL can be found by
clicking the green [Open In New Tab] button on that same page, then noting the URL in the browser:
   ```shell
   export APSTRA_USER=admin
   export APSTRA_PASS=AdjectiveAnimalNumberSymbol
   export APSTRA_URL=https://<ip_address>:<port_number>
   ```

### CloudLabs Setup
In this step we install Docker and establish reachability to the Docker worker VMs inside the
CloudLabs topology so that Terraform can add and remove workload on these VMs. It's all handled by
the `host_services.exp` and `host_services.sh` scripts, and boils down to:

- Setup tailscale so terraform can reach those VMs directly.
- Trust your public key, retrieved from github by your username.
- Install docker on those VMs.

The expect script needs to have the following three arguments passed to it:
- `ip:port` representing the CloudLabs internet-facing menu system for your topology. Get this from
  the CloudLabs topology info page in the *SSH access to VMs* box. We only want `ip:port`, here not
  the whole SSH url.
- Your github username.
- The specific VM hostname: `s1`, `s2`, `s3`, or `s4`.

Run it for each VM (s1-4) like this:

```shell
./host_services.exp ip.ip.ip.ip:port githubusername s1
```

You'll probably want to open four tabs so the process runs on all four VMs (`s1` through `s4`) in
parallel. Each one takes a few minutes to complete.

After Tailscale is installed (about halfway through the process) each VM will display a URL which
adds the VM to your tailnet. Follow the URL. Once the VM is authorized, it will continue on with 
installing Docker.

When the expect script's work is complete, it will leave you at a `admin@localhost:~$` prompt. At
this point you can log out of the VM (`exit`) and test login with `ssh s1` (or `s2`, etc...)
You should be logged directly into the VM without any prompts for authentication, keys, etc...

### Run The `setup_docker` Terraform Project

This Terraform project ensures that each Docker worker node has a local copy of the "application
workload" containers we'll be running, along with a little bit of customization we want on those
containers. We preload the containers so that we don't experience deploy failures later if we
happen to get rate-limited by docker hub.

```shell
cd ${CFD18}/setup_docker  # change to the terraform project directory
terraform init   # fetch any required terraform providers and modules
terraform appply # run the project
```

> **_NOTE_**
> 
> You may encounter an error like this:
> 
>> `Error pinging Docker server: error during connect: Get "http://s1:2375/_ping": dial tcp: lookup s1 on 8.8.8.8:53: no such host` 
> 
> It indicates a name resolution problem experienced by the Terraform provider for Docker.
It should be possible to interact with `s1` through `s4` using `ping`, `ssh`,
`curl http://s1:2375/containers/json`, etc... Name resolution is faciliated by
[Tailscale's Magic DNS](https://tailscale.com/kb/1081/magicdns/) feature. If those tests
work, but Docker/Terraform errors persist, quitting and then restarting Tailscale may help.
I've found I have to jump though this hoop each time I start or stop the corporate VPN on
"my" laptop.

> **_NOTE_**
> 
> Docker Hub errors at this stage may be due to the Docker Hub [rate limit](https://docs.docker.com/docker-hub/download-rate-limit/).
> It's the reason image fetch onto the worker nodes is a separate project. Try again
> shortly, it'll probably start working.

### Run The `setup_fabric` Terraform Project

At this point, your CloudLabs topology consists of:
- An un-configured Apstra server
- 5 virtual switches (un-configured)
- 4 VMs running Docker with locally cached container images
- 11 virtual Ethernet cables interconnecting the switches and Docker VMs
- IP reachability for management between all of the following:
  - Your workstation (the automation orchestrator)
  - The Apstra VM
  - The virtual switch out-of-band management interfaces
  - The Docker VMs management interfaces

It's time to set up the fabric. This means informing Apstra about the switches and servers we'll be using, and the
connectivity between them, setting up some initial IP and ASN pool info, creating the Blueprint, starting a load
balancer, and so forth.

```shell
cd ${CFD18}/setup_docker  # change to the terraform project directory
terraform init            # fetch any required terraform providers and modules
terraform appply          # run the project
```

Now might be a good time to log into the Apstra web UI to check out the work we've done so far:

| UI Location                                                               | Expected Result                                                                                                                                                                      |
|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Devices -> Managed Devices                                                | 5 switches with green *Acknowledged* checkmarks                                                                                                                                      |
| Design -> Rack Types                                                      | Created *CFD 18 Rack*                                                                                                                                                                |
| Devices -> Managed Devices                                                | 5 switches with green *Acknowledged* checkmarks                                                                                                                                      |
| Design -> Rack Types                                                      | Created *CFD 18 Rack*                                                                                                                                                                |
| Design -> Templates                                                       | Created *CFD 18 Rack*                                                                                                                                                                |
| Resources -> IP Pools                                                     | *CFD 18 Applications IPv4 Pool* with the CIDR blocks specified in `local.tf`                                                                                                         |
| Blueprints                                                                | Created *CFD 18*                                                                                                                                                                     |
| Blueprints -> CFD 18 -> Dashboard                                         | Green flags everywhere, no anomalies                                                                                                                                                 |
| Blueprints -> CFD 18 -> Staged -> Physical -> Resources                   | Various ASN and IP pools assigned                                                                                                                                                    |
| Blueprints -> CFD 18 -> Staged -> Physical -> Device Profiles             | Each switch has a device profile assigned                                                                                                                                            |
| Blueprints -> CFD 18 -> Staged -> Physical -> Devices                     | Each switch has a specific "physical" asset assigned by serial number                                                                                                                |
| Blueprints -> CFD 18 -> Staged -> Physical -> Devices                     | In-rack servers S1-S3, and external server S4 (these were not in the template) have been added to the topology.                                                                      |
| Blueprints -> CFD 18 -> Staged -> Virtual -> Routing Zones                | The "cfd_18" routing zone has been created and has IP addresses assigned                                                                                                             |
| Blueprints -> CFD 18 -> Staged -> Virtual -> Virtual Networks             | A "services" network for the load balancer                                                                                                                                           |
| Blueprints -> CFD 18 -> Staged -> Virtual -> Virtual Networks -> services | The "services" network uses IPs from our pool (selected by Apstra), has a VLAN assigned (selected by Apstra) on all 3 leaf switches, and has server S4 connected via tagged handoff. |
| Blueprints -> CFD 18 -> Staged -> Connectivity Templates                  | The "services" network has tagged and untagged connectivity templates, with one being applied to S4's eth1 interface.                                                                |
| Blueprints -> CFD 18 -> Time Voyager                                      | Fabric deployed by Terraform                                                                                                                                                         |

In addition to the work done inside Apstra, the load balancer host (S4) has been configured with details *chosen by Apstra*:

> The Load Balancer host has a tagged handoff to the Apstra-selected VLAN (3, in this case):
> ```shell
> admin@s4:~$ ip -o link list | grep @eth1
> 14: eth1.3@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000\    link/ether 52:54:00:f3:ec:6d brd ff:ff:ff:ff:ff:ff
> admin@s4:~$ 
> ```

> The Load Balancer host has a an IP presence on that subinterface, connecting it to the LB net:
> ```shell
> admin@s4:~$ ip -4 -o addr list dev eth1.3
> 14: eth1.3    inet 172.29.0.10/24 scope global eth1.3\       valid_lft forever preferred_lft forever
> admin@s4:~$
> ```

> The Load Balancer host has static routes for all of the CIDR blocks in the *CFD 18 Applications* pool:
> ```shell
> admin@s4:~$ ip route list dev eth1.3
> 172.29.0.0/24 proto kernel scope link src 172.29.0.10
> 172.29.0.0/16 via 172.29.0.1
> 172.30.0.0/16 via 172.29.0.1
> 172.31.0.0/16 via 172.31.0.1
> admin@s4:~$
> ```

So far, so good. But this is just baseline setup. We're devops-y *application owners* in this scenario.
Let's deploy an application...

### Run The `deploy_nginx` Terraform Project

Finally, we're at the state were we can demonstrate seamlessly integrating cloud-style network operations
into application deployments. Everything up to this point was prerequisite work because Apstra doesn't
come with Docker, a ready-to-go load balancer, and do forth.

This is the point where we enter "a day in the life of an app-deploy/devops/SRE person".

The `deploy_nginx` project imagines itself a real application deployment.

It uses Apstra to create an application-specific subnet using EVPN overlay on our switching fabric,
exposes that subnet via tagged handoff at the docker nodes, configures a matching (subnet, IPAM, tagged
handoff) docker network on the docker nodes, deploys application containers (nginx) on the docker nodes,
and configures the load balancer to steer traffic towards those containers.

> **_Note:_**
> We're making use of Apstra resource pool capability (*Some* VLAN ID, I don't care! Break me off the
next available /24 to use there!), but of course we could be prescriptive if we'd rather get type these
values in, fetch them from an IPAM or whatever.

```shell
cd ${CFD18}/deploy_nginx  # change to the terraform project directory
terraform init            # fetch any required terraform providers and modules
terraform appply          # run the project
```

After deployment visit "the application" by pointing your browser at [the load balancer](http://s4).
Each application instance uses a different color background. Reloading the page should make it apparent
that you're hitting each of them. The load balancer stats page is [here](http://s4:8404/stats)