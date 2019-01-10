PROC IMPORT OUT= B00.C1 
            DATAFILE= "C:\Documents and Settings\STD\Desktop\SAS Classes
\SGN01\Input Files\TESTCASA.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=YES;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
