#THIS IS A PAID SERVICE !!!!!!!!!!!!!!!!!!!

/* In order for our instances in the app layer private subnet to be able to access the 
internet they will need to go through a NAT Gateway


  public_subnet_1_eip_id = data.aws_eip.public_subnet_1_eip.id
  public_subnet_2_eip_id = data.aws_eip.public_subnet_2_eip.id

  #Because you cannot directly reference data sources within variable definitions. 

*/

/*
variable "PublicSubnetNAT" {
  type = list(object({
    name            = string
    allocation_id   = string
    subnet_id       = string
    
  }))
  default = [
    {
      name           = "NAT_gateway_1a"
      allocation_id  = "eipalloc-00afe5bd3b91eb7ec"  #Change to your own
      subnet_id      = "subnet-0ae5224ca4f918b98"
      
    },
    {
      name           = "NAT_gateway_1b"
      allocation_id  = "eipalloc-04c9989411c463d3c"  #Change to your own       #i think in this case id is the same as allocation id
      subnet_id      = "subnet-09d499b31f2518a4e"                          # According to state show command at least .....
      
    }
  ]
}





resource "aws_nat_gateway" "akl_NAT_gateway" {
  count         = length(var.PublicSubnetNAT)
  allocation_id = var.PublicSubnetNAT[count.index].allocation_id
  subnet_id     = var.PublicSubnetNAT[count.index].subnet_id

  tags = {
    Name = var.PublicSubnetNAT[count.index].name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.                            Don't fully understand .. look up later.
  depends_on = [aws_internet_gateway.akl_internet_gateway]
}



*/





resource "aws_nat_gateway" "akl_NAT_gateway_1a" {
  allocation_id = data.aws_eip.public_subnet_1_1a_eip.id  
  subnet_id     = aws_subnet.akl_private_subnets[0].id

  tags = {
    Name = "gw_NAT_1a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.akl_internet_gateway]
}


resource "aws_nat_gateway" "akl_NAT_gateway_1b" {
  allocation_id = data.aws_eip.public_subnet_1_1b_eip.id  
  subnet_id     = aws_subnet.akl_private_subnets[2].id

  tags = {
    Name = "gw_NAT_1b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.akl_internet_gateway]

}