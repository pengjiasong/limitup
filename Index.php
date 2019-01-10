<?php
//path_to_sdk无用
//来源：http://data.eastmoney.com/zjlx/detail.html
date_default_timezone_set('Asia/Shanghai');
if(in_array(date('w'),array(6,7))){
	exit();
}

file_put_contents('bb.txt','');
file_put_contents('cc.txt','');
ignore_user_abort(true);
set_time_limit(0); // 取消脚本运行时间的超时上限
echo str_repeat(" ",1024);
echo "Running...";
ob_flush();
flush();
ob_clean();
$daytemp = array();
while(1){
	if(date('Hi')>=1530){
		exit();
	}
	if(date('Hi')<'0930'){
		continue;
	}
	$url = 'http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx/JS.aspx?type=ct&st=(ChangePercent)&sr=-1&p=1&ps=200&js=var%20mSoQyijv={pages:(pc),date:%222014-10-22%22,data:[(x)]}&token=894050c76af8597a853f5b408b759f5d&cmd=C._AB&sty=DCFFITA&rt=49698198';
	$content = file_get_contents($url);

	if(preg_match('/data:\[([^\[\]]+)\]/' , $content , $match)){
		if(preg_match_all('/\"([^\"]+)\"/' , $match[1] , $match1)){
			foreach($match1[1] as $item){
				$parm = explode(',' , $item);
				/*
				if(isset($_SESSION['a'.$parm[1]])){
					if(time()-$_SESSION['a'.$parm[1]]['time']>30 & $parm[4] <9.7 && $_SESSION['a'.$parm[1]]['send'] == 0){
						// $msg = "您的订单编号：\r\n".$parm[1]."\r\n,物流信息：\r\n".$parm[2];
						$msg = "name：".$parm[1].",code：".$parm[2].",fivedaytop：".$_SESSION['a'.$parm[1]]['fivedaytop']."\r\n";
						file_put_contents('cc.txt',$msg,FILE_APPEND);
						// $msg = urlencode($msg);
						$_SESSION['a'.$parm[1]]['send'] = 1;
						// send($msg,18580716334);
					}
				}
				*/
				if($parm[4]>9.8 && !isset($_SESSION['a'.$parm[1]]) && substr($parm[1] , 0 , 1 ) != 3 && $parm[3] < 50){
					$hiscontent = file_get_contents('http://quotes.money.163.com/trade/lsjysj_'.$parm[1].'.html');
					if(preg_match_all('/<tr class=\'(dbrow){0,1}\'>(<td[^<>]*>[^<>]*<\/td>){6}<td[^<]*>(-{0,1}\d+\.\d+)<\/td>/sim',$hiscontent,$match)){
						$fivedaytop = 0;
						for($i = 0; $i <=5 ; $i ++){
							if(isset($match[3][$i]) && $match[3][$i] > 9.8){
								$fivedaytop++;
							}
						}
						if($fivedaytop >= 1 ){
							$_SESSION['a'.$parm[1]]['time'] = time();
							$_SESSION['a'.$parm[1]]['fudu'] = $parm[4];
							$_SESSION['a'.$parm[1]]['send'] = 0;
							$_SESSION['a'.$parm[1]]['fivedaytop'] = $fivedaytop;
							$msg = "name：".$parm[1].",code：".$parm[2].",fivedaytop：".$fivedaytop."\r\n";
							file_put_contents('bb.txt',$msg,FILE_APPEND);
						}
					}
				}
			}
		}
	}
	sleep(3);
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