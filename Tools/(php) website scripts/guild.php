<link rel="stylesheet" href="style.css" type="text/css">
<center>
<?php
	$msconnect = mssql_connect("127.0.0.1","sa","Password");
	$msdb = mssql_select_db("kal_db", $msconnect);
	$plist = "SELECT Name,Standard,Exp FROM [Guild] ORDER BY GID";
	$pplist = mssql_query($plist);

	echo "<table width='400' height='1'><tr valign='top'>";
	echo "<td width='5%'><b>Guild Name</b></td><td width='5%'><b>Level</b></td><td width='5%'><b>Guild EXP</b></td></tr><tr valign='top'>";

	while($list = mssql_fetch_array($pplist)){
	
	echo "<td width='5%'>";
	echo $list[Name];
	echo "</td>";	
	
	echo "<td width='5%'>";
	echo $list [Standard];
	echo "</td>";
	
	echo "<td width='5%'>";
	echo $list[Exp];
	echo "</td></tr><tr>";
	}
	echo "</tr></table>";
?>
</center>

<a href="index.php">Back</a>