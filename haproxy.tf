resource "openstack_compute_instance_v2" "haproxy" {
  name            = "haproxy"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${openstack_compute_keypair_v2.deploy-k8s-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.deploy-k8s-allow-external-6443.name}"]

  network {
    name = "Ext-Net",
  }

  network {
    name = "${data.openstack_networking_network_v2.infra-internal.name}"
    fixed_ip_v4 = "10.240.0.9"
  }

  metadata {
    deploy-k8s = "haproxy"
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
