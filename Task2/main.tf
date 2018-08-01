provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}


# Public Subnets
resource "aws_subnet" "subnet-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-a}"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-b}"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-c}"
  availability_zone = "${var.region}c"
}

resource "aws_route_table" "subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "subnet-route" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.igw.id}"
  route_table_id          = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-a-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-a.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-b-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-b.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-c-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-c.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_security_group" "security-group" {
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port = "80"
      to_port   = "80"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = "443"
      to_port   = "443"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "terraform-test-launchconfig" {
  name_prefix = "terraform-test-launchconfig"
  image_id = "ami-20ce4936"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.security-group.id}"]
  associate_public_ip_address = true
  user_data = "${file("userdata.sh")}"
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "terraform-test-autoscaling-group" {
  name = "terraform-test-autoscaling-group"
  vpc_zone_identifier = ["${aws_subnet.subnet-a.id}", "${aws_subnet.subnet-b.id}", "${aws_subnet.subnet-c.id}"]
  launch_configuration = "${aws_launch_configuration.terraform-test-launchconfig.name}"
  min_size = 1
  max_size = 1
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true



  tag {
    key = "Name"
    value = "ec2 instance"
    propagate_at_launch = true
  }
}

# scale up alarm

resource "aws_autoscaling_policy" "terraform-test-scalepolicy" {
  name = "terraform-test-scalingpolicy"
  autoscaling_group_name = "${aws_autoscaling_group.terraform-test-autoscaling-group.name}"
  adjustment_type = "ExactCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "terraform-test-alarm" {
  alarm_name = "terraform-test-alarm"
  alarm_description = "terraform-test-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = 0

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.terraform-test-autoscaling-group.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.terraform-test-scalepolicy.arn}"]
}

/*
output "nginx_domain" {
  value = "${aws_instance.instance.public_dns}"
}
*/
