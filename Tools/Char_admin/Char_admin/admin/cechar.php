<?php
include "ce.php";
?>

<script>
function calcstats() {
    f = document.fchar;
    f.pu.value = f.lvl.value * 5;
    if (f.klass.value == 0) {
        f.str.value = 18;
        f.hth.value = 16;
        f.int.value = 8;
        f.wis.value = 8;
        f.agi.value = 10;
    }
    else if (f.klass.value == 1) {
        f.str.value = 8;
        f.hth.value = 10;
        f.int.value = 18;
        f.wis.value = 16;
        f.agi.value = 8;
    }
    else if (f.klass.value == 2) {
        f.str.value = 14;
        f.hth.value = 10;
        f.int.value = 8;
        f.wis.value = 10;
        f.agi.value = 18;
    }
}
function gedit() {
	if (document.fchar.gid.value != 0) {
		document.fgedit.gname.value = document.fchar.gid.options[document.fchar.gid.selectedIndex].text;
		document.fgedit.submit();
	}
}
</script>
<form name='fgedit' method='post' action='guildedit.php'>
	<input type='hidden' name='gname' value=''>
</form>
<center>
<p></p><table><form name='fchar' method="post">
<?php 	
include "../config.php";
include "../data/admin.php";
include "../data/classes.php";
include "../data/grole.php";
include "../data/jobs.php";
include "../data/revival.php";
include "../data/gmclass.php";

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";
if ($_POST['cname']) {
    $tmp = mssql_select_db("kal_db", $cid);
    if ($_POST['name']) { //save changes // update
        $qr = mssql_query("UPDATE Player SET UID='".$_POST['uid']."',Admin='".$_POST['admin']."',Name='".$_POST['cname']."',Class='".$_POST['klass']."',Specialty='".$_POST['job']."',
Level='".$_POST['lvl']."',Contribute='".$_POST['con']."',Exp='".$_POST['exp']."',GID='".$_POST['gid']."',GRole='".$_POST['grole']."',
Strength='".$_POST['str']."',Health='".$_POST['hth']."',Intelligence='".$_POST['int']."',Wisdom='".$_POST['wis']."',Dexterity='".$_POST['agi']."',
CurHP='".$_POST['chp']."',CurMP='".$_POST['cmp']."',PUPoint='".$_POST['pu']."',SUPoint='".$_POST['su']."',Killed='".$_POST['died']."',
Map='".$_POST['map']."',X='".$_POST['x']."',Y='".$_POST['y']."',Z='".$_POST['z']."',Face='".$_POST['face']."',Hair='".$_POST['hair']."',
RevivalId='".$_POST['rev']."',Rage='".$_POST['rage']."' WHERE Name='".$_POST['name']."'", $cid);

        if ($_POST['gid'] != 0) { //look if char needs to be (added to/updated in/deleted from) table GuildMember
            $qr = mssql_query("SELECT GID,PID FROM GuildMember WHERE GID='".$_POST['gid']."' AND PID='".$_POST['pid']."'", $cid);
            if (mssql_num_rows($qr) == 0) {
                $qr = mssql_query("INSERT INTO GuildMember (GID,PID,Class,ConnectTell,Date) VALUES (".$_POST['gid'].",".$_POST['pid'].",".$_POST['gmclass'].",1,0)", $cid);
            }
            if ($_POST['ogmclass'] != $_POST['gmclass']) {
                $qr = mssql_query("UPDATE GuildMember SET Class='".$_POST['gmclass']."' WHERE GID='".$_POST['gid']."' AND PID='".$_POST['pid']."'", $cid);
            }
        }
        else {
            $qr = mssql_query("DELETE FROM GuildMember WHERE GID='".$_POST['ogid']."' AND PID='".$_POST['pid']."'", $cid);
        }
    }
    else if ($_POST['what'] == 'add') { 
    	$uid = $_POST['uid'];
    	if (!$uid) { //get uid from acc id if it isnt given
    		if ($_POST['acc']) {
    			$tmp = mssql_select_db("kal_auth", $cid);
        		$qr = mssql_query("SELECT UID FROM Login WHERE ID='".$_POST['acc']."'", $cid);
        		if ($acc = mssql_fetch_row($qr)) {
        			$uid = $acc[0];
        		}
        		else {
        			echo "ERROR: no account has that name as id. try case sensitiv.<br>";
        			exit;
        		}
    		}
    		else {
    			echo "ERROR: got no account name nor uid.<br>";
    			exit;
    		}
    	}
    	$tmp = mssql_select_db("kal_db", $cid);
    	$qr = mssql_query("SELECT UID FROM Player WHERE UID='$uid'", $cid);
    	if (mssql_num_rows($qr) < 3) { //check if already 3 chars exist
    		$qr = mssql_query("SELECT Name FROM Player WHERE Name='".$_POST['cname']."'", $cid);
    		if (mssql_num_rows($qr) == 0) { //check if name not already in use
				$qr = mssql_query("INSERT INTO Player (UID,Admin,Name,Class,Specialty, Level,Contribute,Exp,GID,GRole, 
Strength,Health,Intelligence,Wisdom,Dexterity, CurHP,CurMP,PUPoint,SUPoint,Killed, Map,X,Y,Z,Face, Hair,RevivalId,Rage)
VALUES ($uid,0,'".$_POST['cname']."',0,1, 1,0,0,0,0, 1,1,1,1,1, 1,1,1,1,0, 0,266296,255562,18387,1, 1,0,0)", $cid);
			} else echo "ERROR: name already in use<br>";
		} else {
			echo "ERROR: account has already 3 characters<br>";
			exit;
		}
	}
	echo "<tr>
<td>Account:</td><td>";
    //get char data
    $qr = mssql_query("SELECT UID,PID,Admin,Name,Class,Specialty,Level,Contribute,Exp,GID,GRole,Strength,Health,Intelligence,Wisdom,Dexterity,CurHP,CurMP,PUPoint,SUPoint,Killed,Map,X,Y,Z,Face,Hair,RevivalId,Rage FROM Player WHERE Name='".$_POST['cname']."'", $cid);
    if (list($uid,$pid,$admin,$name,$klass,$job,$lvl,$con,$exp,$gid,$grole,$str,$hth,$int,$wis,$agi,$chp,$cmp,$pu,$su,$died,$map,$x,$y,$z,$face,$hair,$rev,$rage) = mssql_fetch_row($qr)) {
        
        $tmp = mssql_select_db("kal_auth", $cid); //get acc id from uid
        $qr = mssql_query("SELECT ID FROM Login WHERE UID='$uid'", $cid);
        if (!$acc = mssql_fetch_row($qr)) //if id found
        	echo "UNKNOWN UID (not account ID)<br><input type='text' name='uid' value='$uid'>";
        else
        	echo "$acc[0]<input type='hidden' name='uid' value='$uid'>";
		echo "</td><td></td>
<input type='hidden' name='name' value='$name'>"; //old name in case it is changed so to find which line to update
echo "
<td>Char Name:</td><td><input type='text' name='cname' value='$name'></td><td></td>
<td>Player ID:</td><td><input type='text' name='pid' value='$pid' readonly></td>
</tr>

<tr>
<td>Admin:</td><td><select name='admin'>";
for ($i=0; $i<=$dadmin['c']; $i++) {
    if (!is_null($dadmin[$i])) {
        echo "<option value='$i'";
        if ($i == $admin) echo " selected";
        echo ">".$dadmin[$i]."</option>";
    }
}
echo "</select></td><td></td>
<input type='hidden' name='ogid' value='$gid'>
<td>Guild ID:</td><td><select name='gid'><option value='0'";
$tmp = mssql_select_db("kal_db", $cid);
$qr = mssql_query("SELECT GID,Name FROM Guild", $cid);
if (mssql_num_rows($qr) > 0) {
    if ($gid == 0) echo " selected";
    echo ">-</option>\n";
    while (list($ggid,$gname) = mssql_fetch_row($qr)) {
        echo "<option value='$ggid'";
        if ($ggid == $gid) echo " selected";
        echo ">$gname</option>";
    } 
} else echo " selected>-</option>";
echo "</select>
<input type='hidden' name='ogmclass' value='$gmclass'>
<select name='gmclass'>";
if ($gid != 0) { //has guild so find out his class (leader,member...)
    $qr = mssql_query("SELECT GID,PID,Class FROM GuildMember WHERE GID='$gid' AND PID='$pid'", $cid);
    list($gmgid,$gmpid,$gmclass) = mssql_fetch_row($qr);
}
for ($i=0; $i<=$dgmclass['c']; $i++) {
    if (!is_null($dgmclass[$i])) {
        echo "<option value='$i'";
        if ($i == $gmclass) echo " selected";
        echo ">".$dgmclass[$i]."</option>";
    }
}
echo "</select> <input type='button' onclick='gedit()' value='edit'></td><td></td>
<td>Guild Role:</td><td><select name='grole'>";
for ($i=0; $i<=$dgrole['c']; $i++) {
    if (!is_null($dgrole[$i])) {
        echo "<option value='$i'";
        if ($i == $grole) echo " selected";
        echo ">".$dgrole[$i]."</option>";
    }
}
echo "</select></td>
</tr>

<tr>
<td>Class:</td><td><select name='klass'>";
for ($i=0; $i<=$dclass['c']; $i++) {
    if (!is_null($dclass[$i])) {
        echo "<option value='$i'";
        if ($i == $klass) echo " selected";
        echo ">".$dclass[$i]."</option>";
    }
}
echo "</select></td><td></td>
<td>Job:</td><td><select name='job'>";
for ($i=0; $i<=$djob[$klass]['c']; $i++) {
    if (!is_null($djob[$klass][$i])) {
        echo "<option value='$i'";
        if ($i == $job) echo " selected";
        echo ">".$djob[$klass][$i]."</option>";
    }
}
echo "</select></td><td></td>
<td>Died:</td><td><input type='text' name='died' value='$died'></td>
</tr>

<tr>
<td>Level:</td><td><input type='text' name='lvl' value='$lvl'></td><td></td>
<td>Exp:</td><td><input type='text' name='exp' value='$exp'></td><td></td>
<td>Contribution:</td><td><input type='text' name='con' value='$con'></td>
</tr>

<tr>
<td>Strength:</td><td><input type='text' name='str' value='$str'></td><td></td>
<td>Current HP:</td><td><input type='text' name='chp' value='$chp'></td><td></td>
<td>Revival:</td><td><select name='rev'>";
for ($i=0; $i<=$drevival['c']; $i++) {
    if (!is_null($drevival[$i])) {
        echo "<option value='$i'";
        if ($i == $rev) echo " selected";
        echo ">".$drevival[$i]."</option>";
    }
}
echo "</select></td>
</tr>

<tr>
<td>Health:</td><td><input type='text' name='hth' value='$hth'></td><td></td>
<td>Current MP:</td><td><input type='text' name='cmp' value='$cmp'></td><td></td>
<td>Map:</td><td><input type='text' name='map' value='$map'></td>
</tr>

<tr>
<td>Intelligence:</td><td><input type='text' name='int' value='$int'></td><td></td>
<td>Points:</td><td><input type='text' name='pu' value='$pu'></td><td></td>
<td>X:</td><td><input type='text' name='x' value='$x'></td>
</tr>

<tr>
<td>Wisdom:</td><td><input type='text' name='wis' value='$wis'></td><td></td>
<td>Skill Points:</td><td><input type='text' name='su' value='$su'></td><td></td>
<td>Y:</td><td><input type='text' name='y' value='$y'></td>
</tr>

<tr>
<td>Agility:</td><td><input type='text' name='agi' value='$agi'></td><td></td>
<td>Rage:</td><td><input type='text' name='rage' value='$rage'></td><td></td>
<td>Z:</td><td><input type='text' name='z' value='$z'></td>
</tr>

<tr>
<td>Face:</td><td><input type='text' name='face' value='$face'></td><td></td>
<td>Hair:</td><td><input type='text' name='hair' value='$hair'></td><td></td>
<td colspan='2'><input type='button' value='calc stats for given level and class' onclick='calcstats()'> <input type='submit' value='update'></td>
</tr>";
        
    } else echo "ERROR: character not found. try case sensitiv.<br>";
}
?>
</form></table>
</center>
