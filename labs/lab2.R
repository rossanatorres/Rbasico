# Siempre limpiar nuestro environment
rm(list=ls())
# Instalar paquetes
#install.packages("nombre de paquete") # esto solo hacerlo una vez en la vida!!!!!
library(tidyverse) # llamar paquete
#library(survey) #llamar paquete
library(rio)
#library(readxl)
# library(haven)


# Donde yo tengo los archivos que estare usando
#setwd(path = "~/Documents/GitHub/Rbasico")

# Verificar
getwd() 



# Abrir base y explorar base de datos =========================

# # SOLO PARA DEMOSTRACION NO CORRER
# # Leer csv
# data <- read_excel("files/out_agecat_reclassifed1_weighted_2021.xlsx")
# 
# #Leer libro de excel
# data_list <- import_list("files/out_agecat_reclassifed1_weighted_2021.xlsx", setclass = "tbl")
# data_list[[1]] #seleccionar primera hoja de calculo
# data_list$agecat_1 #seleccionar primera hoja de calculo


# Leer dta
# Yo tengo guardada la base aqui:
#Antropometria <- read_dta("files/Antropometria.dta")

Antropometria <- read_dta("tus carpeta/Antropometria.dta")


class(Antropometria)  
dim(Antropometria)  #ver dimension de dataframe
names(Antropometria) #ver variables que tengo en dataframe
nrow(Antropometria)  #ver cuantas filas
ncol(Antropometria)   # ver cuantas columnas hay
head(Antropometria, n = 10)  #ver los primeros 10 datos
tail(Antropometria, n = 10)  # ver los ultimos 10 datos
length(Antropometria$folio) # examinar una columna


class(Antropometria$sexo)
# numerico a categorico
#Antropometria$sexo <- as.character(Antropometria$sexo) # cambiar a caracter
# Usar factor
# Ordenando y etiquetando 
Antropometria$sexo_fac <- factor(Antropometria$sexo, 
                                 levels = c(2,1), 
                                 labels = c("M", "H"))
# categorico a numerico # CON CUIDADO!!!

# Summary statistics ======================================
# Estas funciones vienen predeterminadas en R
# Aplicar a una columna
Antropometria$edad
mean(Antropometria$edad) # para vectores 
median(Antropometria$edad)
hist(Antropometria$edad)
quantile(Antropometria$edad) # cuartil = default
quantile(Antropometria$edad, probs = seq(0, 1, 1/5)) # quintil
sd(Antropometria$edad)
summary(Antropometria$edad)

# Contar observaciones de variables 
# funcion table
table(Antropometria$sexo)
table(Antropometria$edad)
table(Antropometria$sexo, exclude = NULL) # tambien categoria de missings

table(is.na(Antropometria$sexo)) # checar missings


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
# input operacion logica (condicion/caracteristica que necesitamos) 
# output  un vector logico 
which(Antropometria$peso > 60) # cuales filas cumplen mi condicion

# Paso 2. Usar estructura para seleccionar valores 
Antropometria[which(Antropometria$peso > 60),]
# Paso 3. Si lo deseo guardar nuestro resultado
peso60 <- Antropometria[which(Antropometria$peso > 60),]

#Nota: Podemos usar mas de una operacion logica
#condicion1 & condicion2
# & significa que debe cumplir todas las condiciones
# | significa que puede cumplir cualquiera de las dos condiciones
#condicion1 | condicion2
pesoedad60 <- Antropometria[which(Antropometria$peso > 60 & Antropometria$edad >60),]
Antropometria[which(Antropometria$peso > 60 | Antropometria$edad >60),]

# Crear una nueva variable
Antropometria$mi_imc <- Antropometria$peso/(Antropometria$talla/100)^2


# Inicializar una variable vacia
Antropometria$sexo_lab <- NA #otra opcion que no recomiendo
Antropometria$sexo_lab <- rep(NA, nrow(Antropometria))

# Reescribir variable anterior en funcion a otra columna (sexo)
Antropometria$sexo_lab[Antropometria$sexo == 1] <- "Hombre"
Antropometria$sexo_lab[Antropometria$sexo == 2] <- "Mujer"

# Funcion ifelse (equivalente a lo de arriba)
Antropometria$sexo_lab <- rep(NA, nrow(Antropometria))

Antropometria$sexo_lab <- ifelse(Antropometria$sexo == 1, "Hombre",
                                 "Mujer")

# Problema cuando tenemos mas de una categoria pues tenemos que hacer
# ifelse anidados (posible pero que flojera)

