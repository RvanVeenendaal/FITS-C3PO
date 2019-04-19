:begin
@echo off

SET BASE_PATH=%~dp0
REM ECHO Script name  : %0
REM Path to collection: %~dp1
REM Collection name   : %~nx1

IF [%1] == [] GOTO Error1
IF NOT EXIST %1\ GOTO Error2
IF [%2] == [] GOTO Error3

REM Adding JDK6 to PATH Environment Variable, as this version is required for C3PO.
SET PATH=%BASE_PATH%\JAVA\jdk1.6.0;%PATH%

REM Referring JAVA_HOME to JDK6, as this version is required for C3PO.
SET JAVA_HOME=%BASE_PATH%\JAVA\jdk1.6.0\

REM Start MongoDB database in a seperate Command Prompt
ECHO Starting MongoDB (in seperate, minimized, Command Prompt)...
START /MIN CMD /K %BASE_PATH%\MONGODB\mongodb-2.0.5\bin\mongod.exe -dbpath %BASE_PATH%\MONGODB\data\db

REM Create directory for storing FITS XML output files
ECHO Creating directory for FITS files using collection name: %BASE_PATH%\FITS_OUTPUT\%2
IF NOT EXIST %BASE_PATH%\FITS-OUTPUT\%2\ mkdir %BASE_PATH%\FITS-OUTPUT\%2

REM Create directory for storing C3PO output files
ECHO Creating directory for C3PO files using collection name: %BASE_PATH%\C3PO_OUTPUT\%2
IF NOT EXIST %BASE_PATH%\C3PO-OUTPUT\%2\ mkdir %BASE_PATH%\C3PO-OUTPUT\%2

REM Fire up FITS and write FITS XML output files to the FITS XML output directory
ECHO Running FITS (this may take a while)...
CALL %BASE_PATH%\FITS\fits-1.4.1\fits.bat -i %1\ -o %BASE_PATH%\FITS-OUTPUT\%2 -r

REM Fire up C3PO in gather mode, which stores the FITS XML output in the database
ECHO Starting C3PO in GATHER mode...
java -jar %BASE_PATH%\C3PO\c3po-cmd-0.4.0.jar gather -c %2 -r -i %BASE_PATH%\FITS-OUTPUT\%2

REM Fire up C3PO in profile mode, which profiles the FITS XML output in the database
ECHO Starting C3PO in PROFILE mode...
java -jar %BASE_PATH%\C3PO\c3po-cmd-0.4.0.jar profile -c %2 -o %BASE_PATH%\C3PO-OUTPUT\%2

REM Fire up C3PO in export mode, which saves a csv export of the profile to the C3PO output directory
ECHO Starting C3PO in EXPORT mode...
java -jar %BASE_PATH%\C3PO\c3po-cmd-0.4.0.jar export -c %2 -o %BASE_PATH%\C3PO-OUTPUT\%2

REM CD to c3po-webapi directory, which is where play.bat must be ran
ECHO CD to %BASE_PATH%\C3PO\c3po-master\c3po-webapi...
CD %BASE_PATH%\C3PO\c3po-master\c3po-webapi

REM Fire up the C3PO web api in a seperate Command Prompt
ECHO Starting C3PO-webapi (in seperate, minimized, Command Prompt)...
START /MIN CMD /K %BASE_PATH%\PLAY\play-2.0.4\play.bat run

REM CD back to starting directory
ECHO CD back to %BASE_PATH%...
CD %BASE_PATH%

REM Fire up your default browser and go to the C3PO overview page URL
ECHO Starting default browser with C3PO overview page URL...
START http://localhost:9000/c3po/overview
GOTO End

REM Echo the Usage message
:Usage
ECHO Usage: %0 input_directory collection_name
ECHO        input_directory:  the path to the directory with the collection of files to analyse. No spaces allowed!
ECHO        collection_name: the name you want the collection to have in the database. No spaces allowed!
ECHO        %0 will run FITS against the collection of files, store the results in the database,
ECHO        start the C3PO web interface and open C3PO's overview page in your default browser.
ECHO        Starting the web interface may take a while. You may have to refresh the overview page.
GOTO End

REM Echo an error if no input_directory was provided
:Error1
ECHO Error: no input_directory provided!
GOTO Usage

REM Echo an error if the input_directory can't be accessed
:Error2
ECHO Error accessing input_directory %1!
GOTO Usage

REM Echo an error if no collection_name was provided
:Error3
ECHO Error: no collection_name provided!
GOTO Usage

:End
REM End of script