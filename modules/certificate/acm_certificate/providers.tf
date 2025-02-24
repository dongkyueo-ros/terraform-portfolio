// virginia
provider "aws" {
  region  = "us-east-1"
  alias   = "virginia"
}

// seoul
provider "aws" {
  region  = var.region
  alias   = "seoul"
}