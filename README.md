# FiveM Scripts

![alt text](https://kasper-rasmussen.dk/assets/images/banner_low.png "Logo")


Disse projekter har været under udvikling i et stykke tid, og et par stykker har været afprøvet på serveren DanDream, som jeg har valgt at forlade. 

Da jeg håber nogen kan bruge dem, bliver de nu delt her, og håber i tager godt imod dem. 

Dog skal det siges, at jeg som sagt ikke har haft dem alle afprøvet på en officel server med mange spillere, og derfor sætter jeg stor pris på beskeder med eventuelle fejl, mangler og lignende. 

## Projekter:

![alt text](https://kasper-rasmussen.dk/assets/images/icons/info_16x16.png "Waiting") kasperr_base

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_carjack_alert

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_info_menu [(video)](https://youtu.be/wizzv1FT7Tk "Info menu - video")

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_inventory [(video)](https://youtu.be/loLkBvHa110 "Inventory - video")

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_jobcenter [(video)](https://youtu.be/CjaqFxzWaTM "Jobcenter - video")

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_loadout [(video)](https://youtu.be/iAjVkuo1j3A "Loadout - video")

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_police_equipment [(video)](https://youtu.be/WORBnH0MDuA "Police equipment - video")

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_progress_handler

![alt text](https://kasper-rasmussen.dk/assets/images/icons/check_16x16.png "Completed") kasperr_richpresence

### Dokumentation:

Alle projekter har en inkluderet config fil, hvor der er mulighed for at gøre oplevelsen for jeres spillere mere personligt. 
Her vil i se en fil: `config.lua`, som primært er configs til diverse Lua filer.

Derudover vil der i visse tilfælde være en fil: `configNui.js`, hvor det omhandler den medfølgende NUI menu (lavet i HTML, CSS & JavaScript).

#### Progress Handler
Jeg har udarbejdet en "progress handler", som er beregnet til at køre et ønsket event efter kort tid. 

Det kan være smart at benytte den, hvis man ikke ønsker, at folk kan indtage mad, drikke eller samle genstande op meget hurtigt, eller man generalt ønsker at spilleren skal vente et par sekunder for at kunne fortsætte.

##### Brug af den omtalte "progress handler":

**Parametre:**

Titel: Overskrift

Tid: Her angiver vi hvor lang tid der skal gå før den er færdig

Type: Vælg om det event, som skal køres er "client" eller "server"

Event: Navnet på det event som skal køres

Args: Eventuelle variabler som man ønsker at sende med hen til det event, man ønsker at køre

```lua
TriggerClientEvent("kasperr_progress_handler:open", "My title", 5000, "client", "event:name", {"random string"}) 
```