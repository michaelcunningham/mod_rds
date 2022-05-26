resource "aws_vpc" "tf_vpc" {
  cidr_block = "172.30.0.0/16"

  tags = {
    Name = "tf-michael-vpc"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "172.30.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-michael-subnet"
  }
}

resource "aws_network_interface" "tf_interface" {
  subnet_id   = aws_subnet.tf_subnet.id
  private_ips = ["172.30.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

