Toon is a smart thermostat which is mounted on the wall of your living room for example.
It is connected to your boiler and maybe to your electricity and gas meters and maybe even more.

This Toon app is for Daikin air conditioners only and : 
    
 - enables you to control heating and cooling from 1 wall mounted device.
 - supports up to 4 air conditioners.
 - has 1 Tile showing status of the air conditioners and giving access to the Control screen.
 - has 1 Control screen with controls + buttons to start the Settings and Energy screens.
 - has 1 Settings screen to configure up to 4 air conditioners.
 - has 1 Energy Usage screen showing last 12 months of energy consumption of up to 4 air conditioners.
 - has 1 Graphs screen showing last 12 months of heat, cool and totals, pages between up to 4 air conditioners.

Limitation : Newer Daikin airco's don't have a local API running, so can only be accessed true the cloud. 
See https://www.domoticaforum.eu/viewtopic.php?t=13798

You can install this app from the ToonStore or manually without ToonStore :

 - Open an sftp tool like WinScp/Mozilla on Windows to browse to your Toon.
 - On your Toon go to /qmf/qml/apps and create a folder daikin.
 - In that folder you put at least the qml files and the drawables folder.
 - You may put your own png files in the drawables folder.
   These will be overwritten when you upgrade from the ToonStore.
 - Restart the GUI. ( On your Toon go to > Settings > TSC > Restart GUI )

After manual installation or from the ToonStore you add the Daikin app like any other app to the screen.
Click on a big + and add a tile for Daikin.

 - There will be a scrolling message on the Tile inviting you to configure.
 - Click the Tile to see the Control screen.
 - Click the Settings button to go to the Settings screen.
 - Change the number of air conditioners from 4 to what you want. (all screen layouts adopt themselves.) 
 - Change names, IP addresses and the interval in which Tile updates from one to the other.
 - Only when you click Save on the Settings screen your settings are really saved.
    When click the Home button (or the Settings screen times out) your changes are not permanent.
 - After you click Save on the Settings you are back in the Control screen.
 - You may have a look at the Usage screen ( bottom right button ) and inspect the graphs.
 - On the Control screen you can select an air conditioner and use controls.
 - On the Control screen click Monitor All to monitor all or Home to focus on 1 air conditioner.
 
Notes :
 - Controls touched on the control screen behind the tile are sent immediately to the air conditioner.
 - Control button updates are done by reading back from the air conditioner so it may take a moment before you 
   see a change on the Controls screen after selecting a control button.
 - This is not true for temperature, which is both changed immediatly and synced with the air conditioner.
 - The Control screen has a Monitor All button when you configure more that 1 air conditioner.
   When you have more air conditioners click this button to enable the Tile to switch between them.
   Otherwise the Tile will focus on the last on the Control screen selected air conditioner.
 - When you have 1 air conditioners you can configure 4 with the same IP and give them different names like :
   'Kitchen' , '.Kitchen.' , '..Kitchen..' , '...Kitchen...' which gives a nice effect on the Tile.
   Or name them 'Happy' , 'birthday', 'to my dear', 'Toon'
 - When you configure more with the same IP, the Energy Usage report sees them as individual air conditioners.
 - See some screenshots in the screenshots folder.

Tile colors represent mode :

    black / grey : power is off
    blue         : cooling
    red          : heating
    yellow       : ventilating
    green        : drying
    
On the tile you see the name you gave your air conditioner.
The next line is the current temperature, a symbol for the mode and the target temperature.

    '^' : heating
    'v' : cooling
    '>' : automatic
    '=' : ventilating / drying

Bottom number : outdoor temperature

Thanks for reading and enjoy.
