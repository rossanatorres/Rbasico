rm(list=ls())
library(tidyverse)
library(survey)
library(haven)
library(readstata13)
library(gtsummary)

# Antropometria**********
# Yo tengo la base guardada aqui
Antropometria <- read_stata("~/Documents/GitHub/Rbasico/files/Antropometria.dta")
# Crear mi identificador
Antropometria$identifier <- factor(paste0("folio_",
                                          Antropometria$folio,
                                          "__intp_",
                                          Antropometria$intp))


Antropometria <- Antropometria %>% 
  mutate(imc = peso/(talla/100)^2,
         imc_cat = case_when(imc < 18.5 ~ "Bajo peso",
                             imc >= 18.5 & imc < 25 ~ "Normal",
                             imc >= 25 & imc < 30 ~ "Sobrepeso",
                             imc >= 30  ~ "Obesidad"))

Antropometria$imc_cat <- factor(Antropometria$imc_cat,
                                levels = c("Bajo peso",
                                           "Normal",
                                           "Sobrepeso",
                                           "Obesidad"))
table(Antropometria$imc_cat, exclude = NULL)



# IMPORTANTE TENER TODAS LAS VARIABLES QUE VOY A USAR 
# ANTES DE CREAR MI DISENO
table(is.na(Antropometria$pondef))

Antropometria <- Antropometria %>% 
  drop_na(pondef)


# REMOVER TODAS LAS ETIQUETAS!!!!!!!!!!!!!!
Antropometria<-haven::zap_labels(Antropometria)

Antropometria <- Antropometria %>% 
  mutate(sexo_lab = case_when(sexo == 1~ "Hombre",
                              sexo == 2 ~ "Mujer"))


# Usar el paquete gtsummary ============================
# install.packages("survey") # Recuerda que esto solo se instala una vez!!
library(gtsummary)


antro_mini <- select(Antropometria,
                     edad, sexo_lab, peso, talla, imc_cat)

antro_mini %>% 
  tbl_summary()



# Podemos personalizar nuestra tabla facilmente
# Cambiar nombres de filas
antro_mini %>% 
  tbl_summary(label = list(edad ~ "Edad",
                           sexo_lab ~ "Sexo",
                           peso ~ "Peso (kg)",
                           talla ~ "Talla (cm)",
                           imc_cat ~ "Categoria de IMC"))

# Cambiar la estadistica
antro_mini %>% 
  tbl_summary(label = list(edad ~ "Edad",
                           sexo_lab ~ "Sexo",
                           peso ~ "Peso (kg)",
                           talla ~ "Talla (cm)",
                           imc_cat ~ "Categoria de IMC"),
              statistic = list(
                all_continuous() ~ "{mean} ({sd})",
                all_categorical() ~ "{n} / {N} ({p}%)"
              ))

# Darle formato a los numeros
antro_mini %>% 
  tbl_summary(label = list(edad ~ "Edad",
                           sexo_lab ~ "Sexo",
                           peso ~ "Peso (kg)",
                           talla ~ "Talla (cm)",
                           imc_cat ~ "Categoria de IMC"),
              statistic = list(
                all_continuous() ~ "{mean} ({sd})",
                all_categorical() ~ "{n} / {N} ({p}%)"
              ),
              digits = everything() ~ 1)


# Dividir las estadisticas en algun grupo

antro_mini %>% 
  tbl_summary(by = sexo_lab,
              label = list(edad ~ "Edad",
                           #sexo_lab ~ "Sexo",
                           peso ~ "Peso (kg)",
                           talla ~ "Talla (cm)",
                           imc_cat ~ "Categoria de IMC"),
              statistic = list(
                all_continuous() ~ "{mean} ({sd})",
                all_categorical() ~ "{n} / {N} ({p}%)"
              ),
              digits = everything() ~ 1)

#Muy bonito pero y el diseno muestral?

antro_mini_svy <- Antropometria %>% 
  select(sexo_lab, imc_cat, identifier, code_upm, pondef, est_var)

# En vez de la base, aplicare la funcion tbl_svysummary  a 
# mi diseno muestral
options(survey.lonely.psu = "adjust")
survey::svydesign(ids = ~identifier,
                  strata=~est_var,
                  weights = ~pondef,
                  data=antro_mini_svy)%>%
  tbl_svysummary(by = "sexo_lab", 
                 include = c(imc_cat), 
                 label = imc_cat ~ "Categoria de IMC",
                 digits = everything() ~ 1)

# Muy bonito pero y donde guardo mi tabla o que?

tbl <- survey::svydesign(ids = ~identifier,
                  strata=~est_var,
                  weights = ~pondef,
                  data=antro_mini_svy)%>%
  tbl_svysummary(by = "sexo_lab", 
                 include = c(imc_cat), 
                 label = imc_cat ~ "Categoria de IMC",
                 digits = everything() ~ 1)

# Usar paquete flextable
tbl %>%
  as_flex_table() %>%
  flextable::set_table_properties(layout = "autofit", 
                                  opts_word = list(split = TRUE)) %>%
  flextable::save_as_docx(path = "mitablalinda.docx") # R plots or graphic files (png, pdf and jpeg) and HTML, Word, PDF and PowerPoint


tbl %>%
  as_flex_table() %>%
  flextable::set_table_properties(layout = "autofit", opts_word = list(split = TRUE)) %>%
  flextable::save_as_pptx(path = "mitablalinda.pptx") # R plots or graphic files (png, pdf and jpeg) and HTML, Word, PDF and PowerPoint

