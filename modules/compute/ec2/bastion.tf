resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.bastion_ami.id
  instance_type          = "t2.micro"
  subnet_id              = element(var.pb_subnet_ids, 0)
  key_name               = "eks_bastion_api"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  #user_data              =  base64encode(file("${path.module}/user-data/bastion.sh"))

  // Bastion 인스턴스가 생성된 후 실행되는 프로비저너
  # provisioner "file" {
  #   source      = "${path.module}/.ssh/${var.ssh_private_key}"
  #   destination = "/home/${var.username}/${var.ssh_private_key}"
  #   connection {
  #     type        = "ssh"
  #     user        = var.username
  #     private_key = file("${path.module}/.ssh/${var.ssh_private_key}")
  #     host        = self.public_ip
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mkdir -p /home/${var.username}/ansible/.ssh",
  #     "sudo mv /home/${var.username}/${var.ssh_private_key} /home/${var.username}/ansible/.ssh/${var.ssh_private_key}",
  #     "sudo chmod 600 /home/${var.username}/ansible/.ssh/${var.ssh_private_key}",
  #     "cd /home/${var.username}/ansible",
  #     "sudo sed -i 's/\\bbastion_ip\\b/${self.public_ip}/g' inventory/inventory.ini",
  #     "sudo sed -i '/\\[all:vars\\]/a cluster_name=${var.cluster_name}\\naws_account_id=${var.aws_account_id}' inventory/inventory.ini",
  #     "sudo sed -i 's/\\bbastion_ip\\b/${self.public_ip}/g' playbooks/group_vars/all.yml",
  #     "sudo sed -i 's/\\baws_account_id\\b/${var.aws_account_id}/g' playbooks/group_vars/all.yml",
  #     "sudo sed -i 's/\\bnode_group\\b/${var.cluster_workernode_release}/g' playbooks/group_vars/all.yml",
  #     "sudo sed -i 's/\\baws_vpc_id\\b/${var.vpc_id}/g' playbooks/group_vars/all.yml",
  #     #"sudo sed -i 's/eks_nodes_private_dns:.*/eks_nodes_private_dns:\\n  - ${join("\\n  - ", var.eks_nodes_private_dns)}/' playbooks/group_vars/all.yml",
  #     "sudo ansible-playbook -i inventory/inventory.ini playbooks/eks_deploy.yml"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = var.username
  #     private_key = file("${path.module}/.ssh/${var.ssh_private_key}")
  #     host        = self.public_ip
  #   }
  # }
  
  tags = {
    Name = "ec2-${var.environment}-${var.aws_region}a-${var.project}-bastion"
    Role = "bastion"
  }
  depends_on = [var.cluster_workernode_release]
}

// Bastion EIP
resource "aws_eip" "bastion" {  
  domain    = "vpc"
  instance  = aws_instance.bastion.id

  tags = {
    Name = "eip-${var.environment}-${var.aws_region}a-${var.project}-pub-bastion"
  }
}

// Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-${var.aws_region}-${var.project}-bastion-sg"
  description = "Security group for Bastion allowing SSH from company and Terraform Cloud IP ranges"
  vpc_id      = var.vpc_id

  // 회사 IP 범위에 대한 SSH 허용
  dynamic "ingress" {
    for_each = var.company_ip_ranges
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Allow SSH access from company IP ranges"
    }
  }

  // Terraform Cloud IP 범위에 대한 SSH 및 HTTPS 허용
  dynamic "ingress" {
    for_each = concat(
      local.terraform_cloud_ip_ranges.api,
      local.terraform_cloud_ip_ranges.notifications,
      local.terraform_cloud_ip_ranges.sentinel,
      local.terraform_cloud_ip_ranges.vcs
    )
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Allow SSH access from Terraform Cloud IP ranges"
    }
  }

  dynamic "ingress" {
    for_each = concat(
      local.terraform_cloud_ip_ranges.api,
      local.terraform_cloud_ip_ranges.notifications,
      local.terraform_cloud_ip_ranges.sentinel,
      local.terraform_cloud_ip_ranges.vcs
    )
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Allow HTTPS access from Terraform Cloud IP ranges"
    }
  }

  dynamic "ingress" {
    for_each = var.makeshift_measure
    content {
      
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.environment}-${var.aws_region}-${var.project}-bastion-sg"
  }
}