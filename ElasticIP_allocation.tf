#Allocating Elastic IPs .

resource "aws_eip" "public_subnet_1_eip" {
  tags = {
    Name = "public_subnet_1_eip"
  }
}

resource "aws_eip" "public_subnet_2_eip" {
  tags = {
    Name = "public_subnet_2_eip"
  }
}