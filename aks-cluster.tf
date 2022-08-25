provider "azurerm" {
  features {}
}

provider "azapi" {
}

resource "azurerm_resource_group" "acr" {
  name     = "${var.prefix}-acr-rg"
  location = var.location

  tags = {
    environment = "Dev"
    customer = "Liatrio"
    application = "API"
  }
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.prefix}-aks-rg"
  location = var.location

  tags = {
    environment = "Dev"
    customer = "Liatrio"
    application = "API"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr"
  resource_group_name = azurerm_resource_group.acr.name
  location            = azurerm_resource_group.acr.location
  sku                 = "Basic"

  tags = {
    environment = "Dev"
    customer = "Liatrio"
    application = "API"
  }
}

resource "azurerm_container_registry_task" "acr" {
  name                  = "${var.prefix}-sampleflaskapi"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = var.containerSource
    context_access_token = var.sourcePAT
    image_names          = ["sampleflaskapi:v1"]
  }
}

resource "azapi_resource" "run_acr_task" {
  name = azurerm_container_registry.acr.name 
  location = azurerm_resource_group.acr.location
  parent_id = azurerm_container_registry.acr.id
  type = "Microsoft.ContainerRegistry/registries/taskRuns@2019-06-01-preview"
  body = jsonencode({
    properties = {
       runRequest = {
         type = "DockerBuildRequest"
         sourceLocation = "${var.containerSource}"
         dockerFilePath = "Dockerfile"
         platform = {
           os = "Linux"
          }
         imageNames = ["sampleflaskapi:v1"]
       }
    }
  })
  ignore_missing_property = true

  depends_on = [
    azurerm_container_registry_task.acr
  ]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_DS2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Dev"
    customer = "Liatrio"
    application = "API"
  }
}

resource "azurerm_role_assignment" "aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# resource "null_resource" "deploy" {
#   provisioner "local-exec" {
#     command = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
#   }
#   provisioner "local-exec" {
#     command = "kubectl apply -f deploy.yaml"
#   }

#   depends_on = [
#     azurerm_role_assignment.aks,
#     azapi_resource.run_acr_task
#   ]
# }