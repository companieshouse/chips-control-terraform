module "instance_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.59"

  name       = format("%s-profile", var.application)
  enable_SSM = true

  s3_buckets_write = [local.session_manager_bucket_name]

  kms_key_refs = [
    "alias/${var.account}/${var.region}/ebs",
    local.ssm_kms_key_id,
    local.account_ssm_key_arn
  ]

  cw_log_group_arns = length(local.log_groups) > 0 ? [format(
    "arn:aws:logs:%s:%s:log-group:%s-*:*",
    var.aws_region,
    data.aws_caller_identity.current.account_id,
    var.application
  )] : null

  custom_statements = [
    {
      sid    = "AllowAccessToConfigBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::${var.config_bucket_name}/*",
        "arn:aws:s3:::${var.config_bucket_name}"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
        "s3:PutObject"
      ]
    },
    {
      sid       = "AllowReadOnlyAccessToECR",
      effect    = "Allow",
      resources = ["*"],
      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    },
    {
      sid       = "AllowReadOnlyDescribeAccessToEC2",
      effect    = "Allow",
      resources = ["*"],
      actions = [
        "ec2:Describe*"
      ]
    },
    {
      sid       = "AllowWriteToRoute53",
      effect    = "Allow",
      resources = ["arn:aws:route53:::hostedzone/${data.aws_route53_zone.private_zone.zone_id}"],
      actions = [
        "route53:ChangeResourceRecordSets"
      ]
    },
    {
      sid       = "AllowReadWriteOfParameterStore",
      effect    = "Allow",
      resources = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/chips/*"],
      actions = [
        "ssm:GetParameter*",
        "ssm:PutParameter"
      ]
    },
    {
      sid       = "CloudwatchMetrics"
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "cloudwatch:PutMetricData"
      ]
    },
    {
      sid       = "AllowDescribeALBs",
      effect    = "Allow",
      resources = ["*"],
      actions = [
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeRules"
      ]
    },
    {
      sid       = "AllowCHIPSALBCreateAndDeleteRule",
      effect    = "Allow",
      resources = [
        "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener/app/alb-chips*",
        "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener-rule/app/alb-chips*"
      ],
      actions = [
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:DeleteRule"
      ]
    },
    {
      sid       = "AllowCHIPSSNSPublish",
      effect    = "Allow",
      resources = [
        "arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:chips*"
      ],
      actions = [
        "sns:Publish"
      ]
    },
    {
      sid       = "AllowKMSOperationsForSNS",
      effect    = "Allow",
      resources = [
        data.aws_kms_key.sns_key.arn
      ],
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*"
      ]
    }
  ]
}

resource "aws_iam_role_policy_attachment" "inspector_cis_scanning_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspector2ManagedCisPolicy"
  role       = module.instance_profile.aws_iam_role.name
}
