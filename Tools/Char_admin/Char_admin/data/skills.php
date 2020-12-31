<?php
//skill data
if ($f = fopen("../data/skillsk.txt","r")) {
	$c = 0;
	while(list($id,$job,$rlvl,$mlvl,$name) = fscanf ($f,"%d %d %d %d %s")) {
		$dskill[0][$id] = $mlvl;
		$dskill[5][$id] = $name;
		$dskill[10][$id] = $rlvl;
		$dskill[15][$id] = $job;
		if ($c < $id) $c = $id;
	}
	$dskill[0]['c'] = $c;
	$dskill[5]['c'] = $c;    
	$dskill[10]['c'] = $c;
	$dskill[15]['c'] = $c;
	fclose($f);
}
if ($f = fopen("../data/skillsm.txt","r")) {
	$c = 0;
	while(list($id,$job,$rlvl,$mlvl,$name) = fscanf ($f,"%d %d %d %d %s")) {
		$dskill[1][$id] = $mlvl;
		$dskill[6][$id] = $name;
		$dskill[11][$id] = $rlvl;  
		$dskill[16][$id] = $job;
		if ($c < $id) $c = $id;
	}
	$dskill[1]['c'] = $c;
	$dskill[6]['c'] = $c;
	$dskill[11]['c'] = $c;
	$dskill[16]['c'] = $c;
	fclose($f);
}
if ($f = fopen("../data/skillsa.txt","r")) {
	$c = 0;
	while(list($id,$job,$rlvl,$mlvl,$name) = fscanf ($f,"%d %d %d %d %s")) {
		$dskill[2][$id] = $mlvl;
		$dskill[7][$id] = $name;
		$dskill[12][$id] = $rlvl;
		$dskill[17][$id] = $job;
		if ($c < $id) $c = $id;
	}
	$dskill[2]['c'] = $c;
	$dskill[7]['c'] = $c;
	$dskill[12]['c'] = $c;
	$dskill[17]['c'] = $c;
	fclose($f);
}
?>