output "vpc_id" {
  value = aws_vpc.todoapp_vpc.id
}

output "subnet_ids" {
  value = ["${aws_subnet.pub_subnet.id}", "${aws_subnet.pub2_subnet.id}"]
}