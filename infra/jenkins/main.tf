provider "aws" {
  region = var.region
}

resource "aws_security_group" "jenkins" {
  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-jenkins-sg"
  }
}

resource "aws_instance" "jenkins" {
  ami           = var.jenkins_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.jenkins.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install openjdk-11-jdk -y
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
              echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/jenkins.list
              sudo apt update
              sudo apt install jenkins -y
              sudo systemctl start jenkins
              EOF

  tags = {
    Name = "${var.name_prefix}-jenkins-instance"
  }
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}
