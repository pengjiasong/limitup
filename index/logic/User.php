<?php
namespace app\common\logic;

/**
 * [注册类接口]
 */
class User{
    private $model;
    private $salt = 'newdb';
    
    public function __construct(){
        $this->model = model('User');
    }

    /**
     * 登录drugeyes方法
     * @access public 
     * @param array $param = ['name','pwd'] 参数数组 
     * @return array
     */
	public function loginDrugeyes($param) {
		$res = [];
		if(empty($param['name'])){
			$code = 11017;
			return getRes($res, $code);
		}
		if(empty($param['pwd'])){
			$code = 11027;
			return getRes($res, $code);
		}
		$name = $param['name'] ?: '';
		$pwd = $param['pwd'] ?: '';
		$checkusername = $this->checkUsername($name);
		// $_where = array();
		if ($checkusername == 2) {
			$where['email'] = ['eq',$name];
		} else if ($checkusername == 3) {
			$where['mobile'] = ['eq',$name];
		} else {
			$where['username'] = ['eq',$name];
		}
		$_pwd = md5pwd($pwd);
		$where['password'] = $_pwd;
		$map['where'] = $where;
		$res = $this->getDrugeyesMember($map);
		if(!$res){
			return getRes($res, 11022);
		}else{
			$mapintro['table'] = 'drugeyes_member_intro';
			$mapintro['field'] = 'pic_url';
			$mapintro['connection'] = 'drugeyes';
			$mapintro['where'] = ['uid' => $res['uid']];
			$pic_serialize = $this->model->getOne($mapintro);
			$res['picture'] = '';
			if(!empty($pic_serialize)){
				$pic = json_decode($pic_serialize['pic_url']);
				
				if(!empty($pic)){
					$res['picture'] = 'https://www.drugeyes.com/' . $pic->serverpath_120;
				}
			}
			if(empty($res['picture']) && !file_exists($res['picture'])){
				$res['picture'] = 'https://www.drugeyes.com/uploads/userface/no.png';
			}
		}
		return $res;
	}
	
    /**
     * 登录drugeyes方法
     * @access public 
     * @param array $param = ['mobile','vcode'] 参数数组 
     * @return array
     */
	public function mobileLoginDrugeyes($param) {
		$res = [];
		if(empty($param['mobile']) || empty($param['vcode'])){
			$code = 11001;
			return getRes($res, $code);
		}
		$mobile = $param['mobile'] ? : '';
		$vcode = $param['vcode'] ? : '';
		
		//激活码出错
		$whereCode['rand_mobile'] = $mobile;
		$whereCode['rand_type'] = 4;
		$whereCode['rand_num'] = $vcode;
		$mapCode['table'] = 'drugeyes_mobile_code';
		$mapCode['where'] = $whereCode;
		$mapCode['data'] = ['rand_status'=>1];
		$mapCode['connection'] = 'drugeyes';
		$mobile_code_res = $this->model->updateDate($mapCode);
		if(!$mobile_code_res){
			$code = 11014;
			return getRes($res, $code);
		}
		
		$where['mobile'] = ['eq',$mobile];
		$map['where'] = $where;
		$res = $this->getDrugeyesMember($map);
		if(!$res){
			return getRes($res, 11022);
		}else{
			$mapintro['table'] = 'drugeyes_member_intro';
			$mapintro['field'] = 'pic_url';
			$mapintro['connection'] = 'drugeyes';
			$mapintro['where'] = ['uid' => $res['uid']];
			$pic_serialize = $this->model->getOne($mapintro);
			$res['picture'] = '';
			if(!empty($pic_serialize)){
				$pic = json_decode($pic_serialize['pic_url']);

				if(!empty($pic)){
					$res['picture'] = 'https://www.drugeyes.com/' . $pic->serverpath_120;
				}
			}
			if(!isset($res['picture']) && empty($res['picture']) && !file_exists($res['picture'])){
				$res['picture'] = 'https://www.drugeyes.com/uploads/userface/no.png';
			}
		}
		return $res;
	}

