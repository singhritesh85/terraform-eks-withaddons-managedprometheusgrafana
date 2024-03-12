module "eks_cluster" {
  source = "../module"

  vpc_cidr = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  igw_name = var.igw_name
  natgateway_name = var.natgateway_name
  vpc_name = var.vpc_name

  eks_cluster = var.eks_cluster
  eks_iam_role_name = var.eks_iam_role_name
  node_group_name = var.node_group_name
  eks_nodegrouprole_name = var.eks_nodegrouprole_name    
  launch_template_name = var.launch_template_name
#  eks_ami_id = var.eks_ami_id
  instance_type = var.instance_type
  disk_size = var.disk_size
  ami_type = var.ami_type
  release_version = var.release_version
  kubernetes_version = var.kubernetes_version
  capacity_type = var.capacity_type
  env = var.env[1]
  ebs_csi_name = var.ebs_csi_name

  ebs_csi_version         = var.ebs_csi_version[3]
  addon_version_guardduty = var.addon_version_guardduty[0]
  addon_version_kubeproxy = var.addon_version_kubeproxy[3]
  addon_version_vpc_cni   = var.addon_version_vpc_cni[3]
  addon_version_coredns   = var.addon_version_coredns[3]


  service_account_name = var.service_account_name      ###"${var.service_account_name}-${var.env[1]}"
  grafana_namespace    = var.grafana_namespace         ###"${var.grafana_namespace}-${var.env[1]}"
  prometheus_namespace = var.prometheus_namespace      ###"${var.prometheus_namespace}-${var.env[1]}"
  prometheus_workspace_alias = "${var.prometheus_workspace_alias}-${var.env[1]}"

  
  grafana_workspace_name = "${var.grafana_workspace_name}-${var.env[1]}"
  grafana_version = var.grafana_version[0]
  data_sources = var.data_sources[3]  

}
