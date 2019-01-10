/*-------------------------------------------3RD CLASS------------------------------------------------------------*/

/*/**Looking at the structure of the file/*/
PROC CONTENTS DATA = SASHELP.CITIDAY;RUN; 


/*******************************************
*******TRANSFER OF OUTPUT TO EXTERNAL FILES*
********************************************/

/* EXPORTING TO EXCEL*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week2\C1.XLS";
PROC CONTENTS DATA = SASHELP.CITIDAY;RUN;
ODS HTML CLOSE;


/*EXPORTING TO WORD*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week2\C.DOC";
PROC CONTENTS DATA = SASHELP.CITIDAY;RUN;
ODS HTML CLOSE;


/*EXPORTING TO HTML*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week2\C.HTML";
PROC CONTENTS DATA = SASHELP.CITIDAY;RUN;
ODS HTML CLOSE;


/*EXPORTING TO PDF*/
ODS PDF FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week2\C.PDF";
PROC CONTENTS DATA = SASHELP.CITIDAY;RUN;
ODS PDF CLOSE;


/*Class Activity1:Export the SAS file: Cars from the library Sashelp into your local system
in formats: Excel, Doc, Pdf, HTML*/

/*2.PRINTING THE SAS OUTPUT*/


/*******************************************
*******PRINTING THE ENTIRE OUTPUT ***********
********************************************/

PROC PRINT DATA = SASHELP.CLASS;RUN;


/*******************************************
*******PRINTING FEW VARIABLES ***********
********************************************/

PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;RUN;


/*******************************************
*******PRINTING FEW OBSERVATIONS ***********
********************************************/


PROC PRINT DATA = SASHELP.CLASS(OBS = 10);RUN;

PROC PRINT DATA = SASHELP.CLASS
(FIRSTOBS = 5 OBS = 10);RUN;


ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week2\C1.XLS";
PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;RUN;
ODS HTML CLOSE;


/*******************************************
*******PRINTING WITH CONDITIONS ***********
********************************************/

PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE SEX = "F";RUN;

PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE SEX ~= "F";RUN;


PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE AGE <13;RUN;


PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE AGE >14;RUN;


PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE 13<=AGE<=14;RUN;


PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE AGE <13 OR AGE > 14;RUN;

PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;WHERE NOT(13<=AGE<=14);RUN;


PROC PRINT DATA = SASHELP.CLASS;
VAR NAME AGE SEX;
WHERE SEX = "F" AND NOT(13<=AGE<=14);RUN;
/*This is with Multiple Conditions*/


/*Class Activity2: FROM SASHELP.AIR PRINT THE DATES WHICH AREWEEKENDS AFTER 1955*/



PROC PRINT DATA = SASHELP.AIR;
FORMAT DATE WEEKDATE30.;
VAR DATE;WHERE YEAR(DATE)>1955 AND
(WEEKDAY(DATE)=1 OR WEEKDAY(DATE)= 7);RUN;
PROC PRINT DATA = SASHELP.AIR;
FORMAT DATE WEEKDATE30.;
VAR DATE;WHERE YEAR(DATE)>1955 AND
WEEKDAY(DATE) IN (1,7);RUN;*/


/*Home Activity 1: FROM SASHELP.CLASS PRINT THE NAME AGE AND SEX OF THOSE FEMALES WHOSE NAME STARTS WITH J*/



/*******************************************
*******CONDITIONAL VALUE CREATION ***********
********************************************/

DATA NEW;SET OLD;
IF COND THEN ACTION;
ELSE IF COND THEN ACTION;
ELSE IF COND THEN ACTION;....;
ELSE ACTION;RUN;
/*2 CATEGORY*/
DATA B01.C;SET SASHELP.CLASS;FORMAT X 10.2;
IF SEX = "F" THEN X = AGE**2;
ELSE X = LOG(AGE);RUN;


/*Class Activity 3: FROM SASHELP.CLASS, CREATE A NEW DATASET AND A NEW CATEGORY VARIABLE FOR AGE,
with the following three categories age <13, between 13 and 14 and >14*/

DATA B01.C7;SET SASHELP.CLASS;
FORMAT T $30.;
IF AGE < 13 THEN T = "AGE BELOW 13";
ELSE IF AGE <=14 THEN 
T = "AGE BETWEEN 13 AND 14";
ELSE T = "AGE ABOVE 14";RUN;


/*Home Activity 2: FROM SASHELP.AIR CREATE A NEW DATA WITH 2 EXTRA COLUMNS STORING
1. THE FINANCIAL QUARTER
2. A VARIABLE CALLED T TO SHOW
"WEDNESDAY/THURSDAY","OTHER WEEKDAYS" 
OR "WEEKENDS" ACCORDING AS DAY OF THE WEEK.;*/








