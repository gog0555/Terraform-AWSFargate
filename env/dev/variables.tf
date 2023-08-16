variable "env" {
  type    = string
  default = "env"
}

variable "name" {
  description = "Value of the Name tag for Resources"
  type        = string
  default     = "name"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  type = map(any)
  default = {
    public_subnets = {
      public-1a = {
        name = "public-1a"
        cidr = "10.0.1.0/24"
        az   = "ap-northeast-1a"
      },
      public-1c = {
        name = "public-1c"
        cidr = "10.0.2.0/24"
        az   = "ap-northeast-1c"
      },
      public-1d = {
        name = "public-1d"
        cidr = "10.0.3.0/24"
        az   = "ap-northeast-1d"
      }
    }
  }
}

variable "capacity_provider" {
  type    = string
  default = "FARGATE"
}

variable "ecs_task" {
  type = object({
    network_mode = string
    cpu          = number
    memory       = number
  })
  default = {
    network_mode = "awsvpc"
    cpu          = 256
    memory       = 512
  }
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "fargate_weight" {
  type    = number
  default = 1
}