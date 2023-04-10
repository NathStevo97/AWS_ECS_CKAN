resource "aws_cloudwatch_log_group" "datapusher" {
  name = "/ecs/${var.resource_name_prefix}-datapusher"
}

resource "aws_cloudwatch_log_group" "solr" {
  name = "/ecs/${var.resource_name_prefix}-solr"
}

resource "aws_cloudwatch_log_group" "ckan" {
  name = "/ecs/${var.resource_name_prefix}-ckan"
}

