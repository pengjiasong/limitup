<?php
namespace app\index\controller;
use think\Controller;
use think\Request;
use think\Config;
use think\DB;

/**
 * 基本的公共类
 */
class Common extends Controller{

	protected $param; //获取全部参数

	/**
	 * [_initialize 初始化函数]
	 * @return [type] [处理公共部分]
	 */
    protected function _initialize() {
		// $this->checkRule();

    }

   	/**
   	 * [paramDeal 请求参数处理函数]
   	 * @return [void]
   	 */
    protected function paramDeal(){
		$get = Request::instance()->get();
		foreach($get as $key22=>$val){
			if( in_array($key22 , ['words' , 'fourth_condition' , 'filter_condition']) ){
				$this->wordshandle($key22 , $val);
			}else{
				if(strstr($val , '⊙')){
					$valtemp = explode('⊙' , $val);
					Request::instance()->get([$key22 => '']);
					Request::instance()->get([$key22.count($valtemp) => addslashes(array_pop($valtemp))]);
				}else if(!empty($val)){
					Request::instance()->get([$key22 => addslashes($val)]);
				}
			}
		}
		$this->param = Request::instance()->param();
    }
	
	protected function wordshandle($key22 = '' , $words = ''){
		$returnstr = '';
		if(preg_match_all("/(\s*_OR |\s*_AND |\s*_NOT )?(((?!_AND | _OR | _AND | _NOT ).)+)/sim", $words , $matches)){
			foreach($matches[2] as $key=>$val){
				$item = explode('=',$val);
				if(count($item) == 2){
					if(strstr($item[1] , '⊙')){
						$valtemp = explode('⊙' , $item[1]);
						$returnstr .= $matches[1][$key].$item[0].count($valtemp).'='.addslashes(array_pop($valtemp));
					}else if(!empty($item[1])){
						$returnstr .= $matches[1][$key].$item[0].'='.addslashes($item[1]);
					}else{
						$returnstr .= $matches[1][$key].$item[0].'='.addslashes($item[1]);
					}
				}else{
					$returnstr .= $matches[1][$key].$item[0].'='.addslashes($item[1]);
				}
			}
		}
		//dump($returnstr);exit;
		Request::instance()->get([$key22 => $returnstr]);
	}
	
	// 验证access_token和获取token_user
    protected function getTokenUser($clientType){
		$code = 200;
		$res = [];
		if(!empty($this->param['accesstoken'])){
			$accesstoken = $this->param['accesstoken'];
			$tokenUser = $this->getAccessTokenInfo($accesstoken, $clientType);
			if($tokenUser){
				if(time() - $tokenUser['firsttime'] > config('timeout')){
				    $tablename = $clientType == 'APP'? 'sys_app_access_token' : 'sys_access_token';
				    Db::connect('newdbBase')->table($tablename)->where("access_token='".$accesstoken."'")->delete();
					$code = 11015;
				}else{
					$tokenUser['private'] = [];//项目私有部分
					$this->tokenUser = $tokenUser;  //私有调用
					Config::set('tokenUser',$tokenUser);
				}
			}else{
				$code = 11015;
			}
			if($code != 200){
				getRes($res, $code , true);
			}
		}
	}
	
