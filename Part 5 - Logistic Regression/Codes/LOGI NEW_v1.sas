

/************LOGISTIC REGRESSION************
********************************************
*******************************************/

/*Setting the Working Directory*/

LIBNAME L "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other";
RUN;

/*Looking at the contents of the Data*/

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\Conte.XLS";
PROC CONTENTS DATA= L.LOGISTIC;
RUN;
ODS HTML CLOSE;


/*STAGE 1: UNIVARIATE UNIVARIATE ANALYSIS*/


/*CLEANED*/
/*GENERATION OF RANDOM SUBSAMPLE BASED ON RANUNI FUNCTION
90% OF THE DATA IS IN THE DEVELOPMENT SAMPLE AND 10% IN THE VALIDATION SAMPLE*/




DATA L.D L.V;
SET L.LOGISTIC;
IF RANUNI(7894) <=0.9 THEN OUTPUT L.D;
ELSE OUTPUT L.V;
RUN;


/*STAGE 2: MULTICOLLINEARITY CHECK USING VIF*/


/*CHECK OF MULTICOLLINEARITY FROM PROC REG WITH VIF COLLIN*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\MOLC1.XLS";
PROC REG DATA = L.D;
MODEL HONCOMP = 
female
math
prog        
race
read
schtyp
science
ses
socst
write
/VIF COLLIN;
RUN;
ODS HTML CLOSE;



/*STAGE 3: CHECKING THE SIGNIFICANCE OF INDIVIDUAL P-VALUES USING WALD TEST*/

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\L.XLS";
PROC LOGISTIC DATA = L.D DESCENDING;
/*DESCENDING IS WRITTEN TO MODEL THE LOGISTIC FUNCTION P(Y=1)*/
MODEL HONCOMP = 
FEMALE 
READ 
MATH 
socst 
SCIENCE
/LACKFIT RSQ;
OUTPUT OUT = L.OUT P = PRED;
RUN;
QUIT;
ODS HTML CLOSE;


/*Interpretation of Odds Ratio:
for a one female,
the odds of being able to complete HONS (versus not being abe to complete) increase by a factor of 3.31*

/*Things to check:
1. Significance of Variables - P-value<0.001
2.Hosmer-Lemeshow Test, p-value needs to greater>0.001 as we need to accept the Ho
3. Percentage of Concordant Pairs>60*/

/*STAGE 4: CHECKING THE KS-STATIS*/
/*CALLING THE MACRO - ENSURE TO RUN IT BEFORE THIS*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\K2.XLS";
%KSGCF(L.OUT,PRED,HONCOMP,10,KS);
ODS HTML CLOSE;

/*Things to check:
1. KS-STATISTIC
2. GINI COEFFICIENT
3. LORENZ CURVE/

DATA L.OUT;
SET L.OUT;
SCORE = ROUND(PRED*1000);
RUN;



/*STAGE 5: DIVERGENCE TEST*/
PROC TTEST DATA = L.OUT;
VAR SCORE;
CLASS HONCOMP;
RUN;

/*Things to check:
1: P-values of Equality of Variances and T Test
2: P-value<0.0001 to reject the Ho*/


/*STAGE 6: CLUSTERING CHECK*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\CUS.XLS";
PROC FREQ DATA = L.OUT;
TABLES SCORE;
RUN;
ODS HTML CLOSE;



/*STAGE 7: VALIDATION RERUN*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\VAL.XLS";
PROC LOGISTIC DATA = L.V DESCENDING;
MODEL HONCOMP = FEMALE socst SCIENCE;
/*ONLY SIGNIFICANT VARIABLES FROM DEV DATA*/
OUTPUT OUT = L.Y1 P = PROB1;
RUN;
QUIT;



ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\VAL.XLS";
PROC LOGISTIC DATA = L.V DESCENDING;
MODEL HONCOMP = FEMALE  READ MATH socst SCIENCE;
/*ONLY SIGNIFICANT VARIABLES FROM DEV DATA*/
OUTPUT OUT = L.Y1 P = PROB1;
RUN;
QUIT;







ODS HTML CLOSE;
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\K_VAL.XLS";
%KSGCF(L.Y1,PROB1,HONCOMP,10,RO);
ODS HTML CLOSE;




/*SCORING*/
DATA L.V1;
SET V;
/*USE SAME ESTIMATED EQUATION FORM DEV MODEL*/
L = A+B1X1+B2X2+...+BKXK;
P = EXP(L)/(1+EXP(L));
RUN;
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Classes\SGN01\Logistic Regression\Other\K.XLS";
%KSGCF(L.V1,P,HONCOMP,10,RO);
ODS HTML CLOSE;

FINE CLASSING AND COARSE CLASSING
FINE CLASSING - CREATING THE CATEGORIES FOR
CONTINUOUS VARIABLES - CALCULATE WOE AND
INFORMATION VALUE
COARSE CLASSING - LOOK INTO THE WOE PLOT
ACROSS CATEGORIES AND RECATEGORISE BASED ON THE
PLOT TO GET A PROPER GRAPH WHICH SHOULDN'T
HAVE MULTIPLE KINKS

1.	WOE AND IV - CONTINUOUS AND CATEGORCAL VARIABLES
2.	REMOVE VARIABLE WITH IRRELEVENT IV VALUE
3.	RECLASSIFICATION OF REST OF THE VARIABLES - 
COARSE CLASSING
a.	CONTINUOUS AND ORDINAL VARIABLES 
NORMAL RECLASSIFICATION
b.	ORDINAL - SORT ON WOE AND THEN RECLASSIFICATION
4.	CREATE NEW WOE VARIABLE FOR EACH VARIABLE 
TO STORE THE WOE FOR THE CORRESPONDING CATEGORY
5.	THIS WOE VARIABLES SHOULD BE USED AS X VARIABLES
6.	MULTICOLLINEARITY ��
