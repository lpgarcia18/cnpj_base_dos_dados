# Setando ambiente --------------------------------------------------------
options(scipen=999)
gc()
set.seed(1)

# Pacotes -----------------------------------------------------------------
library(tidyverse)
# install.packages("remotes")
# remotes::install_github("georgevbsantiago/qsacnpj") - https://github.com/georgevbsantiago/qsacnpj
library(qsacnpj)
library(data.table)
library(basedosdados)
#devtools::install_github("tidyverse/dbplyr")
library(dbplyr)
library(keyring)

# Protegendo o Billing ----------------------------------------------------
key_set("project_billing", "basedosdados")

# Importando bases ------------------------------------------------------
#Definindo caminho relativo
path_estabelecimento <- paste0(getwd(),"/br_receita_federal.estabelecimento")

# Setando conta
basedosdados::set_billing_id(key_get("project_billing", "basedosdados"))

# Carregar os dados do código de 7 dígitos do município
base_municipio <- read_sql(
  "SELECT * FROM `basedosdados.br_bd_diretorios_brasil.municipio`")
base_municipio <- base_municipio %>% dplyr::select("id_municipio", "id_municipio_rf")
names(base_municipio) <- c("id_municipio", "municipio")

# Carregando dados dos países
base_paises <- readr::read_delim(paste0(path_estabelecimento,"/input/bases_receita_outros/F.K03200$Z.D20514.PAISCSV"),
                          delim = ";", escape_double = F, col_names = F,
                          trim_ws = TRUE)
names(base_paises) <- c("pais", "ds_pais")
base_paises$id_pais <- as.numeric(base_paises$pais)
  

# teste <- readr::read_delim(paste0(path_estabelecimento,"/input/bases_receita_estabelecimento/K3241.K03200Y0.D20514.ESTABELE"),
#                                  delim = ";", escape_double = F, col_names = F,
#                                  trim_ws = TRUE,n_max = 10000)



# lista_arquivos_estabelecimento <- list.files(path = path_estabelecimento,
#                                     recursive = TRUE,
#                                     pattern = "\\.ESTABELE",
#                                     full.names = TRUE)

