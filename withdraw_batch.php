<?php
/**
 * 代付
 **/
//配置文件
//include 'config_haixing.php';
error_reporting(E_ERROR | E_WARNING | E_PARSE);
set_time_limit ( 0 );
require_once './init.php';
require_once FRAMEWORK_PATH . '/library/common.lib.php';
require_once FRAMEWORK_PATH . '/library/functions.lib.php';
load_module_config ( 'account' ); //加载配置文件
$Ip=$GLOBALS ['account_settings'] ['mc_server'] ['default'] ['ip'];
//创建提现日志文件
$fp_log_lyf = fopen(dirname(dirname(__FILE__)) . '/data/withdraw_batch.log', 'ab');
//数据库配置
//$GLOBALS['mysql_config'] = [
//    'host' => $Ip,
//    'database' => 'tianxi',
//    'user' => 'lnyo',
//    'password' => 'Qwe102030.@!.@!',
//    'port' => '3306',
//    'charset' => 'utf8',
//];
//$GLOBALS['redis_config'] = [
//    'host' => $Ip,
//    'port' => '6379',
//    'pass' => '',
//    'database' => 3,
//];
////实例化redis
$GLOBALS['redis'] = new Redis();
////连接
$GLOBALS['redis']->connect($GLOBALS['redis_config']['host'], $GLOBALS['redis_config']['port']);
$GLOBALS['redis']->auth($GLOBALS['redis_config']['pass']);
$GLOBALS['redis']->select($GLOBALS['redis_config']['database']);

$GLOBALS['only'] = 'T';
//天溪app_id
$GLOBALS['app_id'] = '20200114150548';
//key数值
$GLOBALS['key'] = 'ghj4hd9f4g6qa';
$GLOBALS['pay_address'] = 'http://test.dingmei.net';
//$GLOBALS['pay_address'] = 'http://10.1.37.126:11180';
try {
    //连接数据库
    $dsn = "mysql:host=" . $GLOBALS['mysql_config']['host'] . ";port=" . $GLOBALS['mysql_config']['port'] . ";dbname=" . $GLOBALS['mysql_config']['database'] . ";charset=" . $GLOBALS['mysql_config']['charset'] . "";
    $GLOBALS['db'] = new PDO($dsn, $GLOBALS['mysql_config']['user'], $GLOBALS['mysql_config']['password']);

} catch (PDOException $e) {
    echo " Failed: " . $e->getMessage();
}
$pdo = $GLOBALS['db'];


//$pdo->exec('set autocommit = 0'); //（采用共享锁 lock in share mode）

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

$redisData=$_POST;
//        var_dump($redisData);exit;
//    $redisWithdraw = $GLOBALS['redis']->lpush('withdraw_batch', json_encode($redisData));
//var_dump($GLOBALS['redis']->lpop('withdraw_sign'));exit;
try {
    $pdo->beginTransaction();
//    $pdo->begin();
//    if ($GLOBALS['redis']->lpop('withdraw_sign')) {
//        //如果有redis（withdraw_sign） 证明脚本先执行
//        echo '1';
//        exit;
//    } else {
//        withdrawBatch($pdo, $redisData); //批量(选中)
//    }
    withdrawBatch($pdo,$redisData,$fp_log_lyf); //批量(选中)

    $pdo->commit();
//        sleep(1);
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
    exit;
}


