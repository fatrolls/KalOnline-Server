<?php
//guildrole data
if ($f = fopen("../data/grole.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dgrole[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dgrole['c'] = $c;
	fclose($f);
}
?>