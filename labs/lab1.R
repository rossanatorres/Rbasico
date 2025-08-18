
# R basico clase 1 
# Rossana
# Torres
# Alvarez

########## Tipos de objetos en R #############################

# Definir variables (UN elemento/simbolo que representa un valor)===========================

#  1 es el valor asignado a val1
val1 =1
Val1 = 1

# escoger un nombre adecuado (ver diapositivas)

val1 <- 1

# el simbolo <- es equivalente a = 
val1 = 1


# Reescribir variable

val1 = 2

# cuidado!!!
val2 = 2

# Tipos de variables 

# val1 y val2 son

# Variable "perdida" (el valor existe pero no es conocido)
perdida = NA

# Variable logico (para pruebas logicas)
logica = TRUE
logica = FALSE
logica = T
logica = F

# Variable caracter 

caracter = "Rossana"
caracter2 = "Torres"


# Funcion class
# Nota: Una función es algún procedimiento que queremos aplicar a algún objecto para
# obtener algún resultado

# nombredefuncion(argumento)

class(x = val1)
class(val1)
class(logica)
class(perdida)
class(caracter)


# Ver que hay dentro de variable
val1 = 1
val1
# opcion 1

(val2 = 2)
# opcion 2
#(val2 <- 2 #usar esc para evitar quedarnos atorados en el codigo

(val2 <- 2)

# opcion 3
print(val2)


# Hacer operaciones aritmeticas (ver diapositivas)
val1 + val2

val3 <- val1 + val2

val4 <- val3 + 2

# Hacer operacion logica (ver diapositivas)

val4 == 6
val4 > 4
val4 >= 5


# Vectores =====================================================

# Un vector es un arreglo de variables. Tambien hay distintos tipos:

#1. Numericos

# Creo mi vector (ver diapositivas)
mivector1 = c(1,2,3)


class(mivector1)


# Longitud de un vector
# funcion length, ver ayuda
length(x = mivector1)
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
mivector1 > mivector2

mivector5 <- c(1,2,3, 4)

mivector1 > mivector5

# Concatenar vectores
mivector6 <- c(mivector1, mivector2)
mivector6

# Tengo un vector de longitud 6


# Asignar arreglo de valores 

# a:b es para establecer un rango de a a b

# 1 a 4
x = 1:15
x


# Crear un vector que contiene 4 7s
y = rep(x = 7, times = 4)

# Usar ayuda para mas informacion

# Secuencias
a <- seq(from = 10, to = 23, by = 1) # contar de x a y cada 1 unidad
a
b <- seq(from = 10, to = 23) # equivalente
b

d <- seq(10, 23) # equivalente

d


# Vector vacio (el valor no existe y no es conocido)
vec_vacio <- c()

vec_vacio

class(vec_vacio) 

# 2. Caracteres 

# Nombres de perritos 
perritos <- c("Cookie", "Copito")

class(perritos)

apellidos <- c("Torres", "Alvarez")


# operacion (?) con caracteres

nombres <- paste0(perritos," ", apellidos)

resultado <- c(perritos, apellidos)


# 3. Logicos

vec_logico <- rep(NA, 10)
vec_logico

vec_logico <- rep(TRUE, 10)
vec_logico

# Indexar vectores (indicar posicion de algun elemento)

z <- x + y
z

length(z)# parentesis redondos son para funciones

z
# parentesis cuadrados son para indices
# obtener el elemento 3
z[3] 
z[2]
z[1:3] # 

apellidos[2]

# Matrices ===============================================================

# Una matriz es un arreglo de vectores del mismo tipo 
mimatriz <- matrix(data = 1, nrow = 4, ncol = 3)
mimatriz

# Accesar elementos
# estructura: matrix[filas,columnas]
# OJO: mismo numero de filas entre columnas
mimatriz[1,1] # elemento en fila 1, columna 1
mimatriz[1,1:3] # primera fila, todas las columnas
mimatriz[1,1:2] # primera fila, todas las columnas


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

# Lista de variables con el mismo numero de elementos (filas) entre variables (columnas)

df # Ver que hay dentro del dataframe
df$x # Usa $ para acceder columnas
df[,1]

df$y

# Dimension de dataframe

dim(df)

# Nombrar columnas dataframe

colnames(df) <- c("Columna1", "Columna2", "Columna3")
df
# Alternativa: Nombrar al crear

df <- data.frame("Columna1" = 1:12,
                 "Columna2" = 1:12,
                 "Columna3" = 1:12)

# Obtener nombres de dataframe
colnames(df)

# Indexar dataframes
# estructura: df[filas,columnas]
df[3, 1] # fila 3, columna 1
df[4, ]  # fila 4, todas las columnas
df[, 1]

df[c(1, 2, 3), ] # Seleccionar mas de una fila
df[1:3, ] # Seleccionar mas de una fila


# pregunta que quiero contestar
df[, 1] > 2

df

df[df[, 1] > 2, ] # Operacion logica en fila

# Que notan?

# Seleccione un subconjunto de mi dataframe que cumpliera
# la condicion > 2

# Hacer calculos/aplicar funciones
sum(df[, 1], na.rm = T)
sum(1:5)

missings = c(1, 2, NA, NA)
sum(missings)
sum(missings, na.rm = TRUE)

# Reasignar valores

df[3, 2] # un elemento: fila 3 columna 2
df[3, 2] <- 5 
df[3, 2] <- c(5,2) # Para reasignar me tengo que fijar en la dimension!!!!

dim(df[3, ])
df[3, ] <- c(1,1,1) # Reasignar con misma dimension



# Temas basicos extra:

# Ordenar valores de vectores

sort(x, decreasing = F) # valor default
sort(x, decreasing = T) # cambiar default
rev(x)

micaracter <- c("Bajo", "Medio", "Alto", "Muy alto")
micaracter
micaracter <- sort(micaracter, decreasing = T)
micaracter

micaracter <- c(micaracter, micaracter, "Bajo",
                "Alto", "Medio", "Muy alto")

# Crear factor para ordenar jerarquicamente 
mifactor <- factor(micaracter, levels = c("Bajo", 
                                          "Medio", 
                                          "Alto", 
                                          "Muy alto"))
class(mifactor)


# Un factor es otro tipo de objeto en el cual sus elementos tienen un orden
# predeterminado


# Extender dataframes
df
df2 <- cbind.data.frame(df, "Columna4" = mifactor)
df2

row <- data.frame("Columna1"=1, "Columna2"=1, "Columna3"=1)
df3 <- rbind.data.frame(df[,1:3], row)
df3

# Ojo: mismo numero de filas entre columnas
df4 <- rbind.data.frame(df2, row)

df4
row <- data.frame("Columna1"=1, "Columna2"=1, "Columna3"=1, "Columna4" = "Alto")
df4 <- rbind.data.frame(df2, row)
df4

# Crear listas =============================================================
# Arreglo de objetos de cualquier tamano (ver diapositivas)
milista <- list(1:10, 1:20, df2)
names(milista) <- c("vector_uno", "vector_dos","data_frame")


# Accesar listas
# Checar dimension de lista = numbero de elementos
length(milista)

ver = milista[1]

milista[[1]] #accesar al primer elemento de la lista
milista$vector_dos # accesar por nombre
milista[["vector_uno"]][10] #accesar al elemento 10 del objeto 1
milista$data_frame$Columna1[1:3] #accesar al data frame, columna1 y los primeros 3 elementos de la columna

#
rm(val4) # borrar algun elemento
ls() # ver el nombre detodos los elementos que tenemos en el environment
rm(list=ls()) # remover todo

