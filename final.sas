*/
Author: Tianjiao Xu(Raylor Xu)
Date: 04/15/2022
Purpose: Fianl project
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
X "cd S:\desktop\final";
libname final ".";
FILENAME final ".";

*set options;
options nodate;
ods noproctitle;
options fmtsearch = (final);
*Create format;
proc format library = final;
   value screen(fuzz=0) 0 = 'fail'
                        1 = 'pass';
   value sbp(fuzz=0) low - 120 = 'Acceptable (120 or below)'
                    120 <- high = 'High';
   value $ sex(fuzz=0) 'F' = 'Female'
                     'M' = 'Male';
   value dov(fuzz = 0)   '1Jan2018'd - '31Jan2018'd = "Jan2018"
                         '1Feb2018'd - '28Feb2018'd = "Feb2018"
                         '1Mar2018'd - '31Mar2018'd = "Mar2018"
                         '1Apr2018'd - '30Apr2018'd = "Apr2018";
   value name (fuzz=0)
              1="Systolic BP"
              2="Diastolic BP"
              3="Pulse"
              4="Temperature"
              5="Weight";
run; 

*select destinations for output;
ods _all_ close;
ods pdf file = "Final Xu Clinical Trial Case Report.pdf" dpi = 300 style=Meadow;
ods rtf file = "Final Xu Clinical Trial Case Report.rtf" style=sapphire;
ods powerpoint file = "Final Xu Clinical Trial Case Report.ppt"  style=PowerPointDark;

*read in data vist 3;
data final.visit3;
  attrib    Subject label = ''
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' 
            Sex       label = '' length=$1
            dov       label = 'Visit Date' 
            notif_date  label = 'Notification Date'
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'BP Units' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length= $ 9
            position    label = 'Position (Pos)' length=$9
            temperature label = 'Temperature' format=5.1
            tempUnits   label = 'Temperature Units' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Weight Units' length=$2
            pain        label = ''
            start_trt   label = 'Starting Treatment' length=$3
;
     infile RawData("Site 1, 3 Month Visit.txt") dsd dlm='09'x truncover;
     input subject sf_Reason $ screen Sex $ dov : date9.  notif_date : date9. 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temperature 
        tempUnits $ weight weightUnits $ pain start_trt $;
run;

*read in data vist 6;
data final.visit6;
  attrib    Subject label = ''
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass'
            Sex       label = '' length=$1
            dov       label = 'Visit Date' 
            notif_date  label = 'Notification Date'
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'BP Units' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position (Pos)' length=$9
            temperature label = 'Temperature' format=5.1
            tempUnits   label = 'Temperature Units' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Weight Units' length=$2
            pain        label = ''
            start_trt   label = 'Starting Treatment' length=$3
;
     infile RawData("Site 1, 6 Month Visit.txt") dsd dlm='09'x truncover;
     input subject sf_Reason $ screen Sex $ dov : date9.  notif_date : date9. 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temperature 
        tempUnits $ weight weightUnits $ pain start_trt $;
run;

*read in data vist 9;
data final.visit9;
  attrib    Subject label = ''
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass'
            Sex       label = '' length=$1
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'BP Units' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position (Pos)' length=$9
            temperature label = 'Temperature' format=5.1
            tempUnits   label = 'Temperature Units' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Weight Units' length=$2
            pain        label = ''
            start_trt   label = 'Starting Treatment' length=$3
;
     infile RawData("Site 1, 9 Month Visit.txt") dsd dlm='09'x truncover;
     input subject sf_Reason $ screen Sex $ dov : date9.  notif_date : date9. 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temperature 
        tempUnits $ weight weightUnits $ pain start_trt $;
run;

*read in data vist 12;
data final.visit12;
  attrib    Subject label = ''
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass'
            Sex       label = '' length=$1
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'BP Units' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position (Pos)' length=$9
            temperature label = 'Temperature' format=5.1
            tempUnits   label = 'Temperature Units' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Weight Units' length=$2
            pain        label = ''
            start_trt   label = 'Starting Treatment' length=$3
;
     infile RawData("Site 1, 12 Month Visit.txt") dsd dlm='09'x truncover;
     input subject sf_Reason $ screen Sex $ dov : date9.  notif_date : date9. 
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temperature 
        tempUnits $ weight weightUnits $ pain start_trt $; 
