## Base required for Terraform to make AWS API calls

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}

provider "aws" {
  region = local.region
}


# This creates a VPC with 2 public and 2 private subnets in each AZ
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.1"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

# This creates an EKS cluster with 2 nodes in each AZ
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.17.4"

  cluster_name                      = local.name
  cluster_version                   = "1.27"
  cluster_endpoint_public_access    = true

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
        iam_role_additional_policies = {
          additional = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
        instance_types = ["t3.medium"]
        ami_type       = "AL2_x86_64"
        desired_size   = 2
        min_size       = 2
        max_size       = 2
        metadata_options = {
            http_endpoint               = "enabled"
            http_tokens                 = "optional"
            instance_metadata_tags      = "enabled"
            http_put_response_hop_limit = "3"
        }
    }
    arm = {
        iam_role_additional_policies = {
          additional = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
        instance_types = ["c6g.large"]
        ami_type       = "AL2_ARM_64"
        desired_size   = 2
        min_size       = 2
        max_size       = 2
        metadata_options = {
            http_endpoint               = "enabled"
            http_tokens                 = "optional"
            instance_metadata_tags      = "enabled"
            http_put_response_hop_limit = "3"
        }
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  tags = local.tags
}
