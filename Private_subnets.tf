variable "PrivateSubnet" {
  type = list(object({
    name           = string
    cidr_block     = string
    availability_zone = string
  }))
  default = [
    {
      name           = "private_subnet_1_1a"
      cidr_block     = "10.124.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name           = "private_subnet_2_1a"
      cidr_block     = "10.124.2.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name           = "private_subnet_1_1b"
      cidr_block     = "10.124.3.0/24"
      availability_zone = "us-east-1b"
    },
    {
      name           = "private_subnet_2_1b"
      cidr_block     = "10.124.4.0/24"
      availability_zone = "us-east-1b"
    },
  
  ]
}

resource "aws_subnet" "akl_private_subnets" {
  count             = length(var.PrivateSubnet)
  vpc_id            = aws_vpc.akl_vpc.id
  cidr_block        = var.PrivateSubnet[count.index].cidr_block
  availability_zone = var.PrivateSubnet[count.index].availability_zone
  map_public_ip_on_launch = false
  
  
  tags = {
    Name = var.PrivateSubnet[count.index].name
  }
}

