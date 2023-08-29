# MAOO --------------------------------------------------------------------

# In this section the cumulative incidence function, and age of onset values are 
# computed for all diagnoses.
# The "mean_age_of_onset"-function can be found in the R-file mentioned above.
KQN <- c("K","M")
# Create list to save results.
MAOO_Res <- list()
# Runs analysis for all diagnoses and both sex.

## Parallized ##
cl <- makeCluster(23)
doParallel::registerDoParallel(cl)

MAOO_Res <- foreach(i = 1:22, .packages = c("prodlim","pracma")) %dopar% {
  res_list <- list()
  for(q in 1:2){ 
    # Pull out the desired data.
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,8,9,7)]
    # Computes MAOO and CIF.
    res_list[[q]] <- mean_age_of_onset(datq, 
                                       rawdat = TRUE, 
                                       se = TRUE)
  }
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  res_list
} ; stopCluster(cl)


for(i in 1:22){
  names(MAOO_Res)[i] <- paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}

## Unparallized ##
for(i in 1:22){
  res_list <- list()
  for(q in 1:2){
    # Pull out the desired data.
    datq <- ldat[[i]][ldat[[i]]$KQN == KQN[q],c(1,2,8,9,7)]
    # Computes MAOO and CIF.
    res_list[[q]] <- mean_age_of_onset(datq,
                                      rawdat = TRUE,
                                      se = TRUE)
  }
  names(res_list) <- c(paste(diag[i],"K", sep = ""),paste(diag[i],"M", sep = ""))
  MAOO_Res[[i]] <- res_list
  names(MAOO_Res)[i] <-  paste(diag[i])
  if(i %% 5 == 0){
    cat("Iteration ", i, "\n")
  }
}
