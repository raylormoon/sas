*/
Author: Tianjiao Xu(Raylor Xu)
Date: 02/18/2022
Purpose: Programming assignment 3
*/

*clears log and listing windows;
DM "log;clear";
DM "output;clear";

*changing working directory to L odrive to esablish libraries;
X " cd L:\st445";
libname results "results";
libname bookd "Data\BookData\ClinicalTrialCaseStudy";
filename rawdata "Data\BookData\ClinicalTrialCaseStudy";

*change working dirctory to where my output will go;
X "cd S:\desktop\hw3";
libname hw3 ".";
FILENAME hw3 ".";

*set options;
options fmtsearch = (hw3);
options nodate;
ods noproctitle;


*create format;
proc format library = hw3;
  value sbp(fuzz=0) low -< 130 = 'Acceptable'
                    130 - high = 'High';
  value dbp(fuzz=0) low -< 80 = 'Acceptable'
                    80 - high = 'High';
run;

*select destinations for output;
ods listing close;
ods pdf file = "HW3 Xu Clinical Trial Case Report.pdf";
ods rtf file = "HW3 Xu Clinical Trial Case Report.rtf" style=sapphire;
ods powerpoint file = "HW3 Xu Clinical Trial Case Report.ppt" style=PowerPointDark;

*read in data site 1;
data hw3.site1;
  attrib Subj label = 'Subject Number'
            sfReas      label = 'Screen Failure Reason' length=$50
            sfStatus    label = 'Screen Failure Status (0 = Failed)' length=$1
            BioSex      label = 'Biological Sex' length=$1
            VisitDate   label = 'Visit Date' length=$9
            failDate    label = 'Failure Notification Date' length=$9
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'Units (BP)' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position' length=$9
            temp        label = 'Temperature' format=5.1
            tempUnits   label = 'Units (Temp)' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Units (Weight)' length=$2
            pain        label = 'Pain Score';
     infile RawData("Site 1, Baseline Visit.txt") dsd dlm='09'x;
     input subj sfReas $ sfStatus $ BioSex $ VisitDate $ failDate $ 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temp 
        tempUnits $ weight weightUnits $ pain;
run;

*sort the data by descending;
proc sort data = HW3.Site1;
  by descending sfStatus sfReas descending visitdate descending faildate subj;
run;

*print the data to destination;
ods exclude Attributes EngineHost;
ods powerpoint exclude all;
title "Variable-level Attributes and Sort Information: Site 1";
proc contents data = HW3.Site1 varnum;
run;
title;

*read raw data 2;
data hw3.site2;
  attrib Subj label = 'Subject Number'
            sfReas      label = 'Screen Failure Reason' length=$50
            sfStatus    label = 'Screen Failure Status (0 = Failed)' length=$1
            BioSex      label = 'Biological Sex' length=$1
            VisitDate   label = 'Visit Date' length=$10
            failDate    label = 'Failure Notification Date' length=$10
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'Units (BP)' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position' length=$9
            temp        label = 'Temperature' format=3.1
            tempUnits   label = 'Units (Temp)' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Units (Weight)' length=$2
            pain        label = 'Pain Score';
     infile RawData("Site 2, Baseline Visit.csv") dsd;
     input subj sfReas $ sfStatus $ BioSex $ VisitDate $ failDate $ 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temp 
        tempUnits $ weight weightUnits $ pain;
run;

*sort the data by descending;
proc sort data = HW3.Site2;
  by descending sfStatus sfReas descending visitdate descending faildate subj;
run;

*print the data to destination;
ods exclude Attributes EngineHost;
ods powerpoint exclude all;
title "Variable-level Attributes and Sort Information: Site 2";
proc contents data = HW3.Site2 varnum;
run;
title;

*read raw data 3;
data HW3.site3;
  attrib Subj label = 'Subject Number'
            sfReas      label = 'Screen Failure Reason' length=$50
            sfStatus    label = 'Screen Failure Status (0 = Failed)' length=$1
            BioSex      label = 'Biological Sex' length=$1
            VisitDate   label = 'Visit Date' length=$10
            failDate    label = 'Failure Notification Date' length=$10
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'Units (BP)' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position' length=$9
            temp        label = 'Temperature' format=3.1
            tempUnits   label = 'Units (Temp)' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Units (Weight)' length=$2
            pain        label = 'Pain Score';
  infile RawData("Site 3, Baseline Visit.dat") dsd;
  input subj 1-3 sfReas $8-57 sfStatus $59 BioSex $62 VisitDate $63-72 
        failDate $73-82 sbp 83-85 dbp 86-88 bpUnits $89-93 pulse 95-97 
        pulseUnits $98-106 position $108-116 temp 121-123 tempUnits $124 
        weight 125-127 weightUnits $128-129 pain 132;
  list;
run;

*sort the data by descending;
proc sort data = HW3.Site3;
  by descending sfStatus sfReas descending visitdate descending faildate subj;
run;

title "Variable-level Attributes and Sort Information: Site 3";
*print the data to destination;
ods exclude Attributes EngineHost;
ods powerpoint exclude all;
proc contents data = HW3.Site3 varnum;
run;
title;

*Compare my dataset1 with dr.Opperman's;
proc compare base = results.hw3oppermansite1 compare = HW3.Site1 out = HW3.Diff1 
             outbase outcompare outdiff outnoequal noprint
             method = absolute criterion = 1E-10;;
run;

*Compare my dataset 2 with dr.Opperman's;
proc compare base =results.hw3oppermansite2 compare = HW3.Site2 out = HW3.Diff2
             outbase outcompare outdiff outnoequal noprint
             method = absolute criterion = 1E-10;;
run;

*Compare my dataset 3 with dr.Opperman's;
proc compare base =results.hw3oppermansite3 compare = HW3.Site3 out = HW3.Diff3
             outbase outcompare outdiff outnoequal noprint
             method = absolute criterion = 1E-10;;
run;

*create means tables;
ods powerpoint exclude none;
title "Selected Summary Statistics on Baseline Measurements";
title2 "for Patients from Site 1";
footnote j=left h=8pt "Statistic and SAS keyword: Sample size (n), Mean (mean), Standard Deviation (stddev), Median (median), IQR (qrange)";
proc means data=HW3.Site1 nonobs n mean stddev median qrange maxdec=1;
  class pain;
  var weight temp pulse dbp sbp;
run;
title;
footnote;

*create frequency tables;
ods pdf columns=2;
title "Frequency Analysis of Baseline Positions and Pain Measurements by Blood Pressure Status";
title2 "for Patients from Site 2";
footnote j=left h=13pt "Hypertension (high blood pressure) begins when systolic reaches 130 or diastolic reaches 80";
proc freq data=HW3.Site2;
  table position pain*dbp*sbp / norow nocol;
  format dbp dbp. sbp sbp.;
run;
title;
footnote;

*place listing;
ods powerpoint exclude all;
ods pdf columns=1;
title "Selected Listing of Patients with a Screen Failure and Hypertension";
title2 "for patients from Site 3";
footnote j=left h=13pt "Hypertension (high blood pressure) begins when systolic reaches 130 or diastolic reaches 80";
footnote2 j=left h=13pt "Only patients with a screen failure are included.";
proc print data = HW3.Site3(where=((sfstatus='0') and (dbp>80))) label;
  id subj pain;
  var visitDate sfstatus sfReas failDate biosex sbp dbp bpunits weight weightunits;
run;
title;
footnote;

ods rtf close;
ods pdf close;
ods powerpoint close;

quit;
