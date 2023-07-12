variable "PublicSubnet" {
  type = list(object({
    name           = string
    cidr_block     = string
    availability_zone = string
  }))
  default = [
    {
      name           = "Public_subnet_1_1a"
      cidr_block     = "10.124.5.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name           = "Public_subnet_2_1b"
      cidr_block     = "10.124.6.0/24"
      availability_zone = "us-east-1b"
    }
  ]
}

resource "aws_subnet" "akl_public_subnets" {
  count             = length(var.PublicSubnet)
  vpc_id            = aws_vpc.akl_vpc.id
  cidr_block        = var.PublicSubnet[count.index].cidr_block
  availability_zone = var.PublicSubnet[count.index].availability_zone
  map_public_ip_on_launch = true
  
  
  tags = {
    Name = var.PublicSubnet[count.index].name
  }
}