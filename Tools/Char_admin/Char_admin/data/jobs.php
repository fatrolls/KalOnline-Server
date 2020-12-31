<?php
//job data
if ($f = fopen("../data/jobsk.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$djob[0][$id] = $name;
		if ($c < $id) $c = $id;
	}
	$djob[0]['c'] = $c;
	fclose($f);
}
if ($f = fopen("../data/jobsm.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$djob[1][$id] = $name;
		if ($c < $id) $c = $id;
	}
	$djob[1]['c'] = $c;
	fclose($f);
}
if ($f = fopen("../data/jobsa.txt","r")) {
	$c = 0;
	while(list($id,$name) = fscanf ($f,"%d %s")) {
		$djob[2][$id] = $name;
		if ($c < $id) $c = $id;
	}
	$djob[2]['c'] = $c;
	fclose($f);
}
?>