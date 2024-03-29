#Create load balancer
resource "aws_lb" "ALB" {
  name                       = var.ALB
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_traffic.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  enable_deletion_protection = false

  tags = {
    Name = "project-LB"
  }
}

#Setting up of tagert group  group
resource "aws_lb_target_group" "target_group" {
  name        = var.target_group
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = var.health_check["interval"]
    path                = var.health_check["path"]
    timeout             = var.health_check["timeout"]
    matcher             = var.health_check["matcher"]
    healthy_threshold   = var.health_check["healthy_threshold"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
  }
}

#Attached instances to the target group 
resource "aws_lb_target_group_attachment" "attach_inst1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_inst2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_inst3" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web3.id
  port             = 80
}

# Add a listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}