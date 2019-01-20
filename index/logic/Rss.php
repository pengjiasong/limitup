<?php
namespace app\common\logic;

/**
 * [订阅类接口]
 */
class Rss{
	private $model;
	
    public function __construct(){
        $this->model = model('Rss');
    }
	//nav id
	private $dbarray = array('2'=>'zhuce' , '3'=>'zhaobiaodongtai');

	
    /**
     * 添加zhuce订阅条件
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function addWhere($param) {	
		$code = 200;
		$res = [];
		$tokenUser = config('tokenUser');
		$rsswhere['dbid'] = array_search($param['dbname'] , $this->dbarray);
		if(empty($rsswhere['dbid']) || empty($param['subscribe_type']) || empty($param['send_type'])){
			$code = 401;
			return getRes($res, $code);
		}
		$rsswhere['uid'] = $tokenUser['uid'];
		if(!empty($param['shoulihao'])){
			$category = '受理号';
			$keywords = $param['shoulihao'];
			$field = 'shoulihao';
			//按受理号订阅判断是否已在名称或企业中订阅过
			$mapZhuce['table'] = $param['dbname'];
			$mapZhuce['where'] = db_where('shoulihao' , '=' , $keywords);
			$mapZhuce['field'] = 'name,qiyemingcheng,ylbm';
			$resZhuce = $this->model->getOne($mapZhuce);
			if(!empty($resZhuce)){
				$rsswhereShouli['field'] = [['=','name'],['=','qiyemingcheng'],['=','ylbm'],'or'];
				$rsswhereShouli['keywords'] = [['=',$resZhuce['name']],['=',$resZhuce['qiyemingcheng']],['=',$resZhuce['ylbm']],'or'];
				$mapRsswhere2['table'] = 'base_rsswhere';
				$mapRsswhere2['where'] = $rsswhere;
				$mapRsswhere2['where_high'] = $rsswhereShouli;
				if($this->model->count($mapRsswhere2)) {
					$code = 10003;
					return getRes($res, $code);
				}
			}else{
				$code = 11016;
				return getRes($res, $code);
			}
		}else if(!empty($param['name'])){
			$category = '药品名称';
			$keywords = $param['name'];
			$field = 'name';
		}else if(!empty($param['qiyemingcheng'])){
			$category = '企业名称';
			$keywords = $param['qiyemingcheng'];
			$field = 'qiyemingcheng';
		}else if(!empty($param['ylbm'])){
			$category = '活性成分';
			$keywords = $param['ylbm'];
			$field = 'ylbm';
		}
		if(empty($field)){
			$code = 10002;
			return getRes($res, $code);
		}
		//兼容DB/ES数据查询
		$checkMap['table'] = $param['dbname'];
		$dbs = config('ES.DBS');
		if(in_array($checkMap['table'] , $dbs)){
			$checkMap['where'] = db_where($field , '=' , $keywords);
		}else{
			$checkMap['where'] = [$field => $keywords];
		}
		if(!$this->model->count($checkMap)){
			$code = 11016;
			return getRes($res, $code);
		}	
		$rsswhere['category'] = $category;
		$rsswhere['keywords'] = $keywords;
		$rsswhere['field'] = $field;
		$mapRsswhere['table'] = 'base_rsswhere';
		$mapRsswhere['where'] = $rsswhere;
		if($this->model->count($mapRsswhere)) {
			$code = 10003;
			return getRes($res, $code);
		}

		$rsswhere['subscribe_type'] = $param['subscribe_type'] ?? 0;
		$rsswhere['send_type'] = str_replace(['2,3','3,2'],'1',implode(',',(array)$param['send_type']));
		if(in_array($rsswhere['send_type'] , array(1,3))){
			if(empty($param['send_email'])){
				$code = 401;
				return getRes($res, $code);
			}
			$rsswhere['send_email'] = $param['send_email'];
		}
		
		$rsswhere['addtime'] = time();
		$mapRsswhereInsert['data'] = $rsswhere;
		$mapRsswhereInsert['table'] = $mapRsswhere['table'];
		if($this->model->insert($mapRsswhereInsert)){
			return getRes($res, $code);
		}else{
			$code = 404;
			return getRes($res, $code);
		}
	}
	
    /**
     * 添加zhuce提示信息
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function zhuceinput($param) {	
		$code = 200;
		$res = [];
		if(!empty($param['shoulihao'])){
			$field = 'shoulihao';
			$keywords = $param['shoulihao'];
		}else if(!empty($param['name'])){
			$field = 'name';
			$keywords = $param['name'];
		}else if(!empty($param['qiyemingcheng'])){
			$field = 'qiyemingcheng';
			$keywords = $param['name'];
		}else if(!empty($param['ylbm'])){
			$field = 'ylbm';
			$keywords = $param['ylbm'];
		}
		if(empty($field)){
			$code = 10002;
			return getRes($res, $code);
		}
		$mapZhuce['table'] = 'zhuce';
		$mapZhuce['where'] = db_where($field , 'like' , $keywords);
		$mapZhuce['group'] = $field;
		$mapZhuce['field'] = str_field($field);
		$mapZhuce['limit'] = '0,15';
		$resZhuce = $this->model->select($mapZhuce);
		if(!empty($resZhuce[$field])) {
			$res = array_column($resZhuce[$field] , 'key');
		}else{
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 订阅条件列表
     * @access public 
     * @return array
     */
	public function whereList(){
		$code = 200;
		$res = [];
		$tokenUser = config('tokenUser');
		$where['uid'] = $tokenUser['uid'];
		$map['table'] = 'base_rsswhere';
		$map['field'] = 'id,dbid,category,keywords,subscribe_type,send_type,addtime';
		$map['order'] = 'addtime desc';
		$map['where'] = $where;
		$res = $this->model->getList($map);
		if(empty($res)){
			$code = 404;
			return getRes($res, $code);	
		}
		foreach($res['res'] as $key=>$val){
			$res['res'][$key]['head_title'] = '';
			$res['res'][$key]['subscribe_title'] = '';
			$res['res'][$key]['send_title'] = '';
			if($val['dbid'] == 2){
				$res['res'][$key]['head_title'] = lang('zhuce dbname');
			}
			if($val['subscribe_type'] == 1){
				$res['res'][$key]['subscribe_title'] = lang('subscribe change');
			}
			if($val['send_type'] == 1){
				$res['res'][$key]['send_title'] = lang('zhuce send all type');
			}else if($val['send_type'] == 2){
				$res['res'][$key]['send_title'] = lang('send system');
			}else if($val['send_type'] == 3){
				$res['res'][$key]['send_title'] = lang('send email');
			}
			unset($res['res'][$key]['dbid'],$res['res'][$key]['subscribe_type'],$res['res'][$key]['send_type']);
		}
		return getRes($res, $code);
	}
	
