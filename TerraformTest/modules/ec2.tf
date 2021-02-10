resource "aws_instance" "my_prod_ec2" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
 tags = {
	resource-name = "Prod ec2"
	environment = "Prod"
	region = var.region
	Creation-Time = var.Creation-Time
  }
  availability_zone = "${var.availability_zone}"
}

resource "aws_eip" "eip" {
  vpc = true
  instance = "aws_instance.my_prod_ec2.id"
}