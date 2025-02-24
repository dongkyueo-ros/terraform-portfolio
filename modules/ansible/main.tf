
resource "null_resource" "bastion_remote_exec" {
  // Bastion 인스턴스가 생성된 후 실행되는 프로비저너
  provisioner "file" {
    source      = "${path.module}/.ssh/${var.ssh_private_key}"
    destination = "/home/${var.username}/${var.ssh_private_key}"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file("${path.module}/.ssh/${var.ssh_private_key}")
      host        = var.bastion_public_eip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/${var.username}/ansible/.ssh",
      "sudo mv /home/${var.username}/${var.ssh_private_key} /home/${var.username}/ansible/.ssh/${var.ssh_private_key}",
      "sudo chmod 600 /home/${var.username}/ansible/.ssh/${var.ssh_private_key}",
      "cd /home/${var.username}/ansible",
      "sudo sed -i 's/\\bbastion_ip\\b/${var.bastion_public_eip}/g' inventory/inventory.ini",
      "sudo sed -i '/\\[all:vars\\]/a cluster_name=${var.cluster_name}\\naws_account_id=${var.aws_account_id}' inventory/inventory.ini",
      "sudo sed -i 's/\\bbastion_ip\\b/${var.bastion_public_eip}/g' playbooks/group_vars/all.yml",
      "sudo sed -i 's/\\baccount_id\\b/${var.aws_account_id}/g' playbooks/group_vars/all.yml",
      "sudo sed -i 's/\\beks_cluster_name\\b/${var.cluster_name}/g' playbooks/group_vars/all.yml",
      "sudo sed -i 's/\\bnode_group\\b/${var.cluster_workernode_release}/g' playbooks/group_vars/all.yml",
      "sudo sed -i 's/\\bvpc_id\\b/${var.vpc_id}/g' playbooks/group_vars/all.yml",
      "sudo sed -i 's/\\bhosted_zone_id\\b/${var.hosted_zone_id}/g' playbooks/group_vars/all.yml",
      #"sudo sed -i 's/eks_nodes_private_dns:.*/eks_nodes_private_dns:\\n  - ${join("\\n  - ", var.eks_nodes_private_dns)}/' playbooks/group_vars/all.yml",
      "sudo ansible-playbook -i inventory/inventory.ini playbooks/eks_deploy.yml"
    ]

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file("${path.module}/.ssh/${var.ssh_private_key}")
      host        = var.bastion_public_eip
    }
  }
  depends_on = [var.bastion_id]
}
