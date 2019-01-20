<?php
namespace app\common\model;

class EsSearch{

	public $model;
	public $es;

	function __construct(){
		$this->model = model('DBService','service');
		$this->es = model('Elasticsearch','service');
	}

    public function getList($map=[]){
        $return = $this->model->_findList($this->es,$map);
        return $return;
    }
	
    public function getGroupList($map=[]){
        $return = $this->model->select($this->es,$map);
        return $return;
    }

    public function getOne($map=[]){
        $return = $this->model->_findOne($this->es,$map);
        return $return;
    }
    
    public function getAll($map=[]){
        $return = $this->model->_findAll($this->es,$map);
        return $return;
    }

    public function getDslSearch($map = ''){
        $return = $this->es->dslSearch($map);
        return $return;
    }

}