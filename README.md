# AOO2023
Theis is a github repository for the code used for the analysis conducted in the paper: "A comprehensie analysis of age of onset and cumulative incidence of mental disorders: a Danish register study". 

Short about the paper: Abstract? Methods? Results? Conclusion?

## Functions

| R-function            | Calculates                                   |
| --------------------- | -------------------------------------------- |
| `CIF()`               | The cumulative incidence function            |
| `median_age()`        | The median age from the CIF                  |
| `quantile_age()`      | The quantile age from the CIF                |
| `mean_age()`          | The mean age from the CIF                    |
| `mean_age_of_onset()` | Combines the functions above to one function |
| `nIR()`               | The incidence rate                           |

### Analysis

In the files `MAOO.R` and `IR_res.R` the above functions are run on the data. There is a parallel and unparallel version of the procedures. 

### Libraries used

| Library       |  Used in                                    |
| ------------- | ------------------------------------------- |
| prodlim       | Computing CIF in mean_age_of_onset()        |
| Epi           | nIR()                                       |
| popEpi        | nIR()                                       |
| pracma        | mean_age() for calculating area below curve |
| doParallel    | Run the code quicker                        |
| foreach       | Run the code quicker                        |

At each of the R-scripts, the packages used in a function is listed. 

## Data description

The study looks at individuals who are alive and healthy, with no prior diangose, in Denmark at the begining of 2004 or your 1'st, 5'th or 10'th birthday (Depending on the earliest age of onset of the diagnose) whatever comes later. The study ends at the end of 2021. After cleaning the data, there is a data-set for each diagnose of intrest and it has the following columns.

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

## Data visualization

To see the interactive data vizualization website, click [here.](https://csievert.shinyapps.io/mental-aoo-danish/)

## Math

Lets define $A$ as the maximum age of the participants. In this paper we have set $A=80$. Further let $Ã$ denote the median age of onset. 
When computing the mean age of onset for cause $i$ in a competing risk set-up. 
Note that the cumulative incidence function (CIF), in a competing risk set-up, is defined as the Aalen-Johansen estimator:
$$F_i (t) = \int^t_0 S(u) \alpha_i (u) du,$$
where $S(t)$ is the survival function and $\alpha_i (t)$ is the cause-specific hazard got cause $i$ at time $t$. 
Since we are only intrested in the cause *Diagnosed*, we will subpress the $i$ in the future. 
The median can be found as $Â := \frac{F (A)}{2}$. The idea is the to transfer the CIF to a probability; 
therefore, we divide the the CIF with $F(A)$, this is then subtracted from 1, s.t.
$$G(t) = 1 - \frac{F(t)}{F(A)} .$$
The mean age of onset can then be computed as 
$$\mu = \int^A_0 G(t) dt = \int^A_0 1 -  \frac{F(t)}{F(A)}  dt = A - \frac{1}{F(A)} \int^A_0 F(t) dt.$$
It can be seen as a restricted mean age of onset. 

![image](https://github.com/CBeck96/AOO2023/assets/43062260/9e70d6d5-71ee-4d21-9239-aec82975b0e5)
![image](https://github.com/CBeck96/AOO2023/assets/43062260/b60396c4-0586-4026-8e54-aeee9a9e2cef)

