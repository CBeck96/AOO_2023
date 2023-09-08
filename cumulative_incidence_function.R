# Cumulative incidence function 

# This function works in the set-up of competing risk, where the states are:
# Healthy, Diagnosed, death, and emigrated. The function also takes into account 
# late entry. 
# Tstart,Tslut, and censor_stat is desriped in the Data description. 

# Packages used:
# prodlim

# Input:
# dat    : Data used. Takes a data frame
# se     : Indicator to include confidence intervals. Default is False. 

# Output: 
# Gives a list of the following
#   1) CIR: A data frame containing 
#        - time given in ages
#        - Survival 
#        - Cumulative incidence for the state diagnosed
#        - Cumulative incidence for the state death
#        - Cumulative incidence for the state emigration
#   2) lower: Lower confidence limits (Structure as above, without time)
#   3) upper: Upper confidence limits (Structure as above, without time)
#   4) model: Model fitted on the data

CIF <- function(dat , se = FALSE){
  # Tstart and Tslut is the start and exit age respectively. Where censor_stat
  # is the status of exit.
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
