This project is about configuring hadoop cluster on AWS instances. This project uses Ansible and Terraform as the main tools.

First the terraform will create the complete infrastructure and create a invetory from template file consisting the IP addresses of the instances under specific groups based on tags

Using this inventory ansible will completely configure the hadoop over the AWS instances