run;

*read in data vist baseline;
data final.visit1;
  attrib    Subject label = ''
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass'
            Sex       label = '' length=$1
            dov       label = 'Visit Date' 
            notif_date  label = 'Notification Date'
            sbp         label = 'Systolic Blood Pressure'
            dbp         label = 'Diastolic Blood Pressure'
            bpUnits     label = 'BP Units' length=$5
            pulse       label = 'Pulse'
            pulseUnits  label = 'Units (Pulse)' length=$9
            position    label = 'Position (Pos)' length=$9
            temperature label = 'Temperature' format=5.1
            tempUnits   label = 'Temperature Units' length=$1
            weight      label = 'Weight'
            weightUnits label = 'Weight Units' length=$2
            pain        label = '';
     infile RawData("Site 1, Baseline Visit.txt") dsd dlm='09'x;
     input subject sf_Reason $ screen Sex $ dov : date9.  notif_date : date9.
        sbp dbp bpUnits $ pulse pulseUnits $ position $ temperature 
        tempUnits $ weight weightUnits $ pain;
run;

*read in data lab 3;
data final.lab3;
  attrib    Subject label = ''
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' length=$1
            Sex       label = '' length=$1
            ALB       label = 'Chem-Albumin, g/dL'
            Alk_Phos  label = 'Chem-Alk. Phos., IU/L'
            ALT       label = 'Chem-Alt, IU/L'
            AST       label = 'Chem-AST, IU/L'
            D_Bili    label = 'Chem-Dir. Bilirubin, mg/dL'
            GGTP      label = 'Chem-GGTP, IU/L'
            c_gluc    label = 'Chem-Glucose, mg/dL'
            U_Glue    label = 'Uri.-Glucose, 1label =high'
            T_Bili    label = 'Chem-Tot. Bilirubin, mg/dL'
            Prot      label = 'Chem-Tot. Prot., g/dL'
            Hemoglob  label = 'Hemoglobin, g/dL'
            Hematocr  label = 'EVF/PCV, %'
            Preg      label = 'Pregnancy Flag, 1=Pregnant, 0=Not'
  ;
           
     infile RawData("Site 1, 3 Month Lab Results.txt") dsd dlm='09'x truncover;
     input subject dov : date9.  notif_date : date9. SF_Reason: $ Screen $ Sex $ ALB  Alk_Phos
           ALt AST D_Bili GGTP C_Gluc U_Glue T_Bili Prot Hemoglob Hematocr Preg;
run;

*read in data lab 6;
data final.lab6;
  attrib    Subject label = ''
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' length=$1
            Sex       label = '' length=$1
            ALB       label = 'Chem-Albumin, g/dL'
            Alk_Phos  label = 'Chem-Alk. Phos., IU/L'
            ALT       label = 'Chem-Alt, IU/L'
            AST       label = 'Chem-AST, IU/L'
            D_Bili    label = 'Chem-Dir. Bilirubin, mg/dL'
            GGTP      label = 'Chem-GGTP, IU/L'
            c_gluc    label = 'Chem-Glucose, mg/dL'
            U_Glue    label = 'Uri.-Glucose, 1label =high'
            T_Bili    label = 'Chem-Tot. Bilirubin, mg/dL'
            Prot      label = 'Chem-Tot. Prot., g/dL'
            Hemoglob  label = 'Hemoglobin, g/dL'
            Hematocr  label = 'EVF/PCV, %'
            Preg      label = 'Pregnancy Flag, 1=Pregnant, 0=Not'
  ;
           
     infile RawData("Site 1, 6 Month Lab Results.txt") dsd dlm='09'x truncover;
     input subject dov : date9.  notif_date : date9. SF_Reason: $ Screen $ Sex $ ALB  Alk_Phos
           ALt AST D_Bili GGTP C_Gluc U_Glue T_Bili Prot Hemoglob Hematocr Preg;
