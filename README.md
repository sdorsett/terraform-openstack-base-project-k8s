# terraform-openstack-kubernetes

The repository contains Terraform configurations for deploying the a Kubernetes HA deployment on openstack with:
- 1 haproxy api virtual machine
- 3 etcd virtual machines
- 3 kubernetes controller virtual machines
- 3 kubernetes worker nodes

In order to run these Terraform configurations you will need to have:
1. An openstack account and openrc.sh file for that account download.
2. The python openstack client installed on the deploying system
2. Ansible installed on the deploying system

Source the openrc.sh file for you openstack account, provide the password for the Openstack user and run `terraform plan` to test connecting to OVH public cloud.

