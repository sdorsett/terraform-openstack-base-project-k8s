resource "openstack_compute_instance_v2" "haproxy" {
  name            = "haproxy"
  image_id        = data.openstack_images_image_v2.ubuntu_18_04.id
  flavor_id       = data.openstack_compute_flavor_v2.sandbox.id
  key_pair        = data.openstack_compute_keypair_v2.deploy-keypair.name
  security_groups = [openstack_compute_secgroup_v2.deploy-k8s-allow-external-6443.name]
  user_data       = templatefile("${path.module}/cloud-init.tpl", { private_ip = "10.240.0.9" })

  network {
    name = "Ext-Net"
  }

  network {
    name        = data.openstack_networking_network_v2.default-internal.name
    fixed_ip_v4 = "10.240.0.9"
  }

  metadata = {
    group = "haproxies"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname -f",
    ]
    connection {
      host        = coalesce(self.access_ip_v4, self.access_ip_v6)
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key)
    }
  }
}

