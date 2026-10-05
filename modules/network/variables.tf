#modules/network/variables.tf
 
variable "rg_name" {
  type        = string
  description = "Navnet på ressursgruppa nettverket skal ligge i."
}
 
variable "location" {
  type        = string
  description = "Azure-regionen ressursene opprettes i."
}
 
variable "base_name" {
  type        = string
  description = <<-TEKST
    Navnegrunnlaget miljøet leverer, f.eks. "oblig1-dev-kristmkn".
    Modulen setter selv på prefiksene "vnet-", "snet-" og "nsg-".
  TEKST
}
 
variable "address_space" {
  type        = string
  description = "Adresserommet vnet-et disponerer, som CIDR – f.eks. 10.10.0.0/16."

  validation {
    condition     = can(cidrhost(var.address_space, 0))
    error_message = "address_space må være en gyldig CIDR-blokk, f.eks. 10.10.0.0/16."
  }
}
 
variable "subnets" {
  type        = map(number)
  description = <<-TEKST
    Subnettene som skal opprettes: navn => netnum innenfor adresserommet.
    Nøkkelen er subnettets identitet og skal ligge i ro; netnum bestemmer
    hvilken del av adresserommet det får.
  TEKST
}
 
variable "subnet_newbits" {
  type        = number
  default     = 8
  description = <<-TEKST
    Hvor mange bit subnettene forlenger adresserommet med.
    8 gir /24 ut av et /16, altså 256 mulige subnett.
  TEKST
}
 
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Felles tags fra miljøet. Tags arves ikke fra ressursgruppa i Azure."
}