function withdrawBatch($pdo,$redisData,$fp_log_lyf)
{
    //内部支付返回结果response_data
    $returnData = '';

//        原始SQL集合
//    $arrayAll = [];
    //处理后的SQL集合
//    $resultAll = [];
    //提现表id (tx_live_withdraw)$redisData['id'];
//    echo $redisData['status']; exit;  //测试

    $withdrawIds = explode(',', $redisData['withdraw_id']);
    foreach ($withdrawIds as $withdraw_id_v) {
//        echo $redisData['status'];
//提现生成提现日志表(tx_live_withdraw_log) 作为之后的 代付接口的唯一标识 order_no

        //执行批量提现 代付接口
//        $strWithDrawLog = 'insert into `tx_live_withdraw_log` (`withdraw_id`,`admin_id`,`status`,`reason`,`c_time`)  values(:withdraw_id, :admin_id, :status, :reason, :c_time)';
//        $stmWithDrawLog = $pdo->prepare($strWithDrawLog);
//        $stmWithDrawLog->bindValue(':withdraw_id', $withdraw_id_v, PDO::PARAM_INT);
//        $stmWithDrawLog->bindValue(':admin_id', $redisData['admin_id'], PDO::PARAM_INT); //ADMIN_ID 为 $_SESSION['admin_id']
//        $stmWithDrawLog->bindValue(':status',$redisData['status'] , PDO::PARAM_STR);
//        $stmWithDrawLog->bindValue(':reason', $redisData['reason'], PDO::PARAM_STR);
//        $stmWithDrawLog->bindValue(':c_time', time(), PDO::PARAM_INT);

        $strWithDrawLog1 = 'insert into `tx_live_withdraw_log`(`withdraw_id`,`admin_id`,`status`,`reason`,`c_time`)
     values(' . $withdraw_id_v . ',' . $redisData['admin_id'] . ',1' . ',' . "'" . $redisData['reason'] . "'" . ',' . time() . ')';
//
        $stmWithDrawLog = $pdo->prepare($strWithDrawLog1);

        if ($stmWithDrawLog->execute() === false) {
            $pdo->rollBack();
            exit;
        }



        $lastId[] = (int)$pdo->lastInsertId();


    }

//    exit;
//    var_dump($lastId);


    //查询提现所需参数
//  w.status=1 待提现

//status=4 处理中
    $sql = 'select
           w.id,w.price,w.status,
           m.login_name,m.member_id,
           b.bank_num,b.id,b.phone,b.real_name,b.id_card
            from tx_live_withdraw w 
            left join base_member m on m.member_id=w.member_id  
            left join base_bankcard b on b.member_id=w.member_id
            where  w.status in (1) and w.id in (' . $redisData['withdraw_id'] . ')  order by b.id desc lock in share mode';

    $sqlQuery = $pdo->query($sql);
    while ($values = $sqlQuery->fetch(PDO::FETCH_ASSOC)) {
        $arrayAll[] = $values;
    }
    if(empty($arrayAll)){
        echo '4';
        exit;
    }
//    print_r($arrayAll);
//    echo '等待提现中......';
    foreach ($arrayAll as $key_a => $info_a) {

        $resultAll[$key_a]['account_number'] = $arrayAll[$key_a]['bank_num'];
//        $resultAll[$key_a]['account_number'] = '6210810730006088489';
        $resultAll[$key_a]['amount'] = (string)($arrayAll[$key_a]['price'] * 100);
        $resultAll[$key_a]['id_card'] = $arrayAll[$key_a]['id_card'];
        $resultAll[$key_a]['mobile_no'] = $arrayAll[$key_a]['phone'];
        $resultAll[$key_a]['order_no'] = (string)($GLOBALS['only'] . $lastId[$key_a]); //订单号(不能重复 全局唯一,提交失败后也不能重复)
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
    $resultEnd['timestamp'] = (string)time();
    ksort($resultEnd, SORT_STRING);
    $jsonMd5 = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
//    var_dump($jsonMd5); exit;
    $sign = md5($jsonMd5);
    $resultEnd['sign'] = $sign;
    $jsonBank = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
//    var_dump($jsonBank);

//    var_dump(json_decode($jsonBank, true)); exit;
    //调用代付接口
    $returnData = postCurls($GLOBALS['pay_address'] . "/order/repay", $jsonBank);

    //返回数据
    $data_array = json_decode($returnData, true);
//    $data_array = '{
//    "code": "00000000",
// "msg": "aaaaaa",
// "info_list": [{
//        "order_no": "T353",
//  "code": "00000000",
//  "msg": "aaaaaa"
// }]
//}';

//    var_dump($data_array);
//     exit;
    //(代付接口结果返回处理) (//积分提现)

    if ($data_array['code'] == '00000000') {
        foreach ($data_array['info_list'] as $info_k => $info_v) {
            //先查询该用户基本信息 （member_id）
            $baseMemberSql = 'select  m.member_id,m.red_packet_balance,m.shell_balance ,
              w.source_type,w.price,w.withdraw_way,w.id
             from base_member m,tx_live_withdraw w,tx_live_withdraw_log wl
             where  m.member_id=w.member_id and w.id=wl.withdraw_id and wl.id=' . substr($data_array['info_list'][$info_k]['order_no'], strripos($data_array['info_list'][$info_k]['order_no'], $GLOBALS['only']) + 1);
            $baseMemberSelect = $pdo->query($baseMemberSql)->fetch(PDO::FETCH_ASSOC);
//            print_r($baseMemberSelect['member_id']);
            //查找原表中积分
             $memberSql = 'select price,price_freeze from tx_task_member where member_id=' . $baseMemberSelect['member_id'] . ' lock in share mode  ';

//            if ($GLOBALS['redis']->lpop('withdraw_sign')) {
//                //如果有redis（withdraw_sign） 证明脚本先执行
//                echo '1';
//                exit;
//            }else{}
                $member_credit = $pdo->query($memberSql)->fetch(PDO::FETCH_ASSOC);

            //进行每一条提现记录判断
            if ($data_array['info_list'][$info_k]['code'] == '00000000') {

                //代表成功(修改提现状态)tx_live_withdraw 还原冻结积分
                $status = 2;
                $account_price = $baseMemberSelect['price']; //到账金额
                $type = 4;
                $memo = '提现成功';
                $returnReturn = '1'; // 结果返回
                //还原(tx_task_member) price_freeze 冻结 积分  //修改积分(原来海星总数)
                $priceUseHy = $pdo->exec('update tx_task_member set price_freeze=' . bcsub($member_credit['price_freeze'], $baseMemberSelect['price'], 2) . ' where member_id= ' . $baseMemberSelect['member_id']);
                if ($priceUseHy == 0) {
                    $pdo->rollBack();
                    exit;
                }


            } else {
                //失败 返还积分。
                $status = 3;
                $account_price = 0;
                $type = 3;
                $memo = '提现失败';
                $returnReturn = '3';
                //还原(tx_task_member) price,price_freeze
                $priceHy = $pdo->exec('update tx_task_member set price_freeze=' . bcsub($member_credit['price_freeze'], $baseMemberSelect['price'], 2) . ', price= ' . bcadd($member_credit['price'], $baseMemberSelect['price'], 2) . ' where member_id= ' . $baseMemberSelect['member_id']);
                if ($priceHy == 0) {
                    $pdo->rollBack();
                    exit;
                }


            }
            //插入（tx_live_credit_log 表）source_type 1 红包 2贝壳 3积分
//            echo 'source_type=' . $baseMemberSelect['source_type'];
            if ($baseMemberSelect['source_type'] == '3') {
                //=============================插入 tx_live_credit_log(表数据)
                $strLiveCreditLog = 'insert into `tx_live_credit_log` (`anchor_id`,`credit_num`,`type`,`withdraw_way`,`c_time`)  values(:anchor_id, :credit_num, :type, :withdraw_way, :c_time)';
                $stmLiveCreditLog = $pdo->prepare($strLiveCreditLog);
                $stmLiveCreditLog->bindValue(':anchor_id', $baseMemberSelect['member_id'], PDO::PARAM_INT);
                $stmLiveCreditLog->bindValue(':credit_num', $baseMemberSelect['price'], PDO::PARAM_STR); //ADMIN_ID 为 $_SESSION['admin_id']
                $stmLiveCreditLog->bindValue(':type', $type, PDO::PARAM_INT); //类别：1.直播打赏 2.提现 3.提现退回 4.提现成功
                $stmLiveCreditLog->bindValue(':withdraw_way', $baseMemberSelect['withdraw_way'], PDO::PARAM_STR); //提现方式：1.微信 2.支付宝（type-2/3）4.银行卡（新增）
                $stmLiveCreditLog->bindValue(':c_time', time(), PDO::PARAM_INT);
                if ($stmLiveCreditLog->execute() === false) {
                    $pdo->rollBack();
                    exit;
                }


            }
//                if ($baseMemberSelect['source_type'] == '1') {
//                    //=============================插入 tx_live_packet_log(表数据)
//                    $strLivePacketLog = 'insert into `tx_live_packet_log` (`member_id`,`price`,`type`,`withdraw_way`,`c_time`)  values(:member_id, :price, :type, :withdraw_way, :c_time)';
//                    $stmLivePacketLog = $pdo->prepare($strLivePacketLog);
//                    $stmLivePacketLog->bindValue(':member_id', $baseMemberSelect['member_id'], PDO::PARAM_INT);
//                    $stmLivePacketLog->bindValue(':price', $baseMemberSelect['price'], PDO::PARAM_STR); //ADMIN_ID 为 $_SESSION['admin_id']
//                    $stmLivePacketLog->bindValue(':type', 3, PDO::PARAM_INT); //类别：1.领红包 2.提现 3.提现退回
//                    $stmLivePacketLog->bindValue(':withdraw_way', $baseMemberSelect['withdraw_way'], PDO::PARAM_STR); //提现方式：1.微信 2.支付宝（type-2/3）4.银行卡（新增）
//                    $stmLivePacketLog->bindValue(':c_time', time(), PDO::PARAM_INT);
//                    if ($stmLivePacketLog->execute() === false) {
//                        $pdo->rollBack();
//                        exit;
//                    }
//                    $redPacketUpdate = "update base_member set red_packet_balance = red_packet_balance + '{$baseMemberSelect['price']}' where member_id = '{$baseMemberSelect['member_id']}'";
//                    $UpdateRedupdate = $pdo->exec($redPacketUpdate);
//
//
//                }


            //记录 tx_starfish_log（原海星表）积分变动日志记录
            //查询（人民币/积分） 比例
            $creditConfig = "select name_com from tx_credit_config where name ='人民币/积分'" ;
            $creditConfigSelect = $pdo->query($creditConfig)->fetch(PDO::FETCH_ASSOC);
//            var_dump(explode(':',$creditConfigSelect['name_com']));
            if(empty($creditConfigSelect)){
                $creditbl=$baseMemberSelect['price']*100;
            }else{
                list($rmbE,$creditE) = explode(':',$creditConfigSelect['name_com']);
                $creditbl = ($baseMemberSelect['price']/$rmbE)*$creditE;
            }

            $strFreeze2 = 'insert into `tx_starfish_log`(`member_id`,`invite_member_id`,`type`,`channel`,`gear`,`price`,`title`,`create_time`) values(:member_id, :invite_member_id, :type, :channel, :gear, :price, :title, :create_time)';
            $stmFreeze2 = $GLOBALS['db']->prepare($strFreeze2);
            $stmFreeze2->bindValue(':member_id', $baseMemberSelect['member_id'], PDO::PARAM_INT);
            $stmFreeze2->bindValue(':invite_member_id', 0, PDO::PARAM_INT);
            $stmFreeze2->bindValue(':type', 7, PDO::PARAM_INT); // 7提现
            $stmFreeze2->bindValue(':channel', 0, PDO::PARAM_STR);
            $stmFreeze2->bindValue(':gear', 0, PDO::PARAM_STR);
            $stmFreeze2->bindValue(':price', '-' . $creditbl, PDO::PARAM_STR);
//            $stmFreeze2->bindValue(':price', '-' . $baseMemberSelect['price'], PDO::PARAM_STR);
            $stmFreeze2->bindValue(':title', $memo, PDO::PARAM_STR);
            $stmFreeze2->bindValue(':create_time', time(), PDO::PARAM_STR);

            if ($stmFreeze2->execute() === false) {
                $pdo->rollBack();
                exit;
            }
            //修改提现表和提现日志表的状态(tx_live_withdraw tx_live_withdraw_log) status 2提现成功 3提现失败
            $withdrawUpdate = 'update tx_live_withdraw w ,tx_live_withdraw_log wl set  w.account_price= ' . $account_price . ' , w.status= ' . $status . ' , w.deal_time= ' . time() . '  where w.id=wl.withdraw_id and wl.id=' . substr($data_array['info_list'][$info_k]['order_no'], strripos($data_array['info_list'][$info_k]['order_no'], $GLOBALS['only']) + 1);
            $UpdateWithdraw = $pdo->exec($withdrawUpdate);
            if ($UpdateWithdraw == 0) {
                $pdo->rollBack();
                exit;
            }
            //提现成功或失败 log tx_live_withdraw_log
            $strWithDrawLogYesNo = 'insert into `tx_live_withdraw_log` (`withdraw_id`,`admin_id`,`status`,`reason`,`c_time`)  values(:withdraw_id, :admin_id, :status, :reason, :c_time)';
            $stmWithDrawLogYesNo = $pdo->prepare($strWithDrawLogYesNo);
            $stmWithDrawLogYesNo->bindValue(':withdraw_id', $baseMemberSelect['id'], PDO::PARAM_INT);
            $stmWithDrawLogYesNo->bindValue(':admin_id', $redisData['admin_id'], PDO::PARAM_INT); //ADMIN_ID 为 $_SESSION['admin_id']
            $stmWithDrawLogYesNo->bindValue(':status', $status, PDO::PARAM_INT);
            $stmWithDrawLogYesNo->bindValue(':reason', $memo, PDO::PARAM_STR);
            $stmWithDrawLogYesNo->bindValue(':c_time', time(), PDO::PARAM_INT);
            if ($stmWithDrawLogYesNo->execute() === false) {
                $pdo->rollBack();
                exit;
            }


        }

//        echo '代码底层';
        echo $returnReturn;

    } else {
        //内部代付接口报 echo '4';
        echo '4';

    }
    //添加日志文件
    $logs = array(
        'withdraw_id' => $redisData['withdraw_id'],
        'admin_id' => $redisData['admin_id'],
        'return' => $returnData,
        'memo' => '提现日志记录'
    );
    fwrite($fp_log_lyf, date("Y-m-d H:i:s") . "tx_live_withdraw_log表提现" . json_encode($logs, JSON_UNESCAPED_UNICODE) . PHP_EOL);


}



