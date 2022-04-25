################################################
# SSH Key
################################################

locals {
  private_key_file = var.private_key_file != "" ? var.private_key_file : "files/user-data/key-pair/id_rsa"
  public_key_file  = var.public_key_file != "" ? var.public_key_file : "files/user-data/key-pair/id_rsa"
}

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


output "tls_private_key" {
  value = tls_private_key.global_key
}

resource "null_resource" "mkdirs" {
  # Removing always triggers from the main module.
  provisioner "local-exec" {
    command = "mkdir -p ${dirname(local.private_key_file)}; mkdir -p ${dirname(local.public_key_file)}"
  }
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  depends_on = [
    null_resource.mkdirs,
  ]
  filename        = local.private_key_file
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  depends_on = [
    null_resource.mkdirs,
  ]
  filename = local.public_key_file
  content  = tls_private_key.global_key.public_key_openssh
}

resource "aws_key_pair" "this" {
  depends_on = [
    null_resource.mkdirs,
  ]
  key_name_prefix = "${module.this.id}-keypair"
  public_key      = tls_private_key.global_key.public_key_openssh
}

output "aws_key_pair" {
  value = aws_key_pair.this
}

output "aws_key_pair_private" {
  value = local.private_key_file
}

output "aws_key_pair_public" {
  value = local.public_key_file
}
