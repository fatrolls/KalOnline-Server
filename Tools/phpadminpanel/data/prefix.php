<?php
//prefix data
if ($f = fopen("../data/prefix.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dprefix[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dprefix['c'] = $c;
	fclose($f);
}
?>