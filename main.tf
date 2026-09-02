provider "aws" {
    region      = "us-east-1"
    version     = "~> 2.0"
}

terraform {
    backend "s3" {
        bucket = "my-terraform-states-rrs"
        key    = "terraform-zbx.tfstate"
        region = "us-east-1"
    }
}