# Alternativa:
# Crear una nueva variable
# Inicializar una variable vacia

Antropometria$edad_cat <- rep(NA, nrow(Antropometria))
#Antropometria$edad_cat <- NA # es equivalente
table(Antropometria$edad_cat, exclude = NULL)
# Reescribir variable anterior en funcion a otra columna (edad)

Antropometria$edad_cat[Antropometria$edad<30] <- "20’s"
Antropometria$edad_cat[Antropometria$edad>=30 & Antropometria$edad<40] <- "30’s"
Antropometria$edad_cat[Antropometria$edad>=40 & Antropometria$edad<50] <- "40’s"
Antropometria$edad_cat[Antropometria$edad>=50 & Antropometria$edad<60] <- "50’s"
Antropometria$edad_cat[Antropometria$edad>=60 & Antropometria$edad<70] <- "60’s"
Antropometria$edad_cat[Antropometria$edad>=70 & Antropometria$edad<80] <- "70’s"
Antropometria$edad_cat[Antropometria$edad>=80] <- "80’s"

# Verificar
table(Antropometria$edad_cat, exclude = NULL)


ver <- Antropometria[, c("edad","edad_cat")]

# Introduccion a dplyr ===================================

# glimpse

glimpse(Antropometria) # visualizar la base de datos

# Pipes

x <- rnorm(10) #un vector de 10 elementos 
x %>% max  # a x aplica la funcion max()
# es lo mismo que
max(x)

# Seleccionar solo las columnas que me interesan

mini_antro2 <- select(Antropometria, peso, talla)
mini_antro <- Antropometria[, c(peso, talla)] #equivalente

# con pipes
mini_antro_pipes <- Antropometria %>% select(peso, talla)


# Seleccionar solo las filas que me interesan
# Paso 1. Establecer caracteristica que deseo
peso60 <- filter(Antropometria, peso > 60)
peso60 <- Antropometria[Antropometria$peso > 60, ]


# con pipes
peso60_pipes <- Antropometria %>% dplyr::filter(peso > 60)

#Nota: Podemos usar mas de una operacion logica
# & significa que debe cumplir todas las condiciones
# | significa que puede cumplir cualquiera de las dos condiciones
pesoedad60 <- filter(Antropometria, peso > 60 & edad >60)
pesoedad60 <- filter(Antropometria, peso > 60, edad >60) #equivalente

apesoedad60 <- filter(Antropometria, peso > 60 | edad >60) # al menos una

peso60 <- Antropometria[Antropometria$peso > 60, ]


# Crear una nueva variable

# Base                   # nueva columna
Antropometria <- dplyr::mutate(Antropometria, dos = 2)

# con pipes
Antropometria <- Antropometria %>% dplyr::mutate(uno = 1)

Antropometria$tres <- rep(3, nrow(Antropometria))
Antropometria$tres <- 3

 
# Inicializar una variable vacia
Antropometria <- mutate(Antropometria, mi_imc = peso/((talla)/100)^2)
Antropometria$mi_imc <- Antropometria$peso/(Antropometria$talla/100)^2

# con pipes
Antropometria <- Antropometria %>% mutate(mi_imc2 = peso/((talla)/100)^2)

# Reescribir variable anterior en funcion a otra columna (sexo)

# Funcion case_when
Antropometria <- mutate(Antropometria, 
                        sexo_lab2 = case_when(sexo == 1 ~ "Hombre",
                                             sexo == 2 ~"Mujer"))

Antropometria$sexo_lab <- ifelse(Antropometria$sexo == 1, "Hombre",
                                 "Mujer")

# Podemos usarlo para mas de una categoria
Antropometria <- mutate(Antropometria, 
                        edad_cat = case_when(edad < 20 ~ "20s",
                                             edad >= 20 & edad <50 ~ "Adultez",
                                             edad >= 50 ~ "50+"))

Antropometria <- Antropometria %>% 
                    mutate(edad_cat_pipe = case_when(edad < 20 ~ "20s",
                                             edad >= 20 & edad <50 ~ "Adultez",
                                             edad >= 50 ~ "50+"))


# Verificar

table(Antropometria$edad_cat, exclude = NULL)
table(Antropometria$edad_cat_pipe, exclude = NULL)




# Exportar datos ======================================
# save
write_dta(mini_antro_pipes, "~/Documents/GitHub/Rbasico/mini_antro.dta")
write_csv(mini_antro_pipes, "~/Documents/GitHub/Rbasico/mini_antro.csv")
save(mini_antro_pipes, file = "~/Documents/GitHub/Rbasico/mini_antro.rda")
# write
