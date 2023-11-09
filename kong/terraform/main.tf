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


resource "aws_eks_addon" "kong_konnect-ri" {
  cluster_name                  = "kubecon2023"
  addon_name                    = "kong_konnect-ri"
  resolve_conflicts_on_update   = "OVERWRITE"
  addon_version                 = "v3.4.1-eksbuild.1"
  configuration_values = jsonencode({
    "env": {
        "cluster_cert": "/etc/secrets/kong-cluster-cert/tls.crt",
        "cluster_cert_key": "/etc/secrets/kong-cluster-cert/tls.key",
        "cluster_control_plane": "6fae8e8f10.us.cp0.konghq.com:443",
        "cluster_server_name": "6fae8e8f10.us.cp0.konghq.com",
        "cluster_telemetry_endpoint": "6fae8e8f10.us.tp0.konghq.com:443",
        "cluster_telemetry_server_name": "6fae8e8f10.us.tp0.konghq.com"
    },
    "secretVolumes": [
        "kong-cluster-cert"
    ],
    "autoscaling":{
      "enabled": true,
      "minReplicas": 4,
    }
  })
}