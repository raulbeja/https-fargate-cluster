# Define Local Values in Terraform
locals {
  name = "${var.owner}-${var.env}"
  common_tags = {
    owner       = "${var.owner}"
    environment = "${var.env}"
  }
} 