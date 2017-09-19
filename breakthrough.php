<?php
include('common.php');
set_time_limit(0);
ini_set('max_execution_time', 100*3600*3600*3600);
ini_set("memory_limit","1000M");

//http://data.10jqka.com.cn/rank/xstp/
$order = isset($_GET['order']) ? $_GET['order']: 'desc';
$breakthroughurl = 'http://data.10jqka.com.cn/rank/xstp/board/5/order/'.$order.'/page/1/ajax/1/';
while(1){
	$breakthroughcontent = mb_convert_encoding(file_get_contents($breakthroughurl),'utf-8','GB2312');
	if(preg_match_all('/code="hs_(\d+)" class="J_showCanvas">([^<>]+)<\/a><\/td>/sim',$breakthroughcontent,$match)){
		foreach($match[1] as $key=>$hyinfo){
			$first = substr($hyinfo , 0 , 1 );
			if($first != 3){
				if($first == 6){
					$prefix = 'sh';
				}else{
					$prefix = 'sz';
				}
			}else{
				continue;
			}
			$breakthroughdata[$hyinfo][] = $match[2][$key];
			$breakthroughdata[$hyinfo][] = 0;
			$breakthroughdata[$hyinfo][] = 'breakthrough';
			$breakthroughdata[$hyinfo][] = $prefix;
		}
	}

	if(preg_match('/<a class="changePage" page="(\d+)" href="javascript:void\(0\);">下一页<\/a>/sim',$breakthroughcontent , $pagenext)){
		$breakthroughurl = 'http://data.10jqka.com.cn/rank/xstp/board/5/order/'.$order.'/page/'.$pagenext[1].'/ajax/1/';
		if($pagenext[1] == 20){
			break;
		}
	}else{
		break;
	}
}
if(!empty($breakthroughdata)){
	$fp = fopen('data/breakthrough.php', 'w');
	fwrite($fp, '<?php $data='.var_export($breakthroughdata, true).';?>');
	fclose($fp);
	echo '<a href="Analysis.php?datafile=breakthrough">breakthrough</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
}

?>