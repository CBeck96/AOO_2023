# Quantile ages 

# d : The ages of the sample
# x : The probabilities from the cumulative incidence
# q : qunatile value. If q = 0.5, quantile_age gives the same as median_age

# Computes the median age of onset from the cumulative incidence
median_age <- function(d,x){
  a <- d[x == sign(x - 0.5)*min(abs(x-0.5)) + 0.5,]
  return(a)
}

# Computes the age of onset for a given quantile from the cumulative incidence
quantile_age <- function(d,x,q){
  a <- d[x == sign(x - q)*min(abs(x-q)) + q,]
  return(a)
}