    /**
     * 用户注册
     * @access public 
     * @param array $param = ['name','pwd'] 参数数组 
     * @return string
     */
	public function register($param) {		
		//验证
		$res = [];
		$code = 200;
		if(empty($param['name'])){
			$code = 11003;
			return getRes($res, $code);
		}
		if(config('clientType') == 'APP'){
			if(!isMobile($param['name'])){
				$code = 11008;
				return getRes($res, $code);
			}
			//判断验证码
			$whereCode['rand_mobile'] = $param['name'];
			$whereCode['rand_type'] = 4;
			$whereCode['rand_num'] = $param['vcode'];
			$mapCode['table'] = 'drugeyes_mobile_code';
			$mapCode['where'] = $whereCode;
			$mapCode['data'] = ['rand_status'=>1];
			$mapCode['connection'] = 'drugeyes';
			$mobile_code_res = $this->model->updateDate($mapCode);
			if(!$mobile_code_res){
				$code = 11014;
				return getRes($res, $code);
			}
		}else if(!$this->is_username($param['name'])){
			$code = 11003;
			return getRes($res, $code);
		}
		if(empty($param['pwd'])){
			$code = 11006;
			return getRes($res, $code);
		}
		$name = $param['name'] ?: '';
		$pwd = $param['pwd'] ?: '';
		$map['where'] = ['username'=>$name];
		$drugeyesMember = $this->getDrugeyesMember($map);
		if(!empty($drugeyesMember['username'])){
			$code = 11004;
			return getRes($res, $code);	
		}
		
		//认证有效性
		if(empty($param['timeStamp']) || empty($param['randStr']) || empty($param['typeature'])){
			$code = 11005;
			return getRes($res, $code);
		}
		$typeature = $this->arithmetic($param['timeStamp'],$param['randStr']);	
		if($param['typeature'] != $typeature){
            $code = 11005;
			return getRes($res, $code);
        }

		//注册
		$drugeyesmemberid = $this->registerdrugeyes($name , $pwd);
		if(!$drugeyesmemberid){
			return getRes($res, 11007);
		}
		return $drugeyesmemberid;
	}
	
	//注册drugeyes
    private function registerdrugeyes($name, $pwd){
		$data['username'] = $name;
        $data['password'] = md5pwd($pwd);
		$time = time();
		$data['regdate'] = $time;	
		$data['lastlogintime'] = $time;	
		if(config('clientType') == 'APP'){
			$data['mobile'] = $name;
			$data['mobile_proving'] = 1;
		}

		$map['table'] = 'drugeyes_member';
		$map['connection'] = 'drugeyes';
		$map['data'] = $data;
		return $this->model->insert($map);	
	}	
	
	/**
	 * 获取drugeyes用户基本信息
     * @param array $map 参数数组 
     * @return array
	 */
	public function getDrugeyesMember($map = []) {
		$map['table'] = 'drugeyes_member';
		$map['field'] = 'uid,username,email,mobile';
		$map['connection'] = 'drugeyes';
		$res = $this->model->getOne($map);
		return $res;
	}
	
	/**
	 * 判断用户名
	 * 
	 * @param string $username 获取的变量名
	 * @return 1 用户名，2 邮箱，3 手机
	 * @return mixed
	 */
	public function checkUsername($username) {
		if(isEmail($username)){
			return 2;
		}else if(isMobile($username)){
			return 3;
		}else{
			return 1;
		}
	}
	 
	/**
	* 检查用户名是否符合规定 (六个字符以上，只能有中文，字母，数字，下划线的)
	*
	* @param STRING $username 要检查的用户名
	* @return 	TRUE or FALSE
	*/
	private function is_username($username) {
		if(isMobile($username))	return false;
		$strlen = strlen($username);
		if(!preg_match("/^[a-zA-Z0-9_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]+$/", $username)){
			return false;
		}else if($this->transgress_keyword($username)> 0){
			return false;
		}else if ( 20 < $strlen || $strlen < 6 ) {
			return false;
		}
		return true;
	}
	
	/**
	* 敏感词
	*/
	private function transgress_keyword ($content){
		$keyword = array ("drugeyes", "药物视界", "测试", ,"ceshi" , "admin", "root", ".");	//定义敏感词
		$msg = 0;
		foreach($keyword as $value) {
			if (substr_count($content, $value) > 0) {
				$msg ++;
			}
		}
		return $msg;//返回变量值，根据变量值判断是否存在敏感词
	}
	
