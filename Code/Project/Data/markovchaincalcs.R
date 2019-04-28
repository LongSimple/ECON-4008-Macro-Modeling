library(markovchain)
library(infotheo)
library(dplyr)
library(caret)
library(readxl)
library(xlsx)
bitcoin_price_data <- read_excel("Classes/MacroModeling/Working/Project/Code/Project/Data/bitcoin_price_data.xlsx", 
                                 sheet = "export2", col_types = c("numeric", 
                                                                  "numeric", "numeric"))

sequence <- rep(bitcoin_price_data$Return, bitcoin_price_data$`Times Sampled`)

sequenceMatr<-createSequenceMatrix(sequence,sanitize=FALSE)
mcFitMLE<-markovchainFit(data=sequence)
mcFitBSP<-markovchainFit(data=sequence,method="bootstrap",nboot=5, name="Bootstrap Mc")
write.xlsx(mcFitMLE[["standardError"]], "Classes/MacroModeling/Working/Project/Code/Project/Data/markovchain.xlsx")

