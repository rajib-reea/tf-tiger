resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_eip" "main" {
  domain = "vpc"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.nat.id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_subnet" "app" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.1.110.0/24"
}

resource "aws_subnet" "nat" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.1.100.0/24"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "alb_a" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.1.4.0/24"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "alb_c" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1c"
  cidr_block        = "10.1.5.0/24"

  map_public_ip_on_launch = true
}
