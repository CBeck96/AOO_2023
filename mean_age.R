# Mean by age integrating under survival curve 

# This is done so the integrale is more accurate, than using rectangles.

# Computes the mean age of onset by integrating the area below the curve G
# Generate pseudo survival function
# F(t) = int_0^t S(u)a(u)du
# G(t) = 1 - F(t)/F(A)
# where F(A) = max(F(t))

# x : Values of the first axis
# y : Values of the second axis

mean_age <- function(x,y){
  return(trapz(x,y))
}

# Packages used:
# pracma