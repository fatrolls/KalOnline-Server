<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Unbenanntes Dokument</title>
</head>
<?php
function passConvert($password)
{
	$encar = array('!'=>'95', '"'=>'88', '#'=>'9D', '$'=>'4C', '%'=>'F2', '&'=>'3E', '\''=>'BB', '('=>'C0', ')'=>'7F', '*'=>'18', '+'=>'70', ','=>'A6', '-'=>'E2', '.'=>'EC', '/'=>'77',
						'0'=>'2C', '1'=>'3A', '2'=>'4A', '3'=>'91', '4'=>'5D', '5'=>'7A', '6'=>'29', '7'=>'BC', '8'=>'6E', '9'=>'D4', ':'=>'40', ';'=>'17', '<'=>'2E', '='=>'CB', '>'=>'72', '?'=>'9C',
						'@'=>'A1', 'A'=>'FF', 'B'=>'F3', 'C'=>'F8', 'D'=>'9B', 'E'=>'50', 'F'=>'51', 'G'=>'6D', 'H'=>'E9', 'I'=>'9A', 'J'=>'B8', 'K'=>'84', 'L'=>'A8', 'M'=>'14', 'N'=>'38', 'O'=>'CE',
						'P'=>'92', 'Q'=>'5C', 'R'=>'F5', 'S'=>'EE', 'T'=>'B3', 'U'=>'89', 'V'=>'7B', 'W'=>'A2', 'X'=>'AD', 'Y'=>'71', 'Z'=>'E3', '['=>'D5', '\\'=>'BF', ']'=>'53', '^'=>'28', '_'=>'44',
						'`'=>'33', 'a'=>'48', 'b'=>'DB', 'c'=>'FC', 'd'=>'09', 'e'=>'1F', 'f'=>'94', 'g'=>'12', 'h'=>'73', 'i'=>'37', 'j'=>'82', 'k'=>'81', 'l'=>'39', 'm'=>'C2', 'n'=>'8D', 'o'=>'7D',
						'p'=>'08', 'q'=>'4F', 'r'=>'B0', 's'=>'FE', 't'=>'79', 'u'=>'0B', 'v'=>'D6', 'w'=>'23', 'x'=>'7C', 'y'=>'4B', 'z'=>'8E', '{'=>'06', '|'=>'5A', '}'=>'CC', '~'=>'62');

	$newpass = "0x";					  			
	for ($i = 0; $i < strlen($password); $i++)
	{
		$newpass .= $encar[$password[$i]];
	}					
	
	return $newpass;  
}

if ($_POST["gogogo"])
{
	$err = "";
	
	if (!$_POST["accname"]) $err .= "<font color='red'><b>Enter an ID <br>\n";
	if (!$_POST["accpass1"]) $err .= "<font color='red'><b>Enter an Password <br>\n";
	if (!$_POST["accpass2"]) $err .= "<font color='red'><b>Repeat Password <br>\n";
	
			
	
	if ($err == "")
	{
		if ($_POST["accpass1"] != $_POST["accpass2"])
			$err .= "<font color='red'><b>Passwords does not match! <br>\n";
	}
	
	if ($err == "")
	{
		// using standard windows authentication, whwn you use a password, use this line
		// $msconnect = mssql_connect("localhost", "sa", "pass");
		$msconnect = mssql_connect("localhost");
		$msdb = mssql_select_db("kal_auth", $msconnect);
		
		$cpass = passConvert($_POST["accpass1"]);
		$query = "INSERT INTO Login ([ID], [PWD], [Birth], [Type], [ExpTime]) VALUES('".$_POST["accname"]."', $cpass , '19190101', '0', '4000')";
		//echo $query;
		
		$acccreate = mssql_query($query);

		if ($acccreate)
		{		
			$uid = mssql_result(mssql_query("SELECT [UID] from Login WHERE [ID]='".$_POST["accname"]."'"),0,0);
				
			mssql_close() or die('failed closing mssql');

		

			//echo $query;
			
	
			$_POST["accname"] = "";
			$_POST["str"] = "";
			$_POST["hlt"] = "";
			$_POST["int"] = "";
			$_POST["wis"] = "";
			$_POST["agi"] = "";												
							
			$err = "<b>Acc created ! =) you can now log in!</b>";				
							
		}
		else echo "Somethings Wrong!!  :P";
		mssql_close() or die('failed closing mssql');	

	}
	
}




?>
      
      
  <title></title>
<body>

<form method="post" action="index.php">
  <table>
    <tr>
      <td></td><td><?= $err ?></td>
	  </tr>
    <tr>
      <td>ID:</td><td><input type="text" name="accname" value="<?= $_POST["accname"] ?>" maxlength="12"></td>
	  </tr>
    <tr>
      <td>Password:</td><td><input type="password" name="accpass1" maxlength="8"></td>		
	  </tr>
    <tr>
      <td>Repeat Password:</td><td><input type="password" name="accpass2" maxlength="8"></td>
	  </tr>
    
    <tr><td>&nbsp;</td></tr>
    
    <tr>
      	  </tr>
    <tr>
      					
		      </table>
		  </td>
	  </tr>	
    
    <tr>
      
		    </td>
	  </tr>
    
    <tr>
      <td><input type="submit" name="gogogo" value="Create"></td>
	  </tr>
  </table>
  
</form>
</body>
</html><!-- tab end -->
<body>
</body>
</html>
