<?php include "ce.php"; ?>
<center>
<p></p><table cellpadding="3><tr><th>GID</th><th>Guild Name</th><th></th><th></th></tr>
<?php
include "../config.php";

$tmp = mssql_select_db("kal_db", $cid);
$qr = mssql_query("SELECT GID,Name FROM Guild", $cid);
while (list($gid,$name) = mssql_fetch_row($qr)) {
	echo "<tr>
<td>$gid</td>
<td>$name</td>
<form method='post' action='guildedit.php'> <input type='hidden' name='gname' value='$name'><td><input type='submit' value='edit'></td></form>
<form method='post' action='guildmlist.php'> <input type='hidden' name='gname' value='$name'><td><input type='submit' value='members'></td></form>
</tr>";
} 

?>
</table>
</center>
