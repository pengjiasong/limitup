<?php
// +----------------------------------------------------------------------
// 封装ES-SQL为TP5操作类写法
// +----------------------------------------------------------------------
// +----------------------------------------------------------------------
// | Copyright (c) 2018 
// +----------------------------------------------------------------------
namespace app\common\service;
use Elasticsearch\ClientBuilder;

use PDO;

class Elasticsearch {
	public $client;
    // 数据库Connection对象实例
    private $connection;
    // 当前模型类名称
    private $model;
    // 当前数据表名称（含前缀）
    private $table = '';
    // 当前数据表名称（不含前缀）
    private $name = '';
    // 查询参数
    private $options = [];
    // 参数绑定
    private $bind = [];
	//sql
	private $sql = '';
	//total查询总数
	public $total = 0;
	//total查询总数
	// public $total = 0;
	//polymerization 聚合返回字段标识
	private $polymerization = '';
    // 初始化tableName映射表
    private $tbname = [];

    // 数据库表达式
    private $exp = ['eq' => '=', 'neq' => '<>', 'gt' => '>', 'egt' => '>=', 'lt' => '<', 'elt' => '<=', 'notlike' => 'NOT LIKE', 'not like' => 'NOT LIKE', 'like' => 'LIKE', 'in' => 'IN', 'exp' => 'EXP', 'notin' => 'NOT IN', 'not in' => 'NOT IN', 'between' => 'BETWEEN', 'not between' => 'NOT BETWEEN', 'notbetween' => 'NOT BETWEEN', 'exists' => 'EXISTS', 'notexists' => 'NOT EXISTS', 'not exists' => 'NOT EXISTS', 'null' => 'NULL', 'notnull' => 'NOT NULL', 'not null' => 'NOT NULL', '> time' => '> TIME', '< time' => '< TIME', '>= time' => '>= TIME', '<= time' => '<= TIME', 'between time' => 'BETWEEN TIME', 'not between time' => 'NOT BETWEEN TIME', 'notbetween time' => 'NOT BETWEEN TIME'];

    // SQL表达式
    private $selectSql    = 'SELECT%DISTINCT% %FIELD% FROM %TABLE%%FORCE%%JOIN%%WHERE%%GROUP%%HAVING%%ORDER%%LIMIT% %UNION%%LOCK%%COMMENT%';
    private $insertSql    = '%INSERT% INTO %TABLE% (%FIELD%) VALUES (%DATA%) %COMMENT%';
    private $insertAllSql = '%INSERT% INTO %TABLE% (%FIELD%) %DATA% %COMMENT%';
    private $updateSql    = 'UPDATE %TABLE% SET %SET% %JOIN% %WHERE% %ORDER%%LIMIT% %LOCK%%COMMENT%';
    private $deleteSql    = 'DELETE FROM %TABLE% %USING% %JOIN% %WHERE% %ORDER%%LIMIT% %LOCK%%COMMENT%';

    /**
     * 构造函数
     * @access public
     * @param Connection $connection 数据库对象实例
     * @param string     $model      模型名
     */
    public function __construct()
    {
		$hosts = config('ES')['hosts'];
		$this->client = ClientBuilder::create()           // Instantiate a new ClientBuilder
                    ->setHosts($hosts)      // Set the hosts
                    ->build();              // Build the client object
        // 初始化tableName数组
        $this->tbname = config('ES.esname');
		return $this;
    }


    /**
     * 获取当前的索引
     * @access public
     * @return string
     */
    public function getIndex()
    {
        return $this->index;
    }


    /**
     * 指定默认数据表名（含前缀）
     * @access public
     * @param string $table 表名
     * @return $this
     */
    public function setTable($table)
    {
        $table = isset($this->tbname[$table])?$this->tbname[$table]:$table;
        $this->table = $table;
        return $this;
    }

    /**
     * 得到当前或者指定名称的数据表
     * @access public
     * @param string $name
     * @return string
     */
    public function getTable($name = '')
    {
        if ($name || empty($this->table)) {
            $name      = $name ?: $this->name;
            if ($name) {
                $tableName = Loader::parseName($name);
            }
        } else {
            $tableName = $this->table;
        }
        return $tableName;
    }
	
    /**
     * 获取数据库的配置参数
     * @access private
     * @param string $config 配置名称
     * @return mixed
     */
    private function getConfig($config = '')
    {
        return $config ? $this->config[$config] : $this->config;
    }

    /**
     * 将SQL语句中的__TABLE_NAME__字符串替换成带前缀的表名（小写）
     * @access public
     * @param string $sql sql语句
     * @return string
     */
    public function parseSqlTable($sql)
    {
        if (false !== strpos($sql, '__')) {
            $prefix = $this->prefix;
            $sql    = preg_replace_callback("/__([A-Z0-9_-]+)__/sU", function ($match) use ($prefix) {
                return $prefix . strtolower($match[1]);
            }, $sql);
        }
        return $sql;
    }


    /**
     * 获取最近一次查询的sql语句
     * @access public
     * @return string
     */
    public function getLastSql($default = false)
    {
		if($default){
			return $this->sql($this->sql,1);
		}else{
			return $this->sql;
		}
    }


    /**
     * 得到某个字段的值
     * @access public
     * @param string $field   字段名
     * @param mixed  $default 默认值
     * @param bool   $force   强制转为数字类型
     * @return mixed
     */
    public function value($field, $default = null, $force = false)
    {
        $result = false;
        if (empty($this->options['fetch_sql']) && !empty($this->options['cache'])) {
            // 判断查询缓存
            $cache = $this->options['cache'];
            if (empty($this->options['table'])) {
                $this->options['table'] = $this->getTable();
            }
            $key    = is_string($cache['key']) ? $cache['key'] : md5($field . serialize($this->options) . serialize($this->bind));
            $result = Cache::get($key);
        }
        if (false === $result) {
            if (isset($this->options['field'])) {
                unset($this->options['field']);
            }
			//设置field、limit
            $this->field($field)->limit(1);
			// 分析查询表达式
			$options = $this->parseExpress();
			// 生成查询SQL
            $this->sql = $this->builderSelect($options);
			$res = $this->sql($this->sql);
			
			// print_r($res);
			$polymerization = empty($this->polymerization) ? $field : $this->polymerization;
			if(isset($res['aggregations'][$polymerization]['value'])){
				$result = $res['aggregations'][$polymerization]['value'];
			}else if(isset($res['hits']['hits'][0]['_source'][$polymerization])){
				$result = $res['hits']['hits'][0]['_source'][$polymerization];
			}else if(isset($res['aggregations'])){
				foreach($res['aggregations'] as $val){
					if(isset($val[$polymerization]['value_as_string'])){
						$result = $val[$polymerization]['value_as_string'];
						break;
					}
				}
			}
            if (isset($cache)) {
                // 缓存数据
                $this->cacheData($key, $result, $cache);
            }
        } else {
            // 清空查询条件
            $this->options = [];
        }
        return false !== $result ? $result : $default;
    }

    /**
     * 得到某个列的数组
     * @access public
     * @param string $field 字段名 多个字段用逗号分隔
     * @param string $key   索引
     * @return array
     */
    public function column($field, $key = '')
    {
        $result = false;
        if (empty($this->options['fetch_sql']) && !empty($this->options['cache'])) {
            // 判断查询缓存
            $cache = $this->options['cache'];
            if (empty($this->options['table'])) {
                $this->options['table'] = $this->getTable();
            }
            $guid   = is_string($cache['key']) ? $cache['key'] : md5($field . serialize($this->options) . serialize($this->bind));
            $result = Cache::get($guid);
        }
        if (false === $result) {
            if (isset($this->options['field'])) {
                unset($this->options['field']);
            }
            if (is_null($field)) {
                $field = '*';
            } elseif ($key && '*' != $field) {
                $field = $key . ',' . $field;
            }
            $pdo = $this->field($field)->getPdo();
            if (is_string($pdo)) {
                // 返回SQL语句
                return $pdo;
            }
            if (1 == $pdo->columnCount()) {
                $result = $pdo->fetchAll(PDO::FETCH_COLUMN);
            } else {
                $resultSet = $pdo->fetchAll(PDO::FETCH_ASSOC);
                if ($resultSet) {
                    $fields = array_keys($resultSet[0]);
                    $count  = count($fields);
                    $key1   = array_shift($fields);
                    $key2   = $fields ? array_shift($fields) : '';
                    $key    = $key ?: $key1;
                    if (strpos($key, '.')) {
                        list($alias, $key) = explode('.', $key);
                    }
                    foreach ($resultSet as $val) {
                        if ($count > 2) {
                            $result[$val[$key]] = $val;
                        } elseif (2 == $count) {
                            $result[$val[$key]] = $val[$key2];
                        } elseif (1 == $count) {
                            $result[$val[$key]] = $val[$key1];
                        }
                    }
                } else {
                    $result = [];
                }
            }
            if (isset($cache) && isset($guid)) {
                // 缓存数据
                $this->cacheData($guid, $result, $cache);
            }
        } else {
            // 清空查询条件
            $this->options = [];
        }
        return $result;
    }

    /**
     * COUNT查询
     * @access public
     * @param string $field 字段名
     * @return integer|string
     */
    public function count($field = '*')
    {
        if (isset($this->options['group'])) {
            // 支持GROUP
            $options = $this->getOptions();
            $subSql  = $this->options($options)->field('count(' . $field . ')')->bind($this->bind)->buildSql();
            return $this->table([$subSql => '_group_count_'])->value('COUNT(*) AS tp_count', 0, true);
        }
		$this->polymerization = 'tp_count';
        return $this->value('COUNT(' . $field . ') AS tp_count', 0, true);
    }

    /**
     * SUM查询
     * @access public
     * @param string $field 字段名
     * @return float|int
     */
    public function sum($field)
    {
		$this->polymerization = 'tp_sum';
        return $this->value('SUM(' . $field . ') AS tp_sum', 0, true);
    }

    /**
     * MIN查询
     * @access public
     * @param string $field 字段名
     * @return mixed
     */
    public function min($field)
    {
		$this->polymerization = 'tp_min';
        return $this->value('MIN(' . $field . ') AS tp_min', 0, true);
    }

    /**
     * MAX查询
     * @access public
     * @param string $field 字段名
     * @return mixed
     */
    public function max($field)
    {
		$this->polymerization = 'tp_max';
        return $this->value('MAX(' . $field . ') AS tp_max', 0, true);
    }

