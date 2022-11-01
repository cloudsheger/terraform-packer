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

# File cloudcasts.tf

resource "aws_instance" "cloudcasts_web" {
  ami           = data.aws_ami.app.id
  instance_type = var.instance_size

  root_block_device {
    volume_size = 8 # GB
    volume_type = "gp2"
  }

  lifecycle { 
    create_before_destroy = true
  }

  tags = {
    Name        = "cloudcasts-${var.infra_env}-web"
    Project     = "cloudcasts.io"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}
# Create an eip resouce 
resource "aws_eip" "app_eip" {
  vpc = true

  lifecycle {

    prevent_destroy = false

  }

  tags = {
    Name        = "cloudcasts-${var.infra_env}-web"
    Project     = "cloudcasts.io"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

# associate eip to the instance

resource "aws_eip_association" "app_eip_assoc" {
  instance_id   = aws_instance.cloudcasts_web.id
  allocation_id = aws_eip.app_eip.id
}