#--------------------------------------------------------------------
# Provision Highly Available Web Cluster in any Region (Default VPC).
#   - Security Groups for Web Server and Elastic Load Balancer (ELB).
#   - Launch Configuration with Auto AMI Lookup.
#   - Auto Scaling Group using 2 Availability Zoes (AZs).
#   - Clasic Load Balancer in 2 Availability Zones.
#--------------------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "working" {}

# Fetch AMI ID
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "web" {
  name = "Web Security Group"
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Security Group"
    Owner = "Igor Yakubov"
  }
}

# Launch configuration for Auto-Scaling Group
resource "aws_launch_configuration" "web" {
  name_prefix     = "WebServer-Highly-Available-LC"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling Group
resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 3
  max_size             = 3
  min_elb_capacity     = 3
  # Load Balancer will perform the health check
  health_check_type = "ELB"
  # The Group will be deployed into 2 AZs
  vpc_zone_identifier = [aws_default_subnet.default_in_az_1.id, aws_default_subnet.default_in_az_2.id]
  # Classic Load Balancers
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "Igor Yakubov"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Classic Load Balancers
resource "aws_elb" "web" {
  name               = "WebServer-HighlyAvailable-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name  = "WebServer-HighAvailable-ELB"
    Owner = "Igor Yakubov"
  }
}

# Provides a resource to manage a default AWS VPC subnet in the current region.
# The aws_default_subnet behaves differently from normal resources,
# in that Terraform does not create this resource but instead "adopts" it into management.
# This resource cannot be destroyed by Terraform.
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet
resource "aws_default_subnet" "default_in_az_1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_in_az_2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}

output "load_balancer_url" {
  value = aws_elb.web.dns_name
}
