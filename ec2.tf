resource "aws_instance" "ec2_instance" {
  count = "${contains(tolist(["ec2"]), var.mod_type) ? 1 : 0}"

  ami                     = var.amis[var.region]
  instance_type           = "t3.micro"
  disable_api_termination = false

  network_interface {
    network_interface_id = aws_network_interface.tf_ec2_interface[count.index].id
    device_index         = 0
  }

  tags = {
    Name = "tf-michael-learning-ec2"
  }
}

resource "aws_vpc" "tf_ec2_vpc" {
  count = "${contains(tolist(["ec2"]), var.mod_type) ? 1 : 0}"

  cidr_block = "172.30.0.0/16"

  tags = {
    Name = "tf-ec2-vpc"
  }
}

resource "aws_subnet" "tf_ec2_subnet" {
  count = "${contains(tolist(["ec2"]), var.mod_type) ? 1 : 0}"

  vpc_id            = aws_vpc.tf_ec2_vpc[count.index].id
  cidr_block        = "172.30.10.0/24"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    Name = "tf-ec2-subnet"
  }
}

resource "aws_network_interface" "tf_ec2_interface" {
  count = "${contains(tolist(["ec2"]), var.mod_type) ? 1 : 0}"

  subnet_id   = aws_subnet.tf_ec2_subnet[count.index].id
  private_ips = ["172.30.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

