<?php
print_r($_SESSION);
exit;
if(!empty($_SESSION)){
	$fp = fopen('data/daytemp.php', 'w');
	fwrite($fp, '<?php $data='.var_export($_SESSION, true).';?>');
	fclose($fp);
}
header('location:Analysis.php?datafile=daytemp');
?>