    /**
     * 用户新消息列表
     * @access public 
     * @return array
     */
	public function msgList(){
		$code = 200;
		$res = [];
		$limit = get_limit();
		$tokenUser = config('tokenUser');
		$wheres[] = 'uid = '.$tokenUser['uid'];
		$wheres[] = 'send_type != 3';
		$sql = 'SELECT id,title,fulltitle,dbid,infoid,`status`,type,addtime,field FROM(SELECT * FROM base_newmsg where dbid !=0 && '.implode(' && ' , $wheres).' ORDER BY addtime DESC ) AS t GROUP BY  CONCAT(title,dbid) 
				UNION ALL
				SELECT id,title,fulltitle,dbid,infoid,`status`,type,addtime,field FROM(SELECT id,title,fulltitle,dbid,infoid,type,addtime,field,if(base_newmsg_read.uid = '.$tokenUser['uid'].' , 1 , 0) as status FROM base_newmsg LEFT JOIN base_newmsg_read ON base_newmsg.id = base_newmsg_read.msgid WHERE dbid = 0 group BY base_newmsg.id ORDER BY addtime DESC ) AS c
				ORDER BY  status asc,addtime DESC limit ' . $limit;
		
		$msgList = $this->model->query(['sql'=>$sql]);
		if(empty($msgList)){
			$code = 404;
			return getRes($res, $code);
		}
		foreach($msgList as $key=>$val){
			$msgList[$key]['head_title'] = '系统公告';
			$msgList[$key]['type_title'] = '';
			if($val['dbid'] == 2){
				if($val['field'] == 'shoulihao'){
					$msgList[$key]['title'] = $val['fulltitle'];
				}
				if($val['type'] == 1){
					$msgList[$key]['type_title'] = lang('zhuce shoulihao change');
				}else if($val['type'] == 2){
					$msgList[$key]['type_title'] = lang('zhuce new register');
				}else if($val['type'] == 3){
					$msgList[$key]['type_title'] = lang('zhuce shoulihao change');
				}
				$msgList[$key]['head_title'] = lang('zhuce rss');
			}
			/* else if($val['dbid'] == 0){
				$whereRead['uid'] = $tokenUser['uid'];
				$whereRead['msgid'] = $val['id'];
				$mapRead['table'] = 'base_newmsg_read';
				$mapRead['where'] = $whereRead;
				if($this->model->count($mapRead)){
					$msgList[$key]['status'] = 1;
				}else{
					$msgList[$key]['status'] = 0;
				}
			} */
			unset($msgList[$key]['fulltitle'],$msgList[$key]['field']);
		}

		//count
		$countSql = 'SELECT id FROM(SELECT * FROM base_newmsg where dbid !=0 && '.implode(' && ' , $wheres).') AS t GROUP BY  CONCAT(title,dbid) 
					UNION ALL
					SELECT id FROM(SELECT * FROM base_newmsg where dbid =0) AS c';
		$tempCount = $this->model->query(['sql'=>$countSql]);
		$res['count'] = count($tempCount);
		$res['page'] = input('param.page' , 1);
		$res['res'] = $msgList;
		return getRes($res, $code);
	}
	
