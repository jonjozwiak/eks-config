variable "region" {
  type        = "string"
  description = "The region in which the stack will be deployed"
  default     = "us-west-2"
}

variable "aws_profile" {
  type        = "string"
  description = "The profile to be selected from the ~/.aws/credentials file"
  default     = "default"	# Awesome
}

variable "domain" {
  description = "The domain to configure (already registered)"
  default     = "bridgecrew.info"
}

variable "subdomain" {
  description = "The subdomain to create"
  default     = "eks1.bridgecrew.info"
}

variable "environment_tag" {
  description = "Tag your resources with this"
  default     = "eks1"
}

