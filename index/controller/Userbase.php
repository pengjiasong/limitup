<?php
namespace app\common\controller;
use think\Request;

class Userbase extends Base{

	private $salt = 'drugeyes';
	
    public function _initialize() {
    	parent::_initialize();
    	$this->logic = model('User','logic');
    	
    }
}
