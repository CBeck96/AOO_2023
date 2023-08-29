# Mean age of onset -------------------------------------------------------

# Generate pseudo survival function
# F(t) = int_0^t S(u)a(u)du
# G(t) = 1 - F(t)/F(A)
# where F(A) = max(F(t))

# df      : Data used. Can either be raw data or the output of the CIF-function.
# rawdat  : Indicates if the format of the data. Default is FALSE.   
# medians : Indicator for computing the median in the output. Default is TRUE.
# se      : Indicates if the function will have confidence intervals in 
#           its output. Is only useful if rawdat is TRUE.

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
  out_mean <- data.frame("Cause" = 1, 
                        "Mean 1" = aa)
  
  out <- list("Mean" = out_mean)
  # Computes the median if medians is equal TRUE.
  if(medians == TRUE){
    # Find median age, ie age at which half probability mass is below and above.
    am <- median_age(ndf,ndf$G1)$time
    a <- mean(am)
    out_median <- data.frame("Cause" = 1, 
                            "Median 1" = a)
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

# Packages used:
# prodlim
# pracma