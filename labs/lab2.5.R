rm(list = ls())
library(tidyverse)
#library()

# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")

# Verificar
#getwd() 

# Abrir base FFQ  ============================================

# Yo tengo la base guardada aqui
FFQ <- read_csv("~/Documents/GitHub/Rbasico/files/ffq_long.csv")

#FFQ <- FFQ <- read_csv("tu carpeta/ffq_long.csv")

glimpse(FFQ)


# Ventaja de usar pipes

FFQ <- FFQ %>% 
       select(identifier, sexo, edadanos, region, sexo, edadanos,
              alimento, consumo) %>% 
       mutate(edad_entero = round(edadanos)) #%>% 
       #filter(sexo == "masculino")


# seleccionar
# filtrar
# crear nueva variable (edad en enteros)

# Un analisis sencillo

# consumo de ssb por tipo de bebidas
unique(FFQ$alimento)
tipobebidas <- FFQ %>% 
               group_by(alimento) %>% 
               summarise(ssb_tot = sum(consumo))


# consumo de ssb por region

region <- FFQ %>% 
  group_by(region) %>% 
  summarise(ssb_tot = sum(consumo))


unique(FFQ$region)



# Analisis por individuo
nrow(FFQ)
length(unique(FFQ$identifier))

ssb_tot_indiv <- FFQ %>% 
  group_by(identifier) %>% 
  summarise(ssb_tot = sum(consumo, na.rm = TRUE))


# Opcion 2 (sin usar summarise)
ssb_notunique <- FFQ %>% 
       group_by(identifier) %>% 
       mutate(ssb_tot = sum(consumo, na.rm = TRUE))

# ungroup()

ssb_tot_indiv_complete <- ssb_notunique%>% 
  distinct(identifier, .keep_all=TRUE)


# Transformar data de long a wide
# https://tidyr.tidyverse.org/reference/pivot_wider.html
FFQ_wide <- FFQ %>% 
        pivot_wider(names_from = alimento, values_from = consumo)
        
sum(FFQ_wide$`refresco normal`, na.rm = TRUE)

FFQ_wide <- FFQ_wide %>% 
  mutate(ssb_tot_2 = `refresco normal` + `néctares de frutas o pulpa de frutas industrializados con az`)

# Recodificar 
FFQ_wide$`refresco normal`[is.na(FFQ_wide$`refresco normal`)] <- 0
FFQ_wide$`néctares de frutas o pulpa de frutas industrializados con az`[is.na(FFQ_wide$`néctares de frutas o pulpa de frutas industrializados con az`)] <- 0


FFQ_wide <- FFQ_wide %>% 
  mutate(ssb_tot_all = rowSums(across(!c("identifier",
                                "sexo",
                                "edadanos",
                                "region",
                                "edad_entero")), 
                       na.rm = TRUE))



# Abrir base Antropometria ==========================================

# Yo tengo guardada la base aqui:

Antropometria <- read_dta("files/Antropometria.dta")

#Antropometria <- read_dta("tus carpeta/Antropometria.dta")


# Merge por identificador

Antropometria$identifier <- factor(paste0("folio_",
                                          Antropometria$folio,
                                          "__intp_",
                                          Antropometria$intp))

antropometria_mini <- select(Antropometria, identifier, peso, talla)


# Merge
# https://bookdown.org/ddiannae/curso-rdata/uniones-para-mutar.html
# https://dplyr.tidyverse.org/reference/mutate-joins.html
base_completa2 <- left_join(ssb_tot_indiv_complete, antropometria_mini, 
                            by = "identifier")





