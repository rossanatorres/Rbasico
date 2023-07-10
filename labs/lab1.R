
# Definir variables =====================================================

#  X es el valor asignado a x
# escoger un nombre adecuado

# Variable vacia


# Valor logico


# Reescribir variable



# Funcion class


# Ver que hay dentro de variable

# opcion 1


# opcion 2


# opcion 3


# Hacer operaciones aritmeticas



# Hacer operacion logica




# Vectores =====================================================

# Crear vector
#1. Numericos

# Dimension de un vector
# funcion length, ver ayuda


# Operaciones con vectores
# aritmeticas


# que observan?


# logicas


# class


# Asignar arreglo de valores 

# a:b es para establecer un rango de a a b
x <- 1:4 
x



y <- rep(7, 4) # Creaar un vector que con tiene 4 7s
y


# Secuencias
a <- seq(from = 10, to = 23, by = 1) # contar de 10 to a cada 1 unidad
a
b <- seq(from = 10, to = 23) # equivalente
b

d <- seq(10, 23) # equivalente

d


# Vector vacio



# 2. Caracteres 



# operacion (?) con caracteres


# funcion class

# Indexar vectores 

z <- x + y
length(z)# parentesis redondos son para funciones

z[3] # parentesis cuadrados son para indices
z[2]
z[1:3] # 



# Matrices ===============================================================




# estructura: matrix[filas,columnas]
# OJO: mismo numero de filas entre columnas



# Dimension de matriz



# Nombrar columnas de matriz



# Dataframes  =============================================================

# Crear un dataframe
df <- data.frame(x, y, z)
# OJO: mismo numero de filas entre columnas

df # Ver que hay dentro del dataframe
df$x # Usa $ para acceder columnas
df$y

# Dimension de dataframe

dim(df)

# Nombrar columnas dataframe

# Alternativa:


# Obtener nombres de dataframe


# Indexar dataframes
df[3, 1] # estructura: df[filas,columnas]
df[4, ]
df[, 1]
df[c(1, 2, 3), ] # Seleccionar mas de una fila

df[df[, 1] > 2, ] # Operacion logica en fila

# Que notan?


df[c(FALSE, TRUE, TRUE, FALSE), ]
df[c(T, F, F, T), ]




# Hacer calculos/aplicar funciones
sum(df[, 1])
sum(x)


# Reasignar valores
df
df[3, 2] <- 5 
df


# Ordenar valores de columnas
sort(x, decreasing = F) # valor default
sort(x, decreasing = T) # cambiar default



# Crear listas =============================================================
milista <- list(1:10, 1:20)
names(lista) <- c("uno", "dos")


# Accesar listas
milista[[1]]
milista$uno
milista[["uno"]][10]


