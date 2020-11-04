<?php

// MySQL配置
$mysql_dbms   = 'mysql';      //数据库类型
$mysql_host   = '127.0.0.1';  //数据库主机名
$mysql_dbName = 'gozero';     //使用的数据库
$mysql_user   = 'root';       //数据库连接用户名
$mysql_pass   = '';           //对应的密码
$mysql_dsn    = "{$mysql_dbms}:host={$mysql_host};dbname={$mysql_dbName}";

// Redis配置
$redis_host = '127.0.0.1';
$redis_port = 6379;
$redis_pass = '';

// Memcache配置
$memcache_host = '127.0.0.1';
$memcache_port = 11211;

// MySQL链接测试
echo "-------------------MYSQL-------------------<br/>";

try {
    $dbh = new \PDO($mysql_dsn, $mysql_user, $mysql_pass); //初始化一个PDO对象
    echo "MySQL连接成功<br/>";
    /* 你还可以进行一次搜索操作
    foreach ($dbh->query('SELECT * from FOO') as $row) {
        print_r($row); //你可以用 echo($GLOBAL); 来看到这些值
    }
    */
    $dbh = null;
} catch (PDOException $e) {
    die ("Error!: " . $e->getMessage() . "<br/>");
}
// 默认这个不是长连接，如果需要数据库长连接，需要最后加一个参数：array(PDO::ATTR_PERSISTENT => true) 变成这样：
// $db = new PDO($dsn, $user, $pass, [PDO::ATTR_PERSISTENT => true]);.

// Redis链接测试
echo "-------------------REDIS-------------------<br/>";

try {
    $redis = new \Redis();
    $redis->connect($redis_host, $redis_port);
    $redis->auth($redis_pass);

    echo "Redis连接成功<br/>";

    // 查看服务是否运行
    $ping = $redis->ping('sss');
    echo "Redis服务运行中: {$ping}<br/>";

    $redis_key = 'redis_test_key';
    $redis->set($redis_key, '测试redis成功');
    $r = $redis->get($redis_key);
    $redis->del($redis_key);
    echo "{$r}<br/>";
} catch (\Exception $e) {
    die ("Error!: " . $e->getMessage() . "<br/>");
}

// Memcache连接测试
echo "------------------MEMCACHE-----------------<br/>";

try {
    $memcache = new Memcache();
    $memcache->connect($memcache_host, $memcache_port) or die ("Memcache not connect"); //连接Memcached服务器

    $memcache_key = 'memcache_test_key';
    $memcache->set($memcache_key, '测试memcache成功');   //设置一个变量到内存中，名称是key 值是test
    $m = $memcache->get($memcache_key);   //从内存中取出key的值
    $memcache->delete($memcache_key);
    echo "{$m}<br/>";

} catch (\Exception $e) {
    die ("Error!: " . $e->getMessage() . "<br/>");
}