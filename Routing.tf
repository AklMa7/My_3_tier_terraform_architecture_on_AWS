
#------------------ Routing the public subnets to the gateway via a routing table and associating them.

resource "aws_route_table" "akl_public_rt"{
    vpc_id   = aws_vpc.akl_vpc.id

    tags = {
        Name = "3_tier_public_route_table"
    }
}

#Add a route that directs traffic from the VPC to the internet gateway.
/*for all traffic destined for IPs outside the VPC CDIR range, add an entry that directs it to the internet gateway as a target*/

resource "aws_route" "akl_default_route"{
    route_table_id          = aws_route_table.akl_public_rt.id
    destination_cidr_block  = "0.0.0.0/0"  #All ip adresses will head to our internet gateway
    gateway_id              = aws_internet_gateway.akl_internet_gateway.id #Links route table to internet gateway 


}


# Now we need to bridge the gap between  our public subnets using the routing table.

resource "aws_route_table_association" "Public_subnet_1_1a_association" {
  subnet_id      = aws_subnet.akl_public_subnets[0].id
  route_table_id = aws_route_table.akl_public_rt.id
}

resource "aws_route_table_association" "Public_subnet_2_1b_association" {
  subnet_id      = aws_subnet.akl_public_subnets[1].id
  route_table_id = aws_route_table.akl_public_rt.id
}

#------------------------------ Routing the private subnets to the individual NAT gateways via routing tables .

# NAT gateway for AZ    :  1a
resource "aws_route_table" "akl_private_rt_1a"{
    vpc_id   = aws_vpc.akl_vpc.id

    tags = {
        Name = "3_tier_route_table_1a"
    }
}

resource "aws_route" "akl_private_route_1a"{
    route_table_id          = aws_route_table.akl_private_rt_1a.id
    destination_cidr_block  = "0.0.0.0/0"  #All ip adresses will head to our internet gateway
    gateway_id              = aws_nat_gateway.akl_NAT_gateway_1a.id #Links route table to internet gateway 

}

resource "aws_route_table_association" "Private_subnet_1_1a_association" {
  subnet_id      = aws_subnet.akl_private_subnets[0].id
  route_table_id = aws_route_table.akl_private_rt_1a.id
}





# NAT gateway for AZ    :  1b

resource "aws_route_table" "akl_private_rt_1b"{
    vpc_id   = aws_vpc.akl_vpc.id

    tags = {
        Name = "3_tier_route_table_1b"
    }
}

resource "aws_route" "akl_private_route_1b"{
    route_table_id          = aws_route_table.akl_private_rt_1b.id
    destination_cidr_block  = "0.0.0.0/0"  #All ip adresses will head to our internet gateway
    gateway_id              = aws_nat_gateway.akl_NAT_gateway_1b.id #Links route table to internet gateway 

}

resource "aws_route_table_association" "Private_subnet_1_1b_association" {
  subnet_id      = aws_subnet.akl_private_subnets[2].id
  route_table_id = aws_route_table.akl_private_rt_1b.id
}

