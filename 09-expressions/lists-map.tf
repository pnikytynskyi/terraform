locals {
  users_map = {
    for user in var.users  : user.username => user.role...
  }
  users_map2 = {
    for username, roles in local.users_map  : username => {roles = roles}
  }
}

output "users_to_output_roles" {
  value = local.users_map2[var.user_to_output].roles
}