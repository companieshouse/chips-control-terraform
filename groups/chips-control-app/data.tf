data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_ec2_managed_prefix_list" "administration" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared-services-management" {
  name = "shared-services-management-cidrs"
}

data "vault_generic_secret" "ch_development_concourse_cidrs" {
  path = "/aws-accounts/network/ch-development-private-management-cidrs"
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
  most_recent = true
}

data "aws_kms_key" "sns_key" {
  key_id = "alias/${var.account}/${var.region}/sns"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/app/ec2"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "nfs_mounts" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/app/nfs_mounts"
}

data "aws_ami" "ami" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.ami_name == "docker-ami-*" ? true : false

  filter {
    name = "name"
    values = [
      var.ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    ANSIBLE_INPUTS             = jsonencode(local.userdata_ansible_inputs)
    DNS_DOMAIN                 = local.internal_fqdn
    DNS_ZONE_ID                = data.aws_route53_zone.private_zone.zone_id
    HERITAGE_ENVIRONMENT       = title(var.environment)
  }
}

data "template_cloudinit_config" "userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata.rendered
  }
}
