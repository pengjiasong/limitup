<?php
namespace app\common\service;
 
 /**
  * redis扩展类
  */
class RedisService{
    protected $handler = null;
    protected $options = [];
 
    public function __construct($options = []){   
        // options 根据config配置进行初始化设置
        $this->options = config('redis');
        //判断是否有扩展(如果你的apache没reids扩展就会抛出这个异常)
        if (!extension_loaded('redis')) {
            throw new \BadFunctionCallException('not support: redis');     
        }
        if (!empty($options)) {
            $this->options = array_merge($this->options, $options);
        }
        $func = $this->options['persistent'] ? 'pconnect' : 'connect';     //判断是否长连接
        $this->handler = new \Redis;
        $this->handler->$func($this->options['host'], $this->options['port'], $this->options['timeout']);
        // 设置密码
        if ('' != $this->options['password']) {
            $this->handler->auth($this->options['password']);
        }
 
        if (0 != $this->options['select']) {
            $this->handler->select($this->options['select']);
        }
    }

    public function exists($key){
        return $this->handler->exists($key);
    }
 
    /**
     * 写入字符串
     * @param string $key 键名
     * @param string $value 键值
     * @param int $exprie 过期时间 0:永不过期
     * @return bool
     */
    public function set($key, $value, $exprie = 0)
    {
        if ($exprie == 0) {
            $set = $this->handler->set($key, $value);
        } else {
            $set = $this->handler->setex($key, $exprie, $value);
        }
        return $set;
    }
 
    /**
     * 读取字符串
     * @param string $key 键值
     * @return mixed
     */
    public function get($key)
    {
        $fun = is_array($key) ? 'Mget' : 'get';
        return $this->handler->{$fun}($key);
    }
 
    /**
     * 获取值长度
     * @param string $key
     * @return int
     */
    public function lLen($key)
    {
        return $this->handler->lLen($key);
    }
 
    /**
     * 将一个或多个值插入到列表头部
     * @param $key
     * @param $value
     * @return int
     */
    public function LPush($key, $value, $value2 = null, $valueN = null)
    {
        return $this->handler->lPush($key, $value, $value2, $valueN);
    }
 
    /**
     * 移出并获取列表的第一个元素
     * @param string $key
     * @return string
     */
    public function lPop($key)
    {
        return $this->handler->lPop($key);
    }

    /**
     * [ping ping一下]
     * @return [type] [description]
     */
    public function ping(){
        return $this->handler->ping();
    }
}