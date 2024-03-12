variable "vpc_cidr"{

}

variable "private_subnet_cidr"{

}

variable "public_subnet_cidr"{

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

}

variable "natgateway_name" {

}

variable "vpc_name" {

}

variable "eks_cluster" {

}

variable "eks_iam_role_name" {

}

variable "node_group_name" {

}

variable "eks_nodegrouprole_name" {

}

variable "launch_template_name" {

}

variable "instance_type" {

}

#variable "eks_ami_id" {

#}

variable "disk_size" {

}

variable "capacity_type" {

}

variable "ami_type" {

}

variable "release_version" {

}

variable "kubernetes_version" {

}

variable "env" {

}

variable "ebs_csi_name" {

}

variable "ebs_csi_version" {

}

variable "addon_version_guardduty" {

}

variable "addon_version_kubeproxy" {

}

variable "addon_version_vpc_cni" {

} 

variable "addon_version_coredns" {

}

variable "service_account_name" {

}

variable "grafana_namespace" {

}

variable "prometheus_namespace" {

}

variable "prometheus_workspace_alias" {

}

variable "grafana_workspace_name" {

}

variable "grafana_version" {

}

variable "data_sources" {

}
