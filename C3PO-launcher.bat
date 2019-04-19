:begin
@echo off

SET BASE_PATH=%~dp0
REM ECHO Script name  : %0
REM Path to collection: %~dp1
REM Collection name   : %~nx1

REM Adding JDK6 to PATH Environment Variable, as this version is required for C3PO.
SET PATH=%BASE_PATH%\JAVA\jdk1.6.0;%PATH%

REM Referring JAVA_HOME to JDK6, as this version is required for C3PO.
SET JAVA_HOME=%BASE_PATH%\JAVA\jdk1.6.0\

REM Start MongoDB database in a seperate Command Prompt
ECHO Starting MongoDB (in seperate, minimized, Command Prompt)...
START /MIN CMD /K %BASE_PATH%\MONGODB\mongodb-2.0.5\bin\mongod.exe -dbpath %BASE_PATH%\MONGODB\data\db

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
ECHO Usage: %0 
ECHO        %0 will fire up the C3PO web api and open C3PO's overview page in your default browser.
ECHO        Starting the web interface may take a while. You may have to refresh the overview page.
GOTO End

:End
REM End of script