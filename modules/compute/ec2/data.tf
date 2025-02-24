// 최신 Ubuntu 22.04 LTS AMI 검색
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]  // Canonical 소유자 ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

// Pakcer Bastion AMI
data "aws_ami" "bastion_ami" {
  most_recent = true
  owners      = ["${var.aws_account_id}"]  # 또는 해당 AMI를 소유한 AWS 계정 ID

  filter {
    name   = "name"
    values = ["ami-*-${var.aws_region}-${var.project}-ubuntu-*"]  # 원하는 AMI 이름 패턴
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Terraform Cloud IP Range
data "http" "terraform_cloud_ip_ranges" {
  url = "https://app.terraform.io/api/meta/ip-ranges"

  request_headers = {
    # Enabling the `If-Modified-Since` flag may result in an empty response
    # If-Modified-Since = "Tue, 26 May 2020 15:10:05 GMT"
    Accept = "application/json"
  }
}

locals {
  # assign JSONified output to a local variable
  terraform_cloud_ip_ranges = jsondecode(data.http.terraform_cloud_ip_ranges.response_body)
}