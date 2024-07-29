variable "name" {
  description = "The name of the Lambda function (without prefix)"
  type        = string
}

variable "prefix" {
  description = "The prefix to apply to all resources"
  type        = string
}

variable "handler_export_alias" {
  description = "The export alias of the handler function"
  type        = string
  default     = "handler"
}

variable "runtime" {
  description = "The runtime to use for the Lambda function"
  type        = string
  default     = "nodejs18.x"
}

variable "environment_variables" {
  description = "Environment variables to set on the Lambda function"
  type        = map(string)
  default     = {}
}
