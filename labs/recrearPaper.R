rm(list=ls())
install.packages("readstata13")
library(readstata13)
library(haven)
library(tidyverse)
library(survey)


setwd("~/Documents/GitHub/Rbasico")

##ENSANUT
#Read .dta files 
ensanut       <- read.dta13("files/frecuencia_adultos_nutrimentos.dta")
ffqfoods      <- read.csv("files/FFQ_classifications.csv")

#Added sugar to coffee, tea, milk, and added flavour to milk not included as SSB # Ver si leche preparada sí o no y aguas de fruta con azúcar
ffqfoods$ssb[c(20,49,78,101, 102)]  <- 0 #quité leche (102) para sacar consumo de Tona

#Combine folio (home identifier) and intp (individual identifier)
ensanut$identifier <- factor(paste0("folio_",ensanut$folio,"__intp_",ensanut$intp))
individuals        <- unique(ensanut$identifier)

#Get ssbs
ssb           <- ffqfoods$x[which(ffqfoods$ssb == 1)] 

#Variables in reduced database
ensavars      <- c("identifier","entidad","code_upm",
                   "est_var","pondef","indicef",
                   "nse4f","nse5f","area","region",
                   "sexo","edadanos")

#Deshacer objeto haven_labelled
#Children$zbmicat <- as.character(as_factor(Children$zbmicat))

#Keep those observations of ENSANUT that are SSB
ensanut_clean          <- ensanut[which(ensanut$alimento %in% ssb),]
ensanut_clean          <- ensanut_clean[,c("alimento","consumo",ensavars)]

write_csv(ensanut_clean, "~/Documents/GitHub/Rbasico/files/ensanut_long.csv")


ensanut_clean          <- spread(ensanut_clean, alimento, consumo) #Wide -> long
ensanut_clean$consumo  <- rowSums(ensanut_clean[,which(colnames(ensanut_clean) %in% ssb)], na.rm = TRUE)
ensanut_clean          <- ensanut_clean[,c(ensavars, "consumo")]

#Add those that did not consume any SSB
notssb        <- ensanut[which(!(ensanut$identifier %in% ensanut_clean$identifier)),ensavars]
sans          <- notssb[!duplicated(notssb$identifier), ]
sans$consumo  <- 0

#Bind complete database
ensanut_ssb   <- rbind(ensanut_clean, sans) #2879 adultos
ensanut_ssb <- ensanut_ssb[which(ensanut_ssb$edadanos >= 20),]

#Get BMI, because effect of SSB on BMI is given by BMI
Adultos_BMI            <- read_dta("files/Antropometria.dta")
Adultos_BMI            <- Adultos_BMI[Adultos_BMI$edad>=20,]
Adultos_BMI$bmi        <- (Adultos_BMI$peso/((Adultos_BMI$talla/100)^2) + Adultos_BMI$peso2/((Adultos_BMI$talla2/100)^2))/2
Adultos_BMI$identifier <- factor(paste0("folio_",Adultos_BMI$folio,"__intp_",Adultos_BMI$intp))
Adultos_BMI            <- Adultos_BMI[, c("bmi", "identifier")]
#Adultos_BMI            <- Adultos_BMI[complete.cases(Adultos_BMI),]

ensanut_ssb            <- merge(ensanut_ssb,Adultos_BMI, by="identifier")
#Remove useless extra databases
rm(ensanut, ffqfoods, notssb, sans, ensanut_clean, Adultos_BMI)


mydesign <- svydesign(id = ~ identifier, strata = ~est_var, weights = ~pondef ,
                      PSU = ~code_upm, data = ensanut_ssb) 
options(survey.lonely.psu = "adjust")


svymean(~consumo, mydesign, na.rm = TRUE)

