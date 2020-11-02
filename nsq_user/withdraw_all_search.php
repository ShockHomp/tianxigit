<?php
/**
 * 批量修改签约状态轮询  (linux 在开启一个定时任务 防止程序卡死 1小时重启一次)
 **/
//配置文件
//include 'config_haixing.php';
//创建转账日志文件
//echo $fp_log_lyf = fopen(dirname(__FILE__) . '/logs/transfer_account_complete_v6.log', 'ab');
//数据库配置
$GLOBALS['mysql_config'] = [
    'host' => '10.2.8.114',
    'database' => 'tianxi',
    'user' => 'root',
    'password' => '123456',
    'port' => '3306',
    'charset' => 'utf8',
];
$GLOBALS['only'] = 'T';
//天溪app_id
$GLOBALS['app_id'] = '20200114150548';
//key数值
$GLOBALS['key'] = 'ghj4hd9f4g6qa';
//处理条数 （防止info_list 一次处理过多数据）
$GLOBALS['handle_sum'] = '1';
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

do {
    /************************************************处理条数节点start********************/
    //查询处理到的节点判断

    $rowsStartId = $pdo->query('select
           b.bank_num,b.id,b.phone,b.real_name,b.id_card,b.bank_sign_up,b.member_id,b.bank_sign_up,b.order_no
            from base_bankcard b 
          
             order by b.id  asc limit 1')->fetch(PDO::FETCH_ASSOC);


    $rowsMaxId = $pdo->query('select
           b.bank_num,b.id,b.phone,b.real_name,b.id_card,b.bank_sign_up,b.member_id,b.bank_sign_up,b.order_no
            from base_bankcard b 
            where b.bank_sign_up in (2,3) 
            order by b.id desc limit 1 ')->fetch(PDO::FETCH_ASSOC);


    if ($limitAfter >= $rowsMaxId['id']) {

        $limitBefore = $rowsStartId['id']; //轮询

    } else {

        if (!isset($limitBefore)) {
            $limitBefore = $rowsStartId['id'];
        } else {
            $limitBefore += $GLOBALS['handle_sum'];
        }


    }
    $limitAfter = $limitBefore + $GLOBALS['handle_sum'];
    /************************************************处理条数节点end********************/

    try {
        $pdo->beginTransaction();
        //签约
        withdrawBatchSign($pdo, $limitBefore, $limitAfter);
        $pdo->commit();
        sleep(2);//等待时间，进行下一次操作
    } catch (Exception $e) {
        $pdo->rollBack();
        echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
        exit;
    }


} while (true);


function withdrawBatchSign($pdo, $limitBefore, $limitAfter)
{
//    and id_bonus_account between ' . $limitBefore . ' and ' . $limitAfter . '
    //签约 状态 查询
    echo $sql = 'select
           b.bank_num,b.id,b.phone,b.real_name,b.id_card,b.bank_sign_up,b.member_id,b.bank_sign_up,b.order_no
            from base_bankcard b 
            where b.id between ' . $limitBefore . ' and  ' . $limitAfter . ' and b.bank_sign_up in (2)
            order by b.id ';

    $sqlQuery = $pdo->query($sql);
    while ($values = $sqlQuery->fetch(PDO::FETCH_ASSOC)) {
        $arrayAll[] = $values;
    }
    if ($arrayAll) {
        foreach ($arrayAll as $key_a => $info_a) {
            $resultAll[$key_a]['order_no'] = $arrayAll[$key_a]['order_no'];  //唯一查询;签约状态标识
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
        $resultEnd['pay_type'] = 'Wk_Bank';

        ksort($resultEnd, SORT_STRING);
//    var_dump($resultEnd);
        $jsonMd5 = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);

        $sign = md5($jsonMd5);
        $resultEnd['sign'] = $sign;
        $jsonBank = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);

//    var_dump(json_decode($jsonBank, true));
        //调用签约申请接口
        $returnData = postCurls($GLOBALS['pay_address'] . "/order/repay_sign_status", $jsonBank);
        $data_array = json_decode($returnData, true);

        var_dump($data_array);
//    exit;
        if ($data_array['code'] == '00000000' || $data_array['code'] == '00000015') {
            foreach ($data_array['info_list'] as $info_k => $info_v) {
                if (($data_array['info_list'][$info_k]['code'] == '00000000' && $data_array['info_list'][$info_k]['status'] == '2') || ($data_array['info_list'][$info_k]['code'] == '00000015' && $data_array['info_list'][$info_k]['status'] == '3')) {

                    if (!empty($data_array['info_list'][$info_k]['order_no'])) {
                        echo 'update base_bankcard set bank_sign_up=3 where  order_no=' . $data_array['info_list'][$info_k]['order_no'];
                        $priceUseHy = $pdo->exec('update base_bankcard set bank_sign_up=3 where  order_no=' . "'" . $data_array['info_list'][$info_k]['order_no'] . "'");
                    }
                    echo  json_encode(array('bank_sign_up' => 3, 'msg' => '签约成功'),JSON_UNESCAPED_UNICODE);

                } else {
                    echo  json_encode(array('bank_sign_up' => 2, 'msg' => '签约失败'),JSON_UNESCAPED_UNICODE);


                }
            }
        } else {

            echo  json_encode(array('bank_sign_up' => 1, 'msg' => '网络异常,请稍后重试'),JSON_UNESCAPED_UNICODE);

        }

    } else {
        echo '暂无需要处理的数据';
    }


}



