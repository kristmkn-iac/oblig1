variable "shortname" {
  type        = string
  description = "Ditt eget kortnavn. Går inn i alle ressursnavn."
}

variable "project" {
  type        = string
  description = "Prosjektnavn, del av navnegrunnlaget."
}

variable "environment" {
  type        = string
  description = "Miljønavn: dev, test eller prod."
}

variable "location" {
  type        = string
  description = "Azure-regionen ressursene opprettes i."
}

variable "vm_size" {
  type        = string
  description = "VM-SKU. Se lista over tillatte SKU-er i oppgaven."
}

variable "vm_subnet_key" {
  type        = string
  description = <<-TEKST
    Hvilket subnett maskinen skal på, som NAVN – ikke som posisjon.
    Slås opp i mapet fra nettverks-stacken: subnet_ids["app"].
  TEKST
}

variable "admin_username" {
  type        = string
  default     = "tfadmin"
  description = "Lokal administratorbruker på maskinen."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = <<-TEKST
    Settes som miljøvariabel, ikke i tfvars:
      export TF_VAR_admin_password=<et-langt-passord>
    Merk at sensitive = true bare skjuler verdien i utskrift. Den ligger i
    klartekst i state uansett – og nå ligger state i Azure. Det er derfor
    containeren er privat og rollene er satt.
  TEKST
}

# ---------------------------------------------------------------------------
#  Backend-adressen til den ANDRE stacken.
#
#  Disse er variabler og ikke hardkodet, slik at main.tf kan være identisk i
#  dev og prod. Verdiene står i terraform.tfvars, og de er de samme som i
#  shared/backend.hcl – bortsett fra nettverk_state_key, som er ulik per miljø.
# ---------------------------------------------------------------------------
variable "backend_resource_group_name" {
  type        = string
  description = "Ressursgruppa state-lagringen ligger i. Fra backend-bootstrap."
}

variable "backend_storage_account_name" {
  type        = string
  description = "Storage account-et state-filene ligger i. Fra backend-bootstrap."
}

variable "backend_container_name" {
  type        = string
  default     = "tfstate"
  description = "Containeren state-filene ligger i."
}

variable "nettverk_state_key" {
  type        = string
  description = <<-TEKST
    key-en til NETTVERKS-stackens state – f.eks. "dev/nettverk.tfstate".
    Ikke å forveksle med app-stackens egen key, som settes ved init.
  TEKST
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "Settes bare hvis du har flere subscriptions."
}