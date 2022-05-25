resource "aws_instance" "ec2_instance" {
  ami                     = var.amis[var.region]
  instance_type           = "t3.micro"
  disable_api_termination = false

  network_interface {
    network_interface_id = aws_network_interface.ec2_interface.id
    device_index         = 0
  }

  tags = {
    Name = "tf-michael-learning-ec2"
  }
}

resource "aws_vpc" "ec2_vpc" {
  cidr_block = "172.30.0.0/16"

  tags = {
    Name = "tf-michael-vpc"
  }
}

resource "aws_subnet" "ec2_subnet" {
  vpc_id            = aws_vpc.ec2_vpc.id
  cidr_block        = "172.30.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-michael-subnet"
  }
}

resource "aws_network_interface" "ec2_interface" {
  subnet_id   = aws_subnet.ec2_subnet.id
  private_ips = ["172.30.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}





resource "aws_db_instance" "pg_instance" {
  count = "${contains(list("pgsql", "pgsql10", "pgsql12"), var.db_type) ? 1 : 0}"

  identifier             = "${lower(replace(var.app_name, " ", "-"))}-pgsql"
  engine                 = "postgres"
  engine_version         = "${var.engine_version_override == "" ?  var.engine_version[format("%s-%s",var.deployment_env,var.db_type)] : var.engine_version_override}"
  instance_class         = "${var.instance_class_override == "" ?  var.instance_class[var.deployment_env] : var.instance_class_override}"
  port                   = "${var.port_override == "" ? local.port : var.port_override}"
  username               = "${var.username}"
  password               = "${var.password}"
  db_subnet_group_name   = "${aws_db_subnet_group.pg_instance_subnet_group.name}"
  parameter_group_name   = "${aws_db_parameter_group.db_parameter_group.name}"
  vpc_security_group_ids = ["${split(",", var.vpc_security_group_ids)}"]
  storage_type           = "${var.storage_type}"
  deletion_protection    = "${var.deletion_protection}"

  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade_override == "" ? var.auto_minor_version_upgrade[var.deployment_env] : var.auto_minor_version_upgrade_override}"
  monitoring_interval        = "${var.monitoring_interval_override == "" ? var.monitoring_interval[var.deployment_env] : var.monitoring_interval_override}"
  monitoring_role_arn        = "${var.monitoring_role_arn[var.deployment_env]}"
  performance_insights_enabled = "${var.performance_insights_enabled_override == "" ? var.performance_insights_enabled[var.deployment_env] : var.performance_insights_enabled_override}"

  maintenance_window      = "${var.preferred_maintenance_window[var.deployment_env]}"
  backup_window           = "${var.preferred_backup_window[var.deployment_env]}"
  backup_retention_period = "${var.backup_retention_period[var.deployment_env]}"

  skip_final_snapshot = "${var.skip_final_snapshot}"

  multi_az              = "${var.multi_az[var.deployment_env]}"
  allocated_storage     = "${var.allocated_storage[var.deployment_env]}"
  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"
  iops                  = "${var.iops}"
  storage_type          = "${var.storage_type}"

  tags {
    App         = "${var.app_name}"
    CostCenter  = "${var.tag_cost_center == "" ? var.app_name : var.tag_cost_center}"
    Built_by    = "Terraform"
    Environment = "${var.environment}"
    Name        = "${lower(var.app_name)}"
  }
}

resource "aws_db_subnet_group" "pg_instance_subnet_group" {
  count = "${contains(list("pgsql", "pgsql10", "pgsql12"), var.db_type) ? 1 : 0}"

  name = "${lower(var.app_name)}_subnet_group"

  subnet_ids = [
    "${split(",", var.private_subnets)}",
  ]

  tags {
    CostCenter  = "${var.tag_cost_center == "" ? var.app_name : var.tag_cost_center}"
    Name        = "${lower(var.app_name)}"
    Built_by    = "Terraform"
    Environment = "${var.environment}"
    App         = "${var.app_name}"
  }
}

resource "aws_route53_record" "pg_cname" {
  count = "${contains(list("pgsql", "pgsql10", "pgsql12"), var.db_type) ? 1 : 0}"

  zone_id = "${var.zoneid}"
  name    = "${var.pgsql_cname == "" ? "${lower(var.app_name)}-${var.db_type}.${var.subdomain}" : var.pgsql_cname }"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.pg_instance.address}"]
}
