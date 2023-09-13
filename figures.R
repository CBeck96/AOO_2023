# Figures

# This is script shows how the figures and panel plots are made.

# Packages used:
# ggplot2
# gridExtra

# Creating a single plot --------------------------------------------------

# Setting the limits of the incidence rate and cumulative incidence across both 
# sexes. This done to create the second Y-axis. 
ylim_IR_DXX = c(0,maximum of IR)
ylim_CIF_Dxx = c(0,maximum of CIF))
# Note that there is not created a IR or CIF. It is written this way to indicate 
# the values to use is the maximum value seen from the incidence rates and 
# cumulative incidence. Remember to include the confidence bounds.

# Here we create the shift and scale for the second Y-axis.
b_DXX = diff(ylim_IR_DXX)/diff(ylim_CIF_DXX)
a_DXX = ylim_IR_DXX[2] - b_DXX*ylim_CIF_DXX[1]

# Here the we create the data frame of the values we wish to plot, with the 
# scaled values. In addition the values are scaled to get per 10 000 person-years
# and per 100 persons respectively.
DXX <- data.frame("time" = c(DXXF$CIF$time,
                             DXXM$CIF$time,
                             DXXF_IR$time,
                             DXXM_IR$time),
                  "Est" = c(DXXF$CIF$prob.1*100*b_DXX,
                            DXXM$CIF$prob.1*100*b_DXX,
                            DXXF_IR$Est*10000,
                            DXXM_IR$Est*10000),
                  "lower" = c(0,DXXF$lower$`1`*100*b_DXX,
                              0,DXXM$lower$`1`*100*b_DXX,
                              DXXF_IR$lb*10000,
                              DXXM_IR$lb*10000),
                  "upper" = c(0,DXXF$upper$`1`*100*b_DXX,
                              0,DXXM$upper$`1`*100*b_DXX,
                              DXXF_IR$ub*10000,
                              DXXM_IR$ub*10000),
                  "KQN" = c(rep("F",nrow(DXXK$CIF)),
                            rep("M",nrow(DXXM$CIF)),
                            rep("F",nrow(DXXK_IR)),
                            rep("M",nrow(DXXM_IR))),
                  "LT" = c(rep("CIR",nrow(DXXK$CIF) + nrow(DXXM$CIF)),
                           rep("IR",nrow(DXXK_IR) + nrow(DXXM_IR)))) 

# Here we create the figure with 'ggplot2'.
ggplot() + 
  geom_line(data = DXX, 
            aes(x = time, 
                y = Est,
                col = factor(KQN),
                linetype = factor(LT))) + 
  geom_ribbon(data = DXX,
              aes(x = time,
                  ymin = lower,
                  ymax = upper,
                  fill = factor(KQN),
                  linetype = factor(LT)),
              alpha = 0.3) +
  geom_point(aes(y = c(max(DXXF$CIF$prob.1*100*b_DXX),
                       max(DXXM$CIF$prob.1*100*b_DXX))/2,
                 x = c(DXXF$median[[2]],DXXM$median[[2]])),
             shape = 21,
             size = 2,
             col = c("red","blue"),
             fill = c("red","blue")) +
  labs(x = "Age",
       title = "DXX") +
  scale_color_manual("",
                     values = c("red","blue"),
                     label = c("Female","Male"),
                     aesthetics = c("fill","color")) +
  scale_linetype_manual("", 
                        values = 1:2,
                        label = c("Cumulative incidence",
                                  "Incidence rate")) + 
  scale_x_continuous(expand = expansion(c(0,0.02))) +
  # This is where we create the second Y-axis.
  scale_y_continuous(expand = expansion(c(0,0.02)),
                     "Incidence rate per 10000 Person-years",
                     sec.axis = sec_axis(~ (.)/b_DXX,
                                         "Cumulative incidence per 100 Persons")) +
  theme_bw() +
  theme(legend.position = "bottom",
        text = element_text(size = 15))


# Creating a panel plot ---------------------------------------------------

# For this section we use the package 'gridExtra'. We create a 2x2 panel plot. 
# We start by creating the figures to add in the panel. These are similar to the 
# figures above, but with minor changes, such that the panel will have common 
# labels and legends. 

figDXX <- ggplot() + 
  geom_line(data = DXX, 
            aes(x = time, 
                y = Est,
                col = factor(KQN),
                linetype = factor(LT))) + 
  geom_ribbon(data = DXX,
              aes(x = time,
                  ymin = lower,
                  ymax = upper,
                  fill = factor(KQN),
                  linetype = factor(LT)),
              alpha = 0.3) +
  geom_point(aes(y = c(max(DXXF$CIF$prob.1*100*b_DXX),
                       max(DXXM$CIF$prob.1*100*b_DXX))/2,
                 x = c(DXXF$median[[2]],DXXM$median[[2]])),
             shape = 21,
             size = 2,
             col = c("red","blue"),
             fill = c("red","blue")) +
  labs(x = " ",
       title = " ") +
  scale_color_manual("",
                     values = c("red","blue"),
                     label = c("Female","Male"),
                     aesthetics = c("fill","color")) +
  scale_linetype_manual("", 
                        values = 1:2,
                        label = c("Cumulative incidence",
                                  "Incidence rate")) + 
  scale_x_continuous(expand = expansion(c(0,0.02))) +
  # This is where we create the second Y-axis.
  scale_y_continuous(expand = expansion(c(0,0.02)),
                     "",
                     sec.axis = sec_axis(~ (.)/b_DXX)) +
  theme_bw() +
  theme(legend.position = "bottom")

# We defining the following function to get a common legend for all 
# of the individual plots. 

g_legend <- function(a_ggplot){
  tmp <- ggplot_gtable(ggplot_build(a_ggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

mylegend <- g_legend(figDXX)

# We the arrange the panel plot with the common legend. Note that we remove the 
# individual legend now, otherwise we can not create the common legend. 
grid.arrange(arrangeGrob(figDXX + guides(col = "none", 
                                         linetype = "none", 
                                         fill = "none"),
                         figDXX + guides(col = "none", 
                                         linetype = "none", 
                                         fill = "none"),
                         figDXX + guides(col = "none", 
                                         linetype = "none", 
                                         fill = "none"),
                         figDXX + guides(col = "none", 
                                         linetype = "none", 
                                         fill = "none"),
                         nrow = 2,
                         left = "Incidence rate per 10000 Person-years",
                         right = "Cumulative incidence per 100 Persons",
                         bottom = "Age"),
             mylegend,
             nrow = 2,
             heights = c(10,0.5))
