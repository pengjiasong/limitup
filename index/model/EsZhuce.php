<?php
namespace app\common\model;

class EsZhuce{

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

    public function getCount($map=[]){
        $return = $this->model->_findCount($this->es, $map);
        return $return;
    }

    public function getMax($map=[]){
        $return = $this->model->max($this->es, $map);
        return $return;
    }
	
    public function getMin($map=[]){
        $return = $this->model->min($this->es, $map);
        return $return;
    }
	
    public function getDslSearch($map=[]){
        $return = $this->model->dslSearch($this->es, $map);
        return $return;
    }
}