    /**
     * 用户订阅新消息列表
     * @access public 
     * @return array
     */
	public function rssMsgList(){
		$code = 200;
		$res = [];
		$limit = get_limit();
		$tokenUser = config('tokenUser');
		$wheres[] = 'uid = '.$tokenUser['uid'];
		$wheres[] = 'send_type != 3';
		$sql = 'SELECT id,title,fulltitle,dbid,infoid,`status`,type,addtime,field FROM(SELECT * FROM base_newmsg where dbid !=0 && '.implode(' && ' , $wheres).' ORDER BY addtime DESC ) AS t GROUP BY  CONCAT(title,dbid) 
				ORDER BY  status asc,addtime DESC limit ' . $limit;
	
		$msgList = $this->model->query(['sql'=>$sql]);
		if(empty($msgList)){
			$code = 404;
			return getRes($res, $code);
		}
		foreach($msgList as $key=>$val){
			$msgList[$key]['head_title'] = '';
			$msgList[$key]['type_title'] = '';
			if($val['dbid'] == 2){
				if($val['field'] == 'shoulihao'){
					$msgList[$key]['title'] = $val['fulltitle'];
				}
				if($val['type'] == 1){
					$msgList[$key]['type_title'] = lang('zhuce shoulihao change');
				}else if($val['type'] == 2){
					$msgList[$key]['type_title'] = lang('zhuce new register');
				}else if($val['type'] == 3){
					$msgList[$key]['type_title'] = lang('zhuce shoulihao change');
				}
				$msgList[$key]['head_title'] = lang('zhuce rss');
			}
			unset($msgList[$key]['fulltitle'],$msgList[$key]['field']);
		}
		
		//count
		$countSql = 'SELECT id FROM(SELECT * FROM base_newmsg where dbid !=0 && '.implode(' && ' , $wheres).' ORDER BY addtime DESC ) AS t GROUP BY  CONCAT(title,dbid)';
		$tempCount = $this->model->query(['sql'=>$countSql]);
		$res['count'] = count($tempCount);
		$res['page'] = input('param.page' , 1);
		$res['res'] = $msgList;
		return getRes($res, $code);
	}
	
