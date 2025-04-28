# Azure Subnet Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/subnet/azurerm/)


This module is designed to manage individual subnets within an Azure Virtual Network (VNet). Each subnet can be customized with various configurations including address prefixes, service endpoints, and network policies. It also supports dynamic delegation settings for specific use cases.

# Features

- Subnet Management: Facilitates the creation and management of individual subnets within a VNet.
- Configurable Address Prefixes: Allows specification of address prefixes for each subnet.
- Service Endpoints: Supports configuration of service endpoints for enhanced connectivity.
- Network Policies: Enables or disables network policies such as private link service and private endpoint policies.
- Dynamic Delegation: Supports dynamic delegation configurations for specific services within subnets.

  # Example Usage

  This example demonstrates how to provision subnets within a virtual network, each with its specific configurations and optional delegations.
