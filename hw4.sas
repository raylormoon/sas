*/
Author: Tianjiao Xu(Raylor Xu)
Date: 03/04/2022
Purpose: Programming assignment 4
*/

*clears log and listing windows;
DM "log;clear";
DM "output;clear";

*changing working directory to L odrive to esablish libraries;
X " cd L:\st445\data";
libname InputDS ".";
filename rawdata ".";
X " cd L:\st445\Results";
libname Results ".";
*change working dirctory to where my output will go;
X "cd S:\desktop\hw4";
libname hw4 ".";
FILENAME hw4 ".";

*set options;
options fmtsearch = (hw4);
options nodate;
ods noproctitle;

*create format for date;
proc format library = hw4;
  value dat  "01JAN&1998"d -< "01APR&1998"d = 'Jan/Feb/Mar'
              "01APR&1998"d -< "01JUL&1998"d = 'Apr/May/Jun'
              "01JUL&1998"d -< "01OCT&1998"d = 'Jul/Aug/Sep'
              "01OCT&1998"d -  "31DEC&1998"d = 'Oct/Nov/Dec'
  ;
run;

*select destinations for output;
ods listing;
ods pdf file = "HW4XuLead.pdf";

*read in raw data and clean issue;
data lead(drop = _:);
  attrib StName length=$2 label="State Name"
         Region length=$9
         JobID label=""
         Date   format=DATE9.
         PolType   length=$4 label="Pollutant Name"
         PolCode   label="Pollutant Code"
         Equipment format=DOLLAR11. 
         Personnel format=DOLLAR11. 
         JobTotal  format=DOLLAR11. 
         ;
  infile rawData("LeadProjects.txt") firstobs=2 dsd truncover;
  input _s $  _ji $  _dateRe : $20.  _Pol $ Equipment :comma. Personnel :comma.;
  StName = upcase(_s);
  JobID = input(tranwrd(tranwrd(_ji,'O','0'),'l','1'),5.);
  Date = input(compress(_dateRe,,'a'),5.);
  Region = propcase(compress(_dateRe,,'ak'));
  PolCode = substr(_pol,1,1);
  PolType = compress(_Pol,,'ak');
  JobTotal = sum(Equipment, Personnel);
run;

*sort data;
proc sort data = lead out = hw4.HW4RaylorLead;
  by region stname descending jobtotal;
run;

*print raw data;
ods output position=hw4.HW4RaylorLeaddesc(drop = member);
ods pdf exclude all;
proc contents data=hw4.HW4RaylorLead varnum;
run;

*compare the difference between raw data and read in data;
proc compare base = Results.hw4oppermanlead compare=hw4.HW4RaylorLead 
  out=hw4.diffsb outbase outcompare outdiff outnoequal noprint method = absolute criterion = 1E-15;
run;

proc compare base = Results.hw4oppermanleaddesc compare=hw4.HW4RaylorLeaddesc 
  out=hw4.diffsa outbase outcompare outdiff outnoequal noprint method = absolute criterion = 1E-15;
run;

*create means table;
title "90th Percentile of Total Job Cost By Region and Quarter";
title2 "Data for 1998";
ods pdf exclude none;
ods listing exclude summary;
ods output summary = hw4.means;
proc means data = hw4.HW4RaylorLead p90;
  class region date;
  var jobtotal;
  format date dat.;
run;
TITLE;

*create bar graph of means;
ods listing image_dpi = 300;
ods graphics on/ width = 6in imagename = "HW4Pctile90";
proc sgplot data = hw4.means;
  hbar region / response = jobtotal_p90
                group = date 
                groupdisplay = cluster
                datalabel=nobs
                datalabelattrs=(size = 6pt);
  keylegend / location = outside 
              position = top 
              across = 4;
  xaxis label = "90th Percentile of Total Job Cost" grid;
  format jobtotal_p90 dollar6.;
run;

*create frequcency table;
ods pdf exclude none;
ods listing exclude crosstabfreqs;
ods output crosstabfreqs = HW4.freq ( where = (_type_='11') keep= region date rowpercent _type_) ;
title "Frequency of Cleanup by Region and Date";
title2 "Data for 1998";
proc freq data =hw4.hw4raylorlead;
  table region*date / nocol nopercent;
  format date dat.;
run;
title;

*proc contents data=hw4.freq;
*run;

*create vertical bar by frequency table;
ods listing image_dpi = 300;
ods graphics on/ width = 6in imagename = "HW4RegionPct";
ods output sgplot = HW4.freqgraph;
proc sgplot data = hw4.freq;
  styleattrs datacolors=(red grey blue purple);
  vbar region / response = rowpercent
                group = date 
                groupdisplay = cluster;
  keylegend / location = inside 
              position = ne 
              down = 2 
              opaque;
  xaxis labelattrs = (size = 16pt) 
        valueattrs = (size = 14pt);
  yaxis label = "Region Percentage within Pollutant" 
        labelattrs = (size = 16pt)
        valueattrs = (size = 12pt)
        values = (0 to 45 by 5) 
        valuesformat = comma4.1 
        offsetmax = 0.05
        grid 
        gridattrs = (thickness = 2 color = grayCC);
run;
title;

proc compare base = Results.hw4oppermangraph2 compare=hw4.freqgraph
  out=hw4.diffsc outbase outcompare outdiff outnoequal noprint method = absolute criterion = 1E-15;
run;

ods pdf close;
quit;
