#vpc variable 
variable "cidr" {
  type    = string
  default = "10.20.0.0/16"
}

#vpc variables
variable "pub1_sub" {}
variable "pub2_sub" {}
variable "pub3_sub" {}
variable "priv1_sub" {}
variable "priv2_sub" {}
variable "priv3_sub" {}
#route table variable
variable "route" {
  type    = string
  default = "0.0.0.0/0"
}

#Security Groups variable
variable "web_ingress" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr        = list(string)
  }))

  default = {
    "80" = {
      description = "Allow HTTP Traffic"
      port        = 80
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "443" = {
      description = "Allow HTTPS Traffic"
      port        = 443
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "22" = {
      description = "Allow SSH Traffic"
      port        = 22
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }
  }
}

#Application Load Balancer Variable
variable "ALB" {
  type    = string
  default = "project"
}

#Target group variable
variable "health_check" {
  type = map(string)
  default = {
    "interval"            = "300"
    "path"                = "/"
    "timeout"             = "60"
    "matcher"             = "200"
    "healthy_threshold"   = "5"
    "unhealthy_threshold" = "5"
  }
}

variable "target_group" {
  type    = string
  default = "project-TG"
}

#route53 varaibls
variable "domain_name" {}
variable "sub_domain_name" {}

#instance variable
variable "key_pairs" {}
