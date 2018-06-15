
/*******************************
***TIME SERIES FORECASTING******
*******ARIMA APPROACH************/


/*PRE-MODELLING PROCESSING*/

/*SETTING lIBRARY*/
DATA B01.A;
SET SASHELP.AIR;
LABEL AIR ="AIR";
RUN;

/*PLOTTING THE AVAILABLE RAW DATA*/
PROC GPLOT DATA = B01.A;
PLOT AIR*DATE;
RUN;


/*CREATING THE LOG, EXPONENTIAL, DIFFRENCE OF LOG AND EXPONANTIAL AT THE SAME TIME FOR 
TRANSFORMATION OF AIR*/
DATA B01.A;
SET B01.A;
LOG_AIR = LOG(AIR);
SQRT_AIR = AIR**0.5;
DIF_LOG_AIR = DIF(LOG_AIR);
DIF_SQRT_AIR = DIF(SQRT_AIR);
RUN;

/*CREATING THE FIES TO EXPORT IN EXCEL*/
ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\TRAN1Air.xls";
PROC PRINT DATA = B01.A;
RUN;
ODS HTML CLOSE;


/*PLOTTING THE DATA TO SEE THAT WHICH TRANSFORMATION OF DATA 
IS GIVING US THE MOST STATIONARY VALUES*/ 
PROC GPLOT DATA = B01.A;
PLOT SQRT_AIR*DATE;
RUN;

PROC GPLOT DATA = B01.A;
PLOT LOG_AIR*DATE;
RUN;

PROC GPLOT DATA = B01.A;
PLOT DIFF_LOG _AIR*DATE;
RUN;

PROC GPLOT DATA = B01.A;
PLOT DIFF_SQRT_AIR*DATE;
RUN;
/*DIFF_LOG_AIR COMES OUT TO BE MOST STATIONARY*/


/*NON STATIONARITY CHECK OF THE DATA USING AUGMENTED DICKEY FULLER TEST*/
/*H0: DATA IS NON STATIONARY
H1: DATA IS STATIONARY

FOR ARIMA FORECASTING, THE PRE-REQUISTE IS DATA SHOULD BE STATIONARY*/

ODS HTML FILE =  "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\ADF_Air.xls";
PROC ARIMA DATA = B01.A;
IDENTIFY VAR = LOG_AIR STATIONARITY = (ADF);
IDENTIFY VAR = SQRT_AIR STATIONARITY = (ADF);
IDENTIFY VAR = DIF_LOG_AIR STATIONARITY = (ADF);
IDENTIFY VAR = DIF_SQRT_AIR STATIONARITY = (ADF);
RUN;
ODS HTML CLOSE;
/*Since, p-value<0.001, we reject HO and conclude DIF_LOG_AIR is statioanry*/


/*CHECK FOR SEASONALITY*/
PROC ARIMA DATA = B01.A;
IDENTIFY VAR = DIF_LOG_AIR;RUN;
/*found seasonality in every 12 months, need to be removed*/

PROC ARIMA DATA = B01.A;
IDENTIFY VAR = DIF_LOG_AIR NLAG = 60;RUN;

/*Here, you need to check the auto correlation output, removing the seasonality*/
DATA B01.A;
SET B01.A;
DIF12_DIF_LOG_AIR = DIF12(DIF_LOG_AIR);
RUN;

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\SESON_Air.xls";
PROC ARIMA DATA = B01.A;
IDENTIFY VAR = DIF12_DIF_LOG_AIR NLAG = 60;
RUN;
ODS HTML CLOSE;
/*__________________________________________________________________________________________________________*/

/*1.STATIONARITY/NON-STATIONARITY*/
/*2.ADF TEST*/
/*3.ACF/PACF PLOTS*/
/*4.AR/MA/ARMA/ARIMA*/


/*/*CREATION OF DEVELOPMENT AND VALIDATION SAMPLE*/

DATA B01.D B01.V;
SET B01.A;
IF YEAR(DATE) = 1960 THEN OUTPUT B01.V;
ELSE OUTPUT B01.D;
RUN;


/*P (ORDER OF AR )  &  Q (ORDER OF MA)*/
PROC ARIMA DATA = B01.D;
IDENTIFY VAR = DIF12_DIF_LOG_AIR MINIC;	/*(TO GET COMBINATION OF P&Q)*/
RUN;

PROC ARIMA DATA = B01.D;
IDENTIFY VAR = DIF12_DIF_LOG_AIR;
ESTIMATE P = 1 Q = 2;
RUN;
PROC ARIMA DATA = B01.D;
IDENTIFY VAR = DIF12_DIF_LOG_AIR;
ESTIMATE P = 3 Q = 2;
RUN; 


/*GENERATE FOR ALL COMBINATIONS*/
/*GENERATE THE FORECASTS*/
PROC ARIMA DATA = B01.D;
IDENTIFY VAR = DIF12_DIF_LOG_AIR;
ESTIMATE P = 2 Q = 3;
FORECAST LEAD = 12 ID = DATE 
INTERVAL = MONTH OUT = B01.F1;
RUN;
QUIT;

/*SHOULD USE THIS FORM*/
PROC ARIMA DATA = B01.D;
IDENTIFY VAR = LOG_AIR(1,12); /*(1 REFFERES TO DIFFRENCING, 12 REFFERS TO SEASONALITY)*/
ESTIMATE P = 2 Q = 3;
FORECAST LEAD = 12 ID = DATE
INTERVAL = MONTH OUT = B01.F2;
RUN;
QUIT;

PROC ARIMA DATA = B01.D;
IDENTIFY VAR = LOG_AIR(1,12); 
ESTIMATE P = 0 Q = 3;
FORECAST LEAD = 12 ID = DATE
INTERVAL = MONTH OUT = B01.F3;
RUN;
QUIT;
/*HERE CALCULATED THE LOWEST MAPE*/



ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\Validate.xls";
PROC PRINT DATA = B01.V;
VAR DATE AIR;
RUN;
ODS HTML CLOSE;


ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\forcast.xls";
PROC PRINT DATA = B01.F3;
VAR FORECAST;
WHERE YEAR(DATE) = 1960;
RUN;
ODS HTML CLOSE;



/*USE THE BEST MODEL ON THE ENTIRE DATA*/
PROC ARIMA DATA = B01.A;
IDENTIFY VAR = LOG_AIR(1,12);
ESTIMATE P = 0 Q = 3;
FORECAST LEAD = 12 ID = DATE 
INTERVAL = MONTH OUT = B01.FN;
RUN;
QUIT;

ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\TS_EST_FINAL.xls";
PROC PRINT DATA = B01.FN;
VAR FORECAST;
RUN;
ODS HTML CLOSE;



ODS HTML FILE = "C:\Documents and Settings\STD\Desktop\SAS Arpendu2\Part 4 - Time Series Forecasting\Data\TS_FINAL.xls";
PROC PRINT DATA = B01.A;
VAR DATE AIR;
RUN;
ODS HTML CLOSE;

