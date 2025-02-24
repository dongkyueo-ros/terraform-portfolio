// OIDC 제공업체 데이터 조회
data "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

// OIDC Assume Role Policy 문서 (브랜치별)
data "aws_iam_policy_document" "oidc_assume_role_policy" {
  for_each = var.sites
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_oidc.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        for branch in var.github_branch : "repo:${var.github_organizations}/${each.value.github_repo}:ref:refs/heads/${branch}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

// GitHub OIDC IAM Role
resource "aws_iam_role" "github_oidc_role" {
  for_each = var.sites
  name     = "GithubCI-${var.github_organizations}-${each.value.bucket_name}"

  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy[each.key].json
}

// S3 및 CloudFront 배포 정책 문서 (IAM Role - inline policy)
data "aws_iam_policy_document" "deployment_policy_document" {
  for_each = var.sites

  statement {
    sid    = "AllowS3BucketManipulation"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:ListBucket"
    ]
    resources = [
      "${var.website_bucket_release[each.key].arn}/*"
    ]
  }

  statement {
    sid    = "AllowS3BucketListing"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      var.website_bucket_release[each.key].arn
    ]
  }

  statement {
    sid    = "AllowCFInvalidation"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      var.aws_cloudfront_distribution[each.key].arn
    ]
  }
}

// 생성된 역할에 배포 정책 연결 (Inline Policy)
resource "aws_iam_role_policy" "s3_deployment_policy_attachment" {
  for_each = var.sites
  name     = "S3DeploymentPolicy-${each.value.bucket_name}"
  role     = aws_iam_role.github_oidc_role[each.key].name
  policy   = data.aws_iam_policy_document.deployment_policy_document[each.key].json
}