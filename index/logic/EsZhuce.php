<?php
namespace app\common\logic;

/**
 * [注册类接口]
 */
class EsZhuce{
	private $model;
	private $maxTotal=200000;
	
    public function __construct(){
        $this->model = model('EsZhuce');
    }
	
    /**
     * 取得列表二次筛选选项和列表结果内容
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getList($param){
		// 组合条件
		$code = 200;
		$res = [];
		//列表数据
		$where = $this->mainList($param);
		$map['where'] = $where;
		$resList = $this->getListExtend($param,$map);
		//二次筛选选项数据
		$resGroupList = $this->getSecondOption($map);
		// exit;
		if(!$resGroupList){
			$code = 405;
		}else if (!$resList) {
			$resGroupList = [];
			$code = 404;
		}else{
			$res['List'] = $resList;
			if(input('param.page') < 2){
				$maxMap['limit'] = '0,'.$this->maxTotal;
				$nameGroup = $this->getGroupExtend('name',$param,$maxMap);
				$qiyemingchengGroup = $this->getGroupExtend('qiyemingcheng',$param,$maxMap);
				$res['ExtendCount'] = ['BaseCount'=>$resList['count'],'NameCount'=>count($nameGroup['name']),'QiyeCount'=>count($qiyemingchengGroup['qiyemingcheng'])];
			}
		}
		$res['GroupList'] = $resGroupList;
		return getRes($res, $code);
	}
	
    /**
     * 列表页数据条件生成方法
     * @access private 
     * @param array $param 参数数组
     * @return string
     */
	private function mainList($param){
		$where = '';
		if(!empty($param)) {
			//主页where生成部分
			//相同部分
			$fieldtype['isjq'] = ['name'=>[],'qiyemingcheng'=>[],'bianma'=>[],'qiyebianmatz'=>[]];
			$fieldtype['time'] = ['chengbanriqi','zhuangtaikaishishijian'];
			$fieldtype['='] = ['zhuceleixing','yaopinleixing','guifanzhuangtaizhongwen','linchuang','xulie','shenqingleixing','shenpingrenwufenlei','tspz','zdzx','yxsp','yzxpj','guifanjixing'];
			$fieldtype['like'] = ['atc','gupiaodaima'];
			$fieldtype['|'] = ['ylbm'=>['fieldfull'=>'zwylbm|ylbm']];
			$fieldtype['regexp'] = ['shoulihao'];
			//不同部分
			if(!empty($param['words'])){ //高级搜索
				$where = str_to_where($param['words'],$fieldtype);
			}else if(!empty($param['fourth_condition'])){ //高级搜索
				$where = str_to_where($param['fourth_condition'],$fieldtype);
			}else{
				$where = arr_to_where($param , $fieldtype);
				if(!empty($param['comprehensive'])){//综合搜索
					$where_zhss = '';
					$controller = strtolower(request()->controller());
					$where_zhss = comprehensive_to_where($controller,$param);
					if ($where) $where .= ' AND '.$where_zhss;
					else $where = $where_zhss;
				}
			}
			if(!empty($param['filter_condition'])){ //二次筛选选项
				$whereSecond = str_to_where($param['filter_condition'],$fieldtype);
				$where = where_append($where, $whereSecond);
			}
			$where = str_replace('xulie' , 'nested(jielun.xulie)' , $where); //子表查询条件修改
			$where = str_replace(add_keyword('shenpingrenwufenlei') , 'nested(xinbao.shenpingrenwufenlei)' , $where);
			//子表查询条件修改
			// dump($where);exit();
			//附加条件where追加部分
			if(!empty($param['groupname'])){
				switch($param['groupname']){
					case 'shenbaolinchuang':
						$where = where_append($where, db_where('linchuang' , '=' , 'L'));
						break;
					case 'shenbaoshengchan':
						$where = where_append($where, db_where('linchuang' , '=' , 'S'));
						break;
					case 'shenbaobuchong':
						$where = where_append($where, db_where('linchuang' , '=' , 'B'));
						break;
					case 'shenbaozhuce':
						$where = where_append($where, db_where('linchuang' , '=' , 'Z'));
						break;
					case 'shenbaozhuanrang':
						$where = where_append($where, db_where('linchuang' , '=' , 'T'));
						break;
					case 'shenbaofushen':
						$where = where_append($where, db_where('linchuang' , '=' , 'R'));
						break;
					case 'buchongshenqing':
						$where = where_append($where, db_where('shenqingleixing' , '=' , 5));
						break;
					case 'xinyaoshenqing':
						$where = where_append($where, db_where('shenqingleixing' , '=' , 1));
						break;
					case 'fangzhishenqing':
						$where = where_append($where, db_where('shenqingleixing' , '=' , 4));
						break;
				}
			}
		}
		return $where;
	}
	
    /**
     * 取得默认列表结果内容
     * @access private 
     * @param array $param 参数数组
	 * @param array $map 各项配置
     * @return string
     */
	private function getListExtend($param = [],$map = []){
		if(!isset($map['where'])){
			$where = $this->mainList($param);
			$map['where'] = $where;
		}
		$map['table'] = 'zhuce';
		//列表数据
		$defaultField = 'id,shoulihao,name,yaopinleixing_1,zhuceleixing,shenqingleixing_1,regtime,chengbanriqi,qiyemingcheng,banlizhuangtai,zhuangtaikaishishijian,xinbao.shenpingrenwufenlei,xinbao.xuhao,jielun.jielun,tspz,zdzx,yxsp,shengfen,yaopinleixing';
		$noFieldRules = config('noFieldRules');
		if(!empty($noFieldRules)){
			$fieldArray = explode(',' , $defaultField);
			$lastFieldArray = array_diff($fieldArray , $noFieldRules );
			$defaultField = implode(',' , $lastFieldArray);
		}
		// $defaultField = str_replace(',zhuangtaikaishishijian' , ",date_histogram(field='zhuangtaikaishishijian','format'='yyyy-MM-dd','interval'='month')" , $defaultField);
		$map['field'] = $map['field'] ?? $defaultField;
		$resList = $this->model->getList($map); 
		return $resList;
	}
	
