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
variable "tier_to_size" {
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
  
}

variable "sku_to_size_and_tier" {
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
    }
variable "sku_name" {
        type = string

    }