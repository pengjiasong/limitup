<?php
//path_to_sdk无用
//来源：http://data.eastmoney.com/zjlx/detail.html
date_default_timezone_set('Asia/Shanghai');
if(in_array(date('w'),array(6,7))){
	exit();
}
// ignore_user_abort(true);
// set_time_limit(0); // 取消脚本运行时间的超时上限
// echo str_repeat(" ",1024);
// echo "Running...";
// ob_flush();
// flush();
// ob_clean();
// $daytemp = array();
while(1){
	$url = 'http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx/JS.aspx?type=ct&st=(ChangePercent)&sr=-1&p=1&ps=200&js=var%20mSoQyijv={pages:(pc),date:%222014-10-22%22,data:[(x)]}&token=894050c76af8597a853f5b408b759f5d&cmd=C._AB&sty=DCFFITA&rt=49698198';
	$content = file_get_contents($url);

	if(preg_match('/data:\[([^\[\]]+)\]/' , $content , $match)){
		if(preg_match_all('/\"([^\"]+)\"/' , $match[1] , $match1)){
			foreach($match1[1] as $item){
				$parm = explode(',' , $item);
				$hiscontent = file_get_contents('http://quotes.money.163.com/trade/lsjysj_'.$parm[1].'.html');
				if($parm[4]>5 && !isset($_SESSION['a'.$parm[1]]) && substr($parm[1] , 0 , 1 ) != 3 && $parm[3] < 17){
					$hiscontent = file_get_contents('http://quotes.money.163.com/trade/lsjysj_'.$parm[1].'.html');
					$_SESSION['a'.$parm[1]] = 0;
					//'http://money.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/'.$parm[1].'.phtml';
					if(preg_match_all('/<tr class=\'(dbrow){0,1}\'>(<td[^<>]*>[^<>]*<\/td>){4}<td[^<]*>(\d+\.\d+)<\/td>/sim',$hiscontent,$match)){
						$fiveday = strval(round(($match[3][0]-$match[3][5])/$match[3][5]*100,2));
						// $tenday = strval(round(($match[3][0]-$match[3][10])/$match[3][10]*100,2));
						// $twoday = strval(round(($match[3][0]-$match[3][2])/$match[3][2]*100,2));
						if($fiveday > 5){
							$msg = "您的订单编号：\r\n".$parm[1]."\r\n,物流信息：\r\n".$parm[2];
							if($parm[4]<9.7 && $_SESSION['a'.$parm[1]] == 0 && date('Hi')>=930 && date('Hi') < 1130){
								$_SESSION['a'.$parm[1]] = 1;
								file_put_contents('bb.txt',$msg,FILE_APPEND);
								$msg = urlencode($msg);
								send($msg,18580716334);
							}else if($_SESSION['a'.$parm[1]] == 0){
								$_SESSION['a'.$parm[1]] = 1;
								file_put_contents('bb.txt',$msg,FILE_APPEND);
							}
						}
					}
				}
			}
		}
	}
	exit;
	sleep(2);
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