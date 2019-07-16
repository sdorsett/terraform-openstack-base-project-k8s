resource "null_resource" "generate-sshkey" {
    provisioner "local-exec" {
        command = "yes y | ssh-keygen -b 4096 -t rsa -C 'deploy-k8s' -N '' -f ${var.private_key}"
    }
}

resource "null_resource" "remove-ansible-hosts-file" {
    provisioner "local-exec" {
        command = "rm -rf ./ansible/hosts"
    }
}

resource "null_resource" "remove-ansible-transfer-directory" {
    provisioner "local-exec" {
        command = "rm -rf ./ansible/transfer/*"
    }
}

resource "null_resource" "add-workers-block-to-ansible-hosts" {
  provisioner "local-exec" {
    command = "echo '[workers]' >> ansible/hosts",
  }
  depends_on = ["openstack_compute_instance_v2.workers","openstack_compute_instance_v2.controllers","openstack_compute_instance_v2.haproxy"]
}

resource "null_resource" "add-workers-to-ansible-hosts" {
  count            = 3
  provisioner "local-exec" {
    command = "echo ${element(openstack_compute_instance_v2.workers.*.name, count.index)} ansible_host=${element(openstack_compute_instance_v2.workers.*.access_ip_v4, count.index)} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.private_key} internal_ip_address=${element(openstack_compute_instance_v2.workers.*.network.1.fixed_ip_v4, count.index)} external_ip_address=${element(openstack_compute_instance_v2.workers.*.access_ip_v4, count.index)}  >> ansible/hosts",
  }
  depends_on = ["null_resource.add-workers-block-to-ansible-hosts"]
}

resource "null_resource" "add-controllers-block-to-ansible-hosts" {
  provisioner "local-exec" {
    command = "echo '[controllers]' >> ansible/hosts",
  }
  depends_on = [ "null_resource.add-workers-to-ansible-hosts" ]
}

resource "null_resource" "add-controllers-to-ansible-hosts" {
  count            = 3
  provisioner "local-exec" {
    command = "echo ${element(openstack_compute_instance_v2.controllers.*.name, count.index)} ansible_host=${element(openstack_compute_instance_v2.controllers.*.access_ip_v4, count.index)} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.private_key} internal_ip_address=${element(openstack_compute_instance_v2.controllers.*.network.1.fixed_ip_v4, count.index)} external_ip_address=${element(openstack_compute_instance_v2.controllers.*.access_ip_v4, count.index)} >> ansible/hosts",
  }
  depends_on = ["null_resource.add-controllers-block-to-ansible-hosts"]
}

resource "null_resource" "add-etcd-block-to-ansible-hosts" {
  provisioner "local-exec" {
    command = "echo '[etcd]' >> ansible/hosts",
  }
  depends_on = [ "null_resource.add-controllers-to-ansible-hosts" ]
}

resource "null_resource" "add-etcd-to-ansible-hosts" {
  count            = 3
  provisioner "local-exec" {
    command = "echo ${element(openstack_compute_instance_v2.etcd.*.name, count.index)} ansible_host=${element(openstack_compute_instance_v2.etcd.*.access_ip_v4, count.index)} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.private_key} internal_ip_address=${element(openstack_compute_instance_v2.etcd.*.network.1.fixed_ip_v4, count.index)} external_ip_address=${element(openstack_compute_instance_v2.etcd.*.access_ip_v4, count.index)} >> ansible/hosts",
  }
  depends_on = ["null_resource.add-etcd-block-to-ansible-hosts"]
}

resource "null_resource" "add-haproxy-to-ansible-hosts" {
  provisioner "local-exec" {
    command = "echo '[haproxies]' >> ansible/hosts; echo ${openstack_compute_instance_v2.haproxy.name} ansible_host=${openstack_compute_instance_v2.haproxy.access_ip_v4} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.private_key}  internal_ip_address=${openstack_compute_instance_v2.haproxy.network.1.fixed_ip_v4} external_ip_address=${openstack_compute_instance_v2.haproxy.access_ip_v4} >> ansible/hosts",
  }
  depends_on = [ "null_resource.add-etcd-to-ansible-hosts" ]
}

resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/hosts ansible/site.yml",
  }
  depends_on = [ "null_resource.add-haproxy-to-ansible-hosts" ]
}

