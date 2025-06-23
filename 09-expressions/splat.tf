locals {
  firstname_from_splat = var.objects_list[*].firstname
  roles_from_splat = [for username, props in local.users_map2 : props.roles]
  roles_from_splat_values = values(local.users_map2)[*].roles

}

output "firstname_from_splat" {
  value = local.firstname_from_splat
}

output "roles_from_splat" {
  value = local.roles_from_splat
}
output "roles_from_splat_values" {
  value = local.roles_from_splat_values
}