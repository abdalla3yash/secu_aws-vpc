resource "aws_route_table_association" "public-subnet-route" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_security_group" "SG" {
  name        = "SG"
  description = "security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG"
  }
  
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_routing_table
  }
}

resource "aws_route_table_association" "private-subnet-route" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.private-route-table.id
}