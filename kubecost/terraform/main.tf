provider "aws" {
    region = "ap-northeast-2"
}

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    
  }
}

# EBS CSI Driver is the pre-requisite for Kubecost

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = "kubecon2023"
  addon_name                  = "aws-ebs-csi-driver"
#   addon_version               = "v1.24.0-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "kubecost" {
  depends_on                    = [ aws_eks_addon.ebs_csi_driver ]
  cluster_name                  = "kubecon2023"
  addon_name                    = "kubecost_kubecost"
  resolve_conflicts_on_update   = "OVERWRITE"
#   addon_version               = "v2.19.1-eksbuild.0" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
}