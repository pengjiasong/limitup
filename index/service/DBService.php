<?php
namespace app\common\service;
use think\DB;

class DBService{
    /**
     * [findAll 查找所有数据]
     * @param  [type] $model [实例化后的模型]
     * @param  [type] $map   [条件：where order field page pageSize]
     * @return [type]        [data count page code codeMsg]
     */
    public function _findList($mm,$map){
        $model = $mm;
        // 获取分页参数
        $tmpPage = input('param.page');
        $tmpPageSize = input('param.pageSize');
        $type = $this->checkClass($model);
        // 返回值
        $return = [];
        // 字段、条件、排序
        $field = isset($map['field'])?$map['field']:'';
        $where = isset($map['where'])?$map['where']:'';
        $where_high = isset($map['where_high'])?$map['where_high']:'';
        $where_filter = isset($map['where_filter'])?$map['where_filter']:'';
        $order = $this->buildOrder($map);
        $union  = isset($map['union'])?$map['union']:[];
        $join = isset($map['join'])?$map['join']:[];
        $alias = isset($map['alias'])?$map['alias']:null;
        $group = isset($map['group'])?$map['group']:'';
        // 表名
        $table = isset($map['table'])?$map['table']:[];
        // return $where;
        // exit;
        $page = !empty($tmpPage)?$tmpPage:1;
        $pageSize = (!empty($tmpPageSize) && $tmpPageSize<=config('paginate.list_max_rows'))?$tmpPageSize:config('paginate.list_rows');
		// 分页
        $offset = ($page-1)*$pageSize;
        $limit = $offset.",".$pageSize;
        $limit = isset($map['limit'])?$map['limit']:$limit;

        $count = 0;
        // union查询和其他查询
        if($type == 'DB'){
            if($group){
                $count = $model->table($table)->alias($alias)->join($join)->where($where)->where($where_high)->where($where_filter)->group($group)->count();
            }else{
                $count = $model->table($table)->alias($alias)->join($join)->where($where)->where($where_high)->where($where_filter)->count();
            }
        }
        // 针对查询部分 union 和 正常的 的查询方式
        if ($union) {
            $new_union = [];
            $num_union = count($union);
            foreach ($union as $k => $v) {
                // 组合limit，在最后一个union上加limit
                $tmpv = $v;
                if ($num_union == $k+1) {
                    $tmpv .= ' limit '.$limit;
                }
                $newunion[] = $tmpv;
                // 累加union的总数count
                $ismatch = preg_match('/SELECT (.*?) FROM/', $v, $preg);
                if ($ismatch) {
                    $count_tmp = 0;
                    $preg[1] = str_replace(['(',')'],['\(','\)'],$preg[1]);
                    $v = preg_replace('/'.$preg[1].'/','COUNT(*) AS count', $v);
                    $count_tmp = Db::query($v);
                    if($count_tmp) {
                        $count += $count_tmp[0]['count'];
                    }
                }
            }
            if($order){
                //修改了一下union和order并用不得行的问题
                $sqlmap = db($table)->table($table)->where($where)->where($where_high)->alias($alias)->where($where_filter)->join($join)->field($field)->union($newunion,true)->select(false);
                $arr_map = explode('limit',$sqlmap);
                $arr_map_key = count($arr_map)-1;
                //完善sql里带有其他limit字段(2018.10.19)
                $arr_map_ = substr($sqlmap,0,strrpos($sqlmap,'limit'));
                $arr_map[0] .= ' ORDER BY ';
                if (is_array($order)) {
                    $order_key = array_keys($order);
                    $order_value = array_values($order);
                    foreach ($order_key as $k => $v) {
                        if($k!=0){
                            $arr_map_ .= ',';
                        }else{
                            $arr_map_ .= ' ORDER BY ';
                        }
                        $arr_map_ .= $v.' '.$order_value[$k];
                    }
                }else{
                    $arr_map_ .= ' ORDER BY '.$order;
                }
                $new_arr_map = $arr_map_.' limit '.$arr_map[$arr_map_key];
                $data['res'] = Db::query($new_arr_map);
            }else{
                // 查询
                $data['res'] = db($table)->table($table)->where($where)->where($where_high)->where($where_filter)->alias($alias)->join($join)->field($field)->group($group)->union($newunion,true)->select();
            }
        }else{
            $data['res'] = $model->table($table)->alias($alias)->join($join)->field($field)->where($where)->where($where_high)->where($where_filter)->group($group)->limit($limit)->order($order)->select();
		}
        // 条数
       if($type == 'ES'){
            $count = $model->total;
        }

        $data['count'] = $count;
        $data['page'] = intval($page);
        // 生成返回值：数据、总页数、当前页数
        if ($count>0) {
            $return = $data;
        }
        $this->debug($model,$map);
        return $return;
    }

