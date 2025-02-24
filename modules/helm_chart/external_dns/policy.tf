// External DNS Policy 
resource "aws_iam_policy" "external_dns_policy" {
  name        = "external_dns_policy"
  description = "Policy for External DNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["route53:ChangeResourceRecordSets"]
        Resource = ["arn:aws:route53:::hostedzone/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["route53:ListHostedZones", "route53:ListResourceRecordSets", "route53:ListTagsForResource"]
        Resource = ["*"]
      }
    ]
  })
}

// External DNS Role
resource "aws_iam_role" "external_dns" {
  name  = "external-dns"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_url}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${local.oidc_url}:sub": "system:serviceaccount:kube-system:external-dns"
          }
        }
      }
    ]
  }
EOF
}

// IAM Role Attachment
resource "aws_iam_policy_attachment" "external_dns_policy_attachment" {
  name        = "external_dns_policy_attachment"
  roles       = [aws_iam_role.external_dns.name]
  policy_arn  = aws_iam_policy.external_dns_policy.arn
}