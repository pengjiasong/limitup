<?php
namespace app\common\logic;

/**
 * 资讯接口
 */
class News{
    private $model;
    private $cate_pid=0;
    
    public function __construct(){
        $this->model = model('News');
    }

    /**
     * 获取新闻详情
     * @access public 
     * @param array $param = ['id'] 参数数组 
     * @return array
     */
	public function getNewsinfo($param) {
		$res = [];
		$code = 200;
		if(empty($param['aid'])){
			$code = 401;
			return getRes($res, $code);
		}
		$map['where']['id'] = $art_id = $param['aid'];
		$newsinfo = $this->getNewsbyid($map);
		if($newsinfo){
			$sqlmap['where']['id'] = $newsinfo['author_id'];
			$authorinfo = $this->getNewsauthor($sqlmap);
			$sqlmaps['where']['id'] = $newsinfo['cate_id'];
			$categoryinfo = $this->getNewscategoryName($sqlmaps);
			if(substr($newsinfo['pic_title'] , 0 , 2) == "//"){
				$newsinfo['pic_title'] = "https:".$newsinfo['pic_title'];
			}
			$newsinfo['content'] = stripslashes(htmlspecialchars_decode($newsinfo['content']));
			$newsinfo['article_href'] = 'https://news.drugeyes.com/archive/'.$param['aid'];
			$newsinfo['create_time'] = date('Y-m-d H:i:s',$newsinfo['create_time']);

			unset($param['aid']);
			$param['author_id'] = $newsinfo['author_id'];
			if($param['author_id']){
				$otherNews = $this->getOtherNews($param);
			}else{
				$otherNews = [];
			}
			$authorinfo['auth_name'] = $authorinfo?$authorinfo['auth_name']:"";
			$res['newsinfo'] = $newsinfo+$authorinfo+$categoryinfo;
			$res['otherNews'] = $otherNews?$otherNews['res']:[];
			//查看是否收藏
			$tokenUser = config('tokenUser')?config('tokenUser'):$param;

			if(!isset($tokenUser['uid'])){
				$code = 11015;
				return getRes($res, $code);
			}
			$mapsql['where'] = array(
				'member_uid'=>$tokenUser['uid'],
				'art_id'=>$art_id,
				);
			//判断是否已收藏过
			$resIsfav = $this->getFavnews($mapsql);

			$res['newsinfo']['is_fav'] = $resIsfav?1:0;
			//判断是否已点赞并且展示点赞数(2018年12月5日)
			$mapPraise['where'] = array(
				'aid'=>$art_id
			);
			$mapPraise['table'] = 'news_praise';
			$mapPraise['connection'] = 'newnews';
			$resPraiseCount = $this->model->counts($mapPraise);
			// print_r($mapPraise);exit;
			$res['newsinfo']['praise_count'] = $resPraiseCount?$resPraiseCount:0;

			$mapPraise['where']['uid'] = $tokenUser['uid'];
			$resIsPraise = $this->model->getOne($mapPraise);
			$res['newsinfo']['is_praise'] = $resIsPraise?1:0;

			if(!$res){
				$code = 404;
			}
		}else{
			$code = 404;
		}
		return getRes($res,$code);
	}

   
	
	/**
	 * 获取资讯详情
     * @param array $map 参数数组 
     * @return array
	 */
	private function getNewsbyid($map = []) {
		$map['table'] = 'news_article';
		$map['field'] = 'title,description,content,pic_title,cate_id,refer_url,author_id,id,keywords,create_time';
		$map['connection'] = 'newnews';
		$res = $this->model->getOne($map);
		return $res;
	}

	/**
	 * 获取资讯作者
     * @param array $map 参数数组 
     * @return array
	 */
	private function getNewsauthor($map = []) {
		$map['table'] = 'news_auth';
		$map['field'] = 'name as auth_name';
		$map['connection'] = 'newnews';
		$res = $this->model->getOne($map);
		return $res;
	}

	/**
	 * 获取资讯分类
     * @param array $map 参数数组 
     * @return array
	 */
	private function getNewscategoryName($map = []) {
		$map['table'] = 'news_article_category';
		$map['field'] = 'name as cate_name';
		$map['connection'] = 'newnews';
		$res = $this->model->getOne($map);
		return $res;
	}

