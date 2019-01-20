<?php
namespace app\common\logic;

/**
 * [BCS分类信息查询]
 */
class YzAll{

    protected $request = '';


    public function __construct(){
        $this->model = model('YzAll');
    }

    /**
     * [common 根据配置分配操作]
     * @return [type] [description]
     */
    public function common(){
        $res = [];
        $this->request = request();
        $controller = $action = '';
        // controller
        if (!$this->request->routeInfo()) {
            $controller = strtolower($this->request->controller());
        }else{
            $controller = $this->request->routeInfo()['rule'][0];
        }
        // action
        $action = strtolower($this->request->action());
        if ($controller && $action) {
            // 根据controller获取配置
            
            $map['where'] = ['z.db_control' => $controller,'z.status' => 1,'a.status' => 1];
            $model = model('BaseApisite');
            $map['alias'] = 'a';
            $map['field'] = 'a.id,a.dbid,a.tablename,a.param_config,a.list_field,a.param_detail,a.details_field,a.filter,a.comment,a.order,a.status,field_extend,z.db_control as modelName';
            $map['join'] = [[['base_dblist'=>'z'],'a.dbid=z.id','left']];
			$map['order'] = '';
            $apiSite = $model->getOne($map);
            // 设置当前表名
            $this->model->table = $apiSite['tablename'];
            // var_dump($action);
            // var_dump($param);
            // exit();
            switch ($action) {
                case 'index':
                    $res = $this->getList($apiSite);
                    break;
                case 'read':
                    $res = $this->getDetail($apiSite);
                    break;
                case 'input':
                    $res = $this->getInput($apiSite);
                    break;
                case 'outdata':
                    $res = $this->getOutData($apiSite);
                    break;
				case 'savewhere':
                    $res = $this->saveWhere($apiSite);
                    break;
				case 'delsavewhere':
                    $res = $this->delSaveWhere($apiSite);
                    break;
				case 'savewherelist':
                    $res = $this->saveWhereList($apiSite);
                    break;
            }
        }
        return $res;
    }

