locals {
  name = "Pavlo N"
  age = -15
  my_object = {
    key1 = 10
    key2 = "my_value"
  }
}

output "example1" {
  value = upper(local.name)
}
output "example2" {
  value = abs(local.age)
}
output "example3" {
  value = yamldecode( file("${path.module}/users.yaml")).users[*].name
}

output "example4" {
  value = yamlencode(local.my_object)
}