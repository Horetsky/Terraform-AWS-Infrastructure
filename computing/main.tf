variable "ami_id" {}
variable "instance_type" {}
variable "public_key" {}
variable "subnet_ids" {}
variable "security_groups" {}
variable "target-group-arns" {}


data "aws_iam_role" "code-deploy-role" {
  name = "code-deploy-ec2-role"
}

resource "aws_iam_instance_profile" "code-deploy-role-profile" {
  name = "code-deploy-ec2-profile"
  role = data.aws_iam_role.code-deploy-role.name
}

resource "aws_key_pair" "prod-desqk-public-key" {
  key_name   = "prod-desqk-server-key"
  public_key = var.public_key
}

module "autoscaling" {
  source = "./autoscaling"
  launch_template_id = aws_launch_template.prod-desqk-lt.id
  desired_size = 2
  max_size = 2
  min_size = 2
  subnet_ids = var.subnet_ids
  target_group_arns = var.target-group-arns
}