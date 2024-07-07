# Terraform Definition
terraform {
  required_version = "~>1.9.1"

  required_providers {
    azurerm = {
      version = "~>3.111.0"
    }
  }
}

# AzureRM Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      purge_soft_deleted_secrets_on_destroy = true
      purge_soft_deleted_keys_on_destroy = true
      purge_soft_deleted_certificates_on_destroy = true
      purge_soft_deleted_hardware_security_modules_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

# Resource Group
resource "azurerm_resource_group" "hub" {
  name       = "${local.prefix_dashed}hub${local.suffix_dashed}"
  location   = var.location
  managed_by = data.azurerm_client_config.current.client_id
  tags       = local.tags
}

# Key Vault
resource "azurerm_key_vault" "secrets" {
  name                            = "${local.prefix}secrets${local.suffix}"
  resource_group_name             = azurerm_resource_group.hub.name
  location                        = azurerm_resource_group.hub.location
  tenant_id                       = var.tenant_id
  sku_name                        = var.sec_size
  enabled_for_deployment          = var.sec_enabled_for_deployment
  enabled_for_disk_encryption     = var.sec_enabled_for_disk_encryption
  enabled_for_template_deployment = var.sec_enabled_for_template_deployment
  public_network_access_enabled   = var.sec_public_network_access_enabled
  purge_protection_enabled        = var.sec_purge_protection_enabled
  soft_delete_retention_days      = var.sec_sd_retention_days
  enable_rbac_authorization       = true
  network_acls {
    default_action                = "Allow"
    bypass                        = "AzureServices"
  }
  tags                            = local.tags
  depends_on = [
    azurerm_resource_group.hub,
  ]
}

resource "azurerm_role_assignment" "current_client_key_vault" {
  scope                = azurerm_key_vault.secrets.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on = [
    azurerm_key_vault.secrets,
  ]
}

# Storage Account
resource "azurerm_storage_account" "data" {
  name                        = "${local.prefix}data${local.suffix}"
  resource_group_name         = azurerm_resource_group.hub.name
  location                    = azurerm_resource_group.hub.location
  account_tier                = var.dat_size
  account_replication_type    = var.dat_replication
  account_kind                = var.dat_kind
  access_tier                 = var.dat_access
  tags                        = local.tags
  depends_on = [
    azurerm_resource_group.hub,
  ]
}

# ServiceBus Namespace
resource "azurerm_servicebus_namespace" "messages" {
  name                = "${local.prefix}messages${local.suffix}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = var.msg_size
  tags                = local.tags
  depends_on = [
    azurerm_resource_group.hub,
  ]
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                       = "${local.prefix}logs${local.suffix}"
  location                   = azurerm_resource_group.hub.location
  resource_group_name        = azurerm_resource_group.hub.name
  sku                        = var.log_size
  retention_in_days          = var.log_retention_days
  daily_quota_gb             = var.log_daily_quota
  internet_ingestion_enabled = var.log_internet_ingestion
  internet_query_enabled     = var.log_internet_query
  tags                       = local.tags
  depends_on = [
    azurerm_resource_group.hub,
  ]
}

# Container Registry
resource "azurerm_container_registry" "images" {
  name                     = "${local.prefix}images${local.suffix}"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  sku                      = var.img_size
  admin_enabled            = var.img_admin_enabled
  tags                     = local.tags
  depends_on = [
    azurerm_resource_group.hub,
  ]
}