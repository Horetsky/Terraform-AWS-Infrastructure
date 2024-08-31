module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  cidr_private_subnet  = var.cidr_private_subnet
  us_availability_zone = var.us_availability_zone
}

module "security-groups" {
  source      = "./security-groups"
  vpc_id      = module.networking.prod-desqk-vpc-id
  ec2_sg_name = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
}

module "load-balancing" {
  source = "./load-balancing"
  vpc_id = module.networking.prod-desqk-vpc-id
  subnet_ids = tolist(module.networking.prod-desqk-vps-public-subnets)
  security_groups = [module.security-groups.prod-desqk-es2-sg]
}

module "computing" {
  source          = "./computing"
  ami_id          = var.ec2_aim
  instance_type   = "t3.micro"
  public_key      = var.ssh_public_key
  subnet_ids      = tolist(module.networking.prod-desqk-vps-public-subnets)
  security_groups = [module.security-groups.prod-desqk-es2-sg]
  target-group-arns = [module.load-balancing.target_group_arn]
}