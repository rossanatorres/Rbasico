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
estIMC(50, 1.53)


# Probar mi funcion con base

ver <- estIMC(Antropometria$peso, Antropometria$talla/100)
summary(ver)

# Guardar mi resultado en base
Antropometria$imc <- estIMC(Antropometria$peso, 
                            Antropometria$talla/100)

# Ejemplo de codigo repetido que podemos volver funcion
# ver laboratorio 2.5

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



# Aplicar funcion en vectores y guardar nuestro resultado

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
  
 median[col] <- (median(df[,col]))
  
}

medianas

# Paquete survey ======================================
#install.packages("survey") # Recuerda que esto solo se instala una vez!!

library(survey)

# Crear mi identificador
Antropometria$identifier <- factor(paste0("folio_",
                                          Antropometria$folio,
                                          "__intp_",
                                          Antropometria$intp))


table(is.na(Antropometria$pondef))

Antropometria <- Antropometria %>% 
  drop_na(pondef)


Antropometria <- Antropometria %>% 
  mutate(imc_cat = case_when(imc < 18.5 ~ "Bajo peso",
                             imc >= 18.5 & imc < 25 ~ "Normal",
                             imc >= 25 & imc < 30 ~ "Sobrepeso",
                             imc >= 30  ~ "Obesidad"))

table(Antropometria$imc_cat, exclude = NULL)



# IMPORTANTE TENER TODAS LAS VARIABLES QUE VOY A USAR 
# ANTES DE CREAR MI DISENO

mydesign <- svydesign(id = ~ identifier, 
                      strata = ~est_var, 
                      weights = ~pondef ,
                      PSU = ~code_upm, data = Antropometria) 
options(survey.lonely.psu = "adjust")

# Llamo a la funcion svymean 
svymean(~peso, design = mydesign)

class(svymean(~peso, design = mydesign))

svymean(~peso, design = mydesign)

confint(svymean(~peso, design = mydesign))


# Estimar proporcion en categorias de imc 

svymean(~factor(imc_cat), design = mydesign)
confint(svymean(~factor(imc_cat), design = mydesign))

# Estimar proporcion en categorias de imc por sexo

# Opcion 1
svymean(~factor(imc_cat), design = subset(mydesign, sexo == 1))
confint(svymean(~factor(imc_cat), design = subset(mydesign, sexo == 1)))

# Opcion 2
svyby(~imc_cat, by = ~sexo, FUN = svymean, design = mydesign,
      na.rm.all = TRUE)



