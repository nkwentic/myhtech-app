resource "aws_subnet" "private_subnet_1" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.environment}-private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_associations" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private_subnet_1[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.environment}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public_subnet_1[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.environment}-eks-igw"
  }
}

resource "aws_route" "public_internet_gateway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

resource "aws_nat_gateway" "eks_nat_gw" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat_gw_ips[count.index].id
  subnet_id     = aws_subnet.public_subnet_1[count.index].id

  tags = {
    Name = "${var.environment}-eks-nat-gw-${count.index + 1}"
  }
}

resource "aws_eip" "nat_gw_ips" {
  count = length(var.public_subnet_cidrs)

  vpc = true

  tags = {
    Name = "${var.environment}-eks-nat-gw-eip-${count.index + 1}"
  }
}

resource "aws_route" "private_nat_gateway_route" {
  count = length(var.private_subnet_cidrs)

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gw[count.index].id
}
