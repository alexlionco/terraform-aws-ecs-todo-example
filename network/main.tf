resource "aws_vpc" "todoapp_vpc" {
  cidr_block           = "10.0.0.0/22"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "todoapp_ig" {
  vpc_id = aws_vpc.todoapp_vpc.id
}

resource "aws_subnet" "pub_subnet" {
  vpc_id            = aws_vpc.todoapp_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
}

resource "aws_subnet" "pub2_subnet" {
  vpc_id            = aws_vpc.todoapp_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.todoapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.todoapp_ig.id
  }

}

resource "aws_route_table_association" "tableassociation" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public.id
}