    public function _findAll($model,$map){
        $type = $this->checkClass($model);
        // 返回值
        $return = [];
        $count = 0;
        // 字段、条件、排序
        $field = isset($map['field'])?$map['field']:'';
        $where = isset($map['where'])?$map['where']:'';
        $join = isset($map['join'])?$map['join']:[];
        $where_high = isset($map['where_high'])?$map['where_high']:'';
		$order = $this->buildOrder($map);
        $union  = isset($map['union'])?$map['union']:[];
        $group = isset($map['group'])?$map['group']:'';
    	// 表名
    	$table = isset($map['table'])?$map['table']:'';
        // var_dump($model->getlastsql());
		if($type == 'DB'){
            if($group){
                $count = $model->where($where)->where($where_high)->table($table)->group($group)->join($join)->count();
            }else{
                $count = $model->join($join)->where($where)->where($where_high)->table($table)->count();
            }
		}

        // 针对查询部分 union 和 正常的 的查询方式
        if ($union) {
            $new_union = [];
            foreach ($union as $k => $v) {
                $newunion[] = $v;
                // 累加union的总数count
                $ismatch = preg_match('/SELECT (.*?) FROM/', $v, $preg);
                if ($ismatch) {
                    $count_tmp = 0;
                    $v = preg_replace('/'.$preg[1].'/', 'COUNT(*) AS count', $v);
                    $count_tmp = Db::query($v);
                    if($count_tmp) {
                        $count += $count_tmp[0]['count'];
                    }
                }
            }
            // 查询
            $data['res'] = db($table)->table($table)->where($where)->where($where_high)->field($field)->union($newunion,true)->order($order)->select();
        }else{
            // 查询
            $data['res'] = $model->join($join)->table($table)->where($where)->where($where_high)->field($field)->order($order)->group($group)->select();
        }
    	// 条数
        if($type == 'ES'){
            $count=$model->total;
        }
        $data['count'] = $count;
        $data['page'] = 1;
        // 生成返回值：数据、总页数、当前页数
        if ($count>0) {
            $return = $data;
        }
        $this->debug($model,$map);
        return $return;
    }

    /**
     * [_findOne 查找一条记录]
     * @param  [type] $model     [模型]
     * @param  array  $map [条件['field','where','join','bind'...]]
     * @return [type]            [结果]
     */
    public function _findOne($model,$map=[]){
        // 表名
        $table = isset($map['table'])?$map['table']:'';
        // 字段条件
        $field = isset($map['field'])?$map['field']:'';
        $join = isset($map['join'])?$map['join']:[];
        $where = isset($map['where'])?$map['where']:'';
        $where_high = isset($map['where_high'])?$map['where_high']:'';
        $group = isset($map['group'])?$map['group']:'';
        $alias = isset($map['alias'])?$map['alias']:null;
        $order = $this->buildOrder($map);
        // 查询操作
        $return = $model->table($table)->alias($alias)->where($where)->where($where_high)->field($field)->join($join)->order($order)->group($group)->find();
        $this->debug($model,$map);
        return $return;
    }

    /**
     * [_findCount description]
     * @param  [type] $model [description]
     * @param  [type] $map   [description]
     * @return [type]        [description]
     */
    public function _findCount($model,$map){
        // 返回值
        $count = 0;
        // 字段、条件、排序
        $where = isset($map['where'])?$map['where']:'';
        $where_high = isset($map['where_high'])?$map['where_high']:'';
        // 表名
        $table = isset($map['table'])?$map['table']:'';
        $count = $model->where($where)->where($where_high)->table($table)->count();
        $this->debug($model,$map);
        return $count;
    }
    
