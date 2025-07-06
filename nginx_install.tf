provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "acc_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "acc_key_pair" {
  key_name   = "acc-key"
  public_key = tls_private_key.acc_private_key.public_key_openssh
}

resource "local_file" "acc_local_file" {
  content              = tls_private_key.acc_private_key.private_key_pem
  filename             = "${path.module}/acc-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "acc-ec2" {
  ami                    = "ami-002dc986ee72c377b"
  instance_type          = "t2.micro"
  key_name               = "acc-key"
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  connection {
    type        = "ssh"
    user        = "fedora"
    private_key = tls_private_key.acc_private_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    when    = create
    inline = [
      "sudo dnf -y install nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

