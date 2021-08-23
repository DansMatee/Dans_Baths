# Dans_Baths
 Bathing System for RedEM:RP
 
 <h2> Using this Script </h2>
 Pretty straightforward script, adds usable baths around the place, and its written in LUA so us mortals do not need to dive into C#.
 
 There are 2 different bath options, <br>
 1 - $0.50 - A light clean. Gets rid of Basic dirt and dries you. <br>
 2 - $2.50 A deep clean. Completely cleans you up. <br>
 
 To edit prices, navigate to client/baths.lua and follow below
 
 ```
 Line 103 and 104 -> Change the Label price
 Line 115 and 118 -> Change the value to your liking
 ```
 
 To add extra baths and blips, navigate to client/baths.lua and follow along below
 
 ```
 Line 6 -> locations table, insert a new row with the following,
 { x=-317.22, y=763.02, z=117.43 }, -- This is a location to open the menu, this is NOT the blip
 
 Line 141 -> blips table, insert a new row with the following,
 { name = 'Baths', sprite = 944812202, x= -317.22, y= 763.02, z= 117.43 }, -- This is the blip / map marker
 ```
 
 <h2> Required Resources </h2>
  RedEM:RP is required <br>
  Forum Post -> https://forum.cfx.re/t/redem-roleplay-gamemode-the-roleplay-gamemode-for-redm/915043 <br>
  Github -> https://github.com/RedEM-RP/redem_roleplay <br>
  <br>
  REDEM:RP_Menu_Base is required <br>
  Github -> https://github.com/RedEM-RP/redemrp_menu_base
  
  <h2> Credits </h2>
  Thank you to RedEM and RedEM:RP <br>
  RedEM:RP Discord -> https://discord.gg/JS82WmQ7nG
 