	/**
     * 取得资讯列表二次筛选选项和列表结果内容
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getList($param){
		// 组合条件
		$code = 200;
		$result = [];
		if(isset($param['limits'])){
			$mapsql['limit'] = '0,'.$param['limits'];
		}
		if(isset($param['searchwords'])){
			$mapsql['where']['title'] = array('like',"%".$param['searchwords']."%");
		}
		if(isset($param['cate_id'])&&$param['cate_id']!=0&&$param['cate_id']!=""){
			$mapsql['where']['cate_id'] = $param['cate_id'];
		}
		$mapsql['join'] = [
			['news_article_category c','news_article.cate_id=c.id','LEFT'],
			['news_auth a','news_article.author_id=a.id','LEFT']
		];
		$res = $this->getNewssearch($mapsql);
		//合并广告
		if(isset($res['newsLists'])&&(count($res['newsLists'])>=1)&&!isset($res['categoryLists'])){
			foreach ($res['newsLists'] as $k => $v) {
				$res['newsLists'][$k]['is_ad'] = 0;
				$res['newsLists'][$k]['keywords'] = $v['keywords']?$v['keywords']:'';
				$res['newsLists'][$k]['refer_url'] = $v['refer_url']?$v['refer_url']:'';
				$res['newsLists'][$k]['pic_title'] = $v['pic_title']?$v['pic_title']:'';
			}
		}
		if(!isset($param['page'])){
			$param['page'] = 1;
		}
		if(isset($res['newsLists'])&&$res['newsLists']&&$param['page']==1&&!isset($res['categoryLists'])){
			//首页广告展示
			$wheres['yz_app_adp.id'] = 3;
			$wheres['yz_app_adp.status'] = 1;
			$wheres['yz_app_ad.status'] = 1;
			$wheres['yz_app_ad.start_time'] = array('elt',time());
			$wheres['yz_app_ad.end_time'] =  array('egt',time());
			$map['where'] = $wheres;
			$map['join'] = [
					['yz_app_adp','yz_app_ad.adp_id=yz_app_adp.id']
				];
			$adList = $this->getAdLists($map);

			$res['adList'] = $adList?$adList['res']:[];

			if($res['adList']&&count($res['adList'])>=1){
				$list = $res['newsLists'];
				foreach ($res['adList'] as $k => $v) {
					$res['adv'][0]['ioscontent'] = 'https://db.drugeyes.com'.$v['ioscontent'];
					$res['adv'][0]['androidcontent'] = 'https://db.drugeyes.com'.$v['androidcontent'];
					$res['adv'][0]['is_ad'] = 1;
					$res['adv'][0]['adtitle'] = $v['adtitle'];
					$res['adv'][0]['link'] = $v['link'];
					$res['adv'][0]['linktype'] = $v['linktype'];
					$res['adv'][0]['arid'] = $v['arid'];
					if($k==0){
						$count_adv = $v['place_id'];
					}else{
						$count_adv = $v['place_id']+1;
					}
					$list = $this->wpjam_array_push($list,$res['adv'],$count_adv);
				}
				$result['res'] = $list;
			}
		}elseif(isset($res['newsLists'])&&$res['newsLists']&&$param['page']!=1&&!isset($res['categoryLists'])){
			//首页的翻页
			$result['res'] = $res['newsLists'];
		}elseif(isset($res['newsLists'])&&$res['newsLists']&&isset($res['categoryLists'])){
			//搜索
			$result['res'] = $res;
			unset($result['res']['count']);
			unset($result['res']['page']);
		}else{
			$code = 404;
		}
		// print_r($res);exit;
		$result['count'] = isset($res['count'])?$res['count']:0;
		$result['page'] = isset($res['page'])?$res['page']:1;
		return getRes($result,$code);
	}

	//在数组之前增加元素
	public function wpjam_array_push($array, $data=null, $key=false){
		$data  = (array)$data;
		$offset  = ($key===false)?false:array_search($key, array_keys($array));
		$offset  = ($offset)?$offset:false;
		if($offset){
			return array_merge(
		  		array_slice($array, 0, $offset),
		  		$data,
		  		array_slice($array, $offset)
			);
		}else{  // 没指定 $key 或者找不到，就不加了
			// return array_merge($array, $data);
			return $array;
		}
	}

	/**
     * 广告展示
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getAdList(){
		$banner = 1;
		$news_banner = 5;
		$code = 200;
		//广告展示
		//1为首页banner,5为资讯首页banner
		$wheres['yz_app_adp.id'] = ['in',$news_banner.",".$banner];
		$wheres['yz_app_adp.status'] = 1;
		$wheres['yz_app_ad.status'] = 1;
		$wheres['yz_app_ad.start_time'] = array('elt',time());
		$wheres['yz_app_ad.end_time'] =  array('egt',time());
		$map['where'] = $wheres;
		$map['join'] = [
				['yz_app_adp','yz_app_ad.adp_id=yz_app_adp.id']
			];
		$adList = $this->getAdLists($map);
		$res['adList'] = $adList?$adList['res']:[];

		if($res['adList']){
			foreach ($res['adList'] as $k => $v) {
				$res['adList'][$k]['ioscontent'] = 'https://db.drugeyes.com'.$v['ioscontent'];
				$res['adList'][$k]['androidcontent'] = 'https://db.drugeyes.com'.$v['androidcontent'];
				$arr[$v['ac_id']][$k] = $res['adList'][$k];
			}
		}
		
		//看着大家都下班了。我也想走了。算了 先这样。日后优化
		//日后优化开头
		foreach ($arr as $k => $v) {
			if($k==$banner){
				$new_arr['bannerAd'] = $v;
			}elseif($k==$news_banner){
				$new_arr['newsAd'] = $v;
			}
		}
		if(isset($new_arr['bannerAd'])&&count($new_arr['bannerAd'])>=1){
			foreach ($new_arr['bannerAd'] as $k => $v) {
				$new_arrs['bannerAd'][] = $v;
			}
		}else{
			$new_arrs['bannerAd'] = [];
		}
		if(isset($new_arr['newsAd'])&&count($new_arr['newsAd'])>=1){
			foreach ($new_arr['newsAd'] as $k => $v) {
			$new_arrs['newsAd'][] = $v;
		}
		}else{
			$new_arrs['newsAd'] = [];
		}
		// print_r($new_arrs);exit;
		//日后优化结尾
		return getRes($new_arrs,$code);

	}

	/**
	 * 获取广告
     * @param array $map 参数数组 
     * @return array
	 */
	private function getAdLists($map = []) {
		$map['table'] = 'yz_app_ad';
		$map['field'] = 'yz_app_ad.id as adid,yz_app_ad.title as adtitle,yz_app_ad.link,yz_app_ad.ioscontent,yz_app_ad.androidcontent,yz_app_ad.linktype,yz_app_ad.article_id AS arid,yz_app_adp.id as ac_id,yz_app_ad.place_id,yz_app_ad.type';
		$res = $this->model->getAll($map);
		return $res;
	}