ler_estabelecimento <- function(base,base_mun,base_p,n){

  base <- readr::read_delim(paste0(path_estabelecimento,"/input/bases_receita_estabelecimento/", base),
                                             delim = ";", escape_double = FALSE, col_names = FALSE,
                                             trim_ws = TRUE, locale = locale(encoding = "WINDOWS-1252"))
  
  base$X10 <- ifelse(nchar(base$X10) > 2 | is.na(base$X10), base$X10, paste0("0",base$X10)) %>% as.character() # ajustando código dos países
  

  names(base) <- c("cnpj_basico",
                                "cnpj_ordem",
                                "cnpj_dv",
                                "matriz_filial",
                                "nome_fantasia",
                                "situacao_cadastral",
                                "dt_situacao_cadastral",
                                "motivo_situacao_cadastral",
                                "nome_cidade_exterior",
                                "pais",
                                "dt_inicio_atividade",
                                "cnae_fiscal_principal",
                                "cnae_fiscal_secundaria",
                                "tipo_logradouro",
                                "logradouro",
                                "numero",
                                "complemento",
                                "bairro",
                                "cep",
                                "uf",
                                "municipio",
                                "DDD 1",
                                "TELEFONE 1",
                                "DDD 2",
                                "TELEFONE 2",
                                "DDD DO FAX",
                                "FAX",
                                "CORREIO ELETRÔNICO",
                                "situacao_especial",
                                "dt_situacao_especial")
  
  
  base$cnpj <- paste0(base$cnpj_basico,
                      base$cnpj_ordem,
                      base$cnpj_dv)
  

  base <- base %>% dplyr::select("cnpj",
                                 "matriz_filial",
                                 "nome_fantasia",
                                 "situacao_cadastral",
                                 "dt_situacao_cadastral",
                                 "motivo_situacao_cadastral",
                                 "nome_cidade_exterior",
                                 "pais",
                                 "dt_inicio_atividade",
                                 "cnae_fiscal_principal",
                                 "cnae_fiscal_secundaria",
                                 "tipo_logradouro",
                                 "logradouro",
                                 "numero",
                                 "complemento",
                                 "bairro",
                                 "cep",
                                 "uf",
                                 "municipio",
                                 "situacao_especial",
                                 "dt_situacao_especial")
  
  base$nome_fantasia <- gsub('[0-9]+', '', base$nome_fantasia) #retirando CPF dos nomes fantasia
  
  
  
  base$dt_situacao_cadastral <- as.Date(as.character(base$dt_situacao_cadastral), format = "%Y%m%d")
  base$dt_inicio_atividade <- as.Date(as.character(base$dt_inicio_atividade), format = "%Y%m%d")
  
  
  
  base <- left_join(base, base_municipio, by= c("municipio"))
  base <- left_join(base, base_paises, by = c("pais"))
  
  base$dt_situacao_especial <- NULL
  base$situacao_especial <- NULL
  base$municipio <- NULL
  
  base$ano <- substr(base$dt_situacao_cadastral, 1, 4)
  base$mes <- substr(base$dt_situacao_cadastral, 6, 7)
  base$numero <- ifelse(base$numero == "S/N", NA, base$numero)
  base$numero <- ifelse(base$numero == "SN", NA, base$numero)
  
  base$pais<- base$ds_pais
  base$sigla_uf <- base$uf    
  base$identificador_matriz_filial <- base$matriz_filial    
  base$data_situacao_cadastral <- base$dt_situacao_cadastral   
  base$data_inicio_atividade <-  base$dt_inicio_atividade 
  
  base$ds_pais <- NULL 
  base$uf <- NULL  
  base$matriz_filial <- NULL
  base$dt_situacao_cadastral <- NULL 
  base$dt_inicio_atividade <- NULL  
  
  
  
  base <- base %>% dplyr::select("ano",
                                 "mes",
                                 "id_pais",
                                 "pais",
                                 "nome_cidade_exterior",
                                 "sigla_uf",
                                 "id_municipio",
                                 "cnpj",
                                 "cnae_fiscal_principal",
                                 "cnae_fiscal_secundaria",
                                 "identificador_matriz_filial",
                                 "nome_fantasia",
                                 "situacao_cadastral",
                                 "data_situacao_cadastral",
                                 "motivo_situacao_cadastral",
                                 "data_inicio_atividade",
                                 "tipo_logradouro",
                                 "logradouro",
                                 "numero",
                                 "complemento",
                                 "bairro",
                                 "cep")
  

 write.csv(base, paste0(path_estabelecimento,"/output/","base_estabelecimento", n,".csv"), row.names = F)
}

# Escrevendo as bases
ler_estabelecimento("K3241.K03200Y0.D20514.ESTABELE",base_municipio,base_paises, 0)
gc()
ler_estabelecimento("K3241.K03200Y1.D20514.ESTABELE",base_municipio,base_paises, 1)
gc()
ler_estabelecimento("K3241.K03200Y2.D20514.ESTABELE",base_municipio,base_paises, 2)
gc()
ler_estabelecimento("K3241.K03200Y3.D20514.ESTABELE",base_municipio,base_paises, 3)
gc()
ler_estabelecimento("K3241.K03200Y4.D20514.ESTABELE",base_municipio,base_paises, 4)
gc()
ler_estabelecimento("K3241.K03200Y5.D20514.ESTABELE",base_municipio,base_paises, 5)
gc()
ler_estabelecimento("K3241.K03200Y6.D20514.ESTABELE",base_municipio,base_paises, 6)
gc()
ler_estabelecimento("K3241.K03200Y7.D20514.ESTABELE",base_municipio,base_paises, 7)
gc()
ler_estabelecimento("K3241.K03200Y8.D20514.ESTABELE",base_municipio,base_paises, 8)
gc()
ler_estabelecimento("K3241.K03200Y9.D20514.ESTABELE",base_municipio,base_paises, 9)
gc()

#Analisando a base
base_estabelecimento9 <- read.csv("br_receita_federal.estabelecimento/output/base_estabelecimento9.csv", nrows=100000)
