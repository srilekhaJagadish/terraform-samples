# Create the VPC
resource "aws_vpc" "app_vpc" {
 cidr_block = var.vpc_cidr_block
 enable_dns_hostnames = var.enable_dns_hostnames
}

# Create the internet gateway
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.app_vpc.id
}

# Create the public subnet
resource "aws_subnet" "public_subnet" {
 vpc_id = aws_vpc.app_vpc.id
 cidr_block = var.vpc_public_subnets_cidr_block
 map_public_ip_on_launch = true
 availability_zone = var.aws_azs
}

# Create the route table
resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.app_vpc.id
route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw.id
 }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public_rt_asso" {
 subnet_id = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.public_rt.id
}

# Create the security group
resource "aws_security_group" "sg" {
 name = "allow_ssh_http"
 description = "Allow ssh http inbound traffic"
 vpc_id = aws_vpc.app_vpc.id

ingress {
 description = "SSH from VPC"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }

ingress {
 description = "HTTP from VPC"
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }

egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }
}


# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]
 filter {
 name = "name"
 values = ["amzn2-ami-hvm*"]
 }
}

# Create the Linux EC2 Web server
resource "aws_instance" "web" {
 ami = data.aws_ami.amazon-linux-2.id
 instance_type = var.instance_type
 key_name = var.instance_key
 subnet_id = aws_subnet.public_subnet.id
 security_groups = [aws_security_group.sg.id]
user_data = <<-EOF
 #!/bin/bash
 yum update -y
 yum install -y httpd.x86_64
 systemctl start httpd.service
 systemctl enable httpd.service
 instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
 instanceAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
 pubHostName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
 pubIPv4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
 privHostName=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
 privIPv4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
 
 echo "<font face = "Verdana" size = "5">" > /var/www/html/index.html
 echo "<center><h1>AWS Linux VM Deployed with Terraform</h1></center>" >> /var/www/html/index.html
 echo "<center> <b>EC2 Instance Metadata</b> </center>" >> /var/www/html/index.html
 echo "<center> <b>Instance ID:</b> $instanceId </center>" >> /var/www/html/index.html
 echo "<center> <b>AWS Availablity Zone:</b> $instanceAZ </center>" >> /var/www/html/index.html
 echo "<center> <b>Public Hostname:</b> $pubHostName </center>" >> /var/www/html/index.html
 echo "<center> <b>Public IPv4:</b> $pubIPv4 </center>" >> /var/www/html/index.html
 echo "<center> <b>Private Hostname:</b> $privHostName </center>" >> /var/www/html/index.html
 echo "<center> <b>Private IPv4:</b> $privIPv4 </center>" >> /var/www/html/index.html
 echo "</font>" >> /var/www/html/index.html
EOF
}