	/**
     * 获取新闻列表
     */
	private function getNewsLists($map = []){
		$map['table'] = 'news_article';
		if(!isset($map['field'])){
			$map['field'] = 'news_article.title,news_article.description,news_article.pic_title,news_article.cate_id,news_article.refer_url,news_article.author_id,news_article.id,news_article.keywords,a.name as a_name,c.name as c_name';
		}
		$map['connection'] = 'newnews';

		$return = $this->model->getList($map);

		return $return;
	}

	/**
     * 根据新闻关键字获取
     */
	private function getNewssearch($map = []){

		$maps['table'] = $map['table'] ='news_article';
		$maps['connection'] =$map['connection'] = 'newnews';
		if(isset($map['where']['title'])){
			$maps['where']['pid'] = 26;
			$maps['where']['c.status'] = 1;
			$maps['where']['c.is_delete'] = 0;
			$maps['field'] = 'news_article.cate_id,count(*) as all_count,c.name';
			$maps['join'] = [
	    			['news_article_category c','news_article.cate_id=c.id']
				];
			$maps['limit'] = 15;
			$maps['where']['title'] = $map['where']['title'];

			//查询所有分类
			$maps['group'] = 'cate_id';
			
			$titles = $this->model->getList($maps);
			$res['categoryLists'] = $titles?$titles['res']:[];
		}
		$map['order'] = ['id'=>'desc'];
		$map['field'] = 'news_article.title,news_article.description,news_article.pic_title,news_article.cate_id,news_article.refer_url,news_article.author_id,news_article.id,news_article.keywords,news_article.create_time';
		$lists = $this->model->getList($map);
		
		$res['newsLists'] = $lists?$lists['res']:[];
		foreach ($res['newsLists'] as $k => $v) {
			if(substr($v['pic_title'] , 0 , 2) == "//"){
				$res['newsLists'][$k]['pic_title'] = "https:".$v['pic_title'];
			}
			$res['newsLists'][$k]['create_time'] = date('Y-m-d',$v['create_time']);
		}
		$res['count'] = isset($lists['count'])?$lists['count']:0;
		$res['page'] = isset($lists['page'])?$lists['page']:1;
		return $res;
	}

