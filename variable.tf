#This variable is the ssh key pair name
variable "key" {
	type = string
	default = "vm_key"
}

#This variable is the AWS ami
variable "os" {
	type = string
	default = "ami-096fda3c22c1c990a"
}


variable "instance_type" {
    type = string
    default = t2.micro
}


variable "security_group" {
    type = string
    default = "launch-wizard-1"
}