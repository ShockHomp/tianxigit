<?php
/**
 * 转账
 **/
//配置文件
include 'config_haixing.php';
//创建转账日志文件
echo $fp_log_lyf = fopen(dirname(__FILE__) . '/logs/transfer_account_complete_v6.log', 'ab');

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
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);//严格校验
    curl_setopt($ch, CURLOPT_HEADER, FALSE);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_POST, TRUE);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}

//积分发放操作


//转账 3小时一执行，
$haveRowsId = false; //判断初始id_bonus_account

do {

    echo date("Y-m-d H:i:s") . '间隔时间' . $GLOBALS['transfer_time'] . PHP_EOL;

    transAction($pdo, $fp_log_lyf);

    sleep($GLOBALS['transfer_time']);//等待时间，进行下一次操作


} while (true);


function transAction($pdo, $fp_log_lyf)
{

//    原始SQL集合
    $arrayAll = [];
    //处理后的SQL集合
    $resultAll = [];

    $sql = ' select 
            u3.wechat_openid,u3.wechat_name,u3.wechat_merchantid,u3.wechat_id,u3.alipay_name,u3.alipay_openid,u3.alipay_userid,u3.alipay_id,
            ba.id_user,ba.id_bonus_account,ba.type,ba.id_order,ba.withdraw_status,ba.credit,
            o.pay_type_sync,o.sn,o.pay_sn_sync
            from cms_bonus_account ba 
            left join  cms_order o on ba.id_order=o.id_order 
            left join cms_user u on ba.id_user=u.id_user 
            left join cms_bonus b on ba.id_bonus=b.id_bonus 
            left join cms_user_3rd u3 on u.id_user=u3.id_user  
            where  ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['split_status'] . ') ) and ba.is_calc=2 and ba.is_need_calc=2 and ba.reason=1 order  by ba.id_user asc ';

    $limitSplitAccount = $pdo->query($sql);

    while ($values = $limitSplitAccount->fetch(PDO::FETCH_ASSOC)) {
        $arrayAll[] = $values;
    }

    foreach ($arrayAll as $key_a => $info_a) {
        $resultAll[$info_a['id_user']][] = $info_a;
    }

    //计算相同id_user credit的和
    foreach ($resultAll as $key_r => $info_r) {
        $item = [];
        foreach ($info_r as $key_rr => $info_rr) {
            //将credit 相加
            if (!isset($item[$info_rr['id_user']])) {
                $item[$info_rr['id_user']] = $info_rr['credit'];
            } else {
                $item[$info_rr['id_user']] += $info_rr['credit'];
            }

        }
        $resultAll[$key_r]['credit_split_total'] = $item;
    }


    foreach ($resultAll as $key_r_e => $info_r_e) {

        //支付type类型
        $type = '';
        //记录日日志
        $bonusAccountId = [];
        $orderPaySn = [];

        //获取二维数组中最后一个数组即（creditSum）
        $creditSplitTotal = array_pop($resultAll[$key_r_e]);
        echo $creditSplitTotal[$key_r_e]; //需要转账的金额（数据库中）
        $valueChange['credit_split_total'] = bcmul($creditSplitTotal[$key_r_e], 100, 0);//需要转账的金额(分)
        $basicInfo = array_shift($resultAll[$key_r_e]);

        /***********************************冻结账户-start***************************************/
        try {
            $pdo->beginTransaction();
            //转账金额为(分)

            $userCreditSql = 'select credit,freeze  from cms_credit where id_user=' . $basicInfo['id_user'] . ' lock in share mode  ';
            $user_credit = $pdo->query($userCreditSql)->fetch(PDO::FETCH_ASSOC);
            //冻结金额 update
            $up1Sql = 'update cms_credit set credit=' . bcsub($user_credit['credit'], $creditSplitTotal[$key_r_e], 2) . ',freeze=' . bcadd($user_credit['freeze'], $creditSplitTotal[$key_r_e], 2) . ' where id_user= ' . $basicInfo['id_user'];
            $up1 = $pdo->exec($up1Sql);
            if ($up1 == 0) {
                $pdo->rollBack();
                exit;
            }
            //credit1积分变动日志记录
            $strCredit1 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
            $stmCredit1 = $GLOBALS['db']->prepare($strCredit1);
            $stmCredit1->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
            $stmCredit1->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
            $stmCredit1->bindValue(':account', 1, PDO::PARAM_INT);
            $stmCredit1->bindValue(':type', 10, PDO::PARAM_INT); //10 为冻结type
            $stmCredit1->bindValue(':amount', '-' . $creditSplitTotal[$key_r_e], PDO::PARAM_STR);
            $stmCredit1->bindValue(':remain', $user_credit['credit'], PDO::PARAM_STR);
            $stmCredit1->bindValue(':status', 2, PDO::PARAM_INT);
            $stmCredit1->bindValue(':status_time', time(), PDO::PARAM_INT);
            $stmCredit1->bindValue(':create_time', time(), PDO::PARAM_INT);
            $stmCredit1->bindValue(':memo', '用户冻结 提现' . $basicInfo['pay_sn_sync'], PDO::PARAM_STR);
            $stmCredit1->bindValue(':is_sync', 1, PDO::PARAM_INT);
            $stmCredit1->bindValue(':sync_time', 0, PDO::PARAM_STR);

            if ($stmCredit1->execute() === false) {
                $pdo->rollBack();
                exit;
            }

            //freeze1积分变动日志记录
            $strFreeze1 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
            $stmFreeze1 = $GLOBALS['db']->prepare($strFreeze1);
            $stmFreeze1->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
            $stmFreeze1->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
            $stmFreeze1->bindValue(':account', 2, PDO::PARAM_INT);
            $stmFreeze1->bindValue(':type', 10, PDO::PARAM_INT); //10 为冻结type
            $stmFreeze1->bindValue(':amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR);
            $stmFreeze1->bindValue(':remain', $user_credit['freeze'], PDO::PARAM_STR);
            $stmFreeze1->bindValue(':status', 2, PDO::PARAM_INT);
            $stmFreeze1->bindValue(':status_time', time(), PDO::PARAM_INT);
            $stmFreeze1->bindValue(':create_time', time(), PDO::PARAM_INT);
            $stmFreeze1->bindValue(':memo', '用户冻结 提现' . $basicInfo['pay_sn_sync'], PDO::PARAM_STR);
            $stmFreeze1->bindValue(':is_sync', 1, PDO::PARAM_INT);
            $stmFreeze1->bindValue(':sync_time', 0, PDO::PARAM_STR);

            if ($stmFreeze1->execute() === false) {
                $pdo->rollBack();
                exit;
            }

            $uniqueId = (int)$pdo->lastInsertId();
            $pdo->commit();
        } catch (Exception $e) {
            $pdo->rollBack();
            echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
            exit;
        }

        /***********************************冻结账户-end***************************************/

        //设置是否真正走的微信内部支付标识
        $haveWxPay = true;
        //设置是否真正走的支付宝内部支付标识
        $haveAliPay = true;
        //判断失败结果(脚本内部)
        $resonWxFailed = array();
        //判断支付返回结果(内部支付)
        $data_array = array();
        //内部支付返回结果response_data
        $returnData = '';

        //如果该用户有绑定支付处理
        try {
            $pdo->beginTransaction();
            if (!empty($basicInfo['wechat_openid']) || !empty($basicInfo['alipay_openid'])) {
                //起初判断该订单微信还是支付宝
                if ((int)$basicInfo['pay_type_sync'] == 1) {
                    //微信支付
                    echo '支付类型wx';
                    if (!empty($basicInfo['wechat_openid'])) {
                        $type = 3;
                        //查看每人每天的(微信转账次数 10，和金额数 5000)是否超过上限
                        $start = mktime(0, 0, 0, date("m"), date("d"), date("Y"));//当天开始时间戳
                        $end = mktime(23, 59, 59, date("m"), date("d"), date("Y"));//当天结束时间戳
                        bcmul($basicInfo['credit_split_total'], 100, 0);
                        $sqlLimit = 'select count(id_user) as counts,sum(amount) as amountTotal   from cms_withdraw where id_user=' . $basicInfo['id_user'] . ' and type in (3) and status=6 and create_time between ' . $start . ' and ' . $end;
                        $user_wx_transfer_limit = $pdo->query($sqlLimit)->fetch(PDO::FETCH_ASSOC);
                        if ((int)$user_wx_transfer_limit['count'] < 9 && (int)bcmul($user_wx_transfer_limit['amountTotal'], 100, 0) <= 500000 && (int)$valueChange['credit_split_total'] >= 30 && bcadd(bcmul($user_wx_transfer_limit['amountTotal'], 100, 0), $valueChange['credit_split_total'], 2) <= 500000) {
                            $jsonWxTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "WeChat_NATIVE",
                                        "order_no": "' . $basicInfo['pay_sn_sync'] . '",
                                        "info_list": [{
                                         "open_id": "' . $basicInfo['wechat_openid'] . '",
                                          "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                          "real_name":"' . $basicInfo['wechat_name'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $uniqueId . '",  
                                         "desc": "商品分享佣金",
                                        
                                         
                               }]
                            }';

                            echo date("Y-m-d H:i:s") . '微信转账' . $jsonWxTransfer;
                            //调用内部支付宝转账接口
                            $returnData = postCurls($GLOBALS['pay_address'] . "/order/enterprise_payment", $jsonWxTransfer);
                            //返回数据
                            $data_array = json_decode($returnData, true);
                            //添加一个支付宝转账的返回标识  （为后续如果增加支付宝转账限制做准备(目前微信分账和支付宝转账,调用内部支付后，处理逻辑一致)）
                            $data_array['data'][0]['signsign'] = 'wx_transfer';
                            var_dump($data_array);

                        } else {
                            //记录内部限制
                            $haveWxPay = false;
                            $resonWxFailed['count'] = $user_wx_transfer_limit['count'];
                            $resonWxFailed['amountTotal'] = $user_wx_transfer_limit['amountTotal'];
                            $resonWxFailed['credit_split_total'] = (int)$valueChange['credit_split_total'];

                        }

                    } elseif (!empty($value['alipay_openid'])) {
                        $type = 6;
                        //支付宝转账 （最小金额10分）
                        if ((int)$valueChange['credit_split_total'] >= 10) {

                            $jsonAliTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "AliPay_App",
                                        "order_no": "' . $GLOBALS['only'] . $uniqueId . '",
                                        "activity_name": "商品分享佣金",
                                        "desc": "商品分享佣金",
                                        "info_list": [{
                                         "account_number": "' . $basicInfo['alipay_openid'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $uniqueId . '",  
                                         "account_type": "ALIPAY_LOGON_ID",
                                         "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                         "real_name":"' . $basicInfo['alipay_name'] . '"
                               }]
                            }';
                            echo date("Y-m-d H:i:s") . '支付宝转账' . $jsonAliTransfer;
                            //调用内部支付宝转账接口
                            $returnData = postCurls($GLOBALS['pay_address'] . "/order/enterprise_payment", $jsonAliTransfer);
                            //返回数据
                            $data_array = json_decode($returnData, true);
                            //添加一个支付宝转账的返回标识  （为后续如果增加支付宝转账限制做准备(目前微信分账和支付宝转账,调用内部支付后，处理逻辑一致)）
                            $data_array['data'][0]['signsign'] = 'ali_transfer';
                            var_dump($data_array);


                        } else {
                            //记录内部限制
                            $haveAliPay = false;


                        }
                    }


                } elseif ((int)$basicInfo['pay_type_sync'] == 2) {
                    echo '支付类型ali';
                    if (!empty($basicInfo['alipay_openid'])) {
                        $type = 6;
                        if ((int)$valueChange['credit_split_total'] >= 10) {
                            $jsonAliTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "AliPay_App",
                                        "order_no": "' . $GLOBALS['only'] . $uniqueId . '",
                                        "activity_name": "商品分享佣金",
                                        "desc": "商品分享佣金",
                                        "info_list": [{
                                         "account_number": "' . $basicInfo['alipay_openid'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $uniqueId . '",  
                                         "account_type": "ALIPAY_LOGON_ID",
                                         "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                         "real_name":"' . $basicInfo['alipay_name'] . '"
                               }]
                            }';
                            echo date("Y-m-d H:i:s") . '支付宝转账' . $jsonAliTransfer;
                            //调用内部支付宝转账接口
                            $returnData = postCurls($GLOBALS['pay_address'] . "/order/enterprise_payment", $jsonAliTransfer);
                            //返回数据
                            $data_array = json_decode($returnData, true);
                            //添加一个支付宝转账的返回标识  （为后续如果增加支付宝转账限制做准备(目前微信分账和支付宝转账,调用内部支付后，处理逻辑一致)）
                            $data_array['data'][0]['signsign'] = 'ali_transfer';
                            var_dump($data_array);
                        } else {
                            //记录内部限制
                            $haveAliPay = false;


                        }

                    } elseif (!empty($basicInfo['wechat_openid'])) {
                        $type = 3;
                        //查看每人每天的(微信转账次数 10，和金额数 5000)是否超过上限
                        $start = mktime(0, 0, 0, date("m"), date("d"), date("Y"));//当天开始时间戳
                        $end = mktime(23, 59, 59, date("m"), date("d"), date("Y"));//当天结束时间戳
                        bcmul($basicInfo['credit_split_total'], 100, 0);
                        $sqlLimit = 'select count(id_user) as counts,sum(amount) as amountTotal   from cms_withdraw where id_user=' . $basicInfo['id_user'] . ' and type in (3) and status=6 and create_time between ' . $start . ' and ' . $end;

                        $user_wx_transfer_limit = $pdo->query($sqlLimit)->fetch(PDO::FETCH_ASSOC);
                        if ((int)$user_wx_transfer_limit['count'] < 9 && (int)bcmul($user_wx_transfer_limit['amountTotal'], 100, 0) <= 500000 && (int)$valueChange['credit_split_total'] >= 30 && bcadd(bcmul($user_wx_transfer_limit['amountTotal'], 100, 0), $valueChange['credit_split_total'], 2) <= 500000) {
                            $jsonWxTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "WeChat_NATIVE",
                                        "order_no": "' . $basicInfo['pay_sn_sync'] . '",
                                        "info_list": [{
                                         "open_id": "' . $basicInfo['wechat_openid'] . '",
                                          "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                          "real_name":"' . $basicInfo['wechat_name'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $uniqueId . '",  
                                         "desc": "商品分享佣金",
                                        
                                         
                               }]
                            }';

                            echo date("Y-m-d H:i:s") . '微信转账' . $jsonWxTransfer;
                            //调用内部支付宝转账接口
                            $returnData = postCurls($GLOBALS['pay_address'] . "/order/enterprise_payment", $jsonWxTransfer);
                            //返回数据
                            $data_array = json_decode($returnData, true);
                            //添加一个支付宝转账的返回标识  （为后续如果增加支付宝转账限制做准备(目前微信分账和支付宝转账,调用内部支付后，处理逻辑一致)）
                            $data_array['data'][0]['signsign'] = 'wx_transfer';
                            var_dump($data_array);

                        } else {
                            //记录内部限制
                            $haveWxPay = false;
                            $resonWxFailed['count'] = $user_wx_transfer_limit['count'];
                            $resonWxFailed['amountTotal'] = $user_wx_transfer_limit['amountTotal'];
                            $resonWxFailed['credit_split_total'] = (int)$valueChange['credit_split_total'];

                        }


                    }
                }


            } else {
                //无绑定支付类型
                //直接处理，将withdraw_status 改为5
                foreach ($info_r_e as $key_rr_e => $info_rr_e) {
                    if ($key_rr_e !== 'credit_split_total') {
                        $noAccountUpdate = 'update cms_bonus_account ba  set  withdraw_status=5 where id_bonus_account=' . $info_rr_e['id_bonus_account'];
                        echo $noAccountUpdate;
                        $accountBonusUpdate = $pdo->exec($noAccountUpdate);

                    }

                }
                //记录没绑定信息日志
                fwrite($fp_log_lyf, date("Y-m-d H:i:s") . "无绑定任何支付的id_user:" . $basicInfo['id_user'] . PHP_EOL);
            }
            $pdo->commit();
        } catch (Exception $e) {
            $pdo->rollBack();
            echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
            exit;
        }

        try {
            $pdo->beginTransaction();
            if (!empty($type)) {
                ##########################################插入cms_withdraw 和cms_withdraw_detail 表数据 start##################################
                //记录 cms_withdraw 表
                $withdrawInsert = 'insert into `cms_withdraw`(`sn`,`id_user`,`method`,`type`,`credit_type`,`amount`,`fee`,`account_amount`,`create_time`,`status`,`status_time`,`wechat_name`,`wechat_account`,`alipay_name`,`alipay_account`,`back_reason`,`bank`,`person`,`card`,`contact`,`account_bank`,`address`,`try_times`,`last_try_time`,`response_data`) values(:sn,:id_user,:method,:type,:credit_type,:amount,:fee,:account_amount,:create_time,:status,:status_time,:wechat_name,:wechat_account,:alipay_name,:alipay_account,:back_reason,:bank,:person,:card,:contact,:account_bank,:address,:try_times,:last_try_time,:response_data)';
                $stmWithdraw = $GLOBALS['db']->prepare($withdrawInsert);
                $stmWithdraw->bindValue(':sn', date('YmdHis') . rand('100000', '999999'), PDO::PARAM_STR);
                $stmWithdraw->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
                $stmWithdraw->bindValue(':method', 2, PDO::PARAM_INT); //1 手动 2自动
                $stmWithdraw->bindValue(':type', $type, PDO::PARAM_INT); //1 //微信分账 3 //微信转账 4 //支付宝分账 6 //支付宝转账 （默认1走微信分账）
                $stmWithdraw->bindValue(':credit_type', 1, PDO::PARAM_STR);// 1积分 2海星积分
                $stmWithdraw->bindValue(':amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR); //金额 (分账的积分)
                $stmWithdraw->bindValue(':fee', 0, PDO::PARAM_STR); //手续费
                $stmWithdraw->bindValue(':account_amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR); //到账金额
                $stmWithdraw->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmWithdraw->bindValue(':status', 1, PDO::PARAM_INT); //1待处理 3打回 6成功
                $stmWithdraw->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmWithdraw->bindValue(':wechat_name', $basicInfo['wechat_name'], PDO::PARAM_STR);//微信姓名
                $stmWithdraw->bindValue(':wechat_account', $basicInfo['wechat_openid'], PDO::PARAM_STR); //微信账号（openid)
                $stmWithdraw->bindValue(':alipay_name', $basicInfo['alipay_name'], PDO::PARAM_STR); //支付宝姓名
                $stmWithdraw->bindValue(':alipay_account', $basicInfo['alipay_openid'], PDO::PARAM_STR);//支付宝账号（openid）
                $stmWithdraw->bindValue(':back_reason', '', PDO::PARAM_STR);//打回原因
                $stmWithdraw->bindValue(':bank', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':person', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':card', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':contact', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':account_bank', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':address', '', PDO::PARAM_STR);
                $stmWithdraw->bindValue(':try_times', '', PDO::PARAM_INT);
                $stmWithdraw->bindValue(':last_try_time', '', PDO::PARAM_INT);
                $stmWithdraw->bindValue(':response_data', '', PDO::PARAM_STR);
                if ($stmWithdraw->execute() == false) {
                    $pdo->rollBack();
                    exit;
                }
                $idWithdraw = (int)$pdo->lastInsertId();

                //记录 cms_withdraw_change_log 表
                $withdrawLogInsert = 'insert into `cms_withdraw_change_log`(`id_withdraw`,`sn`,`id_user`,`method`,`type`,`credit_type`,`amount`,`fee`,`account_amount`,`create_time`,`status`,`status_time`,`wechat_name`,`wechat_account`,`alipay_name`,`alipay_account`,`back_reason`,`bank`,`person`,`card`,`contact`,`account_bank`,`address`,`try_times`,`last_try_time`,`response_data`) values(:id_withdraw,:sn,:id_user,:method,:type,:credit_type,:amount,:fee,:account_amount,:create_time,:status,:status_time,:wechat_name,:wechat_account,:alipay_name,:alipay_account,:back_reason,:bank,:person,:card,:contact,:account_bank,:address,:try_times,:last_try_time,:response_data)';
                $stmWithdrawLog = $GLOBALS['db']->prepare($withdrawLogInsert);
                $stmWithdrawLog->bindValue(':id_withdraw', $idWithdraw, PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':sn', date('YmdHis') . rand('100000', '999999'), PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':method', 2, PDO::PARAM_INT); //1 手动 2自动
                $stmWithdrawLog->bindValue(':type', $type, PDO::PARAM_INT); //1 //微信分账 3 //微信转账 4 //支付宝分账 6 //支付宝转账 （默认1走微信分账）
                $stmWithdrawLog->bindValue(':credit_type', 1, PDO::PARAM_STR);// 1积分 2海星积分
                $stmWithdrawLog->bindValue(':amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR); //金额 (分账的积分)
                $stmWithdrawLog->bindValue(':fee', 0, PDO::PARAM_STR); //手续费
                $stmWithdrawLog->bindValue(':account_amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR); //到账金额
                $stmWithdrawLog->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':status', 1, PDO::PARAM_INT); //1待处理 3打回 6成功
                $stmWithdrawLog->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':wechat_name', $basicInfo['wechat_name'], PDO::PARAM_STR);//微信姓名
                $stmWithdrawLog->bindValue(':wechat_account', $basicInfo['wechat_openid'], PDO::PARAM_STR); //微信账号（openid)
                $stmWithdrawLog->bindValue(':alipay_name', $basicInfo['alipay_name'], PDO::PARAM_STR); //支付宝姓名
                $stmWithdrawLog->bindValue(':alipay_account', $basicInfo['alipay_openid'], PDO::PARAM_STR);//支付宝账号（openid）
                $stmWithdrawLog->bindValue(':back_reason', '', PDO::PARAM_STR);//打回原因
                $stmWithdrawLog->bindValue(':bank', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':person', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':card', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':contact', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':account_bank', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':address', '', PDO::PARAM_STR);
                $stmWithdrawLog->bindValue(':try_times', '', PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':last_try_time', '', PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':response_data', '', PDO::PARAM_STR);

                if ($stmWithdrawLog->execute() == false) {
                    $pdo->rollBack();
                    exit;
                }

                foreach ($info_r_e as $key_rr_e => $info_rr_e) {

                    if ($key_rr_e !== 'credit_split_total') {
                        $withdrawDetailInsert = 'insert into `cms_withdraw_detail`(`id_withdraw`,`relation_id_order`,`relation_id_bonus_account`,`bind_bonus_account_type`,`order_pay_sn`,`amount`) values(:id_withdraw,:relation_id_order,:relation_id_bonus_account,:bind_bonus_account_type,:order_pay_sn,:amount)';
                        $stmWithdrawDetail = $GLOBALS['db']->prepare($withdrawDetailInsert);
                        $stmWithdrawDetail->bindValue(':id_withdraw', $idWithdraw, PDO::PARAM_STR);
                        $stmWithdrawDetail->bindValue(':relation_id_order', $info_rr_e['id_order'], PDO::PARAM_STR);
                        $stmWithdrawDetail->bindValue(':relation_id_bonus_account', $info_rr_e['id_bonus_account'], PDO::PARAM_STR);
                        $stmWithdrawDetail->bindValue(':bind_bonus_account_type', $info_rr_e['type'], PDO::PARAM_STR);
                        $stmWithdrawDetail->bindValue(':order_pay_sn', $info_rr_e['pay_sn_sync'], PDO::PARAM_STR);
                        $stmWithdrawDetail->bindValue(':amount', $info_rr_e['credit'], PDO::PARAM_STR); //金额 (转账的积分)

                        echo $info_rr_e['id_bonus_account'] . PHP_EOL;


                        if ($stmWithdrawDetail->execute() === false) {
                            $pdo->rollBack();
                            exit;
                        }
                    }

                }


                ##########################################插入cms_withdraw 和cms_withdraw_detail 表数据 end##################################

            }
            $pdo->commit();
        } catch (Exception $e) {
            $pdo->rollBack();
            echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
            exit;
        }
        /***************************************(内部支付返回处理分账/转账，成功/失败 ，处理逻辑-start)***********************************************/
        try {
            $pdo->beginTransaction();
            if (!empty($type)) {
                if ($data_array['code'] == '00000000' && $data_array['data'][0]['code'] == '00000000') {
                    echo '成功';
                    var_dump($data_array['code']);
                    //修改cms_bonus_account表中withdraw_status=2
                    foreach ($info_r_e as $key_rr_e => $info_rr_e) {
                        if ($key_rr_e !== 'credit_split_total') {
                            $noAccountUpdate = 'update cms_bonus_account ba  set  withdraw_status=2 where id_bonus_account=' . $info_rr_e['id_bonus_account'];
                            $accountBonusUpdate = $pdo->exec($noAccountUpdate);
                        }
                    }
//                需要将cms_credit 表中的数据freeze还原（锁住）
                    $user_credit_weixin_personal_success = $pdo->query('select credit,freeze  from cms_credit where id_user=' . $basicInfo['id_user'] . ' lock in share mode  ')->fetch(PDO::FETCH_ASSOC);
                    //还原freeze 积分
                    $freezeHy = $pdo->exec('update cms_credit set freeze=' . bcsub($user_credit_weixin_personal_success['freeze'], $creditSplitTotal[$key_r_e], 2) . ' where id_user= ' . $basicInfo['id_user']);
                    if ($freezeHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录freeze2积分变动日志记录
                    $strFreeze2 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                    $stmFreeze2 = $GLOBALS['db']->prepare($strFreeze2);
                    $stmFreeze2->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':account', 2, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':type', 7, PDO::PARAM_INT); //7提现成功
                    $stmFreeze2->bindValue(':amount', '-' . $creditSplitTotal[$key_r_e], PDO::PARAM_STR);
                    $stmFreeze2->bindValue(':remain', $user_credit_weixin_personal_success['freeze'], PDO::PARAM_STR);
                    $stmFreeze2->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmFreeze2->bindValue(':memo', '微信个人转账成功,提现' . $basicInfo['pay_sn_sync'], PDO::PARAM_STR);
                    } else {
                        $stmFreeze2->bindValue(':memo', '支付宝转账成功,提现' . $basicInfo['pay_sn_sync'], PDO::PARAM_STR);
                    }

                    $stmFreeze2->bindValue(':is_sync', 1, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':sync_time', 0, PDO::PARAM_STR);

                    if ($stmFreeze2->execute() === false) {
                        $pdo->rollBack();
                        exit;
                    }
                    //修改cms_withdraw status状态 back_reason，response_data

                    $up2 = $pdo->exec('update cms_withdraw set  status=6, create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                    if ($up2 == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    $up3 = $pdo->exec('update cms_withdraw_change_log set status=6, create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                    if ($up3 == 0) {
                        $pdo->rollBack();
                        exit;
                    }


                } else {
                    echo '失败';
                    switch (true) {
                        //内部限制
                        case $haveAliPay === false :
                            $status = 19; //'小于支付宝最低转账限制';
                            break;
                        case (int)$resonWxFailed['count'] >= 9 :
                            $status = 16; //'超过每天最大转账次数';
                            break;
                        case (int)$resonWxFailed['credit_split_total'] < 30 && (!empty($resonWxFailed['credit_split_total'])):
                            $status = 17; //'小于微信转账最低限制';
                            break;
                        case (int)bcmul($resonWxFailed['amountTotal'], 100, 0) > 500000 || bcadd(bcmul($resonWxFailed['amountTotal'], 100, 0), $resonWxFailed['credit_split_total'], 2) > 500000:
                            $status = 18; //'超过微信转账最高限制';
                            break;
                        //支付内部限制
                        case  (int)$data_array['data'][0]['code'] == '00000001':
                            $status = 20;//系统异常 内部错误!
                            break;
                        case $data_array['data'][0]['code'] == '00000018':
                            $status = 26;//本订单号重复
                            break;
                        case $data_array['data'][0]['msg'] == '微信用户姓名与实名不一致':
                            $status = 29;//微信用户姓名与实名不一致
                            break;
                        case $data_array['data'][0]['msg'] == '订单号不合法':
                            $status = 30;//订单号不合法
                            break;
                        case $data_array['data'][0]['msg'] == 'OPENID不合法':
                            $status = 31;//OPENID不合法
                            break;
                        case (int)$data_array['data'][0]['code'] == '04000001':
                            $status = 32;//收款用户不存在
                            break;

                        default:
                            $status = 3; //打回

                    }
                    //0930 新增 !empty($data_array['data'][0]['code']) 为了防止调用时间过长，或者网络原因，内部支付返回空
                    if (!empty($data_array['data'][0]['signsign']) && !empty($data_array['data'][0]['code'])) {
                        // 代表(走了真正的内部支付接口返回错误问题)微信转账/支付宝转账失败(修改cms_bonus_account表中withdraw_status=3)
                        foreach ($info_r_e as $key_rr_e => $info_rr_e) {
                            if ($key_rr_e !== 'credit_split_total') {
                                $noAccountUpdate = 'update cms_bonus_account ba  set  withdraw_status=3 where id_bonus_account=' . $info_rr_e['id_bonus_account'];
                                $accountBonusUpdate = $pdo->exec($noAccountUpdate);
                            }
                        }
                    }
//                需要将cms_credit 表中的数据freeze还原（锁住）
                    $user_credit_weixin_personal_fail = $pdo->query('select credit,freeze  from cms_credit where id_user=' . $basicInfo['id_user'] . ' lock in share mode  ')->fetch(PDO::FETCH_ASSOC);

                    //还原freeze 积分
                    $freezeHy = $pdo->exec('update cms_credit set freeze=' . bcsub($user_credit_weixin_personal_fail['freeze'], $creditSplitTotal[$key_r_e], 2) . ' where id_user= ' . $basicInfo['id_user']);
                    if ($freezeHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //还原credit 积分
                    $creditHy = $pdo->exec('update cms_credit set credit=' . bcadd($user_credit_weixin_personal_fail['credit'], $creditSplitTotal[$key_r_e], 2) . ' where id_user= ' . $basicInfo['id_user']);
                    if ($creditHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录freeze3积分变动日志记录
                    $strFreeze3 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                    $stmFreeze3 = $GLOBALS['db']->prepare($strFreeze3);
                    $stmFreeze3->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':account', 2, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':type', 11, PDO::PARAM_INT); //11 解冻 自动提现退回
                    $stmFreeze3->bindValue(':amount', '-' . $creditSplitTotal[$key_r_e], PDO::PARAM_STR);
                    $stmFreeze3->bindValue(':remain', $user_credit_weixin_personal_fail['freeze'], PDO::PARAM_STR);
                    $stmFreeze3->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        $stmFreeze3->bindValue(':memo', '支付宝转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } elseif ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmFreeze3->bindValue(':memo', '微信转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } else {
                        switch (true) {

                            case (int)$resonWxFailed['count'] >= 9 :
                                $memo = '超过每天最大转账次数:';
                                break;
                            case (int)$resonWxFailed['credit_split_total'] < 30 :
                                $memo = '小于微信转账最低限制:';
                                break;
                            default:
                                $memo = '超过微信转账最高限制:';

                        }
                        if ($haveAliPay === false) {
                            $memo = '小于支付宝最低转账限制:';
                        }
                        $stmFreeze3->bindValue(':memo', $memo . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);

                    }
                    $stmFreeze3->bindValue(':is_sync', 1, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':sync_time', 0, PDO::PARAM_STR);

                    if ($stmFreeze3->execute() === false) {
                        $pdo->rollBack();
                        exit;
                    }

                    //credit3积分变动日志记录
                    $strCredit3 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                    $stmCredit3 = $GLOBALS['db']->prepare($strCredit3);
                    $stmCredit3->bindValue(':id_user', $basicInfo['id_user'], PDO::PARAM_INT);
                    $stmCredit3->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':account', 1, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':type', 11, PDO::PARAM_INT); //11 解冻 自动提现退回
                    $stmCredit3->bindValue(':amount', $creditSplitTotal[$key_r_e], PDO::PARAM_STR);
                    $stmCredit3->bindValue(':remain', $user_credit_weixin_personal_fail['credit'], PDO::PARAM_STR);
                    $stmCredit3->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmCredit3->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        $stmCredit3->bindValue(':memo', '支付宝转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } elseif ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmCredit3->bindValue(':memo', '微信转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } else {


                        switch (true) {
                            case (int)$resonWxFailed['count'] >= 9  :
                                $memo = '超过每天最大转账次数:';
                                break;
                            case (int)$resonWxFailed['credit_split_total'] < 30 :
                                $memo = '小于微信转账最低限制:';
                                break;
                            default:
                                $memo = '超过微信转账最高限制:';


                        }

                        if ($haveAliPay === false) {
                            $memo = '小于支付宝最低转账限制';
                        }
                        $stmCredit3->bindValue(':memo', $memo . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);


                    }

                    $stmCredit3->bindValue(':is_sync', 1, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':sync_time', 0, PDO::PARAM_STR);

                    if ($stmCredit3->execute() === false) {
                        $pdo->rollBack();
                        exit;
                    }
                    //修改cms_withdraw 表 status 失败原因
                    if (!empty($data_array['data'][0]['signsign'])) {

                        $up6 = $pdo->exec('update cms_withdraw set  status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up6 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up7 = $pdo->exec('update cms_withdraw_change_log set  status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up7 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                    } else {
                        switch (true) {
                            case (int)$resonWxFailed['count'] >= 9  :
                                $memo = '超过每天最大转账次数:';
                                break;
                            case (int)$resonWxFailed['credit_split_total'] < 30 :
                                $memo = '小于微信转账最低限制:';
                                break;
                            default:
                                $memo = '超过微信转账最高限制:';


                        }

                        if ($haveAliPay === false) {
                            $memo = '小于支付宝最低转账限制';
                        }
                        $up10 = $pdo->exec('update cms_withdraw set  status=' . $status . ',create_time=' . time() . ',back_reason="' . $memo . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up10 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up11 = $pdo->exec('update cms_withdraw_change_log set  status=' . $status . ',create_time=' . time() . ',back_reason="' . $memo . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up11 == 0) {
                            $pdo->rollBack();
                            exit;
                        }

                    }


                }
            }

            $pdo->commit();
        } catch (Exception $e) {
            $pdo->rollBack();
            echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
            exit;
        }
        /***************************************(内部支付返回处理分账/转账，成功/失败 ，处理逻辑-end)***********************************************/

        if (!empty($type)) {
            $cms_withdraw_logs = $pdo->query('select id_user,type ,method , credit_type,amount, status,create_time,wechat_name,wechat_account,alipay_name,alipay_account,back_reason,response_data from cms_withdraw_change_log where id_withdraw=' . $idWithdraw)->fetch(PDO::FETCH_ASSOC);
            $logs = array(
                'id_user' => $cms_withdraw_logs['id_user'],
                'type' => $cms_withdraw_logs['type'],
                'method' => $cms_withdraw_logs['method'],
                'credit_type' => $cms_withdraw_logs['credit_type'],
                'amount' => $cms_withdraw_logs['amount'],
                'status' => $cms_withdraw_logs['status'],
                'create_time' => $cms_withdraw_logs['create_time'],
                'wechat_name' => $cms_withdraw_logs['wechat_name'],
                'wechat_account' => $cms_withdraw_logs['wechat_account'],
                'alipay_name' => $cms_withdraw_logs['alipay_name'],
                'alipay_account' => $cms_withdraw_logs['alipay_account'],
                'back_reason' => $cms_withdraw_logs['back_reason'],
                'response_data' => $cms_withdraw_logs['response_data'],
                'memo' => '提现(转账)日志记录'
            );
            $cms_withdraw_detail_logs = $pdo->query('select relation_id_bonus_account,order_pay_sn from cms_withdraw_detail where id_withdraw=' . $idWithdraw);
            while ($v_bonus_account_id = $cms_withdraw_detail_logs->fetch(PDO::FETCH_ASSOC)) {
                $bonusAccountId[] = $v_bonus_account_id['relation_id_bonus_account'];
                $orderPaySn[] = $v_bonus_account_id['order_pay_sn'];
            }
            $logs['relation_id_bonus_account'] = implode(',', $bonusAccountId);
            $logs['SN'] = implode(',', $orderPaySn);
            fwrite($fp_log_lyf, date("Y-m-d H:i:s") . "cms_withdraw_change_log表提现" . json_encode($logs, JSON_UNESCAPED_UNICODE) . PHP_EOL);
        }


    }


}



