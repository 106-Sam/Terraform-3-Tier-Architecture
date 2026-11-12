variable "aws_region" {}
variable "aws_profile" {}
variable "vpc-cidr" {}
variable "s3_bucket" {}
variable "PubSubnet" {
    type = list(string)
}
variable "AZone" {
    type = list(string)
}
variable "PrivSubnet" {
    type = list(string)
}