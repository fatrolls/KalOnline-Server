<?php include "ce.php"; ?>
<center>
<p></p><table><form name='fchar' method="post">
<?php
include "../config.php"; 

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";


if ($_POST['gname']) {
	$tmp = mssql_select_db("kal_db", $cid);
	if ($_POST['what'] == 'add') {
		$qr = mssql_query("SELECT Name FROM Guild WHERE Name='".$_POST['gname']."'");
		if (mssql_num_rows($qr) != 0) {
			echo "ERROR: a guild with that name already exists<br>";
		}
		else {
			$mgid = 100000;
			//$qr = mssql_query("INSERT INTO GuildAlliance (GID1,Date) VALUES (".$_POST['gid'].",".time().")", $cid);
			$qr = mssql_query("SELECT MAX(GID) FROM Guild", $cid);
			if ($r = mssql_fetch_row($qr))
				$mgid = $r[0];
			if ($mgid < 100000)
				$mgid = 100000;
			$mgid++;
			$qr = mssql_query("INSERT INTO Guild (GID,Name,Standard,Exp,SubLeaderAble,CenturionAble,TenAble,RegularAble,TempAble,AID)
			VALUES ($mgid,'".$_POST['gname']."',0,0,0,0,0,0,0,0)", $cid);
		}
	}
	else if ($_POST['what'] == 'upd') {
		/*	kinda not needed coz UPDATE with no values sets them to 0
			if (is_null($_POST['gid']) || is_null($_POST['name']) || is_null($_POST['std']) || is_null($_POST['exp'])
				 || is_null($_POST['sleada']) || is_null($_POST['centa']) || is_null($_POST['tena']) || is_null($_POST['regua'])
				 || is_null($_POST['tempa']) || is_null($_POST['aid'])) {
			echo "ERROR: a needed field is empty<br>";
		}
		else {*/
			$fail = 0;
			if ($_POST['ogid'] != $_POST['gid']) { //also update all old GIDs in all Guild* and Player
				if ($_POST['gid']) {
					//check if gid doesnt already exist
					$qr = mssql_query("SELECT GID FROM Guild WHERE GID='".$_POST['gid']."'", $cid);
					if (mssql_num_rows($qr) != 0) {
						$fail = 1;
						echo "ERROR: guild id already in use<br>";
					} else {
						$qr = mssql_query("UPDATE GuildAlliance SET GID1='".$_POST['gid']."' WHERE GID1='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID2='".$_POST['gid']."' WHERE GID2='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID3='".$_POST['gid']."' WHERE GID3='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID4='".$_POST['gid']."' WHERE GID4='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID5='".$_POST['gid']."' WHERE GID5='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID6='".$_POST['gid']."' WHERE GID6='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID7='".$_POST['gid']."' WHERE GID7='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildAlliance SET GID8='".$_POST['gid']."' WHERE GID8='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildCastle SET GID='".$_POST['gid']."' WHERE GID='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildMember SET GID='".$_POST['gid']."' WHERE GID='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE GuildWar SET GID='".$_POST['gid']."' WHERE GID='".$_POST['ogid']."'", $cid);
						$qr = mssql_query("UPDATE Player SET GID='".$_POST['gid']."' WHERE GID='".$_POST['ogid']."'", $cid);
					}
				}
			}
			if ($fail == 0) {
				$qr = mssql_query("UPDATE Guild SET GID='".$_POST['gid']."',Name='".$_POST['name']."',Standard='".$_POST['std']."',Exp='".$_POST['exp']."', 
TodayMessage='".$_POST['msg']."',Leader='".$_POST['lead']."',SubLeader='".$_POST['slead']."',Centurion='".$_POST['cent']."',Ten='".$_POST['ten']."',
Regular='".$_POST['regu']."',[Temp]='".$_POST['temp']."',SubLeaderAble='".$_POST['sleada']."',CenturionAble='".$_POST['centa']."',TenAble='".$_POST['tena']."',
RegularAble='".$_POST['regua']."',TempAble='".$_POST['tempa']."',AID='".$_POST['aid']."' WHERE Name='".$_POST['gname']."'
", $cid);
			}
		//}
	}
	$qr = mssql_query("SELECT GID,Name,Standard,Exp, TodayMessage,Leader,SubLeader,Centurion,Ten,Regular,[Temp], 
	SubLeaderAble,CenturionAble,TenAble,RegularAble,TempAble,AID FROM Guild WHERE Name='".$_POST['gname']."'", $cid);
	if (list($gid,$name,$std,$exp, $msg,$lead,$slead,$cent,$ten,$regu,$temp, $sleada,$centa,$tena,$regua,$tempa,$aid) = mssql_fetch_row($qr)) {
		echo "<tr>
<input type='hidden' name='gname' value='$name'>
<td>Name:</td><td><input type='text' name='name' value='$name'></td><td></td>
<td>Guild Level</td><td><input type='text' name='std' value='$std'></td><td></td>
<td>Exp:</td><td><input type='text' name='exp' value='$exp'></td>
</tr>\n
<tr><input type='hidden' name='ogid' value='$gid'>
<td>Guild ID:</td><td><input type='text' name='gid' value='$gid'></td><td></td>
<td>Alliance ID</td><td><input type='text' name='aid' value='$aid'></td>
</tr>\n
<tr>
<td>Today Message*</td><td colspan='7' align='center'><textarea cols='80' rows='2' wrap='soft' name='msg'>$msg</textarea></td>
</tr>
<tr>
<td>Leader*</td><td><input type='text' name='lead' value='$lead'></td><td></td>
</tr>
<tr>
<td>SubLeader*</td><td><input type='text' name='slead' value='$slead'></td><td></td>
<td>SubLeader Able</td><td><input type='text' name='sleada' value='$sleada'></td><td></td>
</tr>\n
<tr>
<td>Centurion*</td><td><input type='text' name='cent' value='$cent'></td><td></td>
<td>Centurion Able</td><td><input type='text' name='centa' value='$centa'></td><td></td>
</tr>\n
<tr>
<td>Ten*</td><td><input type='text' name='ten' value='$ten'></td><td></td>
<td>Ten Able</td><td><input type='text' name='tena' value='$tena'></td><td></td>
</tr>\n
<tr>
<td>Regular*</td><td><input type='text' name='regu' value='$regu'></td><td></td>
<td>Regular Able</td><td><input type='text' name='regua' value='$regua'></td><td></td>
</tr>\n
<tr>
<td>Temp*</td><td><input type='text' name='temp' value='$temp'></td><td></td>
<td>Temp Able</td><td><input type='text' name='tempa' value='$tempa'></td><td></td>
</tr>\n
<tr><input type='hidden' name='what' value='upd'>  <td colspan='6'>* field may be empty</td><td align='right' colspan='2'><input type='submit' value='update'></td></tr>";
	} else echo "ERROR: guild doesnt exist. try case sensitiv.<br>";
	
	
}

?>
</form></table>
</center>