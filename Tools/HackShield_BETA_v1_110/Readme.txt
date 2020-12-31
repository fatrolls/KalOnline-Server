Here is a quick start guide:

1. Open the configuration files MainConfig.txt and config.properties wiht you favorit editor.
2. Set the port in MainConfig.txt to 30002 (Port=30002).
3. In the config.properties you must set the MainSrv. port to 30002 (KalMainServerPort = 30002)
   and the HackShield server port to 30001 (HackShildServerPort = 30001).
4. Setup your firewall and block the MaiSrv. port 30002.
5. Start now KAL AuthSvr. -> KAL DBSvr -> KAL MainSvr -> HackShield.

Have fun :D

Available commands:

Admin:

 /status       | Show Max. and Cur. connection
 /blocklist    | Show all blocked accounts
 /block name   | Block player account by name
 /unblock name | Unblock player account by name
 /protect val  | Set hack protect status (Val = enable/disable)
 /reload val   | Reload the configuration or BadWordList file (Val = config/badwordlist)
 /move2 name   | Move to the player (for move2 addon you need the MainSrv. 3 file)

Player:
 /online       | Show you how many player are online
 /i val        | Ignore the chat from player (val = help/list/add/del/clear)

For shutdown you must type in the console "q" and enter :P
