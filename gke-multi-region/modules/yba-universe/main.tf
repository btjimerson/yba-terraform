terraform {
  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.9"
    }
  }
}

# Admin user for YBA
# Make sure YB_CUSTOMER_PASSWORD environment variable is set
resource "yba_customer_resource" "yba_admin" {
  depends_on = [yba_installer.yba]
  provider   = yba.unauthenticated
  code       = "admin"
  email      = var.yba_admin_email
  name       = var.yba_admin_name
}

//TODO: add providers
