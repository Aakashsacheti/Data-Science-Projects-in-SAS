/***************************************
************SQL IN SAS*******************
***************************************
***************************************/


/*SELECTING ALL VARIABLES  with * */
PROC SQL;CREATE TABLE B01.C4 AS SELECT
* FROM SASHELP.CLASS;QUIT;


/*SELECTING a few variables*/
PROC SQL;CREATE TABLE B01.C4 AS SELECT
NAME,AGE,SEX FROM SASHELP.CLASS;QUIT;


DATA B01.C4;SET SASHELP.CLASS;
KEEP NAME AGE SEX;RUN;


/*SELECTING a few variables based on categorical function*/


/*******Using WHERE function***************
*******************************************
*******************************************/

PROC SQL;CREATE TABLE B01.C4 AS SELECT
NAME,AGE,SEX FROM SASHELP.CLASS WHERE
SEX = "F";QUIT;



DATA B01.C4;SET SASHELP.CLASS;
KEEP NAME AGE SEX;IF SEX="F";RUN;


/*GROUPING VARIABLES*/



/************Using Group By****************
*******************************************
*******************************************/


PROC SUMMARY DATA = SASHELP.CLASS 
MEAN NWAY MISSING;CLASS SEX;
VAR AGE HEIGHT WEIGHT;OUTPUT OUT = B01.C1 
MEAN(AGE) = AVG_AGE MEAN(HEIGHT)=AVG_HT
MEAN(WEIGHT) = AVG_WT;RUN;



PROC SQL;CREATE TABLE B01.C AS SELECT
SEX,COUNT(NAME) AS FREQ,MEAN(AGE) AS AVG_AGE,
MEAN(HEIGHT)AS AVG_HT, MEAN(WEIGHT) AS AVG_WT
FROM SASHELP.CLASS GROUP BY SEX;QUIT;



/************DISTINCT COUNT****************
*******************************************
*******************************************/


PROC SQL;CREATE TABLE B01.C AS SELECT
COUNT(DISTINCT(AGE)) AS CN_A, COUNT(DISTINCT(WEIGHT)) AS CN_W, COUNT(DISTINCT(HEIGHT)) AS CN_H
FROM SASHELP.CLASS;QUIT;




/******DISTINCT COUNT BY GROUP VARIABLE*****
*******************************************
*******************************************/


PROC SQL;CREATE TABLE B01.C AS SELECT
SEX,COUNT(DISTINCT(AGE)) AS CN 
FROM SASHELP.CLASS GROUP BY SEX;QUIT;



/*MACRO*/


PROC UNIVARIATE DATA = SASHELP.AIR
NEXTROBS = 20;VAR AIR;RUN;



%MACRO UNI(DT,VA,OB);
PROC UNIVARIATE DATA = &DT
NEXTROBS = &OB;VAR &VA;RUN;%MEND;


/*CALL THE MACRO*/


%UNI(SASHELP.CLASS,WEIGHT,7);

%UNI(SASHELP.AIR,AIR,7);
/
