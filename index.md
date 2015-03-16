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

## Requirements

* Vagrant `1.5.0`+
	* You can check your vagrant version by running `vagrant -v` in your terminal
* VirtualBox or VMWare Fusion

## Screencasts

### Quickstart
<iframe src="//player.vimeo.com/video/85876881" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/85876881">Vaprobash Quickstart</a> from <a href="http://vimeo.com/fideloper">Chris Fidao</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

### Apache Virtual Hosts Configuration
<iframe src="//player.vimeo.com/video/85983902" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/85983902">Apache Virtual Hosts with Vaprobash</a> from <a href="http://vimeo.com/fideloper">Chris Fidao</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

### Laravel with Vaprobash
<iframe src="//player.vimeo.com/video/85984418" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/85984418">Laravel with Vaprobash</a> from <a href="http://vimeo.com/fideloper">Chris Fidao</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
