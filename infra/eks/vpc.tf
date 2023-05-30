resource "aws_vpc" "finance_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "finance_subnet_1" {
  vpc_id = aws_vpc.finance_vpc.id
  cidr_block = var.subnet_cidr_block_1
  availability_zone = var.availability_zone_1
  tags = {
    Name = "${var.vpc_name} - Subnet 1"
  }
}

resource "aws_subnet" "finance_subnet_2" {
  vpc_id = aws_vpc.finance_vpc.id
  cidr_block = var.subnet_cidr_block_2
  availability_zone = var.availability_zone_2
  tags = {
    Name = "${var.vpc_name} - Subnet 2"
  }
}

resource "aws_security_group" "finance_security_group" {
  name_prefix = "${var.vpc_name}-"
  vpc_id = aws_vpc.finance_vpc.id

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [var.allowed_cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name} - Security Group"
  }
}