	/**
	 * 获取资讯分类
     * @return array
	 */
	private function getNewscategoryLists() {
		$map['table'] = 'news_article_category';
		$map['field'] = 'name as cate_name,id as cid';
		$map['where']['status'] = 1;
		$map['where']['is_delete'] = 0;
		$map['where']['pid'] = 26;
		$map['order'] = ['sort'=>'desc'];
		$map['connection'] = 'newnews';
		$res = $this->model->getAll($map);
		return $res;
	}

	/**
     * 获取热搜
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getHotsearchLists(){
		$code = 200;

		$wheres['status'] = 1;
		$wheres['sort'] = array('egt',1);
		$map['where'] = $wheres;
		$map['order'] = ['sort'=>'desc'];

		$HotList = $this->getHotLists($map);

		$res['hotList'] = $HotList?$HotList['res']:[];


		return getRes($res,$code);

	}

	/**
     * 获取分类
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getCategoryList(){
		$code = 200;
		//广告展示
		$categorylist = $this->getNewscategoryLists();

		if(isset($categorylist['res'])&&$categorylist['res']){
			$res['categoryList'] = array_merge(array(array('cate_name'=>'头条','cid'=>0)),$categorylist['res']);
		}else{
			$code = 404;
			$res = [];
		}

		return getRes($res,$code);
	}
	
	/**
     * 获取
     */
	private function getHotLists($map = []){
		$map['table'] = 'news_hotsearch';
		$map['field'] = 'searchword,id as hid';
		$map['connection'] = 'newnews';

		$return = $this->model->getAll($map);

		return $return;
	}

	/**
     * 获取相关新闻n
     * @access public 
     * @param array $param = [''] 参数数组 
     * @return array
     */
	public function getOtherNews($param) {
		$res = [];

		if(empty($param['author_id'])){
			$code = 401;
			return getRes($res, $code);
		}
		if(!isset($param['limits'])){
			$map['limit'] = '0,5';
		}else{
			$map['limit'] = '0,'.$param['limits'];
		}
		$map['order'] = ['id'=>'desc'];
		$map['field'] = 'title,id,pic_title,create_time,refer_url';
		$map['where']['author_id'] = $param['author_id'];
		$newsinfo = $this->getNewsLists($map);
		if($newsinfo){
			foreach ($newsinfo['res'] as $k => $v) {
				if(substr($v['pic_title'] , 0 , 2) == "//"){
					$newsinfo['res'][$k]['pic_title'] = "https:".$v['pic_title'];
					$newsinfo['res'][$k]['create_time'] = date('Y-m-d',$v['create_time']);
				}
			}
		}else{
			$newsinfo['res'] = [];
		}

		return $newsinfo;
	}

