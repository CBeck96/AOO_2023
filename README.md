# Age of onset (AOO2023)
This is a github repository for the code used for the analysis conducted in the paper: "A comprehensie analysis of age of onset and cumulative incidence of mental disorders: a Danish register study" published in Acta Psychiatrica Scandinavica. [Paper](http://doi.org/10.1111/acps.13682)

## Functions

Below is the R-functions created to make the analysis for the paper. 

| R-function            | Calculates                                   |
| --------------------- | -------------------------------------------- |
| `CIF()`               | The cumulative incidence function            |
| `median_age()`        | The median age from the CIF                  |
| `quantile_age()`      | The quantile age from the CIF                |
| `mean_age()`          | The mean age from the CIF                    |
| `mean_age_of_onset()` | Combines the functions above to one function |
| `nIR()`               | The incidence rate                           |

### Libraries used

| Library       | Used in                                         |
| ------------- | ----------------------------------------------- |
| prodlim       | Computing CIF in mean_age_of_onset()            |
| Epi           | nIR()                                           |
| popEpi        | nIR()                                           |
| pracma        | mean_age() for calculating area below the curve |
| doParallel    | Run the code quicker                            |
| foreach       | Run the code quicker                            |
| ggplot2       | Creating plots                                  |
| gridExtra     | Creating panel plots                            |

At each of the R-scripts, the packages used in a function is listed. 

## Analysis

In the files `MAOO.R` and `IR_res.R` the above functions are run on the data. There is a parallel and unparallel version of the procedures. The code to create the plots and panel plots can be found in the file `figures.R`. The incidence rate and cumulative incidence got from the analysis can be found in the file `AOO_Results.csv`. It holds the predicted incidence rate and cumulative incidence for all diagnosis and both sexes. The confidence interval for both estimates are given, in addition it also contains the confidence interval for the predictions.  

## Description of input data 

The study looks at individuals who are alive and healthy in Denmark at the begining of 2004 or your 1'st, 5'th or 10'th birthday (Depending on the earliest age of onset of the diagnose) whatever comes later. The study ends at the end of 2021. After cleaning the data, there is a data-set for each diagnose of intrest and it has the following columns.

| Column number | Column name   | Description                                                                        |
| ------------- | ------------- | ---------------------------------------------------------------------------------- |
| 1             | PID	          |	Person ID                                                                          |
| 2	            | KQN	          |	Sex                                                                                |
| 3	            | fdato	        |	Date of birth                                                                      |
| 4	            | bornDK	      |	Indicates if person is born in DK                                                  |
| 5	            | start_date	  |	Date of entry in study                                                             |
| 6	            | end_date	    |	Date of exit of study                                                              |
| 7	            | censor_stat	  |	Censoring status at end of study (1: Healthy, 2: Diagnosed, 3: Emigrated, 4: Dead) |
| 8	            | Tstart	      |	Age at entry of study                                                              |
| 9	            | Tslut	        |	Age at exit of study                                                               |
| 10	          | dobth	        |	Date of birth as continuous variable                                               |
| 11	          | doinc	        |	Date of entry as continuous variable                                               |
| 12	          | doend	        | Date of exit as continuous variable                                                |

Example of dates as continuous variables:

| Date          | Continuous date  |
| ------------- | ---------------- |
| 01/01/2004    | 2004.000         |
| 18/03/2006    | 2006.208         |
| 07/07/2007    | 2007.511         |
| 30/11/2016    | 2016.913         |

### Availability of data and materials

Data for this study os property of Statistic Denmark and the Danish Health Data Authority. The data are available from the authorities, but restrictions apply.

## Data visualization

To see the interactive data vizualization website, click [here.](https://csievert.shinyapps.io/mental-aoo-danish/) The data uesd to make this vizualization can be found through the link or in the file `AOO_Results.csv`.

## Math

Lets define $A$ as the maximum age of the participants. In this paper we have set $A=80$. Further let $Ã$ denote the median age of onset. 
we wish to compute the mean age of onset for cause $i$ in a competing risk set-up. 
Note that the cumulative incidence function (CIF), in a competing risk set-up, is defined as the Aalen-Johansen estimator:
$$F_i (t) = \int^t_0 S(u) \alpha_i (u) du,$$
where $S(t)$ is the survival function and $\alpha_i (t)$ is the cause-specific hazard for cause $i$ at time $t$. 
Since we are only interested in the cause *Diagnosed*, we will suppress the $i$ in the future. 
The median can be found as $Â := \frac{F (A)}{2}$. The idea is then to transform the CIF to a probability; 
therefore, we divide the the CIF with $F(A)$, this is then subtracted from 1, s.t.
$$G(t) = 1 - \frac{F(t)}{F(A)} .$$
The mean age of onset can then be computed as 
$$\mu = \int^A_0 G(t) dt = \int^A_0 1 -  \frac{F(t)}{F(A)}  dt = A - \frac{1}{F(A)} \int^A_0 F(t) dt.$$
It can be seen as a restricted mean age of onset. 

![image](https://github.com/CBeck96/AOO2023/assets/43062260/9e70d6d5-71ee-4d21-9239-aec82975b0e5)
![image](https://github.com/CBeck96/AOO2023/assets/43062260/b60396c4-0586-4026-8e54-aeee9a9e2cef)

