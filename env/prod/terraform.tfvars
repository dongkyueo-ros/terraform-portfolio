// Company IP Range (Bastion Securty Groups)
company_ip_ranges = ["<company_ip_range_1>", "<company_ip_range_2>"]

// VPC
vpc_cidr_block            = "172.17.0.0/20"                                                   # VPC CIDR
azs                       = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]         # 배포 AZ
public_subnets            = ["172.17.0.0/24", "172.17.1.0/24", "172.17.2.0/24"]               # Public Subnets CIDR
private_subnets_eks       = ["172.17.6.0/24", "172.17.7.0/24", "172.17.8.0/24"]               # Private Subnets eks node, pod CIDR
private_subnets_master    = ["172.17.14.0/28", "172.17.14.16/28", "172.17.14.32/28"]          # Private Subnets eks master CIDR
private_subnets_db        = ["172.17.15.0/26", "172.17.15.64/26", "172.17.15.128/26"]         # Private Subnets db CIDR

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

        
    worker3 = {
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
logs_bucket_name = "logs-bucket-prd"

// ACM Certificate (Seoul)
acm_certificate_domain_name = "<acm_domain_name>"

// Frontend S3 bucket domain - prod
sites = {
    site1_prod = {
        domain_name     = "<domain>"
        subdomain_name  = "<subdomain>"
        bucket_name     = "<buckuc_name>"
        aliases         = ["<domain_name>"]
        github_repo     = "<github_repo>"
        github_branch   = [ "main", "develop" ]
        use_function    = false
    }
}