run;
*read in data lab 9;
data final.lab9;
  attrib    Subject label = ''
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' length=$1
            Sex       label = '' length=$1
            ALB       label = 'Chem-Albumin, g/dL'
            Alk_Phos  label = 'Chem-Alk. Phos., IU/L'
            ALT       label = 'Chem-Alt, IU/L'
            AST       label = 'Chem-AST, IU/L'
            D_Bili    label = 'Chem-Dir. Bilirubin, mg/dL'
            GGTP      label = 'Chem-GGTP, IU/L'
            c_gluc    label = 'Chem-Glucose, mg/dL'
            U_Glue    label = 'Uri.-Glucose, 1label =high'
            T_Bili    label = 'Chem-Tot. Bilirubin, mg/dL'
            Prot      label = 'Chem-Tot. Prot., g/dL'
            Hemoglob  label = 'Hemoglobin, g/dL'
            Hematocr  label = 'EVF/PCV, %'
            Preg      label = 'Pregnancy Flag, 1=Pregnant, 0=Not'
  ;
           
     infile RawData("Site 1, 9 Month Lab Results.txt") dsd dlm='09'x truncover;
     input subject dov : date9.  notif_date : date9. SF_Reason: $ Screen $ Sex $ ALB  Alk_Phos
           ALt AST D_Bili GGTP C_Gluc U_Glue T_Bili Prot Hemoglob Hematocr Preg;
run;

*read in data lab 12;
data final.lab12;
  attrib    Subject label = ''
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' length=$1
            Sex       label = '' length=$1
            ALB       label = 'Chem-Albumin, g/dL'
            Alk_Phos  label = 'Chem-Alk. Phos., IU/L'
            ALT       label = 'Chem-Alt, IU/L'
            AST       label = 'Chem-AST, IU/L'
            D_Bili    label = 'Chem-Dir. Bilirubin, mg/dL'
            GGTP      label = 'Chem-GGTP, IU/L'
            c_gluc    label = 'Chem-Glucose, mg/dL'
            U_Glue    label = 'Uri.-Glucose, 1label =high'
            T_Bili    label = 'Chem-Tot. Bilirubin, mg/dL'
            Prot      label = 'Chem-Tot. Prot., g/dL'
            Hemoglob  label = 'Hemoglobin, g/dL'
            Hematocr  label = 'EVF/PCV, %'
            Preg      label = 'Pregnancy Flag, 1=Pregnant, 0=Not'
  ;
           
     infile RawData("Site 1, 12 Month Lab Results.txt") dsd dlm='09'x truncover;
     input subject dov : date9.  notif_date : date9. SF_Reason: $ Screen $ Sex $ ALB  Alk_Phos
           ALt AST D_Bili GGTP C_Gluc U_Glue T_Bili Prot Hemoglob Hematocr Preg;
run;

*read in data baseline lab;
data final.lab1;
  attrib    Subject label = ''
            dov       label = 'Visit Date'
            notif_date  label = 'Notification Date'
            sf_reason label = 'Screen Failure Reason' length=$50
            screen    label = 'Screening Flag, 0=Failure, 1=Pass' length=$1
            Sex       label = '' length=$1
            ALB       label = 'Chem-Albumin, g/dL'
            Alk_Phos  label = 'Chem-Alk. Phos., IU/L'
            ALT       label = 'Chem-Alt, IU/L'
            AST       label = 'Chem-AST, IU/L'
            D_Bili    label = 'Chem-Dir. Bilirubin, mg/dL'
            GGTP      label = 'Chem-GGTP, IU/L'
            c_gluc    label = 'Chem-Glucose, mg/dL'
            U_Glue    label = 'Uri.-Glucose, 1label =high'
            T_Bili    label = 'Chem-Tot. Bilirubin, mg/dL'
            Prot      label = 'Chem-Tot. Prot., g/dL'
            hemoglob  label = 'Hemoglobin, g/dL'
            Hematocr  label = 'EVF/PCV, %'
            Preg      label = 'Pregnancy Flag, 1=Pregnant, 0=Not'
  ;
           
     infile RawData("Site 1, Baseline Lab Results.txt") dsd dlm='09'x truncover;
     input subject dov : date9.  notif_date : date9. SF_Reason: $ Screen $ Sex $ ALB  Alk_Phos
           ALt AST D_Bili GGTP C_Gluc U_Glue T_Bili Prot hemoglob Hematocr Preg;
run;

*create frequency table of baseline visit 8.2.3;
title "Sex Versus Pain Level Split on Screen Failure Versus Pass, Site 1 Baseline";
proc freq data=final.visit1;
      table screen*sex*pain/nocol;
      format Sex $sex. screen screen.;
