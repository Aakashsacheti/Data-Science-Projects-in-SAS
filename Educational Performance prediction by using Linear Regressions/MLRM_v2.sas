

/**********************************************************/
/***********Multiple Linear Regression *********************/
/**********************************************************/


PROC CONTENTS DATA = B01.ELEMAPI;

/*****************************
**********Data Cleaning*******
******************************/


/**Checking the structure of the Data**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\UNIVARIATE_ELEMAPI.XLS";
PROC UNIVARIATE DATA = B01.ELEMAPI NEXTROBS = 15;
RUN;ODS HTML CLOSE;




/**Faeture Creation**/
DATA B01.m; 
SET B01.Elemapi;
S=NOT_HSG+HSG+SOME_COL+COL_GRAD+GRAD_SCH;RUN;

/**ODS EXCEL FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\ELEMAPI_A.XLSX";	**/
PROC PRINT DATA = B01.m ;
RUN; 
/**ODS EXCEL CLOSE;**/


/**Checking the Anomalies in the Data*/
PROC FREQ DATA = B01.m;
TABLES S;RUN;


PROC FREQ DATA = B01.m;TABLES S;
WHERE AVG_ED = .;RUN;


PROC FREQ DATA = B01.m;
TABLES DNUM;
WHERE FULL <=1;
RUN;




/**Data Treatment*/
DATA B01.m;SET B01.m;
ACS_K3 = ABS(ACS_K3);
IF AVG_ED = . THEN AVG_ED = 0;
IF FULL <=1 THEN FULL = FULL*100;RUN;



/*Missing Value Treatment*/
PROC MEANS DATA = B01.m MEAN NMISS;
RUN;

PROC MEANS DATA = B01.m MIN MAX MEAN NMISS;
VAR MEALS;
CLASS MEALCAT;
RUN;


DATA B01.A;SET B01.A;
IF ACS_K3 = . THEN ACS_K3 =19.1608040;
IF ACS_46 = . THEN ACS_46 =29.6851385;
IF MOBILITY = . THEN MOBILITY =18.2531328;
IF MEALCAT = 1 AND MEALS = . THEN 
MEALS = 28.36;
IF MEALCAT = 2 AND MEALS = . THEN 
MEALS = 66.0468750;RUN;


/*FREQ FOR CATEGORY VARIABLES*/
PROC FREQ DATA = B01.A;TABLES MEALCAT YR_RND;RUN;




/*********************************************************************
*********Checking Interdependence between Independent Variables*******
***********************************************************************/





/*CHECKINH THE CORR OF API00 WITH THE OTHER CONT VARIABLES*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Week 6\O.XLS";
PROC CORR DATA = B01.A;
WITH API00;RUN;ODS HTML CLOSE;




/*Interdependence among the Categorical VARIABLES*/
/** checking the -vely corelated mealcat**/
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS MEALCAT;
RUN;

PROC ANOVA DATA = B01.A;
CLASS MEALCAT;
MODEL API00=MEALCAT;
RUN;
 
/** checking -ively correlated free meals variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\mealmean_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS MEALS;
RUN; ODS HTML CLOSE;

/** checking -ively correlated free meals variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\ELLmean_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS ELL;
RUN; ODS HTML CLOSE;

/** checking -ively correlated YEAR ROUND SCHOOLS variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\YEARRrndDmean_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS YR_RND;RUN;
RUN; ODS HTML CLOSE;

/** checking -ively correlated year round schools with full time teachers variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\YEARRrndfULLDmean_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00 FULL;
CLASS YR_RND;
RUN;
ODS HTML CLOSE;

PROC ANOVA DATA = B01.A;CLASS YR_RND;
MODEL API00=YR_RND;RUN;

/** checking -ively correlated year round schools with parents not High School Graduates variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\Not Hsg_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS not_hsg;
RUN;
ODS HTML CLOSE;

/** checking -ively correlated year round schools with parents= Graduates variable**/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\graduates_ELEMAPI.XLS";
PROC MEANS DATA = B01.A MEAN;
VAR API00;
CLASS grad_sch;
RUN;
ODS HTML CLOSE;

/*********************************************************************
**********************Start of Modelling******************************
***********************************************************************/