    /**
     * 添加AccessToken
     * @access public 
     * @param array $user 用户信息 
     * @param array $param 参数数组 
     * @return string
     */
	public function insertAccessToken($user , $param) {
		$time = time();
		//$historydata   记录登陆的历史记录
		$historydata['uid'] = $user['uid'];
		$historydata['addtime'] = $time;
		$historydata['client'] = config('client');
		
		// $historydata['appname'] = I('appname'); db_android_client
		// $historydata['model'] = I('model'); //机型 OPPO R7 KitKat
		$mapHistory['table'] = 'sys_userlogin_history';
		$mapHistory['connection'] = 'newdbBase';
		$mapHistory['data'] = $historydata;

		$where['uid'] = $user['uid'];
		$map['table'] = 'sys_access_token';
		$map['field'] = 'access_token,firsttime';
		$map['where'] = $where;
		$map['connection'] = 'newdbBase';
		$access_token_res = $this->model->getOne($map);
		if(!empty($access_token_res)){
			if($time - $access_token_res['firsttime'] > config('timeout')){ //过期
				$mapDeleteToken['table'] = $map['table'];
				$mapDeleteToken['connection'] = $map['connection'];
				$mapDeleteToken['where'] = ['access_token'=>$access_token_res['access_token']];
				$this->model->delete($mapDeleteToken);
				return false;
			}else{
				$this->model->insert($mapHistory);
				return $access_token_res['access_token'];
			}
		}
		if(empty($param['timeStamp']) || empty($param['randStr']) || empty($param['typeature'])){
			return false;
		}
		$typeature = $this->arithmetic($param['timeStamp'],$param['randStr']);	
		if($param['typeature'] != $typeature){
            return false;
        }
		$access_token = $this->bulid_access_token($user , $typeature);
		$data = $user;
		$data['access_token'] = $access_token;
		$data['firsttime'] = time();
		$map['data'] = $data;
		$insertId = $this->model->insert($map);
		if($insertId){
			$this->model->insert($mapHistory);
			return $access_token;
		}else{
			return false;
		}
	}
	
	//生成添加access_token
	public function bulid_access_token($user , $typeature) {	
		$access_token = str_shuffle(md5(md5($user['uid'].time()).$typeature));
		return $access_token;
	}

    /**
	 * 签名生成
     * @param $timeStamp 时间戳
     * @param $randStr 随机字符串
     * @return string 返回签名
     */
    private function arithmetic($timeStamp,$randStr){
		if(time() - $timeStamp > config('timeout')){
			return '';
		}
        $arr['timeStamp'] = $timeStamp;
        $arr['randStr'] = $randStr;
        $arr['salt'] = $this->salt;
        // 按照首字母大小写顺序排序
        sort($arr,SORT_STRING);
        //拼接成字符串
        $str = implode($arr);
        //进行加密
        $typeature = sha1($str);
        $typeature = md5($typeature);
        //转换成大写
        $typeature = strtoupper($typeature);
        return $typeature;
    }

	/**
     * 手机绑定发送手机验证码 (绑定时)
     * @access public 
     * @param array $param 参数数组 
     * @return string
     */
	public function postpincode($param) {
		$res = [];	
		$code = 200;
		if(!config('tokenUser')){
			$code = 404;
			return getRes($res, $code);
		}
		if(empty($param['mobile'])){
			$code = 11008;
			return getRes($res, $code);
		}
		$mobile = $param['mobile'];

		if(!isMobile($mobile)){
			$code = 11008;
			return getRes($res, $code);
		}
		
		//手机号被使用
		$where['mobile'] = $mobile;
		$where['mobile_proving'] = 1;
		$map['table'] = 'drugeyes_member';
		$map['field'] = 'uid';
		$map['where'] = $where;
		$map['connection'] = 'drugeyes';
		$mobile_code_proving = $this->model->getOne($map);
		if(!empty($mobile_code_proving)){
			$code = 11009;
			return getRes($res, $code);
		}
		
		return $this->pinmobilecode($mobile);
	}	

	/**
     * 发送手机验证码   普通发送验证
     * @access public 
     * @param array $param 参数数组 
     * @return string
     */
	public function postmobilecode($param) {	
		$res = [];	
		$code = 200;		
		if(empty($param['mobile'])){
			$code = 11008;
			return getRes($res, $code);
		}
		$mobile = $param['mobile'];

		//认证有效性
		if(empty($param['timeStamp']) || empty($param['randStr']) || empty($param['typeature'])){
			$code = 11005;
			return getRes($res, $code);
		}
		$typeature = $this->arithmetic($param['timeStamp'],$param['randStr']);	
		if($param['typeature'] != $typeature){
            $code = 11005;
			return getRes($res, $code);
        }

		if(!isMobile($mobile)){
			$code = 11008;
			return getRes($res, $code);
		}
		//专业版判断
		if(isset($param['version']) && $param['version'] == 'professional'){
			// 判断用户是否注册过手机
			$where['mobile'] = $mobile;
			// $where['mobile_proving'] = 1;
			$map['table'] = 'drugeyes_member';
			$map['field'] = 'uid,mobile_proving';
			$map['where'] = $where;
			$map['connection'] = 'drugeyes';
			$member = $this->model->getOne($map);
			if(!empty($member)){
				if($member['mobile_proving'] != 1){
					$code = 11020;
					return getRes($res, $code);
				}else{
					$user =  model('User','logic')->login($member);
					if(!is_array($user)){
						return $user;
					}
				}
			}else{
				$code = 11019;
				return getRes($res, $code);
			}
		}

		return $this->pinmobilecode($mobile);
	}
	
