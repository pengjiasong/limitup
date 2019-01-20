<?php
namespace app\common\model;
use think\Model;
use think\Db;

class NewDbBase extends Model{

    // 设置当前模型对应的完整数据表名称
    protected $table = '';


    function __construct(){
        $this->connect('newdbBase');
        $this->dbserver = model('DBService','service');
    } 

    public function getAll($map = []){
        $this->table = $map['table'] ?? $this->table;
        $return = $this->dbserver->_findList($this,$map);
        return $return;
    }


    public function getOne($map = []){
        $this->table = $map['table'] ?? $this->table;
        $return = $this->dbserver->_findOne($this,$map);
        return $return;
    }
	
    public function select($map = []){
        $this->table = $map['table'] ?? $this->table;
        $return = $this->dbserver->select($this,$map);
        return $return;
    }

}