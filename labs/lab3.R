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

# Personalizar (ver diapositivas)
plot(x = Antropometria$edad, y = Antropometria$talla,
     main = "Edad vs talla", 
     xlab = "Edad (años)", 
     ylab = "Talla (cm)",
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

# Opcion 1. Agrego mis datos y las variables que quiero graficar

ggplot(data = Antropometria, 
       aes(x = edad, y = talla)) 

# Notemos que aun no pasa nada

# Paso 2. Agrego una capa nueva indicando el tipo de grafica que quiero

# notar que las variables que quiero graficar van dentro de
# la funcion aes()
ggplot(data = Antropometria, 
       aes(x = edad, y = talla)) +
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
             aes(x = edad, 
                 y = talla), 
             color = "tomato3",
             size = 1
             )

# Ejemplo:
# Quiero separar mi grafica por sexo Y LA INFORMACION ESTA
# EN BASES DISTINTAS

# IMAGINEMOS que los datos NO vienen de la misma base
Mujeres <- filter(Antropometria, sexo == 2)

Hombres <- filter(Antropometria, sexo == 1)

# Notar que como tengo distintas bases debo hacer dos capas separadas
ggplot() +
  # Capa de Hombres
  geom_point(data = Hombres,
             aes(x = edad, 
                 y = talla),
              color = "magenta4") +
  # Capa de Mujeres
  geom_point(data = Mujeres, 
             aes(x = edad, 
                 y = talla),
             color = "magenta2") 


# Para poder saber a que corresponde el color, puedo poner
# etiquetas NOTEN QUE LAS ETIQUETAS VAN DENTRO DE aes()


ggplot() +
  # Capa de Hombres
  geom_point(data = Hombres,
             aes(x = edad, 
                 y = talla,
                 color = "Hombres")
             ) +
  # Capa de Mujeres
  geom_point(data = Mujeres, 
             aes(x = edad, 
                 y = talla,
                 color = "Mujeres"
                 )
             ) +  # SI NO AGREGO COLORES, R ESCOGERA COLORES PREDETERMINADOS
  
  # Agrego capa para color
  scale_color_manual(values = c("Hombres" = "magenta4",
                                "Mujeres" = "magenta2"))
# Para poder saber a que corresponde el color


# COMO MI VARIABLE SEXO ESTA DENTRO DE MI BASE
# Solucion mas sencilla:
ggplot() +

geom_point(data = Antropometria, 
           aes(x = edad, 
               y = talla,
               color = factor(sexo) # use factor para respetar grupos y no numeros
               )
           ) + # Agrego capa para color
  scale_color_manual(values = c("1" = "magenta4", # Uso los valores de variable sexo
                                "2" = "magenta2"))
  


#Paso 3. Personalizo mi grafica agregando mas capas 

ggplot() +
  geom_point(data = Hombres, aes(x = edad, y = talla,
                                 color = "Hombres")) +
  geom_point(data = Mujeres, aes(x = edad, y = talla, 
                                 color = "Mujeres")) +
  # Agrego titulo, nombres de ejes, nombre de escala de colores
  labs(title = "Edad vs Talla", 
       x = "Edad (años)",
       y = "Talla (cm)", 
       color = "Sexo") +
  # Agrego capa para color
  scale_color_manual(values = c("Hombres" = "magenta4",
                                "Mujeres" = "magenta2")) +
  theme_classic()



# Para guardar nombro mi grafica con el nombre que quiera

migrafica <- ggplot() +
  geom_point(data = Hombres, aes(x = edad, y = talla,
                                 color = "Hombres")) +
  geom_point(data = Mujeres, aes(x = edad, y = talla, 
                                 color = "Mujeres")) +
  # Agrego titulo, nombres de ejes, nombre de escala de colores
  labs(title = "Edad vs Talla", x = "Edad (años)",
       y = "Talla (cm)", color = "Sexo")

# Ahora para verla escribo el nombre
migrafica


# Opcion 1 de guardar
ggsave(filename = "migrafica2.png", plot = migrafica)


# Opcion 2 para guardar (mejor resolucion)
# Llamo la funcion pdf
pdf(file = "~/Documents/GitHub/Rbasico/migrafica3.pdf",
    width = 10, height = 7)

migrafica # el objeto que queremos guardar

dev.off()  # para que el GUI nos funcione bien
