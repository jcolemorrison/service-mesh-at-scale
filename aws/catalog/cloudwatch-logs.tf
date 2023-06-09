resource "aws_cloudwatch_log_group" "acl" {
  name_prefix = "${local.project_tag}-acl-"
}

resource "aws_cloudwatch_log_group" "catalog" {
  name_prefix = "${local.project_tag}-catalog-"
}

resource "aws_cloudwatch_log_group" "catalog_sidecars" {
  name_prefix = "${local.project_tag}-catalog-sidecars-"
}

resource "aws_cloudwatch_log_group" "mesh_gateway" {
  name_prefix = "${local.project_tag}-catalog-sidecars-"
}

locals {
  acl_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.acl.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-acl-"
    }
  }
  catalog_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.catalog.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-catalog"
    }
  }
  catalog_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.catalog_sidecars.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-catalog-sidecars-"
    }
  }
  mesh_gateway_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.mesh_gateway.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-mesh-gatway-"
    }
  }
}