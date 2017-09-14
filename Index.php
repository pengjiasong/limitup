<?php
//path_to_sdk无用
//来源：http://data.eastmoney.com/zjlx/detail.html

ignore_user_abort(true);
set_time_limit(0); // 取消脚本运行时间的超时上限
date_default_timezone_set('Asia/Shanghai');
echo str_repeat(" ",1024);
echo "Running...";
ob_flush();
flush();
ob_clean();
include('data/SelfSelect.php');
$daytemp = array();

while(1){
	if(date('H') >= 15 || date('Hi')==='0930' || date('H')==='10'){
		if(!empty($daytemp)){
			$fp = fopen('data/daytemp.php', 'w');
			fwrite($fp, '<?php $data='.var_export($daytemp, true).';?>');
			fclose($fp);
		}
		if(date('H') >= 15){
			exit();
		}
	}
	sleep(1);
	$url = 'http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx/JS.aspx?type=ct&st=(ChangePercent)&sr=-1&p=1&ps=100&js=var%20mSoQyijv={pages:(pc),date:%222014-10-22%22,data:[(x)]}&token=894050c76af8597a853f5b408b759f5d&cmd=C._AB&sty=DCFFITA&rt=49698198';
	$content = file_get_contents($url);

	if(preg_match('/data:\[([^\[\]]+)\]/' , $content , $match)){
		if(preg_match_all('/\"([^\"]+)\"/' , $match[1] , $match1)){
			foreach($match1[1] as $item){
				$parm = explode(',' , $item);
				//自选
				if(!empty($data[$parm[1]]) && $parm[4]>4 && date('H') < 10 && $data[$parm[1]][1] < 9.5 && empty($_SESSION[$parm[1]][4])){
					$msg = "您的订单编号：\r\n".$parm[1]."\r\n,物流信息：\r\n".$parm[2];
					$msg = urlencode($msg);
					$daytemp = array_merge($daytemp,sendinfo($parm));
					$_SESSION[$parm[1]]['send'] = 1;
				}
				//所有
				if($parm[4] >= 9.5 && $parm[4] < 11 && $parm[3] < 100){
					//不做创业板，排除掉
					if(empty($_SESSION[$parm[1]]) && substr($parm[1] , 0 , 1 ) != 3 && empty($_SESSION[$parm[1]][4])){
						$parm['send'] = 0;
						$_SESSION[$parm[1]]=$parm;
						$daytemp = sendinfo($parm);
						$daytemp = array_merge($daytemp,sendinfo($parm));
					}
				}	
				if(!empty($_SESSION[$parm[1]][4]) && $_SESSION[$parm[1]][4] != $parm[4] && $parm[4] > 8 && $_SESSION[$parm[1]]['send'] == 0 && !in_array($parm[1],$data)){
					$msg = "您的订单编号：\r\n".$parm[1]."\r\n,物流信息：\r\n".$parm[2];
					$msg = urlencode($msg);
					if(date('H') < 10 || !empty($data[$parm[1]])){
						send($msg,18580716334);
					}	
					$_SESSION[$parm[1]]['send'] = 1;
				}
			}
		}
	}
}


function sendinfo($parm){
	$gupiaodaima = $parm[1];
	// $zhejia = round($parm[3]/($parm[4]/100+1) * 1.085 , 2);
	// $msg = "您的订单编号：\r\n".$gupiaodaima."\r\n,物流信息：\r\n".$parm[2];

	$daytemp[$gupiaodaima][] = $parm[2];
	$daytemp[$gupiaodaima][] = $parm[4];
	$daytemp[$gupiaodaima][] = date('d');
	$first = substr($gupiaodaima , 0 , 1 );
	if($first == 6){
		$prefix = 'sh';
	}else{
		$prefix = 'sz';
	}
	$daytemp[$gupiaodaima][] = $prefix;
	return $daytemp;
}


function send($msg, $tele){
	if(is_array($tele)) $tele = implode(',', $tele);
	$msg = '【逍遥游网】'.urldecode($msg);
	$apikey = "a6210b57aaaf24ccc4662e24c6ae3a65";
	$ch = curl_init();
	/* 设置验证方式 */
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept:text/plain;charset=utf-8', 'Content-Type:application/x-www-form-urlencoded','charset=utf-8'));
	/* 设置返回结果为流 */
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	/* 设置超时时间*/
	curl_setopt($ch, CURLOPT_TIMEOUT, 10);
	/* 设置通信方式 */
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	$data=array('text'=>$msg,'apikey'=>$apikey,'mobile'=>$tele);
	curl_setopt ($ch, CURLOPT_URL, 'https://sms.yunpian.com/v1/sms/send.json');
	curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
	$req = curl_exec($ch);
	$req = json_decode($req,true);
	if($req['code'] == 0) return '发送成功';
	else {
		return $req['msg'];
	}
}

?>