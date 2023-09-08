# Mean age of onset 

# This function combines the functions CIF(), mean_age(), median_age(), and 
# quantile_age into one function. 
# Generate pseudo survival function
# F(t) = int_0^t S(u)a(u)du
# G(t) = 1 - F(t)/F(A)
# where F(A) = max(F(t))

# Packages used:
# prodlim
# pracma

# Input:
# df      : Data used. Can either be raw data or the output of the CIF-function.
# rawdat  : Indicates if the format of the data. Default is FALSE.   
# medians : Indicator for computing the median in the output. Default is TRUE.
# se      : Indicates if the function will have confidence intervals in 
#           its output. Is only useful if rawdat is TRUE.

# Output:
#   - Returns a list containing values for the cause diagnosed:
#       1) The mean. Computed with mean_age()
#       2) The median. Computed with median_age()
#       3) The first and third quantile. Computed with quantile_age  
#       4) The pseudo survival function.
#       5) The value of F(A). Where A = 80.
#       6) The output from the function CIF().
#       7) The lower bound from the function CIF().
#       8) The upper bound from the function CIF().
#       9) The confidence interval for the estimae of the mean.
#      10) The model output from the function CIF(). 

mean_age_of_onset <- function(df, rawdat = FALSE, medians = TRUE, se = FALSE){
  ndf <- df
  # Computes the cumulative incidence if it is given rawdata.
  if(rawdat == TRUE){
    mod = CIF(df, se = se)
    ndf = mod[[1]] 
  }
  # Computes the pseudo survival function.
  ndf$G1 <- 1 - ndf$prob.1/max(ndf$prob.1)
  # Mean by integrating under the survival curve.
  aa <- mean_age(ndf$time,ndf$G1)
  out_mean <- data.frame("Cause" = 1, "Mean" = aa)
  
  out <- list("Mean" = out_mean)
  # Computes the median if medians is equal TRUE.
  if(medians == TRUE){
    # Find median age, ie age at which half probability mass is below and above.
    am <- median_age(ndf,ndf$G1)$time
    a <- mean(am)
    out_median <- data.frame("Cause" = 1,  "Median" = a)
    out$median <- out_median
  }
  # Computes the 25% and 75% quantile ages
  a25 <- mean(quantile_age(ndf,ndf$G1,0.25)$time)
  a75 <- mean(quantile_age(ndf,ndf$G1,0.75)$time)
  out$quantile <- c(a25,a75)
  # Saves the pseudo survival function to the output.
  out$G <- ndf$G1
  # Save F(A) to the output.
  out$mFA <- max(ndf$prob.1)
  
  if(rawdat == TRUE){
    out$CIF <- ndf
    if(se == TRUE){
      out$lower <- mod[[2]]
      out$upper <- mod[[3]]
      
      L1 <- c(0,mod[[2]]$`1`)
      U1 <- c(0,mod[[3]]$`1`)
      # Computes the confidence intervals for the mean age of onset
      G1L <- 1 - L1/max(L1)
      muL <- mean_age(ndf$time,G1L)
      G1U <- 1 - U1/max(U1)
      muU <- mean_age(ndf$time,G1U)
      
      out$CImean <- c(muU,muL)
    }
    out$Model <- mod$Model
  }
  return(out)
} 
