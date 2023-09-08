# Mean Age Of Onset (MAOO) and other values   

# In this script the cumulative incidence function, and age of onset values are 
# computed for all diagnoses with the function mean_age_of_onset().

# Packages used:
# prodlim
# pracma

# Packages used for parallization:
# foreach
# doParallel

# Vector for the different sex ("K": Female, "M": Male)
KQN <- c("K","M")
# Create list to save results.
MAOO_Res <- list()
# Runs analysis for all diagnoses and both sex.

## Parallized ##
cl <- makeCluster(23)
doParallel::registerDoParallel(cl)

MAOO_Res <- foreach(i = 1:22, .packages = c("prodlim","pracma")) %dopar% {
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
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  res_list
} ; stopCluster(cl)


for(i in 1:22){
  # Assigns the internal diagnose code as name
  names(MAOO_Res)[i] <- paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}

## Unparallized ##
for(i in 1:22){
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
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  MAOO_Res[[i]] <- res_list
  # Assigns the internal diagnose code as name
  names(MAOO_Res)[i] <-  paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}
