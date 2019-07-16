variable "private_key" {
  default = "/root/.ssh/id_rsa-deploy-k8s"
}

variable "public_key" {
  default = "/root/.ssh/id_rsa-deploy-k8s.pub"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "network-identifier" {
  default = "infra-internal"
}
