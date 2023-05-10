# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "environment" {
  description = "Environment."
  type        = string
}

variable "domain_name" {
  description = "Domain name for the CF Distribution"
  type        = string
}

variable "root_domain_name" {
  description = "Domain name for the Hosted Zone"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}