    /**
     * 利用__call方法实现一些特殊的DB方法
     * @access public
     * @param string $method 方法名称
     * @param array  $args   调用参数
     * @return mixed
     * @throws DbException
     * @throws Exception
     */
    public function __call($method, $args=[])
    {
        if(isset($args[1])){
            $map = $args[1];
        }
        if($method == 'select'){
            // 返回值
            $count=0;
            // 字段、条件、排序
            $field = isset($map['field'])?$map['field']:'';
            $where = isset($map['where'])?$map['where']:'';
            $where_high = isset($map['where_high'])?$map['where_high']:'';
			$alias = isset($map['alias'])?$map['alias']:null;
            $order = $this->buildOrder($map);
            // 表名
            $table = isset($map['table'])?$map['table']:'';
			$join = isset($map['join'])?$map['join']:[];
            $group = isset($map['group'])?$map['group']:'';
            $limit = isset($map['limit'])?$map['limit']:'';
            // 主要给dsl查询用
            $datasel = isset($map['data'])?$map['data']:NULL;
            $dslname = isset($map['dslname'])?$map['dslname']:'';


            // DSL语句处理
            $dsl = '';
            if(!empty($dslname)) {
                // 获取sql并自动获取当前DSL
                $sql = $args[0]->table($table)->field($field)->where($where)->where($where_high)->group($group)->order($order)->limit($limit)->select(false);
                $dsltmp = $args[0]->getLastsql(1);
                // 按规则处理dsl
                $dslxx['name'] = $dslname;
                $dslxx['dsl'] = $dsltmp;
                // 组合新dsl
                $dsltmp = dslDeal($dslxx);
                $mapdsl['table'] = $table;
                $mapdsl['body'] = $dsltmp;
                $dsl = getDsl($mapdsl);
                // 如果要查看dsl
                if (isset($map['debug']) && $map['debug']=='dsl') {
                    dump($dsl);exit();
                }
            }
            // DB/ES/DSL查询          
            $return = $args[0]->table($table)->alias($alias)->field($field)->join($join)->where($where)->where($where_high)->group($group)->order($order)->limit($limit)->select($datasel,$dsl);
            $debug = $this->debug($args[0],$map);
            if(isset($map['debug']) && $map['debug'] == 'dsl') return $debug;
        }else if($method == 'dslSearch'){
            $return = $args[0]->dslSearch($map);
            $this->debug($args[0],$map);
        }else if(in_array($method, ['count','sum','min','max','avg','column','value'])){ //聚合函数        
		   // 字段
            $field = isset($map['field'])?$map['field']: ($method=='count'?'*':'');
            // 条件
            $where = isset($map['where'])?$map['where']:'';
            $where_high = isset($map['where_high'])?$map['where_high']:'';
            // 表名
            $table = isset($map['table'])?$map['table']:'';
			$return = $args[0]->table($table)->where($where)->where($where_high)->$method($field);
            $this->debug($args[0],$map);
        }else if(in_array($method, ['query','execute'])){ 
            if(isset($map['sql'])){
				$sql = $map['sql'];
				$class = get_class($args[0]);
				if(strstr($class , 'connector')){  //有连接
					$return = $args[0]->$method($sql);
				}else{
					$return = Db::$method($sql);
				}
                $this->debug($args[0],$map);
				return $return;
            }
			return false;	
        }else if(in_array($method, ['insert','insertAll'])){ 
            // 表名
            $table = isset($map['table'])?$map['table']:'';
            // 数据
            $data = isset($map['data'])?$map['data']:'';
            $unique = isset($map['unique'])? true:false;
            
            $return = $args[0]->table($table)->$method($data,$unique);
            if($method == 'insert'){
                $return = $args[0]->table($table)->getLastInsID();
            }
        }else if($method == 'update'){
            // 表名
            $table = isset($map['table'])?$map['table']:'';
            // 条件
            $where = isset($map['where'])?$map['where']:'';
            // 数据
            $data = isset($map['data'])?$map['data']:'';
           
            $return = $args[0]->table($table)->where($where)->$method($data);
            $this->debug($args[0],$map);
        }else if($method == 'delete'){ 
            // 表名
            $table = isset($map['table'])?$map['table']:'';
            // 条件
            $where = isset($map['where'])?$map['where']:'';
            $return = $args[0]->table($table)->where($where)->$method();
        }else{
            throw new Exception('method not exist:' . __CLASS__ . '->' . $method);
        }
        return $return;
    }

