terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "tomcat_high_number_of_active_sessions" {
  source    = "./modules/tomcat_high_number_of_active_sessions"

  providers = {
    shoreline = shoreline
  }
}