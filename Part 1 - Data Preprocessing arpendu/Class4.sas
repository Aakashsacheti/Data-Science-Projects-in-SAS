/*SGN*/
/**********************************************
*******************Class 4********************
**********************************************/

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
IF SEX = "F" THEN X = AGE;
ELSE X = LOG(AGE);RUN;


DATA B01.C8;SET SASHELP.CLASS;
FORMAT T $30.;
IF AGE < 13 THEN T = "AGE BELOW 13";
ELSE IF AGE <=14 THEN 
T = "AGE BETWEEN 13 AND 14";
ELSE T = "AGE ABOVE 14";RUN;

/*MULTIPLE ACTION*/
DATA NEW;SET OLD;
IF COND THEN DO;
ACTION 1;ACTION 2;...;ACTION N;END;
ELSE IF COND THEN DO;
ACTION 1;ACTION 2;...;ACTION N;END;
ELSE IF COND THEN DO;
ACTION 1;ACTION 2;...;ACTION N;END;....;
ELSE DO;
ACTION 1;ACTION 2;...;ACTION N;END;RUN;

DATA B01.C9;SET SASHELP.CLASS;
FORMAT T $30.;FORMAT X Y Z 10.2;
IF AGE < 13 THEN DO;
X=LOG(AGE);Y=LOG(HEIGHT);Z=LOG(WEIGHT);
T = "AGE BELOW 13";END;
ELSE IF AGE <=14 THEN DO;
X= 888;Y=999;Z=555;
T = "AGE BETWEEN 13 AND 14";END;
ELSE DO;X=AGE*82;Y=HEIGHT**2;Z=WEIGHT**2;
T = "AGE ABOVE 14";END;RUN;



/*Class Activity 1: FROM SASHELP.AIR CREATE A NEW DATA WITH 2 EXTRA COLUMNS STORING
1. THE FINANCIAL QUARTER
2. A VARIABLE CALLED T TO SHOW
"WEDNESDAY/THURSDAY","OTHER WEEKDAYS" 
 OR "WEEKENDS" ACCORDING AS DAY OF THE WEEK.*/

DATA B01.C4;SET SASHELP.AIR;FORMAT T $30.;
FORMAT DATE WEEKDATE30.;
IF QTR(DATE) = 1 THEN FQ = 4;
ELSE FQ=QTR(DATE) - 1;
IF WEEKDAY(DATE) IN (4,5) THEN
T = "WEDNESDAY/THURSDAY";
ELSE IF WEEKDAY(DATE) IN (1,7) THEN
T = "WEEKENDS";ELSE T ="OTHER WEEKDAYS";RUN;


/*Home Activity : From the SASHELP.CLASS, please create the variable as listed in the conditions
mentioned in the 'HW IF THEN ELSE SHEET*/


/**********************************************
*******************SORTING	********************
**********************************************/


/*CREATE OBSERVATION NO.*/


DATA B01.C;SET SASHELP.CLASS;M=_N_;RUN;


PROC SORT DATA = B01.C OUT=B01.C10;
BY DESCENDING M ;RUN;


PROC SORT DATA = SASHELP.CLASS OUT=B01.C;
BY SEX ;RUN;

/*SORT IN A DESCENDING ORDER*/

PROC SORT DATA = SASHELP.CLASS OUT=B01.C2;
BY DESCENDING SEX ;RUN;


PROC SORT DATA = SASHELP.CLASS OUT=B01.C;
BY DESCENDING AGE;RUN;


/*MULTIPLE VARIABLES*/
PROC SORT DATA = SASHELP.CLASS OUT=B01.C;
BY SEX DESCENDING AGE;RUN;

PROC SORT DATA = SASHELP.CLASS OUT=B01.C;
BY SEX DESCENDING AGE HEIGHT ;RUN;


/**********************************************
************DUPLICATE REMOVALS*****************
**********************************************/


/*DUPLICATE REMOVAL*/
/*BASED ON 1NGLE VARIABLE*/


PROC SORT DATA = SASHELP.CLASS NODUPKEY 
OUT=B01.C DUPOUT = B01.D;BY SEX;RUN;

/*BASED ON >1 VARIABLES*/
PROC SORT DATA = SASHELP.CLASS NODUPKEY 
OUT=B01.C DUPOUT = B01.D;BY AGE SEX;RUN;

/*BASED ON ALL VARIABLES*/
PROC SORT DATA = SASHELP.CLASS NODUP 
OUT=B01.C DUPOUT = B01.D;BY SEX;RUN;



/*/*CENTRAL TENDENCY: MEAN,MEDIAN,MODE*/*/
/*DISPERSION: VARIANCE, STANDARD DEVIATION,*/
/*COEFFICIENT OF VARIATION*/
/*SKEWNESS,KURTOSIS*/
/*CORRELATION*/
/*TESTING OF HYPOTHESIS:*/
/*t TEST - ONE SAMPLE, INDEPENDENT SAMPLE*/
/*, PAIRED t TEST*/
/*ANOVA: */
/*CHISQUARE TEST FOR IDENPENDENCE OF*/
/*ATTRIBUTES*/
/*SAS ANNOTATED OUTPUT: UCLA*/
