data "aws_iam_policy_document" "remote_write" {
#  statement {
#    actions = ["sts:AssumeRoleWithWebIdentity"]
#    effect  = "Allow"

#    principals {
#      type        = "Federated"
#      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
#    }
#    condition {
#      test     = "StringEquals"
#      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
#      values = [
#        "system:serviceaccount:${var.grafana_namespace}:${var.service_account_name}"
#      ]
#    }
#  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.prometheus_namespace}:${var.service_account_name}"
      ]
    }
  }
}

#################################################################################
#Create IAM Policy for Amazon Managed Prometheus
#################################################################################

resource "aws_iam_policy" "managed_prometheus_policy" {
  name        = "AWSManagedPrometheusWriteAccessPolicy-${var.env}"
  description = "Permissions to write and Query to all Amazon Managed Prometheus workspaces"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "aps:RemoteWrite",        ### Allow Write
          "aps:QueryMetrics",       ### Allow Query
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata"
        ],
        "Resource" : "*"                    ### aws_prometheus_workspace.managed_prometheus_workspace.arn
      }
    ]
  })
}

###################################################################################
#Create IAM Role for Amazon Managed Prometheus
###################################################################################

resource "aws_iam_role" "managed_prometheus_role" {
  name               = "eks-amp-serviceaccount-role-${var.env}"
  description        = "IAM role to be used by a Kubernetes service account with write access to Amazon Managed Prometheus"
  assume_role_policy = data.aws_iam_policy_document.remote_write.json
}

###################################################################################
#Attach IAM Policy to IAM Role for Amazon Managed Prometheus
###################################################################################

resource "aws_iam_role_policy_attachment" "amp_role_attachment_1" {
  role       = aws_iam_role.managed_prometheus_role.name
  policy_arn = aws_iam_policy.managed_prometheus_policy.arn
}

resource "aws_iam_role_policy_attachment" "amp_role_attachment_2" {
  role       = aws_iam_role.managed_prometheus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

###################################################################################
#Create Prometheus Workspace
###################################################################################

resource "aws_prometheus_workspace" "managed_prometheus_workspace" {
  alias = var.prometheus_workspace_alias

  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
}

###################################################################################
#Create Grafana Workspace
###################################################################################

resource "random_id" "id" {
  byte_length = 4
}

resource "aws_iam_policy" "managed_grafanaprometheus_policy" {
  name        = "AmazonGrafanaPrometheusPolicy-${random_id.id.hex}"
  description = "Allows Amazon Grafana to access Amazon Prometheus"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "aps:ListWorkspaces",
                "aps:DescribeWorkspace",
                "aps:QueryMetrics",
                "aps:GetLabels",
                "aps:GetSeries",
                "aps:GetMetricMetadata"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_policy" "managed_grafanasns_policy" {
  name        = "AmazonGrafanaSNSPolicy-${random_id.id.hex}"
  description = "Allows Amazon Grafana to publish to SNS"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:*:027330342406:grafana*"
            ]
        }
    ]
  })
}

resource "aws_iam_role" "grafana_role" {
  name = "AmazonGrafanaServiceRole-${random_id.id.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
   })
}

resource "aws_iam_role_policy_attachment" "amg_role_attachment_1" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = aws_iam_policy.managed_grafanaprometheus_policy.arn
}

resource "aws_iam_role_policy_attachment" "amg_role_attachment_2" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = aws_iam_policy.managed_grafanasns_policy.arn
}

resource "aws_grafana_workspace" "managed_grafana" {
  account_access_type      = "CURRENT_ACCOUNT"
  name                     = var.grafana_workspace_name
  authentication_providers = ["AWS_SSO"]               ### ["SAML"]     ### ["AWS_SSO", "SAML"]
  permission_type          = "CUSTOMER_MANAGED"        ### "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.grafana_role.arn
  grafana_version          = var.grafana_version          #["8.4", "9.4"]

  vpc_configuration {
    security_group_ids = [aws_security_group.grafana_sg.id] 
    subnet_ids = aws_subnet.private_subnet.*.id   ###concat("${aws_subnet.public_subnet.*.id}", "${aws_subnet.private_subnet.*.id}") 
  }
  
  data_sources = [var.data_sources]
  notification_destinations = ["SNS"]
  
  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  } 
}

###################################################################################
#Create kubeconfig file
###################################################################################

#resource "null_resource" "create_kubeconfig" {
  
#  provisioner "local-exec" {
#    command = <<-EOT
#                    "aws eks update-kubeconfig --region ${data.aws_region.reg.name} --name ${aws_eks_cluster.eksdemo.name}"
#                    "chmod 600 ~/.kube/config"
#    EOT

#    on_failure = continue
#  }

#  depends_on = [aws_eks_cluster.eksdemo, aws_eks_node_group.eksnode] 

#}

###################################################################################
#Create Namespace in EKS Cluster
###################################################################################

#resource "kubernetes_namespace" "prometheus" {
#  metadata {
#    name = var.prometheus_namespace
#  }

#  depends_on = [aws_eks_cluster.eksdemo, aws_eks_node_group.eksnode, null_resource.create_kubeconfig]

#}
#locals {
#    args = ["--name", "aps", "--region", data.aws_region.reg.name, "--host aps-workspaces.${data.aws_region.reg.name}.amazonaws.com", "--port", ":8005"]
#}

###################################################################################
#Using Helm Install and Update the Prometheus Server Configuration
###################################################################################

#resource "helm_release" "install_prometheus" {
#  name         = "prometheus"  ### Name of the Helm Release after creation, other name can also be choosen
#  repository   = "https://prometheus-community.github.io/helm-charts"
#  chart        = "prometheus"
#  namespace    = var.prometheus_namespace
#  version      = "25.17.0"
#}

#resource "null_resource" "prometheus_update" {

#  provisioner "local-exec" {
#    command     = "helm upgrade prometheus prometheus-community/prometheus -n ${var.prometheus_namespace} -f ${path.module}/helm-config/managed_prometheus_values.yaml --version 25.17.0"        ### --version can be mentioned if needed
#    interpreter = ["/usr/bin/env", "bash", "-c"]
#  }

#  depends_on = [
#    helm_release.install_prometheus, 
#  ]
#}
