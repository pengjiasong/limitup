<?php
//http://blog.csdn.net/gf771115/article/details/48007351
date_default_timezone_set('Asia/Shanghai');
$datafile = empty($_GET['datafile']) ? 'SelfSelect' : $_GET['datafile'];
include('data/'.$datafile.'.php');
if(empty($data)){
	exit;
} 
foreach($data as $key=>$value){
	$sinaarr[] = $value['3'].$key;
}	
if(!empty($sinaarr)){
	$content = file_get_contents('http://hq.sinajs.cn/list='.implode(',',$sinaarr));
	$content = mb_convert_encoding($content, 'UTF-8' , 'EUC-CN');
	if(preg_match_all('/(\d+)=\"([^\"]+)\"/sim', $content , $match)){
		foreach($match[2] as $key=>$item){
			$dataparm = explode(',',$item);
			$zenddata[$match[1][$key]][] = $dataparm[0];
			$amount = strval(round(($dataparm[3]-$dataparm[2])/$dataparm[2]*100,2));
			$zenddata[$match[1][$key]][] = $amount;
			$zenddata[$match[1][$key]][] = date('d');
			$zenddata[$match[1][$key]][] = $data[$match[1][$key]][3];
			$amountlist[$match[1][$key]][] = $amount;
		}
		arsort($amountlist);
	}
	unset($data);
	unset($sinaarr);
	foreach($amountlist as $key=>$value){
		$data[$key] = $zenddata[$key];
	}
}

// print_r($data);

?>
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
<style>
*{ margin:0; padding:0;list-style: none;}
body {font:12px/1.5 Tahoma;}
#header,#content{margin:0 auto;width:90%;} 
#header{height:30px;margin-top:20px;} 
#content{ height:200px} 
.outer{ margin-top:10px;margin-right:10px;width:545px;float:left} 
.tab {overflow:hidden;zoom:1;background:#000;border:1px solid #000;}
.tab li {float:left;color:#fff;height:30px;	cursor:pointer;	line-height:30px;padding:0 20px;}
.tab li.current {color:#000;background:#ccc;}
.content {border:1px solid #000;border-top-width:0;}
.content ul {display:none;padding:10px 0;}
.btn {float:left;color:#fff;height:30px;cursor:pointer;line-height:30px;padding:0 20px;}
</style>
</head>
<script src="jquery.min.js"></script>
<body>
<div id="header">
<button class="btn" id="min">min</button>
<button class="btn" id="daily">daily</button>
<button class="btn" id="weekly">weekly</button>
<button class="btn" id="monthly">monthly</button>
</div>
<div id="content">
	<?php foreach($data as $key=>$value){ ?>
	<div class="outer">
		<div id="<?php echo $value['3'].$key; ?>">
			<span class="currPrice"></span>
			<?php if($datafile != 'SelfSelect'){ ?><a class="addcode" href="javascript:return false;" value="<?php echo $key; ?>">add</a><?php } ?>
			<a class="delcode" href="javascript:return false;" value="<?php echo $key; ?>">del</a>
		</div>
		<ul class="tab">
			<li class="current">min</li>
			<li>daily</li>
			<li>weekly</li>
			<li>monthly</li>
		</ul>
		<div class="content">
			<ul style="display:block;">
				<img src="http://image.sinajs.cn/newchart/min/n/<?php echo $value['3'].$key; ?>.gif"/>
			</ul>
			<ul>
				<img src="http://image.sinajs.cn/newchart/daily/n/<?php echo $value['3'].$key; ?>.gif"/>
			</ul>
			<ul>
				<img src="http://image.sinajs.cn/newchart/weekly/n/<?php echo $value['3'].$key; ?>.gif"/>
			</ul>
			<ul>
				<img src="http://image.sinajs.cn/newchart/monthly/n/<?php echo $value['3'].$key; ?>.gif"/>
			</ul>
		</div>
	</div>
	<?php
		$sinaarr[] = $value['3'].$key;
	}
	if(!empty($sinaarr)){
		echo '<script>var sinastr = "'.implode(',' , $sinaarr).'";</script>';
	}
	?>
</div> 
</body>
<script>
	$(function(){
		$(".tab").each(function(i){
			var $this = $(this);
			$this.find('li').click(function(){
				current($(this) , i);
			})
		});
	});
	
	$(function(){
		$("#min").click(function(){
			$(".tab").each(function(){
				$(this).find('li').eq(0).click();
			});
		})
	});
	
	$(function(){
		$("#daily").click(function(){
			$(".tab").each(function(){
				$(this).find('li').eq(1).click();
			});
		})
	});
	
	$(function(){
		$("#weekly").click(function(){
			$(".tab").each(function(){
				$(this).find('li').eq(2).click();
			});
		})
	});
	
	$(function(){
		$("#monthly").click(function(){
			$(".tab").each(function(){
				$(this).find('li').eq(3).click();
			});
		})
	});
	
	function current(obj,$t){
		$(".tab").eq($t).find("li").removeClass();
		$(".tab").eq($t).find("li").eq(obj.index()).addClass('current');
		$(".content").eq($t).find("ul").css('display','none');
		$(".content").eq($t).find("ul").eq(obj.index()).css('display','block');
	}
	
	$(function(){
		$(".addcode").click(function(){
			var $value = $(this).attr('value');
			$.get("info.php", { action: "add", code: $value },function(data){
				
			});
		})
	});
	
	$(function(){
		$(".delcode").click(function(){
			var $value = $(this).attr('value');
			$.get("info.php", { action: "del", code: $value },function(data){
				
			});
		})
	});

	if(sinastr){
		newdata();
		setInterval("newdata()",1000);
	}
	function newdata(){
		$.ajax({
			url: 'http://hq.sinajs.cn/list='+sinastr,
			dataType: "script",
			cache:true,
			success: function(){
				var codearr = sinastr.split(",");
				for (i=0;i<codearr.length;i++ ) 
				{ 
					var arr = (eval("hq_str_"+codearr[i])).split(",");
					var _currPrice = keepTwoDecimalFull(arr[3]);
					var yesterdayPrice = parseFloat(arr[2]);
					$('#'+codearr[i]+' .currPrice').html(_currPrice+' ('+ keepTwoDecimalFull((_currPrice-yesterdayPrice)/yesterdayPrice*100) +'%)').css("color",colorcss(_currPrice,yesterdayPrice));
				} 
			}
		});
	}
	
	function colorcss(_currPrice , _yesterdayPrice){
		if(_currPrice > _yesterdayPrice){
			var _currcolor = 'red';
		}else if(_currPrice < _yesterdayPrice){
			var _currcolor = 'green';
		}else{
			var _currcolor = 'gray';
		}
		return _currcolor;
	}
	
	
//四舍五入保留2位小数（不够位数，则用0替补）
function keepTwoDecimalFull(num) {
  var result = parseFloat(num);
  if (isNaN(result)) {
    alert('传递参数错误，请检查！');
    return false;
  }
  result = Math.round(num * 100) / 100;
  var s_x = result.toString();
  var pos_decimal = s_x.indexOf('.');
  if (pos_decimal < 0) {
    pos_decimal = s_x.length;
    s_x += '.';
  }
  while (s_x.length <= pos_decimal + 2) {
    s_x += '0';
  }
  return s_x;
}
</script>

</html>