	/**
     * 评论展示
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getCommentList($param){
		// print_r($param);exit;
		$res = [];
		$code = 200;
		if(empty($param['aid'])){
			$code = 401;
			return getRes($res, $code);
		}
		$tokenUser = config('tokenUser');
		if(!$tokenUser){
			$code = 11015;
			return getRes($res, $code);
		}
		$wheres['news_comment.art_id']=$param['aid'];
		//是评论还是评论回复
		if(isset($param['comment_pid'])){
			// $wheres = array_merge($wheres,['news_comment.pid|news_comment.id'=>['eq',$param['comment_pid']]]);
			$wheres['news_comment.cate_pid']=$param['comment_pid'];
		}else{
			$wheres['news_comment.pid']=0;
		}

		if(!isset($param['class'])){
			$wheres['news_comment.class']=1;
		}
		$wheres['news_comment.status'] = 1;
		$map['where'] = $wheres;
		
		$map['join'] = [
				['drugeyes.drugeyes_member_intro i','news_comment.uid=i.uid','LEFT']
			];
		$map['uid']=$tokenUser['uid'];
		$res = $this->findCommentList($map);
		if($res['count']==0&&empty($res['commentList'])){
			$code=404;
		}

		return getRes($res,$code);

	}
	
	/**
     * 获取评论列表
     */
	private function findCommentList($map = []){

		$map['table'] ='news_comment';
		$map['connection'] = 'newnews';
		
		$map['order'] = ['news_comment.id'=>'desc'];
		$map['field'] = 'news_comment.uid,(select count(news_praise_uid.id) from newnews.news_praise_uid where uid='.$map['uid'].' and comment_id=news_comment.id) as is_praise,news_comment.id,i.pic_url,news_comment.username,news_comment.content,news_comment.addtime,news_comment.pid,news_comment.praise_num';

		$lists = $this->model->getList($map);

		$res['commentList'] = $lists?$lists['res']:[];

		foreach ($res['commentList'] as $k => $v) {
			//处理头像
			$head_img = json_decode($v['pic_url'],true);
			$res['commentList'][$k]['head_img'] = $head_img?"https://www.drugeyes.com".$head_img['serverpath_48']:'';
			unset($res['commentList'][$k]['pic_url']);
			//处理时间
			$cut_time = time()-$v['addtime'];
			if($cut_time <= 3600*12 && $cut_time >= 3600*1){
				$hors = $cut_time/3600;
				$res['commentList'][$k]['addtime'] = (int)$hors.'小时前';
			}elseif($cut_time > 0 && $cut_time <= 3600*1){
				$mins = ($cut_time)/60;
				$res['commentList'][$k]['addtime'] = (int)$mins.'分钟前';
			}else{
				$res['commentList'][$k]['addtime'] = date('Y-m-d H:i:s',$v['addtime']);
			}
			//处理名字
			$res['commentList'][$k]['nickname'] = $this->substr_cut($v['username']);
			unset($res['commentList'][$k]['username']);
			if(isset($map['where']['news_comment.cate_pid'])&&$v['pid']==0){
				$res['commentAll'][] = $res['commentList'][$k];
				unset($res['commentList'][$k]);
			}elseif(!isset($map['where']['news_comment.cate_pid'])&&$v['pid']==0){
				$mapsql['where']['cate_pid'] = $v['id'];
				$res['commentList'][$k]['count_comment'] = $this->getCommentcount($mapsql);
			}
		}
		$res['count'] = isset($lists['count'])?$lists['count']:0;
		$res['page'] = isset($lists['page'])?$lists['page']:1;
		return $res;
	}

	
	private function substr_cut($user_name){
        //获取字符串长度
        $strlen = mb_strlen($user_name, 'utf-8');
        //如果字符创长度小于2，不做任何处理
        if($strlen<2){
        	return $user_name;
        }else{
            //mb_substr — 获取字符串的部分
        	$firstStr = mb_substr($user_name, 0, 1, 'utf-8');
        	$lastStr = mb_substr($user_name, -1, 1, 'utf-8');
        	//str_repeat — 重复一个字符串
        	return $strlen == 2 ? $firstStr . str_repeat('*', mb_strlen($user_name, 'utf-8') - 1) : $firstStr . str_repeat("*", $strlen - 2) . $lastStr;
        }
    }

    /**
     * 获取子回复
     */
	private function getCommentcount($map = []){
		$map['table'] = 'news_comment';
		$map['connection'] = 'newnews';
		// print_r($map);exit;
		$return = $this->model->counts($map);

		return $return;
	}

