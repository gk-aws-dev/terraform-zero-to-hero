provider "aws" {
    region = "us-east-1"  
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "subnet1"
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "subnet2"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      Name = "my_igw"
    }
}

resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      Name = "my_rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

resource "aws_route_table_association" "rt_1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "rt_2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my_sg" {
    name = "my_sg"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description = "HTTP from VPC"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow ssh"
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

    tags = {
      Name = "my_sg"
    }
}

resource "aws_instance" "my_instance" {
    ami = "ami-0a699202e5027c10d"
    instance_type = "t2.micro"
    key_name = "Virginia_new"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.subnet1.id

    tags = {
      Name = "my_instance"
    }
    
}

resource "aws_instance" "my_instance2" {
    ami = "ami-0a699202e5027c10d"
    instance_type = "t2.micro"
    key_name = "Virginia_new"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.subnet2.id

    tags = {
      Name = "my_instance2"
    }
}

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = true

  tags = {
    Name = "my_lb"
  }
}

resource "aws_lb_target_group" "my_TG" {
  name = "my-TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "lb_TG" {
  target_group_arn = aws_lb_target_group.my_TG.arn
  target_id        = aws_instance.my_instance.id  
  port             = 80 
}

resource "aws_lb_target_group_attachment" "lb_TG1" {
  target_group_arn = aws_lb_target_group.my_TG.arn
  target_id        = aws_instance.my_instance2.id 
  port             = 80 
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_TG.arn
    type = "forward"
  }
}
