<?php
include('common.php');
set_time_limit(0);
ini_set('max_execution_time', 100*3600*3600*3600);
ini_set("memory_limit","1000M");

//http://data.10jqka.com.cn/funds/hyzjl/###
$industrylisturl = empty($_GET['url']) ? 'http://data.10jqka.com.cn/funds/hyzjl/board/10/ajax/1/' : $_GET['url'];
$hycontent = mb_convert_encoding(file_get_contents($industrylisturl),'utf-8','GB2312');

if(preg_match_all('/<td class="tl"><a href="([^\"]+)" target="_blank">([^<>]+)<\/a><\/td>/sim',$hycontent,$match)){
	foreach($match[1] as $key=>$value){
		echo hyinfoadd($value,$match[2][$key]);
	}
}

function hyinfoadd($url,$hyname){	
	if(preg_match('/code\/(\d+)\//sim',$url,$urlmatch)){
		$file = 'data/'.$urlmatch[1].'.php';
		if(file_exists($file)){
			$changetime = filemtime($file);
			if(time()-$changetime<24*7*3600){
				return '<a href="Analysis.php?datafile='.$urlmatch[1].'">'.$hyname.'</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
			}
			include($file);
		}
	}else{
		return false;	
	}
	
	while(1){
		$hyinfocontent = mb_convert_encoding(file_get_contents($url),'utf-8','GB2312');
		if(preg_match_all('/<td><a href="http:\/\/stockpage.10jqka.com.cn\/\d+\/" target="_blank">(\d+)<\/a><\/td>\s*<td><a href="http:\/\/stockpage.10jqka.com.cn\/\d+" target="_blank">([^<>]+)<\/a><\/td>\s*<td class="c-rise">[^<>]+<\/td>\s*<td class="c-rise">([^<>]+)<\/td>/sim',$hyinfocontent,$hyinfomatch)){
			foreach($hyinfomatch[1] as $key=>$hyinfo){
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
				$hyinfodata[$hyinfo][] = $hyinfomatch[2][$key];
				$hyinfodata[$hyinfo][] = $hyinfomatch[3][$key];
				$hyinfodata[$hyinfo][] = $hyname;
				$hyinfodata[$hyinfo][] = $prefix;
			}
		}
		if(preg_match('/<a class="changePage" page="(\d+)" href="javascript:void\(0\);">下一页<\/a>/sim',$hyinfocontent , $pagenext)){
			$url = 'http://q.10jqka.com.cn/gn/detail/order/desc/page/'.$pagenext[1].'/ajax/1/code/'.$urlmatch[1];
		}else{
			break;
		}
	}
	if(!empty($hyinfodata)){
		$fp = fopen($file, 'w');
		fwrite($fp, '<?php $data='.var_export($hyinfodata, true).';?>');
		fclose($fp);
		return '<a href="Analysis.php?datafile='.$urlmatch[1].'">'.$hyname.'</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	}
}

?>