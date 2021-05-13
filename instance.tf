provider "aws" {
	alias = "sankeerth"
	region = "us-east-1"
	profile = "sankeerth"
}

provider "aws" {
        alias = "kumar"
        region = "us-east-1"
        profile = "kumar"
}

provider "aws" {
        alias = "nobel"
        region = "us-east-1"
        profile = "nobel"
}

variable "key" {
	type = string
	default = "vm_key"
}

variable "os" {
	type = string
	default = "ami-096fda3c22c1c990a"
}

resource "aws_instance" "hdfs_slave"{
	provider = aws.nobel
	count = 3
	ami = var.os
	instance_type = "t2.micro"
	key_name = var.key
	security_groups = [ "launch-wizard-1" ]
	tags = {
		role = "hdfs_slave"
	}
}

resource "aws_instance" "mr_slave"{
        provider = aws.kumar
        count = 3
        ami = var.os
	instance_type = "t2.micro"
        key_name = var.key
        security_groups = [ "launch-wizard-1" ]
        tags = {
                role = "mr_slave"
        }
}

resource "aws_instance" "s1"{
        provider = aws.sankeerth
        ami = var.os
	instance_type = "t2.micro"
        key_name = var.key
        security_groups = [ "launch-wizard-1" ]
        tags = {
                role = "hdfs_master"
        }
}

resource "aws_instance" "s2"{
        provider = aws.sankeerth
        ami = var.os
	instance_type = "t2.micro"
        key_name = var.key
        security_groups = [ "launch-wizard-1" ]
        tags = {
                role = "mr_master"
        }
}

resource "aws_instance" "s3"{
        provider = aws.sankeerth
        ami = var.os
	instance_type = "t2.micro"
        key_name = var.key
        security_groups = [ "launch-wizard-1" ]
        tags = {
                role = "client"
        }
}


resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  hdfs_master = aws_instance.s1.public_ip,
  mr_master = aws_instance.s2.public_ip,
  client = aws_instance.s3.public_ip,
  hdfs_slave = aws_instance.hdfs_slave.*.public_ip,
  mr_slave = aws_instance.mr_slave.*.public_ip
 }
 )
 filename = "inventory"
}


#resource "null_resource" "play2"{
#  provisioner "local-exec" {
#    command = "ansible-playbook hadoop.yml"
#  }
#}

