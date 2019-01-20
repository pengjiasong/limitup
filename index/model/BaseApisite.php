<?php
namespace app\common\model;
use think\Model;

class BaseApisite extends Model{

    // 设置当前模型对应的完整数据表名称
    protected $table = 'base_apisite';
    protected $dbserver;

    function __construct(){
        $this->dbserver = model('DBService','service');
    } 

    public function getAll($map = []){
        $map['table'] = $this->table;
        $return = $this->dbserver->_findAll($this,$map);
        return $return;
    }


    public function getOne($map = []){
        $map['table'] = $this->table;
        $return = $this->dbserver->_findOne($this,$map);
        return $return;
    }

}