provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "dev.nathanpowell.org"
    persistance = "destroy"
  }
}

resource "aws_subnet" "devprivate" {
  vpc_id     = "${aws_vpc.dev.id}"
  cidr_block =  "10.0.122.0/24"
  tags {
    Name = "devprivate"
    persistance = "destroy"
  }
}

resource "aws_subnet" "devpublic" {
  vpc_id     = "${aws_vpc.dev.id}"
  cidr_block =  "10.0.124.0/24"
  tags {
    Name = "devpublic"
    persistance = "destroy"
  }
}

resource "aws_security_group" "devsg" {
  vpc_id = "${aws_vpc.dev.id}"
  name   = "basic"
  tags {
    persistance = "destroy"
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_internet_gateway" "devgw" {
  vpc_id = "${aws_vpc.dev.id}"
}
