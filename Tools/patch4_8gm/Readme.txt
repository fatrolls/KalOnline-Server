

I wrote some functions for handing new GM commands. 

Functions are:

- /addotp NUMER (2Bytes value)
- /addevasion NUMBER (2Bytes value)
- /addabsorb NUMBER (1Byte value)
- /addresist NUMBER (1Byte value)
- /warbegin - starts guildwar (if proclaimed)
- /warend - finish guildwar
- /declare - turn on possibility of proclaiming guildwar. Notice is displayed.
- /buffoff - turnoff your assassin mask and some buffs like speed, party buffs.



Important!
==========

* If you enter /declare and npc says 'not time for declare...', retype /declare and everything will be fine.

* /warbegin starts war only when leaders proclaim the guildwar as usually ! So war begins if you declare war by hand in guildwar table. Remember - modify gulildwar table only when server is offline ! Running server can't see online table modification!


if u want to run many wars one by one you can do this way:
==========================================================
1) /declare (guildleaders can declare war now)
2) /warbegin (war started if leader(s) declared war)
3) /warend (finish guildwar)
4) /declare (guildleaders can declare war now)
5) /warbegin (war started if leader(s) declared war)
6) /warend (finish guildwar)
...........
...........and again, again...

Tested only on short guildwars :P

2) Installation:
================

Copy patch to mainsvrt.exe server folder, apply (server must be off, mainsvrt.exe will be written) , enjoy!

You can apply this patch also, when older version was applied. There is no need to install previous versions of patch.

Mar 