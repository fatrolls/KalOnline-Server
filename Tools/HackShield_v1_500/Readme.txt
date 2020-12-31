Here is a quick start guide:

1. Open the configuration files MainConfig.txt and config.properties wiht you favorit editor.
2. Set the port in MainConfig.txt to 30002 (Port=30002).
3. In the config.properties you must set the MainSrv. port to 30002 (KalMainServerPort = 30002)
   and the HackShield server port to 30001 (HackShildServerPort = 30001).
4. Setup your firewall and block the MaiSrv. port 30002.
5. Start now KAL AuthSvr. -> KAL DBSvr -> KAL MainSvr -> HackShield.

Have fun :D

Available in game commands:

Admin:

 /status       | Show Max. and Cur. connection
 /blocklist    | Show all blocked accounts
 /block name   | Block player account by name
 /unblock name | Unblock player account by name
 /protect val  | Set hack protect status (Val = enable/disable)
 /reload val   | Reload the configuration or BadWordList file (Val = config/badwordlist)
 /move2 name   | Move to the player (for move2 addon you need the MainSrv. 3 file)

 /report list  | Show all active user reports by report id, name and subject
 /report get val | Get a user report details by report id (val = Report ID)
 /report done val | Set a user report as done
 /report remove val | Remove the user report (val = Report ID)

Player:
 /online       | Show you how many player are online
 /i val        | Ignore the chat from player (val = help/list/add/del/clear)
 /report val   | User report system (val = subject/text/send :: /report help for more details)