    /**
     * AVG查询
     * @access public
     * @param string $field 字段名
     * @return float|int
     */
    public function avg($field)
    {
		$this->polymerization = 'tp_avg';
        return $this->value('AVG(' . $field . ') AS tp_avg', 0, true);
    }

    /**
     * 设置记录的某个字段值
     * 支持使用数据库字段和方法
     * @access public
     * @param string|array $field 字段名
     * @param mixed        $value 字段值
     * @return integer
     */
    public function setField($field, $value = '')
    {
        if (is_array($field)) {
            $data = $field;
        } else {
            $data[$field] = $value;
        }
        return $this->update($data);
    }

    /**
     * 查询SQL组装 join
     * @access public
     * @param mixed  $join      关联的表名
     * @param mixed  $condition 条件
     * @param string $type      JOIN类型
     * @return $this
     */
    public function join($join, $condition = null, $type = 'INNER')
    {
        if (empty($condition)) {
            // 如果为组数，则循环调用join
            foreach ($join as $key => $value) {
                if (is_array($value) && 2 <= count($value)) {
                    $this->join($value[0], $value[1], isset($value[2]) ? $value[2] : $type);
                }
            }
        } else {
            $table = $this->getJoinTable($join);

            $this->options['join'][] = [$table, strtoupper($type), $condition];
        }
        return $this;
    }

    /**
     * 获取Join表名及别名 支持
     * ['prefix_table或者子查询'=>'alias'] 'prefix_table alias' 'table alias'
     * @access public
     * @param array|string $join
     * @return array|string
     */
    protected function getJoinTable($join, &$alias = null)
    {
        // 传入的表名为数组
        if (is_array($join)) {
            list($table, $alias) = each($join);
        } else {
            $join = trim($join);
            if (false !== strpos($join, '(')) {
                // 使用子查询
                $table = $join;
            } else {
                $prefix = $this->prefix;
                if (strpos($join, ' ')) {
                    // 使用别名
                    list($table, $alias) = explode(' ', $join);
                } else {
                    $table = $join;
                    if (false === strpos($join, '.') && 0 !== strpos($join, '__')) {
                        $alias = $join;
                    }
                }
                if ($prefix && false === strpos($table, '.') && 0 !== strpos($table, $prefix) && 0 !== strpos($table, '__')) {
                    $table = $this->getTable($table);
                }
            }
        }
        if (isset($alias)) {
            if (isset($this->options['alias'][$table])) {
                $table = $table . '@think' . uniqid();
            }
            $table = [$table => $alias];
            $this->alias($table);
        }
        return $table;
    }

    /**
     * 查询SQL组装 union
     * @access public
     * @param mixed   $union
     * @param boolean $all
     * @return $this
     */
    public function union($union, $all = false)
    {
        $this->options['union']['type'] = $all ? 'UNION ALL' : 'UNION';

        if (is_array($union)) {
            $this->options['union'] = array_merge($this->options['union'], $union);
        } else {
            $this->options['union'][] = $union;
        }
        return $this;
    }

    /**
     * 指定查询字段 支持字段排除和指定数据表
     * @access public
     * @param mixed   $field
     * @param boolean $except    是否排除
     * @param string  $tableName 数据表名
     * @param string  $prefix    字段前缀
     * @param string  $alias     别名前缀
     * @return $this
     */
    public function field($field, $except = false, $tableName = '', $prefix = '', $alias = '')
    {
        if (empty($field)) {
            return $this;
        }
        if (is_string($field)) {
            $field = array_map('trim', explode(',', $field));
        }
        if (true === $field) {
            // 获取全部字段
            $fields = $this->getTableInfo($tableName ?: (isset($this->options['table']) ? $this->options['table'] : ''), 'fields');
            $field  = $fields ?: ['*'];
        } elseif ($except) {
            // 字段排除
            $fields = $this->getTableInfo($tableName ?: (isset($this->options['table']) ? $this->options['table'] : ''), 'fields');
            $field  = $fields ? array_diff($fields, $field) : $field;
        }
        if ($tableName) {
            // 添加统一的前缀
            $prefix = $prefix ?: $tableName;
            foreach ($field as $key => $val) {
                if (is_numeric($key)) {
                    $val = $prefix . '.' . $val . ($alias ? ' AS ' . $alias . $val : '');
                }
                $field[$key] = $val;
            }
        }

        if (isset($this->options['field'])) {
            $field = array_merge($this->options['field'], $field);
        }
        $this->options['field'] = array_unique($field);
        return $this;
    }

    /**
     * 设置数据
     * @access public
     * @param mixed $field 字段名或者数据
     * @param mixed $value 字段值
     * @return $this
     */
    public function data($field, $value = null)
    {
        if (is_array($field)) {
            $this->options['data'] = isset($this->options['data']) ? array_merge($this->options['data'], $field) : $field;
        } else {
            $this->options['data'][$field] = $value;
        }
        return $this;
    }

    /**
     * 指定JOIN查询字段
     * @access public
     * @param string|array $table 数据表
     * @param string|array $field 查询字段
     * @param string|array $on    JOIN条件
     * @param string       $type  JOIN类型
     * @return $this
     */
    public function view($join, $field = true, $on = null, $type = 'INNER')
    {
        $this->options['view'] = true;
        if (is_array($join) && key($join) !== 0) {
            foreach ($join as $key => $val) {
                $this->view($key, $val[0], isset($val[1]) ? $val[1] : null, isset($val[2]) ? $val[2] : 'INNER');
            }
        } else {
            $fields = [];
            $table  = $this->getJoinTable($join, $alias);

            if (true === $field) {
                $fields = $alias . '.*';
            } else {
                if (is_string($field)) {
                    $field = explode(',', $field);
                }
                foreach ($field as $key => $val) {
                    if (is_numeric($key)) {
                        $fields[]                   = $alias . '.' . $val;
                        $this->options['map'][$val] = $alias . '.' . $val;
                    } else {
                        if (preg_match('/[,=\.\'\"\(\s]/', $key)) {
                            $name = $key;
                        } else {
                            $name = $alias . '.' . $key;
                        }
                        $fields[$name]              = $val;
                        $this->options['map'][$val] = $name;
                    }
                }
            }
            $this->field($fields);
            if ($on) {
                $this->join($table, $on, $type);
            } else {
                $this->table($table);
            }
        }
        return $this;
    }

    /**
     * 设置分表规则
     * @access public
     * @param array  $data  操作的数据
     * @param string $field 分表依据的字段
     * @param array  $rule  分表规则
     * @return $this
     */
    public function partition($data, $field, $rule = [])
    {
        $this->options['table'] = $this->getPartitionTableName($data, $field, $rule);
        return $this;
    }

    /**
     * 指定AND查询条件
     * @access public
     * @param mixed $field     查询字段
     * @param mixed $op        查询表达式
     * @param mixed $condition 查询条件
     * @return $this
     */
    public function where($field, $op = null, $condition = null)
    {
        $param = func_get_args();
        array_shift($param);
        $this->parseWhereExp('AND', $field, $op, $condition, $param);
        return $this;
    }

    /**
     * 指定OR查询条件
     * @access public
     * @param mixed $field     查询字段
     * @param mixed $op        查询表达式
     * @param mixed $condition 查询条件
     * @return $this
     */
    public function whereOr($field, $op = null, $condition = null)
    {
        $param = func_get_args();
        array_shift($param);
        $this->parseWhereExp('OR', $field, $op, $condition, $param);
        return $this;
    }

    /**
     * 指定XOR查询条件
     * @access public
     * @param mixed $field     查询字段
     * @param mixed $op        查询表达式
     * @param mixed $condition 查询条件
     * @return $this
     */
    public function whereXor($field, $op = null, $condition = null)
    {
        $param = func_get_args();
        array_shift($param);
        $this->parseWhereExp('XOR', $field, $op, $condition, $param);
        return $this;
    }

