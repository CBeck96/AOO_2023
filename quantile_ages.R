# Quantile and median ages 

# Input:
# d : The ages of the sample 
# x : The probabilities from the cumulative incidence
# q : quantile value. If q = 0.5, quantile_age gives the same as median_age

# Output:
#   - Returns the median and quantile respectively.

# Computes the median age of onset from the cumulative incidence
median_age <- function(d,x){
  a <- d[x == sign(x - 0.5)*min(abs(x-0.5)) + 0.5,]
  aa <- a$time
  return(mean(aa))
}

# Computes the age of onset for a given quantile from the cumulative incidence
quantile_age <- function(d,x,q){
  a <- d[x == sign(x - q)*min(abs(x-q)) + q,]
  aa <- a$time
  return(mean(aa))
}