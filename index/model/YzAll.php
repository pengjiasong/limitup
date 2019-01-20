<?php
namespace app\common\model;
use think\Model;

class YzAll extends Model{

    // 设置当前模型对应的完整数据表名称
    public $table = '';
    protected $model;

    function __construct(){
        $this->model = model('DBService','service');
    }

    public function getList($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_findList($this,$map);
        return $return;
    }
	
    public function select($map = []){
        $map['table'] = $this->table;
        $return = $this->model->select($this,$map);
        return $return;
    }

    public function getOne($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_findOne($this,$map);
        return $return;
    }

    public function getGroup($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_groupBy($this,$map);
        return $return;
    }

    public function getCount($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_findCount($this,$map);
        return $return;
    }

    public function getAll($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_findAll($this,$map);
        return $return;
    }
    public function getGroupList($map = []){
        $map['table'] = $this->table;
        $return = $this->model->_select($this,$map);
        return $return;
    }
}