<?php
namespace app\index\logic;
use think\Model;

/**
 * [页面配置信息加载]
 * @Author: pjs <756420913@qq.com>
 */
class Help extends Model{

    public function __construct(){
        $this->model = model('Help');
    }

    /**
     * 获取帮助分类
     * @access public 
     * @return array
     */
    public function getCategory(){
		$code = 200;
        $res = [];
		
		$res = model('help')->getOne('zhuce');
		print_r($res);
		exit;
        if (!$res) {
            $code = 404;
        }else{
			$res = arr2tree($res);
		}
        return getRes($res, $code);
    }
	
    /**
     * 获取帮助标签
     * @access public 
     * @return array
     */
    public function getLabel(){
		$code = 200;
        $res = [];
		$map['table'] = 'base_help_label';
		$where['status'] = ['eq' , 1];
		$map['where'] = $where;
		$res = $this->model->select($map);
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
	
    /**
     * 获取帮助列表
     * @access public 
     * @return array
     */
    public function getList($param){
		$code = 200;
        $res = [];
		$where = [];
		$idarr = [];
		exit;
		if(!empty($param['catid'])){
			$wherecheck['pid'] = ['eq' , $param['catid']];
			$mapcheck['table'] = 'base_help_category';
			$mapcheck['field'] = 'id';
			$mapcheck['where'] = $wherecheck;
			$rescheck = $this->model->select($mapcheck);
			if(!empty($rescheck)){
				$idarr = array_column($rescheck, 'id');
			}else{
				$idarr = [$param['catid']];
			}
		}
		
		if(!empty($param['name'])){
			$where['name'] = ['like' , '%'.$param['name'].'%'];
		}else if(!empty($idarr)){
			$where['catid'] = ['in' , implode(',' , $idarr)];
		}
		$where['status'] = ['eq' , 1];
		$map['field'] = 'name,id,content';
		$map['table'] = 'base_help';
		$map['order'] = 'sort desc';
		$map['where'] = $where;
		$res = $this->model->getList($map);
        if (!$res) {
            $code = 404;
        }
        return getRes($res, $code);
    }
	
    /**
     * 获取帮助详情
     * @access public 
     * @return array
     */
    public function getInfo($id){
		$code = 200;
        $res = [];
		$where = [];
		if(!empty($id)){
			$where['id'] = ['eq' , $id];
		}else{
			return getRes($res, 401);
		}
		$tokenUser = config('tokenUser');
		$map['table'] = 'base_help';
		$map['field'] = 'id,catid,name,content,addtime,liulan,labelid';
		$map['where'] = $where;
		$res = $this->model->getOne($map);
        if (!$res) {
            $code = 404;
        }else{
			//帮助关联标签文章
			$redis = model('RedisService','service');
			$redkey = md5(($tokenUser['uid'] ?? '') .'help'. $res['id']);
			if (!$redis->exists($redkey)) {
				$mapupdate['table'] = 'base_help';
				$mapupdate['data'] = ['liulan' => $res['liulan'] + 1];
				$mapupdate['where']['id'] = ['eq' , $id];
				$this->model->updata($mapupdate);
				$redis->set($redkey, $redkey, 300); //保存5分钟
			}
			$resLabel = [];
			if(!empty($res['labelid'])){
				$labelid = explode(',' , $res['labelid']);
				$mapLabel['table'] = 'base_help';
				$mapLabel['field'] = 'id,name,addtime';
				$mapLabel['sort'] = 'addtime desc';
				$whereLabel = [];
				foreach($labelid as $temp){
					$whereLabel[] = "find_in_set(".$temp.",labelid) && status = 1 && id != ".$res['id'];
				}
				$mapLabel['where'] = '('.implode(' || ' , $whereLabel).')';
				$resLabel = $this->model->select($mapLabel);
			}
			$res['helpLabel'] = $resLabel;
			
			//是否点过赞
			$mapLove['table'] = 'base_help_love';
			$mapLove['field'] = 'type';
			$mapLove['where']['helpid'] = ['eq' , $id];
			$mapLove['where']['uid'] = ['eq' , $tokenUser['uid'] ?? 0];
			$resLove = $this->model->getOne($mapLove);
			$res['lovetype'] = 0;
			if(!empty($resLove)){
				$res['lovetype'] = $resLove['type'];
			}
			
			//点赞数和无用数
			$mapLove2['table'] = 'base_help_love';
			$mapLove2['field'] = 'type,count(*) as count';
			$mapLove2['group'] = 'type';
			$mapLove2['where']['helpid'] = ['eq' , $id];
			$resLove2 = $this->model->select($mapLove2);
			$res['lovecount'] = 0;
			$res['badcount'] = 0;
			foreach($resLove2 as $val){
				if($val['type'] == 1){
					$res['lovecount'] = $val['count'];
				}else if($val['type'] == 2){
					$res['badcount'] = $val['count'];
				}
			}
		}
        return getRes($res, $code);
    }
	
    /**
     * 点赞
     * @access public 
     * @return array
     */
    public function helpLove($param = []){
		$code = 200;
        $res = [];
		if(empty($param['id'])){
			return getRes($res, 401);
		}
		if(empty($param['type'])){
			return getRes($res, 401);
		}
		if(!in_array($param['type'] , [1,2])){
			return getRes($res, 401);
		}
		$tokenUser = config('tokenUser');
		$wheres['uid'] = ['eq' , $tokenUser['uid'] ?? 0];
		$wheres['helpid'] = ['eq' , $param['id']];
		$map['table'] = 'base_help_love';
		$map['field'] = 'type';
		$map['where'] = $wheres;
		$restemp = $this->model->getOne($map);
		$insertmap['table'] = 'base_help_love';
		$insertmap['data'] = ['uid'=>$tokenUser['uid'] ?? 0 , 'helpid' =>$param['id'], 'type' =>$param['type']];
        if (!empty($restemp)) {
			if($restemp['type'] == $param['type']){
				$code = 12003;
			}else{
				$insertmap['where'] = $wheres;
				$restemp2 = $this->model->updata($insertmap);
				if(!$restemp2){
					$code = 404;
				}
			}
        }else{
			$restemp2 = $this->model->insert($insertmap);
			if(!$restemp2){
				$code = 404;
			}
		}
        return getRes($res, $code);
    }

}