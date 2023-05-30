resource "aws_lb" "finance_app_alb" {
  name               = "finance-app-alb"
  internal           = false
  load_balancer_type = "application"

  subnet_mapping {
    subnet_id = aws_subnet.finance_app_private_subnet_a.id
    allocation_id = aws_eip.finance_app_alb_eip_a.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.finance_app_private_subnet_b.id
    allocation_id = aws_eip.finance_app_alb_eip_b.id
  }

  tags = {
    Name = "finance-app-alb"
  }
}

resource "aws_eip" "finance_app_alb_eip_a" {
  vpc      = true
}

resource "aws_eip" "finance_app_alb_eip_b" {
  vpc      = true
}
