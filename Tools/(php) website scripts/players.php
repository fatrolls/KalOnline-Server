<link rel="stylesheet" href="style.css" type="text/css">
<center>
<?php
	$msconnect = mssql_connect("localhost");
	$msdb = mssql_select_db("kal_db", $msconnect);
	$plist = "SELECT * FROM Player ORDER BY [UID]";
	$pplist = mssql_query($plist);

	echo "<table width='400' height='1'><tr valign='top'>";
	echo "<td width='5%'><b>Name</b></td><td width='5%'><b>Class</b></td><td width='5%'><b>Level</b></td></tr><tr valign='top'>";

	while($list = mssql_fetch_array($pplist)){
	if($list['Class'] == "0"){
	$char = "Knight";
	}
	elseif($list['Class'] == "1"){
	$char = "Mage";
	}
	else
	$char = "Archer";
	echo "<td width='5%'>";
	echo $list[Name];
	echo "</td>";	
	echo "<td width='5%'>";
	echo $char;
	echo "</td>";
	echo "<td width='5%'>";
	echo $list[Level];
	echo "</td></tr><tr>";
	}
	echo "</tr></table>";
?>
</center>