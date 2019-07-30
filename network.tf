provider "openstack" {
}

data "openstack_images_image_v2" "ubuntu_18_04" {
  name        = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_compute_flavor_v2" "sandbox" {
  name = "s1-8"
}

data "openstack_compute_keypair_v2" "deploy-keypair" {
  name = "deploy-keypair"
}

resource "openstack_compute_secgroup_v2" "deploy-k8s-allow-external-6443" {
  name        = "deploy-k8s-allow-external-6443"
  description = "permitted inbound external TCP 6443 traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "10.240.0.0/24"
  }
}

resource "openstack_compute_secgroup_v2" "deploy-k8s-allow-external-ssh" {
  name        = "deploy-k8s-allow-external-ssh"
  description = "permitted inbound ssh traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "10.240.0.0/24"
  }
}

data "openstack_networking_network_v2" "default-internal" {
  name = var.network-identifier
}

data "openstack_networking_subnet_v2" "default-internal-subnet" {
  name       = var.network-identifier
  ip_version = 4
}

