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

