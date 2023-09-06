# IR calculations 

# dat    : Data used
# knot   : Knots used for splines
# sp     : Probability in each interval for split
# pv     : Values predictions are made on
# method : Method used for split (Lexis, Multi)

nIR <- function(dat, knot, sp, pv,  method = "Lexis"){
  # Transform the data into lexis format.
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
  # Adds the two previous data frames to the output
  out <- list("Incidens rate" = ir,
              "IR points" = irp,
              "KQN" = sdat$KQN[1],
              "Split" = b,
              "Prediction values" = pv,
              "Method" = method)
  return(out)
}

# Packages used:
# Epi
# popEpi
