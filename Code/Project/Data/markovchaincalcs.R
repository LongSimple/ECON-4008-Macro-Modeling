library(markovchain)
library(infotheo)
library(dplyr)
library(caret)
library(readxl)
library(xlsx)
bitcoin_price_data <- read_excel("Classes/MacroModeling/Working/Project/Code/Project/Data/bitcoin_price_data.xlsx", 
                                 sheet = "export")
range(bitcoin_price_data$`Adjusted Returns`)
data_dicretized <- discretize(bitcoin_price_data$`Adjusted Returns`, disc="globalequalwidth", nbins=102)
bitcoin_price_data$`Adjusted Returns` <- data_dicretized$X







sequence <- bitcoin_price_data$`Adjusted Returns`

testchain<-markovchainFit(data=sequence, method = "bootstrap", byrow = TRUE, nboot = 5000,laplacian=0,"markovchianboi")

write.xlsx(testchain[["estimate"]]@transitionMatrix, "Classes/MacroModeling/Working/Project/Code/Project/Data/markovchaintest.xlsx")

