provider "aws"{
    profile = var.aws_profile
    region = var.aws_region
}

# creating s3 bucket
#resource "aws_s3_bucket" "remotetf"{
#    bucket = var.s3_bucket
#    tags = {
#        Name = "remotetf"
#    }
#}

# backend for remote S3 tfstate file
terraform{
    backend "s3" {
        bucket = "3-tier-app106"
        key = "3-tier-app.tfstate"
        region = "ap-south-2"
        
    }
}

module "vpc"{
    source = "./modules/vpc/"
    vpc_cidr = var.vpc-cidr
    PubSubnet = var.PubSubnet
    AZone = var.AZone
    PrivSubnet = var.PrivSubnet

}

