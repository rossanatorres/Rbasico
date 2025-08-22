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

# Ejemplo extra basico
x <- 1:10
# Media manual
sum(x)/length(x)
# Media con funcion ya definida
mean(x)


miMedia <- function(vector){
  
  
  media <- sum(vector)/length(vector)
  
  return(media)
  #return(sum(vector)/length(vector))
  
}

miMedia(x)

# Ejemplo basico para que entendamos como definir
# funciones

# estimar imc
estIMC = function(kg, mt){
  
  imc = kg/(mt^2)
  
  return(imc)

}

# Probar mi funcion

estIMC(50, 1.53)

imc_fun <- estIMC(kg = 50, mt = 1.53)
imc_fun

# Corroborar manualmente
kg = 50
mt = 1.53
imc_manual <- kg/(mt^2)
imc_manual

# Probar mi funcion con base Antropometria

imc_vec <- estIMC(Antropometria$peso, 
                  Antropometria$talla/100)

summary(imc_vec)

# Corrobar manualmente
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
# consumo de ssb por tipo de bebidas
tipobebidas_fun <- agruparSumar(data = FFQ, grupo = alimento, 
                    sum_var = consumo)

# # Equivalente
# tipobebidas <- FFQ %>% 
#   group_by(alimento) %>% 
#   summarise(ssb_tot = sum(consumo))


# Consumo por region
region_fun <- agruparSumar(data = FFQ, grupo =region, 
                     sum_var = consumo)


# Equivalente  
# region <- FFQ %>% 
#   group_by(region) %>% 
#   summarise(ssb_tot = sum(consumo))

# consumo de ssb por individuo
ssb_tot_indiv_fun <- agruparSumar(data = FFQ, 
                     grupo = identifier, 
                     sum_var = consumo)


# Equivalente
ssb_tot_indiv <- FFQ %>% 
  group_by(identifier) %>% 
  summarise(ssb_tot = sum(consumo, na.rm = TRUE))


# if else statement (ver diapositivas)==================================

# Estructura general:
# Cuerpo de un ifelse NO CORRER

# if (condicion) {
#   # codigo ejecutado cuando la condicion regresa TRUE
# } else {
#   # codigo ejecutado cuando la condicion regresa FALSE
# }


# Ejemplo:

# Verificar si un vector es numerico


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

vectorNumerico(vector = x)
vectorNumerico(vector = y)
vectorNumerico(vector =z)

# Multiples condiciones
# Estructura general:
# Cuerpo de if else anidados NO CORRER

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

# Iteraciones (ver diapositivas)==========================================

# Cuerpo, NO CORRER

# for (elemento in secuencia) { 
#   
#    # alguna operacion
#     
# }

# secuencia: de donde empiezo a recorrer a donde termino
# de recorrer. Ejemplo: del 1 al 20 (1:20), 1:nrow(df) (de la
# primera fila a ultima, etc)

# Ejemplo facil:
vector <- c("Rossana", "Torres", "Alvarez")
length(vector)
1:3

for (elemento in 1:length(vector)) {
  
  #elemento = 1
  print(vector[elemento])
  
}


# Resolver el problema de if else

x = -10:10
#1:length(x)

for (i in 1:length(x)) {
  
if(x[i] > 1){
  
  print("X es mayor que 1")
  
  } else {
  
    print("X es menor que 1")
  
  }

}

# ifelse es una funcion que hace que un if else
# statement funcione para vectores, es decir,
# ifelse es una funcion vectorizada
ifelse(x >1, "X es mayor que 1", 
       "X es menor que 1")


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

medianas_manual <- c(median(df$a), median(df$b),
                     median(df$c), median(df$d))

# Porque ya sabemos que la longitud del resultado es 4
medianas_loop <- c(NA, NA, NA, NA)

# SI NO SABEMOS O QUEREMOS ALGO MAS CORTO ALTERNATIVA
# USAR VECTOR VACIO
medianas_loop <- c()
  



for (c in 1:ncol(df)) {

  medianas_loop[c] <- median(df[,c])
  
}

medianas_loop


# Equivalente pero con dplyr
medianas_loop_dplyr <- df %>%
  summarise(across(.cols = everything(), 
                   .fns = ~median(.x, na.rm = TRUE))) %>%
  as.numeric()


# A veces los for loops son muy lentos entonces debemos
# Buscar alternativas con otros paquetes
