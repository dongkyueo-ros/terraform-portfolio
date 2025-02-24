// Company IP Range (Bastion Securty Groups)
company_ip_ranges = ["<company_ip_range_1>", "<company_ip_range_2>"]

// VPC
vpc_cidr_block            = "172.19.0.0/22"                                                 # VPC CIDR
azs                       = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]       # 배포 AZ
public_subnets            = ["172.19.0.0/26", "172.19.0.64/26", "172.19.0.128/26"]          # Public Subnets CIDR
private_subnets_eks       = ["172.19.1.0/26", "172.19.1.64/26", "172.19.1.128/26"]          # Private Subnets eks node, pod CIDR
private_subnets_master    = ["172.19.2.0/28", "172.19.2.16/28", "172.19.2.32/28"]           # Private Subnets eks master CIDR
private_subnets_db        = ["172.19.3.0/26", "172.19.3.64/26", "172.19.3.128/26"]          # Private Subnets db CIDR

// EKS Version
eks_version = "1.30"

// Worknode Groups
workers_config = {

    worker1 = {
        desired_size = 3
        min_size     = 2
        max_size     = 5

        disk_size     = 30
        ami_type      = "AL2_x86_64"

        instance_types = ["m5.xlarge"]
        capacity_type  = "ON_DEMAND"
    }
    
    worker2 = {
        desired_size = 3
        min_size     = 2
        max_size     = 5

        disk_size     = 30
        ami_type      = "AL2_x86_64"

        instance_types = ["m5.xlarge"]
        capacity_type  = "ON_DEMAND"
    }
}

// Instance Key Pair
ec2_ssh_key = "<eks_key_pair>"

// Cloudfront logs S3 Bucket
logs_bucket_name = "logs-bucket-dev"

// ACM Certificate (Seoul)
acm_certificate_domain_name = "<acm_domain_name>"

// Frontend S3 Bucket Domain - dev
sites = {
    site1_dev = {
        domain_name     = "<domain>"
        subdomain_name  = "<subdomain>"
        bucket_name     = "<buckuc_name>"
        aliases         = ["<domain_name>"]
        github_repo     = "<github_repo>"
        use_function    = true
    }
}