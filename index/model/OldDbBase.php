<?php
namespace app\common\model;
use think\Model;
use think\Db;

class OldDbBase extends Model{

    // 设置当前模型对应的完整数据表名称
    protected $table = '';


    function __construct(){
        $this->connect('olddb');
        $this->dbserver = model('DBService','service');
    }

    public function getAll($map = []){
        $this->table = $map['table'];
        $return = $this->dbserver->_findAll($this,$map);
        return $return;
    }


    public function getOne($map = []){
        $map['table'] = $this->table;
        $return = $this->dbserver->_findOne($this,$map);
        return $return;
    }

}