run;
title;

*create frequency table of 8.2.4;
title "Sex Versus Screen Failure at Baseline Visit in Site 1";
proc freq data=final.visit1(where = (Screen eq 0));
  tables Sex*sf_reason/nocol nopercent;
  format Sex $sex.;
run;
title;

*create MEANS table of 8.2.5;
title "Diastolic Blood Pressure and Pulse Summary Statistics at Baseline Visit in Site 1";
proc means data = final.visit1 nolabels maxdec = 1 n mean std min max;
  class sex sbp;
  var dbp pulse;
  format sex $sex. sbp sbp.;
run;
title;

*create MEANS table of 8.2.6;
title "Glucose and Hemoglobin Summary Statistics from Baseline Lab Results, Site 1";
proc means data = final.lab1 nolabels maxdec = 1 min q1 median q3 max;
  class sex;
  format sex $sex.;
  var c_gluc hemoglob;
run;
title;

*create sgplot of 8.3.2;
ods graphics on / width = 6in outputfmt=png imagename = 'finalgraph1';
title "Recruits that Pass Initial Screening, by Month in Site 1";
proc sgplot data = final.visit1;
  vbar dov/group = sex groupdisplay = cluster;
  keylegend/location = inside position = topleft title = '';
  xaxis label = 'Month';
  yaxis label = 'Passed Screening at Baseline Visit';
  format dov dov.;
  where screen eq 1;
run;
title;

*create sgplot of 8.3.3;
ods graphics on / width = 6in outputfmt=png imagename = 'finalgraph2';
title "Average Albumin Results Baseline Lab, Site 1";
proc sgplot data = final.lab1;
  hbar sex /response = alb stat = mean limits=upper limitattrs=(color=black);
  attrib alb label='Chem-Albumin, g/dL, 95% Confidence Limits';
  xaxis label='Chem-Albumin, g/dL';
  yaxis display=(nolabel);
  keylegend/location = outside position = bottom;
run;
title;

*combine the visit datasets;
data final.visits;
  attrib dov format = mmddyy10.
         notif_date format = mmddyy10.;
  set final.visit1(in = inone)
      final.visit3(in = inthree)
      final.visit6(in = insix)
      final.visit9(in = innine)
      final.visit12(in = intwelve);
      if position in ('RECUMBANT' , 'RECLINED') then position = 'RECUMBENT';
      else if position = "SITTING" then position = "SEATED";
      if tempUnits = "C" then do;
          temperature=(1.8*temperature)+32;
          tempUnits="F";
      end;
      if weightUnits ="kg" then do;
          weight=2.20462*weight;
          weightUnits="lb";
      end;
      if inone = 1 then do;
            Visit = "Baseline Visit";
            VisitNum='0';
            VisitMonth="Baseline";
            end;
            if inthree = 1 then do;
               Visit = '3 Month Visit';
               VisitNum='1';
               VisitMonth='3 Month';
               end;
               if insix = 1 then do;
                  Visit = '6 Month Visit';
                  VisitNum='2';
                  VisitMonth='6 Month';
                  end;
                  if innine = 1 then do;
                     Visit = '9 Month Visit';
                     VisitNum='3';
                     VisitMonth='9 Month';
                     end;
                     if intwelve = 1 then do;
                       Visit = '12 Month Visit';
                       VisitNum='4';
                       VisitMonth='12 Month';
                       end;

run;

*combine the lab datasets;
data final.labs;
  attrib dov format = mmddyy10.
         notif_date format = mmddyy10.;
  set Final.lab1(in = inbaselinelab)
      Final.lab3(in = inthreelab)
      Final.lab6(in = insixlab)
      Final.lab9(in = inninelab)
      Final.lab12(in = intwelvelab);
  if inbaselinelab = 1 then lab = "Baseline";
    else if inthreelab = 1 then lab = "3 Month";
    else if insixlab = 1 then lab = "6 Month";
    else if inninelab = 1 then lab = "9 Month";
    else if intwelvelab = 1 then lab = "12 Month";
run;

*create Glucose Distributions by sgpanl of 8.4.3;
ods graphics on / width = 6in imagename = 'Finalgraph3';
title "Glucose Distributions, Baseline and 3 Month Visits, Site 1";
proc sgpanel data = Final.labs;
  panelby lab/novarname sort = descending; 
  where lab in ("Baseline","3 Month");
  histogram C_Gluc/scale = percent;
