resource "aws_key_pair" "keypair" {
  key_name   = var.application
  public_key = local.ec2_data["public-key"]
  tags       = merge(local.default_tags, { Name = var.application })
}
