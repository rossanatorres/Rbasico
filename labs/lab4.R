rm(list =ls()) # limpiar environment
library(tidyverse)
library(haven)


# Abrir bases  ============================================

# FFQ**********
# Yo tengo la base guardada aqui
FFQ <- read_csv("~/Documents/GitHub/Rbasico/files/ffq_long.csv")

# Tu debes correr esta linea, cambia el directorio 
#FFQ <- FFQ <- read_csv("tu directorio/ffq_long.csv")

# Antropometria**********
# Yo tengo la base guardada aqui
Antropometria <- read_dta("~/Documents/GitHub/Rbasico/files/Antropometria.dta")





# Tu debes correr esta linea, cambia el directorio 
#Antropometria<-  read_dta("tu directorio/Antropometria.dta")


# Funciones ======================================

# Estructura general:
# Cuerpo de una funcion NO CORRER

# miFuncion <- function(inputs) {
#   
#   output = # Alguna operacion/proceso
#     
#     return(output)
#   
# }

# Ejemplo basico

# estimar imc
estIMC <- function(kg, mt){
  
  imc <- kg/(mt^2)
  
  return(imc)

}



# Probar mi funcion
estIMC(kg = 50, mt = 1.53)

kg = 50
mt = 1.53
imc <- kg/(mt^2)
imc

# Probar mi funcion con base

imc_vec <- estIMC(kg = Antropometria$peso, mt = Antropometria$talla/100)

summary(imc_vec)

kg = Antropometria$peso
mt = Antropometria$talla/100

imc_vec2 <- Antropometria$peso/(Antropometria$talla/100)^2
summary(imc_vec2)


# Guardar mi resultado en base
Antropometria$imc <- estIMC(Antropometria$peso, 
                            Antropometria$talla/100)




# Ejemplo de codigo repetido que podemos volver funcion
# en laboratorio 2.5

# consumo de ssb por tipo de bebidas
tipobebidas <- FFQ %>% 
  group_by(alimento) %>% 
  summarise(ssb_tot = sum(consumo))


# consumo de ssb por region 
region <- FFQ %>% 
  group_by(region) %>% 
  summarise(ssb_tot = sum(consumo))

# consumo de ssb por individuo
ssb_tot_indiv <- FFQ %>% 
  group_by(identifier) %>% 
  summarise(ssb_tot = sum(consumo, na.rm = TRUE))

# NO ESPANTARSE
agruparSumar <- function(data, grupo, sum_var){

  # https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html
  new_data <- data %>% 
  group_by(across({{grupo}})) %>% 
  summarise("suma_{{sum_var}}" := sum({{sum_var}}))

  return(new_data)
  
}

# Probar
res <- agruparSumar(FFQ, alimento, consumo)
res2 <- agruparSumar(FFQ, region, consumo)
res3 <- agruparSumar(FFQ, identifier, consumo)


# if else statement ==================================

# Estructura general:
# Cuerpo de un ifelse NO CORRER

# if (condicion) {
#   # codigo ejecutado cuando la condicion regresa TRUE
# } else {
#   # codigo ejecutado cuando la condicion regresa FALSE
# }


# Ejemplo:

# Verificar si un vector es numerico

vector = c(1:10)

if(is.numeric(vector)){
  
  print("El vector es numerico")
  
} else {
  
  print("El vector no es numerico")
  
}


# Funcion para verificar si un vector es numerico

vectorNumerico <- function(vector){
  
  if(is.numeric(vector)){
    
    print("El vector es numerico")
    
  } else {
    
    print("El vector no es numerico")
    
  }
  
  
  
}

x <- c(1,2,3)
y <- c("Rossana", "Torres")
z <- c(TRUE, FALSE, NA)

vectorNumerico(x)
vectorNumerico(y)
vectorNumerico(z)

# Multiples condiciones
# Estructura general:
# Cuerpo de ifelse anidados NO CORRER

# if (condicion) {
#   # Hace algo
# } else if (otra condicion) {
#   # Hace otra cosa
# } else {
#   # Hace otra cosa distinta a las anteriores
# }

# Ejemplo
numero <- -5

if(numero < 0){
  print("El numero es negativo")
} else if(numero == 0){
  print("El numero es cero")
} else{
  print("El numero es positivo")
}


# CUIDADO La condición debe devolver o TRUE o FALSE, 
#no un vector de TRUE/FALSE ni un elemento vacío

# Ejemplo de algo que NO FUNCIONA
x = 1:10

if(x > 1){
  
  print("X es mayor que 1")

  } else {
  
  print("X es menor que 1")

    }

# Iteraciones ==========================================

# Cuerpo, NO CORRER
# for (elemento in secuencia) { 
#   
#    # alguna operacion
#     
# }

# Ejemplo facil:
vector <- c("Rossana", "Torres", "Alvarez")

for (i in 1:length(vector)) {
  
  print(vector[i])
  
}


# Resolver el problema de if else

x = -10:10

for (i in 1:length(x)) {
  
if(x[i] > 1){
  
  print("X es mayor que 1")
  
  } else {
  
    print("X es menor que 1")
  
  }

}

# Modificar algun objeto

x <- 1:10
x
for (i in 1:length(x)) {
  
  x[i] <- x[i]^2
  
}
x




# Problema: Calcular la mediana de cada columna
df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

median(df$a)
median(df$b)
median(df$c)
median(df$d)

medianas <- c()

for (col in 1:ncol(df)) {
  
  #col <- 2
  
 medianas[col] <- (median(df[,col]))
  
}

medianas
#rbind(df, medianas)