    /**
     * 指定Null查询条件
     * @access public
     * @param mixed  $field 查询字段
     * @param string $logic 查询逻辑 and or xor
     * @return $this
     */
    public function whereNull($field, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'null', null);
        return $this;
    }

    /**
     * 指定NotNull查询条件
     * @access public
     * @param mixed  $field 查询字段
     * @param string $logic 查询逻辑 and or xor
     * @return $this
     */
    public function whereNotNull($field, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'notnull', null);
        return $this;
    }

    /**
     * 指定Exists查询条件
     * @access public
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereExists($condition, $logic = 'AND')
    {
        $this->options['where'][strtoupper($logic)][] = ['exists', $condition];
        return $this;
    }

    /**
     * 指定NotExists查询条件
     * @access public
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereNotExists($condition, $logic = 'AND')
    {
        $this->options['where'][strtoupper($logic)][] = ['not exists', $condition];
        return $this;
    }

    /**
     * 指定In查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereIn($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'in', $condition);
        return $this;
    }

    /**
     * 指定NotIn查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereNotIn($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'not in', $condition);
        return $this;
    }

    /**
     * 指定Like查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereLike($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'like', $condition);
        return $this;
    }

    /**
     * 指定NotLike查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereNotLike($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'not like', $condition);
        return $this;
    }

    /**
     * 指定Between查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereBetween($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'between', $condition);
        return $this;
    }

    /**
     * 指定NotBetween查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereNotBetween($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'not between', $condition);
        return $this;
    }

    /**
     * 指定Exp查询条件
     * @access public
     * @param mixed  $field     查询字段
     * @param mixed  $condition 查询条件
     * @param string $logic     查询逻辑 and or xor
     * @return $this
     */
    public function whereExp($field, $condition, $logic = 'AND')
    {
        $this->parseWhereExp($logic, $field, 'exp', $condition);
        return $this;
    }


    /**
     * 分析查询表达式
     * @access public
     * @param string                $logic     查询逻辑 and or xor
     * @param string|array|\Closure $field     查询字段
     * @param mixed                 $op        查询表达式
     * @param mixed                 $condition 查询条件
     * @param array                 $param     查询参数
     * @return void
     */
    protected function parseWhereExp($logic, $field, $op, $condition, $param = [])
    {
        $logic = strtoupper($logic);
        if ($field instanceof \Closure) {
            $this->options['where'][$logic][] = is_string($op) ? [$op, $field] : $field;
            return;
        }
        if (is_string($field) && !empty($this->options['via']) && !strpos($field, '.')) {
            $field = $this->options['via'] . '.' . $field;
        }
        if (is_string($field) && preg_match('/[,=\>\<\'\"\(\s]/', $field)) {
            $where[] = ['exp', $field];	
            if (is_array($op)) {
                // 参数绑定
                $this->bind($op);
            }	
        } elseif (is_null($op) && is_null($condition)) {		
            if (is_array($field)) {
                // 数组批量查询
                $where = $field;
                foreach ($where as $k => $val) {
                    $this->options['multi'][$logic][$k][] = $val;
                }
            } elseif ($field && is_string($field)) {
                // 字符串查询
                $where[$field]                            = ['null', ''];
                $this->options['multi'][$logic][$field][] = $where[$field];
            }
        } elseif (is_array($op)) {
            $where[$field] = $param;
        } elseif (in_array(strtolower($op), ['null', 'notnull', 'not null'])) {
            // null查询
            $where[$field]                            = [$op, ''];
            $this->options['multi'][$logic][$field][] = $where[$field];
        } elseif (is_null($condition)) {
            // 字段相等查询
            $where[$field]                            = ['eq', $op];
            $this->options['multi'][$logic][$field][] = $where[$field];
        } else {
            $where[$field] = [$op, $condition, isset($param[2]) ? $param[2] : null];
            if ('exp' == strtolower($op) && isset($param[2]) && is_array($param[2])) {
                // 参数绑定
                $this->bind($param[2]);
            }
            // 记录一个字段多次查询条件
            $this->options['multi'][$logic][$field][] = $where[$field];
        }
        if (!empty($where)) {
            if (!isset($this->options['where'][$logic])) {
                $this->options['where'][$logic] = [];
            }
            if (is_string($field) && $this->checkMultiField($field, $logic)) {
                $where[$field] = $this->options['multi'][$logic][$field];
            } elseif (is_array($field)) {
                foreach ($field as $key => $val) {
                    if ($this->checkMultiField($key, $logic)) {
                        $where[$key] = $this->options['multi'][$logic][$key];
                    }
                }
            }
            $this->options['where'][$logic] = array_merge($this->options['where'][$logic], $where);
        }
    }

    /**
     * 检查是否存在一个字段多次查询条件
     * @access public
     * @param string $field 查询字段
     * @param string $logic 查询逻辑 and or xor
     * @return bool
     */
    private function checkMultiField($field, $logic)
    {
        return isset($this->options['multi'][$logic][$field]) && count($this->options['multi'][$logic][$field]) > 1;
    }

    /**
     * 去除某个查询条件
     * @access public
     * @param string $field 查询字段
     * @param string $logic 查询逻辑 and or xor
     * @return $this
     */
    public function removeWhereField($field, $logic = 'AND')
    {
        $logic = strtoupper($logic);
        if (isset($this->options['where'][$logic][$field])) {
            unset($this->options['where'][$logic][$field]);
        }
        return $this;
    }

    /**
     * 去除查询参数
     * @access public
     * @param string|bool $option 参数名 true 表示去除所有参数
     * @return $this
     */
    public function removeOption($option = true)
    {
        if (true === $option) {
            $this->options = [];
        } elseif (is_string($option) && isset($this->options[$option])) {
            unset($this->options[$option]);
        }
        return $this;
    }

    /**
     * 指定查询数量
     * @access public
     * @param mixed $offset 起始位置
     * @param mixed $length 查询数量
     * @return $this
     */
    public function limit($offset, $length = null)
    {
        if (is_null($length) && strpos($offset, ',')) {
            list($offset, $length) = explode(',', $offset);
        }
        $this->options['limit'] = intval($offset) . ($length ? ',' . intval($length) : '');
        return $this;
    }

    /**
     * 指定分页
     * @access public
     * @param mixed $page     页数
     * @param mixed $listRows 每页数量
     * @return $this
     */
    public function page($page, $listRows = null)
    {
        if (is_null($listRows) && strpos($page, ',')) {
            list($page, $listRows) = explode(',', $page);
        }
        $this->options['page'] = [intval($page), intval($listRows)];
        return $this;
    }

    /**
     * 分页查询
     * @param int|array $listRows 每页数量 数组表示配置参数
     * @param int|bool  $simple   是否简洁模式或者总记录数
     * @param array     $config   配置参数
     *                            page:当前页,
     *                            path:url路径,
     *                            query:url额外参数,
     *                            fragment:url锚点,
     *                            var_page:分页变量,
     *                            list_rows:每页数量
     *                            type:分页类名
     * @return \think\Paginator
     * @throws DbException
     */
    public function paginate($listRows = null, $simple = false, $config = [])
    {
        if (is_int($simple)) {
            $total  = $simple;
            $simple = false;
        }
        if (is_array($listRows)) {
            $config   = array_merge(Config::get('paginate'), $listRows);
            $listRows = $config['list_rows'];
        } else {
            $config   = array_merge(Config::get('paginate'), $config);
            $listRows = $listRows ?: $config['list_rows'];
        }

        /** @var Paginator $class */
        $class = false !== strpos($config['type'], '\\') ? $config['type'] : '\\think\\paginator\\driver\\' . ucwords($config['type']);
        $page  = isset($config['page']) ? (int) $config['page'] : call_user_func([
            $class,
            'getCurrentPage',
        ], $config['var_page']);

        $page = $page < 1 ? 1 : $page;

        $config['path'] = isset($config['path']) ? $config['path'] : call_user_func([$class, 'getCurrentPath']);

        if (!isset($total) && !$simple) {
            $options = $this->getOptions();

            unset($this->options['order'], $this->options['limit'], $this->options['page'], $this->options['field']);

            $bind    = $this->bind;
            $total   = $this->count();
            $results = $this->options($options)->bind($bind)->page($page, $listRows)->select();
        } elseif ($simple) {
            $results = $this->limit(($page - 1) * $listRows, $listRows + 1)->select();
            $total   = null;
        } else {
            $results = $this->page($page, $listRows)->select();
        }
        return $class::make($results, $listRows, $page, $total, $simple, $config);
    }

    /**
     * 指定当前操作的数据表
     * @access public
     * @param mixed $table 表名
     * @return $this
     */
    public function table($table)
    {
        if (is_string($table)) {
            if (strpos($table, ')')) {
                // 子查询
            } elseif (strpos($table, ',')) {
                $tables = explode(',', $table);
                $table  = [];
                foreach ($tables as $item) {
                    @list($item, $alias) = explode(' ', trim($item));
                    $item = $this->tbname[$item];
                    if ($alias) {
                        $this->alias([$item => $alias]);
                        $table[$item] = $alias;
                    } else {
                        $table[] = $item;
                    }
                }
            } elseif (strpos($table, ' ')) {
                list($table, $alias) = explode(' ', $table);
                $table = $this->tbname[$table];

                $table = [$table => $alias];
                $this->alias($table);
            }else{
                $table = $this->tbname[$table];                
            }
        } else {
            $tables = $table;
            $table  = [];
            foreach ($tables as $key => $val) {
                $val = $this->tbname[$val];
                if (is_numeric($key)) {
                    $table[] = $val;
                } else {
                    $this->alias([$key => $val]);
                    $table[$key] = $val;
                }
            }
        }
        $this->options['table'] = $table;
        return $this;
    }

    /**
     * 指定排序 order('id','desc') 或者 order(['id'=>'desc','create_time'=>'desc'])
     * @access public
     * @param string|array $field 排序字段
     * @param string       $order 排序
     * @return $this
     */
    public function order($field, $order = null)
    {
        if (!empty($field)) {
            if (is_string($field)) {
                if (!empty($this->options['via'])) {
                    $field = $this->options['via'] . '.' . $field;
                }
                $field = empty($order) ? $field : [$field => $order];
            } elseif (!empty($this->options['via'])) {
                foreach ($field as $key => $val) {
                    if (is_numeric($key)) {
                        $field[$key] = $this->options['via'] . '.' . $val;
                    } else {
                        $field[$this->options['via'] . '.' . $key] = $val;
                        unset($field[$key]);
                    }
                }
            }
            if (!isset($this->options['order'])) {
                $this->options['order'] = [];
            }
            if (is_array($field)) {
                $this->options['order'] = array_merge($this->options['order'], $field);
            } else {
                $this->options['order'][] = $field;
            }
        }
        return $this;
    }


    /**
     * 指定group查询
     * @access public
     * @param string $group GROUP
     * @return $this
     */
    public function group($group)
    {
        $this->options['group'] = $group;
        return $this;
    }

    /**
     * 指定having查询
     * @access public
     * @param string $having having
     * @return $this
     */
    public function having($having)
    {
        $this->options['having'] = $having;
        return $this;
    }

    /**
     * 指定distinct查询
     * @access public
     * @param string $distinct 是否唯一
     * @return $this
     */
    public function distinct($distinct)
    {
        $this->options['distinct'] = $distinct;
        return $this;
    }

    /**
     * 指定数据表别名
     * @access public
     * @param mixed $alias 数据表别名
     * @return $this
     */
    public function alias($alias)
    {
        if (is_array($alias)) {
            foreach ($alias as $key => $val) {
                if (false !== strpos($key, '__')) {
                    $table = $this->parseSqlTable($key);
                } else {
                    $table = $key;
                }
                $this->options['alias'][$table] = $val;
            }
        } else {
            if (isset($this->options['table'])) {
                $table = is_array($this->options['table']) ? key($this->options['table']) : $this->options['table'];
                if (false !== strpos($table, '__')) {
                    $table = $this->parseSqlTable($table);
                }
            } else {
                $table = $this->getTable();
            }

            $this->options['alias'][$table] = $alias;
        }
        return $this;
    }

    /**
     * 获取执行的SQL语句
     * @access public
     * @param boolean $fetch 是否返回sql
     * @return $this
     */
    public function fetchSql($fetch = true)
    {
        $this->options['fetch_sql'] = $fetch;
        return $this;
    }


    /**
     * 设置从主服务器读取数据
     * @access public
     * @return $this
     */
    public function master()
    {
        $this->options['master'] = true;
        return $this;
    }

    /**
     * 设置是否严格检查字段名
     * @access public
     * @param bool $strict 是否严格检查字段
     * @return $this
     */
    public function strict($strict = true)
    {
        $this->options['strict'] = $strict;
        return $this;
    }

    /**
     * 设置查询数据不存在是否抛出异常
     * @access public
     * @param bool $fail 数据不存在是否抛出异常
     * @return $this
     */
    public function failException($fail = true)
    {
        $this->options['fail'] = $fail;
        return $this;
    }


    /**
     * 查询日期或者时间
     * @access public
     * @param string       $field 日期字段名
     * @param string|array $op    比较运算符或者表达式
     * @param string|array $range 比较范围
     * @return $this
     */
    public function whereTime($field, $op, $range = null)
    {
        if (is_null($range)) {
            if (is_array($op)) {
                $range = $op;
            } else {
                // 使用日期表达式
                switch (strtolower($op)) {
                    case 'today':
                    case 'd':
                        $range = ['today', 'tomorrow'];
                        break;
                    case 'week':
                    case 'w':
                        $range = ['this week 00:00:00', 'next week 00:00:00'];
                        break;
                    case 'month':
                    case 'm':
                        $range = ['first Day of this month 00:00:00', 'first Day of next month 00:00:00'];
                        break;
                    case 'year':
                    case 'y':
                        $range = ['this year 1/1', 'next year 1/1'];
                        break;
                    case 'yesterday':
                        $range = ['yesterday', 'today'];
                        break;
                    case 'last week':
                        $range = ['last week 00:00:00', 'this week 00:00:00'];
                        break;
                    case 'last month':
                        $range = ['first Day of last month 00:00:00', 'first Day of this month 00:00:00'];
                        break;
                    case 'last year':
                        $range = ['last year 1/1', 'this year 1/1'];
                        break;
                    default:
                        $range = $op;
                }
            }
            $op = is_array($range) ? 'between' : '>';
        }
        $this->where($field, strtolower($op) . ' time', $range);
        return $this;
    }

    /**
     * 获取数据表信息
     * @access public
     * @param mixed  $tableName 数据表名 留空自动获取
     * @param string $fetch     获取信息类型 包括 fields type bind pk
     * @return mixed
     */
    public function getTableInfo($tableName = '', $fetch = '')
    {
		return false; //全部不采用tp5的获取字段信息
    }

    /**
     * 取得数据表的字段信息
     * @access public
     * @param string $tableName
     * @return array
     */
    public function getFields($tableName)
    {
        list($tableName) = explode(' ', $tableName);
        if (false === strpos($tableName, '`')) {
            if (strpos($tableName, '.')) {
                $tableName = str_replace('.', '`.`', $tableName);
            }
            $tableName = '`' . $tableName . '`';
        }

        $sql    = 'SHOW COLUMNS FROM ' . $tableName;
        $pdo    = $this->query($sql, [], false, true);
        $result = $pdo->fetchAll(PDO::FETCH_ASSOC);
        $info   = [];
        if ($result) {
            foreach ($result as $key => $val) {
                $val                 = array_change_key_case($val);
                $info[$val['field']] = [
                    'name'    => $val['field'],
                    'type'    => $val['type'],
                    'notnull' => (bool) ('' === $val['null']), // not null is empty, null is yes
                    'default' => $val['default'],
                    'primary' => (strtolower($val['key']) == 'pri'),
                    'autoinc' => (strtolower($val['extra']) == 'auto_increment'),
                ];
            }
        }
        return $this->fieldCase($info);
    }
	
    /**
     * 对返数据表字段信息进行大小写转换出来
     * @access private
     * @param array $info 字段信息
     * @return array
     */
    private function fieldCase($info)
    {
        // 字段大小写转换
        switch ($this->attrCase) {
            case PDO::CASE_LOWER:
                $info = array_change_key_case($info);
                break;
            case PDO::CASE_UPPER:
                $info = array_change_key_case($info, CASE_UPPER);
                break;
            case PDO::CASE_NATURAL:
            default:
                // 不做转换
        }
        return $info;
    }

    // 获取当前数据表字段信息
    private function getTableFields($table = '')
    {
        return $this->getTableInfo($table ?: $this->getOptions('table'), 'fields');
    }
	
    // 获取当前数据表字段类型
    public function getFieldsType($table = '')
    {
        return $this->getTableInfo($table ?: $this->getOptions('table'), 'type');
    }
	
    // 获取当前数据表绑定信息
    public function getFieldsBind($table = '')
    {
        $types = $this->getFieldsType($table);
		print_r($types);
        $bind  = [];
        if ($types) {
            foreach ($types as $key => $type) {
                $bind[$key] = $this->getFieldBindType($type);
            }
        }
        return $bind;
    }

    /**
     * 获取字段绑定类型
     * @access public
     * @param string $type 字段类型
     * @return integer
     */
    protected function getFieldBindType($type)
    {
        if (0 === strpos($type, 'set') || 0 === strpos($type, 'enum')) {
            $bind = PDO::PARAM_STR;
        } elseif (preg_match('/(int|double|float|decimal|real|numeric|serial|bit)/is', $type)) {
            $bind = PDO::PARAM_INT;
        } elseif (preg_match('/bool/is', $type)) {
            $bind = PDO::PARAM_BOOL;
        } else {
            $bind = PDO::PARAM_STR;
        }
        return $bind;
    }

    /**
     * 参数绑定
     * @access public
     * @param mixed   $key   参数名
     * @param mixed   $value 绑定变量值
     * @param integer $type  绑定类型
     * @return $this
     */
    public function bind($key, $value = false, $type = PDO::PARAM_STR)
    {
        if (is_array($key)) {
            $this->bind = array_merge($this->bind, $key);
        } else {
            $this->bind[$key] = [$value, $type];
        }
        return $this;
    }

    /**
     * 检测参数是否已经绑定
     * @access public
     * @param string $key 参数名
     * @return bool
     */
    public function isBind($key)
    {
        return isset($this->bind[$key]);
    }

    /**
     * 查询参数赋值
     * @access protected
     * @param array $options 表达式参数
     * @return $this
     */
    protected function options(array $options)
    {
        $this->options = $options;
        return $this;
    }

    /**
     * 获取当前的查询参数
     * @access public
     * @param string $name 参数名
     * @return mixed
     */
    public function getOptions($name = '')
    {
        if ('' === $name) {
            return $this->options;
        } else {
            return isset($this->options[$name]) ? $this->options[$name] : null;
        }
    }


    /**
     * 设置关联查询
     * @access public
     * @param string|array $relation 关联名称
     * @return $this
     */
    public function relation($relation)
    {
        if (empty($relation)) {
            return $this;
        }
        if (is_string($relation)) {
            $relation = explode(',', $relation);
        }
        if (isset($this->options['relation'])) {
            $this->options['relation'] = array_merge($this->options['relation'], $relation);
        } else {
            $this->options['relation'] = $relation;
        }
        return $this;
    }


    /**
     * 插入记录
     * @access public
     * @param mixed   $data         数据
     * @param boolean $replace      是否replace
     * @param boolean $getLastInsID 返回自增主键
     * @param string  $sequence     自增序列名
     * @return integer|string
     */
    public function insert(array $data = [], $replace = false, $getLastInsID = false, $sequence = null)
    {
        // 分析查询表达式
        $options = $this->parseExpress();
        $data    = array_merge($options['data'], $data);
        // 生成SQL语句
        $sql = $this->builderInsert($data, $options, $replace);
        // 获取参数绑定
        $bind = $this->getBind();
        if ($options['fetch_sql']) {
            // 获取实际执行的SQL语句
            return $this->getRealSql($sql, $bind);
        }

        // 执行操作
        $result = 0 === $sql ? 0 : $this->execute($sql, $bind);
        if ($result) {
            $sequence  = $sequence ?: (isset($options['sequence']) ? $options['sequence'] : null);
            $lastInsId = $this->getLastInsID($sequence);
            if ($lastInsId) {
                $pk = $this->getPk($options);
                if (is_string($pk)) {
                    $data[$pk] = $lastInsId;
                }
            }
            $options['data'] = $data;
            $this->trigger('after_insert', $options);

            if ($getLastInsID) {
                return $lastInsId;
            }
        }
        return $result;
    }

    /**
     * 插入记录并获取自增ID
     * @access public
     * @param mixed   $data     数据
     * @param boolean $replace  是否replace
     * @param string  $sequence 自增序列名
     * @return integer|string
     */
    public function insertGetId(array $data, $replace = false, $sequence = null)
    {
        return $this->insert($data, $replace, true, $sequence);
    }

    /**
     * 批量插入记录
     * @access public
     * @param mixed     $dataSet 数据集
     * @param boolean   $replace  是否replace
     * @param integer   $limit   每次写入数据限制
     * @return integer|string
     */
    public function insertAll(array $dataSet, $replace = false, $limit = null)
    {
        // 分析查询表达式
        $options = $this->parseExpress();
        if (!is_array(reset($dataSet))) {
            return false;
        }

        // 生成SQL语句
        if (is_null($limit)) {
            $sql = $this->builderInsertAll($dataSet, $options, $replace);
        } else {
            $array = array_chunk($dataSet, $limit, true);
            foreach ($array as $item) {
                $sql[] = $this->builderInsertAll($item, $options, $replace);
            }
        }

        // 获取参数绑定
        $bind = $this->getBind();
        if ($options['fetch_sql']) {
            // 获取实际执行的SQL语句
            return $this->getRealSql($sql, $bind);
        } elseif (is_array($sql)) {
            // 执行操作
            return $this->batchQuery($sql, $bind);
        } else {
            // 执行操作
            return $this->execute($sql, $bind);
        }
    }

    /**
     * 通过Select方式插入记录
     * @access public
     * @param string $fields 要插入的数据表字段名
     * @param string $table  要插入的数据表名
     * @return integer|string
     * @throws PDOException
     */
    public function selectInsert($fields, $table)
    {
        // 分析查询表达式
        $options = $this->parseExpress();
        // 生成SQL语句
        $table = $this->parseSqlTable($table);
        $sql   = $this->builderSelectInsert($fields, $table, $options);
        // 获取参数绑定
        $bind = $this->getBind();
        if ($options['fetch_sql']) {
            // 获取实际执行的SQL语句
            return $this->getRealSql($sql, $bind);
        } else {
            // 执行操作
            return $this->execute($sql, $bind);
        }
    }

    /**
     * 更新记录
     * @access public
     * @param mixed $data 数据
     * @return integer|string
     * @throws Exception
     * @throws PDOException
     */
    public function update(array $data = [])
    {
        $options = $this->parseExpress();
        $data    = array_merge($options['data'], $data);
        $pk      = $this->getPk($options);
        if (isset($options['cache']) && is_string($options['cache']['key'])) {
            $key = $options['cache']['key'];
        }

        if (empty($options['where'])) {
            // 如果存在主键数据 则自动作为更新条件
            if (is_string($pk) && isset($data[$pk])) {
                $where[$pk] = $data[$pk];
                if (!isset($key)) {
                    $key = 'think:' . $options['table'] . '|' . $data[$pk];
                }
                unset($data[$pk]);
            } elseif (is_array($pk)) {
                // 增加复合主键支持
                foreach ($pk as $field) {
                    if (isset($data[$field])) {
                        $where[$field] = $data[$field];
                    } else {
                        // 如果缺少复合主键数据则不执行
                        throw new Exception('miss complex primary data');
                    }
                    unset($data[$field]);
                }
            }
            if (!isset($where)) {
                // 如果没有任何更新条件则不执行
                throw new Exception('miss update condition');
            } else {
                $options['where']['AND'] = $where;
            }
        } elseif (!isset($key) && is_string($pk) && isset($options['where']['AND'][$pk])) {
            $key = $this->getCacheKey($options['where']['AND'][$pk], $options, $this->bind);
        }

        // 生成UPDATE SQL语句
        $sql = $this->builderUpdate($data, $options);
        // 获取参数绑定
        $bind = $this->getBind();
        if ($options['fetch_sql']) {
            // 获取实际执行的SQL语句
            return $this->getRealSql($sql, $bind);
        } else {
            // 检测缓存
            if (isset($key) && Cache::get($key)) {
                // 删除缓存
                Cache::rm($key);
            } elseif (!empty($options['cache']['tag'])) {
                Cache::clear($options['cache']['tag']);
            }
            // 执行操作
            $result = '' == $sql ? 0 : $this->execute($sql, $bind);
            if ($result) {
                if (is_string($pk) && isset($where[$pk])) {
                    $data[$pk] = $where[$pk];
                } elseif (is_string($pk) && isset($key) && strpos($key, '|')) {
                    list($a, $val) = explode('|', $key);
                    $data[$pk]     = $val;
                }
                $options['data'] = $data;
                $this->trigger('after_update', $options);
            }
            return $result;
        }
    }
	
	
    /**
     * 查找记录
     * @access public
     * @param array|string|Query|\Closure $data
     * @return Collection|false|\PDOStatement|string
     * @throws DbException
     * @throws ModelNotFoundException
     * @throws DataNotFoundException
     */
    public function select($data = null, $dsl = '')
    {
        if ($data instanceof Query) {
            return $data->select();
        } elseif ($data instanceof \Closure) {
            call_user_func_array($data, [ & $this]);
            $data = null;
        }
        // 分析查询表达式
        $options = $this->parseExpress();

        if (false === $data) {
            // 用于子查询 不查询只返回SQL
            $options['fetch_sql'] = true;
        } elseif (!is_null($data)) {
            // 主键条件分析
            $this->parsePkWhere($data, $options);
        }
        $resultSet = false;
        if (empty($options['fetch_sql']) && !empty($options['cache'])) {
            // 判断查询缓存
            $cache = $options['cache'];
            unset($options['cache']);
            $key       = is_string($cache['key']) ? $cache['key'] : md5(serialize($options) . serialize($this->bind));
            $resultSet = Cache::get($key);
        }
        if (false === $resultSet) {
            if ($dsl !== '') {
                $result = $this->dslSearch($dsl);
            }else{
                // 生成查询SQL
                $sql = $this->builderSelect($options);
    			// 获取参数绑定
                $bind = $this->getBind();
    			$this->sql = $this->getRealSql($sql, $bind);
                if ($options['fetch_sql']) {
                    // 获取实际执行的SQL语句
                    return $this->sql;
                }
    			$result = $this->sql($this->sql);
            }
			if(!empty($result['hits']['hits'])){
				$resultSet = array_column($result['hits']['hits'] , '_source');
                // 查询字段以及字段别名处理
                $resultSet = $this->fieldsShow($options,$resultSet);
			}
			if(!empty($options['group']) && !empty($result['aggregations'])){
				// $aaa = $this->aggregations($result['aggregations']);
				// print_r($aaa);
				// exit;
				unset($resultSet);
			
				foreach($result['aggregations'] as $k=>$item){
					//因考虑到使用时处理NESTED类型的数据麻烦，现将关联表下的字段默认为需要取的字段，
					//如字段名有重复，请给主表名进行重命名
					if(strstr($k , '@NESTED')){
						$k = str_replace('@NESTED' , '' , $k);
						$nestedParm = explode('.' , $k);
						if(isset($item[$k]['buckets'])){
							$resultSet[$nestedParm[1]] = $item[$k]['buckets'];
						}
					}else{
						$resultSet[$k] = $item['buckets'];
					}
				}
			}else if(empty($options['group']) && !empty($result['aggregations'])){ //非group形式的返回
                $resultSet = $result['aggregations'];
            }

			$this->total = $result['hits']['total'];
            if (isset($cache) && false !== $resultSet) {
                // 缓存数据集
                $this->cacheData($key, $resultSet, $cache);
            }
        }

        // 返回结果处理
        if (!empty($options['fail']) && count($resultSet) == 0) {
            $this->throwNotFound($options);
        }
        return $resultSet;
    }
	
	private function aggregations($result,$resultSet = []){
		// print_r($result);
		// exit;
		foreach($result as $k=>$item){
			if(isset($item['buckets'])){
				foreach($item['buckets'] as $bkey=>$value){
					if(count($value) != 2){
						if(isset($value['key_as_string'])){
							$value['key'] = $value['key_as_string'];
							unset($value['key_as_string']);
						}
						foreach($value as $key=>$val){
							if(!is_array($val)){
								$resultSet[$k][$bkey][$key] = $val;
							}else{
								$resultSet = array_merge($resultSet , $resultSet[$k][$bkey]);
								$this->aggregations($value , $resultSet);
							}
						}
					}else{
						
					}
				}
			}
		}
		
		return $resultSet;
		// return $this->aggregations($result[$k] , $resultSet);
	}

    /**
     * 查找单条记录
     * @access public
     * @param array|string|Query|\Closure $data
     * @return array|false|\PDOStatement|string|Model
     * @throws DbException
     * @throws ModelNotFoundException
     * @throws DataNotFoundException
     */
    public function find($data = null)
    {
        if ($data instanceof Query) {
            return $data->select();
        } elseif ($data instanceof \Closure) {
            call_user_func_array($data, [ & $this]);
            $data = null;
        }
        // 分析查询表达式
        $options = $this->parseExpress();

        if (false === $data) {
            // 用于子查询 不查询只返回SQL
            $options['fetch_sql'] = true;
        } elseif (!is_null($data)) {
            // 主键条件分析
            $this->parsePkWhere($data, $options);
        }
        $options['limit'] = 1;
        $result           = false;

        if (empty($options['fetch_sql']) && !empty($options['cache'])) {
            // 判断查询缓存
            $cache = $options['cache'];
            if (true === $cache['key'] && !is_null($data) && !is_array($data)) {
                $key = 'think:' . (is_array($options['table']) ? key($options['table']) : $options['table']) . '|' . $data;
            } elseif (is_string($cache['key'])) {
                $key = $cache['key'];
            } elseif (!isset($key)) {
                $key = md5(serialize($options) . serialize($this->bind));
            }
            $result = Cache::get($key);
        }
        if (false === $result) {
            // 生成查询SQL
			$this->sql = $this->builderSelect($options);
			$res = $this->sql($this->sql);
			if(!empty($res['hits']['hits'])){
				// $result = $res['hits']['hits'][0]['_source'];
				$resultSet = array_column($res['hits']['hits'] , '_source');
                // 查询字段漏掉字段名显示处理
                $resultSet = $this->fieldsShow($options,$resultSet);
				if(isset($resultSet[0])){
					$result =  $resultSet[0];
				}
			}
			$this->total = $res['hits']['total'];

            if (isset($cache) && false !== $result) {
                // 缓存数据
                $this->cacheData($key, $result, $cache);
            }
        }
		if (!empty($options['fail'])) {
            $this->throwNotFound($options);
        }
        return $result;
    }
	
    /**
     * 查询字段漏掉字段名显示处理
     * @param  [object] $options [当前模型]
     * @param  [array]  $data    [结果数据集合]
     * @return [array]           [组合好的结果集]
     */
    public function fieldsShow($options, $data = [], $type = 0){
        if (!empty($data)) {
            // 分析查询表达式
            if (isset($options['field']) && !empty($options['field'] && $options['field']!=='*')) {
                // 组合字段
				$accurate = config('ES.accurate');
                $handle = [];
				foreach ($data as $key => $value) {
					if($key == 0){
						foreach($options['field'] as $tempfield){
							if(!array_key_exists($tempfield, $value)){
								//排除情况
								if(!strpbrk('(),\'\"=, ' , $tempfield)){
									$tempfield = str_replace($accurate , '' , $tempfield);
									if(strstr($tempfield, '.')){
										$fieldparm = explode('.' , $tempfield);
										$handle[$fieldparm[1]] = $tempfield;
										if(isset($value[$fieldparm[0]][0][$fieldparm[1]])){
											$data[$key][$fieldparm[1]] = $value[$fieldparm[0]][0][$fieldparm[1]];
											if($fieldparm[0] != $fieldparm[1]){
												unset($data[$key][$fieldparm[0]]);
											}
										}else{
											$data[$key][$fieldparm[1]] = NULL;
										}
									}
								}
							}
						}
					}else{
						foreach($handle as $val){
							$fieldparm = explode('.' , $val);
							if(isset($value[$fieldparm[0]][0][$fieldparm[1]])){
								$data[$key][$fieldparm[1]] = $value[$fieldparm[0]][0][$fieldparm[1]];
								if($fieldparm[0] != $fieldparm[1]){
									unset($data[$key][$fieldparm[0]]);
								}
							}else{
								$data[$key][$fieldparm[1]] = NULL;
							}
						}
					}
				}
            }
        }
        return $data;
    }

    /**
     * 查询失败 抛出异常
     * @access public
     * @param array $options 查询参数
     * @throws ModelNotFoundException
     * @throws DataNotFoundException
     */
    protected function throwNotFound($options = [])
    {
        if (!empty($this->model)) {
            throw new ModelNotFoundException('model data Not Found:' . $this->model, $this->model, $options);
        } else {
            $table = is_array($options['table']) ? key($options['table']) : $options['table'];
            throw new DataNotFoundException('table data not Found:' . $table, $table, $options);
        }
    }

    /**
     * 查找多条记录 如果不存在则抛出异常
     * @access public
     * @param array|string|Query|\Closure $data
     * @return array|\PDOStatement|string|Model
     * @throws DbException
     * @throws ModelNotFoundException
     * @throws DataNotFoundException
     */
    public function selectOrFail($data = null)
    {
        return $this->failException(true)->select($data);
    }

    /**
     * 查找单条记录 如果不存在则抛出异常
     * @access public
     * @param array|string|Query|\Closure $data
     * @return array|\PDOStatement|string|Model
     * @throws DbException
     * @throws ModelNotFoundException
     * @throws DataNotFoundException
     */
    public function findOrFail($data = null)
    {
        return $this->failException(true)->find($data);
    }
	
    /**
     * 获取绑定的参数 并清空
     * @access public
     * @return array
     */
    public function getBind()
    {
        $bind       = $this->bind;
        $this->bind = [];
        return $bind;
    }

    /**
     * 创建子查询SQL
     * @access public
     * @param bool $sub
     * @return string
     * @throws DbException
     */
    public function buildSql($sub = true)
    {
        return $sub ? '( ' . $this->select(false) . ' )' : $this->select(false);
    }

    /**
     * 删除记录
     * @access public
     * @param mixed $data 表达式 true 表示强制删除
     * @return int
     * @throws Exception
     * @throws PDOException
     */
    public function delete($data = null)
    {
        // 分析查询表达式
        $options = $this->parseExpress();
        $pk      = $this->getPk($options);
        if (isset($options['cache']) && is_string($options['cache']['key'])) {
            $key = $options['cache']['key'];
        }

        if (!is_null($data) && true !== $data) {
            if (!isset($key) && !is_array($data)) {
                // 缓存标识
                $key = 'think:' . $options['table'] . '|' . $data;
            }
            // AR模式分析主键条件
            $this->parsePkWhere($data, $options);
        } elseif (!isset($key) && is_string($pk) && isset($options['where']['AND'][$pk])) {
            $key = $this->getCacheKey($options['where']['AND'][$pk], $options, $this->bind);
        }

        if (true !== $data && empty($options['where'])) {
            // 如果条件为空 不进行删除操作 除非设置 1=1
            throw new Exception('delete without condition');
        }
        // 生成删除SQL语句
        $sql = $this->builderDelete($options);
        // 获取参数绑定
        $bind = $this->getBind();
        if ($options['fetch_sql']) {
            // 获取实际执行的SQL语句
            return $this->getRealSql($sql, $bind);
        }

        // 检测缓存
        if (isset($key) && Cache::get($key)) {
            // 删除缓存
            Cache::rm($key);
        } elseif (!empty($options['cache']['tag'])) {
            Cache::clear($options['cache']['tag']);
        }
        // 执行操作
        $result = $this->execute($sql, $bind);
        if ($result) {
            if (!is_array($data) && is_string($pk) && isset($key) && strpos($key, '|')) {
                list($a, $val) = explode('|', $key);
                $item[$pk]     = $val;
                $data          = $item;
            }
            $options['data'] = $data;
            $this->trigger('after_delete', $options);
        }
        return $result;
    }
	
    /**
     * 分析表达式（可用于查询或者写入操作）
     * @access protected
     * @return array
     */
    protected function parseExpress()
    {
        $options = $this->options;

        // 获取数据表
        if (empty($options['table'])) {
            $options['table'] = $this->getTable();
        }

        if (!isset($options['where'])) {
            $options['where'] = [];
        } elseif (isset($options['view'])) {
            // 视图查询条件处理
            foreach (['AND', 'OR'] as $logic) {
                if (isset($options['where'][$logic])) {
                    foreach ($options['where'][$logic] as $key => $val) {
                        if (array_key_exists($key, $options['map'])) {
                            $options['where'][$logic][$options['map'][$key]] = $val;
                            unset($options['where'][$logic][$key]);
                        }
                    }
                }
            }

            if (isset($options['order'])) {
                // 视图查询排序处理
                if (is_string($options['order'])) {
                    $options['order'] = explode(',', $options['order']);
                }
                foreach ($options['order'] as $key => $val) {
                    if (is_numeric($key)) {
                        if (strpos($val, ' ')) {
                            list($field, $sort) = explode(' ', $val);
                            if (array_key_exists($field, $options['map'])) {
                                $options['order'][$options['map'][$field]] = $sort;
                                unset($options['order'][$key]);
                            }
                        } elseif (array_key_exists($val, $options['map'])) {
                            $options['order'][$options['map'][$val]] = 'asc';
                            unset($options['order'][$key]);
                        }
                    } elseif (array_key_exists($key, $options['map'])) {
                        $options['order'][$options['map'][$key]] = $val;
                        unset($options['order'][$key]);
                    }
                }
            }
        }

        if (!isset($options['field'])) {
            $options['field'] = '*';
        }

        if (!isset($options['data'])) {
            $options['data'] = [];
        }

        foreach (['master', 'lock', 'fetch_pdo', 'fetch_sql', 'distinct'] as $name) {
            if (!isset($options[$name])) {
                $options[$name] = false;
            }
        }

        foreach (['join', 'union', 'group', 'having', 'limit', 'order', 'force', 'comment'] as $name) {
            if (!isset($options[$name])) {
                $options[$name] = '';
            }
        }

        if (isset($options['page'])) {
            // 根据页数计算limit
            list($page, $listRows) = $options['page'];
            $page                  = $page > 0 ? $page : 1;
            $listRows              = $listRows > 0 ? $listRows : (is_numeric($options['limit']) ? $options['limit'] : 20);
            $offset                = $listRows * ($page - 1);
            $options['limit']      = $offset . ',' . $listRows;
        }

        $this->options = [];
        return $options;
    }
	
    /**
     * 生成查询SQL
     * @access private
     * @param array $options 表达式
     * @return string
     */
    private function builderSelect($options = [])
    {
        $sql = str_replace(
            ['%TABLE%', '%DISTINCT%', '%FIELD%', '%JOIN%', '%WHERE%', '%GROUP%', '%HAVING%', '%ORDER%', '%LIMIT%', '%UNION%', '%LOCK%', '%COMMENT%', '%FORCE%'],
            [
                $this->parseTable($options['table'], $options),
                $this->parseDistinct($options['distinct']),
                $this->parseField($options['field'], $options),
                $this->parseJoin($options['join'], $options),
                $this->parseWhere($options['where'], $options),
                $this->parseGroup($options['group']),
                $this->parseHaving($options['having']),
                $this->parseOrder($options['order'], $options),
                $this->parseLimit($options['limit']),
                $this->parseUnion($options['union']),
                $this->parseLock($options['lock']),
                $this->parseComment($options['comment']),
                $this->parseForce($options['force']),
            ], $this->selectSql);
        return $sql;
    }

    /**
     * 生成insert SQL
     * @access private
     * @param array     $data 数据
     * @param array     $options 表达式
     * @param bool      $replace 是否replace
     * @return string
     */
    private function builderInsert(array $data, $options = [], $replace = false)
    {
        // 分析并处理数据
        $data = $this->parseData($data, $options);
        if (empty($data)) {
            return 0;
        }
        $fields = array_keys($data);
        $values = array_values($data);

        $sql = str_replace(
            ['%INSERT%', '%TABLE%', '%FIELD%', '%DATA%', '%COMMENT%'],
            [
                $replace ? 'REPLACE' : 'INSERT',
                $this->parseTable($options['table'], $options),
                implode(' , ', $fields),
                implode(' , ', $values),
                $this->parseComment($options['comment']),
            ], $this->insertSql);

        return $sql;
    }

    /**
     * 生成insertall SQL
     * @access private
     * @param array     $dataSet 数据集
     * @param array     $options 表达式
     * @param bool      $replace 是否replace
     * @return string
     * @throws Exception
     */
    private function builderInsertAll($dataSet, $options = [], $replace = false)
    {
        // 获取合法的字段
        if ('*' == $options['field']) {
            $fields = array_keys($this->getFieldsType($options['table']));
        } else {
            $fields = $options['field'];
        }

        foreach ($dataSet as &$data) {
            foreach ($data as $key => $val) {
                if (!in_array($key, $fields, true)) {
                    if ($options['strict']) {
                        throw new Exception('fields not exists:[' . $key . ']');
                    }
                    unset($data[$key]);
                } elseif (is_null($val)) {
                    $data[$key] = 'NULL';
                } elseif (is_scalar($val)) {
                    $data[$key] = $this->parseValue($val, $key);
                } elseif (is_object($val) && method_exists($val, '__toString')) {
                    // 对象数据写入
                    $data[$key] = $val->__toString();
                } else {
                    // 过滤掉非标量数据
                    unset($data[$key]);
                }
            }
            $value    = array_values($data);
            $values[] = 'SELECT ' . implode(',', $value);
        }
        $fields = array_map([$this, 'parseKey'], array_keys(reset($dataSet)));
        $sql    = str_replace(
            ['%INSERT%', '%TABLE%', '%FIELD%', '%DATA%', '%COMMENT%'],
            [
                $replace ? 'REPLACE' : 'INSERT',
                $this->parseTable($options['table'], $options),
                implode(' , ', $fields),
                implode(' UNION ALL ', $values),
                $this->parseComment($options['comment']),
            ], $this->insertAllSql);

        return $sql;
    }

    /**
     * 生成select insert SQL
     * @access private
     * @param array     $fields 数据
     * @param string    $table 数据表
     * @param array     $options 表达式
     * @return string
     */
    private function builderSelectInsert($fields, $table, $options)
    {
        if (is_string($fields)) {
            $fields = explode(',', $fields);
        }

        $fields = array_map([$this, 'parseKey'], $fields);
        $sql    = 'INSERT INTO ' . $this->parseTable($table, $options) . ' (' . implode(',', $fields) . ') ' . $this->select($options);
        return $sql;
    }

    /**
     * 生成update SQL
     * @access private
     * @param array     $data 数据
     * @param array     $options 表达式
     * @return string
     */
    private function builderUpdate($data, $options)
    {
        $table = $this->parseTable($options['table'], $options);
        $data  = $this->parseData($data, $options);
        if (empty($data)) {
            return '';
        }
        foreach ($data as $key => $val) {
            $set[] = $key . '=' . $val;
        }

        $sql = str_replace(
            ['%TABLE%', '%SET%', '%JOIN%', '%WHERE%', '%ORDER%', '%LIMIT%', '%LOCK%', '%COMMENT%'],
            [
                $this->parseTable($options['table'], $options),
                implode(',', $set),
                $this->parseJoin($options['join'], $options),
                $this->parseWhere($options['where'], $options),
                $this->parseOrder($options['order'], $options),
                $this->parseLimit($options['limit']),
                $this->parseLock($options['lock']),
                $this->parseComment($options['comment']),
            ], $this->updateSql);

        return $sql;
    }

    /**
     * 生成delete SQL
     * @access private
     * @param array $options 表达式
     * @return string
     */
    private function builderDelete($options)
    {
        $sql = str_replace(
            ['%TABLE%', '%USING%', '%JOIN%', '%WHERE%', '%ORDER%', '%LIMIT%', '%LOCK%', '%COMMENT%'],
            [
                $this->parseTable($options['table'], $options),
                !empty($options['using']) ? ' USING ' . $this->parseTable($options['using'], $options) . ' ' : '',
                $this->parseJoin($options['join'], $options),
                $this->parseWhere($options['where'], $options),
                $this->parseOrder($options['order'], $options),
                $this->parseLimit($options['limit']),
                $this->parseLock($options['lock']),
                $this->parseComment($options['comment']),
            ], $this->deleteSql);

        return $sql;
    }
	

    /**
     * 数据分析
     * @access protected
     * @param array     $data 数据
     * @param array     $options 查询参数
     * @return array
     * @throws Exception
     */
    protected function parseData($data, $options)
    {
        if (empty($data)) {
            return [];
        }

        // 获取绑定信息
        $bind = $this->getFieldsBind($options['table']);
        if ('*' == $options['field']) {
            $fields = array_keys($bind);
        } else {
            $fields = $options['field'];
        }

        $result = [];
        foreach ($data as $key => $val) {
            $item = $this->parseKey($key, $options);
            if (is_object($val) && method_exists($val, '__toString')) {
                // 对象数据写入
                $val = $val->__toString();
            }
            if (false === strpos($key, '.') && !in_array($key, $fields, true)) {
                if ($options['strict']) {
                    throw new Exception('fields not exists:[' . $key . ']');
                }
            } elseif (is_null($val)) {
                $result[$item] = 'NULL';
            } elseif (isset($val[0]) && 'exp' == $val[0]) {
                $result[$item] = $val[1];
            } elseif (is_scalar($val)) {
                // 过滤非标量数据
                if (0 === strpos($val, ':') && $this->isBind(substr($val, 1))) {
                    $result[$item] = $val;
                } else {
                    $key = str_replace('.', '_', $key);
                    $this->bind('data__' . $key, $val, isset($bind[$key]) ? $bind[$key] : PDO::PARAM_STR);
                    $result[$item] = ':data__' . $key;
                }
            }
        }
        return $result;
    }

    /**
     * 字段名分析
     * @access protected
     * @param string $key
     * @param array  $options
     * @return string
     */
    protected function parseKey($key, $options = [])
    {
        return $key;
    }

    /**
     * value分析
     * @access protected
     * @param mixed     $value
     * @param string    $field
     * @return string|array
     */
    protected function parseValue($value, $field = '')
    {
        if (is_string($value)) {
            // $value = strpos($value, ':') === 0 && $this->isBind(substr($value, 1)) ? $value : $this->connection->quote($value);
        } elseif (is_array($value)) {
            $value = array_map([$this, 'parseValue'], $value);
        } elseif (is_bool($value)) {
            $value = $value ? '1' : '0';
        } elseif (is_null($value)) {
            $value = 'null';
        }
        return $value;
    }

    /**
     * field分析
     * @access protected
     * @param mixed     $fields
     * @param array     $options
     * @return string
     */
    protected function parseField($fields, $options = [])
    {
        if ('*' == $fields || empty($fields)) {
            $fieldsStr = '*';
        } elseif (is_array($fields)) {
            // 支持 'field1'=>'field2' 这样的字段别名定义
            $array = [];
            foreach ($fields as $key => $field) {
                if (!is_numeric($key)) {
                    $array[] = $this->parseKey($key, $options) . ' AS ' . $this->parseKey($field, $options);
                } else {
                    $array[] = $this->parseKey($field, $options);
                }
            }
            $fieldsStr = implode(',', $array);
        }
        return $fieldsStr;
    }

    /**
     * table分析
     * @access protected
     * @param mixed $tables
     * @param array $options
     * @return string
     */
    protected function parseTable($tables, $options = [])
    {
        $item = [];
        foreach ((array) $tables as $key => $table) {
            if (!is_numeric($key)) {
                if (strpos($key, '@think')) {
                    $key = strstr($key, '@think', true);
                }
                $key    = $this->parseSqlTable($key);
                $item[] = $this->parseKey($key) . ' ' . (isset($options['alias'][$table]) ? $this->parseKey($options['alias'][$table]) : $this->parseKey($table));
            } else {
                $table = $this->parseSqlTable($table);
                if (isset($options['alias'][$table])) {
                    $item[] = $this->parseKey($table) . ' ' . $this->parseKey($options['alias'][$table]);
                } else {
                    $item[] = $this->parseKey($table);
                }
            }
        }
        return implode(',', $item);
    }

    /**
     * where分析
     * @access protected
     * @param mixed $where   查询条件
     * @param array $options 查询参数
     * @return string
     */
    protected function parseWhere($where, $options)
    {
        $whereStr = $this->buildWhere($where, $options);
        if (!empty($options['soft_delete'])) {
            // 附加软删除条件
            list($field, $condition) = $options['soft_delete'];

            $binds    = $this->getFieldsBind($options['table']);
            $whereStr = $whereStr ? '( ' . $whereStr . ' ) AND ' : '';
            $whereStr = $whereStr . $this->parseWhereItem($field, $condition, '', $options, $binds);
        }
        return empty($whereStr) ? '' : ' WHERE ' . $whereStr;
    }

    /**
     * 生成查询条件SQL
     * @access public
     * @param mixed     $where
     * @param array     $options
     * @return string
     */
    public function buildWhere($where, $options)
    {
        if (empty($where)) {
            $where = [];
        }

        if ($where instanceof Query) {
            return $this->buildWhere($where->getOptions('where'), $options);
        }

        $whereStr = '';
        $binds    = $this->getFieldsBind($options['table']);
        foreach ($where as $key => $val) {
            $str = [];
            foreach ($val as $field => $value) {
                if ($value instanceof \Closure) {
                    // 使用闭包查询
                    $query = new Query($this->connection);
                    call_user_func_array($value, [ & $query]);
                    $whereClause = $this->buildWhere($query->getOptions('where'), $options);
                    if (!empty($whereClause)) {
                        $str[] = ' ' . $key . ' ( ' . $whereClause . ' )';
                    }
                } elseif (strpos($field, '|')) {
                    // 不同字段使用相同查询条件（OR）
                    $array = explode('|', $field);
                    $item  = [];
                    foreach ($array as $k) {
                        $item[] = $this->parseWhereItem($k, $value, '', $options, $binds);
                    }
                    $str[] = ' ' . $key . ' ( ' . implode(' OR ', $item) . ' )';
                } elseif (strpos($field, '&')) {
                    // 不同字段使用相同查询条件（AND）
                    $array = explode('&', $field);
                    $item  = [];
                    foreach ($array as $k) {
                        $item[] = $this->parseWhereItem($k, $value, '', $options, $binds);
                    }
                    $str[] = ' ' . $key . ' ( ' . implode(' AND ', $item) . ' )';
                } else {
                    // 对字段使用表达式查询
                    $field = is_string($field) ? $field : '';
                    $str[] = ' ' . $key . ' ' . $this->parseWhereItem($field, $value, $key, $options, $binds);
                }
            }

            $whereStr .= empty($whereStr) ? substr(implode(' ', $str), strlen($key) + 1) : implode(' ', $str);
        }

        return $whereStr;
    }

    // where子单元分析
    protected function parseWhereItem($field, $val, $rule = '', $options = [], $binds = [], $bindName = null)
    {
        // 字段分析
        $key = $field ? $this->parseKey($field, $options) : '';

        // 查询规则和条件
        if (!is_array($val)) {
            $val = is_null($val) ? ['null', ''] : ['=', $val];
        }
        list($exp, $value) = $val;

        // 对一个字段使用多个查询条件
        if (is_array($exp)) {
            $item = array_pop($val);
            // 传入 or 或者 and
            if (is_string($item) && in_array($item, ['AND', 'and', 'OR', 'or'])) {
                $rule = $item;
            } else {
                array_push($val, $item);
            }
            foreach ($val as $k => $item) {
                $bindName = 'where_' . str_replace('.', '_', $field) . '_' . $k;
                $str[]    = $this->parseWhereItem($field, $item, $rule, $options, $binds, $bindName);
            }
            return '( ' . implode(' ' . $rule . ' ', $str) . ' )';
        }

        // 检测操作符
        if (!in_array($exp, $this->exp)) {
            $exp = strtolower($exp);
            if (isset($this->exp[$exp])) {
                $exp = $this->exp[$exp];
            } else {
                throw new Exception('where express error:' . $exp);
            }
        }
        $bindName = $bindName ?: 'where_' . str_replace(['.', '-'], '_', $field);
        if (preg_match('/\W/', $bindName)) {
            // 处理带非单词字符的字段名
            $bindName = md5($bindName);
        }

        if (is_object($value) && method_exists($value, '__toString')) {
            // 对象数据写入
            $value = $value->__toString();
        }

        $bindType = isset($binds[$field]) ? $binds[$field] : PDO::PARAM_STR;
        if (is_scalar($value) && array_key_exists($field, $binds) && !in_array($exp, ['EXP', 'NOT NULL', 'NULL', 'IN', 'NOT IN', 'BETWEEN', 'NOT BETWEEN']) && strpos($exp, 'TIME') === false) {
            if (strpos($value, ':') !== 0 || !$this->isBind(substr($value, 1))) {
                if ($this->isBind($bindName)) {
                    $bindName .= '_' . str_replace('.', '_', uniqid('', true));
                }
                $this->bind($bindName, $value, $bindType);
                $value = ':' . $bindName;
            }
        }

        $whereStr = '';
        if (in_array($exp, ['=', '<>', '>', '>=', '<', '<='])) {
            // 比较运算
            if ($value instanceof \Closure) {
                $whereStr .= $key . ' ' . $exp . ' ' . $this->parseClosure($value);
            } else {
                $whereStr .= $key . ' ' . $exp . ' ' . $this->parseValue($value, $field);
            }
        } elseif ('LIKE' == $exp || 'NOT LIKE' == $exp) {
            // 模糊匹配
            if (is_array($value)) {
                foreach ($value as $item) {
                    $array[] = $key . ' ' . $exp . ' ' . $this->parseValue($item, $field);
                }
                $logic = isset($val[2]) ? $val[2] : 'AND';
                $whereStr .= '(' . implode($array, ' ' . strtoupper($logic) . ' ') . ')';
            } else {
                $whereStr .= $key . ' ' . $exp . ' ' . $this->parseValue($value, $field);
            }
        } elseif ('EXP' == $exp) {
            // 表达式查询
            $whereStr .= '( ' . $key . ' ' . $value . ' )';
        } elseif (in_array($exp, ['NOT NULL', 'NULL'])) {
            // NULL 查询
            $whereStr .= $key . ' IS ' . $exp;
        } elseif (in_array($exp, ['NOT IN', 'IN'])) {
            // IN 查询
            if ($value instanceof \Closure) {
                $whereStr .= $key . ' ' . $exp . ' ' . $this->parseClosure($value);
            } else {
                $value = array_unique(is_array($value) ? $value : explode(',', $value));
                if (array_key_exists($field, $binds)) {
                    $bind  = [];
                    $array = [];
                    $i     = 0;
                    foreach ($value as $v) {
                        $i++;
                        if ($this->isBind($bindName . '_in_' . $i)) {
                            $bindKey = $bindName . '_in_' . uniqid() . '_' . $i;
                        } else {
                            $bindKey = $bindName . '_in_' . $i;
                        }
                        $bind[$bindKey] = [$v, $bindType];
                        $array[]        = ':' . $bindKey;
                    }
                    $this->bind($bind);
                    $zone = implode(',', $array);
                } else {
                    $zone = implode(',', $this->parseValue($value, $field));
                }
                $whereStr .= $key . ' ' . $exp . ' (' . (empty($zone) ? "''" : $zone) . ')';
            }
        } elseif (in_array($exp, ['NOT BETWEEN', 'BETWEEN'])) {
            // BETWEEN 查询
            $data = is_array($value) ? $value : explode(',', $value);
            if (array_key_exists($field, $binds)) {
                if ($this->isBind($bindName . '_between_1')) {
                    $bindKey1 = $bindName . '_between_1' . uniqid();
                    $bindKey2 = $bindName . '_between_2' . uniqid();
                } else {
                    $bindKey1 = $bindName . '_between_1';
                    $bindKey2 = $bindName . '_between_2';
                }
                $bind = [
                    $bindKey1 => [$data[0], $bindType],
                    $bindKey2 => [$data[1], $bindType],
                ];
                $this->bind($bind);
                $between = ':' . $bindKey1 . ' AND :' . $bindKey2;
            } else {
                $between = $this->parseValue($data[0], $field) . ' AND ' . $this->parseValue($data[1], $field);
            }
            $whereStr .= $key . ' ' . $exp . ' ' . $between;
        } elseif (in_array($exp, ['NOT EXISTS', 'EXISTS'])) {
            // EXISTS 查询
            if ($value instanceof \Closure) {
                $whereStr .= $exp . ' ' . $this->parseClosure($value);
            } else {
                $whereStr .= $exp . ' (' . $value . ')';
            }
        } elseif (in_array($exp, ['< TIME', '> TIME', '<= TIME', '>= TIME'])) {
            $whereStr .= $key . ' ' . substr($exp, 0, 2) . ' ' . $this->parseDateTime($value, $field, $options, $bindName, $bindType);
        } elseif (in_array($exp, ['BETWEEN TIME', 'NOT BETWEEN TIME'])) {
            if (is_string($value)) {
                $value = explode(',', $value);
            }

            $whereStr .= $key . ' ' . substr($exp, 0, -4) . $this->parseDateTime($value[0], $field, $options, $bindName . '_between_1', $bindType) . ' AND ' . $this->parseDateTime($value[1], $field, $options, $bindName . '_between_2', $bindType);
        }
        return $whereStr;
    }

    // 执行闭包子查询
    protected function parseClosure($call, $show = true)
    {
        $query = new Query($this->connection);
        call_user_func_array($call, [ & $query]);
        return $query->buildSql($show);
    }

    /**
     * 日期时间条件解析
     * @access protected
     * @param string    $value
     * @param string    $key
     * @param array     $options
     * @param string    $bindName
     * @param integer   $bindType
     * @return string
     */
    protected function parseDateTime($value, $key, $options = [], $bindName = null, $bindType = null)
    {
        // 获取时间字段类型
        if (strpos($key, '.')) {
            list($table, $key) = explode('.', $key);
            if (isset($options['alias']) && $pos = array_search($table, $options['alias'])) {
                $table = $pos;
            }
        } else {
            $table = $options['table'];
        }
        $type = $this->getTableInfo($table, 'type');
        if (isset($type[$key])) {
            $info = $type[$key];
        }
        if (isset($info)) {
            if (is_string($value)) {
                $value = strtotime($value) ?: $value;
            }

            if (preg_match('/(datetime|timestamp)/is', $info)) {
                // 日期及时间戳类型
                $value = date('Y-m-d H:i:s', $value);
            } elseif (preg_match('/(date)/is', $info)) {
                // 日期及时间戳类型
                $value = date('Y-m-d', $value);
            }
        }
        $bindName = $bindName ?: $key;
        $this->bind($bindName, $value, $bindType);
        return ':' . $bindName;
    }

    /**
     * limit分析
     * @access protected
     * @param mixed $limit
     * @return string
     */
    protected function parseLimit($limit)
    {
        return (!empty($limit) && false === strpos($limit, '(')) ? ' LIMIT ' . $limit . ' ' : '';
    }

    /**
     * join分析
     * @access protected
     * @param array $join
     * @param array $options 查询条件
     * @return string
     */
    protected function parseJoin($join, $options = [])
    {
        $joinStr = '';
        if (!empty($join)) {
            foreach ($join as $item) {
                list($table, $type, $on) = $item;
                $condition               = [];
                foreach ((array) $on as $val) {
                    if (strpos($val, '=')) {
                        list($val1, $val2) = explode('=', $val, 2);
                        $condition[]       = $this->parseKey($val1, $options) . '=' . $this->parseKey($val2, $options);
                    } else {
                        $condition[] = $val;
                    }
                }

                $table = $this->parseTable($table, $options);
                $joinStr .= ' ' . $type . ' JOIN ' . $table . ' ON ' . implode(' AND ', $condition);
            }
        }
        return $joinStr;
    }

    /**
     * order分析
     * @access protected
     * @param mixed $order
     * @param array $options 查询条件
     * @return string
     */
    protected function parseOrder($order, $options = [])
    {
        if (is_array($order)) {
            $array = [];
            foreach ($order as $key => $val) {
                if (is_numeric($key)) {
                    if ('[rand]' == $val) {
                        if (method_exists($this, 'parseRand')) {
                            $array[] = $this->parseRand();
                        } else {
                            throw new BadMethodCallException('method not exists:' . get_class($this) . '-> parseRand');
                        }
                    } elseif (false === strpos($val, '(')) {
                        $array[] = $this->parseKey($val, $options);
                    } else {
                        $array[] = $val;
                    }
                } else {
                    $sort    = in_array(strtolower(trim($val)), ['asc', 'desc']) ? ' ' . $val : '';
                    $array[] = $this->parseKey($key, $options) . ' ' . $sort;
                }
            }
            $order = implode(',', $array);
        }
        return !empty($order) ? ' ORDER BY ' . $order : '';
    }

    /**
     * group分析
     * @access protected
     * @param mixed $group
     * @return string
     */
    protected function parseGroup($group)
    {
        return !empty($group) ? ' GROUP BY ' . $this->parseKey($group) : '';
    }

    /**
     * having分析
     * @access protected
     * @param string $having
     * @return string
     */
    protected function parseHaving($having)
    {
        return !empty($having) ? ' HAVING ' . $having : '';
    }

    /**
     * comment分析
     * @access protected
     * @param string $comment
     * @return string
     */
    protected function parseComment($comment)
    {
        return !empty($comment) ? ' /* ' . $comment . ' */' : '';
    }

    /**
     * distinct分析
     * @access protected
     * @param mixed $distinct
     * @return string
     */
    protected function parseDistinct($distinct)
    {
        return !empty($distinct) ? ' DISTINCT ' : '';
    }

    /**
     * union分析
     * @access protected
     * @param mixed $union
     * @return string
     */
    protected function parseUnion($union)
    {
        if (empty($union)) {
            return '';
        }
        $type = $union['type'];
        unset($union['type']);
        foreach ($union as $u) {
            if ($u instanceof \Closure) {
                $sql[] = $type . ' ' . $this->parseClosure($u, false);
            } elseif (is_string($u)) {
                $sql[] = $type . ' ' . $this->parseSqlTable($u);
            }
        }
        return implode(' ', $sql);
    }

    /**
     * index分析，可在操作链中指定需要强制使用的索引
     * @access protected
     * @param mixed $index
     * @return string
     */
    protected function parseForce($index)
    {
        if (empty($index)) {
            return '';
        }

        if (is_array($index)) {
            $index = join(",", $index);
        }

        return sprintf(" FORCE INDEX ( %s ) ", $index);
    }

    /**
     * 设置锁机制
     * @access protected
     * @param bool|string $lock
     * @return string
     */
    protected function parseLock($lock = false)
    {
        if (is_bool($lock)) {
            return $lock ? ' FOR UPDATE ' : '';
        } elseif (is_string($lock)) {
            return ' ' . trim($lock) . ' ';
        }
    }
	
    /**
     * 根据参数绑定组装最终的SQL语句 便于调试
     * @access public
     * @param string    $sql 带参数绑定的sql语句
     * @param array     $bind 参数绑定列表
     * @return string
     */
    private function getRealSql($sql, array $bind = [])
    {
        if (is_array($sql)) {
            $sql = implode(';', $sql);
        }

        foreach ($bind as $key => $val) {
            $value = is_array($val) ? $val[0] : $val;
            $type  = is_array($val) ? $val[1] : PDO::PARAM_STR;
            // 判断占位符
            $sql = is_numeric($key) ?
            substr_replace($sql, $value, strpos($sql, '?'), 1) :
            str_replace(
                [':' . $key . ')', ':' . $key . ',', ':' . $key . ' ', ':' . $key . PHP_EOL],
                [$value . ')', $value . ',', $value . ' ', $value . PHP_EOL],
                $sql . ' ');
        }
        return rtrim($sql);
    }
	
	/**
	 * [sql 类sql查询]
	 * @param  [String] $sql [类sql语句]
	 * @param  [int] $explain [是否将sql语句转换成DSL，默认否]
	 * @return [array/json]      [具体数据/DSL]
	 */
	public function sql($sql, $explain = 0){
		$param = ($explain === 1)?['type'=>'_explain','sql'=>$sql]:['sql' => $sql];
		$data = $this->client->sql($param);
		return $data;
	}
	
    /**
     * 根据dsl进行查询
     * @access public
     * @param array $dsl
     * @return array
     */
	public function dslSearch($dsl){
		$data = $this->client->search($dsl);
		return $data;
	}
}
