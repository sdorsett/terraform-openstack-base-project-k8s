resource "null_resource" "remove-ansible-transfer-directory" {
    provisioner "local-exec" {
        command = "rm -rf ./ansible/transfer/*"
    }
}

resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/hosts ansible/site.yml",
  }
  depends_on = [ "null_resource.add-haproxy-to-ansible-hosts" ]
}

