# EC2 instance for Jenkins
resource "aws_instance" "jenkins" {
  ami           = var.jenkins_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = "jenkins"
  }

  # Provisioner for installing Docker, Jenkins, and other necessary tools
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -",
      "sudo yum install -y nodejs",
      "sudo yum install -y git",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade",
      "sudo yum install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }

  # Security group for Jenkins EC2 instance
  vpc_security_group_ids = [
    aws_security_group.jenkins.id,
  ]
}

# Security group for Jenkins EC2 instance
resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_http_cidr]
  }

  tags = {
    Name = "jenkins"
  }
}
