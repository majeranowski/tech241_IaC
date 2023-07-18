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