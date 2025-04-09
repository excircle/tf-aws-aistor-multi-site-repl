#------------------------------------------------------------------------------
# VPCS
#------------------------------------------------------------------------------

////////////
// West 2 //
////////////

module "minio-vpc-west-2" {
  source = "github.com/excircle/tf-aws-minio-vpc"
  providers = {
    aws = aws.us-west-2
  }

  application_name      = "minio-vpc-west-2"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc-west-2"
}

#------------------------------------------------------------------------------
# CLUSTERS
#------------------------------------------------------------------------------

////////////
// West 2 //
////////////

# module "minio-us-west-2-cluster1" {
#   source = "./modules/dummie-nodes/tf-aws-minio-cluster"
#   providers = {
#     aws = aws.us-west-2
#   }

#   application_name          = "minio-us-west-2-cluster1"
#   system_user               = "ubuntu"
#   hosts                     = 2                                     # Number of nodes with MinIO installed
#   vpc_id                    = module.minio-vpc-west-2.vpc_id
#   minio_license             = var.minio_license                     # Required only if using: minio_flavor = "aistor"
#   minio_flavor              = "aistor"
#   minio_binary_version      = "latest"  # Example: "minio.RELEASE.2025-01-17T05-24-29Z" or "latest"
#   minio_binary_arch         = "linux-amd64"
#   ebs_root_volume_size      = 30
#   ebs_storage_volume_size   = 20
#   make_private              = false
#   ec2_instance_type         = "t2.medium"
#   ec2_ami_image             = "ami-0606dd43116f5ed57"               # (ami-0884d2865dbe9de4b) Ubuntu 22.04 - us-west-2
#   az_count                  = 2                                     # Number of AZs to use
#   subnets                   = module.minio-vpc-west-2.subnets
#   num_disks                 = 4                                     # Creates a number of disks
#   sshkey                    = var.sshkey                            # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
#   ec2_key_name              = "sshkey"
#   package_manager           = "apt"
#   bastion_host              = false
# }

# module "minio-us-west-2-cluster2" {
#   source = "./modules/dummie-nodes/tf-aws-minio-cluster"
#   providers = {
#     aws = aws.us-west-2
#   }

#   application_name          = "minio-us-west-2-cluster2"
#   system_user               = "ubuntu"
#   hosts                     = 2                                     # Number of nodes with MinIO installed
#   vpc_id                    = module.minio-vpc-west-2.vpc_id
#   minio_license             = var.minio_license                     # Required only if using: minio_flavor = "aistor"
#   minio_flavor              = "aistor"
#   minio_binary_version      = "latest"  # Example: "minio.RELEASE.2025-01-17T05-24-29Z" or "latest"
#   minio_binary_arch         = "linux-amd64"
#   ebs_root_volume_size      = 30
#   ebs_storage_volume_size   = 20
#   make_private              = false
#   ec2_instance_type         = "t2.medium"
#   ec2_ami_image             = "ami-0606dd43116f5ed57"               # (ami-0884d2865dbe9de4b) Ubuntu 22.04 - us-west-2
#   az_count                  = 2                                     # Number of AZs to use
#   subnets                   = module.minio-vpc-west-2.subnets
#   num_disks                 = 4                                     # Creates a number of disks
#   sshkey                    = var.sshkey                            # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
#   ec2_key_name              = "sshkey"
#   package_manager           = "apt"
#   bastion_host              = false
# }

#------------------------------------------------------------------------------
# DISKS
#------------------------------------------------------------------------------

//////////////////////
// West 2 - Disks 1 //
//////////////////////

# module "minio-west-2-cluster1-disks" {

#   source = "github.com/excircle/tf-aws-minio-disks"
#   providers = {
#     aws = aws.us-west-2
#   }

#   minio_hosts = module.minio-us-west-2-cluster1.minio_host_info
#   disk_names = module.minio-us-west-2-cluster1.disk-names
#   ebs_storage_volume_size = module.minio-us-west-2-cluster1.ebs_storage_volume_size
# }

# module "minio-west-2-cluster2-disks" {

#   source = "github.com/excircle/tf-aws-minio-disks"
#   providers = {
#     aws = aws.us-west-2
#   }

#   minio_hosts = module.minio-us-west-2-cluster2.minio_host_info
#   disk_names = module.minio-us-west-2-cluster2.disk-names
#   ebs_storage_volume_size = module.minio-us-west-2-cluster2.ebs_storage_volume_size
# }