    /**
     * 注册订阅具体消息列表
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function zhuce($param){
		$code = 200;
		$res = [];
		if(empty($param['id'])){
			$code = 401;
			return getRes($res, $code);
		}
		$tokenUser = config('tokenUser');
		$where['uid'] = $tokenUser['uid'];
		$where['id'] = $param['id'];
		$map['table'] = 'base_newmsg';
		$map['field'] = 'dbid,title';
		$map['where'] = $where;
		$newmsgInfo = $this->model->getOne($map);
		if(empty($newmsgInfo)){
			$code = 404;
			return getRes($res, $code);	
		}
		
		//按名称或企业订阅时
		$whereList['uid'] = $tokenUser['uid'];
		$whereList['title'] = $newmsgInfo['title'];
		$whereList['dbid'] = $newmsgInfo['dbid'];
		$whereList['send_type'] = ['<>' , 3];
		
		$mapList['table'] = 'base_newmsg';
		$mapList['field'] = 'id,fulltitle as title,type,infoid,status';
		$mapList['where'] = $whereList;
		$mapList['order'] = 'status desc,addtime desc';
		$res = $this->model->getList($mapList);
		if(empty($res)){
			$code = 404;
			return getRes($res, $code);	
		}
		$change = 0;
		$new = 0;
		$tempCount = 0;
		foreach($res['res'] as $key=>$val){
			$res['res'][$key]['type_title'] = '';
			if($val['type'] == 1){
				$res['res'][$key]['type_title'] = lang('zhuce shoulihao change');
				if($val['status'] == 0){
					$change ++ ;
				}
			}else if($val['type'] == 2){
				$res['res'][$key]['type_title'] = lang('zhuce new register');
				if($val['status'] == 0){
					$new ++;
				}
			}else if($val['type'] == 3){
				$res['res'][$key]['type_title'] = lang('zhuce shoulihao change');
				if($val['status'] == 0){
					$new ++;
					$change ++ ;
					$tempCount ++;
				}
			}
			$tempCount ++;
		}
		//已读未读    当已读条数/未读条数之和小于等于当页总条数判定为完成
		$res['change_count'] = 0;
		$res['new_count'] = 0;
		if($change + $new <=$tempCount){
			$res['change_count'] = $change;
			$res['new_count'] = $new;
		}else if($change <= $tempCount){
			$whereListweidu = $whereList;
			$whereListweidu['status'] = 0;
			$whereListweidu['type'] = ['IN' , [2,3]];
			$mapListweidu['table'] = 'base_newmsg';
			$mapListweidu['where'] = $whereListweidu;
			$res['change_count'] = $change;
			$res['new_count'] = $this->model->count($mapListweidu);
		}else if($new <= $tempCount){
			$whereListweidu = $whereList;
			$whereListweidu['status'] = 0;
			$whereListweidu['type'] = ['IN' , [1,3]];
			$mapListweidu['table'] = 'base_newmsg';
			$mapListweidu['where'] = $whereListweidu;
			$res['change_count'] = $this->model->count($mapListweidu);
			$res['new_count'] = $new;
		}else{
			$whereListweidu = $whereList;
			$whereListweidu['status'] = 0;
			$whereListweidu['type'] = ['IN' , [1,3]];
			$mapListweidu['table'] = 'base_newmsg';
			$mapListweidu['where'] = $whereListweidu;
			$res['change_count'] = $this->model->count($mapListweidu);
			$whereListweidu['type'] = ['IN' , [2,3]];
			$res['new_count'] = $this->model->count($mapListweidu);
		}
		
		return getRes($res, $code);
	}
	
    /**
     * 注册订阅受理号变化
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function zhuceshouli($param){
		$code = 200;
		$res = [];
		if(empty($param['id'])){
			$code = 401;
			return getRes($res, $code);
		}
		$tokenUser = config('tokenUser');
		$where['uid'] = $tokenUser['uid'];
		$where['id'] = $param['id'];
		$map['table'] = 'base_newmsg';
		$map['field'] = 'dbid,title,fulltitle,field,addtime';
		$map['where'] = $where;
		$newmsgInfo = $this->model->getOne($map);
		if(empty($newmsgInfo)){
			$code = 404;
			return getRes($res, $code);	
		}
		if($newmsgInfo['field'] != 'shoulihao'){
			$temptitle = explode(' ' , $newmsgInfo['fulltitle']);
			$newmsgInfo['title'] = trim($temptitle[0]);
		}
		$mapZhuce['table'] = 'zhuce';
		$mapZhuce['where'] = db_where('shoulihao' , '=' , $newmsgInfo['title']);
		$mapZhuce['field'] = 'id,shoulihao,name,qiyemingcheng,chenbanriqi,zhuceolddata';
		$res = $this->model->getOne($mapZhuce);
		if(empty($res)){
			$code = 404;
			return getRes($res, $code);	
		}
		$tempHistory = multi_array_sort($res['zhuceolddata'] , 'date');
		unset($res['zhuceolddata']);
		if(count($tempHistory) >= 2){
			$res['history'][0] = ['status'=>$tempHistory[1]['status'] , 'jielun'=>$tempHistory[1]['jielun'] , 'date'=>$tempHistory[1]['date'] ];
			$res['history'][1] = ['status'=>$tempHistory[0]['status'] , 'jielun'=>$tempHistory[0]['jielun'] , 'date'=>$tempHistory[0]['date'] ];
		}else{
			$code = 404;
			return getRes([], $code);	
		}
		$res['addtime'] = $newmsgInfo['addtime'];
		return getRes($res, $code);
	}

    /**
     * 取消订阅
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function delrsswhere($param) {
		$code = 200;
		$res = [];
		if(empty($param['id'])){
			$code = 404;
			return getRes($res, $code);
		}
		
		$tokenUser = config('tokenUser');
		$where['uid'] = $tokenUser['uid'];
		$where['id'] =  $param['id'];
		$map['table'] = 'base_rsswhere';
		$map['field'] = 'keywords,dbid';
		$map['where'] = $where;
		$rsswhere = $this->model->getOne($map);
		if(empty($rsswhere)){
			$code = 404;
			return getRes($res, $code);	
		}
		//删除newmsg消息表
		$msgDelWhere['uid'] = $tokenUser['uid'];
		$msgDelWhere['dbid'] =  $rsswhere['dbid'];
		$msgDelWhere['title'] =  $rsswhere['keywords'];
		$msgDelMap['table'] = 'base_newmsg';
		$msgDelMap['where'] = $msgDelWhere;
		$this->model->delete($msgDelMap);
		
		//删除rsswhere订阅条件表
		$delRsswhere['uid'] = $tokenUser['uid'];
		$delRsswhere['dbid'] = $tokenUser['uid'];
		$mapRsswhere['table'] = 'base_rsswhere';
		$mapRsswhere['where'] = $where;
		$this->model->delete($mapRsswhere);
		
		return getRes($res, $code);	
	}
}