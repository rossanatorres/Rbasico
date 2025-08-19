rm(list = ls())
library(tidyverse)

# Clase 3. Ventajas de usar pipes y funciones extra
# dentro de tidyverse

# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")

# Verificar
#getwd() 

# Abrir base FFQ  

# Yo tengo la base guardada aqui
FFQ <- read_csv("~/Documents/GitHub/Rbasico/files/ffq_long.csv")

#FFQ <- FFQ <- read_csv("tu carpeta/ffq_long.csv")

# Siempre tengo que investigar una nueva base!!!
glimpse(FFQ)


# Resumen de ayer y ventaja de usar pipes =====
FFQ <- FFQ %>% 
       select(identifier, sexo, edadanos, region, sexo, edadanos,
              alimento, consumo) %>% 
       mutate(edad_entero = round(edadanos)) 

# Ojo cuando filtro porque pierdo observaciones,
FFQnse <- FFQ %>% 
       filter(nse5f == "muy alto")


# seleccionar
# filtrar
# crear nueva variable (edad en enteros)


######## Funciones extras en tidyverse #########

# Un analisis sencillo ========================

# Quiero calcular el consumo total de 
# bebidas azucaradas (ssb)
# de cada tipo de bebidas (agrupado)

FFQ$alimento
unique(FFQ$alimento)

tipobebidas <- FFQ %>% 
               # Agrupo por tipo de bebida
               group_by(alimento) %>% 
               # Hago un "resumen" por grupo 
               # (en este caso quiero sumar)
               summarise(ssb_tot = sum(consumo))


# Consumo de ssb por region y alimento
unique(FFQ$region)

region <- FFQ %>% 
  # Puedo agrupar por mas de una columna
  group_by(region, alimento) %>% 
  summarise(ssb_tot = sum(consumo))


# Analisis por individuo =======================
nrow(FFQ)
length(unique(FFQ$identifier))

ssb_tot_indiv <- FFQ %>% 
  group_by(identifier) %>% 
  summarise(ssb_tot = sum(consumo, na.rm = TRUE))


# Vamos a ver que pasa si uso mutate
ssb_notunique <- FFQ %>% 
       group_by(identifier) %>% 
       mutate(ssb_tot = sum(consumo, na.rm = TRUE)) %>% 
       ungroup()

ssb_tot_indiv_complete <- ssb_notunique%>% 
  distinct(identifier, .keep_all=TRUE)


# Transformar data de long a wide ============
# https://tidyr.tidyverse.org/reference/pivot_wider.html
FFQ_wide <- FFQ %>% 
        pivot_wider(names_from = alimento, 
                    values_from = consumo)
   
# Paquete que me ayuda a limpiar bases
library(janitor)

# Cambio nombres de columnas      
FFQ_wide <- clean_names(FFQ_wide)

FFQ_wide$nectares <- FFQ_wide$nectares_de_frutas_o_pulpa_de_frutas_industrializados_con_az

sum(FFQ_wide$refresco_normal, na.rm = TRUE)

FFQ_wide <- FFQ_wide %>% 
  mutate(ssb_tot_2 = refresco_normal + nectares)

# No hace bien la operacion por los NAs
# Recodificar 
FFQ_wide$refresco_normal[is.na(FFQ_wide$refresco_normal)] <- 0
FFQ_wide$nectares[is.na(FFQ_wide$nectares)] <- 0

# Vuelvo a correr
FFQ_wide <- FFQ_wide %>% 
  mutate(ssb_tot_2 = refresco_normal + nectares)

# Operacion a lo largo de columnas
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


# Merge FFQ y Antropometria por identificador =======

Antropometria$identifier <- factor(paste0("folio_",
                                          Antropometria$folio,
                                          "__intp_",
                                          Antropometria$intp))

antropometria_mini <- select(Antropometria, 
                             identifier, 
                             peso, talla)


# Merge
# https://bookdown.org/ddiannae/curso-rdata/uniones-para-mutar.html
# https://dplyr.tidyverse.org/reference/mutate-joins.html
base_completa2 <- left_join(ssb_tot_indiv_complete, antropometria_mini, 
                            by = "identifier")





