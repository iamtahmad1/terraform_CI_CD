terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 4.18.0"

    }

  }



  backend "s3" {

    bucket         	   = "tfbucket0963"

    key              	   = "state/terraform.tfstate"

    region         	   = "ap-south-1"


  }

}