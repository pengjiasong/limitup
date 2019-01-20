<?php
namespace app\common\controller;
use think\Request;

class Rssbase extends Base{
	
    public function _initialize() {
    	parent::_initialize();
    	$this->logic = model('Rss','logic');
    }

    /**
     * 订阅消息列表
	 * @access public
     * @return array
     */
    public function index(){
		$res = $this->logic->rssMsgList();
		return $res;
    }
	
    /**
     * 用户消息列表
	 * @access public
     * @return array
     */
    public function msg(){
		$res = $this->logic->msgList();
		return $res;
    }
	
	
    /**
     * 添加订阅条件
	 * @access public
     * @return array
     */
    public function addwhere(){
        // 限定接收参数
		$param = Request::instance()->only('dbname,shoulihao,name,qiyemingcheng,ylbm,send_type,send_email,subscribe_type');
		$res = $this->logic->addWhere($param);
		return $res;
    }
	
    /**
     * 订阅条件列表
	 * @access public
     * @return array
     */
    public function where(){
        // 限定接收参数
		$res = $this->logic->whereList();
		return $res;
    }
	
    /**
     * 取消订阅
	 * @access public
     * @return array
     */
    public function delrsswhere(){
        // 限定接收参数
		$param = Request::instance()->only('id');
		$res = $this->logic->delrsswhere($param);
		return $res;
    }
	
    /**
     * 注册订阅具体消息列表
	 * @access public
     * @return array
     */
    public function zhuce(){
        // 限定接收参数
		$param = Request::instance()->only('id');
		$res = $this->logic->zhuce($param);
		return $res;
    }
	
    /**
     * 注册订阅受理号变化
	 * @access public
     * @return array
     */
    public function zhuceshouli(){
        // 限定接收参数
		$param = Request::instance()->only('id');
		$res = $this->logic->zhuceshouli($param);
		return $res;
    }
	
    /**
     * 注册订阅受理号变化
	 * @access public
     * @return array
     */
    public function zhuceinput(){
        // 限定接收参数
		$param = Request::instance()->only('shoulihao,name,qiyemingcheng,ylbm');
		$res = $this->logic->zhuceinput($param);
		return $res;
    }
}
