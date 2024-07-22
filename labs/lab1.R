
rm(list=ls())
# Clase 1. R Basico !!!!!!!!!!!!!
# Definir variables =====================================================

#  X es el valor asignado a x
# escoger un nombre adecuado

val1 <- 1

# el simbolo <- es equivalente a = 
val2 = 2 

# Reescribir variable
# cuidado!!!

# Variable vacia
vacia <- NA

# Valor logico

logico <- TRUE
logico <- FALSE
logico <- T
logico <- F


# Funcion class
class(val1)
class(logico)
class(vacia)

# Ver que hay dentro de variable

# opcion 1
val2 <- 2
val2

# opcion 2
(val2 <- 2) # cuidado si no cerramos nos sale error
#(val2 <- 2 #usar esc para evitar quedarnos atorados en el codigo

# opcion 3
print(val2)


# Hacer operaciones aritmeticas
val1 + val2

val3 <- val1 + val2

val4 <- val3 + 2

# Hacer operacion logica

val4 > 8
val4 < 8
val4 <= 8
val4 >= 8
val4 == 6

# Vectores =====================================================

# Crear vector
#1. Numericos
mivector1 <- c(1, 2, 3)
class(mivector1)

# Dimension de un vector
# funcion length, ver ayuda
length(mivector1)

# Operaciones con vectores
# aritmeticas

mivector1 + 1

mivector2 <- c(4,5,6)

mivector1 + mivector2


# que observan?
mivector1
mivector2
mivector1 + mivector2
# logicas


# class
class(mivector1)

# Asignar arreglo de valores 

# a:b es para establecer un rango de a a b
x <- 1:4 
x



y <- rep(x = 7, times = 4) # Crear un vector que con tiene 4 7s
y

# Usar ayuda para mas informacion

# Secuencias
a <- seq(from = 10, to = 23, by = 1) # contar de 10 to a cada 1 unidad
a
b <- seq(from = 10, to = 23) # equivalente
b

d <- seq(10, 23) # equivalente

d


# Vector vacio
vec_vacio <- c()

vec_vacio

class(vec_vacio)

# 2. Caracteres 

# Nombres de perritos mexicanos

perritos <- c("Copito", 'Firulais')
class(perritos)

apellidos <- c("Torres", "Alvarez")


# operacion (?) con caracteres

nombres <- paste0(perritos," ",apellidos, perritos)

resultado <- c(nombres, apellidos)


# Indexar vectores 

z <- x + y
z

length(z)# parentesis redondos son para funciones

z
z[3] # parentesis cuadrados son para indices
z[2]
z[1:3] # 



# Matrices ===============================================================

mimatriz <- matrix(data = 1, nrow = 4, ncol = 3)
mimatriz

# Accesar elementos
# estructura: matrix[filas,columnas]
# OJO: mismo numero de filas entre columnas
mimatriz[1,1] # elemento en fila 1, columna 1
mimatriz[1,1:3] # primera fila, todas las columnas
mimatriz[1,] # primera fila todas las columnas
mimatriz[,2]
# Dimension de matriz
dim(mimatriz)



# Nombrar columnas de matriz
colnames(mimatriz) <- c("Columna1", "Columna2", "Columna3")
mimatriz
rownames(mimatriz) <- c("Fila1", "Fila2", "Fila3", "Fila4")
mimatriz

mimatriz["Fila2","Columna3"]

# Dataframes  =============================================================

# Crear un dataframe
df <- data.frame(x, y, z)

# OJO: mismo numero de filas entre columnas (vectores)

df # Ver que hay dentro del dataframe
df$x # Usa $ para acceder columnas
df$y

# Dimension de dataframe

dim(df)

# Nombrar columnas dataframe

colnames(df) <- c("Columna1", "Columna2", "Columna3")
df
# Alternativa:
df <- data.frame("columna1"= x, "columna2" = y, "columna3" =z)
df

# Obtener nombres de dataframe
colnames(df)

# Indexar dataframes
# estructura: df[filas,columnas]
df[3, 1] # fila 3, columna 1
df[4, ]  # fila 4, todas las columnas
df[, 1]

df[c(1, 2, 3), ] # Seleccionar mas de una fila
df[1:3, ] # Seleccionar mas de una fila


#df[c("columna1", "columna2"), ]

# pregunta que quiero contestar
df[, 1] > 2

df

df[df[, 1] > 2, ] # Operacion logica en fila

# Que notan?





# Hacer calculos/aplicar funciones
sum(df[, 1], na.rm = T)
sum(x)

missings = c(1, 2, NA, NA)
sum(missings, na.rm = TRUE)

# Reasignar valores

df[3, 2] # un elemento: fil 3 columna 2
df[3, 2] <- 5 
df[3, 2] <- c(5,2) # Para reasignar me tengo que fijar en la dimension!!!!
dim(df[3, ])
df[3, ] <- c(1,1,1) # Reasignar con misma dimension

df$prueba_logica <- rep(NA, nrow(df))
df$prueba_logica <- df[, 1] > 2

# Ordenar valores de columnas


sort(x, decreasing = F) # valor default
sort(x, decreasing = T) # cambiar default
rev(x)

micaracter <- c("Bajo", "Medio", "Alto", "Muy alto")
micaracter
micaracter <- sort(micaracter, decreasing = T)
micaracter

# Crear factor para ordenar jerarquicamente 
mifactor <- factor(micaracter, levels = c("Bajo", 
                                          "Medio", 
                                          "Alto", 
                                          "Muy alto"))
class(mifactor)

df
df2 <- cbind.data.frame(df, "columna4" = mifactor)
df2

row <- data.frame("columna1"=1, "columna2"=1, "columna3"=1)
df3 <- rbind.data.frame(df[,1:3], row)

# Ojo: mismo numero de filas entre columnas
df4 <- rbind.data.frame(df2, row)

row <- data.frame("columna1"=1, "columna2"=1, "columna3"=1, "columna4" = 1)
df4 <- rbind.data.frame(df2, row)

row <- data.frame("columna1"=1, "columna2"=1, "columna3"=1, "columna4" = "Alto")
df4 <- rbind.data.frame(df2, row)

# Crear listas =============================================================
# Arreglo de objetos de cualquier tamano
milista <- list(1:10, 1:20, df2)
names(milista) <- c("vector_uno", "vector_dos","data_frame")


# Accesar listas
# Checar dimension de lista = numbero de elementos
length(milista)

milista[[1]] #accesar al primer elemento de la lista
milista$vector_dos # accesar por nombre
milista[["vector_uno"]][10] #accesar al elemento 10 del objeto 1
milista$data_frame$columna1[1:3] #accesar al data frame, columna1 y los primeros 3 elementos de la columna

#
rm(val4) # borrar algun elemento
ls() # ver el nombre detodos los elementos que tenemos en el environment
rm(list=ls()) # remover todo

