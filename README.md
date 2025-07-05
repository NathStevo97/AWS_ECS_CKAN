# CKAN on AWS

Repository containing code to deploy a sample version of CKAN to AWS via Terraform.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.91.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ckan-cluster"></a> [ckan-cluster](#module\_ckan-cluster) | ./modules/ckan-cluster | n/a |
| <a name="module_postgres"></a> [postgres](#module\_postgres) | ./modules/postgres | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ./modules/redis | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.21.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_cidr_blocks"></a> [admin\_cidr\_blocks](#input\_admin\_cidr\_blocks) | n/a | `string` | `""` | no |
| <a name="input_availability_zone_map"></a> [availability\_zone\_map](#input\_availability\_zone\_map) | n/a | `map(any)` | <pre>{<br/>  "eu-west-2a": "eu-west-2a",<br/>  "eu-west-2b": "eu-west-2b",<br/>  "eu-west-2c": "eu-west-2c"<br/>}</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | `""` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | n/a | `string` | `""` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Database instance type e.g. db.t2.micro, this can be adjusted to suit using the options at https://aws.amazon.com/rds/instance-types/ | `string` | `"db.t2.micro"` | no |
| <a name="input_lb_acm_certificate_arn"></a> [lb\_acm\_certificate\_arn](#input\_lb\_acm\_certificate\_arn) | n/a | `string` | `""` | no |
| <a name="input_rds_database_name"></a> [rds\_database\_name](#input\_rds\_database\_name) | n/a | `string` | `"ckan"` | no |
| <a name="input_rds_database_password"></a> [rds\_database\_password](#input\_rds\_database\_password) | n/a | `string` | `"ckan"` | no |
| <a name="input_rds_database_username"></a> [rds\_database\_username](#input\_rds\_database\_username) | n/a | `string` | `"ckan"` | no |
| <a name="input_rds_readonly_database_name"></a> [rds\_readonly\_database\_name](#input\_rds\_readonly\_database\_name) | n/a | `string` | `"ckan_readonly"` | no |
| <a name="input_rds_readonly_database_password"></a> [rds\_readonly\_database\_password](#input\_rds\_readonly\_database\_password) | n/a | `string` | `"readonly"` | no |
| <a name="input_rds_readonly_database_user"></a> [rds\_readonly\_database\_user](#input\_rds\_readonly\_database\_user) | n/a | `string` | `"readonly"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | n/a | `string` | `"ckan"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution"></a> [cloudfront\_distribution](#output\_cloudfront\_distribution) | n/a |
| <a name="output_database_address"></a> [database\_address](#output\_database\_address) | n/a |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | n/a |
| <a name="output_load_balancer_dns"></a> [load\_balancer\_dns](#output\_load\_balancer\_dns) | n/a |
| <a name="output_redis_address"></a> [redis\_address](#output\_redis\_address) | n/a |
<!-- END_TF_DOCS -->
