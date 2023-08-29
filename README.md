# AOO2023
Code used in the results to the paper: "A comprehensie analysis of age of onset and cumulative incidence of mental disorders: a Danish register study". 

Abstract:

Methods:

Results:

Conclusion:

## Functions

`CIF()`   
`median_age()`   
`quantile_age()`   
`mean_age()`   
`mean_age_of_onset()`
`nIR()`   

`MAOO.R`   
`IR_res.R`   

Computes the CIF using the prodlim package  

Calculates the quantile age of onset from the CIF

Calculates the mean age of onset from the CIF

Computes the CIF, median, and mean age of onset

Computes the IR

### Analysis

## Libraries used

| Library       |  Description                                        |
| ------------- | --------------------------------------------------- |
| prodlim       | Used for computing CIF in mean_age_of_onset()       |
| Epi           | Used in nIR()                                       |
| popEpi        | Used in nIR()                                       |
| pracma        | Used in mean_age() for calculating area below curve |
| doParallel    | Used to run the code quicker                        |
| foreach       | Used to run the code quicker                        |


## Data description

The study looks at individuals who are alive and healthy, with no prior diangose, in Denmark at the begining of 2004 or your 1'st, 5'th or 10'th birthday (Depending on the earliest age of onset of the diagnose) whatever comes later. The study ends at the end of 2021, diagnose, emigration or death. The data is prepared such it has the following columns. 

| Column number | Column name   | Description                                                                        |
| ------------- | ------------- | ---------------------------------------------------------------------------------- |
| 1             | PID	          |	Person ID                                                                          |
| 2	            | KQN	          |	Sex                                                                                |
| 3	            | fdato	        |	Date of birth                                                                      |
| 4	            | bornDK	      |	Indicator for if person is born in DK                                              |
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
| 01/01/2004    | 2040.000         |
| 18/03/2006    | 2006.208         |
| 07/07/2007    | 2007.511         |
| 30/11/2016    | 2016.913         |

## Data visualization

Interactive data visualization website:
