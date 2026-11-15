variable "vpc_cidr" {}
variable "PubSubnet" {
    type = list(string)
}
variable "AZone" {
    type = list(string)
}
variable "PvtSubnet" {
    type = list(string)
}
variable "anywhere_cidr" {}