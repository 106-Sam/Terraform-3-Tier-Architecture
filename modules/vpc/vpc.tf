resource "aws_vpc" "vpc"{
    cidr_block = var.vpc_cidr
    tags = {
        Name = "vpc"
    }
}


# public/private subnets, internet gateway, NAT gateways, route tables.


# 2 Public Subnets 

resource "aws_subnet" "PubSubnet"{
    count = length(var.PubSubnet)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PubSubnet[count.index]
    availability_zone = var.AZone[count.index]
    tags = {
        Name = "PubSubnet-${count.index + 1}"
    }
}

# 2 Private Subnets
resource "aws_subnet" "PrivSubnet"{
    count = length(var.PrivSubnet)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PrivSubnet[count.index]
    availability_zone = var.AZone[count.index]
    tags = {
        Name = "PrivSubnet-${count.index + 1}"
    }
}





