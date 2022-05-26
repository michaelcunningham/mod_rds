resource "aws_db_instance" "pg_instance" {
  count = "${contains(tolist(["pgsql12"]), var.db_type) ? 1 : 0}"

  identifier             = "tf-michael"
  engine                 = "postgres"
  engine_version         = "14.2"
  instance_class         = "db.t3.micro"
  port                   = "5432"
  username               = "postgres"
  password               = "changeMe"
  db_subnet_group_name   = "${aws_db_subnet_group.tf_subnet_group.name}"
  # parameter_group_name   = "${aws_db_parameter_group.db_parameter_group.name}"
  # vpc_security_group_ids = ["${split(",", var.vpc_security_group_ids)}"]
  storage_type           = "gp2"
  # deletion_protection    = "${var.deletion_protection}"

  # auto_minor_version_upgrade = "${var.auto_minor_version_upgrade_override == "" ? var.auto_minor_version_upgrade[var.deployment_env] : var.auto_minor_version_upgrade_override}"
  # monitoring_interval        = "${var.monitoring_interval_override == "" ? var.monitoring_interval[var.deployment_env] : var.monitoring_interval_override}"
  # monitoring_role_arn        = "${var.monitoring_role_arn[var.deployment_env]}"
  performance_insights_enabled = "${var.performance_insights_enabled == "" ? var.performance_insights_enabled : false}"

  # multi_az              = "${var.multi_az[var.deployment_env]}"
  allocated_storage     = "20"
  # copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"
  # iops                  = "${var.iops}"
  # storage_type          = "${var.storage_type}"

#  tags {
#    App         = "${var.app_name}"
#    CostCenter  = "${var.tag_cost_center == "" ? var.app_name : var.tag_cost_center}"
#    Built_by    = "Terraform"
#    Environment = "${var.environment}"
#    Name        = "${lower(var.app_name)}"
#  }
}


