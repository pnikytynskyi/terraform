variable "numbers_list" {
  type = list(number)
}

variable "objects_list" {
  type = list(object({
    firstname = string
    lastname  = string
  }))
}

variable "user_to_output" {
  type = string
}

variable "users" {
  type = list(object({
    username = string
    role = string
  }))
}