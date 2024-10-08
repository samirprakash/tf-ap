provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "spixrnc-vpc" {
  default = true
}

data "aws_subnets" "spixrnc-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spixrnc-vpc.id]
  }
}

resource "aws_launch_configuration" "spixrnc-launch-configuration" {
  image_id        = "ami-04dd23e62ed049936"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.spixrnc-instance-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  # required with an autoscaling group
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "spixrnc-instance-sg" {
  name        = "spixrnc-instance-sg"
  description = "Allow inbound traffic on port 8080"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "spixrnc-autoscaling-group" {
  launch_configuration = aws_launch_configuration.spixrnc-launch-configuration.name
  vpc_zone_identifier  = data.aws_subnets.spixrnc-subnets.ids

  target_group_arns = [aws_lb_target_group.spixrnc-lb-target-group.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "spixrnc-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "spixrnc-lb" {
  name               = "spixrnc-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.spixrnc-subnets.ids
}

resource "aws_lb_listener" "spixrnc-lb-listener" {
  load_balancer_arn = aws_lb.spixrnc-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "spixrnc-lb-sg" {
  name        = "spixrnc-lb-sg"
  description = "Allow inbound traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "spixrnc-lb-target-group" {
  name     = "spixrnc-lb-target-group"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.spixrnc-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 15
  }
}
