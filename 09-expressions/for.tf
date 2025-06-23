locals {
  double_numbers = [for n in var.numbers_list : (n * 2)]
  even_numbers   = [for n in var.numbers_list : n if n %  2 == 0]

  first_names = [for name in var.objects_list : name.firstname]
  last_names  = [for name in var.objects_list : name.lastname]
  full_names  = [for name in var.objects_list : "${name.firstname} ${name.lastname}"]
}

output "doubles" {
  value = local.double_numbers
}

output "evens" {
  value = local.even_numbers
}

output "first_names" {
  value = local.first_names
}

output "last_names" {
  value = local.last_names
}

output "full_names" {
  value = local.full_names
}