	//发送手机验证码公共方法
	private function pinmobilecode($mobile){
		$res = [];
		$where['rand_mobile'] = $mobile;
		$where['rand_type'] = 4;
		$map['table'] = 'drugeyes_mobile_code';
		$map['field'] = 'rand_addtime';
		$map['where'] = $where;
		$map['order'] = 'rand_addtime DESC';
		$map['connection'] = 'drugeyes';
		$mobile_addtime = $this->model->getOne($map);
		if(!empty($mobile_addtime)){
			if(time()-$mobile_addtime['rand_addtime'] < 60){
				$code = 11010;
				return getRes($res, $code);
			}
		}

		$randnums = rand(100000,999999);
		$mobile_arr = array($mobile);
		// $_msg = lang('mobile phone verification code').$randnums;
		$_msg = "手机验证码：".$randnums."（30分钟内有效）";
		$str_succes = send($_msg,$mobile_arr);
		
		if($str_succes == "发送成功"){
			//数据入库
			$mobile_code_data['rand_num'] = $randnums;
			$mobile_code_data['rand_addtime'] = time();
			$mobile_code_data['rand_mobile'] = $mobile;
			$mobile_code_data['rand_type'] = 4;
			$mobile_code_data['rand_ip'] = '110.110.110.110'; //标识APP的 乱写的  
			
			$mapInsert['table'] = 'drugeyes_mobile_code';
			$mapInsert['data'] = $mobile_code_data;
			$mapInsert['connection'] = 'drugeyes';
			$add_res = $this->model->insert($mapInsert);
			if($add_res){
				$code = 200;
				return getRes(['vcode'=>$randnums], $code);
			}else{
				$code = 11013;
				return getRes($res, $code);
			}
		}else{
			$code = 11013;
			return getRes($res, $code);
		}
	}

	/**
     * 绑定mobile
     * @access public 
     * @param array $param 参数数组 
     * @return string
     */
	public function bindmobile($param) {
		$res = [];
		$code = 200;
		$tokenUser = config('tokenUser');
		if(!$tokenUser){
			$code = 11015;
			return getRes($res, $code);
		}
		if(empty($param['mobile'])){
			$code = 11008;
			return getRes($res, $code);
		}
		if(empty($param['vcode'])){
			$code = 11014;
			return getRes($res, $code);
		}
		$mobile = $param['mobile'];
		$vcode = $param['vcode'];
		if(!isMobile($mobile)){
			$code = 11008;
			return getRes($res, $code);
		}
		
		//手机号被使用
		$where['mobile'] = $mobile;
		$where['mobile_proving'] = 1;
		$map['table'] = 'drugeyes_member';
		$map['field'] = 'uid';
		$map['where'] = $where;
		$map['connection'] = 'drugeyes';
		$mobile_code_proving = $this->model->getOne($map);
		if(!empty($mobile_code_proving)){
			$code = 11009;
			return getRes($res, $code);
		}
		
		//激活码出错
		$whereCode['rand_mobile'] = $mobile;
		$whereCode['rand_type'] = 4;
		$whereCode['rand_num'] = $vcode;
		$mapCode['table'] = 'drugeyes_mobile_code';
		$mapCode['where'] = $whereCode;
		$mapCode['data'] = ['rand_status'=>1];
		$mapCode['connection'] = 'drugeyes';
		$mobile_code_res = $this->model->updateDate($mapCode);
		if(!$mobile_code_res){
			$code = 11014;
			return getRes($res, $code);
		}
		
		//修改drugeyes电话
		$whereMember['username'] = $tokenUser['username'];
		$mapMember['table'] = 'drugeyes_member';
		$mapMember['where'] = $whereMember;
		$mapMember['data'] = ['mobile'=>$mobile,'mobile_proving'=>1];
		$mapMember['connection'] = 'drugeyes';
		$resMember = $this->model->updateDate($mapMember);

		if($resMember){
			//修改项目电话
			$whereUser['username'] = $tokenUser['username'];
			$mapUser['table'] = 'sys_app_user';
			$mapUser['where'] = $whereUser;
			$mapUser['data'] = ['mobile'=>$mobile];
			$mapUser['connection'] = 'newdbBase';
			$resUser = $this->model->updateDate($mapUser);
			if($resUser){
				$code = 200;
				return getRes($res, $code);
			}else{
				$code = 404;
				return getRes($res, $code);
			}
		}else{
			$code = 404;
			return getRes($res, $code);
		}	
	}
	
