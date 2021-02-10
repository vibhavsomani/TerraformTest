resource "aws_instance" "my_ec2" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  tags = {
      Name = "${var.ec2_name}"
  }
  availability_zone = "${var.availability_zone}"
}