<link rel="stylesheet" href="style.css" type="text/css">
<?php 
$fp = @fsockopen ("127.0.0.1", 30001, $errno, $errstr, 2); // 2 = sec. timeout 
if (!$fp) { 
   echo "<span id=code><b>Server is offline</b></span>"; 
} else { 

       echo "<span id=code1><b>Server is online</b></span>"; 
   } 
   @fclose($fp); 

?> 
<br>
<a href="kalxtreme.com">Back</a>
