# Incidence rates 

# In this script the incidence rates is computed for all diagnoses and sex.

# Packages used:
# Epi
# popEpi

# Packages used for parallization:
# foreach
# doParallel

# Vector for the different sex ("K": Female, "M": Male)
KQN <- c("K","M")
# Creates list to save results.
IR_Res <- list()
# for-loop that goes through all diagnoses and both sex

#### Paralized ####
cl <- makeCluster(2)
doParallel::registerDoParallel(cl)

IR_Res <- foreach(i = 1:22, .packages = c("Epi","popEpi")) %dopar% {
  res_list <- list()
  eaoo <- EAOO$eaoo[i] # Notes the earliest age of onset for the given disgnose
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
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  res_list
} ; stopCluster(cl)


for(i in 1:22){
  # Assigns the internal diagnose code as name
  names(IR_Res)[i] <- paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}

#### Unparallized ####
for(i in 1:22){
  res_list <- list()
  eaoo <- EAOO$eaoo[i] # Notes the earliest age of onset for the given disgnose
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
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  IR_Res[[i]] <- res_list
  # Assigns the internal diagnose code as name
  names(IR_Res)[i] <-  paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}