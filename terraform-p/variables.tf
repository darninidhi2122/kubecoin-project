variable "region" {
  default = "us-east-1"
}

variable "control_plane_instance_type" {
  default = "c7i-flex.large"
}

variable "worker_instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "EC2 key pair name"
}

variable "ami" {
  description = "Ubuntu AMI ID"
}
