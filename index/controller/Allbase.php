<?php
namespace app\common\controller;
use think\Request;

class Allbase extends Base{

    public function _initialize() {
    	parent::_initialize();
    	$logic = model('YzAll','logic');
    	$this->res = $logic->common();
    }
    public function index(){
        $res = $this->res;
        return $res;
    }

    public function read(){
        $res = $this->res;
        return $res;        
    }
    public function input(){
        $res = $this->res;
        return $res;
    }
    public function outdata(){
        $res = $this->res;
        return $res;
    }
	
    public function savewhere(){
        $res = $this->res;
        return $res;
    }
	
    public function delsavewhere(){
        $res = $this->res;
        return $res;
    }
	
    public function savewherelist(){
        $res = $this->res;
        return $res;
    }
    
}
