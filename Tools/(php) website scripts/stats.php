<link rel="stylesheet" href="style.css" type="text/css">
<?



//fill your login & pass






		$msconnect = mssql_connect("127.0.0.1","sa","password");
		$msdb = mssql_select_db("kal_db", $msconnect);


		$q = "SELECT * FROM Player";
		$r = mssql_query($q);
		$sad = mssql_num_rows($r);
		echo "<div align=left>Total players: $sad";



		$q = "SELECT Class FROM Player WHERE Class = '0'";
		$r = mssql_query($q);
		$sad = mssql_num_rows($r);
		echo "<div align=left>Total Knights: $sad";



		$q = "SELECT Class FROM Player WHERE Class = '1'";
		$r = mssql_query($q);
		$sad = mssql_num_rows($r);
		echo "<div align=left>Total Mages: $sad";


		$q2 = "SELECT Class FROM Player WHERE Class = '2'";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total Archers: $sad2";

		$q2 = "SELECT * FROM Guild";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total Guilds: $sad2";

		$q2 = "SELECT * FROM GuildMember";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total GuildMembers: $sad2";

		$q2 = "SELECT * FROM GuildWar";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total GuildWars: $sad2";

		$q2 = "SELECT * FROM GuildAlliance";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total GuildAlliances: $sad2";

		$q2 = "SELECT * FROM GuildCastle";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total GuildCastles: $sad2";

		$q2 = "SELECT * FROM Item";
		$r2 = mssql_query($q2);
		$sad2 = mssql_num_rows($r2);
		echo "<div align=left>Total Items: $sad2";

?>