	/**
     * 评论文章
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function commentArticle($param){
		// print_r($param);exit;
		$res = [];
		$code = 200;
		if(empty($param['aid'])){
			$code = 401;
			return getRes($res, $code);
		}
		//获取评论
		if(empty($param['content'])){
			$code = 401;
			return getRes($res, $code);
		}
		$tokenUser = config('tokenUser');

		$data = array(
			'username'=>$tokenUser['username'],
			'uid'	  =>$tokenUser['uid'],
			'content' =>$param['content'],
			'art_id' =>$param['aid'],
			'addtime' =>time(),
			'class' =>1
			);
		if(isset($param['comment_pid'])){
			$data['pid'] = $param['comment_pid'];
			$this->getCommentPid($data['pid']);
			$data['cate_pid'] = $this->cate_pid;
		}
		$map['data'] = $data;
		$res = $this->addComment($map);
		if($res){
			//新增积分
			$params['forced']=1;
			$params['accesstoken']=$tokenUser['access_token'];
			$params['client']='iOS';
			$params['motion']='appcomment';
			$resScore = model('apiv1/Score','logic')->setSharescore($params);
			if($resScore==200){
				$result['isadd_point'] = 1;
			}else{
				$result['isadd_point'] = 0;
			}
		}else{
			$result['isadd_point'] = 0;
		}

		return getRes($result,$code);

	}

	/**
     * 查看最顶级评论
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	private function getCommentPid($pid){
		$sqlCpid['field'] = 'pid';
		//查询他的pid
		$sqlCpid['where'] = array(
			'id'=>$pid,
			);
		$sqlCpid['table'] = 'news_comment';
		$sqlCpid['connection'] = 'newnews';
		$resCpid = $this->model->getOne($sqlCpid);
		if($resCpid['pid']==0){
			$this->cate_pid=$pid;
		}else{
			$this->getCommentPid($resCpid['pid']);
		}
	}

	/**
     * 添加评论
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	private function addComment($map){
		$map['table'] = 'news_comment';
		$map['connection'] = 'newnews';

		$return = $this->model->insert($map);

		return $return;
	}


	//获取评论
	/**
     * 评论展示
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	public function getCommentLists($param){

		$res = [];
		$code = 200;
		if(empty($param['aid'])){
			$code = 401;
			return getRes($res, $code);
		}
		if(empty($param['comment_pid'])){
			$code = 401;
			return getRes($res, $code);
		}
		$tokenUser = config('tokenUser');
		if(!$tokenUser){
			$code = 11015;
			return getRes($res, $code);
		}
		$wheres['news_comment.cate_pid'] = $param['comment_pid'];
		$map['order'] = ['addtime'=>'desc'];
		$wheres['news_comment.art_id']=$param['aid'];

		if(!isset($param['class'])){
			$wheres['news_comment.class']=1;
		}
		$wheres['news_comment.status'] = 1;
		$map['where'] = $wheres;
		
		$map['join'] = $sqlmap['join'] = [
				['drugeyes.drugeyes_member_intro i','news_comment.uid=i.uid','LEFT']
			];
		$map['uid'] = $sqlmap['uid'] = $tokenUser['uid'];
		$res = $this->findCommentLists($map);
		// print_r($res);exit;
		$sqlmap['where']['news_comment.pid'] = 0;
		$sqlmap['where']['news_comment.id'] = $param['comment_pid'];
		$commentLists = $this->findCommentList($sqlmap);
		if($commentLists['commentList']){
			$comments_ = $commentLists['commentList'][0];
			$res['commentLists'] = array(
				'content'	=>$comments_['content'],
				'head_img'	=>$comments_['head_img'],
				'nickname'	=>$comments_['nickname'],
				'addtime'	=>$comments_['addtime'],
				'praise_num'=>$comments_['praise_num'],
				'is_praise'	=>$comments_['is_praise'],
			);
		}

// print_r($commentLists);exit;
		return getRes($res,$code);

	}

	/**
     * 获取用户信息
     */
	private function getUserinfo($map = []){
		$map['table'] = 'sys_app_access_token';
		$map['connection'] = 'newdbbase';

		$return = $this->model->getOne($map);

		return $return;
	}

	/**
     * 获取单条
     */
	private function getPidComment($map){
		$map['table'] = 'news_comment';
		$map['connection'] = 'newnews';
		if(isset($map['field'])){
			$map['field'] = 'username,cotent';
		}
		$return = $this->model->getOne($map);

		return $return;
	}

