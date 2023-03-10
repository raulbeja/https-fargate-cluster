variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"  
}

variable "owner" {
  description = "Infrastructure Owner"
  type        = string
  default     = "rbg"
}

variable "env" {
  description = "Environment Variable used as prefix an tagging"
  type        = string
  default     = "mysandbox"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string 
  default     = "10.0.0.0/16"
}

variable "min_avz" {
  description = "Minimun number of availability zones"
  type        = number
  default     = 2
}

variable "ecs_cluster_name" {
  description = "Cluster Name"
  type        = string 
  default     = "MyCluster"
}

variable "ecs_domain_name" {
  description = "Cluster Domain Name"
  type        = string 
  default     = "rbgdevdom.es"
}

variable "inet_cidr_block" {
  description = "Internet CIDR Block"
  type        = string 
  default     = "0.0.0.0/0"
}

variable "ecs_service_name" {
  description = "Application service name"
  type        = string 
  default     = "fargate-nginx"
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  type        = string
  default     = "512"
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  type        = string
  default     = "256"
}

variable "desired_task_number" {
  description = "Number of tasks"
  type        = number
  default     = 2
}

variable "docker_container_port" {
  description = "Application container exposed port"
  type        = number
  default     = 80
}

variable "docker_image" {
  description = "Docker Image URL"
  type        = string
  default = "nginx:latest"
}
