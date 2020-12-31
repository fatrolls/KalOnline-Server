<?php 
$fp = @fsockopen ("85.25.131.85", 30001, $errno, $errstr, 2); // 2 = sec. timeout 
if (!$fp) { 
   echo "<span style=\"color:red\"><b>On Maintenance</b></span>"; 
} else { 

       echo "<span style=\"color:green\"><b>Online</b></span>"; 
   } 
   @fclose($fp); 

?> 