	// 验证检查用户权限
	private function checkRule(){
		$code = 200;
		$res = [];
		$request= Request::instance();
		$controller = strtolower($request->controller());
		$action = strtolower($request->action());
		$time = time();

		if($controller == 'all'){ // 类似于单表操作的检测
			$pathParm = explode('/' , strtolower($request->pathinfo()));
			$controller = $pathParm[0] ?? $controller;
		}
		$dbDetails = Db::table('base_dblist')->field('id,db_control,dbname,rules,bianma,zhongbiaobianma,qiyebianma,expansion_conf')->where("db_control='" . $controller . "'")->find();
		Config::set('dbConf',$dbDetails);//数据库基本信息
		// if(!empty($this->tokenUser['grade_id'])){
			$grade_id = $this->tokenUser['grade_id'] ?? 0;

			$notcheck = []; // 设置不用检测的controller
			if(in_array($controller , $notcheck)) return true;
			$userRank = Db::connect('newdbBase')->table('sys_user_grade')->field('rules,dbrules')->where('id=' . $grade_id)->find();
			$user = Db::connect('newdbBase')->table('sys_user')->field('rules,dbrules,alonerule,starttime,endtime')->where('uid=' . ($this->tokenUser['uid'] ?? 0))->find();
			if(!empty($dbDetails) ){
				$rules = $dbDetails['rules'] ?? ''; //默认基础权限
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
					if(in_array($dbDetails['id'] , $gradeDbrules)){
						$rules .= ','.implode(',' , $gradeRules);
					}
				}
				
				//检测权限
				$mapping = [
					'aggs' => 'visualization',
					'aggsview' => 'visualization',
					'znfxaggs' => 'visualization',
					'spphxsl' => 'visualization',
					'qyphxsl' => 'visualization',
					'spphxse' => 'visualization',
					'qyphxse' => 'visualization',
					'ndxs' => 'visualization',
					'jplb' => 'visualization',
					'getanalysis' => 'visualization',
					'getspxx' => 'visualization',
					'getqyxx' => 'visualization',
					'getndxx' => 'visualization',
					'getatc' => 'visualization',
					'ypfxtj' => 'visualization',
					'ypfxtime' => 'visualization',
					'ypfxqiye' => 'visualization',
					'ypfxfirst' => 'visualization',
					'ypfxarea' => 'visualization',
					'ypfxfeiyong' => 'visualization',
					'ypfxfilter' => 'visualization',
					'ypfxqiyefx' => 'visualization',
					'ypfxqiyepz' => 'visualization',
					'ypfxqiyetime' => 'visualization',
					'ypfxqiyehot' => 'visualization',
					'qyfxfilter' => 'visualization',
					'ypfxaggs' => 'visualization',
					'viewxszl' => 'visualization',
					'viewggxszl' => 'visualization',
					'viewdatexszl' => 'visualization',
					'viewjckxszl' => 'visualization',
					'qyaggs' => 'visualization',
					'yearqy' => 'visualization',
					'viewqyxsze' => 'visualization',
					'viewdatejplb' => 'visualization',
					'getqydlfx' => 'visualization',
					'getqyxstj' => 'visualization',
					'getqyndfx' => 'visualization',
					'getdlfx' => 'visualization',
					'getxstj' => 'visualization',
					'getndfx' => 'visualization',
				];
				$action = $mapping[$action] ?? $action;
				$actionRule = Db::connect('newdbBase')->table('sys_user_auth_rule')->field('id')->where("action='" . $action . "'")->find();
				if(!empty($actionRule)){
					if(!empty($rules)){
						$actionRules = explode(',' , $rules);
						if($action == 'index' || $action == 'read'){
							if($action == 'index'){
								if(isset($this->param['words'])){
									if(!in_array(2 , $actionRules)) $code = 11016;
								}else if(isset($this->param['filter_condition'])){
									if(!in_array(3 , $actionRules)) $code = 11016;
								}
								if($code != 11016){
									$tmpPage = input('param.page');
									$tmpPageSize = input('param.pageSize');
									$total = $tmpPage * $tmpPageSize ; 
									if(!in_array(13 , $actionRules)){
										if($total > 200){
											$code = 11016;
										}
									}else{
										if($total > 1500){
											$code = 11028;
										}
									}
								}
							}
							if($action == 'read'){
								if(!in_array(7 , $actionRules)) $code = 11016;
							}
							if($code != 11016){
								$noFieldRules = [];
								$actionRuleList = Db::connect('newdbBase')->table('sys_user_auth_rule')->field('id,field')->where("action='" . $action . "' && type=4 && dbid=" . $dbDetails['id'])->select();
								if(!empty($actionRuleList)){
									foreach($actionRuleList as $ruleInfo){
										if(!in_array($ruleInfo['id'] , $actionRules)){
											array_push($noFieldRules , $ruleInfo['field']); 
										}
									}
								}
								if(!empty($noFieldRules)){
									Config::set('noFieldRules',$noFieldRules);
								}
							}
						}else{
							if(!in_array($actionRule['id'] , $actionRules)){
								$code = 11016;
							} 
						}
					}else if($action == 'index'){
						//列表页不计入权限	
					}else{
						$code = 11016;
					}
				}
			}
		// }else{
			// $code = 11016;
		// }
		if($code != 200){
			getRes($res, $code , true); //强制输出
		}
	}
	
	//获取access_token详情  在10分钟以内的
	private function getAccessTokenInfo($access_token, $clientType = 'PC'){
	    $tablename = $clientType == 'APP'? 'sys_app_access_token' : 'sys_access_token';
	    $token_info = Db::connect('newdbBase')->table($tablename)->where("access_token='".$access_token."'")->find();
		return $token_info;
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
    
}