# Incidence rates 

# In this script the incidence rates is computed for all diagnoses and sex.

# Packages used:
# Epi
# popEpi

# Packages used for parallelization:
# foreach
# doParallel

# Internal diagnose names and earliest age of onset 
EAOO <- data.frame("Diag" = c("D10","D11","D12","D20","D21","D22","D30","D31",
                              "D33","D41","D42","D51","D52","D61","D62","D63",
                              "D70","D81","D81","D91","D92","Dyy"),
                   "eaoo" = c(10,10,10,10,10,10,10,10,10,
                              5,5,1,1,10,10,10,1,1,1,1,1,1))
# Saves the number of diagnosis to run the analysis on
nDiag <- nrow(EAOO)
# Vector for the different sex ("K": Female, "M": Male)
KQN <- c("K","M")
# Creates list to save results.
IR_Res <- list()
# for-loop that goes through all diagnoses and both sexes

#### Parallelized ####
cl <- makeCluster(2)
doParallel::registerDoParallel(cl)

IR_Res <- foreach(i = 1:nDiag, .packages = c("Epi","popEpi")) %dopar% {
  res_list <- list()
  eaoo <- EAOO$eaoo[i] # Notes the earliest age of onset for the given diagnose
  for(q in 1:2){
    # Pull out the desired data, based on sex and diagnose
    # To see which columns are chosen see the Data description
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,7,10,11,12)]
    # Computes the incidence rates
    res_list[[q]] <- nIR(datq,  
                         knot = seq(eaoo+2,75,8), 
                         sp = 50, 
                         pv = seq(eaoo,80,0.5),  
                         method = "Lexis")
  }
  # Assigns the internal diagnose code and sex as name
  names(res_list) <- c(paste(EAOO$Diag[i],"K", sep = ""),
                       paste(EAOO$Diag[i],"M", sep = ""))
  res_list
} ; stopCluster(cl)


for(i in 1:nDiag){
  # Assigns the internal diagnose code as name
  names(IR_Res)[i] <- paste(EAOO$Diag[i])
}

#### Unparallelized ####
for(i in 1:nDiag){
  res_list <- list()
  eaoo <- EAOO$eaoo[i] # Notes the earliest age of onset for the given diagnose
  for(q in 1:2){
    # Pull out the desired data, based on sex and diagnose
    # To see which columns are chosen see the Data description
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,7,10,11,12)]
    # Computes the incidence rates
    res_list[[q]] <- nIR(datq,
                         knot = seq(eaoo+2,75,8),
                         sp = 50,
                         pv = seq(eaoo,80,0.5),
                         method = "Lexis")
  }
  # Assigns the internal diagnose code and sex as name
  names(res_list) <- c(paste(EAOO$Diag[i],"K", sep = ""),
                       paste(EAOO$Diag[i],"M", sep = ""))
  IR_Res[[i]] <- res_list
  # Assigns the internal diagnose code as name
  names(IR_Res)[i] <-  paste(EAOO$Diag[i])
}