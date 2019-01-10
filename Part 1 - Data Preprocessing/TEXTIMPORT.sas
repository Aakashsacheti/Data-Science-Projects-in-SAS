PROC IMPORT OUT= B01.TXT01 
            DATAFILE= "C:\Documents and Settings\STD\Desktop\SAS Classes
\SGN01\Input Files\TESTCASA123.txt" 
            DBMS=DLM REPLACE;
     DELIMITER='09'x; 
     GETNAMES=YES;
     DATAROW=2; 
RUN;