    /**
     * [getList 获取列表]
     * @param  [type]  $apiSite [description]
     * @param  array   $map     [description]
     * @param  integer $getData [1：直接返回当前数据]
     * @return [type]           [description]
     */
	public function getList($apiSite, $map = [], $getData = 0){
        // 获取指定参数
        //$paramsite = json_decode($apiSite['param_config'], true);
		$paramsite = unserialize($apiSite['param_config']);
        $only = [];
        foreach ($paramsite as $k => $v) {
            $only[] = $v['var'];
        }
        // 添加允许综合搜索过来的字段
        $only[] = 'comprehensive';
        $only[] = 'searchwords';
        $only[] = 'words';
        $only[] = 'filter_condition';
        $only[] = 'fourth_condition';
        
        $only = implode(',', $only);
        $param = $this->request->instance()->only($only);
        // 组合条件
        $code = 200;
        $where = [];
        // 参数处理   	
        if(!empty($param['comprehensive'])){  //综合搜索过来
            $controller = strtolower($apiSite['modelName']);
            $where = comprehensive_to_where($controller,$param,'db');
            $map['where'] = $where;
        }else if(!empty($param['fourth_condition'])){  //当前表搜索
			if(isset($param['fourth_condition'])) $map['where_high'] = where_high($paramsite, $param['fourth_condition']); // 第四种查询
            $map['where'] = where_ordinary($paramsite, $param);   // 普通搜索
        }else{
			// $where = param_to_where($paramsite, $param);
            if(isset($param['words'])) $map['where_high'] = where_high($paramsite, $param['words']); // 高级搜索
            $map['where'] = where_ordinary($paramsite, $param);   // 普通搜索
		}
		if(!empty($param['filter_condition'])){ //二次筛选选项
			$map['where_filter'] = where_high($paramsite, $param['filter_condition']);
		}
        $map['field'] = $apiSite['list_field'];
		$noFieldRules = config('noFieldRules');
		if(!empty($noFieldRules)){
			$fieldArray = explode(',' , $apiSite['list_field']);
			$lastFieldArray = array_diff($fieldArray , $noFieldRules );
			$map['field'] = implode(',' , $lastFieldArray);
		}
        //$map['debug'] = 'sql';
        // 列表筛选
		$field = explode(',',$map['field']);
		foreach($field as $key=>$value){
			if(strstr($value,':')){
				$newfieldre = explode(':',$value);
				$newfield[$newfieldre[0]] = $newfieldre[1];
				unset($field[$key]);
			}
		}
		$map['field'] = implode(',',$field);
		$map['default_order'] = $apiSite['order'] ?? '';
        $res = $this->model->getList($map);
		if(isset($newfield)) {
			if ($res) {
				foreach ($res['res'] as $k => $v) {
					$tmpkey = array_keys($v);
					foreach ($newfield as $k1 => $v1) {
						if (in_array($k1, $tmpkey)) {
							if(isset($v['id'])){
								$v[$k1] = call_user_func($v1, $v['id']);
							}else{
								$v[$k1] = call_user_func($v1, $v[$k1]);
							}
						}elseif(isset($v['id'])){
							$v[$k1] = call_user_func($v1, $v['id']);
						}
					}
					$res['res'][$k] = $v;
				}
			}
		}
        // 方便其他函数使用数据
        if ($getData == 1) {
            return $res;
        }
        $GroupList = [];
        // 二次筛选
        if ($apiSite['filter']) {
			//获取base_search
			$mapSearch['where'] = ['dbid' => $apiSite['dbid']];
            $mapSearch['field'] = 'filter';
			$basetable = $this->model->table;
            $this->model->table = 'base_search';
			$mapSearch['order'] = '';
			$searchFilter = $this->model->getOne($mapSearch);
			$filterArray = unserialize($searchFilter[$mapSearch['field']]);
			$filterArray = multi_array_sort($filterArray,'sort');
			
			$this->model->table = $basetable;
			//apiSite  filter字段没用到
            foreach ($filterArray as $k => $v) {
				if(!empty($filterArray[$k]['option'])){
					$optionArray = explode(',' , $filterArray[$k]['option']);
					if(strstr($filterArray[$k]['option'] , '=')){
						$optionType = 3;
					}else{
						$optionType = 2;
					}
				}else{
					$optionType = 1;
				}
				$map['field'] = $v['field'];
				$map['group'] = $v['field'];
                $group = $this->model->getGroup($map);
				foreach ($group as $key => $value) {
					if (!$value[$v['field']]) unset($group[$key]);
				}
                array_multisort(array_column($group, 'count'),SORT_DESC,$group);
				$groupArray = array_column($group,null,$map['field']);
				if ($group) {
					$filter = [];
					if($optionType == 1){
						foreach($group as $item){
							$filter[] = ['doc_count' => $item['count'],'key' => $item[$map['field']],'label' => $item[$map['field']]]; 
						}
					}else if($optionType == 2){
						$havecount = 0;
						foreach($optionArray as $item){
							if(!empty($groupArray[$item])){
								if($groupArray[$item]['count'] > 0){
									$filter[] = ['doc_count' => $groupArray[$item]['count'],'key' => $item,'label' => $item]; 
									$havecount += $groupArray[$item]['count'];
								}
							}else if($item == '其他'){
								$totalcount = array_sum(array_column($group , 'count'));
								$othercount = $totalcount - $havecount;
								if($othercount > 0){
									$filter[] = ['doc_count' => $othercount,'key' => $item,'label' => $item]; 
								}
							}
						}
					}else if($optionType == 3){
						$havecount = 0;
						foreach($optionArray as $item){
							$temp = explode('=' , $item);
							$kev = [];
							if(count($temp) == 1){
								$kev['key'] = $item;
								$kev['val'] = $item;
							}else{
								$kev['key'] = $temp[0];
								$kev['val'] = $temp[1];
							}
							if(!empty($groupArray[$kev['key']])){
								if($groupArray[$kev['key']]['count'] > 0){
									$filter[] = ['doc_count' => $groupArray[$kev['key']]['count'],'key' => $kev['key'],'label' => $kev['val']]; 
									$havecount += $groupArray[$item]['count'];
								}
							}else if($item == '其他'){
								$totalcount = array_sum(array_column($group , 'count'));
								$othercount = $totalcount - $havecount;
								if($othercount > 0){
									$filter[] = ['doc_count' => $othercount,'key' => $item,'label' => $item]; 
								}
							}
						}
					}
					if(!empty($filter)){
						$GroupList[$v['name']] = ['label' => $v['label'] , 'data' => $filter];
					}
				}
            }
        }
		//添加进搜索历史
		if(!empty($map['where'])){
			$tokenUser = config('tokenUser');
			$dbConf = config('dbConf');
			$url = $this->request->instance()->url();
			$redis = model('RedisService','service');
			$redkey = md5(($tokenUser['uid'] ?? '') . 'search' .$url);
			if (!$redis->exists($redkey)) {
				$historyWhereData['uid'] = $tokenUser['uid'] ?? 0;
				$historyWhereData['username'] = $tokenUser['username'] ?? '';
				$historyWhereData['rank_name'] = $tokenUser['rank_name'] ?? '';
				$historyWhereData['whereinfo'] = $url;
				$historyWhereData['dbid'] = $dbConf['id'] ?? 0;
				$historyWhereData['dbname'] = $dbConf['dbname'] ?? '';
				$historyWhereData['addtime'] = time();
				$historyWhereData['num'] = $res['count'] ?? 0;
				$mapHistoryWhere['table'] = 'base_history_where';
				$mapHistoryWhere['data'] = $historyWhereData;
				model('NewDb')->insert($mapHistoryWhere);   
				$redis->set($redkey, $redkey, 300); //保存5分钟
			}
		}

        if (!$res) {
            $code = 404;
        }else{
			$res['GroupList'] = $GroupList;
		}
		
        return getRes($res, $code);
	}
	
