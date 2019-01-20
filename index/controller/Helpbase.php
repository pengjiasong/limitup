<?php
namespace app\common\controller;
use think\Request;

class Helpbase extends Base{

    public function _initialize() {
    	parent::_initialize();
		$this->logic = model('Help','logic');
    }
	
    /**
     * [category 获取帮助分类]
     * @access public 
     * @return array
     */
    public function category(){
		$res = $this->logic->getCategory();
        return $res;
    }
	
    /**
     * [category 获取帮助标签]
     * @access public 
     * @return array
     */
    public function label(){
		$res = $this->logic->getLabel();
        return $res;
    }
	
    /**
     * [list 获取帮助列表]
     * @access public 
     * @return array
     */
    public function list(){
        // 限定接收参数
        $field = 'name,catid';
		$param = Request::instance()->only($field);
		$res = $this->logic->getList($param);
        return $res;
    }
	
    /**
     * [read 获取帮助详情]
     * @access public 
     * @return array
     */
    public function read($id){
		$res = $this->logic->getInfo($id);
        return $res;
    }
    
    /**
     * [read 获取帮助详情]
     * @access public 
     * @return array
     */
    public function love(){
		$field = 'id,type';
		$param = Request::instance()->only($field);
		$res = $this->logic->helpLove($param);
        return $res;
    }
}
