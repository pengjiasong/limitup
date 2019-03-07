<?php
//监控
date_default_timezone_set('Asia/Shanghai');
if(in_array(date('w'),array(6,7))){
	exit();
}

// file_put_contents('bb.txt','');
// file_put_contents('cc.txt','');
// ignore_user_abort(true);
// set_time_limit(0); // 取消脚本运行时间的超时上限
// echo str_repeat(" ",1024);
// echo "Running...";
// ob_flush();
// flush();
// ob_clean();
// $daytemp = array();
while(1){
	$datetime = date('Hi');
	if($datetime<'0930'){
		continue;
	}

	$content = file_get_contents('dd.txt');
	$item = explode(',' , $content);
	foreach($item as $val){
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

		$getcontent = mb_convert_encoding(file_get_contents('http://hq.sinajs.cn/list='.$prefix.$val), 'utf-8' , 'gb2312');
		$item = explode(',' , substr($getcontent , 21));
		
		$showstr = mb_substr($item[0] , 0 , 2) .';;;'. $item[3] . ';;;' . $item[4] . ';;;' . $item[5]. ';;;' . $item[6];
		echo $showstr;
		exit;
		echo $getcontent;
exit;
	}
	file_put_contents('nn.txt' , '');

	if($datetime>=1530){
		exit();
	}
	sleep(4);
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