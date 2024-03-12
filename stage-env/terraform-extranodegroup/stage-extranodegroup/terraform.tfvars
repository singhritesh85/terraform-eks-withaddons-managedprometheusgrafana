######################Terraform EKS Extra NodeGroup######################

region = "us-east-2"
#subnet_ids = ["subnet-7cb8b707", "subnet-c9236e84", "subnet-ad5f95c5"]
subnet_ids = ["subnet-06835c14b9650e767", "subnet-077f7145b51a73b31", "subnet-03d7f196e7b5b55aa"]
eks_cluster = "eks-demo-cluster"
#eks_iam_role_name = ""
launch_template_name = "eks-extra-nodegroup-launch-template"
eks_cluster_name = "eks-demo-cluster"
node_group_name2 = "eks-nodegroup2"
eks_nodegrouprole_name = "arn:aws:iam::027330342406:role/eks-nodegroup-role"    #"eks-nodegroup-role"
instance_type = ["t3.micro", "t3.small", "t3.medium"]
disk_size = "10"
ami_type = ["AL2_x86_64", "CUSTOM"]
release_version = ["1.22.15-20221222", "1.23.16-20230217", "1.24.10-20230217", "1.25.6-20230217", "1.27.9-20240110"]
#kubernetes_version = ["1.22", "1.23", "1.24", "1.25"]
capacity_type = ["ON_DEMAND", "SPOT"]
env = ["dev", "stage", "prod"]
