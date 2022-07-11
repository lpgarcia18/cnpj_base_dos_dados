# Setando ambiente --------------------------------------------------------
options(scipen=999)
gc()
set.seed(1)

# Pacotes -----------------------------------------------------------------
library(tidyverse)
library(data.table)


# Extração ----------------------------------------------------------------
motivo_situacao_cadastral <- readr::read_delim(paste0(path_estabelecimento,"/input/bases_receita_outros/F.K03200$Z.D20514.MOTICSV"),
                                 delim = ";", escape_double = F, col_names = F,
                                 trim_ws = TRUE)
names(motivo_situacao_cadastral) <- c("motivo_situacao_cadastral", "desc_motivo_situacao_cadastral")

#Definindo caminho relativo
path_estabelecimento <- paste0(getwd(),"/br_receita_federal.estabelecimento")

write.csv(motivo_situacao_cadastral, paste0(path_estabelecimento,"/output/","motivo_situacao_cadastral.csv"))

          