variable "vpc_cidr" {}
variable "PubSubnet" {
    type = list(string)
}
variable "AZone" {
    type = list(string)
}
variable "PrivSubnet" {
    type = list(string)
}