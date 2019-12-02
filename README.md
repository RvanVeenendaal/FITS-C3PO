# FITS_C3PO
README voor het werken met de tools FITS en C3PO in een 64-bits Windowsomgeving.

FITS zorgt voor identificatie, validatie en metadata-extractie van bestanden.

C3PO zet de resulterende FITS-XML om in profielen ("content profiles") van de bestanden.
## Doel van de bestanden
Uitleg over het installeren van FITS, C3PO en benodigde software staat in INSTALL FITS en C3PO.txt.

De commando's om de C3PO web api (met de database) te starten staan ook in de batchfile "C3PO-launcher.bat".

De C3PO-launcher kan in een Command Prompt worden opgestart, of door de batchfile te dubbelklikken. 

De commando's om FITS, C3PO en de C3PO web api in een pipeline te starten staan in de batchfile "FITS-C3PO-launcher.bat".

De FITS-C3PO-launcher kan in een Command Prompt worden gestart. Een voorbeeld van een aanroep is "FITS-C3PO-launcher.bat C:\demo\DATASET MijnDATASET", waarbij C:\demo\DATASET de map is waar uw (test)bestanden in staan, en MijnDATASET de naam is die u aan de analyseresultaten van de (test)bestanden wilt geven. Die naam gebruikt de webinterface van C3PO bijvoorbeeld als naam voor deze dataset.

## De benodigde tools
FITS: http://projects.iq.harvard.edu/fits

C3PO: http://ifs.tuwien.ac.at/imp/c3po (c3po-cmd-0.4.0 en bijbehorende C3PO-webapi)

MongoDB: http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2.0.5.zip (versie 2.0.5 nodig voor C3PO)

Play: https://downloads.typesafe.com/releases/play-2.0.4.zip (versie 2.0.4 nodig voor C3PO) 

Een downloadbestand (ZIP, 430 MB) met daarin de benodigde tools is beschikbaar via XXXXXXXXXX (tijdelijk niet beschikbaar, update in de maak). In plaats van alle software (en afhankelijkheden) zelf te downloaden en installeren, kun je ook dit bestand downloaden, uitpakken in een folder van je keuze en gebruiken.

LET OP: veel van de onderstaande commando's worden op de Command Prompt (cmd.exe) uitgevoerd.

Bekendheid met het uitvoeren van commando's op de Command Prompt wordt verondersteld.

Hierna wordt ervan uitgegaan dat de tools geïnstalleerd zijn in c:\demo.

## 1: Maak FITS-analyse van dataset, vanuit folder met data.
   Voer fits.bat zonder parameters uit voor uitleg.

FITS-XML-metadatabestanden worden weggeschreven in de uitvoerfolder.

*** Controleer periodiek of je de laatste versie van FITS geïnstalleerd hebt. ***

LET OP: maak eerst de output directory (C:\demo\FITS_C3PO\FITS-OUTPUT\DATASET) waar FITS de resultaten van de analyse naar toe kan schrijven. 
 
In de folder C:\Temp\DATASET (aangenomen dat daar de te analyseren dataset staat), voer het volgende commando uit. :
   
C:\demo\FITS_C3PO\FITS-OUTPUT\FITS\fits-1.4.1\fits.bat -i c:\Temp\DATASET -o C:\demo\FITS_C3PO\FITS-OUTPUT\DATASET -r
   
Na -i staat de folder met de Input, na -o staat de folder met Output, en -r zorgt ervoor dat subfolders Recursief worden bezocht.

## 2: Maak de metadata via C3PO beschikbaar
Start de mongodb-databaseserver op, met een verwijzing naar de lokale database.

C:\demo\FITS_C3PO\MONGODB\mongodb-2.0.5\bin\mongod.exe -dbpath C:\demo\FITS_C3PO\MONGODB\data\db

Na -dbpath staat de folder met de database. C3PO schrijft data weg in deze database.

### Laat C3PO de data inlezen (gather).

*** Controleer periodiek of je de laatste versie van C3PO geïnstalleerd hebt. ***

NB In BenchmarkDP is c3po doorontwikkeld, zie github.com/datascience/c3po/.

Pogingen om de daar doorontwikkelde web api onder Windows te laten werken mislukten.

In de folder C:\Temp\DATASET, voer het volgende commando uit:

java -jar C:\demo\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar gather -c DATASET -r -i C:\demo\FITS_C3PO\FITS\FITS-OUTPUT\DATASET

Na -c staat de naam die in de database aan de dataset wordt gegeven, na -i staat de folder met FITS-resultaten en -r staat weer voor recursief.

### Laat C3PO profielen opbouwen (profile)
   
In de folder C:\Temp\DATASET, voer het volgende commando uit:

java -jar C:\demo\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar profile -c DATASET -o C:\demo\FITS_C3PO\C3PO\C3PO_OUTPUT\DATASET

Na -c staat de naam van de data in de database, na -o staat de folder waar een XML-bestand met globale metadata wordt opgeslagen.

## 3: Nu kun je de C3PO-webinterface opstarten:
In de folder C:\demo\FITS_C3PO\C3PO\c3po-master\c3po-webapi, voer het volgende commando uit:

C:\demo\FITS_C3PO\PLAY\play-2.0.4\play.bat run

Let op dat je in play.bat zo nodig de padnamen aanpast naar waar je de tools installeerde. Anders krijg je een foutmelding over "kan het gevonden pad niet vinden" bij het uitvoeren van dit commando.

### Open vervolgens een webbrowser en ga naar de URL:
http://localhost:9000/c3po/overview

Kies uit de beschikbare collecties (bijv. DATASET).

## Je kunt in C3PO een export maken van alle of een deel van de gegevens.
In bijv. Excel kun je dan zelf je eigen analyses uitvoeren.

Let op: voor het maken van de export is de webapi niet noodzakelijk.

Je kunt de export ook maken via de commandline (optie export):

java -jar C:\demo\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar export -c DATASET -o C:\demo\FITS_C3PO\C3PO\C3PO_OUTPUT\DATASET

Na -c staat de naam van de data in de database, na -o staat de folder waar het (kommagescheiden) exportbestand wordt weggeschreven.

## Let op: in C:\demo\C3PO\c3po-master\c3po-webapi\exports en in .log-bestanden slaat C3PO metadata (exports en logs) op. Mocht u uw versie van de toolset aan anderen beschikbaar willen stellen, verwijder dan eerst deze metadata.

# EINDE
