variable "region" {
  description = "A região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "default_tags" {
  description = "Tags padrão para os recursos."
  type        = map(string)
  default     = {
                    AccessControl   = "Dados",
                    Availability    = "Full",
                    BusinessUnit    = "Data Science",
                    Env             = "Production",
                    Product         = "DataLake",
                }
}

#------------LAMBDAS----------------
variable "app_tag" {
  description = "Tag indicando a aplicação relacionada ao projeto."
  type        = string
}

variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "runtime" {
  description = "Ambiente de execução da função Lambda"
  type        = string
}
variable "timeout" {
  description = "Tempo limite para a função Lambda em segundos"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Tamanho da memória para a função Lambda em MB"
  type        = number
  default     = 128
}

variable "lambda_policy_statements" {
  description = "List of IAM policy statements for the Lambda execution role"
  type        = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "layers" {
  description = "Lista de ARNs das layers para a função Lambda"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Variáveis de ambiente para a função Lambda"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "Lista de IDs de sub-rede para a função Lambda"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Lista de IDs de grupos de segurança para a função Lambda"
  type        = list(string)
  default     = []
}

variable "allow_secrets_manager" {
  description = "Permitir que o Secrets Manager invoque a função Lambda"
  type        = bool
  default     = false
}

variable "create_eventbridge" {
  description = "Criar regras do EventBridge para a função Lambda"
  type        = bool
  default     = false
}

variable "eventbridge_schedule" {
  description = "Expressão de agendamento para o EventBridge"
  type        = string
  default     = ""
}