


data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}






data "aws_eip" "public_subnet_1_1a_eip" {
  id = "eipalloc-00afe5bd3b91eb7ec"
}


data "aws_eip" "public_subnet_1_1b_eip" {
  id = "eipalloc-04c9989411c463d3c"
}



