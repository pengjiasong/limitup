<?php
namespace app\index\model;
use think\Model;

class Help extends Model{

	protected $table = 'zhuce';
    protected $field = '*';
    protected $where = [];
	protected $whereOr = [];
	protected $union = [];
	protected $join = [];
	protected $alias = '';
	protected $group = '';
	protected $order = '';
	protected $connect;
	protected $thisModel = '';

	function __construct($table = ''){
		$this->table = $table ?: $this->table;
		
		$dbs = config('ES.DBS');
		if(in_array($this->table , $dbs)){
			$this->model = model('Elasticsearch','service');
		}else{
			$this->model = $this::connect($this->connect);
		}
	}

    protected function selectModel(){
        $this->thisModel = $this->model->table($this->table)->alias($this->alias)->field($this->field)
			->join($this->join)->where($this->where)->group($this->group)->order($this->order);
	}

    public function getList($map = []){
		// $this->checkModel($map);
        $return = $this->dbserver->_findList($this->model,$map);
        return $return;
    }
	
    public function getOne(){
		$this->selectModel();
		return $this->thisModel->select();
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