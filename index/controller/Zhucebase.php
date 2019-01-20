<?php
namespace app\common\controller;
use think\Request;

class Zhucebase extends Base{
	// 接收参数
	private $field = 'name,name_eq,shoulihao,qiyemingcheng,qiyemingcheng_eq,chengbanriqi,zhuangtaikaishishijian,zhuceleixing,yaopinleixing,shenqingleixing,xulie,linchuang,banlizhuangtai,tspz,zdzx,yxsp,guifanjixing,shenpingrenwufenlei,words,comprehensive,searchwords,filter_condition,fourth_condition,groupname,bianma,qiyebianmatz';

    public function _initialize() {
    	parent::_initialize();
    	$this->logic = model('EsZhuce','logic');
    }

    /**
     * 注册与受理数据库列表
	 * @access public
     * @return array
     */
    public function index(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->getList($param);
		return $res;
    }

    /**
     * 列表页按药品名称浏览数据统计
	 * @access public 
     * @return array
     */
    public function nameGroup(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$param['order'] = input('param.order','');
		Request::instance()->get(['order'=>'']);
		$res = $this->logic->nameGroup($param);
		return $res;
    }
	
    /**
     * 列表页按药品名称浏览数据
	 * @access public 
     * @return array
     */
    public function nameList(){ 
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->nameList($param);
		return $res;
    }
	
    /**
     * 列表页按企业名称浏览数据统计
	 * @access public 
     * @return array
     */
    public function qiyeGroup(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$param['order'] = input('param.order','');
		Request::instance()->get(['order'=>'']);
		$res = $this->logic->qiyeGroup($param);
		return $res;
    }
	
    /**
     * 列表页按企业名称浏览数据
	 * @access public 
     * @return array
     */
    public function qiyeList(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->qiyeList($param);
		return $res;
    }
	
    /**
     * 注册数据库搜索词
     * @access public 
     * @return array
     */
	public function input(){
		$field = 'name,qiyemingcheng'; 
		$param = Request::instance()->only($field);
		$res = $this->logic->input($param);
		return $res;
	}
	
    /**
     * 列表页导出数据
	 * @access public 
     * @return array
     */
    public function outData(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$option = Request::instance()->only('outdata_action,outdata_column');
		$res = $this->logic->outData($param,$option);
		return $res;
    }
	
    /**
     * 注册可视化分析
     * @access public 
     * @return array
     */
    public function visualization(){
        // 限定接收参数
		$param = Request::instance()->only($this->field);
		$res = $this->logic->visualization($param);
		return $res;
    }
	
    /**
     * 注册时光轴
     * @access public 
     * @return array
     */
    public function timeline($id){
        // 限定接收参数
		$param = Request::instance()->only('id');
		$res = $this->logic->timeline($param);
		return $res; 
    }

    /**
     * [baseInfo 注册详情的基本信息接口]
     * @return [type] [description]
     */
    public function read($id){
        // 限定接收参数
        $res = $this->logic->getBaseInfo($id);
        return $res;
    }
	
    /**
     * 保存搜索条件
     * @return [type] [description]
     */
    public function savewhere(){
        $res = $this->logic->saveWhere();
        return $res;
    }
	
    /**
     * 删除搜索条件
     * @return [type] [description]
     */
    public function delsavewhere(){
        $res = $this->logic->delSaveWhere();
        return $res;
    }
	
    /**
     * 保存搜索条件
     * @return [type] [description]
     */
    public function savewherelist(){
        $res = $this->logic->saveWhereList();
        return $res;
    }

    public function devprocess(){
        $param = Request::instance()->only('id');
        $res = $this->logic->getDevProcess($param);
        return $res;
    }
    
}
