/*
Author: Tianjiao Xu(Raylor Xu)
Date: 02/09/2022
Purpose: Programming assignment 2
*/

*clears log and listing windows;
DM "log;clear";
DM "output;clear";

*changing working directory to L odrive to esablish libraries;
X " cd L:\st445";
libname InputDS "Data";
filename rawdata "Data";

*change working dirctory to where my output will go;
X "cd S:\desktop\hw2";
libname hw2 ".";
FILENAME hw2 ".";

*Read in raw data;
data hw2.baseball;
  *create label and length;
  attrib FName  label = 'First Name' length = $ 9
         LName  label = 'Last Name' length = $ 11
         Team   label = 'Team at the end of 1986' length = $ 13
         nAtBat label = '# of At Bats in 1986'
         nHits  label = '# of Hits in 1986' 
         nHome  label = '# of Home Runs in 1986'
         nRuns  label = '# of Runs in 1986' 
         nRBI   label = '# of RBIs in 1986' 
         nBB    label = '# of Walks in 1986' 
         YrMajor   label = '# of Years in the Major Leagues' 
         CrAtBat   label = '# of At Bats in Career'
         CrHits    label = '# of Hits in Career' 
         CrHome    label = '# of Home Runs in Career'
         CrRuns    label = '# of Runs in Career' 
         CrRbi     label = '# of RBIs in Career' 
         CrBB      label = '# of Walks in Career'            
         League    label = 'League at the end of 1986' length = $ 8
         Division  label = 'Division at the end of 1986' length = $ 4
         Position  label = 'Position(s) Played' length = $ 2
         nOuts     label = '# of Put Outs in 1986'           
         nAssts    label = '# of Assists in 1986'           
         nError    label = '# of Errors in 1986'           
         Salary    label = 'Salary (Thousands of Dollars)'   format = dollar10.3 
  ;
  infile rawdata("Baseball.dat") dlm = '092C'x firstobs = 13;
  
  input LName $ FName $ team $ nAtBat 50-53 nHits 54-57 nHome 58-61 nRuns 62-65   
    nRBI 66-69 nBB 70-73 YrMajor 74-77 CrAtBat 78-82 CrHits 83-86 CrHome 87-90
        CrRuns 91-94 CrRbi 95-98 CrBB 99-102 League $ Division $ Position $ 
        nOuts 133-136 nAssts 137-140 nError 141-144 Salary 145-152
  ;
run;

*select destinations for output;
ods listing close;
ods noproctitle;
ods rtf file = "HW2 Xu Baseball Report.rtf" style=festival;
ods pdf file = "HW2 Xu Baseball Report.pdf" style=meadow;
option nodate;

*delete attributes and engine;
ods exclude Attributes EngineHost;
ods pdf exclude all;
*print raw data;
title 'Variable-Level Descriptor Information';
proc contents data = hw2.baseball varnum;
run;
title;

*set the format that already in inputds library;
options fmtsearch = (InputDS);
title 'Salary Format Details';
proc format library=InputDS fmtlib;
 select salary; *salary is the given format;
run;
title;

*create the data that show different mean; 
ods pdf exclude none; 

*create title for means tables;
title 'Summaries of Selected Batting Statistics';
title2 height=8pt 'Grouped by League (1986), Division (1986), and Salary (1987)';
proc means data=hw2.baseball min p25 p50 p75 max maxdec=3 nolabels;
  class league division salary/missing;
  var nhome nhits nruns nrbi nbb;
*create label and format;
  attrib league label='League at the end of 1986'
     division label='Division at the end of 1986'
     Salary label='Salary (Thousands of Dollars)' format=salary.;
run;
title;

*Create title for frequency tables;
title 'Breakdown of Players by Position and Position by Salary';

*create the table of frequency;
proc freq data=hw2.baseball;
  table position/missing;
  table position*salary/missing;
  format salary salary.;
run;
title;

*sort for printing;
proc sort data=hw2.baseball
  out=baseball;
  by league division team desending salary;
run;

*create listing;
title 'Listing of Selected Players';
footnote j=left height=8pt 'Included: Players with Salaries of at least $1,000,000 or who played for the Chicago Cubs';
proc print data= baseball (where =(salary ge 1000 or (team = 'Chicago' and league = 'National')))label;
  id lname fname position;
  var league division team salary nhits nhome nruns nrbi nbb;
  sum salary nhits nhome nruns nrbi nbb;         
  format Salary dollar12.3 nhits nhome nruns nrbi nbb comma6.
  ;
run;
title;
footnote;


ods rtf close;
ods pdf close;
ods listing;
