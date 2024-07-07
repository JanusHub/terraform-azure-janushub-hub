# Authentication
variable "tenant_id" {
  type        = string
  description = "Azure tenant ID."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "Azure service principal ID."
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azure service principal secrect."
  sensitive   = true
}

# General
variable "organization" {
  type        = string
  description = "Organization Name."
}

variable "environment" {
  type        = string
  description = "Environment Name."
}

variable "owner" {
  type        = string
  description = "Owner E-Mail."
}

variable "location" {
  type        = string
  description = "Azure Region."
  default     = "westeurope"
}

# KeyVault
variable "sec_size" {
  type        = string
  description = "KV size ('standard', 'premium')."
  default     = "standard"
}

variable "sec_sd_retention_days" {
  type        = number
  description = "KV soft delete retention days (between 7 and 90, defaults to 90)."
  default     = 7
}

variable "sec_enabled_for_deployment" {
  type        = bool
  description = "KV provides certificated to VMs on deployment."
  default     = true
}

variable "sec_enabled_for_disk_encryption" {
  type        = bool
  description = "KV provides certificated to Azure Disk Encryption."
  default     = true
}

variable "sec_enabled_for_template_deployment" {
  type        = bool
  description = "KV provides certificated to Azure Resource Manager."
  default     = true
}

variable "sec_public_network_access_enabled" {
  type        = bool
  description = "KV accessible from internet."
  default     = true
}

variable "sec_purge_protection_enabled" {
  type        = bool
  description = "KV purge protected."
  default     = true
}

# Storage Account
variable "dat_size" {
  type        = string
  description = "Storage size ('Standard', 'Premium')."
  default     = "Standard"
}

variable "dat_replication" {
  type        = string
  description = "Storage replication ('LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS')."
  default     = "GRS"
}

variable "dat_kind" {
  type        = string
  description = "Storage kind ('BlobStorage', 'BlockBlobStorage', 'FileStorage', 'Storage', 'StorageV2')."
  default     = "StorageV2"
}

variable "dat_access" {
  type        = string
  description = "Storage access ('Hot', 'Cool')."
  default     = "Hot"
}

# ServiceBus Namespace
variable "msg_size" {
  type        = string
  description = "Messaging size ('Basic', 'Standard', 'Premium')."
  default     = "Standard"
}

# Log Analytics Workspace
variable "log_size" {
  type        = string
  description = "LAW size ('Free', 'PerNode', 'Premium', 'Standard', 'Standalone', 'Unlimited', 'CapacityReservation', 'PerGB2018')."
  default     = "PerGB2018"
}

variable "log_retention_days" {
  type        = number
  description = "LAW retention days (between 30 and 730, with free defaults to 7)."
  default     = 30
}

variable "log_daily_quota" {
  type        = number
  description = "LAW daily quota in GB (-1 = unlimited as default, with free defaults to 0.5)."
  default     = 0.1
}

variable "log_internet_ingestion" {
  type        = bool
  description = "LAW internet ingestion enabled."
  default     = true
}

variable "log_internet_query" {
  type        = bool
  description = "LAW internet query enabled."
  default     = true
}

# Container Registry
variable "img_size" {
  type        = string
  description = "Images size ('Basic', 'Standard', 'Premium')."
  default     = "Basic"
}

variable "img_admin_enabled" {
  type        = bool
  description = "Images admin access."
  default     = true
}

# Locals
locals {
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  prefix = "${var.organization}"
  suffix = "${var.environment}"
  prefix_dashed = "${var.organization}-"
  suffix_dashed = "-${var.environment}"
}