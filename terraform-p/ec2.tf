resource "aws_instance" "control_plane" {
  ami           = var.ami
  instance_type = var.control_plane_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-control-plane"
  }
}

resource "aws_instance" "worker1" {
  ami           = var.ami
  instance_type = var.worker_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-worker-1"
  }
}

resource "aws_instance" "worker2" {
  ami           = var.ami
  instance_type = var.worker_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-worker-2"
  }
}
