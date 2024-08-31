resource "aws_launch_template" "prod-desqk-lt" {
    name_prefix   = "prod-desqk-"
    image_id      = var.ami_id
    instance_type = var.instance_type

    key_name               = aws_key_pair.prod-desqk-public-key.key_name

    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination       = true
        security_groups = var.security_groups
    }

    iam_instance_profile {
        name = aws_iam_instance_profile.code-deploy-role-profile.name
    }

    user_data = filebase64("${path.module}/user-data.sh")

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "Desqk Prod Launch Template"
        }
    }

    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"
    }
}