---
layout: default
title: Vaprobash
home: true
---

**Va**grant **Pro**visioning **Bash** Scripts

## Quickstart

1\. Download the Vagrantfile

```bash
$ curl -L http://bit.ly/vaprobash > Vagrantfile
```

2\. Edit the Vagrantfile. Uncomment whichever you'd like to install.

```ruby
#Install Base
config.vm.provision "shell", path: "..."

#Install Apache
config.vm.provision "shell", path: "...", args: server_ip

# But leave Nginx commented out
# config.vm.provision "shell", path: "...", args: server_ip
```

3\. Vagrant up!

```bash
$ vagrant up
```        