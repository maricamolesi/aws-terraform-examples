terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "projects/<project_name>/terraform.tfstate"
    region         = "sa-east-1"
    encrypt        = true
  }
}