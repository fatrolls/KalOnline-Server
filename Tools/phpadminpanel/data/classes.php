<?php
//classes data
if ($f = fopen("../data/classes.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dclass[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dclass['c'] = $c;
	fclose($f);
}
?>