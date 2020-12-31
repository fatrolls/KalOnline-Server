<?php

function encode($password)
{
    $EncTable = array('!'=>'95', '"'=>'88', '#'=>'9D', '$'=>'4C', '%'=>'F2', 
'&'=>'3E', '\''=>'BB', '('=>'C0', ')'=>'7F', '*'=>'18', '+'=>'70', 
','=>'A6', '-'=>'E2', '.'=>'EC', '/'=>'77',
                        '0'=>'2C', '1'=>'3A', '2'=>'4A', '3'=>'91', 
'4'=>'5D', '5'=>'7A', '6'=>'29', '7'=>'BC', '8'=>'6E', '9'=>'D4', ':'=>'40', 
';'=>'17', '<'=>'2E', '='=>'CB', '>'=>'72', '?'=>'9C',
                        '@'=>'A1', 'A'=>'FF', 'B'=>'F3', 'C'=>'F8', 
'D'=>'9B', 'E'=>'50', 'F'=>'51', 'G'=>'6D', 'H'=>'E9', 'I'=>'9A', 'J'=>'B8', 
'K'=>'84', 'L'=>'A8', 'M'=>'14', 'N'=>'38', 'O'=>'CE',
                        'P'=>'92', 'Q'=>'5C', 'R'=>'F5', 'S'=>'EE', 
'T'=>'B3', 'U'=>'89', 'V'=>'7B', 'W'=>'A2', 'X'=>'AD', 'Y'=>'71', 'Z'=>'E3', 
'['=>'D5', '\\'=>'BF', ']'=>'53', '^'=>'28', '_'=>'44',
                        '`'=>'33', 'a'=>'48', 'b'=>'DB', 'c'=>'FC', 
'd'=>'09', 'e'=>'1F', 'f'=>'94', 'g'=>'12', 'h'=>'73', 'i'=>'37', 'j'=>'82', 
'k'=>'81', 'l'=>'39', 'm'=>'C2', 'n'=>'8D', 'o'=>'7D',
                        'p'=>'08', 'q'=>'4F', 'r'=>'B0', 's'=>'FE', 
't'=>'79', 'u'=>'0B', 'v'=>'D6', 'w'=>'23', 'x'=>'7C', 'y'=>'4B', 'z'=>'8E', 
'{'=>'06', '|'=>'5A', '}'=>'CC', '~'=>'62');

    $Encode = "0x";

    for ($i = 0; $i < strlen($password); $i++)
        $Encode .= $EncTable[$password[$i]];

    return $Encode;
}

function decode($password)
{
    $DecTable = array('95'=>'!', '88'=>'"', '9D'=>'#', '4C'=>'$', 'F2'=>'%', 
'3E'=>'&', 'BB'=>'\'', 'C0'=>'(', '7F'=>')', '18'=>'*', '70'=>'+', 
'A6'=>',', 'E2'=>'-', 'EC'=>'.', '77'=>'/',
                        '2C'=>'0', '3A'=>'1', '4A'=>'2', '91'=>'3', 
'5D'=>'4', '7A'=>'5', '29'=>'6', 'BC'=>'7', '6E'=>'8', 'D4'=>'9', '40'=>':', 
'17'=>';', '2E'=>'<', 'CB'=>'=', '72'=>'>', '9C'=>'?',
                        'A1'=>'@', 'FF'=>'A', 'F3'=>'B', 'F8'=>'C', 
'9B'=>'D', '50'=>'E', '51'=>'F', '6D'=>'G', 'E9'=>'H', '9A'=>'I', 'B8'=>'J', 
'84'=>'K', 'A8'=>'L', '14'=>'M', '38'=>'N', 'CE'=>'O',
                        '92'=>'P', '5C'=>'Q', 'F5'=>'R', 'EE'=>'S', 
'B3'=>'T', '89'=>'U', '7B'=>'V', 'A2'=>'W', 'AD'=>'X', '71'=>'Y', 'E3'=>'Z', 
'D5'=>'[', 'BF'=>'\\', '53'=>']', '28'=>'^', '44'=>'_',
                        '33'=>'`', '48'=>'a', 'DB'=>'b', 'FC'=>'c', 
'09'=>'d', '1F'=>'e', '94'=>'f', '12'=>'g', '73'=>'h', '37'=>'i', '82'=>'j', 
'81'=>'k', '39'=>'l', 'C2'=>'m', '8D'=>'n', '7D'=>'o',
                        '08'=>'p', '4F'=>'q', 'B0'=>'r', 'FE'=>'s', 
'79'=>'t', '0B'=>'u', 'D6'=>'v', '23'=>'w', '7C'=>'x', '4B'=>'y', '8E'=>'z', 
'06'=>'{', '5A'=>'|', 'CC'=>'}', '62'=>'~');


    for ($i = 0; $i < strlen($password); $i++)
	{
		$Hex = sprintf("%02x", ord($password[$i]));
        $Decode .= $DecTable[strtoupper($Hex)];
	}

    return $Decode;
}
function auth($ID, $PWD)
{
	$connect = mssql_connect('127.0.0.1', 'SA', 'pass');
	$db = mssql_select_db('kal_auth', $connect);

	$q = mssql_query("SELECT [PWD] FROM Login WHERE [ID] = '$ID'", $connect);
	$r = mssql_fetch_array($q);
	$pwd = decode($r['PWD']);

	if($pwd == $PWD)
		return true;
	else
		return false;
}

function change($ID, $PWD)
{
	$connect = mssql_connect('127.0.0.1', 'SA', 'pass');
	$db = mssql_select_db('kal_auth', $connect);

	$EPWD = encode($PWD);

	mssql_query("UPDATE [Login] SET [PWD] = ".$EPWD." WHERE [ID] = '{$ID}'", 
$connect);
}

if( isset($_POST['change']) )
{
	$id = $_POST['id'];
	$oldpwd = $_POST['oldpwd'];
	$pwd1 = $_POST['pwd1'];
	$pwd2 = $_POST['pwd2'];

	if($id == "")
	{
		echo "Please type in your id!";
		return;
	}

	if($oldpwd == "")
	{
		echo "Please type in your password!";
		return;
	}

	if($pwd1 == "")
	{
		echo "Please type in your new password!";
		return;
	}

	if(auth($id, $oldpwd))
	{
		if($pwd1 != $pwd2)
		{
			echo "Passwords do not match...";
		}
		else
		{
			change($id, $pwd2);
			echo "<font color=\"Red\"> Password changed successfully.. </font>";
		}
	}
	else
	{
		echo "Wrong password...";
	}


	return;
}

?>

<p><font color="Red"></font>
</p>
<form method="POST" action="">

<label></label>
<p>
<label></label>

<table width="350" border="0" align="center" cellpadding="0" 
cellspacing="0">
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>ID:</td>
    <td><div align="center">
      <input name="id" type="text" id="id" />
    </div></td>
  </tr>
  <tr>
    <td><label>Old Password:</label></td>
    <td><div align="center">
      <input name="oldpwd" type="password" id="oldpwd" />
    </div></td>
  </tr>
  <tr>
    <td>New Password: </td>
    <td><div align="center">
      <input name="pwd1" type="password" id="pwd1" />
    </div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><div align="center">
      <input name="pwd2" type="password" id="pwd2" />
    </div></td>
  </tr>
  <tr>
    <td height="50" colspan="2"><div align="center">
      <input type="submit" name="change" value="Change Pass..." />
    </div></td>
  </tr>
</table>
<p>&nbsp;</p>
</form>

