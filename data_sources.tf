data "terraform_remote_state" "main" {
  backend = "local"

  config = {
    path = "${path.module}/../core/core.terraform.tfstate"
  }
}
