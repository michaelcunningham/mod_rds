resource "aws_db_instance" "pg_instance" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  identifier             = "tf-rds-pg14"
  engine                 = "postgres"
  engine_version         = "14.2"
  instance_class         = "db.t3.micro"
  port                   = "5432"
  username               = "postgres"
  password               = "changeMe"
  db_subnet_group_name   = "${aws_db_subnet_group.tf_rds_subnet_group.name}"
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


resource "aws_vpc" "tf_rds_vpc" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  cidr_block = "172.40.0.0/16"

  tags = {
    Name = "tf-rds-vpc"
  }
}

resource "aws_subnet" "tf_rds_subnet_1" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  vpc_id            = aws_vpc.tf_rds_vpc[count.index].id
  cidr_block        = "172.40.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-rds-subnet-1"
  }
}

resource "aws_subnet" "tf_rds_subnet_2" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  vpc_id            = aws_vpc.tf_rds_vpc[count.index].id
  cidr_block        = "172.40.11.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "tf-rds-subnet-2"
  }
}

resource "aws_db_subnet_group" "tf_rds_subnet_group" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  name        = "tf-subnet-group"
  subnet_ids  = ["${aws_subnet.tf_rds_subnet_1[count.index].id}","${aws_subnet.tf_rds_subnet_2[count.index].id}",]
}

resource "aws_network_interface" "tf_rds_interface" {
  count = "${contains(tolist(["pgsql12", "pgsql14"]), var.mod_type) ? 1 : 0}"

  subnet_id   = aws_subnet.tf_rds_subnet_1[count.index].id
  private_ips = ["172.40.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

