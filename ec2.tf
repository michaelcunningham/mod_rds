resource "aws_instance" "ec2_instance" {
  count = "${contains(tolist("ec2", "ec2x"), var.aws_type) ? 1 : 0}"

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

