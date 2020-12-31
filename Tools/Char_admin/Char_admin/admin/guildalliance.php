<?php include "ce.php"; ?>
<center>
<p></p><table>
<?php
include "../config.php";

$tmp = mssql_select_db("kal_db", $cid);

$gid = $_POST['gid'];
if ($_POST['what'] == 'upd') {
	$gid = $_POST['gid1'];
	
	//look if already exist
	$qr = mssql_query("SELECT GID1 FROM GuildAlliance WHERE GID1='$gid'", $cid);
	if ($found = mssql_fetch_row($qr)) {
		$qr = mssql_query("UPDATE GuildAlliance SET GID1=".$_POST['gid1'].",GID2=".$_POST['gid2'].",GID3=".$_POST['gid3'].",GID4=".$_POST['gid4'].",
GID5=".$_POST['gid5'].",GID6=".$_POST['gid6'].",GID7=".$_POST['gid7'].",GID8=".$_POST['gid8']." WHERE GID1='$gid'", $cid);
//,Date=".time()."
	} else {
	$qr = mssql_query("INSERT INTO GuildAlliance (GID1,GID2,GID3,GID4,GID5,GID6,GID7,GID8,Date) 
VALUES (".$_POST['gid1'].",".$_POST['gid2'].",".$_POST['gid3'].",".$_POST['gid4'].",
".$_POST['gid5'].",".$_POST['gid6'].",".$_POST['gid7'].",".$_POST['gid8'].",".time().")", $cid);
	}
}
else if (!$gid) { //get gid by guild name
	$qr = mssql_query("SELECT GID FROM Guild WHERE Name='".$_POST['gname']."'", $cid);
	if ($gida = mssql_fetch_row($qr)) {
		$gid = $gida[0];
	}
	else {
		echo "ERROR: got no gid and no guild name<br>";
		exit;
	}
	
}

//load
$qr = mssql_query("SELECT GID1,GID2,GID3,GID4,GID5,GID6,GID7,GID8 FROM GuildAlliance
WHERE GID1='$gid' OR GID2='$gid' OR GID3='$gid' OR GID4='$gid' OR GID5='$gid' OR GID6='$gid' OR GID7='$gid' OR GID8='$gid'", $cid); 
if ($gids = mssql_fetch_row($qr)) { //$gid0-7
	//read all guild names
	unset($gid);	
	$qr = mssql_query("SELECT GID,Name FROM Guild", $cid);
	while (list($ggid,$gname) = mssql_fetch_row($qr)) {
		$gid[$ggid] = $gname;
	}
	
	echo "<form method='post'><input type='hidden' name='gname' value='".$_POST['gname']."'>\n
<tr><td>GID1</td><td>".$gid[$gids[0]]."<input type='hidden' name='gid1' value='$gids[0]'></td></tr>\n";
	for ($i=2; $i<9; $i++) {
		echo "<tr><td>GID$i</td><td><select name='gid$i' ><option value='0'>-</option>\n";
		foreach ($gid as $id => $name) {
			echo "<option value='$id'";
			if ($id == $gids[$i-1]) {
				echo " selected";
			}
			echo ">$name</option>\n";
		}
		echo "</select></td></tr>\n";
	}
	echo "<tr><td colspan='2' align='center'>
<input type='hidden' name='what' value='upd'>
<input type='submit' value='update'></td></tr></form>";
}
?>
</table>
</center>
