# // ec2_instances
# resource "aws_instance" "ec2_instances" {
#   for_each = var.ec2_instances

#   ami                         = data.aws_ami.ubuntu_ami.id
#   instance_type               = each.value.instance_type
#   subnet_id                   = each.value.subnet_id
#   vpc_security_group_ids      = each.value.security_group
#   associate_public_ip_address = each.value.public_ip
#   key_name                    = each.value.key_name
#   #iam_instance_profile        = var.ec2_fis_role_name
#   user_data                   = base64encode(file("${path.module}/user-data/${each.value.user_data}"))

#   root_block_device {
#     volume_size           = each.value.volume_size
#     volume_type           = each.value.volume_type
#     delete_on_termination = each.value.volume_delete
#   }

#   tags = {
#     Name          = "ec2-${var.environment}-${var.region}-${var.project}-${each.key}"
#     Ec2StressCpu  = "Allowed"
#     Env           = var.environment
#   }
#   volume_tags = {
#     Name  = "ec2-${var.environment}-${var.region}-${var.project}-${each.key}"
#     Env   = var.environment
#   }
# }
