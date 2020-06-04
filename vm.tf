data "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  key_vault_id = azurerm_key_vault.keys.id
  depends_on   = [azurerm_key_vault_secret.admin_password]
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "myVMIP"
  location            = data.terraform_remote_state.main.outputs.location
  resource_group_name = azurerm_resource_group.project.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Testing"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${data.terraform_remote_state.main.outputs.prefix}vm-nic"
  location            = data.terraform_remote_state.main.outputs.location
  resource_group_name = azurerm_resource_group.project.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.terraform_remote_state.main.outputs.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${data.terraform_remote_state.main.outputs.prefix}vm"
  location              = data.terraform_remote_state.main.outputs.location
  resource_group_name   = azurerm_resource_group.project.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = data.azurerm_key_vault_secret.admin_password.value
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
