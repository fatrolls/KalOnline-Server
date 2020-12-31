<?php include "ce.php"; ?>
<center>
<p></p><table><tr><th>CID</th><th>GID</th><th>Tax</th><th>TaxRate</th><th>GateLimit</th>
<?php
include "../config.php";
include "../data/gcastles.php";

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";

$tmp = mssql_select_db("kal_db", $cid);

//read all guild names
$qr = mssql_query("SELECT GID,Name FROM Guild", $cid);
while (list($ggid,$gname) = mssql_fetch_row($qr)) {
	$gids[$ggid] = $gname;
}

echo "<form method='post'><th>
<input type='hidden' name='what' value='add'>
<input type='submit' value='add'>
</th></form>
</tr>";

if ($_POST['what'] == 'add') {
	$qr = mssql_query("INSERT INTO GuildCastle (CID,GID,Tax,TaxRate,GateLimit) VALUES (0,0,100,100,100)", $cid);
}
else if ($_POST['what'] == 'upd') {
	$qr = mssql_query("UPDATE GuildCastle SET CID=".$_POST['cid'].",GID=".$_POST['gid'].",Tax=".$_POST['tax'].",TaxRate=".$_POST['taxr'].",
GateLimit=".$_POST['gatel']." WHERE CID=".$_POST['ocid']." AND GID=".$_POST['ogid'], $cid);
}

$qr = mssql_query("SELECT CID,GID,Tax,TaxRate,GateLimit FROM GuildCastle", $cid);
while (list($cid,$gid,$tax,$taxr,$gatel) = mssql_fetch_row($qr)) {
	
	echo "<form method='post'><tr><td>
<input type='hidden' name='ocid' value='$cid'>
<select name='cid' ><option value='0'>-</option>\n";
foreach ($dgcastle as $id => $name) {
	if ($id != 'c') {
		echo "<option value='$id'";
		if ($id == $cid) {
			echo " selected";
		}
		echo ">$name</option>\n";
	}
}
echo "</select>\n";
	echo "</td><td>
<input type='hidden' name='ogid' value='$gid'>
<select name='gid' ><option value='0'>-</option>\n";
foreach ($gids as $id => $name) {
	echo "<option value='$id'";
	if ($id == $gid) {
		echo " selected";
	}
	echo ">$name</option>\n";
}
echo "</select>\n";
	echo "</td><td><input type='text' name='tax' value='$tax'></td>
<td><input type='text' name='taxr' value='$taxr'></td>
<td><input type='text' name='gatel' value='$gatel'></td>
<input type='hidden' name='what' value='upd'>
<td><input type='submit' value='update'></td></tr>
</form>";

}

?>

</table>
</center>
