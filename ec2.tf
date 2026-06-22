resource "aws_instance" "web_server_1" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              echo "<h1>Production Server Alpha</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "Prod-Web-Server-1" }
}

resource "aws_instance" "web_server_2" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              echo "<h1>Production Server Bravo</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "Prod-Web-Server-2" }
}

resource "aws_lb_target_group_attachment" "attach_1" {
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_2" {
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}
