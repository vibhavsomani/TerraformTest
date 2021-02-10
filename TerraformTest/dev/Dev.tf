module "my_ec2" {
    source = "../modules/ec2"
    instance_type = "t2.nano"
    ec2_name = "my_dev_EC2"
	key_name = ""
	associate_public_ip_address = ""
	environment = "Dev"
	region = "us-east-1"
	Creation-Time = ""
}

module "resources" {
    source = "../modules"
}