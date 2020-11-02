<?php
/**
 * 签约申请
 * 请求传参说明 列 $_POST = array(
                    'member_id' => '123456',
                    'bank_num' => '6227000735210638213'
                    );
//返回说明 bank_sign_up=3 就证明已经签约成功，不要再点击了，2 签约申请发送成功（和短信发送成功一样） 1 签约申请发送失败，重试
 **/
//配置文件
//include 'config_haixing.php';
//创建转账日志文件
//echo $fp_log_lyf = fopen(dirname(__FILE__) . '/logs/transfer_account_complete_v6.log', 'ab');
//数据库配置
$GLOBALS['mysql_config'] = [
    'host' => '',
    'database' => '192.168.105.84',
    'user' => 'root',
    'password' => 'Qwe102030.@!.@!',
    'port' => '3306',
    'charset' => 'utf8',
];
$GLOBALS['only'] = 'T';
//天溪app_id
$GLOBALS['app_id'] = '20200114150548';
//key数值
$GLOBALS['key'] = 'ghj4hd9f4g6qa';
$GLOBALS['pay_address'] = 'http://test.dingmei.net';
try {
    //连接数据库
    $dsn = "mysql:host=" . $GLOBALS['mysql_config']['host'] . ";port=" . $GLOBALS['mysql_config']['port'] . ";dbname=" . $GLOBALS['mysql_config']['database'] . ";charset=" . $GLOBALS['mysql_config']['charset'] . "";
    $GLOBALS['db'] = new PDO($dsn, $GLOBALS['mysql_config']['user'], $GLOBALS['mysql_config']['password']);

} catch (PDOException $e) {
    echo " Failed: " . $e->getMessage();
}
$pdo = $GLOBALS['db'];

$pdo->exec('set autocommit = 0'); //（采用共享锁 lock in share mode）

function postCurls($url, $json)
{
    $ch = curl_init();
    // 设置超时
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);//严格校验
    // 设置header
    curl_setopt($ch, CURLOPT_HEADER, FALSE);
    // 要求结果为字符串且输出到屏幕上
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    // post提交方式
    curl_setopt($ch, CURLOPT_POST, TRUE);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    // 运行curl
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}

//需要 member_id  银行卡号
//$_POST['member_id'];
//$_POST['bank_num'];
//$_POST = array(
//    'member_id' => '123456',
//    'bank_num' => '6227000735210638213'
//);
if(empty($_POST)){
    echo '请用post请求,并传指定参数 例如:';
    var_dump(array(
        'member_id' => '123456',
        'bank_num' => '6227000735210638213'
    ));
    exit;
}
try {
    $pdo->beginTransaction();
    //签约
    withdrawBatchSign($pdo);

    $pdo->commit();
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
    exit;
}


function withdrawBatchSign($pdo)
{

    //签约查询
     $sql = 'select
           b.bank_num,b.id,b.phone,b.real_name,b.id_card,b.bank_sign_up,b.member_id,b.bank_sign_up,b.order_no
            from base_bankcard b 
            where b.member_id=' . $_POST['member_id'] . ' and b.bank_num=' . $_POST['bank_num'] . '
            order by b.id desc';

    $sqlQuery = $pdo->query($sql);
    while ($values = $sqlQuery->fetch(PDO::FETCH_ASSOC)) {
        $arrayAll[] = $values;
    }
    foreach ($arrayAll as $key_a => $info_a) {

        if ($arrayAll[$key_a]['bank_sign_up'] == 3) {
            echo json_encode(array('bank_sign_up' => $arrayAll[$key_a]['bank_sign_up'], 'msg' => '已经签约成功'),JSON_UNESCAPED_UNICODE);
            exit;
        }

        $resultAll[$key_a]['account_number'] = $arrayAll[$key_a]['bank_num'];
        $resultAll[$key_a]['id_card'] = $arrayAll[$key_a]['id_card'];
        $resultAll[$key_a]['mobile_no'] = $arrayAll[$key_a]['phone'];
        $resultAll[$key_a]['pay_type'] = 'Wk_Bank';
        $resultAll[$key_a]['real_name'] = $arrayAll[$key_a]['real_name'];
        if (!isset($sort)) {
            $sort = 1;
        } else {
            $sort++;
        }
        $resultAll[$key_a]['sort'] = (string)$sort;

    }
    $resultEnd['app_id'] = $GLOBALS['app_id'];
    $resultEnd['info_list'] = array_values($resultAll);
    $resultEnd['key'] = $GLOBALS['key'];
    ksort($resultEnd, SORT_STRING);
    $jsonMd5 = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
    $sign = md5($jsonMd5);
    $resultEnd['sign'] = $sign;
    $jsonBank = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
//    var_dump($jsonBank);
//    var_dump(json_decode($jsonBank, true));
    //调用签约申请接口
    $returnData = postCurls($GLOBALS['pay_address'] . "/order/repay_sign", $jsonBank);
    $data_array = json_decode($returnData, true);

//    var_dump($data_array);
    if ($data_array['code'] == '00000000') {
        foreach ($data_array['info_list'] as $info_k => $info_v) {
            if ($data_array['info_list'][$info_k]['code'] == '00000000') {
//                发送签约申请成功 （修改为 bank_sign_up =2 签约中）
                if (!empty($data_array['info_list'][$info_k]['order_no'])) {
                    $priceUseHy = $pdo->exec('update base_bankcard set bank_sign_up=2 where member_id= ' . $_POST['member_id'] . 'and bank_num=' . $_POST['bank_num'] . ' and order_no=' . $data_array['info_list'][$info_k]['order_no']);
                }
                echo json_encode(array('bank_sign_up' => 2, 'msg' => '签约申请发送成功'),JSON_UNESCAPED_UNICODE);
                exit;
            } else {
                echo json_encode(array('bank_sign_up' => 1, 'msg' => '签约申请发送失败，请稍后重试'),JSON_UNESCAPED_UNICODE);

                exit;
            }
        }
    } else {
        echo json_encode(array('bank_sign_up' => 1, 'msg' => '网络异常签约申请发送失败，请稍后重试'),JSON_UNESCAPED_UNICODE);
        exit;
    }


}



