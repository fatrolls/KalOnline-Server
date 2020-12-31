<?php include "ce.php"; ?>
<center>
<p></p><table cellpadding="3"><tr><th>Player Name</th><th>Player Status</th><th></th><th></th></tr>
<?php
include "../config.php";
include "../data/gmclass.php";

$tmp = mssql_select_db("kal_db", $cid);

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";

$qr = mssql_query("SELECT GID,Name FROM Guild WHERE Name='".$_POST['gname']."'", $cid);  //get gid from gname
if (list($gid,$gname) = mssql_fetch_row($qr)) {
	$qr2 = mssql_query("SELECT PID,Class FROM GuildMember WHERE GID='$gid'", $cid);
	while (list($pid,$class) = mssql_fetch_row($qr2)) {
		echo "<tr>
<td>";
$qr = mssql_query("SELECT Name FROM Player WHERE PID='$pid'", $cid);
if (list($name) = mssql_fetch_row($qr)) {
	echo "$name";
}
echo "</td>
<td>$dgmclass[$class]</td>
<form method='post' action='cechar.php'><input type='hidden' name='cname' value='$name'><td><input type='submit' value='char'></td></form>
<form method='post' action='ceskills.php'><input type='hidden' name='cname' value='$name'><td><input type='submit' value='skills'></td></form>
</form>
</tr>";
	} 
}
?>
</table>
</center>



