<?php
//revival data
if ($f = fopen("../data/revival.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$drevival[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$drevival['c'] = $c;
	fclose($f);
}
?>