	/**
     * 忘记密码根据用户手机号重置
     * @access public 
     * @param array $param 参数数组 
     * @return string
     */
	public function forgetpwd($param) {
		$res = [];	
		$code = 200;		
		if(empty($param['mobile'])){
			$code = 11008;
			return getRes($res, $code);
		}
		if(empty($param['newpwd'])){
			$code = 11006;
			return getRes($res, $code);
		}
		if(empty($param['vcode'])){
			$code = 11014;
			return getRes($res, $code);
		}
		$mobile = $param['mobile'];
		$vcode = $param['vcode'];
		$newpwd = $param['newpwd'];

		//认证有效性
		if(empty($param['timeStamp']) || empty($param['randStr']) || empty($param['typeature'])){
			$code = 11005;
			return getRes($res, $code);
		}
		$typeature = $this->arithmetic($param['timeStamp'],$param['randStr']);	
		if($param['typeature'] != $typeature){
            $code = 11005;
			return getRes($res, $code);
        }

		if(!isMobile($mobile)){
			$code = 11008;
			return getRes($res, $code);
		}

		$where['rand_mobile'] = $mobile;
		$where['rand_type'] = 4;
		$where['rand_num'] = $vcode;
		$map['table'] = 'drugeyes_mobile_code';
		$map['where'] = $where;
		$map['data'] = ['rand_status'=>1];
		$map['connection'] = 'drugeyes';
		$mobile_code_res = $this->model->updateDate($map);
		if(!$mobile_code_res){
			$code = 11014;
			return getRes($res, $code);
		}

		//修改drugeyes密码
		$whereMember['username'] = $mobile;
		$mapMember['table'] = 'drugeyes_member';
		$mapMember['where'] = $whereMember;
		$mapMember['data'] = ['password'=>md5pwd($newpwd)];
		$mapMember['connection'] = 'drugeyes';
		$resMember = $this->model->updateDate($mapMember);

		if($resMember){
			//修改项目密码
			$whereUser['username'] = $mobile;
			$mapUser['table'] = 'sys_user';
			$mapUser['where'] = $whereUser;
			$mapUser['data'] = ['password'=>md5pwd($newpwd)];
			$mapUser['connection'] = 'newdbBase';
			$resUser = $this->model->updateDate($mapUser);
			if($resUser){
				$code = 200;
				return getRes($res, $code);
			}else{
				$code = 404;
				return getRes($res, $code);
			}
		}else{
			$code = 404;
			return getRes($res, $code);
		}
	}
	
	/**
     * 退出登录清除token
     * @access public 
     * @param array $param 参数数组 
     * @return string
     */
	public function logout($param) {
		$res = [];	
		$code = 200;		
		//认证有效性
		// if(empty($param['timeStamp']) || empty($param['randStr']) || empty($param['typeature'])){
			// $code = 11005;
			// return getRes($res, $code);
		// }
		// $typeature = $this->arithmetic($param['timeStamp'],$param['randStr']);	
		// if($param['typeature'] != $typeature){
            // $code = 11005;
			// return getRes($res, $code);
        // }
		// if(empty($param['accesstoken'])){
			// $code = 11015;
			// return getRes($res, $code);
		// }
		$tablename = config('clientType') == 'APP'? 'sys_app_access_token' : 'sys_access_token';
		$map['connection'] = 'newdbBase';
		$map['table'] = $tablename;
		$map['where'] = "access_token='".$param['accesstoken']."'";
		$restemp = model('user')->delete($map);
		if(!$restemp){
			$code = 404;
			return getRes($res, $code);
		}
		return getRes($res, $code);
	}
	
	/*********************************会员部分结束********************************/
	
