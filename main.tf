locals {
  user_data_tpl = "${file("${path.module}/templates/user_data")}"
}

data "template_file" "user_data" {
  # Render the template once for each instance
  template = "${local.user_data_tpl}"

  vars {
    hostname = "discourse"
  }
}

resource "aws_key_pair" "discourse" {
  key_name   = "discourse"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCflLpEFah1USN0edydDRXy5y1H3uVlVqfcRXBDSt3/Q+tO1ilR7x6qkqFUJGr2YpxG9AI45XimqI1Q1RoYHWI0cbDBOF6m9F8flrmIRZL2WkX0Ul5HBLFcbXs40eo6jXuV7Mom1cvLVvp5H/zsSutN3RwG/Q81Psv04ZX8xQHPlYnTOigzrUPsYWLciLiQ269s5dI4lDgQTwEIlou0PHgtMwBlWLGNIFpTY/mMgv7tIqNiRtXVEukYGeDp605+OX8Rf5S0JkKxdqij9HS1noYcAo/XN5jk5MCbtY5vnkc6nAm7xlwzq5RNggkgnTe/UpWM0fOsznUwi6Np8eXpWKDz owen@grimoire.ca"
}

resource "aws_instance" "discourse" {
  # The instance contains irrecoverable data (the redis and postgres data dirs,
  # plus uploads). Don't destroy it. Yes, this is a risky configuration.
  lifecycle {
    prevent_destroy = true
  }

  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.small"

  vpc_security_group_ids = ["${aws_security_group.discourse.id}"]

  key_name = "${aws_key_pair.discourse.key_name}"

  subnet_id = "${data.terraform_remote_state.network.subnet_id}"

  user_data = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size = 15
  }

  tags {
    Project = "discourse.tf"
  }
}

output "instance_ip" {
  value = "${aws_instance.discourse.public_ip}"
}
