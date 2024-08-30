variable "ami_id" {}
variable "public_key" {}
variable "subnet_ids" {}
variable "instance_type" {}
variable "security_groups" {}

output "prod-desqk-es2-instance-id" {
  value = aws_instance.prod-desqk-es2-instance.id
}

data "aws_iam_role" "code-deploy-role" {
  name = "code-deploy-ec2-role"
}

resource "aws_iam_instance_profile" "code-deploy-role-profile" {
  name = "code-deploy-ec2-profile"
  role = data.aws_iam_role.code-deploy-role.name
}

resource "aws_instance" "prod-desqk-es2-instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = true
  key_name                    = "prod-desqk-server-key"

  iam_instance_profile = aws_iam_instance_profile.code-deploy-role-profile.name

  user_data = file("${path.module}/user-data.tpl")

  tags = {
    Name = "Desqk Prod Server"
  }

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "prod-desqk-public-key" {
  key_name   = "prod-desqk-server-key"
  public_key = var.public_key
}