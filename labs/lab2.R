# Siempre limpiar nuestro environment
rm(list=ls())
# Instalar paquetes
#install.packages("nombre de paquete") # esto solo hacerlo una vez en la vida!!!!!
#library(tidyverse) # llamar paquete
#library(survey) #llamar paquete
#library(rio)
# library(haven)
# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")
# Verificar
getwd() 

# Abrir base y explorar base de datos =========================

# SOLO PARA DEMOSTRACION NO CORRER
# Leer csv

#Leer libro de excel
#data_list <- import_list("Two_Product_Model/Data/out_agecat_reclassifed1_weighted_2021.xlsx", setclass = "tbl")

# Leer dta
Antropometria <- read_dta("files/Antropometria.dta")


# class()  
# dim()  #ver dimension de dataframe
# names() #ver variables que tengo en dataframe
# nrow()  #ver cuantas filas
# head()  #ver los primeros datos
# length() # examinar una columna
# ncol()   # ver cuantas columnas hay

# numerico a categorico
Antropometria$sexo
# Usar factor
# categorico a numerico

# Summary statistics ======================================
# Estas funciones vienen predeterminadas en R
# Aplicar a una columna
Antropometria$edad
#mean()
#median()
#quantile()
# sd()
# summary()

# Contar observaciones de variables categoricas
Antropometria$sexo_cat

# Subconjuntos =========================================
