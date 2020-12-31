<?php
//guildmember class data
if ($f = fopen("../data/gmclass.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dgmclass[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dgmclass['c'] = $c;
	fclose($f);
}
?>