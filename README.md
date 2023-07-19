# Infrastructure as Code (IaC)

IaC stands for Infrastructure as Code. It is an approach to managing and provisioning infrastructure resources using machine-readable configuration files or scripts rather than manual processes.

Traditionally, when setting up and managing infrastructure, such as servers, networks, and storage, it would involve manual configuration and management through a series of manual steps or scripts. This manual approach can be time-consuming, error-prone, and difficult to reproduce consistently.

With Infrastructure as Code, infrastructure resources are defined, configured, and managed using code. This code is typically written in a domain-specific language (DSL) or a general-purpose programming language, such as YAML, JSON, or even programming languages like Python or Ruby.

# Ansible

What is it?

A configuration manager tool used in DevOps. It is simple. It is agent-less. No dependencies needed for it to run. Lightweight.

Ansible is an open-source automation tool that provides a simple, agentless, and powerful platform for managing and automating IT infrastructure and configuration management tasks. It is designed to streamline and simplify the process of deploying, configuring, and orchestrating systems and applications.

ansible default folder - to make changes in configuration file

cd /etc/ansible/

# Ansible Architecture

![](images/ansible.png)


* Step 1: Let's start with creating EC2 instances on AWS. 1 for ansible controller and 2nd and 3rd for agend nodes for app and db.
   - All Of them should have SSH security group rules and Ubuntu 18.04 (because it has python already preinstalled (the only dependencies for Ansible))

![](./images/1.png)

* Step 2: SSH in manually to Node Controller and install ansible:
  - Run update and upgrade commands:

```bash
sudo apt update -y
sudo apt upgrade -y
``` 

* Step 3: Install Ansible

```bash
 sudo apt-add-repository ppa:ansible/ansible
 sudo apt install ansible -y
 sudo apt update -y
```

* Step 4: go back to controller VM and create a .pem file in ~/.ssh/ folder called tech241.

* Step 5: Manually SSH in to app and db VMs (agent nodes) from our controller VM and run update and upgrade commands to make agents available to connect

```bash
sudo apt update -y
sudo apt upgrade -y
``` 



* Step 6: Go to default directory for ansible to configure hosts file that wil allow connection between controller and agents

```bash
cd /etc/ansible/

sudo nano hosts

```

  - In the file add app and db VMs

```bash
# Ex 2: A collection of hosts belonging to the 'webservers' group
[web]

ec2-instance ansible_host=34.244.62.102 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech241.pem

[db]

ec2-instance ansible_host=34.249.203.43 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech241.pem

```

![](images/5.png)

* Step 7: Test the connection between controller and agents.

```bash
sudo ansible web -m ping
sudo ansible db -m ping

```

![](images/6.png)

SUCCESS!

# adhock commands

Ad-hoc commands in the context of Ansible refer to one-line commands that you can run from the command line without the need for writing a separate Ansible playbook or script. These commands allow you to perform quick tasks or execute specific modules on remote servers.

We don't need to ssh manually to each system. keeping process system. 

we need sudo permission

-a - argument of what command we should run on agent

`sudo ansible web -a "uname -a"` - checking os version on agent node

`sudo ansible web -a "date"` - checking time zone on agent node.

`sudo ansible web -a "free"` - checking free space on agent node

`sudo ansible web -a "ls -a"` - checking what is installed on agent

`sudo ansible web -m ansible.builtin.copy -a "src=/etc/ansible/test.txt dest=~"` - copy a test.txt file from controller node to agend home folder. on controller file was in ansible folder.

## Scripting in Ansible

Web-node:
install nginx
node security group must allow port 80

Playbooks - scripts

need to be in default location /etc/ansible

`sudo nano nginx.yml` - to create YAML script file

```YAML
# YAML file start with --- thre dashes
# Why playbooks
# Create a playbook to install nginx in web node
---

# Which host to perform the task
- hosts: web

# see the logs by gathering facts
  gather_facts: yes
# admin access (sudo)
  become: true
# add the instructions  -  install nginx on web agent
  tasks:
  - name: Installing nginx
    apt: pkg=nginx state=present
# check the status of nginx - ensure is actively running

# adhoc command to check the status


```

`sudo ansible-playbook nginx.yml`

RESPONSE:

```bash
PLAY [web] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ec2-instance]

TASK [Installing nginx] ********************************************************
changed: [ec2-instance]

PLAY RECAP *********************************************************************
ec2-instance               : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

HOSTS FILE:

```bash
# This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups

# Ex 1: Ungrouped hosts, specify before any group headers.

## green.example.com
## blue.example.com
## 192.168.100.1
## 192.168.100.10

# Ex 2: A collection of hosts belonging to the 'webservers' group

[web]

ec2-instance ansible_host=34.242.248.77 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech241.pem

[db]

ec2-instance ansible_host=54.246.248.58 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tech241.pem


## [webservers]
## alpha.example.org
## beta.example.org
## 192.168.1.100
## 192.168.1.110

```