<?php
include('common.php');
set_time_limit(0);
ini_set('max_execution_time', 100*3600*3600*3600);
ini_set("memory_limit","1000M");
$day = date('d'); 

if($day%10 == 0){
	$newurl = 'http://datainterface.eastmoney.com/EM_DataCenter/JS.aspx?type=NS&sty=NSSTV5&st=12&sr=-1&p=1&ps=100&js=var%20CURggAIV={pages:(pc),data:[(x)]}&stat=1&rt=49731936';
	$newcontent = curl_https($newurl);
	if(preg_match('/data:\[([^\[\]]+)\]/' , $newcontent , $match)){
		if(preg_match_all('/\"([^\"]+)\"/' , $match[1] , $match1)){
			foreach($match1[1] as $item){
				$parm = explode(',' , $item);
				if(empty($parm[40])){
					if(substr($parm[4] , 0 , 1 ) != 3){
						$newdata[] = $parm[4];
					}
				}
			}
		}
	}
	if(!empty($newdata)){
		$fp = fopen('data/newdata.php', 'w');
		fwrite($fp, '<?php $newdata='.var_export($newdata, true).';?>');
		fclose($fp);
	}
}
if(!isset($newdata)){
	include('data/newdata.php');
}

$url = 'http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx/JS.aspx?type=ct&st=(ChangePercent)&sr=-1&p=1&ps=100&js=var%20mSoQyijv={pages:(pc),date:%222014-10-22%22,data:[(x)]}&token=894050c76af8597a853f5b408b759f5d&cmd=C._AB&sty=DCFFITA&rt=49698198';
$content = curl_https($url);

if(preg_match('/data:\[([^\[\]]+)\]/' , $content , $match)){
	if(preg_match_all('/\"([^\"]+)\"/' , $match[1] , $match1)){
		foreach($match1[1] as $key=>$item){
			$parm = explode(',' , $item);
			
			if($parm[4] >= 9.9 && $parm[4] < 11 && $parm[3] < 100){
				$first = substr($parm[1] , 0 , 1 );
				if($first != 3){
					if($first == 6){
						$prefix = 'sh';
					}else{
						$prefix = 'sz';
					}
					$infourl = 'https://gupiao.baidu.com/api/stocks/stocktimelinefive?from=pc&os_ver=1&cuid=xxx&vv=100&format=json&stock_code='.$prefix.$parm[1].'&step=3&timestamp=1491895053048';
					$infocontent = curl_https($infourl);
					$obj = json_decode($infocontent);
					if(!isset($obj->timeLine)){
						continue;
					}
					$list = $obj->timeLine;

					if($list[323]->netChangeRatio != 0){
						$yesterday = $list[323]->netChangeRatio;
					}else if($list[242]->netChangeRatio != 0){
						$yesterday = $list[242]->netChangeRatio;
					}else if($list[161]->netChangeRatio != 0){
						$yesterday = $list[161]->netChangeRatio;
					}else if($list[80]->netChangeRatio != 0){
						$yesterday = $list[80]->netChangeRatio;
					}else{
						$yesterday = 0;
					}
					if($list[404]->netChangeRatio >= 9.9 && $yesterday >= 9.9 && !in_array($parm[1] , $newdata)){
						$LinkingBoarddata[$parm[1]][] = $parm[2];
						$LinkingBoarddata[$parm[1]][] = strval(round($list[404]->netChangeRatio ,2));
						$LinkingBoarddata[$parm[1]][] = $day;
						$LinkingBoarddata[$parm[1]][] = $prefix;
					}
				}
			}	
		}
	}
}

if(!empty($LinkingBoarddata)){
	$fp = fopen('data/LinkingBoard.php', 'w');
	fwrite($fp, '<?php $data='.var_export($LinkingBoarddata, true).';?>');
	fclose($fp);
	echo '<a href="Analysis.php?datafile=LinkingBoard">View</a>';
}

?>