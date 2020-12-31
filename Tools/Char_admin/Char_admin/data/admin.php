<?php
//admin data
if ($f = fopen("../data/admin.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$dadmin[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$dadmin['c'] = $c;
	fclose($f);
}
?>