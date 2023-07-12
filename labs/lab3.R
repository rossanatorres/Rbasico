# Siempre limpiar nuestro environment
rm(list=ls())
library(tidyverse) # llamar paquete
library(haven)


# Donde yo tengo los archivos que estare usando
setwd("~/Documents/GitHub/Rbasico")

# Verificar
getwd() 

# Abrir base  ==========================================

# Yo tengo guardada la base aqui:

Antropometria <- read_dta("files/Antropometria.dta")

#Antropometria <- read_dta("tus carpeta/Antropometria.dta")


# Graficas =============================================

#1. Usando paquete graphics (precargado en r) **********

# plot

# ejemplo facil

x <- 1:10
y <- 1:10
plot(x, y)


# Usando talla y edad de base

plot(Antropometria$edad, Antropometria$talla)

# Investigar
ver <- select(Antropometria, edad, talla)

Antropometria <- filter(Antropometria, talla <222)

# Personalizar 
plot(Antropometria$edad, Antropometria$talla,
     main = "Edad vs talla", xlab = "Edad (años)", ylab = "Talla (cm)",
     col = "dodgerblue")



# barplot

barplot(table(Antropometria$sexo))


# hist
hist(Antropometria$peso)

# 2. Paquete ggplot2 *************************************

# Agregar capas

# Paso 1. Lienzo
ggplot()
# Para agregar capas utilizo el simbolo +

# Agrego mis datos y las variables que quiero graficar


ggplot(data = Antropometria, aes(x = edad, y = talla)) 

# Notemos que aun no pasa nada

# Paso 2. Agrego una capa nueva indicando el tipo de grafica que quiero

# notar que las variables que quiero graficar van dentro de
# la funcion aes()
ggplot(data = Antropometria, aes(x = edad, y = talla)) +
  geom_point()

# Agrego color

ggplot(data = Antropometria, aes(x = edad, y = talla)) +
  geom_point(color = "tomato3")

# Opcion 2. Lo mas usado

# aes() dentro de geom_point
ggplot(data = Antropometria) +
  geom_point(aes(x = edad, y = talla), 
             color = "tomato3")

# Opcion 3 
# Pongo datos y aes dentro del tipo de grafica 
ggplot() +
  geom_point(data = Antropometria, 
             aes(x = edad, y = talla), 
             color = "tomato3")

# Ejemplo:
# Quiero separar mi grafica por sexo

Mujeres <- filter(Antropometria, sexo == 2)

Hombres <- filter(Antropometria, sexo == 1)

# Notar que como tengo distintas bases debo hacer dos capas separadas
ggplot() +
  # Capa de Hombres
  geom_point(data = Hombres, aes(x = edad, y = talla,
                                 color = "Hombres")) +
  # Capa de Mujeres
  geom_point(data = Mujeres, aes(x = edad, y = talla, 
                                 color = "Mujeres")) 
# Para poder saber a que corresponde el color


# Solucion mas sencilla:
ggplot() +

geom_point(data = Antropometria, aes(x = edad, y = talla,
                               color = factor(sexo))) 
  


#Paso 3. Personalizo mi grafica agregando mas capas 

ggplot() +
  geom_point(data = Hombres, aes(x = edad, y = talla,
                                 color = "Hombres")) +
  geom_point(data = Mujeres, aes(x = edad, y = talla, 
                                 color = "Mujeres")) +
  # Agrego titulo, nombres de ejes, nombre de escala de colores
  labs(title = "Edad vs Talla", x = "Edad (años)",
       y = "Talla (cm)", color = "Sexo")

