<?php
//item data
if ($f = fopen("../data/items.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$ditem[$id] = $name;
		if ($c < $id) $c = $id;
	}
	$ditem['c'] = $c;
	fclose($f);
}
//quest items
if ($f = fopen("../data/itemsquest.txt","r")) {
	$c = 0;
	$i = 0;
	while(list($id) = fscanf ($f,"%d")) {
		$ditemquest[$i++] = $id;
	}
	$ditem['c'] = --$i;
	fclose($f);
}
?>
