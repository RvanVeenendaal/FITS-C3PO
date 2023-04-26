# README voor het werken met de tools FITS en C3PO in een 64-bits Windowsomgeving.

## Algemeen: 
- FITS zorgt voor identificatie, validatie en metadata-extractie van bestanden.
- C3PO zet de resulterende FITS-XML om in profielen ("content profiles") van de bestanden.
- Bij het installeren van de tools zul je merken, dat er veel afhankelijkheden van oudere softwarepakketten zijn. Als Nationaal Archief hebben we daarom een voorgeïnstalleerde versie van FITS, C3PO en afhankelijheden gemaakt. Dit is een ZIP van zo'n 400 MB. Neem contact met ons op, als je daar gebruik van wilt maken.

## Zie voor meer informatie over de tools hun websites:
- FITS: http://projects.iq.harvard.edu/fits
- C3PO: http://ifs.tuwien.ac.at/imp/c3po (c3po-cmd-0.4.0 en bijbehorende C3PO-webapi)
- MongoDB: http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2.0.5.zip (versie 2.0.5 nodig voor C3PO)
- Play: https://downloads.typesafe.com/releases/play-2.0.4.zip (versie 2.0.4 nodig voor C3PO) 

## LET OP: veel van de onderstaande commando's worden op de Command Prompt (cmd.exe) uitgevoerd.
Bekendheid met het uitvoeren van commando's op de Command Prompt wordt verondersteld.

## 1: Maak voordat je de tools start directory's aan voor de uitvoer van de tools.
- Deze readme gaat er vanuit, dat de te analyseren dataset in de directory C:\Temp\DATASET staat. Als dat bij jou anders is, pas de commando's van aan jouw situatie aan.
- Deze readme gaat er ook vanuit, dat je de tools installeerde in de directory C:\Temp\FITS_C3PO. Als dat bij jou anders is, pas de commando's van aan jouw situatie aan.
- Maak eerst de uitvoerdirectory C:\Temp\FITS_C3PO\FITS-OUTPUT\DATASET waar FITS de resultaten van de analyse naar toe kan schrijven. 
- Maak ook een uitvoerdirectory C:\demo\FITS_C3PO\C3PO-OUTPUT\DATASET waar C3PO de profielexport naar toe kan schrijven.

## 2: Maak een FITS-analyse van de dataset, vanuit de directory met data.
- Voer fits.bat zonder parameters uit voor uitleg over FITS.
- FITS-XML-metadatabestanden worden weggeschreven in de uitvoerfolder.
#### NB Controleer periodiek op de FITS-website of er FITS-updates zijn. Als je FITS vernieuwt, pas dan de versienummers in deze readme aan.

- In de directory C:\Temp\FITS_C3PO\FITS-OUTPUT\FITS\fits-1.5.5, voer het volgende commando uit: <br/>
C:\Temp\FITS_C3PO\FITS-OUTPUT\FITS\fits-1.5.5\fits.bat -i c:\Temp\DATASET -o C:\Temp\FITS_C3PO\FITS-OUTPUT\DATASET -r
- Na -i staat de directory met de invoer (dataset) voor FITS.
- Na -o staat de directory waar FITS de uitvoer (output) naar toe kan schrijven
- Met -r zorgt je ervoor dat eventuele subdirectories recursief worden meegenomen.

## 3: Maak de metadata via C3PO beschikbaar
- Start de mongodb-databaseserver op in de achtergrond, met een verwijzing naar de lokale database: <br/>
start /B C:\Temp\FITS_C3PO\MONGODB\mongodb-2.0.5\bin\mongod.exe -dbpath C:\Temp\FITS_C3PO\MONGODB\data\db
- Met start /B start Windows de MongoDB in de achtergrond.
- Zo nu en dan zal MongoDB een statusupdate in de Command Prompt zetten.
- Druk dan op Enter om weer een commando te kunnen typen.
- Pas als je de Command Prompt afsluit gaat de database uit.
- Het alternatief is dat je het commando zonder start /B uitvoert in een tweede Command Prompt.
- Na -dbpath staat de folder met de database. C3PO schrijft data weg in deze database.

## 4: Laat C3PO de data inlezen (gather).
- In de directory C:\Temp\DATASET, voer het volgende commando uit: <br/>
java -jar C:\Temp\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar gather -c DATASET -r -i C:\Temp\FITS_C3PO\FITS\FITS-OUTPUT\DATASET
- Na -c staat de naam die in de database en op de C3PO-website aan de dataset wordt gegeven.
- Na -i staat de directory met FITS-resultaten.
- Met -r zorgt je ervoor dat eventuele subdirectories recursief worden meegenomen.

## 5: Laat C3PO profielen opbouwen (profile)
- In de directory C:\Temp\DATASET, voer het volgende commando uit: <br/>
java -jar C:\Temp\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar profile -c DATASET -o C:\Temp\FITS_C3PO\C3PO\C3PO_OUTPUT\DATASET
- Na -c staat de naam van de data in de database.
- Na -o staat de directory waar een XML-bestand met globale metadata wordt opgeslagen.

## 6: Nu kun je de C3PO-webinterface opstarten:
- In de folder C:\Temp\FITS_C3PO\C3PO\c3po-master\c3po-webapi, voer het volgende commando uit: <br/>
C:\Temp\FITS_C3PO\PLAY\play-2.0.4\play.bat run
- Open vervolgens een webbrowser en ga naar de URL: <br/>
http://localhost:9000/c3po/overview
- Kies uit de beschikbare collecties (bijv. DATASET).
- Uitleg over hoe je met de C3PO-webinterface werkt, vind je via de C3PO-link bovenaan deze readme.

## 7: Je kunt in C3PO een CSV-export maken van alle of een deel van de gegevens.
- In bijv. Excel kun je dan zelf je eigen analyses uitvoeren.
- Let op: voor het maken van de export is de webapi niet noodzakelijk.
- Je kunt de export maken via de Command Prompt, met de optie export: <br/>
java -jar C:\Temp\FITS_C3PO\C3PO\c3po-cmd-0.4.0.jar export -c DATASET -o C:\Temp\FITS_C3PO\C3PO\C3PO_OUTPUT\DATASET
- Na -c staat de naam van de data in de database.
- Na -o staat de directory waar het CSV-exportbestand wordt weggeschreven.
- Dit is een Comma Separated Values tekstbestand, dat je bijv. in Excel kunt importeren.

## TOT SLOT
- De commando's om de C3PO webapi (met de database) te starten staan ook in de batchfile "C3PO-launcher.bat".
- De C3PO-launcher kan in een Command Prompt worden opgestart, of door de batchfile te dubbelklikken.
- De commando's om FITS, C3PO en de C3PO webapi in een keer achter elkaar te starten staan in de batchfile "FITS-C3PO-launcher.bat".
- De FITS-C3PO-launcher kan in een Command Prompt worden gestart.
### NB In de twee launchers koos ik ervoor, de MongoDB in aparte Command Prompts op te starten.

EINDE
