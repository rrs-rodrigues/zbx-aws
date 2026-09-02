variable "project_name" {
    description = "Nome do projeto"
    type        = string
}

variable "environment" {
    description = "Ambiente do projeto (ex: dev, staging, prod)"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block para a VPC"
    type        = string
}

variable "avaliable_zones" {
    description = "Lista de zonas de disponibilidade"
    type        = list(string)
}

variable "public_subnet_cidrs" {
    description = "Lista de CIDRs para sub-redes públicas"
    type        = list(string)
}

variable "private_app_subnet_cidrs" {
    description = "Lista de CIDRs para sub-redes privadas"
    type        = list(string)
}

variable "private_db_subnet_cidrs" {
    description = "Lista de CIDRs para sub-redes privadas de banco de dados"
    type        = list(string)
}

variable "nat_gateway_count" {
    description = "Número de NAT Gateways a serem criados"
    type        = number
    default     = 1
}

variable "enable_vpc_flow_logs" {
    description = "Habilitar logs de fluxo da VPC"
    type        = bool
}

variable "flow_logs_retention_in_days" {
    description = "Número de dias para retenção dos logs de fluxo"
    type        = number
}