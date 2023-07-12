resource "aws_s3_bucket" "akl_bucket" {
  bucket = "demowebapp-akl"

  tags = {
    Name        = "3_tier_akls3bucket"
    Environment = "3_tier_aklDev"
  }
}