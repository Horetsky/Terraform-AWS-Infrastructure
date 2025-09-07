# Terraform AWS Infrastructure

## Overview

This project provisions an **AWS infrastructure** using **Terraform** and modular architecture. The setup includes networking, security groups, load balancing, auto-scaling EC2 instances, and DNS configuration.

---

## Architecture Components

### 1. Networking (`networking` module)

* Creates a VPC.
* Configures **public** and **private** subnets.
* Associates subnets with an availability zone.

### 2. Security Groups (`security-groups` module)

* Defines security group rules for EC2 instances.
* Allows inbound traffic for:

    * SSH (22)
    * HTTP (80)
    * HTTPS (443)

### 3. Load Balancing (`load-balancing` module)

* Creates an **Application Load Balancer (ALB)**.
* Attaches ALB to public subnets.
* Uses EC2 security group for inbound traffic.

### 4. Computing (`computing` module)

* Launches an **Auto Scaling Group (ASG)** of EC2 instances.
* Connects instances to ALB target group.

### 5. Hosted Zone (`hosted-zone` module)

* Configures a DNS record (Route53).
* Points domain name to the ALB using its DNS name and hosted zone ID.

---

## Variables

The infrastructure requires the following variables (defined in `variables.tf` or via CLI/environment):

---

## Usage

### 1. Initialize project

```bash
terraform init
```

### 2. Preview changes

```bash
terraform plan
```

### 3. Apply changes

```bash
terraform apply -auto-approve
```

### 4. Destroy infrastructure

```bash
terraform destroy -auto-approve
```

---

## Project Structure

```
/ main.tf              # Root module calling all submodules
/ computing/           # Auto Scaling Group (EC2 instances)
/ hosted-zone/         # Route53 DNS configuration
/ load-balancing/      # ALB + Target group
/ networking/          # VPC, subnets, networking resources
/ security-groups/     # Security groups for EC2
```

---

## Requirements

* [Terraform](https://www.terraform.io/downloads) >= 1.3.0
* AWS account with proper IAM permissions
* Configured AWS CLI credentials