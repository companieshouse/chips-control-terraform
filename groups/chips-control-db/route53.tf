# resource "aws_route53_record" "rds" {
#   for_each = { for key, database in var.rds_databases : key => database }

#   zone_id = data.aws_route53_zone.private_zone.zone_id
#   name    = format("%s%s", each.key, "db")
#   type    = "CNAME"
#   ttl     = "300"
#   records = [module.rds[each.key].this_db_instance_address]
# }
resource "aws_route53_record" "rds" {
  for_each = var.rds_databases

  name    = try(each.value.record_name, format("%sdb", each.key))
  zone_id = data.aws_route53_zone.private_zone.zone_id
  records = [try(
    module.rds[each.key].this_db_instance_address,
    module.rds[each.key].db_instance_address,
    module.rds[each.key].address,
    module.rds[each.key].endpoint
  )]
  ttl     = 300
  type    = "CNAME"
}