# ------------------------------------------------------------------------------
# RDS Security Group and rules
# ------------------------------------------------------------------------------
module "rds_security_group" {
  for_each = var.rds_databases

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "sgr-${each.key}-rds-001"
  description = format("Security group for the ${each.key} RDS database")
  vpc_id      = data.aws_vpc.vpc.id

  ingress_with_source_security_group_id = local.rds_ingress_from_services[each.key]

  egress_rules = ["all-all"]
  tags         = merge(local.default_tags, { Name = "sgr-${each.key}-rds-001" })
}
resource "aws_security_group_rule" "admin_oracle_db" {
  for_each = var.rds_databases

  description       = "Allow Oracle DB listener from admin prefix list"
  type              = "ingress"
  from_port         = 1521
  to_port           = 1521
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.admin.id]
  security_group_id = module.rds_security_group[each.key].security_group_id
}

resource "aws_security_group_rule" "admin_oracle_em" {
  for_each = var.rds_databases

  description       = "Allow Oracle Enterprise Manager from admin prefix list"
  type              = "ingress"
  from_port         = 5500
  to_port           = 5500
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.admin.id]
  security_group_id = module.rds_security_group[each.key].security_group_id
}
# ------------------------------------------------------------------------------
# RDS Instance
# ------------------------------------------------------------------------------
module "rds" {
  for_each = var.rds_databases

  source  = "terraform-aws-modules/rds/aws"
  version = "6.13.1"

  create_db_parameter_group = true
  create_db_subnet_group    = true

  character_set_name          = lookup(each.value, "character_set_name", "AL32UTF8")
  identifier                  = join("-", ["rds", each.key, var.environment, "001"])
  engine                      = lookup(each.value, "engine", "oracle-se2")
  major_engine_version        = lookup(each.value, "major_engine_version", "19")
  engine_version              = lookup(each.value, "engine_version", "19")
  auto_minor_version_upgrade  = lookup(each.value, "auto_minor_version_upgrade", false)
  license_model               = lookup(each.value, "license_model", "license-included")
  instance_class              = lookup(each.value, "instance_class", "db.t3.micro")
  allocated_storage           = lookup(each.value, "allocated_storage", 10)
  storage_type                = lookup(each.value, "storage_type", null)
  iops                        = lookup(each.value, "iops", null)
  multi_az                    = lookup(each.value, "multi_az", false)
  storage_encrypted           = true
  kms_key_id                  = data.aws_kms_key.rds.arn
  option_group_description    = "Option group for ${join("-", ["rds", each.key, var.environment, "001"])}"
  parameter_group_description = "Database parameter group for ${join("-", ["rds", each.key, var.environment, "001"])}"
  db_subnet_group_description = "Database subnet group for ${join("-", ["rds", each.key, var.environment, "001"])}"

  db_name  = upper(each.key)
  username = local.rds_data[each.key]["admin-username"]
  password = local.rds_data[each.key]["admin-password"]
  port     = 1521

  manage_master_user_password = false
  deletion_protection         = true
  maintenance_window          = lookup(each.value, "rds_maintenance_window", "Mon:00:00-Mon:03:00")
  backup_window               = lookup(each.value, "rds_backup_window", "03:00-06:00")
  backup_retention_period     = lookup(each.value, "backup_retention_period", 7)
  skip_final_snapshot         = false

  # Enhanced Monitoring
  monitoring_interval             = 30
  monitoring_role_arn             = data.aws_iam_role.rds_enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = lookup(each.value, "rds_log_exports", null)

  performance_insights_enabled          = var.environment == "live" ? true : false
  performance_insights_kms_key_id       = data.aws_kms_key.rds.arn
  performance_insights_retention_period = 7

  ca_cert_identifier = "rds-ca-rsa2048-g1"

  # RDS Security Group
  vpc_security_group_ids = flatten([
    module.rds_security_group[each.key].security_group_id,
    data.aws_security_group.rds_shared.id,
  ])

  # DB subnet group
  # subnet_ids = data.aws_subnet_ids.data.ids
  subnet_ids = data.aws_subnets.application.ids

  # DB Parameter group
  family = join("-", [each.value.engine, each.value.major_engine_version])

  parameters = var.parameter_group_settings[each.key]

  options = concat([
    {
      option_name                    = "OEM"
      port                           = "5500"
      vpc_security_group_memberships = [module.rds_security_group[each.key].security_group_id]
    },
    {
      option_name = "SQLT"
      version     = "2018-07-25.v1"
      option_settings = [
        {
          name  = "LICENSE_PACK"
          value = "N"
        },
      ]
    },
  ], each.value.per_instance_options)

  timeouts = {
    "create" : "60m",
    "delete" : "60m",
    "update" : "60m"
  }

  tags = merge(
    local.default_tags,
    {
      ServiceTeam = format("%s-DBA-Support", upper(each.key))
      Name        = join("-", ["rds", each.key, var.environment, "001"])
    }
  )
}

module "rds_start_stop_schedule" {
  source = "git@github.com:companieshouse/terraform-modules//aws/rds_start_stop_schedule?ref=tags/1.0.354"

  for_each = var.rds_start_stop_schedule

  rds_schedule_enable = lookup(each.value, "rds_schedule_enable", false)

  rds_instance_id    = module.rds[each.key].db_instance_identifier
  rds_start_schedule = lookup(each.value, "rds_start_schedule")
  rds_stop_schedule  = lookup(each.value, "rds_stop_schedule")
}

module "rds_cloudwatch_alarms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/oracledb_cloudwatch_alarms?ref=tags/1.0.236"

  for_each = var.rds_cloudwatch_alarms


  db_instance_id = module.rds[each.key].db_instance_identifier

  db_instance_shortname = upper(each.key)
  alarm_actions_enabled = lookup(each.value, "alarm_actions_enabled")
  alarm_name_prefix     = "Oracle RDS"
  alarm_topic_name      = lookup(each.value, "alarm_topic_name")
  alarm_topic_name_ooh  = lookup(each.value, "alarm_topic_name_ooh")
}
