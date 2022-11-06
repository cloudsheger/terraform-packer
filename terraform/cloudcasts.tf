# File cloudcasts.tf
# Find the AMI we created

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Component"
    values = ["app"]
  }

  filter {
    name   = "tag:Project"
    values = ["cloudcasts"]
  }

  filter {
    name   = "tag:Environment"
    values = ["staging"]
  }

  #filter {
  #  name   = "name"
  #  values = ["cloudcast-staging-*-app"]
  #}

  owners = ["self"]
}

module "ec2_app" {
   source = "./modules/ec2"
 
   infra_env = var.infra_env
   infra_role = "app"
   instance_size = "t2.micro"
   instance_ami = data.aws_ami.app.id
   subnets = keys(module.vpc.vpc_public_subnets) # Note: Public subnets 
  # security_groups = [] # TODO: Create security groups
  security_groups = [module.vpc.security_group_public] 
  # instance_root_device_size = 12 
}
 
module "ec2_worker" {
   source = "./modules/ec2"
 
   infra_env = var.infra_env
   infra_role = "worker"
   instance_size = "t2.micro"
   instance_ami = data.aws_ami.app.id
   subnets = keys(module.vpc.vpc_private_subnets) # Note: Private subnets  
  # security_groups = [] # TODO: Create security groups
  security_groups = [module.vpc.security_group_private] 
  # instance_root_device_size = 20 //
   instance_root_device_size = 20
}

module "vpc" {
  source = "./modules/vpc"
 
  infra_env = var.infra_env
 
  # Note we are /17, not /16
  # So we're only using half of the available
  vpc_cidr  = "10.0.0.0/17"
}