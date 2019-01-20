<?php
namespace app\common\model;
use think\Model;
use think\Db;

class NewDb extends Model{

    function __construct(){
        $this->dbserver = model('DBService','service');
    } 

    public function getAll($map = []){
        $return = $this->dbserver->_findAll($this,$map);
        return $return;
    }
	
    public function getList($map = []){
        $return = $this->dbserver->_findList($this,$map);
        return $return;
    }

    public function getOne($map = []){
        $return = $this->dbserver->_findOne($this,$map);
        return $return;
    }
	
    public function select($map=[]){
        $return = $this->dbserver->select($this,$map);
        return $return;
    }
	
    public function insert($map = []){
        $return = $this->dbserver->insert($this,$map);
        return $return;
    }

	public function updateData($map = []){
        $return = $this->dbserver->update($this,$map);
        return $return;
    }
}