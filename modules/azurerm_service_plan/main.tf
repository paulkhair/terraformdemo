locals {
asp_name = format("asp%s%s000", var.assetname, var.environment)
lwa_name = format("lwa%s%s", var.assetname, var.environment)
}

resource "azurerm_service_plan" "asp01" {
  name                      = "${local.asp_name}1"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_linux_web_app" "lwa01" {
  #count = var.instance_count
  name                      = "${local.lwa_name}"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  service_plan_id     = azurerm_service_plan.asp01.id
  virtual_network_subnet_id          = data.azurerm_subnet.subnet1.id
  site_config {
    app_command_line = "gunicorn --bind=0.0.0.0 --timeout 600 --chdir backend main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker"
    application_stack {
      python_version = "3.10"
    }  
    vnet_route_all_enabled = true
    ftps_state = "FtpsOnly"
    health_check_path = "/health"
  }
  
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "true"
    WEBSITE_HEALTHCHECK_MAXPINGFAILURES = "10"
    WEBSITE_HTTPLOGGING_RETENTION_DAYS  = "60"
  }

  https_only = true
  logs {
    detailed_error_messages = false
    failed_request_tracing  = false
    http_logs {
      file_system {
        retention_in_days = 60
        retention_in_mb   = 35
      }
    }
  }
/*
  auth_settings_v2 {
    auth_enabled             = true
    default_provider         = "azureactivedirectory"
    excluded_paths           = []
    forward_proxy_convention = "NoProxy"
    http_route_api_prefix    = "/.auth"
    require_authentication   = true
    require_https            = true
    runtime_version          = "~1"
    unauthenticated_action   = "RedirectToLoginPage"

    active_directory_v2 {
        allowed_applications            = []
        allowed_audiences               = []
        allowed_groups                  = []
        allowed_identities              = []
        client_id                       = "53b997c4-bd55-4bc4-bdd1-de884ef38743"
        client_secret_setting_name      = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
        jwt_allowed_client_applications = []
        jwt_allowed_groups              = []
        login_parameters                = {}
        tenant_auth_endpoint            = "https://sts.windows.net/a6c60f0f-76aa-4f80-8dba-092771d439f0/v2.0"
        www_authentication_disabled     = false
    }

    login {
        allowed_external_redirect_urls    = []
        cookie_expiration_convention      = "FixedTime"
        cookie_expiration_time            = "08:00:00"
        nonce_expiration_time             = "00:05:00"
        preserve_url_fragments_for_logins = false
        token_refresh_extension_time      = 72
        token_store_enabled               = false
        validate_nonce                    = true
    }
  }

  sticky_settings {
    app_setting_names       = [
        "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET",
    ]
  }
*/
  tags = {
    environment = var.environment
  }
}

/*
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging-slot"
  app_service_id = azurerm_linux_web_app.lwa01.id

  site_config {
    app_command_line = "gunicorn --bind=0.0.0.0 --timeout 600 --chdir backend main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker"
    application_stack {
      python_version = "3.10"
    }  
    vnet_route_all_enabled = true
    ftps_state = "FtpsOnly"
    health_check_path = "/health"
  }
}
*/

/*
resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_linux_web_app.lwa01.id
  subnet_id      = data.azurerm_subnet.subnet1.id
}
*/
#####  Reference Data already created outside terraform  ##

/*
data "azurerm_virtual_network" "vnet01" {
  name                = "vnet-8a37bca2-bfab-4c1d-b53b-96709c40c203"
  resource_group_name = "pace-default-rg"
}

data "azurerm_subnet" "subnet1" {
  name                = "Subnet1"
  virtual_network_name = data.azurerm_virtual_network.vnet01.name
  resource_group_name = "pace-default-rg"
}

data "azurerm_key_vault" "akv01" {
  name                = "akvcalstorageprod"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "calstoragedbsvrpass" {
  name                = "calstoragedbsvrpass"
  key_vault_id = data.azurerm_key_vault.akv01.id
}


data "azurerm_key_vault_secret" "calstoragejwtsecret" {
  name         = "calstoragejwtsecret"
  key_vault_id = data.azurerm_key_vault.akv01.id
}

data "azurerm_key_vault_secret" "MPASecret" {
  name         = "MPASecret"
  key_vault_id = data.azurerm_key_vault.akv01.id
}

data "azurerm_key_vault_secret" "sa-access-key" {
  name         = "sa-access-key"
  key_vault_id = data.azurerm_key_vault.akv01.id
}

*/