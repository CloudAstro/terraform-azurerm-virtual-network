## 🌐 Additional Information  

This module provides a flexible way to manage Azure subnets, supporting advanced features such as service delegation, service endpoints, and policy attachments. It is designed to be used in both standalone subnet deployments and as part of larger network architectures.

## 📚 Resources

- [Terraform AzureRM Subnet Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)  
- [Azure Subnet Delegation](https://learn.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview)  
- [Azure Service Endpoints](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview)  
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  

## ⚠️ Notes  

- Ensure subnets do not overlap with each other or other VNETs.  
- Validate that required services (e.g., Microsoft.Sql) are available in the selected Azure region before applying service endpoints or delegations.  
- NSG and Route Table associations should be managed outside this module or extended if required.  
- Delegations and policies must align with the subnet’s intended use case (e.g., Azure SQL, App Services, Container Instances, etc.).

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
