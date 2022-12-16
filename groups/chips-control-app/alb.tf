module "internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.5"

  name                       = "alb-${var.application}-int-01"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = false
  idle_timeout               = 120

  security_groups = [module.internal_alb_security_group.security_group_id]
  subnets         = data.aws_subnet_ids.application.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      default_action = {
        type         = "fixed-response"
        status_code  = "503"
        content_type = "text/plain"
      }
    }
  ]

  https_listener_rules = concat(
    [{
      https_listener_index = 0
      priority             = 10

      actions = [
        {
          type               = "forward"
          target_group_index = 0
          weight             = 100
        }
      ]
      conditions = [{ host_headers = [format("%s*.*", var.application)] }]

    }]
  )

  target_groups = concat(
    [{
      name                 = format("tg-%s-app", var.application)
      backend_protocol     = "HTTP"
      backend_port         = var.application_port
      target_type          = "instance"
      deregistration_delay = 60
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.application_health_check_path
        port                = var.application_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }

      tags = {
        InstanceTargetGroupTag = var.application
      }
    }]
  )
}
