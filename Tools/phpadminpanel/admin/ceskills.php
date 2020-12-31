<?php include "ce.php"; ?>
<center>
<p></p><table cellpadding="3"><form method="post">
<?php 
include "../config.php";
include "../data/skills.php";
include "../data/jobs.php";

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";

if ($_POST['cname']) { // load n show
	// data cname=charactername
	$tmp = mssql_select_db("kal_db", $cid);
	if ($_POST['class']) { //load n save changes
		//data in post: cname=Z class=Y pid=X N=on/off/nil 1N=lvl/nil M=on/off/nil 1M=lvl/nil ...
		//find skills already gotten
		$qr = mssql_query("SELECT * FROM Skill WHERE PID='".$_POST['pid']."'", $cid);
		while (list($pid,$index,$level) = mssql_fetch_row($qr)) {
			$sg[$index] = $level;
		}
		$pid = $_POST['pid'];
		$sdc = 5 + $_POST['class'];
		foreach($_POST as $i => $v) {
			if (($i != "pid") && ($i != "class")) {
				if ($i < 200) {
					//$c = $i; //POST index to checkbox
					$l = $i + 100; //POST index to level
					$i -= 100; //real index
					//$v = $v //checkbox state on/nil
					$w = $_POST[$l]; //level
					
					if ($v == 'on') { //checkbox checked
						if (!$sg[$i]) { //add //no lvl in db
							if (!$w) 
								$w = 1;
							$qr = mssql_query("INSERT INTO Skill VALUES ($pid,$i,$w)", $cid);
						}
						else if ($sg[$i] != $w) { //level changed //lvl in db different to level here
							if ($w && is_numeric($w)) {
								$qr = mssql_query("UPDATE Skill SET Level='$w' WHERE PID='$pid' AND [Index]='$i'", $cid);
							}
						}
					}
				} else {
					$c = $i - 100;
					//$l = $i;
					$i -= 200;
					//$w = $v;
					$v = $_POST[$c];
					
					if (($v != 'on') && $sg[$i]) { //del //unchecked AND level in db
						$qr = mssql_query("DELETE FROM Skill WHERE PID='$pid' AND [Index]='$i'", $cid);
					}
				}
			}
		}
	}	
	
	
	
	
	//find char
	$qr = mssql_query("SELECT PID,Name,Class FROM Player WHERE Name='".$_POST['cname']."'", $cid);
	if (list($pid,$name,$class) = mssql_fetch_row($qr)) {
		echo "<input type='hidden' name='cname' value='".$_POST['cname']."'> 
<input type='hidden' name='class' value='$class'> 
<input type='hidden' name='pid' value='$pid'>\n";
		//find skills already gotten
		$qr = mssql_query("SELECT * FROM Skill WHERE PID='$pid'", $cid);
		unset($sg);
		while (list($pid,$index,$level) = mssql_fetch_row($qr)) {
			$sg[$index] = $level;
		}
		echo "<tr><th></th><th>Name</th><th>Job</th><th>Required Level</th><th>Skill Level</th><th>Max Skill Level</th></tr>";
		for ($i=0; $i<=$dskill[$class]['c']; $i++) {
			if (!is_null($dskill[$class][$i])) {
				$j = $i + 100;
				$k = $i + 200;
				echo "<tr><td><input type='checkbox' name='$j' "; if ($sg[$i]) echo "checked"; echo "></td><td>".$dskill[$class+5][$i]." </td>\t<td>".$djob[$class][$dskill[$class+15][$i]]."</td>\t<td align='center'>".$dskill[$class+10][$i]."</td>\t<td><input type='text' name='$k' value='$sg[$i]'></td><td>/ ".$dskill[$class][$i]."</td></tr>\n";
			}
		}
		echo "<tr><td align='right' colspan='6'><input type='submit' value='Update'></td></tr>";
	} else {
		echo "ERROR: character not found! case sensitivity counts!<br>";
	}	
}
else 
?>
</form></td></tr></table></center>