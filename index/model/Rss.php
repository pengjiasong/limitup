<?php
namespace app\common\model;
use think\Model;
use think\Db;

class Rss extends Model{

    protected $model;
    protected $dbserver;

    function __construct(){
        $this->dbserver = model('DBService','service');
    }

    public function getList($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->_findList($this->model,$map);
        return $return;
    }
	
    public function getOne($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->_findOne($this->model,$map);
        return $return;
    }
	
    public function select($map=[]){
		$this->checkModel($map);
        $return = $this->dbserver->select($this->model,$map);
        return $return;
    }

    public function insert($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->insert($this->model,$map);
        return $return;
    }
	
    public function count($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->count($this->model,$map);
        return $return;
    }
	
    public function delete($map = []){
		$this->checkModel($map);
        $return = $this->dbserver->delete($this->model,$map);
        return $return;
    }
	
    public function query($map = []){
        $return = $this->dbserver->query(!empty($map['connection']) ? Db::connect($map['connection']) : $this,$map);
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
}