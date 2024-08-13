variable "ami_id" {}
variable "public_key" {}
variable "subnet_ids" {}
variable "instance_type" {}
variable "security_groups" {}

resource "aws_instance" "prod-desqk-es2-instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = true
  key_name                    = "prod-desqk-server-key"

  user_data = templatefile("./computing/user-data/init.sh", {})

  tags = {
    Name = "Desqk Prod Server"
  }

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "prod-desqk-server-key"
  public_key = var.public_key
}