    /**
     * 通过设置debug关键字获取不同的调试信息 (buildSql方法没写，因为这个要用在数据库执行之前，要加判断，这个有需要的时候手动调用)
     * @access private
     * @param  [type] $model     [模型]
     * @param array  $map   调用参数
     */
    private function debug($model,$map=[])
    {
        if(!empty($map['debug'])){
            $type = $map['debug'];
            switch($type){
                case 'sql':
                    $res = $model->getLastsql();
                    break;
                case 'sqlencode':
                    $res = urlencode($model->getLastsql());
                    break;
                case 'dsl':
                    $res = $model->getLastsql(1);
                    break;
                default:
                    $res = [];
            }
            if($type=='dsl') return $res;
            else dump($res);
        }
    }
    
    /**
     * 通过传入model判断类型
     * @access private
     * @param  [type] $model     [模型]
     * @return string  类型
     */
    private function checkClass($model){
        $class = get_class($model);
        $type = 'DB';
        if(strstr($class,'Elasticsearch')){
            $type = 'ES';
        }
        return $type;
    }

    public function _groupBy($model,$map){
        // 表名
        $table = isset($map['table'])?$map['table']:'';
        // 字段条件
        $field = isset($map['field'])?$map['field'].',count(*) as count':'count(*) as count';
        $group = isset($map['group'])?$map['group']:'';
        $where = isset($map['where'])?$map['where']:'';
        $join = isset($map['join'])?$map['join']:[];
        $where_high = isset($map['where_high'])?$map['where_high']:'';
        $where_filter = isset($map['where_filter'])?$map['where_filter']:'';
        // 查询操作
        $return = $model->table($table)->where($where)->where($where_high)->where($where_filter)->join($join)->field($field)->group($group)->select();
        //echo $model->getlastsql();
        return $return;
    }

    /**
     * 生成order规则
     * @access private
     * @param  [type] $map    
     * @return $order string 
     */
    private function buildOrder($map=[]){
        $order = '';
		$requestOrder = $map['default_order'] ?? '';
		if(!empty(input('param.order'))){
			$requestOrder = input('param.order');
		}
        if(isset($map['order'])){
            $order = $map['order'];
        }else if($requestOrder){
            $controller = strtolower(request()->controller());
            $configOrder = config('order');
            $orderParm = explode(' ' , $requestOrder);
            if(isset($configOrder[$controller]['keyword']) && in_array($orderParm[0] , $configOrder[$controller]['keyword'])){
                if(count($orderParm) == 2){
                    $order = add_keyword($orderParm[0]).' '.$orderParm[1];
                }else{
                    $order = add_keyword($orderParm[0]);
                }
            }else if(isset($configOrder[$controller][$orderParm[0]])){
                if(count($orderParm) == 2){
                    $order = $configOrder[$controller][$orderParm[0]].' '.$orderParm[1];
                }else{
                    $order = $configOrder[$controller][$orderParm[0]];
                }
            }else{
                $order = $requestOrder;
            }
        }
        return $order;
    }
    /**
     * [_findOne 查找一条记录]
     * @param  [type] $model     [模型]
     * @param  array  $map [条件['field','where','join','bind'...]]
     * @return [type]            [结果]
     */
    public function _select($model,$map=[]){
        // 表名
        $table = isset($map['table'])?$map['table']:'';
        // 字段条件
        $field = isset($map['field'])?$map['field']:'';
        $join = isset($map['join'])?$map['join']:[];
        $where = isset($map['where'])?$map['where']:'';
        $where_high = isset($map['where_high'])?$map['where_high']:'';
        $group = isset($map['group'])?$map['group']:'';
        $limit = isset($map['limit'])?$map['limit']:'';
        $order = $this->buildOrder($map);
        // 查询操作
        $return = $model->table($table)->where($where)->where($where_high)->field($field)->join($join)->order($order)->group($group)->limit($limit)->select();
        $this->debug($model,$map);
        return $return;
    }
}