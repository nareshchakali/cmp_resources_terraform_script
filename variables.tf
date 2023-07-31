variable "org" {
    description = "Define organisation name"
    type = string
}

variable "env" {
    type = string
    description = "defining environment"
  
}

variable "app" {
    type = string
    description = "By providing application name"
  
}

variable "rglocation" {
    type = string
    description = "Defining the resources location of the resources"
  
}

variable "tier" {
    type = list(string)
    description = "Providing different sku names for the selecting sku name"
    default = ["B1", "F1", "S1", "Shared"]
}

variable "size" {
    type = list(string)
    description = "Providing different tier for the plan while with out selecting any plan go with free tier"
    default = ["First"]
}

variable "client_id" {
    type = string
    description = "By Passing client id for that app registartion"
  
}


variable "tenant_id" {
    type = string
    description = "defining tenet_id value"
  
}
variable "object_id" {
    type = string
    description = "defining object id"
  
}
variable "administrator_login" {
    type = string
    description = "mentioned value"
  
}
variable "administrator_login_password" {
    type = string
    description = "definig administrator password"
  
}
/*variable "tier_to_size" {
    type = map(string)
    default = {
      
      "B1"     = "Basic"
      "B2"     = "Basic"
      "B3"     = "Basic"
      "F1"     = "Free"
      "Free"   = "Free"
      "P2v2"   = "PremiumV2"
      "P1v2"   = "PremiumV2"
      "S1"     = "Standard"
      "S2"     = "Standard"
      "S3"     = "Standard"
      "SHARED" = "Shared"
    }
  
}*/

/*variable "sku_to_size_and_tier" {
    type = map(object({
        size = string
        tier = string
    }))
    default = {
      "B1"      = { size = "B1",      tier = "Basic" }
      "B2"      = { size = "B2",      tier = "Basic" }
      "B2"      = { size = "B2",      tier = "Basic" }
      "B3"      = { size = "B3",      tier = "Basic" }
      "F1"      = { size = "F1",      tier = "Free" }
      "Free"    = { size = "F1",      tier = "Free" }  # In case "Free" is used as SKU name
      "P1v2"    = { size = "P1v2",    tier = "PremiumV2" }
      "P2v2"    = { size = "P2v2",    tier = "PremiumV2" }
      "P1v3"    = { size = "PC2",     tier = "PremiumV3" }
      "P2v3"    = { size = "PC3",     tier = "PremiumV3" }
      "P3v3"    = { size = "PC4",     tier = "PremiumV3" }
      "S1"      = { size = "S1",      tier = "Standard" }
      "S2"      = { size = "S2",      tier = "Standard" }
      "S3"      = { size = "S3",      tier = "Standard" }
        
      }
    }*/

variable "os_type" {
    description = "The O/S type for App Services to be hosted in this plan. Possible values include 'Windows', 'Linux', and 'WindowsContainer'."
    type = string

    validation {
      condition = try(contains(["Windows", "Linux", "WindowsContainer"], var.os_type), true)
      error_message = "The 'os_type' value must be valid. Possible values are 'Windows', 'Linux', and 'WindowsContainer'."
    }
  
}

variable "sku_name" {
    description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, Free, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P1v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
    type = string
    validation {
      condition = try(contains(["B1", "B2", "B3", "D1", "F1", "Free", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "P1v2", "P1v2", "P3v2", "P1v3", "P2v3", "P3v3", "S1", "S2", "S3", "SHARED", "Y1", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3"], var.sku_name), true)
      error_message = "The 'sku_name' value must be valid. Possible values include B1, B2, B3, D1, F1, Free, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P1v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
    }
}