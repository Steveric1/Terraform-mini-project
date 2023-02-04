#Create instance 
data "aws_availability_zones" "available" {}
resource "aws_instance" "web1" {
  ami                         = "ami-0aa7d40eeae50c9a9"
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.available.names[0]
  key_name                    = "server"
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_traffic.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web1.public_ip} >> host-inventory"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.web1.public_ip
    private_key = file(var.key_pairs)
  }

  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${var.key_pairs} apache1.yml"
  }

  tags = {
    Name = "project-server1"
  }
}


resource "aws_instance" "web2" {
  ami                         = "ami-0aa7d40eeae50c9a9"
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.available.names[1]
  key_name                    = "server"
  subnet_id                   = aws_subnet.public2.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_traffic.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web2.public_ip} >> host-inventory"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.web2.public_ip
    private_key = file(var.key_pairs)
  }

  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${var.key_pairs} apache1.yml"
  }

  tags = {
    Name = "project-server2"
  }
}


resource "aws_instance" "web3" {
  ami                         = "ami-0aa7d40eeae50c9a9"
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.available.names[2]
  key_name                    = "server"
  subnet_id                   = aws_subnet.public3.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_traffic.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web3.public_ip} >> host-inventory"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.web3.public_ip
    private_key = file(var.key_pairs)
  }

  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${var.key_pairs} apache1.yml"
  }

  tags = {
    Name = "project-server3"
  }
}
