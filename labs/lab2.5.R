rm(list = ls())
library(tidyverse)

# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")

# Verificar
getwd() 

# Abrir base FFQ  ============================================

# Yo tengo la base guardada aqui
FFQ <- read_csv("files/ensanut_long.csv")

#FFQ <- FFQ <- read_csv("tu carpeta/ensanut_long.csv")

glimpse(FFQ)


# Ventaja de usar pipes

# seleccionar
# filtrar
# crear nueva variable (edad en enteros)

# Un analisis sencillo

# consumo de ssb por tipo de bebidas

# consumo de ssb por region

# Analisis por individuo
nrow(FFQ)
length(unique(FFQ$identifier))

ssb_unique1 <- FFQ %>% 
  group_by(identifier) %>% 
  summarise(ssb_consumo = sum(consumo, na.rm = TRUE))


ssb_notunique <- FFQ %>% 
       group_by(identifier) %>% 
       mutate(ssb_consumo = sum(consumo, na.rm = TRUE))

ssb_unique2 <- ssb_notunique%>% 
  distinct(identifier, .keep_all=TRUE)


# Transformar data de long a wide

wide <- FFQ %>% 
        pivot_wider(names_from = alimento, values_from = consumo)
        


# Abrir base Antropometria ==========================================

# Yo tengo guardada la base aqui:

Antropometria <- read_dta("files/Antropometria.dta")

#Antropometria <- read_dta("tus carpeta/Antropometria.dta")


# Merge por identificador
FFQ$identifier[1]


Antropometria$identifier <- factor(paste0("folio_",
                                          Antropometria$folio,
                                          "__intp_",
                                          Antropometria$intp))

antropometria_mini <- select(Antropometria, identifier, peso, talla)


# Merge
base_completa2 <- left_join(ssb_unique2, antropometria_mini, 
                            by = "identifier")





