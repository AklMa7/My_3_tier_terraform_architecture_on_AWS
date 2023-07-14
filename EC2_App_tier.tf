/*In this section of our workshop we will create an EC2 instance for our app layer and make all necessary software configurations so
that the app can run. The app layer consists of a Node.js application that will run on port 4000. We will also configure
our database with some data and tables.*/



#We need a key pair to connect to instance via SSH -> Used command " ssh-keygen -t ed25519 " to generate key pair that 
# i stored in ~/.ssh/ 

resource "aws_key_pair" "akl_auth" {
    key_name   = "3_tier_App_tier"
    public_key = file ("~/.ssh/3_tier_App_tier.pub") # instead of whole key as in input we use "file" function ..

}



resource "aws_instance" "akl_EC2_instance_WEB_TIER_1" {
  ami           = data.aws_ami.server_ami.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.akl_sg_App_tier_private_instances.id]
  subnet_id              = aws_subnet.akl_private_subnets[0].id

  iam_instance_profile = "ec2-iam-role"
  
  key_name               = aws_key_pair.akl_auth.id

  root_block_device {    #size for the root block device ( in GB ).
    volume_size        = 10
  }  
 
 
  tags = {
    Name = "akl_EC2_Instance_WEB_TIER_1"
  }
}
