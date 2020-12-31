<?php
//guild castle data
if ($f = fopen("../data/gcastles.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dgcastle[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dgcastle['c'] = $c;
	fclose($f);
}
?>