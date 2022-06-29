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


# Download das bases ------------------------------------------------------
# Fazendo download dos dados dos estabelecimentos de https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/cadastros/consultas/dados-publicos-cnpj
down_func <- function(url, file){
    destino <- paste0(getwd(),"/bases_receita/", file)
    download.file(url, destino)
}

down_func("http://200.152.38.155/CNPJ/K3241.K03200Y0.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 01.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y1.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 02.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y2.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 03.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y3.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 04.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y4.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 05.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y5.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 06.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y6.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 07.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y7.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 08.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y8.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 09.zip")
down_func("http://200.152.38.155/CNPJ/K3241.K03200Y9.D20514.ESTABELE.zip", "Dados Abertos CNPJ ESTABELECIMENTO 10.zip")
