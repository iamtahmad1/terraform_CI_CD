terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 4.18.0"

    }

  }



  backend "remote" {
    hostname = "youritsolutions123.scalr.io"
    organization = "env-v0o3ctmoufoqapn9h"
    workspaces {
      name = "migration-test"
    }
  }

}