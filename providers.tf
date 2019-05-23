terraform {
  backend "s3" {
    bucket = "terraform.grimoire"
    key    = "discourse.tfstate"
    region = "ca-central-1"
  }
}

provider "aws" {
  version = "~> 1.11"

  region = "ca-central-1"
}

# Life is easier if s3 buckets "live" in us-east-1. Discourse, in particular,
# makes this assumption.
provider "aws" {
  version = "~> 1.11"

  alias  = "s3"
  region = "us-east-1"
}

provider "template" {
  version = "~> 1.0"
}

provider "external" {
  version = "~> 1.0"
}
