<?php
$action = empty($_GET['action']) ? 'index': $_GET['action'];
$code = $_GET['code'];
if(empty($code)){
	echo "code不能为空";
	exit;
}
// if(strstr($code , '_')){
	// $code =  substr($code,strpos($code , '_')+1);
// }
$action($code);


function add($code){
	include('data/LinkingBoard.php');
	if(!isset($data[$code])){
		include('data/daytemp.php');
		if(!isset($data[$code])){
			$first = substr($code , 0 , 1 );
			if($first == 6){
				$prefix = 'sh';
			}else{
				$prefix = 'sz';
			}
			$content = file_get_contents('http://hq.sinajs.cn/list='.$prefix.$code);
			$content = mb_convert_encoding($content, 'UTF-8' , 'EUC-CN');
			if(preg_match('/\"([^\"]+)\"/sim', $content , $match)){
				$dataparm = explode(',',$match[1]);
				$data[$code][] = $dataparm[0];
				$data[$code][] = strval(round(($dataparm[3]-$dataparm[2])/$dataparm[2]*100,2));
				$data[$code][] = date('d');
				$data[$code][] = $prefix;
			}
		}
	}

	$LinkingBoarddata[$code] = $data[$code];
	
	include('data/SelfSelect.php');
	if(empty($data[$code])){
		$data[$code] = $LinkingBoarddata[$code];
		$data = array_reverse($data,true);
		$fp = fopen('data/SelfSelect.php', 'w');
		fwrite($fp, '<?php $data='.var_export($data, true).';?>');
		fclose($fp);
	}
	// header('location:'.getenv("HTTP_REFERER"));
}

function del($code){
	include('data/SelfSelect.php');
	if(!empty($data[$code])){
		unset($data[$code]);
		$fp = fopen('data/SelfSelect.php', 'w');
		fwrite($fp, '<?php $data='.var_export($data, true).';?>');
		fclose($fp);
	}
	// header('location:'.getenv("HTTP_REFERER"));
}
?>