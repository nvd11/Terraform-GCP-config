terraform {
  backend "gcs" {
    bucket  = "hsbc"
    prefix  = "terraform/state"
  }
}
