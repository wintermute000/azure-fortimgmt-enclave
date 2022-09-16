resource "azurerm_virtual_machine" "fmgvm" {
  name                             = var.fmgname
  location                         = var.location
  resource_group_name              = azurerm_resource_group.myterraformgroup.name
  network_interface_ids            = [azurerm_network_interface.fmgport1.id,]
  vm_size                          = var.size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  plan {
    name = var.fmgoffer
    publisher = "fortinet"
    product       = var.fmgsku
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = var.fmgoffer
    sku       = var.fmgsku
    version   = var.fmgversion
  }

  storage_os_disk {
    name              = "fmgosDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Premium_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fmgdatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }

  os_profile {
    computer_name  = var.fmgname
    admin_username = var.fmgfazadminusername
    admin_password = var.fmgfazadminpassword
    custom_data = templatefile("${var.bootstrap-fmg}", {
      gwy     = var.port1gateway
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "fmgvm_shutdown_schedule" {
  virtual_machine_id = azurerm_virtual_machine.fmgvm.id
  location           = azurerm_resource_group.myterraformgroup.location
  enabled            = true

  daily_recurrence_time = "2359"
  timezone              = "AUS Eastern Standard Time"


  notification_settings {
    enabled = false

  }
}