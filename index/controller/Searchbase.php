<?php
namespace app\common\controller;
use think\Request;

class Searchbase extends Base{

    public function _initialize() {
    	parent::_initialize();
    	$this->logic = model('EsSearch','logic');
        $this->field = 'drug,company,devices,chinesemedicine,targetspot,disease';
    }

    /**
     * [index 注册与受理数据库列表]
     * @return [type] [description]
     */
    public function index(){
        // 限定接收参数
        $field = $this->field;
		$param = Request::instance()->only($field);
		$res = $this->logic->getGroupList($param);
		return $res;
    }
	
    /**
     * 综合搜索词
     * @access public 
     * @return array
     */
    public function input(){
        // 限定接收参数
        $field = $this->field;
		$param = Request::instance()->only($field);
		$res = $this->logic->input($param);
		return $res;
    }
	
    /**
     * 综合搜索历史记录
     * @access public 
     * @return array
     */
    public function history(){
        // 限定接收参数
        $field = 'type';
		$param = Request::instance()->only($field);
		$res = $this->logic->history($param);
		return $res;
    }
	
    /**
     * 综合搜索热搜
     * @access public 
     * @return array
     */
    public function hot(){
        // 限定接收参数
        $field = 'type';
		$param = Request::instance()->only($field);
		$res = $this->logic->hot($param);
		return $res;
    }
	
    /**
     * 删除综合搜索历史记录
     * @access public 
     * @return array
     */
    public function delhistory(){
        // 限定接收参数
        $field = $this->field;
		$param = Request::instance()->only($field);
		$res = $this->logic->delhistory($param);
		return $res;
    }

    public function getinfo(){
        // 接收参数
        $field = 'db,type,content';
        $param = Request::instance()->only($field);
        $res = $this->logic->getInfo($param);
        return $res;
    }
        
}
