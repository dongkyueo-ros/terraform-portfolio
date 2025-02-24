// ECR Repository
resource "aws_ecr_repository" "ecr_a" {
  name                 = "${var.project}-${var.environment}-${var.region}/ecr-pri"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}/ecr-pri"
    Env  = var.environment
  }
}