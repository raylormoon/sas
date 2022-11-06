*/
Author: Tianjiao Xu(Raylor Xu)
Date: 03/22/2022
Purpose: Programming assignment 5
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

X "cd S:\desktop\hw4";
libname hw4 ".";
*change working dirctory to where my output will go;
X "cd S:\desktop\hw5";
libname hw5 ".";
filename hw5 ".";

*set options;
options nodate;
ods noproctitle;
options fmtsearch = (hw4 InputDS);
*select destinations for output;
ods listing close;
ods pdf file = " HW5xuProjects.pdf" dpi=300;

*read in raw data 1;
data hw5.o3;
  infile rawData("O3Projects.txt") firstobs=2 dsd truncover;
  input _s $ _ji $  _dateRe : $30.  _Pol $ Equipment :comma. Personnel :comma.;
run;

*read in raw data 2;
data hw5.co;
  infile rawData("COProjects.txt") firstobs=2 dsd truncover;
  input _s $ _ji $  _dateRe : $30. Equipment :comma. Personnel :comma.;
run;

*read in raw data 3;
data hw5.so2;
  infile rawData("SO2Projects.txt") firstobs=2 dsd truncover;
  input _s $ _ji $  _dateRe : $30. Equipment :comma. Personnel :comma.;
run;

*read in raw data 4;
data hw5.tsp;
  infile rawData("TSPProjects.txt") firstobs=2 dsd truncover;
  input _s $ _ji $  _dateRe : $30. Equipment :comma. Personnel :comma.;
run;

*combine 5 dataset and clean it;
data hw5.HW5XuProjects(drop = _:);
  attrib StName length=$2 label="State Name"
         Region length=$9
         JobID  label=""
         Date   format=DATE9.
         PolType   length=$4 label="Pollutant Name"
         PolCode   label="Pollutant Code"
         Equipment format=DOLLAR11. 
         Personnel format=DOLLAR11. 
         JobTotal  format=DOLLAR11.
         ;
  set hw5.o3(in=ino3) hw5.co(in=inco) hw5.so2(in=inso2) 
      hw5.tsp(in=intsp) hw5.lead(in=inlead)
         ;
  if inlead eq 0 then do;
  StName = upcase(_s);
  JobID = input(tranwrd(tranwrd(_ji,'O','0'),'l','1'),5.);
  Date = input(compress(_dateRe,,'a'),5.);
  Region = propcase(compress(_dateRe,,'ak'));
  PolCode = compress(_Pol,'5','k');
  PolType = compress(_Pol,'O3','k');
  JobTotal = sum(Equipment, Personnel);
  end;
  if inco eq 1 then do;
        PolType = 'CO';
        PolCode = '3';
      end;
      else if inso2 eq 1 then do;
        PolType = 'SO2';
        PolCode = '4';
         end;
         else if intsp eq 1 then do;
           PolType = 'TSP';
           PolCode = '1';
           end;
run;

*sort data;
proc sort data=hw5.HW5XuProjects out=hw5.HW5XuProjectssorted;
  by PolCode Region descending JobTotal descending Date JobID;
run;

*create data for desc;
ods pdf exclude all;
ods output position=hw5.hw5xuprojectsdesc(drop = member);
proc contents data=hw5.hw5xuprojects varnum;
run;

*compare mine and Dr.opperman's;
proc compare base = Results.hw5oppermanprojects compare=hw5.HW5XuProjectssorted
  out=hw5.diffsa outbase outcompare outdiff outnoequal noprint method = absolute criterion = 1E-10;
run;
proc compare base = Results.hw5oppermanprojectsdesc compare=hw5.hw5xuprojectsdesc 
  out=hw5.diffsb outbase outcompare outdiff outnoequal noprint method = absolute criterion = 1E-15;
run;

*Create means statistics for graphs;
ods pdf exclude all;
proc means data = hw5.HW5XuProjectssorted p25 p75;
  class region date /missing;
  var jobtotal;
  by PolCode;
  format date dat.;
run;

*create graphs;
ods pdf exclude none;
ods pdf startpage=never;
ods listing image_dpi = 300;
ods graphics on/ width = 6in imagename = "H5xugraph";
options nobyline;
title "25th and 75th Percentiles of Total Job Cost";
title2 "By Region and Controlling for Pollutant = #BYVAL1";
title3 h=8pt "Including Records where Region or PolCode were Unknown (Missing)";
footnote j=left "Bars are labeled with the number of jobs contributing to each bar";
proc sgplot data=hw5.means;
  by PolCode;
  styleattrs datacolors=(CX98FB98 CXDDA0DD CXFFDAB9 CXDB7093 gray gray gray gray);
  vbar region / missing response = JobTotal_p75
                group = date 
                groupdisplay = cluster
                grouporder=ascending
                datalabel=nobs
                datalabelattrs=(size=7pt)
                outlineattrs=(color=black)
                name="MyFirstPlot"
                ;
  vbar region / missing response = JobTotal_p25
                group = date 
                groupdisplay = cluster
                grouporder=ascending
                outlineattrs=(color=black)
                name="MySecondPlot"
                ;
  keylegend "MyFirstPlot" / position = top;
  format  PolCode $PolMap. JobTotal_p75 Dollar11. JobTotal_p25 Dollar11. Date dat.; 
  xaxis display=(nolabel);
  yaxis display=(nolabel)
        grid 
        gridattrs = (thickness = 2 color = grayCC);
run;
title;
footnote;

ods pdf close;
quit;
