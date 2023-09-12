# Mean by age integrating under survival curve 

# This integral is computed using trapezes, instead of rectangles. 
# Computes the mean age of onset by integrating the area below the curve G
# Generate pseudo survival function:
# F(t) = int_0^t S(u)a(u)du
# G(t) = 1 - F(t)/F(A)
# where F(A) = max(F(t))

# Packages used:
# pracma

# Input:
# x : Values of the first axis
# y : Values of the second axis

# Output:
#   - Returns the area under the curve by using trapeze  

mean_age <- function(x,y){
  return(trapz(x,y))
}