/*Y = A+B1X1+B2X2+….+BKXK + U*/


ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\model2.XLS";
PROC REG DATA = B01.A;
MODEL API00 = 
meals
/**ell**/
yr_rnd
/**mobility**/
/**acs_k3**/
/**acs_46**/
/**not_hsg**/
hsg
/**some_col**/
/**col_grad**/
/**grad_sch**/
/**avg_ed**/  /** if for unit inc in avg years of edu my api00 score inc by 179 keeping all vars constant, not statistically signi ficant (only at 90 - 100%)	**/
full
/**emer**/
/**enroll**/
/**mealcat**/
/VIF COLLIN;
/**spec;**/
RUN;
ODS HTML CLOSE;


/*ALPHA = 0.01%*/
/*VIF <=1.5, P <0.0001*/

/*HOMOSCEDASTICITY - i.e. THE*/
/*VARIANCE OF THE ERROR COMPONENT */
/*MUST BE CONSTANT ACROSS THE CROSS SECTION*/
/*WHITE'S TEST*/
/*H0: MODEL IS HOMOSCEDASTIC*/
/*H1: MODEL IS HETEROSCEDASTIC;*/
/*P < ALPHA => HETEROSCEDASTICITY WHICH*/
/*CAN BE REDUCED BY TRANSFORMATION OF X*/
/*VARIABLES PARTICULARLY LOG OR SQUARE ROOT*/
/*HETEROSCEDASTICITY*/

/**ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\R2.XLS";
PROC REG DATA = B01.A;
MODEL API00 = 
meals
ell
yr_rnd
mobility
acs_k3
acs_46
not_hsg
hsg
some_col
col_grad
grad_sch
avg_ed
full
emer
enroll
mealcat
/SPEC;
RUN;
ODS HTML CLOSE;	**/

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\FinModSpec.XLS";
PROC REG DATA = B01.A;
MODEL API00 = 
meals
/**ell**/
yr_rnd
/**mobility**/
/**acs_k3**/
/**acs_46**/
/**not_hsg**/
hsg
/**some_col**/
/**col_grad**/
/**grad_sch**/
/**avg_ed**/  /** if for unit inc in avg years of edu my api00 score inc by 179 keeping all vars constant, not statistically signi ficant (only at 90 - 100%)	**/
full
/**emer**/
/**enroll**/
/**mealcat**/
/**VIF COLLIN;**/
/spec;
RUN;
ODS HTML CLOSE;


/*CREATE THE OUTPUT FILE*/
PROC REG DATA = B01.A;
MODEL API00 = 
meals
yr_rnd
hsg
full
;
OUTPUT OUT = B01.O 
P = PRED R = RES;
RUN;
QUIT;




/*NORMALITY OF RESIDUAL*/
/**PROC UNIVARIATE DATA = B01.O NORMAL;
VAR RES;HISTOGRAM RES/NORMAL;RUN;
/*MAPE*/
/*MEAN ABSOLUTE PERCENTAGE ERROR*/
/*ERROR = ACTUAL - PREDICTED*/
/*ABS(ERROR/ACTUAL)*100*/
/*MEAN OF THE ABOVE = MAPE*/

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\Residuals_norm.XLS";
PROC UNIVARIATE DATA = B01.O NORMAL;
RUN; ods html close;

DATA B01.O;SET B01.O;
ERROR = ABS(RES/API00)*100;RUN;

PROC MEANS DATA = B01.O MEAN;VAR ERROR;RUN;
proc export data = B01.O
  dbms= xls 
  outfile= "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 2- Multiple Linear Regression\MlrmFinal.XLS"
 replace;
run;

1. OVERALL SIGNIFICANCE P < ALPHA
2. MULTICOLLINEARITY - VIF <=1.5
3. INDIVIDUAL SIGNIFICANCE - P < ALPHA
4. HOMOSCEDASTICITY CHECK - P > ALPHA
5. NORMALITY CHECK - P > APLHA
6. MAPE <=10%
7. R - SQUARE >= 65%

proc export data=b01.0 
  dbms=xlsx 
  outfile="c:\temp\prdsale.xlsx" 
  replace;
run;
