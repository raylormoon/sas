*/
Author: Tianjiao Xu(Raylor Xu)
Date: 04/08/2022
Purpose: Programming assignment 6
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
X "cd S:\desktop\hw6";
libname hw6 ".";
filename hw6 ".";

*set options;
options nodate;
ods noproctitle;
options fmtsearch = (hw6 InputDS);
*Create format;
proc format library = hw6; 
  value Metro(fuzz=0)     0 = "Indeterminable"
                          1 = "Not in a Metro Area"
                          2 = "In Central/Principal City"
                          3 = "Not in Central/Principal City"
                          4 = "Central/Principal Indeterminable"
  ;
run;
*select destinations for output;
ods listing close;
ods pdf file = " HW6xuIPUMS.pdf" dpi=300 startpage = never;

*Input the cities dataset;
data hw6.cities;
  infile RawData("Cities.txt") firstobs = 2 dlm = "09"x truncover;
  input city : $40. citypop : comma6.;
  city = tranwrd(city,'/','-');
run;

*Input the States data;
data hw6.states;
  infile RawData("States.txt") firstobs = 2 dlm = "09"x truncover;
  input serial state $20. city:$40.;
run;

*Input the Contract data;
data hw6.contract;
  infile RawData("Contract.txt") dsd firstobs = 2 dlm = "09"x truncover;
  input serial metro countyFIPS :$3. MortPay : dollar6. HHI : dollar10. HomeVal : dollar10.;
run;


*Input the Mortgaged data;
data hw6.mortgaged;
  infile RawData("Mortgaged.txt") firstobs = 2 dlm = "09"x truncover dsd;
  input serial metro countyFIPS : $3. MortPay : dollar6. HHI : dollar10. HomeVal : dollar10.;
run;

*Sort the data Cities;
proc sort data = HW6.cities;
  by city;
run;

*Sort the data of state;
proc sort data = HW6.states;
  by city;
run;


*Combine the data of cities and states by city;
data hw6.xuipumscity;
  merge hw6.cities 
        HW6.states;
  by city;
run;
*sort the data;
proc sort data=hw6.xuipumscity
  out=hw6.city2;
  by serial;
run;


*combine 4 data by merge and create values by do;
data hw6.ipums1;
  attrib MortStat length = $ 45
         Ownership length=$6;
  set hw6.contract (in=incontract)
  hw6.mortgaged (in=inmor)
  InputDS.freeclear (in=infree)
  InputDS.renters (in=inrenter rename=(FIPS=CountyFips));
  if incontract eq 1 then do;
  Mortstat = "Yes, contract to purchase";
  Ownership = "Owned";
  end;
    else if inmor eq 1 then do;
       Mortstat = "Yes, mortgaged/ deed of trust or similar debt";
       Ownership = "Owned";
       end;
      else if infree eq 1 then do;
        Mortstat =  "No, owned free and clear";
        Ownership = "Owned";
        end;
        else if inrenter eq 1 then do;
            Mortstat = "N/A";
            Ownership = "Rented";
            end;    
  if HomeVal eq 9999999 then do;
  HomeVal = .R;
  end;
    else if HomeVal eq . then do;
    HomeVal = .M;
    end;
  if serial eq . then delete;
  MetroDesc = put(Metro , Metro.);
run;

*sort thecombined dataset;
proc sort data=hw6.ipums1;
by serial;
run;

*Create the final dataset;
data hw6.Xuipums2005;
  attrib Serial     label = "Household Serial Number"
         CountyFIPS length= $3 label = "County FIPS Code"
         Metro      label = "Metro Status Code"
         MetroDesc  length = $ 32      label = "Metro Status Description"
         CityPop    format = comma6.    label = "City Population (in 100s)"
         MortPay    format = dollar6.   label = "Monthly Mortgage Payment"
         HHI        format = dollar10.  label = "Household Income"
         HomeVal    format = dollar10.  label = "Home Value"
         State      label = "State, District, or Territory"
         City       label = "City Name"
         Metro      label = "Metro Status Code"
         MortStat   length = $ 45 label = "Mortgage Status"
         Ownership  label = "Ownership Status"
    ;
  merge hw6.ipums1  hw6.city2;
  by serial;
run;

*Store the comment for proc compare;
ods pdf exclude all;
ods output position = hw6.Xuipums2005desc(drop = member);
proc contents data = hw6.Xuipums2005 varnum;
run;

*compare for whole data;
proc compare base = Results.HW6Oppermanipums2005
             compare = hw6.Xuipums2005
             out = hw6.diffsA outbase outcomp outdiff outnoequal noprint method = absolute criterion = 1E-15
;
run;

*compare for metadata;
proc compare base = Results.HW6OppermanDesc
             compare = hw6.Xuipums2005desc
             out = hw6.diffsB outbase outcomp outdiff outnoequal noprint method = absolute criterion = 1E-15
;
run;


*Report the data in pdf;
ods pdf exclude none;
title 'Listing of Households in NC with Incomes Over $500,000';
proc report data = hw6.xuipums2005;
  column City Metro MortStat HHI HomeVal;
  where HHI > 500000 and state in ("North Carolina");
run; 
title;

ods proctitle;
*Univariate for citypop, Mortpay, HHI, HomeVal;
ods select citypop.BasicMeasures citypop.quantiles citypop.Histogram.Histogram
           Mortpay.quantiles HHI.BasicMeasures HHI.ExtremeObs HomeVal.BasicMeasures
           HomeVal.ExtremeObs HomeVal.MissingValues;
proc univariate data = Results.HW6Oppermanipums2005 ;
  histogram citypop /kernel;
  var citypop MortPay HHI HomeVal;
run;

*create sgplot;
ods pdf startpage=now;
ods listing image_dpi=300;
ods graphics / reset width = 5.5in imagename="hw6xugraph";
title j=center "Distribution of City Population";
title2  j=center "(For Households in a Recognized City)";
footnote  j=l "Recognized cities have a non-zero value for City Population.";
ods graphics / reset width = 5.5in;
proc sgplot data = Results.HW6Oppermanipums2005;
  where citypop ne 0;
  histogram citypop/scale=proportion;
  density citypop / type = kernel lineattrs=(color=Red thickness=2);
  yaxis display = (nolabel) valuesformat = percent7.;
  keylegend / location = inside position = ne
              ;
run;
title;
footnote;

*create panel graph;
ods listing image_dpi=300;
ods graphics / reset width = 5.5in imagename="hw6xugraph2";
title j=center "Distribution of Household Income Stratified by Mortgage Status";
footnote j=center "Kernel estimate parameters were determined automatically.";
proc sgpanel data = Results.HW6Oppermanipums2005 noautolegend;
  panelby MortStat / novarname;
  histogram HHI/scale=proportion;
  density   HHI / type = kernel lineattrs=(color=Red);
  rowaxis display = (nolabel) valuesformat = percent7.;
  colaxis values = (0 to 1500000 by 1500000);
run;
title;
footnote;
ods pdf close;
ods listing;
quit;



