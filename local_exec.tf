resource "null_resource" "remove-ansible-transfer-directory" {
    provisioner "local-exec" {
        command = "rm -rf ./ansible/transfer/*"
    }
}

resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./openstack_inventory.py ansible/site.yml"
  }
  depends_on = ["openstack_compute_instance_v2.workers","openstack_compute_instance_v2.controllers","openstack_compute_instance_v2.haproxy","openstack_compute_instance_v2.etcd"]
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "${chomp(data.http.myip.body)}/32"
  security_group_id = "${openstack_compute_secgroup_v2.deploy-k8s-allow-external-ssh.id}"
}
