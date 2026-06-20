variable "aws_region" {
  type        = string
  description = "The target AWS Region for all capstone resources."
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "The strict naming convention value for the Amazon EKS cluster."
  default     = "project-bedrock-cluster"
}

variable "vpc_name" {
  type        = string
  description = "The target Value string mapped to the primary VPC Name tag attribute."
  default     = "project-bedrock-vpc"
}

variable "student_id" {
  type        = string
  description = "Your unique sanitized AltSchool student registration identifier."
  default     = "alt-soe-025-3974"
}

variable "project_tag" {
  type        = string
  description = "Mandatory evaluation tagging requirement for cloud resource auditing."
  default     = "karatu-2025-capstone"
}
