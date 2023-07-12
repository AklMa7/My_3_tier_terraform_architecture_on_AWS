module "ec2-iam-role" {
  source  = "Smartbrood/ec2-iam-role/aws"
  name    = "ec2-iam-role"
  version = "0.5.0"
  
  
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]  
}

#AmazonSSMManagedInstanceCore : 
# It allows EC2 instances to use SSM services like running commands, managing inventory, and applying patches.

#AmazonS3ReadOnlyAccess:
#This policy provides read-only access to Amazon S3 (Simple Storage Service) resources. It allows users 
#or services to list, read, and download objects from S3 buckets. ( read only)