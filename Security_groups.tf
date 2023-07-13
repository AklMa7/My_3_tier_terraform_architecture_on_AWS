#-----------------------------  1st sg for the external ELB
resource "aws_security_group" "akl_sg_external_ELB" {
  name        = "public-ELB-sg"
  description = "sg for public internet facing (external) load balancer."
  vpc_id      = aws_vpc.akl_vpc.id

  ingress {     
    description      = "HTTP type traffic allowed"
    from_port        = 80  #Port 80 is associated with HTTP
    to_port          = 80
    protocol         = "tcp" 
    
    cidr_blocks      = [format("%s%s",data.http.my_ip.response_body,"/32")] # Allows traffic from my IP
    
  }

  egress {   
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any protocol can be used
    cidr_blocks      = ["0.0.0.0/0"] 
  }


  tags = {
        Name = "external-ELB-sg"
  }
}


#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------



# -------------------------------------2nd sg  for  public instances in the web tier
resource "aws_security_group" "akl_sg_Web_tier_public_instances" {
  name        = "public-instances-web-tier-ELB-sg"
  description = "sg for public instances in the web-tier."
  vpc_id      = aws_vpc.akl_vpc.id

  ingress {     
    
    description      = "HTTP type traffic allowed"
    from_port        = 80  
    to_port          = 80
    protocol         = "tcp" 
    
    cidr_blocks      = [format("%s%s",data.http.my_ip.response_body,"/32")] # Allows traffic from my IP 
    
  }


  egress {  
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any protocol can be used
    cidr_blocks      = ["0.0.0.0/0"] 
  }


  tags = {
        Name = "public-instances-Web-tier-ELB-sg"
  }
}
#------------------ adding the 1st Sg as in inbound rule in the 2nd SG
resource "aws_security_group_rule" "inbound_rule" {
  
  security_group_id        = aws_security_group.akl_sg_Web_tier_public_instances.id #SG where inbound rule will be added
  type                     = "ingress"
  description              = "HTTP type traffic allowed from external ELB sg to public web-tier instances sg "
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.akl_sg_external_ELB.id  #SG we will add as an inbound rule .



}





#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------




#-------------------------------------- 3rd SG for the internal load balancer . 
resource "aws_security_group" "akl_sg_internal_ELB" {
  name        = "internal-ELB-sg"
  description = "sg for the internal load balancer ( between web-tier and app-tier)"
  vpc_id      = aws_vpc.akl_vpc.id



  egress {   
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any protocol can be used
    cidr_blocks      = ["0.0.0.0/0"] 
  }


  tags = {
        Name = "internal-ELB-sg"
  }
}
#------------------ adding the 2nd Sg as in inbound rule in the 3rd SG
resource "aws_security_group_rule" "inbound_rule_2" {
  
  security_group_id        = aws_security_group.akl_sg_internal_ELB.id #SG where inbound rule will be added
  type                     = "ingress"
  description              = "HTTP type traffic allowed from public web-tier instances sg to internal ELB sg"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.akl_sg_Web_tier_public_instances.id  #SG we will add as an inbound rule .



}


#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------



#-------------------------------------- 4th SG for the app tier private instances.
resource "aws_security_group" "akl_sg_App_tier_private_instances" {
  name        = "private-instances-App-tier-ELB-sg"
  description = "sg for private instances in the app-tier."
  vpc_id      = aws_vpc.akl_vpc.id

  ingress {     
    
    description      = "TCP type traffic allowed"
    from_port        = 4000  
    to_port          = 4000
    protocol         = "tcp" 
    
    cidr_blocks      = [format("%s%s",data.http.my_ip.response_body,"/32")] # Allows traffic from my IP 
    
  }


  egress {   
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any protocol can be used
    cidr_blocks      = ["0.0.0.0/0"] 
  }


  tags = {
        Name = "Private-instances-App-tier-ELB-sg"
  }
}
#------------------ adding the 3rd Sg as in inbound rule in the 4th SG
resource "aws_security_group_rule" "inbound_rule_3" {
  
  security_group_id        = aws_security_group.akl_sg_App_tier_private_instances.id #SG where inbound rule will be added
  type                     = "ingress"
  description              = "TCP type traffic allowed from internal ELB sg to private app-tier instances sg"
  from_port                = 4000
  to_port                  = 4000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.akl_sg_internal_ELB.id  #SG we will add as an inbound rule .



}



#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------

#-------------------------------------- 5th SG for the DB tier private instances.
resource "aws_security_group" "akl_sg_DB_tier_private_instances" {
  name        = "private-instances-DB-tier-ELB-sg"
  description = "sg for private instances in the DB-tier."
  vpc_id      = aws_vpc.akl_vpc.id

  ingress {     
    
    description      = "TCP type traffic allowed"
    from_port        = 3306  #Any port needed 
    to_port          = 3306
    protocol         = "tcp" 
    
    cidr_blocks      = [format("%s%s",data.http.my_ip.response_body,"/32")] # Allows traffic from my IP
    
  }


  egress {  
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any protocol can be used
    cidr_blocks      = ["0.0.0.0/0"] 
  }


  tags = {
        Name = "Private-instances-DB-tier-ELB-sg"
  }
}

#---------------------------- Adding 4th sg as an inbound rule for the 5th sg
resource "aws_security_group_rule" "inbound_rule_4" {
  
  security_group_id        = aws_security_group.akl_sg_DB_tier_private_instances.id  #SG where inbound rule will be added
  type                     = "ingress"
  description              = "TCP type traffic allowed from private App tier instance sg to private DB-tier instances sg"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.akl_sg_App_tier_private_instances.id  #SG we will add as an inbound rule .



}