run;
title;

*create the summary statistics for 8.4.4;
ods pdf exclude all;
ods rtf exclude all;
ods PowerPoint exclude all;
ods output summary = stats;
proc means data = final.visits q1 q3;
  var sbp;
  class VisitMonth;
run;

*use proc sgplot for output 8.4.4;
title "Systolic Blood Pressure Quartiles, Site 1";
ods pdf exclude none;
ods rtf exclude none;
ods PowerPoint exclude none;
proc sgplot data = stats noautolegend;
  styleattrs datacolors=(CX3399FF);
  vbar VisitMonth/response = sbp_q1 barwidth = 0.3;
  vbar VisitMonth/response = sbp_q3 barwidth = 0.3;
  yaxis label = "Systolic BP--Q1 to Q3 Span"
        values = (105 to 140 by 5); 
  xaxis label="Visit" values=("Baseline" "3 Month" "6 Month" "9 Month" "12 Month");
run;


*reshape the final.visit for 8.6.2;
data final.visitsarray;
  set final.visits;
  array value_[5] sbp dbp pulse temperature weight;
  array units_[5] bpunits bpunits pulseUnits tempUnits weightUnits;
  do name = 1 to dim(value_);
    value = value_[name];
    units = units_[name];
    output;
  end;
  format name name.;
  keep subject visit name value units dov;
run;

*print the report after array 0f 8.6.1;
title "Rotated Data from Baseline Visit, Site 1 (Partial Listing)";
proc print data = Final.visitsarray(obs=10) label;
  attrib dov label="Date of Visit" format = mmddyy10.1
         value format = 5.1;
  ;
  var Subject DOV name value units;
         ;
run;
title;

*report for the 8.6.2;
title 'Summary Report on Selected Vital Signs, All Visits, Site 1';
proc report data = final.visitsarray out = report ;
  where name ne 5;
  columns Visit name units value,(mean median std min max);
  define Visit/group order = data style=[cellwidth=0.72in];
  define name/group 'Measurement' style=[just=left];
  define Units/group 'Units';
  define value/analysis '';
  define mean/'Mean' format=4.1;
  define median/'Median' format=4.1;
  define std/'Std.Deviation' format = 5.2 style=[cellwidth=0.65in];
  define min/'Minimum' format=4.1;
  define max/'Maximum' format = 5.1;
run;
title;

*report for the 8.6.3;
title 'BP Summaries, All Visits, Site 1';
proc report data = final.visitsarray;
  where name eq 2 or name eq 1;
  columns visit name,value,(mean median std);
  define visit/group order = data;
  define name/across 'Measurement';
  define value/'';
  define mean/'Mean' format=5.1;
  define median/'Median' format=5.1;
  define std/'Std.Dev' format = 5.2 style=[cellwidth=0.5in];
run;
title;


*report for the 8.7.3;
title 'Summary Report on Selected Vital Signs, All Visits, Site 1 Enhanced';
proc report data = final.visitsarray
  style(header)=[color=black backgroundcolor = grayF0];
  where name ne 5;
  columns Visit name units value,(mean median std min max);
  define Visit/group order = data style(column)=[color=black fontweight=bold];
  define name/group 'Test' style=[just=left];
  define Units/group 'Units';
  define value/analysis '';
  define mean/'Mean' format=5.1;
  define median/'Median' format=5.1;
  define std/'Std.Dev.' format = 5.2 style=[cellwidth=0.5in];
  define min/'Min.' format=4.1;
  define max/'Max.' format = 5.1;
  compute after visit / style=[backgroundcolor = black];
  line '';
  endcomp;
  compute name;
    if name eq 1 then do;
    call define (_row_,'style','style=[background=grayF0]');
    end;
      else if name eq 2 then do;
    call define (_row_,'style','style=[background=white]');
    end;
      else if name eq 3 then do;
    call define (_row_,'style','style=[background=grayE0]');
    end;
      else if name eq 4 then do;
    call define (_row_,'style','style=[background=white]');
    end;
  endcomp;
run;
title;


ods rtf close;
ods pdf close;
ods powerpoint close;
quit;
