
#In order to give the public subnets in our VPC internet access we will have to create and attach an Internet Gateway.


resource "aws_internet_gateway" "akl_internet_gateway" {
    vpc_id = aws_vpc.akl_vpc.id

    tags = {
        Name = "3_tier_igw"
    }
}