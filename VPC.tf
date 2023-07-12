resource "aws_vpc" "akl_vpc" {
    cidr_block           = "10.124.0.0/16"
    enable_dns_hostnames = true 
    enable_dns_support   = true

    tags = {
        Name = "3_tier_vpc"
    }
} 