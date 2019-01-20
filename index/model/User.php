<?php
namespace app\common\model;
use think\DB;
use think\Model;

class User extends Model{
	
	public $model;

	function __construct(){
		$this->model = model('DBService','service');
	}

    public function getOne($map=[]){
		$return = $this->model->_findOne(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
        return $return;
    }
	
    public function getList($map=[]){
		$return = $this->model->_findList(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
        return $return;
    }
    
    public function getAll($map = []){
        $return = $this->model->_findAll(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
        return $return;
    }
	
    public function insert($map = []){
        $return = $this->model->insert(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
	    return $return;
    }
	
    public function insertAll($map = []){
        $return = $this->model->insertAll(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
	    return $return;
    }
	
    public function delete($map = []){
        $return = $this->model->delete(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
	    return $return;
	}
	
    public function select($map = []){
        $return = $this->model->select(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
	    return $return;
	}
    
    public function updateDate($map = []){
        $return = $this->model->update(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
        return $return;
    }
}