<?php
namespace app\common\service;
use think\DB;

class OpenApiAuth{


	/**
	 * [_initialize 初始化函数]
	 * @return [type] [处理公共部分]
	 */
    protected function _initialize() {

    }

   	/**
   	 * [getUserInfo 获取对应appkey用户的信息]
   	 * @param  int $appkey [appkey]
   	 * @param  string $field  [要获取的字段信息]
   	 * @return [type]         [description]
   	 */
    public function getUserInfo($appkey = '',$field = 'id'){
		$map['appkey'] = $appkey;
    	$map['status'] = 1;
		$getUserInfo = Db::connect('newdbBase')->table('api_auth_user')->field($field)->where($map)->find();
		return $getUserInfo;
    }

    /**
     * [getUserAuth 获取用户的权限]
     * @param  int  $appkey [appkey]
     * @param  integer $type   [0:sql返回数组，1:tree类型; 3:一维数组类型['jinkou.index']]
     * @return [type]          [description]
     */
    public function getUserAuth($appkey = '',$type = 0){
    	$return = [];
    	$userAuths = $this->getUserInfo($appkey, 'auth');
    	$map['id'] = ['IN',$userAuths['auth']];
    	$map['status'] = 1;
		$getUserAuth = Db::connect('newdbBase')->table('api_auth_node')->field('id,pid,name')->where($map)->select();
		if ($type === 1) {
			$return = $this->authToTree($getUserAuth);
		}elseif($type === 2) {
        	$return = $this->authToStr($getUserAuth);
		}else{
			$return = $getUserAuth;
		}
		return $return;
    }

    /**
     * [authToTree 权限转换为树形结构]
     * @param  array   $param [description]
     * @param  integer $pid   [description]
     * @return [type]         [description]
     */
    protected function authToTree($param = [], $pid = 0){
    	$return = [];
        foreach ($param as $key => $value){
            if ($value['pid'] == $pid){
                unset($param[$key]);
                $child = $this->authToTree($param, $value['id']);
                if ($child) $value['child'] = $child;
                $return[] = $value;
            }
        }
    	return $return;
    }

    /**
     * [authToStr 权限转换为一维数组]
     * @param  array  $param [description]
     * @return [type]        [description]
     */
    protected function authToStr($param = []){
    	$return = [];
    	$param = $this->authToTree($param);
    	foreach ($param as $key => $value) {
    		$auth = $value['name'];
    		if (isset($value['child'])) {
    			foreach ($value['child'] as $k => $v) {
    				$return[] = $auth.'.'.$v['name'];
		    		if (isset($v['child'])) {
		    			foreach ($v['child'] as $kk => $vv) {
		    				$return[] = $auth.'.'.$v['name'].'.'.$vv['name'];
		    			}
		    		}
    			}
    		}
    	}
    	return $return;
    }

}