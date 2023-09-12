# Mean Age Of Onset (MAOO) and other values   

# In this script the cumulative incidence function, and age of onset values are 
# computed for all diagnoses with the function mean_age_of_onset().

# Packages used:
# prodlim
# pracma

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
# Create list to save results.
MAOO_Res <- list()
# Runs analysis for all diagnoses and both sexes.

## Parallelized ##
cl <- makeCluster(2)
doParallel::registerDoParallel(cl)

MAOO_Res <- foreach(i = 1:nDiag, .packages = c("prodlim","pracma")) %dopar% {
  # Creates an empty list
  res_list <- list()
  for(q in 1:2){ 
    # Pull out the desired data, based on sex and diagnose
    # To see which columns are chosen see the Data description
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,8,9,7)]
    # Computes MAOO and CIF.
    res_list[[q]] <- mean_age_of_onset(datq, 
                                       rawdat = TRUE, 
                                       se = TRUE)
  }
  # Assigns the internal diagnose code and sex as name
  names(res_list) <- c(paste(EAOO$Diag[i],"K", sep = ""),
                       paste(EAOO$Diag[i],"M", sep = ""))
  res_list
} ; stopCluster(cl)


for(i in 1:nDiag){
  # Assigns the internal diagnose code as name
  names(MAOO_Res)[i] <- paste(EAOO$Diag[i])
}

## Unparallelized ##
for(i in 1:nDiag){
  # Creates an empty list
  res_list <- list()
  for(q in 1:2){
    # Pull out the desired data, based on sex and diagnose
    # To see which columns are chosen see the Data description
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,8,9,7)]
    # Computes MAOO and CIF.
    res_list[[q]] <- mean_age_of_onset(datq,
                                      rawdat = TRUE,
                                      se = TRUE)
  }
  # Assigns the internal diagnose code and sex as name
  names(res_list) <- c(paste(EAOO$Diag[i],"K", sep = ""),
                       paste(EAOO$Diag[i],"M", sep = ""))
  MAOO_Res[[i]] <- res_list
  # Assigns the internal diagnose code as name
  names(MAOO_Res)[i] <-  paste(EAOO$Diag[i])
}
