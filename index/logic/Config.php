<?php
namespace app\common\logic;
use think\Db;

/**
 * [页面配置信息加载]
 */
class Config{

    public function __construct(){
        $this->model = model('Config');
    }

    /**
     * 获取搜索配置信息
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
    public function getSearch($param){
		$code = 200;
        $res = [];
        if(!empty($param['dbname'])){
            $map['where'] = ['z.db_control' => $param['dbname'],'z.status' => 1];
            $map['table'] = 'base_search';
            $map['alias'] = 'a';
            $map['field'] = 'a.id,a.normal,a.high,a.filter,z.db_control as dbname';
            $map['join'] = [[['base_dblist'=>'z'],'a.dbid=z.id','left']];
            $search = $this->model->getOne($map);
			if(!empty($search)){
				$dbname = $search['dbname'];
				$normal = unserialize($search['normal']);
				$high = unserialize($search['high']);
				$filter = unserialize($search['filter']);
				/* $aaaa = $high[18];
				// print_r($high);
				unserialize($aaaa['val']);
				// print_r(unserialize($aaaa['val']));
				$cccc = unserialize($aaaa['val']) ; 
				foreach($cccc as $k=>$bbbb){
					$cccc[$k] = $bbbb;
					$cccc[$k]['label'] = $bbbb['name'];
					unset($cccc[$k]['name']);
				}
				$high[18]['value'] = $cccc;
				unset($high[18]['val']);
				// print_r($high);
				echo serialize($high);
				exit;  */
				if($high) array_walk($high,array($this, 'searchWalk'),$dbname);
				if($normal) array_walk($normal,array($this, 'searchWalk'),$dbname);
				$search['high'] = $high ? multi_array_sort($high , 'sort') : [];
				$search['normal'] = $normal ? multi_array_sort($normal , 'sort'): [];
				$search['filter'] = $filter ? multi_array_sort($filter , 'sort'): []; 
				unset($search['id']);
				unset($search['dbname']);
				$res = $search;
			}
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }

    /**
     * view 前端基本参数配置
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
    public function getView($param){
		$code = 200;
        $res = [];
        if(!empty($param['dbname'])){
            $map['where'] = ['db_control' => $param['dbname']];
            $map['table'] = 'base_dblist';
			$map['alias'] = 'a';
            $map['field'] = 'a.*,c.label';
            $map['join'] = [[['base_category'=>'c'],'a.catid=c.id','left']];
            $dblist = $this->model->getOne($map);
			if(!empty($dblist)){
				$dbname = $dblist['db_control'];
				$list_conf = unserialize($dblist['list_conf']);
				$details_conf = unserialize($dblist['details_conf']);
				$expansion_conf = unserialize($dblist['expansion_conf']);
				$helpconf = unserialize($dblist['helpconf']);
				$baseconf['dbname'] = $dblist['dbname'];
				$baseconf['title'] = $dblist['title'];
				$baseconf['view'] = $dblist['view'];
				$baseconf['remark'] = $dblist['remark'];
				$baseconf['db_control'] = $dblist['db_control'];
				$baseconf['catid'] = $dblist['catid'];
				$baseconf['catname'] = $dblist['label'];
				$baseconf['max_export'] = $dblist['max_export'];

				$tokenUser = config('tokenUser');
				$norules = [];
				$time = time();
				//权限返回
				$rules = $dblist['rules'] ?? ''; //默认基础权限
				$mapUserRank['table'] = 'sys_user_grade';
				$mapUserRank['field'] = 'dbrules,rules';
				$mapUserRank['where'] = ['id' => $tokenUser['grade_id'] ?? 0];
				$userRank = model('NewDbBase')->getOne($mapUserRank);
				$mapUser['table'] = 'sys_user';
				$mapUser['field'] = 'dbrules,rules,alonerule,starttime,endtime';
				$mapUser['where'] = ['uid' => $tokenUser['uid'] ?? 0];
				$user = model('NewDbBase')->getOne($mapUser);
				//判断会员过期，用户权限改为空
				$user['starttime'] = empty($user['starttime']) ? 0 :strtotime($user['starttime']);
				$user['endtime'] = empty($user['endtime']) ? 0 :strtotime($user['endtime']);
				if($time >= $user['starttime'] && $time <= $user['endtime']){
				}else{
					$user['dbrules'] = '';
					$user['rules'] = '';
				}
				
				$gradeDbrules = explode(',' , $userRank['dbrules'] ?? '');
				$userDbrules = explode(',' , $user['dbrules'] ?? '');
				$gradeRules = explode(',' , $userRank['rules'] ?? '');
				$userRules = explode(',' , $user['rules'] ?? '');
				if($user['alonerule'] == 1){
					foreach($userDbrules as $user_dbrule){
						if($user_dbrule < 0){
							$gradeDbrules = array_merge(array_diff($gradeDbrules, array(abs($user_dbrule))));
						}else{
							array_push($gradeDbrules , $user_dbrule);
						}
					}
					foreach($userRules as $user_rule){
						if($user_rule < 0){
							$gradeRules = array_merge(array_diff($gradeRules, array(abs($user_rule))));
						}else{
							array_push($gradeRules , $user_rule);
						}
					}
				}
				$gradeDbrules = array_unique($gradeDbrules);
				$gradeRules = array_unique($gradeRules);
				//检测数据库
				if(!empty($gradeDbrules)){
					if(in_array($dblist['id'] , $gradeDbrules)){
						$rules .= ','.implode(',' , $gradeRules);
					}
				}
				
				//列表没有的权限
				$mapAuth['table'] = 'sys_user_auth_rule';
				$mapAuth['field'] = 'type,name,action,field';
				$wherAuth['dbid'] = $dblist['id'];
				$wherAuth['action'] = 'index';
				$wherAuth['id'] = ['NOT IN' , $rules];
				$mapAuth['where'] = $wherAuth;
				$norules['list'] = model('NewDbBase')->select($mapAuth);
				
				//详情没有的权限
				$mapAuth22['table'] = 'sys_user_auth_rule';
				$mapAuth22['field'] = 'type,name,action,field';
				$wherAuth22['dbid'] = $dblist['id'];
				$wherAuth22['action'] = 'read';
				$wherAuth22['id'] = ['NOT IN' , $rules];
				$mapAuth22['where'] = $wherAuth22;
				$norules['detail'] = model('NewDbBase')->select($mapAuth22);
				
				//通用功能没有的权限
				$mapAuth33['table'] = 'sys_user_auth_rule';
				$mapAuth33['field'] = 'type,name,action,field';
				$wherAuth33['type'] = ['eq' , 1];
				$wherAuth33['id'] = ['NOT IN' , $rules];
				$mapAuth33['where'] = $wherAuth33;
				$norules['common'] = model('NewDbBase')->select($mapAuth33);
				
				//独有功能没有的权限
				$mapAuth44['table'] = 'sys_user_auth_rule';
				$mapAuth44['field'] = 'type,name,action,field';
				$wherAuth44['type'] = ['eq' , 3];
				$wherAuth44['dbid'] = ['eq' , $dblist['id']];
				$wherAuth44['id'] = ['NOT IN' , $rules];
				$mapAuth44['where'] = $wherAuth44;
				$norules['exclusive'] = model('NewDbBase')->select($mapAuth44);
				
				$view['list_conf'] = $list_conf ? multi_array_sort($list_conf , 'sort') : [];
				$view['details_conf'] = $details_conf ? multi_array_sort($details_conf , 'sort') : [];
				$view['expansion_conf'] = $expansion_conf ? multi_array_sort($expansion_conf , 'sort') : [];
				$view['helpconf'] = $helpconf ? multi_array_sort($helpconf , 'sort') : [];
				$view['baseconf'] = $baseconf;
				$view['norules'] = $norules;
				$res = $view;
			}
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }

    /**
     * 处理每项搜索值
     * @access private 
     * @param array $value 该项值
     * @param string $key 该项下标
     * @return array
     */
	private function searchWalk(&$value,$key,$dbname){
		if($value['type'] == 'date' && !empty($value['limit'])){
			foreach($value['limit'] as $k=>$item){
				$day = get_day($item['count'],$item['unit']);
				$begindate = date('Y-m-d',strtotime('-'.$day.'day'));
				$map['where'] = db_where($value['name'],'time',[$begindate,date('Y-m-d')]);
				$dbs = config('ES.DBS');
				$map['table'] = in_array($dbname , $dbs) ? $dbname : 'yz_' . $dbname;
				$num = $this->model->count($map);
				$value['limit'][$k]['num'] = $num;
			}
		}else if(substr($value['name'] , 0 , 3) == 'atc'){
			$atc = model('YzAtc','logic')->getAtcList();
			$value['value'] = $atc;
		}else if($value['type'] == 'fullselect' && !empty($value['value'])){
			$value['value'] = arr2tree($value['value']);
		}
	}
	
	public function searchInsert(){
		// 添加数据
		require('/../../searchtemp.php');
		$map['data'] = ['dbname'=>'zhuce' , 'normal'=>serialize($search['normal']) , 'high'=>serialize($search['high'])];
		$map['table'] = 'base_search';
		$this->model->insert($map);
		exit;
	}

    /**
     * [getNav 获取导航配置]
     * @return [type] [description]
     */
    public function getNav(){
        $res = [];
        $navs = $this->getAllNav();
        if ($navs['res']) {
            $res = arrToTree($navs['res']);
            $code = 200;
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }

    public function getAllNav($map = []){
        $res = [];
        $map['table'] = 'base_nav';
        $map['field'] = isset($map['field'])?$map['field']:'id,pid,label,short_label,tooltip,title,href,internal';
        $map['where'] = ['status'=>'1'];
        $map['order'] = 'sort desc,id desc';
        $res = $this->model->getAll($map);
        return $res;
    }

    public function getSearchNav($map = []){
        $res = [];
        $map['table'] = 'base_category';
        $map['field'] = isset($map['field'])?$map['field']:'id,label';
        $map['where'] = ['status'=>'1'];
        $map['order'] = 'sort desc';
        $res1 = $this->model->getAll($map);
        $mapDblist['table'] = 'base_dblist';
        $mapDblist['field'] = 'id,db_control as db_control,dbname as title,catid as pid,db_control as href';
        $mapDblist['where'] = ['status'=>'1'];
        $mapDblist['order'] = 'sort desc';
        $res2 = $this->model->getAll($mapDblist);
        $res = array_merge_recursive($res1,$res2);
        return $res;
    }

    /**
     * [input 输入提示接口]
     * @param  array  $map [必须包含：条件、查找字段、表名]
     * @return [type]      [description]
     */
    public function input($map = []){
        $res = [];
        $code = 200;
        $map['limit'] = 10;
        $data = $this->model->getList($map);
        if (!$data) {
            $code = 404;
        }
        return $data;
    }

    /**
     * [breadCrumb 数据库列表详情面包屑返回接口]
     * @param  array  $map [description]
     * @return [type]      [description]
     */
    public function breadCrumb($map = []){
        $res = [];
        $code = 200;
        $href = $map['dbname'];
        $mapNav['table'] = 'base_nav';
        $mapNav['field'] = 'id,pid,title,href,breadfield';
        $navs = model('Config')->getAll($mapNav);
        if ($navs['res']) $navs = $navs['res'];
        $res['breadcrumb'][] = ['title'=>'首页','href'=>''];
        $tmp = [];
        foreach ($navs as $k => $v) {
            if ($v['href'] == $href) {
                $tmp['two'] = $v;
            }
        }
        foreach ($navs as $k => $v) {
            if ($v['id'] == $tmp['two']['pid']) {
                $tmp['one'] = $v;
            }
        }
        $res['field'] = $tmp['two']['breadfield'];
        unset($tmp['one']['id'],$tmp['one']['pid'],$tmp['one']['breadfield']);
        unset($tmp['two']['id'],$tmp['two']['pid'],$tmp['two']['breadfield']);
        $res['breadcrumb'][] = $tmp['one'];
        $res['breadcrumb'][] = $tmp['two'];
        $res['zhname'] = $tmp['two']['title'];
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }

}