#This instance resource will launch the required instances with hdfs_slave tags
resource "aws_instance" "hdfs_slave"{
	provider = aws.nobel
	count = 1
	ami = var.os
	instance_type = var.instance_type
	key_name = var.key
	security_groups = [ "launch-wizard-1" ]
	tags = {
		Name = "HDFS_SLAVE"
		role = "hdfs_slave"
	}
}

#This instance resource wil launch the required instances with mr_slave tags
resource "aws_instance" "mr_slave"{
        provider = aws.kumar
        count = 1
        ami = var.os
		instance_type = var.instance_type
        key_name = var.key
        security_groups = [ var.security_group ]
        tags = {
			Name = "MR_SLAVE"
        	role = "mr_slave"
        }
}

#This will launch the instance for hdfs_master
resource "aws_instance" "s1"{
        provider = aws.sankeerth
        ami = var.os
		instance_type = var.instance_type
        key_name = var.key
        security_groups = [ var.security_group ]
        tags = {
			Name = "HDFS_MASTER"
        	role = "hdfs_master"
        }
}

#This will launch the instance for mr_master
resource "aws_instance" "s2"{
        provider = aws.sankeerth
        ami = var.os
		instance_type = var.instance_type
        key_name = var.key
        security_groups = [ var.security_group ]
        tags = {
			Name = "MR_MASTER"
    	    role = "mr_master"
        }
}

#This will launch instance for hadoop client
resource "aws_instance" "s3"{
        provider = aws.sankeerth
        ami = var.os
		instance_type = var.instance_type
        key_name = var.key
        security_groups = [ var.security_group ]
        tags = {
			Name = "Client"
            role = "client"
        }
}

#This will generate a dynamic inventory after the instance is launched in AWS, this inventory will be used by the ansible for hadoop configuration
resource "local_file" "AnsibleInventory" {
	content = templatefile("inventory.tmpl",{
		hdfs_master = aws_instance.s1.public_ip,
		mr_master = aws_instance.s2.public_ip,
		client = aws_instance.s3.public_ip,
		hdfs_slave = aws_instance.hdfs_slave.*.public_ip,
		mr_slave = aws_instance.mr_slave.*.public_ip
	})
	filename = "inventory"
}


#This is null resource which will perform a local execution to run the ansible playbook
resource "null_resource" "play"{
	depends_on = ["local_file.AnsibleInventory"]
	provisioner "local-exec" {
		command = "ansible-playbook hadoop.yml"
	}
}
