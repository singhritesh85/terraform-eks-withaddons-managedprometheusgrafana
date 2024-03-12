variable "region" {
  type = string
  description = "Provide the AWS Region into which EKS Cluster to be created"
}

variable "vpc_cidr"{
description = "Provide the CIDR for VPC"
type = string
#default = "10.10.0.0/16"
}

variable "private_subnet_cidr"{
description = "Provide the cidr for Private Subnet"
type = list
#default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "public_subnet_cidr"{
description = "Provide the cidr of the Public Subnet"
type = list
#default = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]
}

data "aws_partition" "amazonwebservices" {
}

data "aws_region" "reg" {
}

data "aws_availability_zones" "azs" {
}

data "aws_caller_identity" "G_Duty" {
}

variable "igw_name" {
description = "Provide the Name of Internet Gateway"
type = string
#default = "test-IGW"
}

variable "natgateway_name" {
description = "Provide the Name of NAT Gateway"
type = string
#default = "EKS-NatGateway"
}

variable "vpc_name" {
description = "Provide the Name of VPC"
type = string
#default = "test-vpc"
}




variable "eks_cluster" {
  type     = string
  description = "Provide the EKS Cluster Name"
}

variable "eks_iam_role_name" {
  type = string
  description = "Provide the EKS IAM Role Name"
}

variable "node_group_name" {
  type = string
  description = "Provide the Node Group Name"
}

variable "eks_nodegrouprole_name" {
  type = string
  description = "Provide the Node Group Role Name"
}

variable "launch_template_name" {
  type = string
  description = "Provide the Launch Template Name"
}

#variable "eks_ami_id" {
#  type = list
#  description = "Provide the EKS AMI ID"
#}

variable "instance_type" {
  type = list
  description = "Provide the Instance Type EKS Worker Node" 
}

variable "disk_size" {
  type = number
  description = "Provide the EBS Disk Size"
}

variable "capacity_type" {
  type = list
  description = "Provide the Capacity Type of Worker Node"
}

variable "ami_type" {
  type = list
  description = "Provide the AMI Type"
}

variable "release_version" {
  type = list
  description = "AMI version of the EKS Node Group"
}

variable "kubernetes_version" {
  type = list
  description = "Desired Kubernetes master version."
}

variable "env" {
  type = list
  description = "Provide the Environment for EKS Cluster and NodeGroup"
}

variable "ebs_csi_name" {
  type = string
  description = "Provide the addon name"
}

variable "ebs_csi_version" {
  type = list
  description = "Provide the ebs csi driver version"
}

variable "addon_version_guardduty" {
  type = list
  description = "Provide the addon version for Guard Duty"
}

variable "addon_version_kubeproxy" {
  type = list
  description = "Provide the addon version for kube-proxy"
}

variable "addon_version_vpc_cni" {
  type = list
  description = "Provide the addon version for VPC-CNI"
}

variable "addon_version_coredns" {
  type = list
  description = "Provide the addon version for core-dns"
}

variable "service_account_name" {
  description = "Provide the name of IAM Proxy Service Account."
  type        = string
}

variable "grafana_namespace" {
  description = "Provide the name of Grafana namespace."
  type        = string
}

variable "prometheus_namespace" {
  description = "Provide the name of Prometheus namespace."
  type        = string
}

variable "prometheus_workspace_alias" {
  description = "Provide the name for Prometheus workspace to be used"
  type        = string
}

variable "grafana_workspace_name" {
  type = string
  description = "Provide the name of Grafana Workspace"
}

variable "grafana_version" {
  type = list
  description = "Select the Grafana Version to be used"
}

variable "data_sources" {
  type = list
  description = "Select the Data Sources for Grafana"
}
