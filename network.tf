// Create Virtual Network

resource "azurerm_virtual_network" "fgtvnetwork" {
  name                = var.vnetname
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = local.common_tags
}

resource "azurerm_subnet" "publicsubnet" {
  name                 = var.publicsubnetname
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "private1subnet" {
  name                 = var.private1subnetname
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.private1cidr]

}

resource "azurerm_subnet" "private2subnet" {
  name                 = var.private2subnetname
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.private2cidr]
}

resource "azurerm_subnet" "private3subnet" {
  name                 = var.private3subnetname
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.private3cidr]
}


// Allocated Public IP
resource "azurerm_public_ip" "PublicIP" {
  name                = var.clusterpip1name
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = local.common_tags
}


//  Network Security Group
resource "azurerm_network_security_group" "publicnetworknsg" {
  name                = "PublicNetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  tags = local.common_tags
}

resource "azurerm_network_security_rule" "publicnetworknsgrules" {
    for_each = var.publicnsg
    name                       = each.value.name
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    source_port_range          = each.value.source_port_range
    destination_port_range     = each.value.destination_port_range
    source_address_prefix      = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
    resource_group_name = azurerm_resource_group.myterraformgroup.name    
    network_security_group_name = azurerm_network_security_group.publicnetworknsg.name
}
  
resource "azurerm_network_security_group" "privatenetworknsg" {
  name                = "PrivateNetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  tags = local.common_tags
}

resource "azurerm_network_security_rule" "privatenetworknsgrules" {
    for_each = var.privatensg
    name                       = each.value.name
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    source_port_range          = each.value.source_port_range
    destination_port_range     = each.value.destination_port_range
    source_address_prefix      = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
    resource_group_name = azurerm_resource_group.myterraformgroup.name    
    network_security_group_name = azurerm_network_security_group.privatenetworknsg.name
}


// Active FGT Network Interface port1
resource "azurerm_network_interface" "activeport1" {
  name                          = "${var.activename}-activeport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.PublicIP.id
  }

  tags = local.common_tags
}

resource "azurerm_network_interface" "activeport2" {
  name                          = "${var.activename}-activeport2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.private1subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport2
  }

  tags = local.common_tags
}

resource "azurerm_network_interface" "fmgport1" {
  name                          = "${var.fmgname}-fmgport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.private2subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fmgport1
  }

  tags = local.common_tags
}

resource "azurerm_network_interface" "fazport1" {
  name                          = "${var.fazname}-fazport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.private2subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fazport1
  }

  tags = local.common_tags
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "port1nsg" {
  depends_on                = [azurerm_network_interface.activeport1]
  network_interface_id      = azurerm_network_interface.activeport1.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  depends_on                = [azurerm_network_interface.activeport2]
  network_interface_id      = azurerm_network_interface.activeport2.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg.id
}



