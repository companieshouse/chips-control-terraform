# chips-control-terraform
Infrastructure code to support CHIPS RunDeck service

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0, < 6.0.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0, < 6.0.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asg"></a> [asg](#module\_asg) | git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template | tags/1.0.356 |
| <a name="module_asg_alarms"></a> [asg\_alarms](#module\_asg\_alarms) | git@github.com:companieshouse/terraform-modules//aws/asg-cloudwatch-alarms | tags/1.0.356 |
| <a name="module_asg_security_group"></a> [asg\_security\_group](#module\_asg\_security\_group) | terraform-aws-modules/security-group/aws | 5.0 |
| <a name="module_cloudwatch_sns_email"></a> [cloudwatch\_sns\_email](#module\_cloudwatch\_sns\_email) | terraform-aws-modules/sns/aws | 6.2.1 |
| <a name="module_cloudwatch_sns_ooh"></a> [cloudwatch\_sns\_ooh](#module\_cloudwatch\_sns\_ooh) | terraform-aws-modules/sns/aws | 6.2.1 |
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.356 |
| <a name="module_internal_alb"></a> [internal\_alb](#module\_internal\_alb) | terraform-aws-modules/alb/aws | 8.7.0 |
| <a name="module_internal_alb_security_group"></a> [internal\_alb\_security\_group](#module\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | 5.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 6.13.1 |
| <a name="module_rds_cloudwatch_alarms"></a> [rds\_cloudwatch\_alarms](#module\_rds\_cloudwatch\_alarms) | git@github.com:companieshouse/terraform-modules//aws/oracledb_cloudwatch_alarms | tags/1.0.195 |
| <a name="module_rds_security_group"></a> [rds\_security\_group](#module\_rds\_security\_group) | terraform-aws-modules/security-group/aws | 5.0 |
| <a name="module_rds_start_stop_schedule"></a> [rds\_start\_stop\_schedule](#module\_rds\_start\_stop\_schedule) | git@github.com:companieshouse/terraform-modules//aws/rds_start_stop_schedule | tags/1.0.354 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role_policy_attachment.inspector_cis_scanning_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group_rule.admin_oracle_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.admin_oracle_em](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ch_development_concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.heritage_development_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.http_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ec2_managed_prefix_list.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.administration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.shared-services-management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_role.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.https_access_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_groups.https_access_group_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_security_group.rds_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.rds_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.userdata_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ch_development_concourse_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.nfs_mounts](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.rundeck_rds](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_allow_concourse_access"></a> [allow\_concourse\_access](#input\_allow\_concourse\_access) | Whether to allow concourse worker subnets access to the ALB | `bool` | `false` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration | `string` | `"docker-ami-*"` | no |
| <a name="input_application"></a> [application](#input\_application) | The component name of the application | `string` | n/a | yes |
| <a name="input_application_health_check_path"></a> [application\_health\_check\_path](#input\_application\_health\_check\_path) | Target group health check path for application | `string` | `"/"` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Target group backend port for application | `number` | `4440` | no |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | The parent name of the application | `string` | `"chips"` | no |
| <a name="input_asg_count"></a> [asg\_count](#input\_asg\_count) | The number of ASGs - typically 1 for dev and 2 for staging/live | `number` | n/a | yes |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The desired capacity of ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The max size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The min size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_cloudwatch_logs"></a> [cloudwatch\_logs](#input\_cloudwatch\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | Bucket name the application will use to retrieve configuration files | `string` | `"shared-services.eu-west-2.configs.ch.gov.uk"` | no |
| <a name="input_default_log_group_retention_in_days"></a> [default\_log\_group\_retention\_in\_days](#input\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_enable_instance_refresh"></a> [enable\_instance\_refresh](#input\_enable\_instance\_refresh) | Enable or disable instance refresh when the ASG is updated | `bool` | `false` | no |
| <a name="input_enable_sns_topic"></a> [enable\_sns\_topic](#input\_enable\_sns\_topic) | A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions | `bool` | `false` | no |
| <a name="input_enforce_imdsv2"></a> [enforce\_imdsv2](#input\_enforce\_imdsv2) | Whether to enforce use of IMDSv2 by setting http\_tokens to required on the aws\_launch\_configuration | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_https_access_sg_patterns"></a> [https\_access\_sg\_patterns](#input\_https\_access\_sg\_patterns) | List of source security group name patterns that will have access to the ALB HTTPS port | `list(string)` | `[]` | no |
| <a name="input_instance_root_volume_size"></a> [instance\_root\_volume\_size](#input\_instance\_root\_volume\_size) | Size of root volume attached to instances | `number` | `40` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_instance_swap_volume_size"></a> [instance\_swap\_volume\_size](#input\_instance\_swap\_volume\_size) | Size of swap volume attached to instances | `number` | `5` | no |
| <a name="input_nfs_mount_destination_parent_dir"></a> [nfs\_mount\_destination\_parent\_dir](#input\_nfs\_mount\_destination\_parent\_dir) | The parent folder that all NFS shares should be mounted inside on the EC2 instance | `string` | `"/mnt"` | no |
| <a name="input_parameter_group_settings"></a> [parameter\_group\_settings](#input\_parameter\_group\_settings) | A map whose keys represent RDS instances and whose values are a list of parameters that will be set in the RDS instance parameter group | `map(list(any))` | n/a | yes |
| <a name="input_rds_cloudwatch_alarms"></a> [rds\_cloudwatch\_alarms](#input\_rds\_cloudwatch\_alarms) | A map whose keys represent RDS instances and whose values define RDS CloudWatch Alarms configuration | `map(map(any))` | n/a | yes |
| <a name="input_rds_databases"></a> [rds\_databases](#input\_rds\_databases) | ------------------------------------------------------------------------------ RDS Variables ------------------------------------------------------------------------------ | `map(any)` | n/a | yes |
| <a name="input_rds_ingress_groups"></a> [rds\_ingress\_groups](#input\_rds\_ingress\_groups) | A map whose keys represent RDS instances and whose values are lists of strings representing security group filter patterns | `map(list(string))` | n/a | yes |
| <a name="input_rds_start_stop_schedule"></a> [rds\_start\_stop\_schedule](#input\_rds\_start\_stop\_schedule) | A map whose keys represent RDS instances and whose values define configuration for RDS start/stop schedules | `map(map(any))` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |

## Outputs

No outputs.
