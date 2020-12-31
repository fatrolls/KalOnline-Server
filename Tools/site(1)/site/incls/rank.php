<table width="440" align="center">
<tr>
<td>
<center><a href="?site=ranking">Show All</a> - <a href="?site=ranking&amp;show=knight">Show Knights</a> - <a href="?site=ranking&amp;show=mage">Show Mages</a> - <a href="?site=ranking&amp;show=archer">Show Archers</a> - <a href="?site=ranking&amp;show=admin">Show Admins</a></center><br />
<table width="440" cellspacing="0" border="1" style="border-collapse: collapse; border: 1px solid #999999;"> 
<tr> 
<td width="40" class="style6"><b>Rank</b></td><td width="175" class="style6"><b>Name</b></td><td width="60" class="style6"><b>Class</b></td>
<td width="40" class="style6"><b>Level</b><td width="150" class="style6"><b>Guild</b></td></tr>
<?
mssql_select_db("kal_db");
if ($_GET['show']  == ""){
$top = 1;
$query = mssql_query("SELECT TOP 50 * FROM [Player] WHERE [Admin] = 0 ORDER by [Level] DESC, [Exp] DESC");
while($r = mssql_fetch_array($query)){
$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$r['GID']."'"); 
$guild2 = mssql_fetch_array($guild_query); 
$guild = $guild2[0]; 

if($guild == "") 
{ 
$guild = "-"; 
} 
if($r['Class'] == 0){
$class = "Knight";
} else if($r['Class'] == 1){
$class = "Mage";
} else if($r['Class'] == 2){
$class = "Archer";
}
echo '<tr><td class="d_red"><center>'.$top.'</center></td><td class="d_blue"><a href="?site=profile&amp;id='.$r['PID'].'">'.$r['Name'].'</a></td><td class="d_blue">'.$class.'</td><td class="d_blue">'.$r['Level'].'</td><td class="d_blue">'.$guild.'</td></tr>
';
$top++;
}
} else if ($_GET['show']  == "knight"){



$top = 1;
$query = mssql_query("SELECT TOP 100 * FROM [Player] WHERE [Class] = 0 AND [Admin] = 0 ORDER by [Level] DESC, [Exp] DESC");
while($r = mssql_fetch_array($query)){
$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$r['GID']."'"); 
$guild2 = mssql_fetch_array($guild_query); 
$guild = $guild2[0]; 

if($guild == "") 
{ 
$guild = "-"; 
} 
if($r['Class'] == 0){
$class = "Knight";
} else if($r['Class'] == 1){
$class = "Mage";
} else if($r['Class'] == 2){
$class = "Archer";
}
echo '<tr><td><center>'.$top.'</center></td><td><a href="?site=profile&amp;id='.$r['PID'].'">'.$r['Name'].'</a></td><td>'.$class.'</td><td>'.$r['Level'].'</td><td>'.$guild.'</td></tr>
';
$top++;
}



} else if ($_GET['show']  == "mage"){


$top = 1;
$query = mssql_query("SELECT TOP 100 * FROM [Player] WHERE [Class] = 1 AND [Admin] = 0 ORDER by [Level] DESC, [Exp] DESC");
while($r = mssql_fetch_array($query)){
$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$r['GID']."'"); 
$guild2 = mssql_fetch_array($guild_query); 
$guild = $guild2[0]; 

if($guild == "") 
{ 
$guild = "-"; 
} 
if($r['Class'] == 0){
$class = "Knight";
} else if($r['Class'] == 1){
$class = "Mage";
} else if($r['Class'] == 2){
$class = "Archer";
}
echo '<tr><td><center>'.$top.'</center></td><td><a href="?site=profile&amp;id='.$r['PID'].'">'.$r['Name'].'</a></td><td>'.$class.'</td><td>'.$r['Level'].'</td><td>'.$guild.'</td></tr>
';
$top++;
}


} else if ($_GET['show']  == "archer"){


$top = 1;
$query = mssql_query("SELECT TOP 100 * FROM [Player] WHERE [Class] = 2 AND [Admin] = 0 ORDER by [Level] DESC, [Exp] DESC");
while($r = mssql_fetch_array($query)){
$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$r['GID']."'"); 
$guild2 = mssql_fetch_array($guild_query); 
$guild = $guild2[0]; 

if($guild == "") 
{ 
$guild = "-"; 
} 
if($r['Class'] == 0){
$class = "Knight";
} else if($r['Class'] == 1){
$class = "Mage";
} else if($r['Class'] == 2){
$class = "Archer";
}
echo '<tr><td><center>'.$top.'</center></td><td><a href="?site=profile&amp;id='.$r['PID'].'">'.$r['Name'].'</a></td><td>'.$class.'</td><td>'.$r['Level'].'</td><td>'.$guild.'</td></tr>
';
$top++;
}


} else if ($_GET['show']  == "admin"){


$top = 1;
$query = mssql_query("SELECT TOP 100 * FROM [Player] WHERE [Admin] = 8 OR [Admin] = 11 ORDER by [Level] DESC, [Exp] DESC");
while($r = mssql_fetch_array($query)){
$guild_query = mssql_query("SELECT [Name] FROM Guild WHERE GID = '".$r['GID']."'"); 
$guild2 = mssql_fetch_array($guild_query); 
$guild = $guild2[0]; 

if($guild == "") 
{ 
$guild = "-"; 
} 
if($r['Class'] == 0){
$class = "Knight";
} else if($r['Class'] == 1){
$class = "Mage";
} else if($r['Class'] == 2){
$class = "Archer";
}
echo '<tr><td><center>'.$top.'</center></td><td><a href="?site=profile&amp;id='.$r['PID'].'">'.$r['Name'].'</a></td><td>'.$class.'</td><td>'.$r['Level'].'</td><td>'.$guild.'</td></tr>
';
$top++;
}


}
?>  
	
</td>
</tr>
</table>
</td>
</tr>
</table><br />