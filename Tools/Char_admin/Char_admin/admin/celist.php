<?php include "ce.php"; ?>
<script>
function edit2(where,what,nick) {
	var f = document.fc2;
	if (where != 0) f.action = where;
   	if (what != 0) f.what.value = what;
   	if (nick != 0) f.cname.value = nick;
    f.submit();
}
function add(uid) {
	document.fc2.what.value = 'add';
	document.fc2.cname.value = prompt("name for char?");
	document.fc2.uid.value = uid;
	document.fc2.submit();
}

</script>
<form name="fc2" method="post" action='cechar.php'>
<input type="hidden" name="cname">
<input type="hidden" name="what">
<input type="hidden" name="uid">
</form>
<center>
<p></p><table cellpadding="3"><tr>
	<th><input type="button" onclick="edit2('<?php echo $_SERVER['PHP_SELF']; ?>','UID',0)" value="Account"></th>
	<th><input type="button" onclick="edit2('<?php echo $_SERVER['PHP_SELF']; ?>',0,0)" value="Name"></th>
	<th>Class</th>
	<th>Job</th>
	<th><input type="button" onclick="edit2('<?php echo $_SERVER['PHP_SELF']; ?>','Level',0)" value="Level"></th>
	<th></th>

	<th></th>
	<th></th></tr>
<?php
include "../config.php";
include "../data/classes.php";
include "../data/jobs.php";

//load accs
$tmp = mssql_select_db("kal_auth", $cid);
$qr = mssql_query("SELECT UID,ID FROM Login", $cid);
while (list($uid,$id) = mssql_fetch_row($qr)) {
	$acc[$uid] = $id;
}

if (!$order = $_POST['what'])
	$order = "Name";

$tmp = mssql_select_db("kal_db", $cid);
$qr = mssql_query("SELECT UID,Admin,Name,Class,Specialty,Level FROM Player ORDER BY $order", $cid);

if ($order != "UID")
	while (list($uid,$admin,$name,$class,$job,$lvl) = mssql_fetch_row($qr)) {
		echo "<tr><td>$acc[$uid]</td><td>";
		if ($admin == "8")	{	echo "<b>$name</b>";	}
		else 				{	echo "$name";	}
		echo "</td>
<td>$dclass[$class]</td>
<td>".$djob[$class][$job]."</td>
<td align='right'>$lvl</td>
<form name='fadd' method='post' action='cechar.php'>
<input type='hidden' name='cname'>
<input type='hidden' name='what' value='add'>
<input type='hidden' name='uid' value='$uid'>
</form>
<td><input type='button' onclick=\"add('$uid')\" value='add'></td>
<td><input type='button' onclick=\"edit2('cechar.php',0,'$name');\" value='char'></td>
<td><input type='button' onclick=\"edit2('ceskills.php',0,'$name');\" value='skills'></td>
</tr>";
	}
else //if ($order == "UID")
	while (list($uid,$admin,$name,$class,$job,$lvl) = mssql_fetch_row($qr)) {
		echo "<tr><td>"; 
		if ($uid != $u) {
			echo "$acc[$uid]";
			$u = $uid;
		}
		echo "</td><td>";
if ($admin == "8")	{	echo "<b>$name</b>";	}
else 				{	echo "$name";	}
echo "</td>
<td>$dclass[$class]</td>
<td>".$djob[$class][$job]."</td>
<td align='right'>$lvl</td>
<form name='fadd' method='post' action='cechar.php'>
<input type='hidden' name='cname'>
<input type='hidden' name='what' value='add'>
<input type='hidden' name='uid' value='$uid'>
</form>
<td><input type='button' onclick=\"add('$uid')\" value='add'></td>
<td><input type='button' onclick=\"edit2('cechar.php',0,'$name');\" value='char'></td>
<td><input type='button' onclick=\"edit2('ceskills.php',0,'$name');\" value='skills'></td>
</tr>";
	}

?>
</table>
</center>