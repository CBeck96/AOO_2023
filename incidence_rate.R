# Incidence rates calculations 

# Packages used:
# Epi
# popEpi

# Input:
# dat    : Data used. Must only contain one sex. dat is a data frame.
# knot   : Knots used for splines. Used when fitting the GLM. knot is a vector 
#          of numerical values.
# sp     : Probability in each interval for split. Used for the splitting of 
#          data. sp is a vector of numerical values between 0 and 1.  
# pv     : Values predictions are made on from the fitted GLM. 
#          pv is a vector of numerical values, 
#          which represents the ages at which predictions are made.
# method : Method used for split (Lexis, Multi). Default is Lexis. 

# Output:
#   - Returns a list containing:
#       1) Data frame of the predicted incidence rates and confidence interval:
#             - Time given in ages
#             - Incidence rates
#             - Lower bound of confidence interval
#             - Upper bound of confidence interval
#       2) Data frame of the number of counts and person years:
#             - Time given in ages (t)
#             - Incidence rates points at time t (D/Y)
#             - The count of cases at time t (D)
#             - The sum of person years at time t (Y)
#       3) Sex of the data.
#       4) A vector of the splits used in splitting of the Lexis data
#       5) Returns the vector pv given in the function
#       6) Method used for the splitting of the Lexis data

nIR <- function(dat, knot, sp, pv,  method = "Lexis"){
  # Transforms the data into lexis format.
  Ldat <- Lexis(entry = list(age = doinc - dobth, per = doinc),
                exit = list(per = doend),
                exit.status = factor(censor_stat, 
                                     labels = c("Well", "Event",
                                                "Emigration", "Dead")),
                data = dat)
  ### Method used for splitting:
  if(method == "Lexis"){
    b <- quantile(Ldat[Ldat[,9] == 1,1], (1:(sp-1))/sp) 
    sdat <- splitLexis(Ldat, "age", breaks = b)
  }
  if(method == "Multi"){
    b <- quantile(Ldat[Ldat[,9] == 1,1], (0:(sp))/sp) 
    sdat <- splitMulti(Ldat, age = b)
  }
  # Counts the number of events and person-years.
  xtab <- xtabs(cbind(D = (lex.Xst == "Event"),
                      Y = lex.dur) ~ floor(age),
               data = sdat)
  # Sets the minimum age of onset.
  minao <- floor(min(Ldat[,1]))
  # Creates a sequence of ages at which the model is fitted.
  A <- seq(minao, dim(xtab)[1] - 1 +  minao,1) 
  s_glm <- glm(xtab ~ Ns(A , knots = knot), 
               family = poisreg)
  # Creates a data frame of ages at which the predictions are made.
  new_dat <- data.frame(A = pv)
  # Predicts the incidence rate with confidence intervals.
  pglm_smo <- ci.pred(s_glm,new_dat)
  # Saves the results from the fitted model.  
  ir <- data.frame("time" = pv,
                   "Est" = pglm_smo[,1],
                   "lb" = pglm_smo[,2],
                   "ub" = pglm_smo[,3])
  # Saves the count of events and person-years
  irp <- data.frame("time" = A,
                    "irp" = xtab[,"D"]/xtab[,"Y"], 
                    "D" = xtab[,"D"], 
                    "Y" = xtab[,"Y"]) 
  # Adds the two previous data frames in a list for the output
  out <- list("Incidens rate" = ir,
              "IR points" = irp,
              "KQN" = sdat$KQN[1],
              "Split" = b,
              "Prediction values" = pv,
              "Method" = method)
  return(out)
}
