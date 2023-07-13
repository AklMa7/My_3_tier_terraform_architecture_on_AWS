resource "aws_db_subnet_group" "akl_RDS_subnet_group" {
  name       = "db_tier_private_instances_subnet_group_2-1a_2-1b"
  subnet_ids = [aws_subnet.akl_private_subnets[1].id, aws_subnet.akl_private_subnets[3].id]

  tags = {
    Description = "DB_tier_private_instances_subnet_group_2-1a_2-1b"
    
  }
}




resource "aws_rds_cluster" "akl_rds-cluster_1" {
  
  cluster_identifier = "aurora-mysql-akl-rds-cluster-1"
  
  engine             = "aurora-mysql"
   
  #allocated_storage  = 10
  #iops               = 100   #input/output ops per second 
  #storage_type       = "gp2" #Change to desired storage
  #engine_version     = "5.7.mysql_aurora.2.03.2"
  availability_zones = ["us-east-1a", "us-east-1b"]
  

  database_name      = "akl_aurora_sql_RDS_DB"
  master_username    = "aklma7"
  master_password    = "aklma7aklma7"

  vpc_security_group_ids = [aws_security_group.akl_sg_DB_tier_private_instances.id] #if we wanna create RDS in non-default vpc

  db_subnet_group_name = aws_db_subnet_group.akl_RDS_subnet_group.name
  # multi_az = true ----> No need to specify this bcs ot is inherent to an AWS RDS cluster. 
  
  skip_final_snapshot = true
}



resource "aws_rds_cluster_instance" "akl_rds-cluster_instance-1" {
  
  identifier         = "aurora-mysql-akl-rds-cluster-instance-1"
  cluster_identifier = aws_rds_cluster.akl_rds-cluster_1.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.akl_rds-cluster_1.engine
  engine_version     = aws_rds_cluster.akl_rds-cluster_1.engine_version

}




resource "aws_rds_cluster_instance" "akl_rds-cluster_instances-2" {  # Usualy gonna be the writer instance = retrieve its endpoint
  
  identifier         = "aurora-mysql-akl-rds-cluster-instance-2"
  cluster_identifier = aws_rds_cluster.akl_rds-cluster_1.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.akl_rds-cluster_1.engine
  engine_version     = aws_rds_cluster.akl_rds-cluster_1.engine_version

}

#aws_rds_cluster_instance.akl_rds-cluster_instances-2.endpoint
#aurora-mysql-akl-rds-cluster-instance-2.ciy8dym3xlyw.us-east-1.rds.amazonaws.com



/*
#     The lifecycle Meta-Argument

resource "aws_rds_cluster" "Prevent_mistake_deletion" {
  # ...

  lifecycle {
    
    prevent_destroy = true
  }
}

*/
