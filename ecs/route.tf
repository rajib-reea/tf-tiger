resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_igw" {
  route_table_id = aws_route_table.public.id

  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_nat" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.nat.id
}

resource "aws_route_table_association" "public_alb_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.alb_a.id
}

resource "aws_route_table_association" "public_alb_c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.alb_c.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id

  nat_gateway_id         = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_app" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.app.id
}
