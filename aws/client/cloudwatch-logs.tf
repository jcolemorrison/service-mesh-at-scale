resource "aws_cloudwatch_log_group" "acl" {
  name_prefix = "${local.project_tag}-acl-"
}

resource "aws_cloudwatch_log_group" "client" {
  name_prefix = "${local.project_tag}-client-"
}

resource "aws_cloudwatch_log_group" "client_sidecars" {
  name_prefix = "${local.project_tag}-client-sidecars-"
}

resource "aws_cloudwatch_log_group" "catalog" {
  name_prefix = "${local.project_tag}-catalog-"
}

resource "aws_cloudwatch_log_group" "catalog_sidecars" {
  name_prefix = "${local.project_tag}-catalog-sidecars-"
}

resource "aws_cloudwatch_log_group" "customers" {
  name_prefix = "${local.project_tag}-customers-"
}

resource "aws_cloudwatch_log_group" "customers_sidecars" {
  name_prefix = "${local.project_tag}-customers-sidecars-"
}

resource "aws_cloudwatch_log_group" "orders" {
  name_prefix = "${local.project_tag}-orders-"
}

resource "aws_cloudwatch_log_group" "orders_sidecars" {
  name_prefix = "${local.project_tag}-orders-sidecars-"
}

resource "aws_cloudwatch_log_group" "mesh_gateway" {
  name_prefix = "${local.project_tag}-client-sidecars-"
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
  client_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-client"
    }
  }
  client_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.client_sidecars.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-client-sidecars-"
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
  customers_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.customers.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-customers"
    }
  }
  customers_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.customers_sidecars.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-customers-sidecars-"
    }
  }
  orders_logs_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.orders.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-orders"
    }
  }
  orders_sidecars_log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.orders_sidecars.name
      awslogs-region        = var.aws_default_region
      awslogs-stream-prefix = "${local.project_tag}-orders-sidecars-"
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