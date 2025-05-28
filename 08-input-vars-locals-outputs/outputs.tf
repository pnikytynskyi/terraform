output "s3_bucket_name" {
  value       = aws_s3_bucket.project_bucket.bucket
  sensitive   = true
  description = "The name of the S3 bucket"
}

# output "sensitive_var" {
#   value     = var.my_sensitivity_info
#   sensitive = true
# }