    /**
     * 取得二次筛选选项内容
     * @access private 
	 * @param array $map 各项配置
     * @return string
     */
	private function getSecondOption($map = []){
		$map['table'] = 'zhuce';
		$group = '(name),(zhuceleixing),(yaopinleixing),(shenqingleixing),(guifanzhuangtaizhongwen),(tspz),(zdzx),(yxsp),(yzxpj),(guifanjixing),(linchuang)';
		$map['field'] = str_field($group);
		$map['group'] = $group.',nested(jielun.xulie.keyword,jielun)';	
		$resGroupList = $this->model->getGroupList($map);

		//给二次筛选选项指定排序
		$rule['zhuceleixing'] = [];
		$rule['yaopinleixing'] = [1=>'中药',2=>'化药',3=>'生物制品',4=>'体外试剂',5=>'其他'];
		$rule['shenqingleixing'] = [1=>'新药',2=>'进口',3=>'进口再注册',4=>'仿制',5=>'补充申请',6=>'复审',8=>'已有国家标准',7=>'其他'];
		$rule['linchuang'] = ['L'=>'申请临床','S'=>'申请上市','B'=>'申请补充','Z'=>'申请再注册','T'=>'申请技术转让','R'=>'申请复审'];
		$rule['xulie'] = [2=>'不批准',1=>'批准',3=>'批准临床',4=>'批准仿制',5=>'批准再注册',7=>'批准生产',8=>'批准补充',9=>'批准进口',11=>'退审',6=>'企业撤回',0=>'其他'];
		$rule['guifanzhuangtaizhongwen'] = ['待受理'=>'待受理','已受理'=>'已受理','待审评'=>'待审评','在审评'=>'在审评','在审评审批中'=>'在审评审批中','待审批'=>'待审批','在审批'=>'在审批','审批完毕－待制证'=>'审批完毕－待制证',
		'制证结束－待发批件'=>'制证结束－待发批件','制证完毕－等待交回旧证'=>'制证完毕－等待交回旧证','制证完毕－已发批件'=>'制证完毕－已发批件','已备案'=>'已备案','已发通知件'=>'已发通知件','已取批件'=>'已取批件','资料在邮寄'=>'资料在邮寄','已缴费'=>'已缴费'];
		$rule['tspz'] = [1=>'是',0=>'否'];
		$rule['zdzx'] = [1=>'是',0=>'否'];
		$rule['yxsp'] = [1=>'是',0=>'否'];
		$rule['yzxpj'] = [1=>'是',0=>'否'];
		$rule['guifanjixing'] = ['原料药'=>'原料药','片剂'=>'片剂','片剂（缓控释）'=>'片剂（缓控释）','胶囊'=>'胶囊','软胶囊'=>'软胶囊','胶囊（缓控释）'=>'胶囊（缓控释）','注射液'=>'注射液',
		'粉针'=>'粉针','颗粒剂'=>'颗粒剂','丸剂'=>'丸剂','软膏剂'=>'软膏剂','凝胶剂'=>'凝胶剂','贴剂'=>'贴剂','吸入剂'=>'吸入剂','滴眼剂'=>'滴眼剂','外用溶液剂'=>'外用溶液剂','口服乳剂'=>'口服乳剂','口服溶液剂'=>'口服溶液剂',
		'混悬剂'=>'混悬剂','滴剂'=>'滴剂','膏剂（内服）'=>'膏剂（内服）','酒剂'=>'酒剂','散剂'=>'散剂','洗剂'=>'洗剂','搽剂'=>'搽剂','酊剂'=>'酊剂','栓剂'=>'栓剂','气雾剂'=>'气雾剂','滴鼻剂'=>'滴鼻剂',
		'喷雾剂'=>'喷雾剂','糊剂'=>'糊剂','膜剂'=>'膜剂','锭剂'=>'锭剂','茶剂'=>'茶剂','滴耳剂'=>'滴耳剂','粉雾剂'=>'粉雾剂','灌肠剂'=>'灌肠剂','植入剂'=>'植入剂','含漱剂'=>'含漱剂','涂剂'=>'涂剂',
		'醑剂'=>'醑剂','膏剂（外用）'=>'膏剂（外用）','诊断试剂'=>'诊断试剂','医疗器械'=>'医疗器械','药用辅料'=>'药用辅料','其他'=>'其他'];
		$resGroupList = second_to_sort($resGroupList , $rule);
		$resGroupList['zhuceleixing'] = multi_array_sort($resGroupList['zhuceleixing'] , 'key' , SORT_ASC);
		return $resGroupList;
	}
	
    /**
     * 列表页按药品名称浏览数据统计
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function nameGroup($param){
		// 组合条件
		$code = 200;
		$res = [];
		$resList = $this->listGroup('name' , $param);
		//二次筛选选项数据
		unset($param['order']);
		$map['where'] = $this->mainList($param);
		$resGroupList = $this->getSecondOption($map);
		if(!$resGroupList){
			$code = 405;
		}else if (!$resList) {
			$code = 404;
		}else{
			$res['GroupList'] = $resGroupList;
			$res['List'] = $resList;
			if(input('param.page') < 2){
				$maxMap['limit'] = '0,'.$this->maxTotal;
				$baseGroup = $this->getListExtend($param);
				$nameGroup = $this->getGroupExtend('name',$param,$maxMap);
				$qiyemingchengGroup = $this->getGroupExtend('qiyemingcheng',$param,$maxMap);
				$res['ExtendCount'] = ['BaseCount'=>$baseGroup['count'],'NameCount'=>count($nameGroup['name']),'QiyeCount'=>count($qiyemingchengGroup['qiyemingcheng'])];
			}
		}
		return getRes($res, $code);
	}
	
    /**
     * 列表页按药品名称浏览数据统计
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function nameList($param){
		// 组合条件
		$code = 200;
		$res = [];

		$where = $this->mainList($param);
		$map['where'] = $where;
		$map['table'] = 'zhuce';
		$map['field'] = 'id,shoulihao,zhucefenlei,shenqingleixing_1,chengbanriqi,qiyemingcheng,banlizhuangtai,zhuangtaikaishishijian,jielun.jielun';
		
		$res = $this->model->getList($map);

		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 列表页按企业名称浏览数据统计
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function qiyeGroup($param){
		// 组合条件
		$code = 200;
		$res = [];
		$resList = $this->listGroup('qiyemingcheng' , $param);
 
		//二次筛选选项数据
		unset($param['order']);
		$map['where'] = $this->mainList($param);
		$resGroupList = $this->getSecondOption($map); 

		if(!$resGroupList){
			$code = 405;
		}else if (!$resList) {
			$code = 404;
		}else{
			$res['GroupList'] = $resGroupList;
			$res['List'] = $resList;
			if(input('param.page') < 2){
				$maxMap['limit'] = '0,'.$this->maxTotal;
				$baseGroup = $this->getListExtend($param);
				$nameGroup = $this->getGroupExtend('name',$param,$maxMap);
				$qiyemingchengGroup = $this->getGroupExtend('qiyemingcheng',$param,$maxMap);
				$res['ExtendCount'] = ['BaseCount'=>$baseGroup['count'],'NameCount'=>count($nameGroup['name']),'QiyeCount'=>count($qiyemingchengGroup['qiyemingcheng'])];
			}
		}
		
		return getRes($res, $code);
	}
	
    /**
     * 列表页按企业名称浏览数据
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function qiyeList($param){
		// 组合条件
		$code = 200;
		$res = [];
		$where = $this->mainList($param);
		$map['where'] = $where;
		$map['table'] = 'zhuce';
		$map['field'] = 'id,shoulihao,name,zhucefenlei,shenqingleixing_1,chengbanriqi,banlizhuangtai,zhuangtaikaishishijian,jielun.jielun';
		
		$res = $this->model->getList($map);

		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 列表页按名称/企业统计分组子方法
     * @access private 
     * @param array $param 参数数组
     * @return array
     */
	private function listGroup($field,$param = [],$map = []){
		$res = [];
		//得到名称分组信息
		$tempGroupList = $this->getGroupExtend($field,$param, $map);
		$whereBase = $this->mainList($param);

		//以分组名加筛选条件统计
		foreach($tempGroupList[$field] as $key=>$info){
			$where = where_append($whereBase, db_where($field,'=',$info['key']));
			$newmap['where'] = $where;
			$newmap['table'] = 'zhuce';
			$group = '(shenqingleixing),(linchuang)';
			$newmap['field'] = str_field($group);
			$newmap['group'] = $group;
			$newmap['limit'] = '0,'.$this->maxTotal;
			$resGroupList = $this->model->getGroupList($newmap);
			
			//生成返回值
			$shenbaolinchuang = 0;
			$shenbaoshengchan = 0;
			$shenbaobuchong = 0;
			$shenbaozhuce = 0;
			$shenbaozhuanrang = 0;
			$shenbaofushen = 0;
			foreach($resGroupList['linchuang'] as $linchuangInfo){
				if($linchuangInfo['key'] == 'L'){
					$shenbaolinchuang += $linchuangInfo['doc_count'];
				}else if($linchuangInfo['key'] == 'S'){
					$shenbaoshengchan += $linchuangInfo['doc_count'];
				}else if($linchuangInfo['key'] == 'B'){
					$shenbaobuchong += $linchuangInfo['doc_count'];
				}else if($linchuangInfo['key'] == 'Z'){
					$shenbaozhuce += $linchuangInfo['doc_count'];
				}else if($linchuangInfo['key'] == 'T'){
					$shenbaozhuanrang += $linchuangInfo['doc_count'];
				}else if($linchuangInfo['key'] == 'R'){
					$shenbaofushen += $linchuangInfo['doc_count'];
				}
			}
			$buchongshenqing = 0;
			$xinyaoshenqing = 0;
			$fangzhishenqing = 0;
			foreach($resGroupList['shenqingleixing'] as $shenqingleixingInfo){
				if($shenqingleixingInfo['key'] == 5){
					$buchongshenqing += $shenqingleixingInfo['doc_count'];
				}else if($shenqingleixingInfo['key'] == 1){
					$xinyaoshenqing += $shenqingleixingInfo['doc_count'];
				}else if($shenqingleixingInfo['key'] == 4){
					$fangzhishenqing += $shenqingleixingInfo['doc_count'];
				}
			}
			//组装返回值
			$res[$key][$field] = $info['key'];
			$res[$key]['shenbaonum'] = $info['doc_count'];
			$res[$key]['shenbaolinchuang'] = $shenbaolinchuang;
			$res[$key]['shenbaoshengchan'] = $shenbaoshengchan;
			$res[$key]['shenbaobuchong'] = $shenbaobuchong;
			$res[$key]['shenbaozhuce'] = $shenbaozhuce;
			$res[$key]['shenbaozhuanrang'] = $shenbaozhuanrang;
			$res[$key]['shenbaofushen'] = $shenbaofushen;
			$res[$key]['buchongshenqing'] = $buchongshenqing;
			$res[$key]['xinyaoshenqing'] = $xinyaoshenqing;
			$res[$key]['fangzhishenqing'] = $fangzhishenqing;
		} 
		return $res;
	}
	
