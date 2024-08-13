variable "vpc_id" {}
variable "ec2_sg_name" {}

resource "aws_security_group" "prod-desqk-es2-sg" {
    vpc_id      = var.vpc_id
    name        = var.ec2_sg_name
    description = "Enable the Port SSH(22), HTTP(80), HTTPS(443)"

    ingress {
        description = "Allow remote SSH from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
    }

    ingress {
        description = "Allow HTTP request from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }

    ingress {
        description = "Allow HTTPS request from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
    }

    egress {
        description = "Allow outgoing request"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Security Groups to allow SSH(22), HTTP(80), HTTPS(443)"
    }
}