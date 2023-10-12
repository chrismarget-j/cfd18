data "aws_ami" "haproxy" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Apollo Supported HAProxy ubuntu18arm*"]
  }

  owners = ["679593333241"]
}

resource "aws_security_group" "haproxy" {
  name        = "haproxy"
  description = "haproxy"
  vpc_id      = aws_vpc.o.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "tls_private_key" "o" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "o" {
  key_name   = "haproxy"
  public_key = tls_private_key.o.public_key_openssh

  provisioner "local-exec" {
    command = "touch haproxy_key && chmod 600 haproxy_key && echo '${tls_private_key.o.private_key_openssh}' > haproxy_key"
  }
}

locals {
  haproxy_cfg_frontend = "frontend app\n  bind *:80\n  default_backend app\n\n"
  haproxy_cfg_backend  = "backend app\n  balance roundrobin\n"
  haproxy_cfg_server   = "  server app-%s %s:80\n"
  haproxy_cfg = join("", [
    "\n",
    local.haproxy_cfg_frontend,
    local.haproxy_cfg_backend,
    join("", [for i in data.terraform_remote_state.deploy_app.outputs["ip_addresses"] : format(local.haproxy_cfg_server, i, i)])
  ])
}

data "cloudinit_config" "haproxy" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "id.sh"
    content_type = "text/x-shellscript"
    content      = "#!/bin/sh\n/usr/bin/id > /tmp/id.out\n"
  }

  part {
    filename     = "haproxy-cfg.sh"
    content_type = "text/x-shellscript"
    content      = "#!/bin/sh\ncat >> /etc/haproxy/haproxy.cfg << EOF\n${local.haproxy_cfg}EOF\nsystemctl restart haproxy\n"
  }
}

resource "aws_eip" "o" {
  domain   = "vpc"
  instance = aws_instance.lb.id
}

resource "aws_instance" "lb" {
  ami                         = data.aws_ami.haproxy.id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.haproxy.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.o.id
  key_name                    = aws_key_pair.o.key_name
  user_data                   = data.cloudinit_config.haproxy.rendered
  user_data_replace_on_change = true
  lifecycle {
    create_before_destroy = true
  }
}