variable "allocated-cidr" {
  description = "Allocated cidr block for the specific vpc"
}

variable "tags" {
  description = "AWS resource tags following company recomended"
  type        = "map"
}

variable "availability-zones" {
  description = "Availability zone for the subnets"
  type        = "list"
}

variable "region" {
  description = "AWS Region for the vpc"
}