    /**
     * 收藏数据库列表
     * @access public
     * @param $param
     * @return array
     */
    public function scsjkList($param){
        $code = 200;
        $res = [];
        $uid = isset($param['uid']) ? $param['uid'] : 0;
        if (!$uid) {
            $code = 401;
            return getRes($res, $code);
        }
        $modelAll = model('YzFavdb');
        $modelAll->table = 'yz_fav_db';
        $maplc['member_uid'] = $uid;
        $map['where'] = $maplc;
        $map['join'] = [['newdb_zh.base_nav n','n.db_control = yz_fav_db.db_control']];
        $map['field'] = 'fav_id as favid,n.label,n.lastuptime,n.datacount,n.db_control,addtime';
        $res = $modelAll->getList($map);
        if(isset($res['res'])){
            foreach($res['res'] as $k => $v){
                $res['res'][$k]['lastuptime'] = isset($v['lastuptime']) ? date("Y-m-d H:i:s", $v['lastuptime']) : '';
                $res['res'][$k]['addtime'] = isset($v['addtime']) ? date("Y-m-d H:i:s", $v['addtime']) : '';
                $res['res'][$k]['url'] = HOST_URL.'/'.$v['db_control'].'.html';
            }
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
    /**
     * 收藏数据库
     * @access public
     * @param $param
     * @return array
     */
    public function scsjk($param){
        $code = 200;
        $res = [];
        $where['member_uid'] = isset($param['uid']) ? $param['uid'] : 0;
        $where['db_control'] = isset($param['dbdb_control']) ? $param['dbdb_control'] : '';
        if (!$where['member_uid'] || !$where['db_control']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['where'] = $where;
        $map['field'] = 'fav_id';
        $res = model('YzFavdb')->getDetail($map);
        if($res){
            $code = 202;
        }else{
            unset($map);
            $map['data'] = array('member_uid' => $param['uid'], 'db_control' => $param['dbdb_control'], 'addtime' => time());
            $re = model('YzFavdb')->insert($map);
            if (!$re) {
                $code = 404;
            }
            $res['fav_id'] = intval($re);
        }
        return getRes($res, $code);
    }
	
    /**
     * 取消收藏数据库/页面/企业
     * @access public
     * @param $param
     * @return array
     */
    public function qxsc($param){
        $code = 200;
        $res = [];
        $type = isset($param['type']) ? $param['type'] : '';
        $where['member_id'] = isset($param['uid']) ? $param['uid'] : 0;
        $where['fav_id'] = isset($param['favid']) ? $param['favid'] : 0;
        if (!$type || !$where['member_uid'] || !$where['fav_id']) {
            $code = 401;
            return getRes($res, $code);
        }
        if($type == 'sjk'){
            $res = model('YzFavdb')->where($where)->delete();
        }elseif($type == 'ym'){
            $res = model('YzFavpage')->where($where)->delete();
        }elseif($type == 'qy'){
            $res = model('YzFavcompany')->where($where)->delete();
        }
        if (!$res) {
            $code = 400;
        }
        return getRes($res=[], $code);
    }
    /**
     * 收藏页面列表
     * @access public
     * @param $param
     * @return array
     */
    public function scymList($param){
        $code = 200;
        $uid = isset($param['uid']) ? $param['uid'] : 0;
        if (!$uid) {
            $code = 401;
            return getRes($res, $code);
        }
        $modelAll = model('YzFavpage');
        $modelAll->table = 'yz_fav_page';
        $maplc['member_uid'] = $uid;
        $map['where'] = $maplc;
        $map['join'] = [['newdb_zh.base_nav n','n.db_control = yz_fav_page.db_control']];
        $map['field'] = 'fav_id as favid,n.label,yz_fav_page.title,url,addtime';
        $res = $modelAll->getList($map);
        if(isset($res['res'])){
            foreach($res['res'] as $k => $v){
                $res['res'][$k]['addtime'] = isset($v['addtime']) ? date("Y-m-d H:i:s", $v['addtime']) : '';
                $res['res'][$k]['url'] = HOST_URL.$v['url'];
            }
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
    /**
     * 收藏页面
     * @access public
     * @param $param
     * @return array
     */
    public function scym($param){
        $code = 200;
        $res = [];
        $param['uid'] = isset($param['uid']) ? $param['uid'] : 0;
        $param['title'] = isset($param['title']) ? $param['title'] : '';
        $param['dbdb_control'] = isset($param['dbdb_control']) ? $param['dbdb_control'] : '';
        if (!$param['member_uid'] || !$param['title'] || !$param['dbdb_control']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['data'] = array('member_uid' => $param['uid'], 'title' => $param['title'], 'db_control' => $param['dbdb_control'], 'url' => $param['url'],'addtime' => time());
        $re = model('YzFavpage')->insert($map);
        if (!$re) {
            $code = 404;
        }
        $res['fav_id'] = intval($re);
        return getRes($res, $code);
    }
    /**
     * 收藏企业列表
     * @access public
     * @param $param
     * @return array
     */
    public function scqyList($param){
        $code = 200;
        $uid = isset($param['uid']) ? $param['uid'] : 0;
        if (!$uid) {
            $code = 401;
            return getRes($res, $code);
        }
        $modelAll = model('YzFavcompany');
        $modelAll->table = 'yz_fav_company';
        $maplc['member_uid'] = $uid;
        $map['where'] = $maplc;
        $map['join'] = [['yz_company c','c.qyid = yz_fav_company.qy_id']];
        $map['field'] = 'fav_id as favid,qy_id,c.qymc,addtime';
        $res = $modelAll->getList($map);
        if(isset($res['res'])){
            foreach($res['res'] as $k => $v){
                $res['res'][$k]['addtime'] = isset($v['addtime']) ? date("Y-m-d H:i:s", $v['addtime']) : '';
                $res['res'][$k]['url'] = HOST_URL.'/company/'.$v['qy_id'].'.html';
            }
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
    /**
     * 收藏企业
     * @access public
     * @param $param
     * @return array
     */
    public function scqy($param){
        $code = 200;
        $res = [];
        $where['member_uid'] = isset($param['uid']) ? $param['uid'] : 0;
        $where['qy_id'] = isset($param['qyid']) ? $param['qyid'] : 0;
        if (!$where['member_uid'] || !$where['qy_id']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['where'] = $where;
        $map['field'] = 'fav_id';
        $res = model('YzFavcompany')->getDetail($map);
        if($res){
            $code = 202;
        }else{
            unset($map);
            $map['data'] = array('member_uid' => $param['uid'], 'qy_id' => $param['qyid'], 'addtime' => time());
            $re = model('YzFavcompany')->insert($map);
            if (!$re) {
                $code = 404;
            }
            $res['fav_id'] = intval($re);
        }
        return getRes($res, $code);
    }
    /**
     * 建议反馈列表
     * @access public
     * @param $param
     * @return array
     */
    public function jyfkList($param){
        $code = 200;
        $uid = isset($param['uid']) ? $param['uid'] : 0;
        if (!$uid) {
            $code = 401;
            return getRes($res, $code);
        }
        $modelAll = model('Feedback');
        $map['table'] = 'be_feedback';
        $maplc['uid'] = $uid;
        $map['where'] = $maplc;
        $map['order'] = 'handel asc,addtime desc';
        $map['field'] = 'id,title,handel,addtime';
        $map['connection'] = 'olddb';
        $res = $modelAll->getAll($map);
        if(isset($res['res'])){
            foreach($res['res'] as $k => $v){
                $res['res'][$k]['handel_name'] = $v['handel'] == 2 ? '已回复' : '未回复';
                $res['res'][$k]['addtime'] = isset($v['addtime']) ? date("Y-m-d H:i:s", $v['addtime']) : '';
            }
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
    /**
     * 建议反馈列表
     * @access public
     * @param $param
     * @return array
     */
    public function jyfkDetail($param){
        $code = 200;
        $re = [];
        $modelAll = model('Feedback');
        $map['table'] = 'be_feedback';
        $where['uid'] = isset($param['uid']) ? $param['uid'] : 0;
        $where['id'] = isset($param['fid']) ? $param['fid'] : 0;
        if (!$where['uid'] || !$where['id']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['where'] = $where;
        $map['field'] = 'id,title,content,attach,reply,addtime';
        $map['connection'] = 'olddb';
        $res = $modelAll->getOne($map);
        if(!isset($res)){
            $code = 404;
        }else{
            $addtime = isset($res['addtime']) ? date("Y-m-d H:i:s", $res['addtime']) : '';
            $content = isset($res['content']) ? $res['content'] : $res['title'];
            $re['title'] = isset($res['title']) ? $res['title'] : "";
            $re['attach'] = isset($res['attach']) ? $res['attach'] : "";
            $reply = isset($res['reply']) ? $res['reply'] : "";
            if(substr($reply,0,3)==';;;'){
                $reply = 'A:'.$content.$addtime.$reply;
            }else{
                $reply = 'A:'.$content.$addtime.';;;'.$reply;
            }
            $reply_arr = explode(";;;", $reply);
            foreach($reply_arr as $k => $v){
                if(substr($v,0,2)=='Q:'){
                    //数据库Q和A存反了
                    $re['res'][$k]['type'] = 'A';
                }else{
                    $re['res'][$k]['type'] = 'Q';
                }
                preg_match("/^(Q|A):(.*)\d{4}-\d{1,2}-\d{1,2}\s\d{1,2}:\d{1,2}:\d{1,2}/is", $v, $content);
                preg_match("/\d{4}-\d{1,2}-\d{1,2}\s\d{1,2}:\d{1,2}:\d{1,2}/is", $v, $time);
                $re['res'][$k]['content'] = preg_replace('/^(&nbsp;|\s)*|(&nbsp;|\s)*$/isU', '', $content[2]);
                $re['res'][$k]['time'] = $time[0];
            }
            if (!$re) {
                $code = 404;
            }
        }
        return getRes($re, $code);
    }
    /**
     * 建议反馈追问
     * @access public
     * @param $uid 用户id
     * @param $fid 建议反馈id
     * @param $content 建议反馈内容
     * @return array
     */
    public function jyfkzw($param){
        $code = 200;
        $res = [];
        $modelAll = model('Feedback');
        $where['id'] = $param['fid'];
        $where['uid'] = isset($param['uid']) ? $param['uid'] : 0;
        $where['id'] = isset($param['fid']) ? $param['fid'] : 0;
        if (!$where['uid'] || !$where['id']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['table'] = 'be_feedback';
        $map['where'] = $where;
        $map['field'] = 'id,reply';
        $map['connection'] = 'olddb';
        $re = $modelAll->getOne($map);
        if(!isset($re)){
            $code = 404;
        }else{
            $map['data'] = array('handel' => 1, 'reply' => $re['reply'].';;;A:'.$param['content'].'  '.date("Y-m-d H:i:s",time()));
            $re = $modelAll->updateDate($map);
            if (!$re) {
                $code = 400;
            }
            $res['fid'] = $param['fid'];
        }
        return getRes($res, $code);
    }
    /**
     * 账号信息
     * @access public
     * @param $uid 用户id
     * @return array
     */
    public function userinfo($param){
        $code = 200;
        $res = [];
        $where['uid'] = isset($param['uid']) ? $param['uid'] : 0;
        if (!$where['uid']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['table'] = 'sys_user';
        $map['field'] = 'uid,grade_id,starttime,endtime,department,truename,address,comname,comtel';
        $map['where'] = $where;
        $map['connection'] = 'newdbbase';
        $res = $this->model->getOne($map);
		//获取drugeyes信息
		$mapdrugeyes['where'] = ['uid'=>$res['uid'] ?? 0];
		$resdrugeyes = $this->getDrugeyesMember($mapdrugeyes);
		$res['username'] = $resdrugeyes['username'] ?? '';
		$res['email'] = $resdrugeyes['email'] ?? '';
		$res['mobile'] = $resdrugeyes['mobile'] ?? '';
        $res['rank_name'] = '普通会员';
        $res['starttime'] = isset($res['starttime']) ? date('Y-m-d', $res['starttime']) : '';
        $res['endtime'] = isset($res['endtime']) ? date('Y-m-d', $res['endtime']) : '';
        if(isset($res['grade_id'])){
            $gmap['table'] = 'sys_user_grade';
            $gmap['field'] = 'title';
            $gmap['where'] = ['id'=>$res['grade_id']];
            $gmap['connection'] = 'newdbbase';
            $grade = model('Userrank')->getOne($gmap);
            if(isset($grade['title'])){
                $res['rank_name'] = $grade['title'];
            }
        }
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
	
    /**
     * 提交账号信息
     * @access public
     * @param $uid 用户id
     * @param $comname 企业名称
     * @param $department 部门
     * @param $truename 联系人
     * @param $comtel 联系电话
     * @param $address 联系地址
     * @return array
     */
    public function usersave($param){
        $code = 200;
        $res = [];
        $where['uid'] = isset($param['uid']) ? $param['uid'] : 0; 
        if (!$where['uid']) {
            $code = 401;
            return getRes($res, $code);
        }
        $map['table'] = 'sys_user';
        $map['where'] = $where;
        $map['connection'] = 'newdbbase';
        $map['data']['comname'] = isset($param['comname']) ? $param['comname'] : '';
        $map['data']['department'] = isset($param['department']) ? $param['department'] : '';
        $map['data']['truename'] = isset($param['truename']) ? $param['truename'] : '';
        $map['data']['comtel'] = isset($param['comtel']) ? $param['comtel'] : '';
        $map['data']['address'] = isset($param['address']) ? $param['address'] : '';
        $re = $this->model->updateDate($map);
        if (!$re) {
            $code = 400;
        }
        $res['uid'] = $param['uid'];
        return getRes($res, $code);
    }
}