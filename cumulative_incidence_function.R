# Cumulative incidence function 

# dat    : Data used
# se     : Indicator to include confidence intervals. Default is False.

# This function works in the set-up of competing risk, where the states are:
# Healthy, Diagnosed, dead, and emigrated.

CIF <- function(dat , se = FALSE){
  CIP <- prodlim(Hist(entry = Tstart , time = Tslut , censor_stat) ~ 1 , 
                 data = dat)
  CIP_df <- data.frame("time" = CIP$time ,
                       "surv" = CIP$surv,
                       "prob.1" = CIP$cuminc$`1`,
                       "prob.2" = CIP$cuminc$`2`,
                       "prob.3" = CIP$cuminc$`3`) 
  # Sets the respective values at age 0  
  CIP_df <- rbind(data.frame("time" = 0 ,
                             "surv" = 1,
                             "prob.1" = 0,
                             "prob.2" = 0,
                             "prob.3" = 0), CIP_df)
  out <- list("CIR" = CIP_df)
  if(se == TRUE){
    out$lower = CIP$lower
    out$upper = CIP$upper
    out$Model = CIP
  }
  return(out)
}

# Packages used:
# prodlim