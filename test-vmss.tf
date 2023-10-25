terraform {

  cloud {
    organization = "example-sentinel"

    workspaces {
      name = "learn-terraform-sentinel"
    }
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.54.0"
    }
  }
}

  provider "azurerm" {
  features {}
}
resource "azurerm_virtual_machine_scale_set_extension" "tlz_extension_linux" {
 
    name                         = "updatinghostname"
    publisher                    = "Microsoft.Compute"
    virtual_machine_scale_set_id = "/subscriptions/fa9f8b42-7e2f-4382-a1a6-4a37841ff40d/resourceGroups/test/providers/Microsoft.Compute/virtualMachineScaleSets/vmsstest"
    type                         = "CustomScriptExtension"
    type_handler_version         =  "1.10"
    protected_settings  =  jsonencode({ 
    
    #fileUris = ["https://github.com/pallavis3/sentinel/blob/792db2a1aa2839017f8e498606a559c87bad9b34/powershell-win2019.zip"],
   # commandToExecute = "powershell -NoProfile -windowstyle hidden -ExecutionPolicy Unrestricted -Command \"Invoke-WebRequest -Uri \"www.google.com\" -UseBasicParsing | Out-File -FilePath C:\\ansible.txt;.\\win-host.ps1 Pallavi ${data.azurerm_subscription.current.subscription_id} CentralUS VMSS  1 FScode vmsshost typevmss dev prod ${var.fapp_key}\"",
   commandToExecute = "powershell -NoProfile -windowstyle hidden -ExecutionPolicy Unrestricted -Command \"Expand-Archive -Path https://github.com/pallavis3/sentinel/blob/64f6a7450594018fd26a16f9b090e28f34da0e0c/powershell-win2019.zip -DestinationPath C:\reference \""
    managedIdentity = {}
    })
 #depends_on = [ azurerm_role_assignment.saroleforvmss ]
 }
