output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.publicsubnet : subnet.id]
}
