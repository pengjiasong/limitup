<?php
namespace app\index\model;
use think\Model;

class Help extends Model{

    function __construct(){
        $this->dbserver = model('DBService','service');
    }

    public function getList($map = []){
		// $this->checkModel($map);
        $return = $this->dbserver->_findList($this->model,$map);
        return $return;
    }
	
    public function getOne($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->_findOne($this->model,$map);
        return $return;
    }
	
    // public function select($map = []){
		// exit;
        // $return = $this->dbserver->select($this->model,$map);
        // return $return;
    // }

    public function insert($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->insert($this->model,$map);
        return $return;
    }
	
    public function updata($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->update($this->model,$map);
        return $return;
    }
	
    public function count($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->count($this->model,$map);
        return $return;
    }
	
	private function checkModel($map = []){
		$dbs = config('ES.DBS');
		if(isset($map['table']) && in_array($map['table'] , $dbs)){
			$this->model = model('Elasticsearch','service');
		}else{
			$this->model = $this;
		}
	}

    public function getAll($map = []){
        $this->checkModel($map);
        $return = $this->dbserver->_findAll($this->model,$map);
        return $return;        
    }
}