resource "aws_instance" "ec2_instance" {
  count = "${contains(tolist(["ec2"]), var.aws_type) ? 1 : 0}"

  ami                     = var.amis[var.region]
  instance_type           = "t3.micro"
  disable_api_termination = false

  network_interface {
    network_interface_id = aws_network_interface.tf_interface.id
    device_index         = 0
  }

  tags = {
    Name = "tf-michael-learning-ec2"
  }
}

