provider "openstack" {}

data "openstack_images_image_v2" "ubuntu_18_04" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_compute_flavor_v2" "s1-2" {
  name = "s1-8"
}

resource "openstack_compute_instance_v2" "controllers" {
  count           = 3
  name            = "controller-${count.index}"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${openstack_compute_keypair_v2.deploy-k8s-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.deploy-k8s-allow-external-ssh.name}"]

  network {
    name = "Ext-Net",
  }

  network {
    name = "${data.openstack_networking_network_v2.infra-internal.name}"
    fixed_ip_v4 = "10.240.0.1${count.index}"
  }

  metadata {
    deploy-k8s = "controller"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname -f",
    ]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

}

resource "openstack_compute_instance_v2" "workers" {
  count           = 3
  name            = "worker-${count.index}"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${openstack_compute_keypair_v2.deploy-k8s-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.deploy-k8s-allow-external-ssh.name}"]

  network {
    name = "Ext-Net",
  }

  network {
    name = "${data.openstack_networking_network_v2.infra-internal.name}"
    fixed_ip_v4 = "10.240.0.2${count.index}"
  }

  metadata {
    deploy-k8s = "worker"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname -f",
    ]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

}

resource "openstack_compute_instance_v2" "etcd" {
  count           = 3
  name            = "etcd-${count.index}"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${openstack_compute_keypair_v2.deploy-k8s-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.deploy-k8s-allow-external-ssh.name}"]

  network {
    name = "Ext-Net",
  }

  network {
    name = "${data.openstack_networking_network_v2.infra-internal.name}"
    fixed_ip_v4 = "10.240.0.3${count.index}"
  }

  metadata {
    deploy-k8s = "controller"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname -f",
    ]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

}
