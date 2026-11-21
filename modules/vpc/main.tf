resource "aws_vpc" "vpc"{
    cidr_block = var.vpc_cidr
    tags = {
        Name = "vpc"
    }
}


# public/private subnets, internet gateway,  route tables, NAT gateways.


# 2 Public Subnets 

resource "aws_subnet" "PubSubnet"{
    count = length(var.PubSubnet)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PubSubnet[count.index]
    availability_zone = var.AZone[count.index]
    map_public_ip_on_launch = true    
    tags = {
        Name = "PubSubnet-${count.index + 1}"
    }
    depends_on = [aws_vpc.vpc]
}

# 2 Private Subnets
resource "aws_subnet" "PvtSubnet"{
    count = length(var.PvtSubnet)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PvtSubnet[count.index]
    availability_zone = var.AZone[count.index]
    map_public_ip_on_launch = false
    tags = {
        Name = "PvtSubnet-${count.index + 1}"
    }
    depends_on = [aws_vpc.vpc]
}

# Internet Gateway
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "igw"
    }
}

# Public Route Table
resource "aws_route_table" "Public-rt"{
    vpc_id = aws_vpc.vpc.id

    route{
        cidr_block = var.anywhere_cidr
        gateway_id = aws_internet_gateway.igw.id
    }
    route{
        cidr_block = var.anywhere_cidr
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = "Public-rt"
    }
    depends_on = [aws_internet_gateway.igw]
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public-rt-assoc"{
    count = length(var.PubSubnet)
    subnet_id = aws_subnet.PubSubnet[count.index].id
    route_table_id = aws_route_table.Public-rt.id
    depends_on = [aws_route_table.Public-rt]
}

# Private Route Table
resource "aws_route_table" "Pvt-rt"{
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Pvt-rt"
    }
    depends_on = [aws_vpc.vpc]
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "priv-rt-assoc"{
    count = length(var.PvtSubnet)
    subnet_id = aws_subnet.PvtSubnet[count.index].id
    route_table_id = aws_route_table.Pvt-rt.id
    depends_on = [aws_route_table.Pvt-rt]
}

# Elastic IP for NAT Gateway  
resource "aws_eip" "nat_eip"{
    domain = "vpc"

    tags = {
        Name = "nat-eip"
    }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw"{
    subnet_id = aws_subnet.PubSubnet[0].id
    allocation_id = aws_eip.nat_eip.id
    tags = {
        Name = "nat-gw"
    }
    depends_on = [aws_internet_gateway.igw, aws_eip.nat_eip]
}

