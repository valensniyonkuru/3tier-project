# Create Launch Template
resource "aws_launch_template" "three_tier_lt" {
  name_prefix   = "three_tier_lt"
  image_id      = data.aws_ssm_parameter.amzn2.value
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  # User data to install apache and start it
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello WE STARTED Terraform AT AMALITECH !!" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "three_tier_instance"
    }
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "three_tier_asg" {
  name                = "three_tier_asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.three_tier_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "three_tier_asg_instance"
    propagate_at_launch = true
  }
}

# Create Bastion Host
resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.amzn2.value
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "three_tier_bastion"
  }
}
