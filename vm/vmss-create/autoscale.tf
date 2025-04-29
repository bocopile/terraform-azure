locals {
  scale_out_rule = {
    operator  = "GreaterThan"
    threshold = var.scale_out_threshold
    direction = "Increase"
    value     = var.scale_out_change_count
    cooldown  = var.scale_out_cooldown
  }

  scale_in_rule = {
    operator  = "LessThan"
    threshold = var.scale_in_threshold
    direction = "Decrease"
    value     = var.scale_in_change_count
    cooldown  = var.scale_in_cooldown
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "${var.resource_name}-autoscale"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  enabled             = true

  profile {
    name = "autoscale-profile"

    capacity {
      minimum = var.scale_min_capacity
      maximum = var.scale_max_capacity
      default = var.scale_default_capacity
    }

    dynamic "rule" {
      for_each = [local.scale_out_rule, local.scale_in_rule]
      content {
        metric_trigger {
          metric_name        = "Percentage CPU"
          metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
          metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
          time_grain         = "PT1M"
          time_window        = "PT2M"
          time_aggregation   = "Average"
          statistic          = "Average"
          operator           = rule.value.operator
          threshold          = rule.value.threshold
        }

        scale_action {
          direction = rule.value.direction
          type      = "ChangeCount"
          value     = rule.value.value
          cooldown  = rule.value.cooldown
        }
      }
    }
  }
}
