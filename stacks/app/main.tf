# =============================================================================
#  environments/<miljø>/app/main.tf  –  CONSUMER STACK
# -----------------------------------------------------------------------------
#  Denne stacken trenger et subnett den ikke eier. Den henter det fra
#  nettverks-stackens outputs i stedet for å få en ID limt inn.
#
#  Fila er IDENTISK i dev og prod. Selv key-en til nettverks-stacken er en
#  variabel, nettopp for at kravet skal holde.
# =============================================================================

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# ---------------------------------------------------------------------------
#  K8 – stack data lookup.
#
#  config-blokka er den samme backend-konfigurasjonen du kjenner fra
#  shared/backend.hcl, med én forskjell som er hele poenget: key peker på
#  NETTVERKS-STACKENS state, ikke på app-stackens egen.
#
#  Merk hva dette forutsetter: vi får ikke tilgang til bare den ene outputen.
#  terraform_remote_state leser HELE state-fila til nettverks-stacken – med alt
#  den vet, i klartekst. Det er greit her, fordi begge stackene er våre. Det
#  ville sjelden vært greit på tvers av to team.
#
#  Verdiene gjentas her fordi backend-konfigurasjonen til en data source ikke
#  kan leses fra -backend-config-fila. Det er en reell ulempe ved mønsteret.
# ---------------------------------------------------------------------------
data "terraform_remote_state" "nettverk" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.nettverk_state_key
    use_azuread_auth     = true
  }
}

locals {
  base_name = lower(format("%s-%s-%s", var.project, var.environment, var.shortname))

  tags = {
    environment = var.environment
    owner       = var.shortname
    project     = var.project
    stack       = "app"
    managedby   = "terraform"
  }

  # Her krysser verdien grensa. ÉN verdi – det er hele avhengigheten mellom de
  # to stackene, og det er med vilje: jo færre verdier, jo løsere kobling.
  subnet_id = data.terraform_remote_state.nettverk.outputs.subnet_ids[var.vm_subnet_key]
}

# App-stacken eier sin egen ressursgruppe. Den KUNNE lest nettverks-stackens
# rg_name i stedet, men da hadde to verdier krysset i stedet for én – og
# app-stacken kunne ikke lenger rives uten å tenke på hvem som eier gruppa.
resource "azurerm_resource_group" "rg" {
  name     = format("rg-app-%s", local.base_name)
  location = var.location
  tags     = local.tags
}

# Modulen er UENDRET fra Oppgave 3.
module "compute" {
  source = "../../modules/compute"

  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  base_name      = local.base_name
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  tags           = local.tags


  subnet_id = local.subnet_id
}