	/**
     * 获取二级评论列表
     */
	private function findCommentLists($map = []){

		$map['table'] ='news_comment';
		$map['connection'] = 'newnews';

		$map['field'] = 'news_comment.id,(select count(news_praise_uid.id) from newnews.news_praise_uid where uid='.$map['uid'].' and comment_id=news_comment.id) as is_praise,i.pic_url,news_comment.username,news_comment.content,news_comment.addtime,news_comment.pid,news_comment.praise_num';

		$lists = $this->model->getList($map);
		// print_r($lists);exit;
		$res['commentList'] = $lists?$lists['res']:[];

		foreach ($res['commentList'] as $k => $v) {
			//处理头像
			$head_img = json_decode($v['pic_url'],true);
			$res['commentList'][$k]['head_img'] = $head_img?"https://www.drugeyes.com".$head_img['serverpath_48']:'';
			unset($res['commentList'][$k]['pic_url']);
			//处理时间
			$cut_time = time()-$v['addtime'];
			if($cut_time <= 3600*12 && $cut_time >= 3600*1){
				$hors = $cut_time/3600;
				$res['commentList'][$k]['addtime'] = (int)$hors.'小时前';
			}elseif($cut_time > 0 && $cut_time <= 3600*1){
				$mins = ($cut_time)/60;
				$res['commentList'][$k]['addtime'] = (int)$mins.'分钟前';
			}else{
				$res['commentList'][$k]['addtime'] = date('Y-m-d H:i:s',$v['addtime']);
			}
			//处理名字
			$res['commentList'][$k]['nickname'] = $this->substr_cut($v['username']);
			unset($res['commentList'][$k]['username']);
			if($v['pid']!=0){
				$aplylists =$this->getCommentAply($v['pid']);
				$res['commentList'][$k]['aply_nickname'] = $this->substr_cut($aplylists['username']);
				$res['commentList'][$k]['aply_content'] = $aplylists['content'];
			}else{
				$res['commentList'][$k]['aply_nickname'] = '';
				$res['commentList'][$k]['aply_content'] = '';
			}
			//判断是不是直接回复
			if($map['where']['news_comment.cate_pid']==$v['pid']){
				$res['commentList'][$k]['is_master'] = 1;
			}else{
				$res['commentList'][$k]['is_master'] = 0;
			}
		}
		$res['countList'] = isset($lists['count'])?$lists['count']:0;
		return $res;
	}

	public function getCommentAply($pid){
		$map['where']['id'] = $pid;
		//根据pid获取上一条的用户和用户回复
		$res = $this->getPidComment($map);
		return $res;
	}

	public function getCommentAplys($map){
		$res = $this->getPidComment($map);
		return $res;
	}

	/**
     * 获取单条
     */
	private function findCommentPraise($map){
		$map['table'] = 'news_praise_uid';
		$map['connection'] = 'newnews';
		if(isset($map['field'])){
			$map['field'] = 'id';
		}
		$return = $this->model->getOne($map);

		return $return;
	}

	//点赞
	public function praiseComment($param){
		$res = [];
		$code = 200;

		if(empty($param['comment_pid'])){
			$code = 401;
			return getRes([], $code);
		}

		//判断是否点过赞
		$userinfo = config('tokenUser');
		if(!$userinfo){
			$code = 11015;
			return getRes($res, $code);
		}
		$mapsql['where'] = array(
			'uid'=>$userinfo['uid'],
			'comment_id'=>$param['comment_pid'],
			);
		$res = $this->findCommentPraise($mapsql);

		if($res){
			$code = 12001;
			return getRes([], $code);
		}else{
			$result = $this->getCommentAply($param['comment_pid']);

			$praise_num = $result['praise_num']+1;
			
			$data = array(
				'praise_num'=>$praise_num,
				);

			$map['data'] = $data;
			$map['where']['id'] = $param['comment_pid'];
			$res = $this->updateComment($map);
			if($res){
				$data = array(
					'comment_id'=>$param['comment_pid'],
					'uid'=>$userinfo['uid'],
					'addtime'=>time()
				);
				$maps['data'] = $data;
				$res = $this->addPraise($maps);
				//新增积分
				$params['forced']=1;
				$params['accesstoken']=$param['accesstoken'];
				$params['client']='iOS';
				$params['motion']='apppraise';
				$resScore = model('apiv1/Score','logic')->setSharescore($params);
				if($resScore==200){
					$resultAll['isadd_point'] = 1;
				}else{
					$resultAll['isadd_point'] = 0;
				}
			}else{
				$resultAll['isadd_point'] = 0;
			}
			$resultAll['praise_num'] = $praise_num;
			return getRes($resultAll,$code);
		}
	}

