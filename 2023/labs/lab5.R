# Paquete survey ======================================
#install.packages("survey") # Recuerda que esto solo se instala una vez!!

rm(list=ls())
library(tidyverse)
library(survey)
library(haven)
library(readstata13)

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

# Limpiar NAs
Antropometria <- Antropometria %>% 
  drop_na(pondef)



mydesign <- svydesign(id = ~ identifier, 
                      strata = ~est_var, 
                      weights = ~pondef ,
                      PSU = ~code_upm, data = Antropometria) 
options(survey.lonely.psu = "adjust")


# Ejemplo funcion svymean =========================
svymean(~peso, design = mydesign)

class(svymean(~peso, design = mydesign))

mi_media <- svymean(~peso, design = mydesign)
mi_media
# Extraer elementos de objeto svystat
mi_media[1] 
mi_media[[1]] 

mi_media[2] 

# Usando wrappers
coef(mi_media)
SE(mi_media)
attr(mi_media, "var")
confint(svymean(~peso, design = mydesign))
CI <- confint(mi_media)
class(CI)
dim(CI)

# Estimar proporcion por categorias ======================

# Categorias de sexo numericas
svymean(~sexo, design = mydesign)
# Correcto
svymean(~factor(sexo), design = mydesign)

# Opcion para variables binarias 
# como mi variable sexo es 1 y 2 y no 0 y 1 uso la siguiente
# formula
svyciprop(~I(sexo == 1), design = mydesign)
svyciprop(~I(sexo == 2), design = mydesign)


# Mas de dos categorias
svymean(~imc_cat, design = mydesign)
confint(svymean(~imc_cat, design = mydesign))


# Problema 1:
# Estimar proporcion en categorias de imc por sexo

# Opcion 1. Estimar por sexo separado y pegar a mano en tabla
svymean(~factor(imc_cat), design = subset(mydesign, sexo == 1))
confint(svymean(~factor(imc_cat), design = subset(mydesign, sexo == 1)))

svymean(~factor(imc_cat), design = subset(mydesign, sexo == 2))
confint(svymean(~factor(imc_cat), design = subset(mydesign, sexo == 2)))

# Opcion 2. Usar svby para estimar ambos sexos en un comando y pegar a mano
svyby(~imc_cat, by = ~factor(sexo), FUN = svymean, 
      design = mydesign, 
      na.rm.all = TRUE)

imctab<- svyby(~imc_cat, by = ~factor(sexo), FUN = svymean, 
                    design = mydesign, 
                    na.rm.all = TRUE)
class(imctab)



# Opcion 3. Crear mi propio for loop


table <- data.frame("IMC_cat" = c("Bajo peso",
                                  "Normal",
                                  "Sobrepeso",
                                  "Obesidad"),
                    "Hombres" = NA, "Mujeres" = NA)
col_names <- c("Hombres", "Mujeres")

for (sex in 1:2) {
  
  #sex <- 1
  table[, col_names[sex]] <- (coef(svymean(~factor(imc_cat), 
          design = subset(mydesign, 
                          sexo == sex))))
  
  
}


# Muy bonito pero nos hacen falta los invervalos de confianza

# Hacer una nueva tabla con intervalos de confianza
tableCI <- data.frame("IMC_cat" = c("Bajo peso",
                                  "Normal",
                                  "Sobrepeso",
                                  "Obesidad"),
                    "hombres_prop" = NA, 
                    "hombres_lower" = NA,
                    "hombres_upper" = NA,
                    "mujeres_prop" = NA,
                    "mujeres_lower" = NA,
                    "mujeres_upper" = NA)

prop_names <- c("hombres_prop", "mujeres_prop")
lower_names <- c("hombres_lower", "mujeres_lower")
upper_names <- c("hombres_upper", "mujeres_upper")

for (sex in 1:2) {
  
  # Tabla de antes
  tableCI[, prop_names[sex]] <- coef(svymean(~factor(imc_cat), 
                                          design = subset(mydesign, 
                                                          sexo == sex)))
  
  tableCI[, lower_names[sex]] <- confint(svymean(~factor(imc_cat), 
                                              design = subset(mydesign, 
                                                              sexo == sex)))[,1]
  tableCI[, upper_names[sex]] <- confint(svymean(~factor(imc_cat), 
                                                 design = subset(mydesign, 
                                                                 sexo == sex)))[,2]
  
  
}

# Darle formato a numeros
tableCIformatted <- tableCI %>% 
                    mutate(across(where(is.numeric), 
                                  function(x) x * 100)) %>% 
                    mutate_if(is.numeric, round, 1) %>% 
                    mutate(Hombres = paste0(hombres_prop, " (",
                                            hombres_lower, ", ",
                                            hombres_upper, ")"),
                           Mujeres = paste0(mujeres_prop, " (",
                                            mujeres_lower, ", ",
                                            mujeres_upper, ")")) %>%
                    select(IMC_cat, Hombres, Mujeres)








# Opcion 3. Manipular objetos con dplyr
imctabWide <- svyby(~imc_cat, by = ~factor(sexo), FUN = svymean, 
                    design = mydesign, 
                    na.rm.all = TRUE)


imctabLong <- imctabWide %>% 
  select("factor(sexo)", starts_with("imc_cat")) %>% 
  pivot_longer(starts_with("imc_cat"),
               names_to = "imc_cat",
               values_to = "mean")

imctabfinalWide <- imctabLong %>% 
  pivot_wider(names_from = "factor(sexo)",
              values_from = "mean")

# Muy bonito pero nos hacen falta los invervalos de confianza

imctabCI <- confint(svyby(~imc_cat, by = ~factor(sexo), 
                          FUN = svymean, design = mydesign, 
                          na.rm.all = TRUE))

imctabCILong <- data.frame(imctabCI) %>% 
  rownames_to_column() %>% 
  mutate(sexo = rep(c(1,2), 4))


imctabCILong[imctabCILong$sexo ==1, c(2,3)]

imctabHombres <- cbind(imctabfinalWide[,2], imctabCILong[imctabCILong$sexo ==1, c(2,3)])
imctabMujeres <- cbind(imctabfinalWide[,3], imctabCILong[imctabCILong$sexo ==2, c(2,3)])

imctabboth <- cbind("IMC_cat" = c("Bajo peso",
                                  "Normal",
                                  "Sobrepeso",
                                  "Obesidad"), 
                    imctabHombres,imctabMujeres)
names(imctabboth) <- names(tableCI)

tableBothformatted <- imctabboth %>% 
  mutate(across(where(is.numeric), 
                function(x) x * 100)) %>% 
  mutate_if(is.numeric, round, 1) %>% 
  mutate(Hombres = paste0(hombres_prop, " (",
                          hombres_lower, ", ",
                          hombres_upper, ")"),
         Mujeres = paste0(mujeres_prop, " (",
                          mujeres_lower, ", ",
                          mujeres_upper, ")")) %>%
  select(IMC_cat, Hombres, Mujeres)

# Muy bonito pero y que tal que quiero usar mas variables?


