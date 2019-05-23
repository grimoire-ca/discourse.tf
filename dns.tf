data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket = "terraform.grimoire"
    key    = "dns.tfstate"
    region = "ca-central-1"
  }
}

resource "aws_route53_record" "discourse_ip4" {
  zone_id = "${data.terraform_remote_state.dns.lithobrake_club_zone_id}"
  name    = "talk"
  type    = "A"
  ttl     = "15"
  records = ["${aws_instance.discourse.public_ip}"]
}

resource "aws_route53_record" "discourse_ip6" {
  zone_id = "${data.terraform_remote_state.dns.lithobrake_club_zone_id}"
  name    = "talk"
  type    = "AAAA"
  ttl     = "15"
  records = ["${aws_instance.discourse.ipv6_addresses}"]
}