	/**
     * 添加评论
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	private function updateComment($map){
		$map['table'] = 'news_comment';
		$map['connection'] = 'newnews';

		$return = $this->model->updateData($map);

		return $return;
	}

	/**
     * 添加点赞人
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	private function addPraise($map){
		$map['table'] = 'news_praise_uid';
		$map['connection'] = 'newnews';

		$return = $this->model->insert($map);

		return $return;
	}

	//收藏文章
	public function setFavnews($param){
		$res = [];
		$code = 200;
		if(empty($param['art_id'])){
			$code = 401;
			return getRes($res, $code);
		}
		//获取用户基本信息
		$tokenUser = config('tokenUser')?config('tokenUser'):$param;
		if(!$tokenUser){
			$code = 11015;
			return getRes($res, $code);
		}
		$mapsql['where'] = array(
			'member_uid'=>$tokenUser['uid'],
			'art_id'=>$param['art_id'],
			);
		//判断是否已收藏过
		$res = $this->getFavnews($mapsql);
		if($res){
			$code = 12002;
			return getRes([], $code);
		}else{
			$sqlmap['where']['id'] = $param['art_id'];
			$result = $this->getNewsbyid($sqlmap);
			if(!$result){
				$code = 404;
				return getRes([], $code);
			}
			$data = array(
				'member_uid'=>$tokenUser['uid'],
				'title'=>$result['title'],
				'art_id'=>$param['art_id'],
				'addtime'=>time()
				);

			$maps['data'] = $data;
			$res = $this->addFavnews($maps);
			if($res){
				$code = 200;
				$resData = ['is_fav'=>1,'favid'=>$res];
			}else{
				$code = 400;
				$resData = ['is_fav'=>0,'favid'=>0];
			}
			return getRes($resData,$code);
		}
	}

	/**
     * 获取收藏资讯
     */
	private function getFavnews($map = []){
		$map['table'] = 'news_fav_news';
		$map['connection'] = 'newnews';

		$return = $this->model->getOne($map);

		return $return;
	}
	
	/**
     * 收藏资讯
     * @access public 
     * @param array $param 参数数组
     * @return array
     */
	private function addFavnews($map){
		$map['table'] = 'news_fav_news';
		$map['connection'] = 'newnews';

		$return = $this->model->insert($map);

		return $return;
	}

	//12.5新增需求。因为此方法写了太久远了,表和字段不同,所以提出来写一份
	public function praiseArticle($param){
		$res = [];
		$code = 200;

		if(empty($param['aid'])){
			$code = 401;
			return getRes([], $code);
		}
		//判断是否点过赞
		$userinfo = config('tokenUser');

		$mapPraise['table'] = 'news_praise';
		$mapPraise['connection'] = 'newnews';
		$mapPraise['where'] = array(
			'uid'=>$userinfo['uid'],
			'aid'=>$param['aid'],
			);
		$res = $this->model->getOne($mapPraise);

		if($res){
			$code = 12001;
			return getRes([], $code);
		}else{
			$data = array(
				'aid'=>$param['aid'],
				'uid'=>$userinfo['uid'],
				'class'=>1
			);
			$addPraise['table'] = 'news_praise';
			$addPraise['connection'] = 'newnews';
			$addPraise['data'] = $data;
			$res = $this->model->insert($addPraise);
			//新增积分
			$params['forced']=1;
			$params['accesstoken']=$param['accesstoken'];
			$params['client']='iOS';
			$params['motion']='apppraise';
			$resScore = model('apiv1/Score','logic')->setSharescore($params);
			if($resScore==200){
				$resultAll['isadd_point'] = 1;
			}else{
				$resultAll['isadd_point'] = 0;
			}
			return getRes($resultAll,$code);
		}
	}
}