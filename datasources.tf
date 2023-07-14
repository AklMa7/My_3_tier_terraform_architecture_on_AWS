




data "aws_eip" "public_subnet_1_1a_eip" {
  id = "eipalloc-00afe5bd3b91eb7ec"
}


data "aws_eip" "public_subnet_1_1b_eip" {
  id = "eipalloc-04c9989411c463d3c"
}







data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}




data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230628.0-x86_64-*"]
  }

  owners = ["137112412989"]
}