    /**
     * 保存搜索条件
	 * @access public
     * @return array
     */
	public function saveWhere($apiSite = []){
		$res = [];
		$code = save_where(); 
        return getRes($res, $code);
	}
	
    /**
     * 删除搜索条件
	 * @access public
     * @return array
     */
	public function delSaveWhere($apiSite = []){
		$res = [];
		$code = del_save_where();
        return getRes($res, $code);
	}
	
    /**
     * 读取搜索条件列表
	 * @access public
     * @return array
     */
	public function saveWhereList($apiSite = []){
        return save_where_list();
	}

    /**
     * [getDetail 获取详情]
     * @param  [type] $apiSite [description]
     * @return [type]          [description]
     */
    public function getDetail($apiSite){
        $res = [];
        if ($apiSite['param_detail']) {
            // 获取指定参数
            $only = $apiSite['param_detail'];
            $param = $this->request->instance()->only($only);
            // 组合条件
            $code = 200;
            $id[$only] = $param[$only];
            $map['where'] = $id;
            $map['field'] = $apiSite['details_field'];
			$noFieldRules = config('noFieldRules');
			if(!empty($noFieldRules)){
				$fieldArray = explode(',' , $apiSite['details_field']);
				$lastFieldArray = array_diff($fieldArray , $noFieldRules );
				$map['field'] = implode(',' , $lastFieldArray);
			}
			$field = explode(',',$map['field']);
			foreach($field as $key=>$value){
				if(strstr($value,':')){
					$newfieldre = explode(':',$value);
					$newfield[$newfieldre[0]] = $newfieldre[1];
					unset($field[$key]);
				}
			}
			$map['field'] = implode(',',$field);

            $res = $this->model->getOne($map);
			if(isset($newfield)) {
				if ($res) {
					$tempkey = array_keys($res);
					foreach($newfield as $k=>$v){
						if(in_array($k,$tempkey)){
							$res[$k] = call_user_func($v,$res[$k]);
						}
					}
				}
			}
        }
        if (!$res) {
            $code = 404;
        }else{
			$res['extendList'] = gldatanum($res);
		}
        return getRes($res, $code);

    }

    /**
     * [getInput 单表输入提示]
     * @param  [type] $apiSite [description]
     * @return [type]          [description]
     */
    public function getInput($apiSite){
        $request = $this->request->param();
        $paramsite = unserialize($apiSite['param_config']);
        //定义为字符串表示只能获取一个参数
        $res = [];
        foreach ($paramsite as $k => $v) {
            if (array_key_exists($v['var'], $request)) {
                $map = [];
                // name like "参数%"
                $map['field'] = str_replace('|' , ',' , $v['hint']);
                $map['table'] = $apiSite['tablename'];
                $map['where'] = [$v['hint']=>['LIKE',$request[$v['var']].'%']];
                break;
            }
        }
        if (!isset($map['where']) || empty($map['where'])) {
            $res = [];
        }else{
			$map['limit'] = '0,10';
            $restemp = $this->model->select($map);
			
			$restemp2 = [];
			if(count($restemp) < 10){
				$map2 = [];
				foreach ($paramsite as $k => $v) {
					if (array_key_exists($v['var'], $request)) {
						$map2['field'] = str_replace('|' , ',' , $v['hint']);
						$map2['table'] = $apiSite['tablename'];
						$map2['where'] = [$v['hint']=>['LIKE','%'.$request[$v['var']].'%']];
						break;
					}
				}
				$map2['limit'] = '0,10';
				$restemp2 = $this->model->select($map2);
			}
			$arr = [];
			foreach ($restemp as $key=>$value) {
				foreach($value as $val){
					if(!empty($val)){
						array_push($arr , $val);	
					}
				}
			}
			foreach ($restemp2 as $key=>$value) {
				foreach($value as $val){
					if(!empty($val)){
						array_push($arr , $val);	
					}
				}
			}
			$res=array_slice(array_unique($arr),0,10);
        }
        $code = 200;
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }

    /**
     * [getOutData 数据导出]
     * @param  [type] $apiSite [基本表配置]
     * @return [type]          [description]
     */
    public function getOutData($apiSite){
        $res = [];
        $map['limit'] = '0,'.outMaxNum($apiSite['modelName']);
        $request = $this->request->param();
        if (isset($request['outdata_column'])) {
            $param = $request['outdata_column'];
            // 获取数据
            $resList = $this->getList($apiSite, $map, 1);
            $data=$resList['res'];
            $tablename = $apiSite['comment'];
            $list = dealOutDataParam($param);
            if (!empty($list)) {
                @out_data($data,$list,$tablename);
                exit();
            }else{
                $code = 404;
            }
        }else{
            $code = 404;
        }
        return getRes($res, $code);
    }

}