   <?php
$msconnect = mssql_connect("127.0.0.1","sa","123");
$msdb = mssql_select_db("kal_db", $msconnect);

$guild_query = mssql_query("SELECT [GID] FROM GuildCastle WHERE CID = 1");
$guild2 = mssql_fetch_array($guild_query);
$guildGID = $guild2[0];

$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$guildGID."'");
$guild2 = mssql_fetch_array($guild_query);
$guild = $guild2[0];
if($guild)
     echo "<font size=2 face=Agency FB><b>$guild</b></font>";
else
     echo "<font size=2 face=Agency FB><b>No one owns the castle.</b></font>";
?> 