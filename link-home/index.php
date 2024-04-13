<?php
$file_content = file(__DIR__ . '/links.txt');

// 连接到Redis
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

// 选择第二个数据库
$redis->select(15);

// 获取完整的URL
$scheme = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
$host = $_SERVER['HTTP_HOST'];
$path = $_SERVER['REQUEST_URI'];
$url = $scheme . "://" . $host . $path;

// 检查Redis中是否存在这个url的数据
if($redis->exists($url)) {
    // 从Redis获取数据并显示
    echo $redis->get($url);
} else {
    // 如果Redis中没有数据，从文件中随机选择500条并保存到Redis
    $random_keys = array_rand($file_content, 1500);
    $data = "";
    foreach($random_keys as $key) {
        $data .= nl2br($file_content[$key]);
    }
    
    // 保存数据到Redis，并设置过期时间为2小时
    $redis->setex($url, 2 * 60 * 60, $data);

    // 显示数据
    echo $data;
}
?>
