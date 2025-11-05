resource "aws_route53_record" "rds" {
  for_each = var.rds_databases

  name    = try(each.value.record_name, format("%sdb", each.key))
  zone_id = data.aws_route53_zone.private_zone.zone_id
  records = [module.rds[each.key].db_instance_address]
  ttl     = 300
  type    = "CNAME"
}