    /**
     * 取得按名称/企业分组列表结果
     * @access private 
     * @param array $param 参数数组
     * @param array $map 各项配置
     * @return array
     */
	private function getGroupExtend($field,$param = [],$map = []){
		//得到名称分组信息
		$where = $this->mainList($param);
		$map['where'] = $where;
		$map['table'] = 'zhuce';
		$group = '('.$field.')';
		$map['field'] = str_field($group).',COUNT(*) AS tp_count';
		$map['group'] = $group;
		$realLimit = get_real_limit();
		$map['limit'] = $map['limit'] ?? $realLimit['num'];
		if(!empty($param['order'])){
			$map['order'] = strstr($param['order'] , 'asc') ? 'tp_count asc' : '' ;
		}
		$return = $this->model->getGroupList($map);
		if(isset($param['order'])){
			$return[$field] = array_slice($return[$field] , $realLimit['num'] - $realLimit['pageSize'] , $realLimit['pageSize']);
		}
		return $return;
	}
	
    /**
     * 返回注册数据库搜索提示词
	 * @access public
     * @param array $param 参数数组
     * @return array
     */
	public function input($param = []){
		$code = 200;
		$where = '';
		$res = [];
		if(!empty($param['name'])){
			$where = 'name.keyword LIKE "'.$param['name'].'%"';
			$group = 'name';
		}else if(!empty($param['qiyemingcheng'])){
			$where = 'qiyemingcheng.keyword LIKE "'.$param['qiyemingcheng'].'%"';
			$group = 'qiyemingcheng';
		}
		if(!empty($where)){
			$map['where'] = $where;
			$map['table'] = 'zhuce';
			$map['field'] = str_field($group);
			$map['group'] = $group;
			$map['limit'] = '0,10';
			$restemp = $this->model->getGroupList($map);
			if(!empty($restemp[$group])){
				if(count($restemp[$group]) < 10){
					$where2 = '';
					if(!empty($param['name'])){
						$where2 = db_where('name','like',$param['name']);
					}else if(!empty($param['qiyemingcheng'])){
						$where2 = db_where('qiyemingcheng','like',$param['qiyemingcheng']);
					}
					$map['where'] = $where2;
					$restemp2 = $this->model->getGroupList($map);
					if(!empty($restemp2[$group])){
						$res111 = array_column($restemp[$group] , 'key');
						$res222 = array_column($restemp2[$group] , 'key');
						$arr = array_unique(array_merge($res111 , $res222));
						$res=array_slice(array_unique($arr),0,10);
					}
				}else{
					$res = array_column($restemp[$group] , 'key');
				}
			}
		}
		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 注册数据库导出数据
	 * @access public
     * @param array $param 参数数组
	 * @param array $option 配置参数
     * @return array
     */
	public function outData($param = [] , $option = []){
		$map['limit'] = '0,'.outMaxNum('zhuce');
		$action = $option['outdata_action'] ?? 'undefined';
		switch($action){
			case 'base':
			case 'undefined':
				$resList = $this->getListExtend($param,$map);
				$data=$resList['res'];
				$tablename = '注册按受理号';
				$list =  dealOutDataParam($option['outdata_column']);
				out_data($data,$list,$tablename);
				break;
			case 'name':
				$data = $this->listGroup('name' , $param, $map);
				$tablename = '注册按名称';
				$list =  dealOutDataParam($option['outdata_column']);
				out_data($data,$list,$tablename);
				break;
			case 'qiye':
				$data = $this->listGroup('qiyemingcheng' , $param, $map);
				$tablename = '注册按企业';
				$list =  dealOutDataParam($option['outdata_column']);
				out_data($data,$list,$tablename);
				break;
		}
	}

    /**
     * 注册可视化分析
     * @access public 
	 * @param array 参数数组
     * @return array
     */
    public function visualization($param = []){
		// set_time_limit(0);
		// ini_set("memory_limit","900M"); 
		$code = 200;
		$res = [];
        $where = $this->mainList($param);
		$map['where'] = $where;
		//二次筛选选项数据
		$resGroupList33 = $this->getSecondOption($map);
		
		//group 规律字段
		$map['table'] = 'zhuce';
		// $group = '(zhuceleixing),(yaopinleixing),(shenqingleixing),(guifanzhuangtaizhongwen),(tspz),(zdzx),(yxsp),(yzxpj),(guifanjixing),(linchuang),(name),(dlcp),(qiyemingcheng),(shengfen),(bianma)';
		$group = '(zhuceleixing),(yaopinleixing),(shenqingleixing),(guifanzhuangtaizhongwen),(tspz),(zdzx),(yxsp),(yzxpj),(guifanjixing),(linchuang),(shengfen),(atc)';
		$map['field'] = str_field($group);
		$map['group'] = $group.",nested(jielun.xulie.keyword,jielun)";
		$map['limit'] = '0,100';
		$resGroupList = $this->model->getGroupList($map); 

		//group 无规律字段
		$mapmore['table'] = 'zhuce';
		// $groupmore = '(name),(qiyemingcheng),(bianma)';
		$groupmore = '(name),(qiyemingcheng),(dlcp),(bianma)';
		$mapmore['field'] = str_field($groupmore);
		$mapmore['where'] = $where;
		$mapmore['group'] = $groupmore;
		$mapmore['limit'] = '0,200000';
		$resGroupListmore = $this->model->getGroupList($mapmore); //分组查询占整个方法新能消耗的90%
		// print_r($resGroupListmore);
		// exit;
		//临床分组数据 （总）
		$linchuangGroup = $this->getSpecifiedSum($resGroupList['linchuang'],['shenbaolinchuang'=>'L','shenbaoshengchan'=>'S']);
		$shoulihaoCount = $this->model->getCount($map);
		//批准分组数据 （批）
		$yipizhunCount = 0;
		foreach($resGroupList['xulie'] as $val){
			if(in_array($val['key'],[1,3,4,5,7,8,9])){
				$yipizhunCount += $val['doc_count'];
			}
		}
		$mapPizhun = $map;
		$mapPizhun['where'] = where_append($where,db_where('nested(jielun.null_value)','=',1));
		$pizhunCount = $this->model->getCount($mapPizhun);
		if($pizhunCount){
			$pizhunlv = number_format($yipizhunCount/$pizhunCount * 100 , 1).'%';
		}else{
			$pizhunlv = '';
		}
		//承办日期 （申报数量）
		$mapChengbanriqi = $map;
		$mapChengbanriqi['group'] = "date_histogram(field='chengbanriqi','interval'='1y','alias'='chengbanriqiYear','format'='yyyy')";
		$resChengbanriqiGroupList = $this->model->getGroupList($mapChengbanriqi);
		$chengbanriqiBest = array_best($resChengbanriqiGroupList['chengbanriqiYear'] , 'doc_count');
		$chengbanriqiMaxYear = isset($chengbanriqiBest['key_as_string']) ? $chengbanriqiBest['key_as_string'] : 0;
		$chengbanriqiMaxCount = isset($chengbanriqiBest['doc_count']) ? $chengbanriqiBest['doc_count'] : 0;
		//申报产品
		$nameList = array_column($resGroupListmore['name'] , 'doc_count');
		$nameCount = count($nameList);
		$dlcpList = array_column($resGroupListmore['dlcp'] , 'doc_count');
		$dlcpCount = count($dlcpList);
		$rule1 = [1=>'中药',2=>'化药',3=>'生物制品',4=>'体外试剂',5=>'其他'];
		$yaopinleixingBest = array_best($resGroupList['yaopinleixing'] , 'doc_count');
		$yaopinleixingMaxCount = isset($yaopinleixingBest['doc_count']) ? $yaopinleixingBest['doc_count'] : 0;
		$yaopinleixingMaxname = isset($yaopinleixingBest['key']) ? $rule1[$yaopinleixingBest['key']] : '';
		$yaopinleixingList = array_column($resGroupList['yaopinleixing'] , 'doc_count');
		$yaopinleixingNum = array_sum($yaopinleixingList);
		if($yaopinleixingNum){
			$yaopinleixinglv = number_format($yaopinleixingMaxCount/$yaopinleixingNum * 100 , 1).'%';
		}else{
			$yaopinleixinglv = '-';
		}
		//申报企业
		$qiyemingchengBest = array_best($resGroupListmore['qiyemingcheng'] , 'doc_count');
		$qiyemingchengCount = count($resGroupListmore['qiyemingcheng']);
		$qiyemingchengMaxCount = isset($qiyemingchengBest['doc_count']) ? $qiyemingchengBest['doc_count'] : 0;
		$qiyemingchengMaxname = isset($qiyemingchengBest['key']) ? $qiyemingchengBest['key'] : '';
		//省份申报
		$shengfenBest = array_best($resGroupList['shengfen'] , 'doc_count');
		$shengfenCount = count($resGroupList['shengfen']);
		$shengfenMaxCount = isset($shengfenBest['doc_count']) ? $shengfenBest['doc_count'] : 0;
		$shengfenMaxname = isset($shengfenBest['key']) ? $shengfenBest['key'] : '';
		//申报趋势
		$mapChengbanriqi22 = $mapChengbanriqi33 = $mapChengbanriqi;
		$mapChengbanriqi22['where'] = where_append($where,db_where('nested(jielun.xulie.keyword,jielun)','IN','1,3,4,5,7,8,9'));
		$resChengbanriqiGroup2List = $this->model->getGroupList($mapChengbanriqi22);
		$mapChengbanriqi33['group'] = "(date_histogram(field='chengbanriqi','interval'='1y','alias'='chengbanriqiYear','format'='yyyy'),(guifanzhuangtaizhongwen))";
		$resChengbanriqiGroup3List = $this->model->getGroupList($mapChengbanriqi33);
		$resChengbanriqiGroup3aa = group_hierarchy($resChengbanriqiGroup3List['chengbanriqiYear'], 'guifanzhuangtaizhongwen');
		//药理分类
		// $resGroupListmore['bianma'] = [];
		// $bianmaList = array_column($resGroupListmore['bianma'] , 'key');
		// $bianmaMap['where'] = ['bianma'=>['IN' , $bianmaList]];
		// $bianmaMap['field'] = 'atc';
		// $bianmaMap['group'] = 'atc';
		// $resAtcList = bianmazong($bianmaMap);
		$resAtc = model('YzAtc','logic')->atcVisualization($resGroupList['atc']);

		//组装返回值
		$res['basic']['total'] = [$shoulihaoCount,$linchuangGroup['shenbaolinchuang'],$linchuangGroup['shenbaoshengchan']];
		$res['basic']['pizhun'] = [$yipizhunCount,$pizhunlv];
		$res['basic']['shenbaonum'] = [$chengbanriqiMaxYear,$chengbanriqiMaxCount];
		$res['basic']['shenbaoname'] = [$nameCount,$dlcpCount,$yaopinleixingMaxname,$yaopinleixingMaxCount,$yaopinleixinglv];
		$res['basic']['shenbaoqiye'] = [$qiyemingchengCount,$qiyemingchengMaxname,$qiyemingchengMaxCount];
		$res['basic']['shenbaoshengfen'] = [$shengfenCount,$shengfenMaxname,$shengfenMaxCount];

		$res['basic']['yxsp'] = $this->getSpecifiedValue($resGroupList['yxsp']);
		$res['basic']['tspz'] = $this->getSpecifiedValue($resGroupList['tspz']);
		$res['basic']['zdzx'] = $this->getSpecifiedValue($resGroupList['zdzx']);
		$res['basic']['yzxpj'] = $this->getSpecifiedValue($resGroupList['yzxpj']);
		$res['shenbaoshuliang'] = $resChengbanriqiGroupList['chengbanriqiYear'];
		$res['pizhun'] = $resChengbanriqiGroup2List['chengbanriqiYear'];
		$res['shenbaobanli'] = $resChengbanriqiGroup3aa;
		$res['guifanzhuangtaizhongwen'] = $resGroupList['guifanzhuangtaizhongwen'];
		$res['atc'] = $resAtc;
		$res['guifanjixing'] = $resGroupList['guifanjixing'];
		$res['qiyemingcheng'] = $resGroupListmore['qiyemingcheng'];
		$res['shengfen'] = $resGroupList['shengfen'];
		//格式化返回
		$rule['yaopinleixing'] = [1=>'中药',2=>'化药',3=>'生物制品',4=>'体外试剂',5=>'其他'];
		$rule['shenqingleixing'] = [1=>'新药',2=>'进口',3=>'进口再注册',4=>'仿制',5=>'补充申请',6=>'复审',8=>'已有国家标准',7=>'其他'];
		$rule['xulie'] = [2=>'不批准',1=>'批准',3=>'批准临床',4=>'批准仿制',5=>'批准再注册',7=>'批准生产',8=>'批准补充',9=>'批准进口',11=>'退审',6=>'企业撤回',0=>'其他'];
		$resGroupList = second_to_sort($resGroupList , $rule);
		$res['shenqingleixing'] = $resGroupList['shenqingleixing'];
		$res['yaopinleixing'] = $resGroupList['yaopinleixing'];
		$res['xulie'] = $resGroupList['xulie'];

		if(!$resGroupList33){
			$code = 405;
		}else if (!$res) {
			$code = 404;
		}
		$res['GroupList'] = $resGroupList33;
		return getRes($res, $code);
    }
	
    /**
     * 返回值为指定值的分组标记字段数量总和
	 * @access private
     * @param array $itemList
     * @param array $option
     * @return array
     */
	private function getSpecifiedSum($itemList , $option){
		$res = [];
		foreach($option as $k=>$v){
			$res[$k] = 0;
		}
		foreach($itemList as $info){
			foreach($option as $key=>$value){
				if($info['key'] == $value){
					$res[$key] += $info['doc_count'];
					break;
				}
			}
		}
		return $res;
	}
	
    /**
     * 返回值为指定值的分组标记数量值
	 * @access private
     * @param array $arr
     * @param string $str
     * @return string
     */
	private function getSpecifiedValue($arr = [] , $str= '1'){
		$return = 0;
		foreach($arr as $value){
			if($value['key'] == $str){
				$return = $value['doc_count'];
				break;
			}
		}
		return $return;
	}
	
    /**
     * 注册时光轴
     * @access public 
	 * @param array 参数数组
     * @return array
     */
    public function timeline($param){
		//CYHS1490010 多数据
		//JXSS0900012 多轮
		//CYHB1750025 一致性评价

		$res = [];
        $where['id'] = $param['id'] ?? 0;
		$checkMap['where'] = $where;
		$checkMap['table'] = 'zhuce';
		$checkMap['field'] = 'shoulihao';
		$zhucecheck = $this->model->getOne($checkMap);
		$code = 200;
		//确保受理号有效
		if (!$zhucecheck) {
			$code = 404;
			return getRes($res,$code);
		}
		$shoulihao = $zhucecheck['shoulihao'];
		$shoulihaoWhere = db_where('shoulihao','=',$shoulihao);
		
		$base = []; // 固定项
		//设置$map通用项
		$map['where'] = $shoulihaoWhere;
		$map['table'] = $checkMap['table'];
		//设置$dslMap通用项
		$dslMap['where'] = '{ "shoulihao" : "'.$shoulihao.'" }';
		$dslMap['table'] = 'zhuce';
		$dslMap['model'] = $this->model;
		//通过受理号直接查询出来的数据项
		$mapZhuceinfo = $map;
		$mapZhuceinfo['field'] = 'shouliriqi.shouliriqi,feiyongdaozhiri,chengbanriqi,yzxpj,yzxpjolddata,xinbao,id,buchongolddata,buchong';
		$zhuceinfo = $this->model->getOne($mapZhuceinfo);
		// echo $zhuceinfo['id']."\r\n";
		
		//CFDA受理
		$dslMapShouli = $dslMap;
		$dslMapShouli['path'] = 'zhuceolddata';
		$dslMapShouli['method'] = 'find';
		$dslMapShouli['nested_where'] = '{ "match_phrase" : {"'.add_keyword('zhuceolddata.status').'" : "已受理"}}';
		$dslMapShouli['nested_field'] = '"zhuceolddata.date"';
		$resShouli = getDslSearch($dslMapShouli);
		$base['shouli'] = ['date'=>0,'label'=>'CFDA受理'];
		if(!empty($resShouli['date'])){
			$base['shouli'] = ['date'=>$resShouli['date'],'label'=>'CFDA受理'];
		}else if(!empty($zhuceinfo['shouliriqi'])){
			$base['shouli'] = ['date'=>$zhuceinfo['shouliriqi'],'label'=>'CFDA受理'];
		}
		//费用收到日
		$feiyongdaozhiri = !empty($zhuceinfo['feiyongdaozhiri']) ? $zhuceinfo['feiyongdaozhiri'] : 0;
		$base['feiyongdaozhiri'] = ['date'=>$feiyongdaozhiri,'label'=>'费用收到日'];
		//CDE承办
		$base['chengbanriqi'] = ['date'=>$zhuceinfo['chengbanriqi'],'label'=>'CDE承办'];
		//remarks
		$dslMapRemarks = $dslMap;
		$dslMapRemarks['path'] = 'zhuce_remarks';
		$dslMapRemarks['nested_where'] = '{ "match_phrase" : {"remarks.null_value" : "1"}}';
		$dslMapRemarks['nested_field'] = '"zhuce_remarks.date","zhuce_remarks.remarks"';
		$dslMapRemarks['nested_sort'] = '{ "zhuce_remarks.date": "asc" }';
		$dslMapRemarks['nested_size'] = 20;
		$remarks = getDslSearch($dslMapRemarks);
		$base['remarks'] = $remarks;
		//新报任务 表名判断
		$xinbaoTable = $zhuceinfo['yzxpj'] === 1 ? 'yzxpjolddata' : 'xinbaoolddata';
		//进入新报任务 (该部分与补充的等预测功能出来之后再考虑是否提出方法调用)	
		$xinbaoMin = $this->intoTask($dslMap, $xinbaoTable , '新报');
		if(!empty($xinbaoMin)){
			$infoLabel = $xinbaoTable === 'yzxpjolddata' ? '一致性评价新报任务' : '新报任务';
			$pingshenzhuangtai = $this->pingshenzhuangtai($dslMap, 'xinbao');
			$gongshileibie = $this->getField($dslMap, 'xinbaoolddata' , 'gongshileibie');
			$shenpingrenwufenlei = $this->getField($dslMap, 'xinbaoolddata' , 'shenpingrenwufenlei');
			$xuhao = $this->xuhao($dslMap, 'xinbao'); 
			$base['xinbao']['min'] = ['date'=>str_replace(' 00:00:00','',$xinbaoMin),'label'=>'进入'.$infoLabel , 'infoLabel'=>$infoLabel , 'pingshenzhuangtai' =>$pingshenzhuangtai,
									'gongshileibie' =>$gongshileibie, 'shenpingrenwufenlei' =>$shenpingrenwufenlei, 'xuhao' =>$xuhao]; 
			//开始技术审评
			$pingshenMin = $this->pingshenMin($dslMap, $xinbaoTable , '新报');
			//药理毒理专业 临床专业  药学专业  统计专业
			$yaoliduliList = $this->getProfession($map , $xinbaoTable , $shoulihao , 'yaoliduli' , '新报');
			$linchuangList = $this->getProfession($map , $xinbaoTable , $shoulihao , 'linchuang' , '新报');
			$yaoxueList = $this->getProfession($map , $xinbaoTable , $shoulihao , 'yaoxue' , '新报');
			if($xinbaoTable === 'yzxpjolddata'){
				$tongjiList = $this->getProfession($map , $xinbaoTable , $shoulihao , 'tongji' , '新报');
				$base['xinbao']['zhuanye']['tongji'] = $tongjiList;
			}						
			$base['xinbao']['zhuanye']['yaoliduli'] = $yaoliduliList;
			$base['xinbao']['zhuanye']['linchuang'] = $linchuangList;
			$base['xinbao']['zhuanye']['yaoxue'] = $yaoxueList;
			if(empty($yaoliduliList) || empty($linchuangList) || empty($yaoxueList) || empty($tongjiList)){
				$mapZhuanyeMax = $map;
				$mapZhuanyeMax['field'] = 'nested('.$xinbaoTable.'.regtime)';
				$zhuanyemax = $this->model->getMax($mapZhuanyeMax);
				$base['xinbao']['zhuanye']['zhuanyemax'] = ['date'=>str_replace(' 00:00:00','',$zhuanyemax),'label'=>'未启动'];
			}
			$base['xinbao']['pingshenMin'] = ['date'=>$pingshenMin,'label'=>'开始技术审评'];
			//完成技术审评
			$pingshenMax = $this->pingshenMax($dslMap, $xinbaoTable , $zhuceinfo , '新报');
			$base['xinbao']['pingshenMax'] = ['date'=>$pingshenMax,'label'=>'完成技术审评'];
			//备注
			$base['xinbao']['beizhu']  = $this->beizhu($map, $xinbaoTable);
		}
		//补发通知
		$dslMapSongda = $dslMap;
		$dslMapSongda['path'] = 'songda';
		$dslMapSongda['nested_where'] = '{ "match_phrase" : {"songda.null_value" : "1"}}';
		$dslMapSongda['nested_sort'] = '{ "songda.songda": "asc" }';
		$dslMapSongda['nested_field'] = '"songda.songda"';
		$dslMapSongda['nested_size'] = 20;
		$songda = getDslSearch($dslMapSongda);
		$base['songda'] = $songda;
		//补充资料任务
		//表名判断
		$buchongTable = $zhuceinfo['yzxpj'] === '是' ? 'yzxpjolddata' : 'buchongolddata';
		//轮数判断
		$mapLunshu = $map;
		if($buchongTable == 'yzxpjolddata'){
			$mapLunshu['group'] = 'nested('.$buchongTable.'.intodate,'.$buchongTable.')';
			$lunshuGroup = [];
			$dslMapBuchong = $dslMap;
			$dslMapBuchong['path'] = $buchongTable;
			$dslMapBuchong['nested_field'] = '"'.$buchongTable.'.intodate"';
			$dslMapBuchong['nested_size'] = 200;
			$buchongList = getDslSearch($dslMapBuchong);
			$reBuchongList = array_unique_second($buchongList,'intodate');
			$lunshuTemp = array_column($reBuchongList , 'intodate');
		}else{
			$mapLunshu['group'] = 'nested('.$buchongTable.'.intodate,'.$buchongTable.')';
			$lunshuGroup = $this->model->getGroupList($mapLunshu);
			$lunshuTemp = array_column($lunshuGroup['intodate'] , 'key_as_string');
			asort($lunshuTemp);	
		}
		$lunshuCount = 0;
		if(count($lunshuTemp) == 1){
			$lunshuCount = 1;
		}else{
			foreach($lunshuTemp as $key=>$intodate){
				if($intodate == '1970-01-01 00:00:00'){
					unset($lunshuTemp[$key]);
				}else{
					$lunshuCount++;
				}
			}
		}
		if($lunshuCount >= 1){
			$mapBuchongMin = $map;
			$lunshuTemp = array_values($lunshuTemp);
			foreach($lunshuTemp as $key=>$intodate){
				//进入补充资料任务
				$nested_where_append = $lunshuCount == 1 ? '' :'{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}';
				if($key == 0){
					$buchongMin = $this->intoTask($dslMap, $buchongTable , '补充' , $nested_where_append);
					if(!empty($buchongMin)){
						$infoLabelPrev = $buchongTable === 'yzxpjolddata' ? '一致性评价补充任务' : '补充资料任务';
						$infoLabel = $lunshuCount == 1 ? $infoLabelPrev : $infoLabelPrev.'第'.num_to_word($key+1).'轮';
						$pingshenzhuangtai = $this->pingshenzhuangtai($dslMap, 'buchong');
						$gongshileibie = $this->getField($dslMap, 'buchongolddata' , 'shenpingbumen');
						$xuhao = $this->xuhao($dslMap, 'buchong');
						$base['buchong'][$key]['min'] = ['date'=>str_replace(' 00:00:00','',$buchongMin),'label'=>'进入'.$infoLabelPrev , 'infoLabel'=>$infoLabel, 'pingshenzhuangtai' =>$pingshenzhuangtai,
									'gongshileibie' =>$gongshileibie, 'xuhao' =>$xuhao];
						//开始技术审评
						$pingshenMin = $this->pingshenMin($dslMap, $buchongTable, '补充',$nested_where_append);
						//药理毒理专业 临床专业  药学专业
						$yaoliduliList = $this->getProfession($map , $buchongTable , $shoulihao , 'yaoliduli' , '补充' , $nested_where_append);
						$linchuangList = $this->getProfession($map , $buchongTable , $shoulihao , 'linchuang' , '补充' , $nested_where_append);
						$yaoxueList = $this->getProfession($map , $buchongTable , $shoulihao , 'yaoxue' , '补充' , $nested_where_append);
						if($buchongTable === 'yzxpjolddata'){
							$tongjiList = $this->getProfession($map , $buchongTable , $shoulihao , 'tongji' , '补充' , $nested_where_append);
							$base['buchong']['zhuanye'][$key]['tongji'] = $tongjiList;
						}	
						$base['buchong']['zhuanye'][$key]['yaoliduli'] = $yaoliduliList;
						$base['buchong']['zhuanye'][$key]['linchuang'] = $linchuangList;
						$base['buchong']['zhuanye'][$key]['yaoxue'] = $yaoxueList;
						if(empty($yaoliduliList) || empty($linchuangList) || empty($yaoxueList) || empty($tongjiList)){
							$mapZhuanyeMax = $map;
							$mapZhuanyeMax['field'] = 'nested('.$buchongTable.'.regtime)';
							$zhuanyemax = $this->model->getMax($mapZhuanyeMax);
							$base['buchong']['zhuanye'][$key]['zhuanyemax'] = ['date'=>str_replace(' 00:00:00','',$zhuanyemax),'label'=>'未启动'];
						}
						$base['buchong'][$key]['pingshenMin'] = ['date'=>$pingshenMin,'label'=>'开始技术审评'];
						//完成技术审评
						$pingshenMax = $this->pingshenMax($dslMap, $buchongTable , $zhuceinfo , '补充' , $nested_where_append );
						$base['buchong'][$key]['pingshenMax'] = ['date'=>$pingshenMax,'label'=>'完成技术审评'];
						//备注
						$base['buchong'][$key]['beizhu']  = $this->beizhu($map, $xinbaoTable);
					}
				}else{
					$buchongMin = $this->intoTask($dslMap, $buchongTable , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
					if(!empty($buchongMin)){
						$infoLabelPrev = $buchongTable === 'yzxpjolddata' ? '一致性评价补充任务' : '补充资料任务';
						$infoLabel = $infoLabelPrev.'第'.num_to_word($key+1).'轮';
						$pingshenzhuangtai = $this->pingshenzhuangtai($dslMap, 'buchong', '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$gongshileibie = $this->getField($dslMap, 'buchongolddata' , 'shenpingbumen', '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$xuhao = $this->xuhao($dslMap, 'buchong', '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$base['buchong'][$key]['min'] = ['date'=>str_replace(' 00:00:00','',$buchongMin),'label'=>'进入'.$infoLabelPrev , 'infoLabel'=>$infoLabel , 'pingshenzhuangtai' =>$pingshenzhuangtai,
									'gongshileibie' =>$gongshileibie, 'xuhao' =>$xuhao];
						//开始技术审评
						$pingshenMin = $this->pingshenMin($dslMap, $buchongTable, '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						//药理毒理专业 临床专业  药学专业
						$yaoliduliList = $this->getProfession($map , $buchongTable , $shoulihao , 'yaoliduli' , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$linchuangList = $this->getProfession($map , $buchongTable , $shoulihao , 'linchuang' , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$yaoxueList = $this->getProfession($map , $buchongTable , $shoulihao , 'yaoxue' , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						if($buchongTable === 'yzxpjolddata'){
							$tongjiList = $this->getProfession($map , $buchongTable , $shoulihao , 'tongji' , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
							$base['buchong']['zhuanye'][$key]['tongji'] = $tongjiList;
						}
						$base['buchong']['zhuanye'][$key]['yaoliduli'] = $yaoliduliList;
						$base['buchong']['zhuanye'][$key]['linchuang'] = $linchuangList;
						$base['buchong']['zhuanye'][$key]['yaoxue'] = $yaoxueList;
						if(empty($yaoliduliList) || empty($linchuangList) || empty($yaoxueList) || empty($tongjiList)){
							$mapZhuanyeMax = $map;
							$mapZhuanyeMax['field'] = 'nested('.$buchongTable.'.regtime)';
							$zhuanyemax = $this->model->getMax($mapZhuanyeMax);
							$base['buchong']['zhuanye'][$key]['zhuanyemax'] = ['date'=>str_replace(' 00:00:00','',$zhuanyemax),'label'=>'未启动'];
						}
						$base['buchong'][$key]['pingshenMin'] = ['date'=>$pingshenMin,'label'=>'开始技术审评'];
						//完成技术审评
						$pingshenMax = $this->pingshenMax($dslMap, $buchongTable , $zhuceinfo , '补充' , '{ "match_phrase" : {"'.$buchongTable.'.intodate" : "'.$intodate.'"}}');
						$base['buchong'][$key]['pingshenMax'] = ['date'=>$pingshenMax,'label'=>'完成技术审评'];
						//备注
						$base['buchong'][$key]['beizhu']  = $this->beizhu($map, $xinbaoTable);
					}
				}				
			}
		}
		//CFDA审批
		$dslMap['nested_field'] = '"zhuceolddata.date"';
		$dslMap['path'] = 'zhuceolddata';
		$dslMap['method'] = 'find';
		$dslMap['nested_sort'] = '';
		//CFDA 开始审批
		$dslMap['nested_where'] = '{ "match_phrase" : {"zhuceolddata.status" : "在审批"}}';
		$cfda_zaishenpin = getDslSearch($dslMap);
		if(!empty($cfda_zaishenpin['date'])){
			$base['cfda_zaishenpin'] = ['date'=>$cfda_zaishenpin['date'],'label'=>'CFDA 开始审批'];
		}
		//CFDA 审批完毕
		$dslMap['nested_where'] = '{ "match_phrase" : {"zhuceolddata.status" : "审批完毕"}}';
		$cfda_shenpinwanbi = getDslSearch($dslMap);
		if(!empty($cfda_shenpinwanbi['date'])){
			$base['cfda_shenpinwanbi'] = ['date'=>$cfda_shenpinwanbi['date'],'label'=>'CFDA 审批完毕'];
		}
		//CFDA 已发批件
		$dslMap['nested_relation'] = 'should';
		$dslMap['nested_where'] = '{ "match_phrase" : {"zhuceolddata.status" : "已发批件"}},{"match_phrase" : {"zhuceolddata.status" : "已发件"}}';
		$cfda_yifapijian = getDslSearch($dslMap);
		if(!empty($cfda_yifapijian['date'])){
			$base['cfda_yifapijian'] = ['date'=>$cfda_yifapijian['date'],'label'=>'CFDA 已发批件'];
		}
		$res = $base;
		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
    }
	
	
	
    /**
     * 返回值为指定专业情况
	 * @access private
     * @param array $map
     * @param string $table
     * @param string $shoulihao
     * @param string $field
     * @param string $renwufenlei
     * @param string $nested_where_append
     * @return string
     */
	private function getProfession($map = [] , $table = '' , $shoulihao = '' , $field = '', $renwufenlei = '',$nested_where_append = ''){
		$map['group'] = 'nested('.$table.'.'.$field.'.keyword,'.$table.')';
		$resGroup = $this->model->getGroupList($map);
		$lamp = ['<img src="/styles/images/lamp_y.jpg">'=>['label'=>'排队待审评','key'=>'daishenpin'] , '<img src="/styles/images/lamp.gif">'=>['label'=>'正在审评','key'=>'zaishenpin'] , '<img src="/styles/images/lamp_shut.gif">'=>['label'=>'已完成审评','key'=>'wanchengshenpin']];
		$return = [];
		if(!empty($resGroup[$field])){
			foreach($resGroup[$field] as $value){
				if(empty($value['key'])){
					continue;
				}
				$dslMap['where'] = '{ "shoulihao" : "'.$shoulihao.'" }';
				$dslMap['table'] = 'zhuce';
				$dslMap['method'] = 'find';
				$dslMap['path'] = $table;
				$dslMap['model'] = $this->model;
				$dslMap['nested_where'] = '{ "match_phrase" : {"'.add_keyword($table.'.'.$field).'" : "'.addslashes(trim($value['key'])).'"}}';
				if($table == 'yzxpjolddata' && !empty($renwufenlei)){
					$dslMap['nested_where'] .= ',{ "match_phrase" : {"'.add_keyword($table.'.shenpingrenwufenlei').'" : "'.$renwufenlei.'"}}';
				}
				if(!empty($nested_where_append)){
					$dslMap['nested_where'] .= ','.$nested_where_append;
				}
				$dslMap['nested_sort'] = '{ "'.$table.'.regtime": "asc" }';
				$dslMap['nested_field'] = '"'.$table.'.regtime"';
				$pingshenMinTemp = getDslSearch($dslMap);
				
				if(isset($pingshenMinTemp['regtime']) && array_key_exists($value['key'] , $lamp)){
					$return[$lamp[$value['key']]['key']] = ['date'=>$pingshenMinTemp['regtime'],'label'=>$lamp[$value['key']]['label']];
				}
			}
		}
		return $return;
	}
	
    /**
     * 进入任务 (timeline时光轴子方法)
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param string $renwufenlei
     * @param string $nested_where_append
     * @return int
     */
	private function intoTask($dslMap = [], $table = '', $renwufenlei = '',$nested_where_append = ''){
		$min = 0;
		$dslMap['path'] = $table;
		$dslMap['method'] = 'find';
		$dslMap['nested_sort'] = '{ "'.$table.'.regtime": "asc" }';
		$dslMap['nested_field'] = '"'.$table.'.regtime"';
		if($table == 'yzxpjolddata'){
			$dslMap['nested_where'] = '{ "match_phrase" : {"'.add_keyword($table.'.shenpingrenwufenlei').'" : "'.$renwufenlei.'"}}';
		}else{
			$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		}
		if(!empty($nested_where_append)){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$minTemp = getDslSearch($dslMap);
		$min = isset($minTemp['regtime']) ? $minTemp['regtime'] : 0;
		return $min;
	}

    /**
     * 开始技术审评 (timeline时光轴子方法)
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param string $renwufenlei
     * @param string $nested_where_append
     * @return int
     */
	private function pingshenMin($dslMap = [] , $table = '' , $renwufenlei = '',$nested_where_append = ''){
		$pingshenMin = 0;
		if($table == 'yzxpjolddata'){
			$dslMap['path'] = $table;
			$dslMap['nested_where'] = '{ "match_phrase" : {"'.add_keyword($table.'.shenpingrenwufenlei').'" : "'.$renwufenlei.'"}}';
			if(!empty($nested_where_append)){
				$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
			}
			$dslMap['nested_sort'] = '{ "'.$table.'.regtime": "asc" }';
			$dslMap['nested_field'] = '"'.$table.'.regtime","'.$table.'.tongji","'.$table.'.yaoliduli","'.$table.'.yaoxue","'.$table.'.linchuang"';
			$dslMap['nested_size'] = 30;
			$pingshenMinList = getDslSearch($dslMap);
			foreach($pingshenMinList as $pingshen){
				if(!empty($pingshen['tongji']) || !empty($pingshen['yaoliduli']) || !empty($pingshen['yaoxue']) || !empty($pingshen['linchuang'])){
					$pingshenMin = $pingshen['regtime'];
					break;
				}
			}
		}else{
			$dslMap['path'] = $table;
			$dslMap['method'] = 'find';
			$dslMap['nested_where'] = '{ "match_phrase" : {"'.add_keyword($table.'.pingshenzhuangtai').'" : "正在审评中"}}';
			if(!empty($nested_where_append)){
				$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
			}
			$dslMap['nested_sort'] = '{ "'.$table.'.regtime": "asc" }';
			$dslMap['nested_field'] = '"'.$table.'.regtime"';
			$pingshenMinTemp = getDslSearch($dslMap);
			$pingshenMin = isset($pingshenMinTemp['regtime']) ? $pingshenMinTemp['regtime'] : 0;
		}
		return $pingshenMin;
	}
	
    /**
     * 完成技术审评 (timeline时光轴子方法)
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param array $zhuceinfo
     * @param string $renwufenlei
     * @param string $nested_where_append
     * @return int
     */
	private function pingshenMax($dslMap = [] , $table = '' , $zhuceinfo = [] , $renwufenlei = '',$nested_where_append = ''){
		$dslMap['path'] = $table;
		$dslMap['method'] = 'find';
		$dslMap['nested_sort'] = '{ "'.$table.'.regtime": "desc" }';
		$dslMap['nested_field'] = '"'.$table.'.regtime"';
		if($table == 'yzxpjolddata' && $zhuceinfo['yzxpj'][0]['null_value'] == 0){
			$dslMap['nested_where'] = '{ "match_phrase" : {"'.$table.'.shenpingrenwufenlei" : "'.$renwufenlei.'"}}';
		}else if($table == 'xinbaoolddata' && $zhuceinfo['xinbao'][0]['null_value'] == 0){
			$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		}else if($table == 'buchongolddata' && $zhuceinfo['buchong'][0]['null_value'] == 0){
			$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		}
		if(!empty($nested_where_append) && !empty($dslMap['nested_where'])){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$pingshenMaxTemp = getDslSearch($dslMap);
		$pingshenMax = isset($pingshenMaxTemp['regtime']) ? $pingshenMaxTemp['regtime'] : 0;
		return $pingshenMax;
	}
	
    /**
     * 备注 (timeline时光轴子方法)
	 * @access private
     * @param array $map
     * @param string $table
     * @return array
     */
	private function beizhu($map = [], $table = ''){
		$map['field'] = $table;
		$resTable = $this->model->getAll($map);
		$return = [];
		$newArray = [];
		if(!empty($resTable['res'][0][$map['field']])){
			foreach($resTable['res'][0][$map['field']] as $value){
				if(!empty($value['beizhu'])){
					$newArray[] = ['beizhu' => $value['beizhu'] , 'regtime' => $value['regtime']];
				}
			}
		}	
		if(!empty($newArray)){
			$tempnewArray = multi_array_sort($newArray , 'regtime' , SORT_ASC);
			$return = array_unique_second($tempnewArray , 'beizhu');
		}
		return $return;
	}
	
    /**
     * 进入新报任务 pingshenzhuangtai (timeline时光轴子方法)
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param string $nested_where_append
     * @return string
     */
	private function pingshenzhuangtai($dslMap = [], $table = '',$nested_where_append = ''){
		$return = '';
		$dslMap['path'] = $table;
		$dslMap['nested_field'] = '"'.$table.'.pingshenzhuangtai"';
		$dslMap['nested_where'] = '{ "match_phrase" : {"'.$table.'.null_value" : "1"}} , { "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		$dslMap['method'] = 'find';
		if(!empty($nested_where_append)){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$base = getDslSearch($dslMap);
		if(!empty($base['pingshenzhuangtai'])){
			$return = $base['pingshenzhuangtai'];
			return $return;
		}
		$tableNew = $table.'olddata';
		$dslMap['path'] = $tableNew;
		$dslMap['nested_field'] = '"'.$tableNew.'.null_value"';
		$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		if(!empty($nested_where_append)){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$extend = getDslSearch($dslMap);
		if(!empty($extend)){
			$return = '已完成审评';
		}
		return $return;
	}
	
    /**
     * 获取子表单字段值 getField (timeline时光轴子方法) 
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param string $field
     * @param string $nested_where_append
     * @return string
     */
	private function getField($dslMap = [], $table = '', $field = '', $nested_where_append = ''){
		$return = '';
		$dslMap['path'] = $table;
		$dslMap['nested_field'] = '"'.$table.'.'.$field.'"';
		$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		$dslMap['method'] = 'find';
		if(!empty($nested_where_append)){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$base = getDslSearch($dslMap);
		if(!empty($base[$field])){
			$return = $base[$field];
			return $return;
		}
		return $return;
	}
	
    /**
     * 进入新报任务 序列号/排队号 (timeline时光轴子方法)
	 * @access private
     * @param array $dslMap
     * @param string $table
     * @param string $nested_where_append
     * @return string
     */
	private function xuhao($dslMap = [], $table = '',$nested_where_append = ''){
		$return = '';
		$dslMap['path'] = $table;
		$dslMap['nested_field'] = '"'.$table.'.xuhao"';
		$dslMap['nested_where'] = '{ "exists" : { "field" : '.$dslMap['nested_field'].' }}';
		$dslMap['method'] = 'find';
		if(!empty($nested_where_append)){
			$dslMap['nested_where'] = $dslMap['nested_where'] .','. $nested_where_append;
		}
		$base = getDslSearch($dslMap);
		if(!empty($base['xuhao'])){
			$return = $base['xuhao'];
		}
		return $return;
	}
	
    /**
     * 保存搜索条件
	 * @access public
     * @return array
     */
	public function saveWhere(){
		$res = [];
		$code = save_where(); 
        return getRes($res, $code);
	}
	
    /**
     * 删除搜索条件
	 * @access public
     * @return array
     */
	public function delSaveWhere(){
		$res = [];
		$code = del_save_where();
        return getRes($res, $code);
	}
	
    /**
     * 读取搜索条件列表
	 * @access public
     * @return array
     */
	public function saveWhereList(){
        return save_where_list();
	}
	
	/**
	 * [getBaseInfo 注册基本信息接口]
	 * @param  [array] $param [受理号]
	 * @return [type]        [description]
	 */
	public function getBaseInfo($id){
		$code = 200;
		// 查询
		$where['id'] = $id;
		$map['where'] = $where;
		$map['table'] = 'zhuce';
		$defaultField = 'id,shoulihao,name,qiyemingcheng,banlizhuangtai,chengbanriqi,zhuceleixing,zhuangtaikaishishijian,jielun.xulie,jielun.jielun,yaopinpizhunwenhao,shoufeiqingkuang,feiyongdaozhiri,jianyanbaogaoshoudaori,biaozhunpinhuizhishoudaori,tongzhineirong,tongzhishijian,xcjc,nyxcjc,yxsp,tspz,zdzx,yaopinleixing_1,shenqingleixing_1,qiyelianheshenbao,songda,remarks,drugid,qiyebianmatz,bianma,ylbm';
		$noFieldRules = config('noFieldRules');
		if(!empty($noFieldRules)){
			$fieldArray = explode(',' , $defaultField);
			$lastFieldArray = array_diff($fieldArray , $noFieldRules );
			$defaultField = implode(',' , $lastFieldArray);
		}
		$map['field'] = $defaultField;
		$res = $this->model->getOne($map);
		foreach ($res as $k => $v) {
			if (isset($v[0]['null_value']) && $v[0]['null_value']==0) {
				$res[$k] = [];
			}
		}
		if (!$res) {
			$code = 404;
		}else {
			$res['extendList'] = gldatanum($res);

			//受理号订阅
			$maprssshoulihao['where'] = ['field'=>['eq','shoulihao'] , 'keywords'=>['eq',$res['shoulihao']]];
			$maprssshoulihao['field'] = 'id';
			$maprssshoulihao['table'] = 'base_rsswhere';
			$rssshouli = model('rss')->getOne($maprssshoulihao);
			//药品名称订阅
			$maprssshoulihao['where'] = ['field'=>['eq','name'] , 'keywords'=>['eq',$res['name']]];
			$rssname = model('rss')->getOne($maprssshoulihao);
			//企业订阅
			$maprssshoulihao['where'] = ['field'=>['eq','qiyemingcheng'] , 'keywords'=>['eq',$res['qiyemingcheng']]];
			$rssqiye = model('rss')->getOne($maprssshoulihao);
			$rss['shoulihao'] = empty($rssshouli) ? 0 : 1;
			$rss['name'] = empty($rssname) ? 0 : 1;
			$rss['qiye'] = empty($rssqiye) ? 0 : 1;
			$res['rss'] = $rss;
			
			// 组合药理分类
			$bianma = $res['bianma'];
			$mapScr['where'] = ['bianma'=>$bianma];
			$mapScr['field'] = 'atcb';
			$scr = model('YzScr')->getOne($mapScr);
			// var_dump($scr);exit();
			// 如果yz_scr表存在act字段值
			$atc = [];
			if ($scr) {
				$atc = model('YzAtc','logic')->getAtc($scr);
			}
			$res['atc'] = $atc;
			// 其他字段查询
			$res['ctd'] = '否';
			// 是否是CTD格式
			if ($res['shoulihao']) {
				$modelall = model('YzAll');
				$ctd['where']['shoulihao'] = $res['shoulihao'];
				$modelall->table = 'yz_ss_ctd';
				$ctd = $modelall->getCount($ctd);
				if ($ctd) $res['ctd'] = '是';
			}
			// 临床试验登记号
			$res['lcsydjh'] = [];
			if ($res['drugid']) {
				$map_linchuangshiyan['where']['drugid'] = $res['drugid'];
				$map_linchuangshiyan['field'] = 'id,me_id';
				$lcsydjh = model('YzLinchuangshiyan')->getAll($map_linchuangshiyan);
				if ($lcsydjh && isset($lcsydjh['res']) && $lcsydjh['res']) {
					$res['lcsydjh'] = $lcsydjh['res'];
				}
			}

			// 送达信息
			if ($res['songda']) {
				foreach ($res['songda'] as $k => $v) {
					if ($v) {
						$res['songda'][$k] = $v['songda'].' 寄发通知';
					}
				}
			}
			// $remarks = $res['remarks'];
			// unset($res['remarks']);
			// if ($remarks) {
			// 	$res['remarks'] = isset($remarks[0]['remarks'])?$remarks[0]['remarks']:'';
			// }else{
			// 	$res['remarks'] = '';
			// }
		}
		return getRes($res,$code);
	}

	/**
	 * [getDevProcess 研发历程接口：直接调用研发历程]
	 * @param  array  $param [description]
	 * @return [type]        [description]
	 */
	public function getDevProcess($param = []){
		$res = [];
		$code = 200;
		// 查询注册的drugid
		$where['id'] = $param['id'] ?? 0;
		$map['where'] = $where;
		$map['table'] = 'zhuce';
		$map['field'] = 'drugid'; 
		$resZhuce = $this->model->getOne($map);
		// 获取研发历程
		$res = model('DevProcess','logic')->getAll($resZhuce);
		if (!$res) {
			$code = 404;
		}
		return getRes($res,$code);
	}

}