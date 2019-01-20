<?php
namespace app\common\controller;
use think\Request;

class Configbase extends Base{

    public function _initialize() {
    	parent::_initialize();
		$this->logic = model('Config','logic');
    }
	
    /**
     * [search 搜索参数列表配置]
     * @access public 
     * @return array
     */
    public function search(){
        // 限定接收参数
        $field = 'dbname';
		$param = Request::instance()->only($field);
		$res = $this->logic->getSearch($param);
        return $res;
    }
	
    /**
     * [view 前端基本参数配置]
     * @access public 
     * @return array
     */
    public function view(){
        // 限定接收参数
        $field = 'dbname';
		$param = Request::instance()->only($field);
		$res = $this->logic->getView($param);
        return $res;
    }
	
    public function searchInsert(){
		$this->logic->searchInsert();
    }

    public function read(){
        $res = $this->res;
        return $res;    	
    }

    // 数据库导航获取接口
    public function getNav(){
        $res = $this->getNav();
        return $res; 
    }

    public function breadCrumb(){
        $field = 'dbname';
        $param = Request::instance()->only($field);
        $res = $this->logic->breadCrumb($param);
        return $res;
    }
    
}
