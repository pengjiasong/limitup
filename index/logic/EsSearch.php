<?php
namespace app\common\logic;

class EsSearch{

	private $categoryMapping = [
									'drug' => '药品' ,
									'company' => '企业',
									'devices' => '医疗器械',
									'chinesemedicine' => '中药材' ,
									'targetspot' => '靶点',
									'disease' => '疾病'
							];
	private $fieldtype = ['drug','company','devices','chinesemedicine','targetspot','disease'];

    public function __construct(){
        $this->model = model('EsSearch');
    }

	//综合搜索
	public function getGroupList($param){
        $res = [];
		// 组合条件
		$code = 200;
		$where = [];
		// $fieldtype['like'] = $this->fieldtype;
		// $where = arr_to_where($param , $fieldtype);
		$keyname = array_keys($param)[0];
		// $valuename = strtolower(array_values($param)[0]);
		$valuename = array_values($param)[0];
		// $where = $keyname.' = REGEXP_QUERY(".*'.$valuename.'.*") OR '.$keyname.'.keyword = REGEXP_QUERY(".*'.$valuename.'.*")';
		// $where = $keyname.'.keyword = REGEXP_QUERY(".*'.$valuename.'.*") OR '.$keyname.'=("'.$valuename.'")';
		$where = $keyname.'.keyword = REGEXP_QUERY(".*'.$valuename.'.*") OR '.$keyname.' LIKE ("%'.$valuename.'%") OR '.$keyname.'=("'.$valuename.'")';
		// dump($where);
		$mapDbs['where'] = $where;
		$mapDbs['table'] = 'search';
		$mapDbs['field'] = 'db_control.keyword as dbs';
		$mapDbs['group'] = '(dbs)';
		// $mapDbs['debug'] = 'sql';
		$dbs = $this->model->getGroupList($mapDbs);
		if ($dbs) $dbs = $dbs['dbs'];

		//综合搜索历史记录
		$tokenUser = config('tokenUser');
		$redis = model('RedisService','service');
		$firstVal = reset($param);
		$firstKey = key($param);
		$redkey = md5(($tokenUser['uid'] ?? '') . $firstKey . $firstVal);
		if (!$redis->exists($redkey)) {
			$insertData['uid'] = $tokenUser['uid'] ?? 0; 
			$insertData['username'] = $tokenUser['username'] ?? ''; 
			$insertData['rank_name'] = $tokenUser['rank_name'] ?? ''; 
			$insertData['category'] = $this->categoryMapping[$firstKey] ?? ''; 
			$insertData['keywords'] = $firstVal; 
			$insertData['addtime'] = time(); 
			$insertData['num'] = array_sum(array_column($dbs, 'doc_count')); 
			$mapInsert['table'] = 'base_comprehensive_search_keywords';
			$mapInsert['data'] = $insertData;
			model('NewDb')->insert($mapInsert);
			$redis->set($redkey, $redkey, 300); //保存5分钟
		}		
		// 获取数据库配置表
        $mapNav['field'] = 'id,label as title,"" as db_control,0 as pid,"" as href';
        $navs = model('Config','logic')->getSearchNav($mapNav);
        if ($navs['res']) $navs = $navs['res'];
        // 查找数据库的配置
        $search = [];
        $pids = [];
    	foreach ($navs as $k => $v) {
	        foreach ($dbs as $kk => $vv) {
	        	if($v['db_control'] == $vv['key']){
	        		$v['count'] = $vv['doc_count'];
	        		$search[] = $v;
	        		$pids[] = $v['pid'];
	        	}
	        }
    	}
    	// 查找父级菜单
    	foreach ($navs as $k => $v) {
    		if (in_array($v['id'], $pids) && $v['pid']==0) {
    			$search[] = $v;
    		}
    	}
    	// 组合新菜单
	    $res['dbs'] = searchNavToTree($search);
	    // 药物报告
		$report = [];
	    if (isset($param['drug'])) {
		    // 查找药物报告
		    $drug['searchall'] = $param['drug'];
		    $report = model('EsReport','logic')->getReportForSearch($drug);
	    }
	    $res['report'] = $report;
	    // 企业报告
		$company = [];
	    if (isset($param['company'])) {
		    // 企业报告条件组合
		    $qiye['qymc'] = $param['company'];
		    // dump($company);
		    $company = model('YzCompany','logic')->getCompanyForSearch($qiye);
	    }
	    $res['company'] = $company;

		if (!$res['dbs'] && !$res['report']) {
			$res = [];
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 返回综合搜索提示词
	 * @access public
     * @param array $param 参数数组
     * @return array
     */
	public function input($param = []){
        $res = [];
		$code = 200;
		if(!empty($param)){
			$key = key($param);
			$value = $param[$key];
			$value_len = strlen($value);
			if(in_array($key , $this->fieldtype)){
				$n = 10;
				$mapDbs['where'] = $key.'.pinyin = REGEXP_QUERY("'.$value.'.*")';
				$mapDbs['table'] = 'searchall_suggest';
				$mapDbs['field'] = $key.'.keyword as dbs';
				$mapDbs['group'] = '(dbs)';
				$mapDbs['limit'] = '0,'.$n;
				$dbs = $this->model->getGroupList($mapDbs);
				if (isset($dbs['dbs']) && count($dbs['dbs'])<$n) {
					$n = $n - count($dbs['dbs']);
					$mapDbs['limit'] = '0,'.$n;
					$mapDbs['where'] = $key.'.pinyin = REGEXP_QUERY(".*'.$value.'.*")';
					$tmp_dbs = $this->model->getGroupList($mapDbs);
					if(isset($tmp_dbs['dbs'])) $dbs['dbs'] = array_merge($dbs['dbs'], $tmp_dbs['dbs']);
				}
				if ($dbs){
					$resdbs = array_column($dbs['dbs'] , 'key');
					$res_zh = $res_other = [];
					foreach ($resdbs as $k => $v) {
						 if (strtolower(substr($v,0,$value_len))==strtolower($value)) {
						        $res_other[] = $v;
						    } else {
						        $res_zh[] = $v;
						    }
					}
					$res = array_merge($res_other,$res_zh);
					$res = array_unique($res);
				}
			}
		}
		$res = array_values($res);
		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 返回综合搜索历史搜索
	 * @access public
     * @param array $param 参数数组
     * @return array
     */
	public function history($param = []){
        $res = [];
		$code = 200;
		$where = [];

		if(!empty($param['type']) && in_array($param['type'] , $this->fieldtype)){
			$tokenUser = config('tokenUser');
			$map['table'] = 'base_comprehensive_search_keywords';
			$map['where'] = ['uid'=>$tokenUser['uid'] ?? 0 , 'category'=>$this->categoryMapping[$param['type']] ?? 0  , 'status' => 1];
			$map['group'] = 'keywords';
			$map['order'] = 'id desc';
			$map['field'] = 'keywords';
			$map['limit'] = '0,5';
			$restemp = model('NewDb')->select($map);
			$res = array_column($restemp , 'keywords');
		}
		
		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 综合搜索热搜
	 * @access public
     * @param array $param 参数数组
     * @return array
     */
	public function hot($param = []){
        $res = [];
		$code = 200;
		$where = [];

		if(!empty($param['type']) && in_array($param['type'] , $this->fieldtype)){
			$map['table'] = 'base_comprehensive_search_keywords';
			$map['where'] = ['category'=>$this->categoryMapping[$param['type']] ?? 0  , 'status' => 1];
			$map['group'] = 'keywords';
			$map['order'] = 'num desc';
			$map['field'] = 'count(*) as num,keywords';
			$map['limit'] = '0,5';
			$restemp = model('NewDb')->select($map);
			$res = array_column($restemp , 'keywords');
		}
		
		if (!$res) {
			$code = 404;
		}
		return getRes($res, $code);
	}
	
    /**
     * 删除综合搜索历史记录
	 * @access public
     * @param array $param 参数数组
     * @return array
     */
	public function delhistory($param = []){
        $res = [];
		$code = 200;
		
		$firstVal = reset($param);
		$firstKey = key($param);
		if(in_array($firstKey , $this->fieldtype)){
			$tokenUser = config('tokenUser');
			$map['table'] = 'base_comprehensive_search_keywords';
			$map['where'] = ['uid'=>$tokenUser['uid'] ?? 0 , 'category'=>$this->categoryMapping[$firstKey] ?? 0  , 'keywords' => $firstVal];
			if(empty($firstVal)) unset($map['where']['keywords']);
			$map['data'] = ['status' => 0];
			if(!model('NewDb')->updateData($map)){
				$code = 404;
			}
		}
		return getRes($res, $code);
	}

}