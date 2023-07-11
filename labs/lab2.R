# Siempre limpiar nuestro environment
rm(list=ls())
# Instalar paquetes
#install.packages("nombre de paquete") # esto solo hacerlo una vez en la vida!!!!!
#library(tidyverse) # llamar paquete
#library(survey) #llamar paquete
#library(rio)
#library(readxl)
# library(haven)
# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")
# Verificar
getwd() 

# Abrir base y explorar base de datos =========================

# SOLO PARA DEMOSTRACION NO CORRER
# Leer csv
data <- read_excel("files/out_agecat_reclassifed1_weighted_2021.xlsx")

#Leer libro de excel
data_list <- import_list("files/out_agecat_reclassifed1_weighted_2021.xlsx", setclass = "tbl")
data_list[[1]] #seleccionar primera hoja de calculo
data_list$agecat_1 #seleccionar primera hoja de calculo

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
factor(Antropometria$sexo, levels = c(1,2), labels = c("H", "M"))
# categorico a numerico

# Summary statistics ======================================
# Estas funciones vienen predeterminadas en R
# Aplicar a una columna
Antropometria$edad
#mean()
#median()
#quantile()
#sd()
#summary()

# Contar observaciones de variables 
# funcion table
table(Antropometria$sexo)

# Subconjunto de datos =========================================

# Recuerda siempre la estructura
# estructura: midataframe[filas,columnas]

# Seleccionar solo las columnas que me interesan
Antropometria[, 1] # seleccionar la primera columna
Antropometria[, 1:4] # seleccionar las primeras 4 columnas
Antropometria[, "peso"] #seleccionar usando nombre de columna
Antropometria[, c("peso","talla")] #seleccionar mas de una columna usando nombre de columnas

# Si quiero guardar los resultados recuerda asignar un nombre
antro_mini <- Antropometria[, c("peso","talla")]

# Seleccionar solo las filas que me interesan
# Paso 1. Establecer caracteristica que deseo
# funcion which:
# input operacion logica (condicion que necesitamos) 
# output  un vector logico 
which(Antropometria$peso > 60)
# Paso 2. Usar estructura para seleccionar valores 
Antropometria[which(Antropometria$peso > 60),]
# Paso 3. Si lo deseo guardar nuestro resultado
peso60 <- Antropometria[which(Antropometria$peso > 60),]

#Nota: Podemos usar mas de una operacion logica
# & significa que debe cumplir todas las condiciones
# | significa que puede cumplir cualquiera de las dos condiciones
Antropometria[which(Antropometria$peso > 60 & Antropometria$edad >60),]
Antropometria[which(Antropometria$peso > 60 | Antropometria$edad >60),]

# Crear una nueva variable

# bmi

# Inicializar una variable vacia
Antropometria$sexo_lab <- rep(NA, nrow(Antropometria))

# Reescribir variable anterior en funcion a otra columna (sexo)

# Funcion ifelse


# Problema cuando tenemos mas de una categoria pues tenemos que hacer
# ifelse anidados (posible pero que flojera)

# Alternativa:
# Crear una nueva variable
# Inicializar una variable vacia

Antropometria$edad_cat <- rep(NA, nrow(Antropometria))
Antropometria$edad_cat <- NA # es equivalente

# Reescribir variable anterior en funcion a otra columna (edad)

Antropometria$edad_cat[which(Antropometria$edad<30)] <- "20’s"
Antropometria$edad_cat[Antropometria$edad>=30 & Antropometria$edad<40] <- "30’s"
Antropometria$edad_cat[Antropometria$edad>=40 & Antropometria$edad<50] <- "40’s"
Antropometria$edad_cat[Antropometria$edad>=50 & Antropometria$edad<60] <- "50’s"
Antropometria$edad_cat[Antropometria$edad>=60 & Antropometria$edad<70] <- "60’s"
Antropometria$edad_cat[Antropometria$edad>=70 & Antropometria$edad<80] <- "70’s"
Antropometria$edad_cat[Antropometria$edad>=80] <- "80’s"

# Verificar


# Introduccion a dplyr ===================================

# glimpse

# Pipes

x <- rnorm(10)
x %>% max
# es lo mismo que
max(x)

# Ventaja de pipes:

# Seleccionar solo las columnas que me interesan

# con pipes

# Seleccionar solo las filas que me interesan
# Paso 1. Establecer caracteristica que deseo

# con pipes

#Nota: Podemos usar mas de una operacion logica
# & significa que debe cumplir todas las condiciones
# | significa que puede cumplir cualquiera de las dos condiciones


# Crear una nueva variable

# bmi 
# Inicializar una variable vacia

# con pipes

# Reescribir variable anterior en funcion a otra columna (sexo)

# Funcion case_when


# Podemos usarlo para mas de una categoria


# Verificar




# Exportar datos ======================================
# save
# write
