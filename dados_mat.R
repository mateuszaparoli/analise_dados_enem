if(!require(data.table)){install.packages('data.table')}


#--------------------
# Caso deseje trocar o local do arquivo, 
# edit a fun��o setwd() a seguir informando o local do arquivo.
#Ex. Windows setwd("C:/temp")
#    Linux   setwd("/home")
#--------------------

library(tidyr)
library(dplyr)
library(ggplot2)

setwd("C:\\Users\\User\\Desktop\\Mateus\\ufmg\\Iniciacao_cientifica\\enem\\info_enem\\DADOS")  

#---------------
# Aloca��o de mem�ria
#---------------
memory.limit(24576)

#------------------
# Carga dos microdados

#itens_2022 <- data.table::fread(input='itens_prova_2022.csv',integer64='character')

data <- data.table::fread(input= 'microdados_enem_2022.csv',integer64='character', nrows = 1000000)

dados_matematica <- data.frame(data$CO_PROVA_MT, data$TX_RESPOSTAS_MT)

#dados_matematica$TX_RESPOSTAS_MT <- paste(" ", dados_matematica$TX_RESPOSTAS_MT)

# Use a função separate para dividir a coluna em várias colunas, pulando a primeira
dados_matematica <- separate(dados_matematica, data.TX_RESPOSTAS_MT, into = paste0("Question_", 0:45), sep = "")

# Remova a coluna original "TX_RESPOSTAS_MT" que não é mais necessária
dados_matematica <- dados_matematica[, -2]

#dados_matematica <- separate(dados_matematica, data.TX_GABARITO_MT, into = paste0("Gabarito_", 0:45), sep = "")

# Substitua "seu_data_frame" pelo nome do seu data frame
resultado <- dados_matematica %>%
  filter(data.CO_PROVA_MT == 1078) %>%
  select(starts_with("Question_")) %>%
  pivot_longer(cols = starts_with("Question_"), names_to = "Coluna") %>%
  group_by(Coluna, value) %>%
  count() %>%
  arrange(Coluna, desc(n))

ggplot(resultado) +
  aes(x = value, y = n) +
  geom_col(fill = "#112446") +
  labs(
    x = "Questions",
    y = "Amount",
    title = "Distribution of Students' Answers in the 2022 ENEM",
    subtitle = "Math Section 1M Students"
  ) +
  theme_minimal() +
  facet_wrap(vars(Coluna))
