// Azure configuration
variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_certificate_path" {
  type = string
}

variable "tenant_id" {
  type = string
}


//  For HA, choose instance size that support 4 nics at least
//  Check : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes
variable "size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "fmgsize" {
  type    = string
  default = "Standard_DS3_v2"
}

variable "fazsize" {
  type    = string
  default = "Standard_DS3_v2"
}

variable "client_size" {
  type    = string
  default = "Standard_B1s"
}

// Availability zones only support in certain regions
// Check: https://docs.microsoft.com/en-us/azure/availability-zones/az-overview
variable "zone1" {
  type    = string
  default = "1"
}

variable "location" {
  type    = string
  default = "australiasoutheast"
}

variable "vnetname" {
  type    = string
  default = "azmgmt-vnet"
}

variable "rgname" {
  type    = string
  default = "azmgmt-rg"
}

variable "activename" {
  type    = string
  default = "azmgmt-fgt"
}

variable "fmgname" {
  type    = string
  default = "azmgmt-fmg"
}

variable "fazname" {
  type    = string
  default = "azmgmt-faz"
}

variable "publicsubnetname" {
  type    = string
  default = "ext-subnet"
}

variable "private1subnetname" {
  type    = string
  default = "int-subnet"
}

variable "private2subnetname" {
  type    = string
  default = "workload1-subnet"
}

variable "private3subnetname" {
  type    = string
  default = "workload2-subnet"
}

variable "hamgmtsubnetname" {
  type    = string
  default = "hamgmt-subnet"
}

variable "clusterpip1name" {
  type    = string
  default = "pip1"
}

variable "activepipname" {
  type    = string
  default = "active-mgmt-pip"
}


variable "client1name" {
  type    = string
  default = "azhublb-client1"
}



// To use custom image uncomment relevant sections in active.tf and passive.tf
// by default is false
variable "custom" {
  default = false
}

//  Custom image blob uri
variable "customuri" {
  type    = string
  default = "<custom image blob uri>"
}

variable "custom_image_name" {
  type    = string
  default = "<custom image name>"
}

variable "custom_image_resource_group_name" {
  type    = string
  default = "<custom image resource group>"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
// If BYOL the fourth static route (for vnet summary) is not automatically created due to inherent FortiOS limitation before licensing.
variable "license_type" {
  default = "payg"
}

// License Type to create FortiManager-VM
// Provide the license type for FortiManager-VM Instances, either byol or trial. If BYOL the license variables need to be set.
variable "fmg_license_type" {
  default = "trial"
}

// License Type to create FortiAnalyzer-VM
// Provide the license type for FortiAnalyzer-VM Instances, either byol or trial. If BYOL the license variables need to be set.
variable "faz_license_type" {
  default = "trial"
}

// enable accelerate network, either true or false, default is false
// Make the the instance choosed supports accelerated networking.
// Check: https://docs.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances
variable "accelerate" {
  default = "true"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

variable "fmgoffer" {
  type    = string
  default = "fortinet-fortimanager"
}

variable "fazoffer" {
  type    = string
  default = "fortinet-fortianalyzer"
}

// BYOL sku: fortinet_fg-vm
// PAYG sku: fortinet_fg-vm_payg_2022
variable "fgtsku" {
  type = map(any)
  default = {
    byol = "fortinet_fg-vm"
    payg = "fortinet_fg-vm_payg_2022"
  }
}

variable "fmgsku" {
  type    = string
  default = "fortinet-fortimanager"
}

variable "fazsku" {
  type    = string
  default = "fortinet-fortianalyzer"
}

// FOS version
variable "fgtversion" {
  type    = string
  default = "7.2.1"
}

variable "fmgversion" {
  type    = string
  default = "7.2.1"
}

variable "fazversion" {
  type    = string
  default = "7.2.1"
}

variable "adminusername" {
  type    = string
  default = "fortiuser"
}

variable "fmgfazadminusername" {
  type    = string
  default = "fortiuser"
}

variable "adminpassword" {
  type    = string
  default = "SecurityFabric1!"
}

variable "fmgfazadminpassword" {
  type    = string
  default = "SecurityFabric1!"
}

// HTTPS Port
variable "adminsport" {
  type    = string
  default = "8443"
}

variable "adminport" {
  type    = string
  default = "8080"
}

variable "fgtmgmtpip" {
  type    = string
  default = "1.1.1.1"
}

variable "fmgadminsport" {
  type    = string
  default = "4443"
}


variable "fazadminsport" {
  type    = string
  default = "4444"
}


variable "sshport" {
  type    = string
  default = "2222"
}

variable "vnetcidr" {
  default = "172.17.17.0/24"
}

variable "publiccidr" {
  default = "172.17.17.0/6"
}

variable "private1cidr" {
  default = "172.17.17.64/26"
}

variable "private2cidr" {
  default = "172.17.17.128/26"
}

variable "private3cidr" {
  default = "172.17.17.192/26"
}

variable "activeport1" {
  default = "172.30.0.4"
}

variable "activeport1mask" {
  default = "255.255.255.0"
}

variable "activeport2" {
  default = "172.17.17.68"
}

variable "activeport2mask" {
  default = "255.255.255.0"
}

variable "fmgport1" {
  default = "172.17.17.133"
}

variable "fazport1" {
  default = "172.17.17.134"
}

variable "client1port1" {
  default = "172.17.17.135"
}

variable "port1gateway" {
  default = "172.17.17.1"
}

variable "port2gateway" {
  default = "172.17.17.65"
}

variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config-active.conf"
}

variable "bootstrap-fmg" {
  // Change to your own path
  type    = string
  default = "config-fmg.conf"
}

variable "bootstrap-faz" {
  // Change to your own path
  type    = string
  default = "config-faz.conf"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "FGVM02TM22024054.lic"
}

variable "fmglicense" {
  // Change to your own byol license file, license.lic in licenses folder
  type    = string
  default = "FMG-VMTM22012011.lic"
}

variable "fazlicense" {
  // Change to your own byol license file, license.lic in licenses folder
  type    = string
  default = "FAZ-VMTM22012345.lic"
}

variable "tags" {
  type = map(any)
  default = {
    environment = "dev"
  }
}

