<?php
namespace app\index\controller;

class Index extends Common
{
    public function _initialize() {
    	parent::_initialize();
    	$this->logic = model('EsZhuce','logic');
    }

    /**
     * 注册与受理数据库列表
	 * @access public
     * @return array
     */
    public function index(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->getList($param);
		return $res;
    }

    /**
     * 列表页按药品名称浏览数据统计
	 * @access public 
     * @return array
     */
    public function nameGroup(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$param['order'] = input('param.order','');
		Request::instance()->get(['order'=>'']);
		$res = $this->logic->nameGroup($param);
		return $res;
    }
	
    /**
     * 列表页按药品名称浏览数据
	 * @access public 
     * @return array
     */
    public function nameList(){ 
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->nameList($param);
		return $res;
    }
	
    /**
     * 列表页按企业名称浏览数据统计
	 * @access public 
     * @return array
     */
    public function qiyeGroup(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$param['order'] = input('param.order','');
		Request::instance()->get(['order'=>'']);
		$res = $this->logic->qiyeGroup($param);
		return $res;
    }
	
    public function index()
    {
	   $this->logic = model('Help','logic');
	   $this->logic = model('EsZhuce','logic');
       // return $this->fetch();
    }
    
}
