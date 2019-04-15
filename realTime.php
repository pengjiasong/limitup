<?php
//监控
date_default_timezone_set('Asia/Shanghai');
if(in_array(date('w'),array(6,7))){
	exit();
}

ignore_user_abort(true);
set_time_limit(0); // 取消脚本运行时间的超时上限
echo str_repeat(" ",1024);
echo "Running...";
ob_flush();
flush();
ob_clean();
$daytemp = array();
while(1){
	$datetime = date('Hi');
	if($datetime<'0915' || ($datetime>'1130' && $datetime<'1300')){
		continue;
	}

	$content = file_get_contents('ss.txt');
	$item = explode(',' , $content);
	$fileArray = [];
	foreach($item as $val){
		if(empty($val)){
			continue;
		}
		$first = substr($val , 0 , 1 );
		if($first != 3){
			if($first == 6){
				$prefix = 'sh';
			}else{
				$prefix = 'sz';
			}
		}else{
			continue;
		}

		$getcontent = mb_convert_encoding(file_get_contents('http://qt.gtimg.cn/q=s_'.$prefix.$val) , 'UTF-8' , 'GB2312');
		$item = explode('~' , $getcontent);
		$showstr = 'show/'.mb_convert_encoding($item[1] , 'gb2312' , 'utf-8') .';;;' . $item[5].'.cls';
		array_push($fileArray , $showstr);
		file_put_contents($showstr ,'');
	}
	if($datetime>=1530){
		exit();
	}
	
	sleep(4);
	foreach($fileArray as $file){
		if(file_exists($file)){
			unlink($file);
		}
	}
}

?>