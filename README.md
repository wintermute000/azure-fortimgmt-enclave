## FortiManagement Infrastructure (FortiGate / FortiManager / FortiAnalyzer) on Azure

A Terraform script to deploy FortiManager and FortiAnalyzer protected by a single FortiGate-VM on Azure  

## Introduction
FortiGate topology
* port1 - public/untrust with public IP
* port2 - private/trust

FortiManager
FortiAnalyzer
Ubuntu 20.04 LTS Jumphost

## Requirements

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.24.0
* Terraform Provider Template >= 2.2.0
* Terraform Provider Random >= 3.1.0

Developed using FOS/FMG/FAZ 7.2.1, older versions will probably work but not tested

## Deployment overview
Terraform deploys the following components:

* Azure Virtual Network with 4 subnets - external, internal, 2x workload subnets
* 1x FortiGate-VM (BYOL/PAYG) instances with two NICs.  
* Untrust interface placed in SD-WAN zone "Underlay".
* 7x firewall rules / VIPs on single public IP - permit outbound, permit internal, permit TCP 4443 --> FMG TCP 443, TCP 541 --> FMG TCP 541, permit TCP 4444 --> FAZ TCP 443, TCP 514 --> FAZ TCP 514, UDP 514 -- FAZ UDP 514
* Public IP has NSG rules only permitting 8443, 8080 and 2222 from a single public IP defined as the "publicnsg" variable. These ports are the default admin ports used by the FortiGate. Adjust "publicnsg" and "privatensg" variables as appropriate.
* Azure SDN connector using managed identity with reader.
* FortiManager VM in the first workload subnet.
* FortiAnalyzer VM in the first workload subnet.
* Ubuntu 20.04 LTS test client VM in the first workload subnet.
* UDRs for internal subnet routing table for default routing and inter-subnet routing through FortiGate.
* FortiGate - Choose payg or byol in "license_type" variable (lowercase) - if byol and using license file, place .lic files in subfolder "licenses", define filename in "fgtlicense" variable and DO NOT populate the "fgtflextoken" variable. If using flex-vm, define token in "fgtflextoken" variable and DO NOT populate the "fgtlicense" variable. DO NOT populate a flex token variable if using a license file or vice versa.
* FortiManager / FortiAnalyzer - Choose trial or byol in "fmg_license_type" and "faz_license_type" variables (lowercase) - if byol, place .lic files in subfolder "licenses" and define in variables.
* Use lowercase for payg, byol, trial variables.
* Terraform backend (versions.tf) stored in Azure storage - customise backend.conf to suit when initialising, or modify as appropriate. An backend.conf.example is provided or comment out the backend "azurerm" resource block.

Topology using default variables

![img](https://github.com/wintermute000/azure-fortimgmt-enclave/blob/main/azure-fortimgmt-enclave.jpg)

**If BYOL FortiGate is used, then some policies cannot be created in FortiOS due to the limitation of unlicensed VM only allowing 3 policies. Add the remaining policies/VIPs after creation. Default routing and port 443 access to FMG/FAZ has been deliberately placed first.**

## Deployment

To deploy the FortiGate-VM to Azure:
1. Clone the repository.
2. Customize variables defined in `variables.tf` file as needed with a standard *.auto.tfvars file. An example is provided.
3. Initialize the providers defining the backend (terraform init -backend-config=backend.conf) and run terraform as normal.

Outputs:

- PublicIP = <Cluster Public IP>
- FortiGate Username = <FGT admin>
- FortiGate Password = <FGT Password>
- FMG/FAZ Username = <FMG/FAZ admin>
- FMG/FAZ Password = <FMG/FAZ Password>
- ResourceGroup = <Resource Group>
- VNET_CIDR = <vnet summary route>

Azure credentials:

The following code is commented out in provider.tf that can be uncommented to run via a service principal

- subscription_id = var.subscription_id
- client_id       = var.client_id
- client_certificate_path   = var.client_certificate_path
- tenant_id       = var.tenant_id

The client_id and client_certificate_path variables are only required for this purpose.

## Acknowledgements
This template was developed from the starting point of https://github.com/fortinet/fortigate-terraform-deploy/tree/main/azure/7.2/ha-port1-mgmt-crosszone-3ports and then enhanced with managed identity SDN connector etc.
References to custom images are commented out. 

## Support
Fortinet-provided scripts in this and other GitHub projects do not fall under the regular Fortinet technical support scope and are not supported by FortiCare Support Services.
For direct issues, please refer to the [Issues](https://github.com/fortinet/fortigate-terraform-deploy/issues) tab of this GitHub project.
For other questions related to this project, contact [github@fortinet.com](mailto:github@fortinet.com).

## License
[License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) ?? Fortinet Technologies. All rights reserved.
# 
