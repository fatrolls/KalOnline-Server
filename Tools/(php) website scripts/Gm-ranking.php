<center>
<h1 class="style1"> Ranking </h1>
<?php
	$msconnect = mssql_connect("127.0.0.1","sa","");
	$msdb = mssql_select_db("kal_db", $msconnect);
	$plist = "SELECT TOP 100 Name,Class,Level FROM [Player] WHERE Admin = '11' AND Level > '0' ORDER BY Level DESc LIMIT 8,11";

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
	echo $list['Name'];
	echo "</td>";	
	echo "<td width='5%'>";
	echo $char;
	echo "</td>";
	echo "<td width='5%'>";
	echo $list['Level'];
	echo "</td></tr><tr>";
	}
	echo "</tr></table>";
?>
</center><br><br>
<a href="http://www.kalxtreme.com">Back</a>