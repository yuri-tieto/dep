terraform {
  backend "local" {
    path = "dep.terraform.tfstate"
  }
}