<?php
/**
 * 转账
 **/
header("Content-Type: text/html;charset=utf-8");
error_reporting(E_ALL || ~E_NOTICE);
set_time_limit(0);
//配置文件
include 'config_haixing.php';
//创建转账日志文件
echo $fp_log_lyf = fopen(dirname(__FILE__) . '/logs/transfer_account_complete_v2.log', 'ab');

try {
    //连接数据库
    $dsn = "mysql:host=" . $GLOBALS['mysql_config']['host'] . ";port=" . $GLOBALS['mysql_config']['port'] . ";dbname=" . $GLOBALS['mysql_config']['database'] . ";charset=" . $GLOBALS['mysql_config']['charset'] . "";
    $GLOBALS['db'] = new PDO($dsn, $GLOBALS['mysql_config']['user'], $GLOBALS['mysql_config']['password']);

} catch (PDOException $e) {
    echo " Failed: " . $e->getMessage();
}
$pdo = $GLOBALS['db'];

$pdo->exec('set autocommit = 0'); //（采用共享锁 lock in share mode）
//$pdo->exec(' SET GLOBAL innodb_lock_wait_timeout=120'); //设置锁最大时间 默认为50
//采用post_curl
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
    $sql = ' select count(ba.id_bonus_account) as counts,
            u3.wechat_openid,u3.wechat_name,u3.wechat_merchantid,u3.wechat_id,u3.alipay_name,u3.alipay_openid,u3.alipay_userid,u3.alipay_id,
            ba.id_user,ba.id_bonus_account,ba.type,ba.id_order,ba.withdraw_status,
            o.pay_type_sync,o.sn,o.pay_sn_sync,
            sum( ba.credit) as credit_split_total ,max(id_bonus_account) as max_id_bonus_account 
            from cms_bonus_account ba ,cms_order o,cms_user u,cms_bonus b,cms_user_3rd u3  
            where ba.id_order=o.id_order and ba.id_user=u.id_user and ba.id_bonus=b.id_bonus and u.id_user=u3.id_user and ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['split_status'] . ') ) and ba.is_calc=2 and ba.is_need_calc=2 and ba.reason=1 group by ba.id_user';

    $limitSplitAccount = $pdo->query($sql);

    while ($value = $limitSplitAccount->fetch(PDO::FETCH_ASSOC)) {

        //统计 relation_id_bonus_account（记录log）
        $bonusAccountId = [];
        $orderPaySn = [];
        if ($value['credit_split_total'] > 0) {
            try {
                $pdo->beginTransaction();
                //转账金额为
                $valueChange['credit_split_total'] = bcmul($value['credit_split_total'], 100, 0);
                $user_credit = $pdo->query('select credit,freeze  from cms_credit where id_user=' . $value['id_user'] . ' lock in share mode  ')->fetch(PDO::FETCH_ASSOC);
                //冻结金额 update
                $up1 = $pdo->exec('update cms_credit set credit=' . bcsub($user_credit['credit'], $value['credit_split_total'], 2) . ',freeze=' . bcadd($user_credit['freeze'], $value['credit_split_total'], 2) . ' where id_user= ' . $value['id_user']);
                if ($up1 == 0) {
                    $pdo->rollBack();
                    exit;
                }
                //credit1积分变动日志记录
                $strCredit1 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                $stmCredit1 = $GLOBALS['db']->prepare($strCredit1);
                $stmCredit1->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                $stmCredit1->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                $stmCredit1->bindValue(':account', 1, PDO::PARAM_INT);
                $stmCredit1->bindValue(':type', 10, PDO::PARAM_INT); //10 为冻结type
                $stmCredit1->bindValue(':amount', '-' . $value['credit_split_total'], PDO::PARAM_STR);
                $stmCredit1->bindValue(':remain', $user_credit['credit'], PDO::PARAM_STR);
                $stmCredit1->bindValue(':status', 2, PDO::PARAM_INT);
                $stmCredit1->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmCredit1->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmCredit1->bindValue(':memo', '用户冻结 提现' . $value['pay_sn_sync'], PDO::PARAM_STR);
                $stmCredit1->bindValue(':is_sync', 1, PDO::PARAM_INT);
                $stmCredit1->bindValue(':sync_time', 0, PDO::PARAM_STR);

                if ($stmCredit1->execute() === false) {
                    $pdo->rollBack();
                    exit;
                }
                //freeze1积分变动日志记录
                $strFreeze1 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                $stmFreeze1 = $GLOBALS['db']->prepare($strFreeze1);
                $stmFreeze1->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                $stmFreeze1->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                $stmFreeze1->bindValue(':account', 2, PDO::PARAM_INT);
                $stmFreeze1->bindValue(':type', 10, PDO::PARAM_INT); //10 为冻结type
                $stmFreeze1->bindValue(':amount', $value['credit_split_total'], PDO::PARAM_STR);
                $stmFreeze1->bindValue(':remain', $user_credit['freeze'], PDO::PARAM_STR);
                $stmFreeze1->bindValue(':status', 2, PDO::PARAM_INT);
                $stmFreeze1->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmFreeze1->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmFreeze1->bindValue(':memo', '用户冻结 提现' . $value['pay_sn_sync'], PDO::PARAM_STR);
                $stmFreeze1->bindValue(':is_sync', 1, PDO::PARAM_INT);
                $stmFreeze1->bindValue(':sync_time', 0, PDO::PARAM_STR);

                if ($stmFreeze1->execute() === false) {
                    $pdo->rollBack();
                    exit;
                }


                ##########################################插入cms_withdraw 和cms_withdraw_detail 表数据 start##################################
                //记录 cms_withdraw 表
                $withdrawInsert = 'insert into `cms_withdraw`(`sn`,`id_user`,`method`,`type`,`credit_type`,`amount`,`fee`,`account_amount`,`create_time`,`status`,`status_time`,`wechat_name`,`wechat_account`,`alipay_name`,`alipay_account`,`back_reason`,`bank`,`person`,`card`,`contact`,`account_bank`,`address`,`try_times`,`last_try_time`,`response_data`) values(:sn,:id_user,:method,:type,:credit_type,:amount,:fee,:account_amount,:create_time,:status,:status_time,:wechat_name,:wechat_account,:alipay_name,:alipay_account,:back_reason,:bank,:person,:card,:contact,:account_bank,:address,:try_times,:last_try_time,:response_data)';
                $stmWithdraw = $GLOBALS['db']->prepare($withdrawInsert);
                $stmWithdraw->bindValue(':sn', date('YmdHis') . rand('100000', '999999'), PDO::PARAM_STR);
                $stmWithdraw->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                $stmWithdraw->bindValue(':method', 2, PDO::PARAM_INT); //1 手动 2自动
                $stmWithdraw->bindValue(':type', 3, PDO::PARAM_INT); //1 //微信分账 3 //微信转账 4 //支付宝分账 6 //支付宝转账 （默认1走微信分账）
                $stmWithdraw->bindValue(':credit_type', 1, PDO::PARAM_STR);// 1积分 2海星积分
                $stmWithdraw->bindValue(':amount', $value['credit_split_total'], PDO::PARAM_STR); //金额 (分账的积分)
                $stmWithdraw->bindValue(':fee', 0, PDO::PARAM_STR); //手续费
                $stmWithdraw->bindValue(':account_amount', $value['credit_split_total'], PDO::PARAM_STR); //到账金额
                $stmWithdraw->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmWithdraw->bindValue(':status', 1, PDO::PARAM_INT); //1待处理 3打回 6成功
                $stmWithdraw->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmWithdraw->bindValue(':wechat_name', $value['wechat_name'], PDO::PARAM_STR);//微信姓名
                $stmWithdraw->bindValue(':wechat_account', $value['wechat_openid'], PDO::PARAM_STR); //微信账号（openid)
                $stmWithdraw->bindValue(':alipay_name', $value['alipay_name'], PDO::PARAM_STR); //支付宝姓名
                $stmWithdraw->bindValue(':alipay_account', $value['alipay_openid'], PDO::PARAM_STR);//支付宝账号（openid）
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
                $stmWithdrawLog->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':method', 2, PDO::PARAM_INT); //1 手动 2自动
                $stmWithdrawLog->bindValue(':type', 3, PDO::PARAM_INT); //1 //微信分账 3 //微信转账 4 //支付宝分账 6 //支付宝转账 （默认1走微信分账）
                $stmWithdrawLog->bindValue(':credit_type', 1, PDO::PARAM_STR);// 1积分 2海星积分
                $stmWithdrawLog->bindValue(':amount', $value['credit_split_total'], PDO::PARAM_STR); //金额 (分账的积分)
                $stmWithdrawLog->bindValue(':fee', 0, PDO::PARAM_STR); //手续费
                $stmWithdrawLog->bindValue(':account_amount', $value['credit_split_total'], PDO::PARAM_STR); //到账金额
                $stmWithdrawLog->bindValue(':create_time', time(), PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':status', 1, PDO::PARAM_INT); //1待处理 3打回 6成功
                $stmWithdrawLog->bindValue(':status_time', time(), PDO::PARAM_INT);
                $stmWithdrawLog->bindValue(':wechat_name', $value['wechat_name'], PDO::PARAM_STR);//微信姓名
                $stmWithdrawLog->bindValue(':wechat_account', $value['wechat_openid'], PDO::PARAM_STR); //微信账号（openid)
                $stmWithdrawLog->bindValue(':alipay_name', $value['alipay_name'], PDO::PARAM_STR); //支付宝姓名
                $stmWithdrawLog->bindValue(':alipay_account', $value['alipay_openid'], PDO::PARAM_STR);//支付宝账号（openid）
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
                //记录 cms_withdraw_detail 明细表 (与cms_bonus_account 一一对应) （查询有多少条id_bonus_account 被汇总）
                //修改 insert into select（0922）
                $withdrawDetailInsert = 'insert into `cms_withdraw_detail`(`id_withdraw`,`relation_id_order`,`relation_id_bonus_account`,`bind_bonus_account_type`,`order_pay_sn`,`amount`)  ' . ' select ' . $idWithdraw . ' ,id_order,id_bonus_account,type,' . $value['pay_sn_sync'] . ',credit from cms_bonus_account ba where ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['split_status'] . ') ) and   id_user=' . $value['id_user'] . ' and is_calc=2  and id_bonus_account<=' . $value['max_id_bonus_account'];

                $stmWithdrawDetail = $pdo->prepare($withdrawDetailInsert);
                if ($stmWithdrawDetail->execute() === false) {
                    $pdo->rollBack();
                    exit;
                }

                $pdo->commit();
                ##########################################插入cms_withdraw 和cms_withdraw_detail 表数据 end##################################
            } catch (Exception $e) {
                $pdo->rollBack();
                echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
                exit;
            }


            try {
                $pdo->beginTransaction();
                echo '==================================================' . $value['id_bonus_account'] . '转账金额为' . $valueChange['credit_split_total'] . '分======';

                //设置有无账号标识
                $haveAcoount = true;
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

                if ((int)$value['pay_type_sync'] == 1) {
                    //微信转账
                    if (!empty($value['wechat_openid'])) {

                        //查看每人每天的(微信转账次数 10，和金额数 5000)是否超过上限
                        $start = mktime(0, 0, 0, date("m"), date("d"), date("Y"));//当天开始时间戳
                        $end = mktime(23, 59, 59, date("m"), date("d"), date("Y"));//当天结束时间戳
                        bcmul($value['credit_split_total'], 100, 0);
                        $user_wx_transfer_limit = $pdo->query('select count(id_user) as count,sum(amount) as amountTotal   from cms_withdraw where id_user=' . $value['id_user'] . ' and type in (3) and status=6 and create_time between ' . $start . ' and ' . $end)->fetch(PDO::FETCH_ASSOC);
                        var_dump($user_wx_transfer_limit);
                        if ((int)$user_wx_transfer_limit['count'] < 9 && (int)bcmul($user_wx_transfer_limit['amountTotal'], 100, 0) <= 500000 && (int)bcmul($value['credit_split_total'], 100, 0) >= 30 && bcadd(bcmul($user_wx_transfer_limit['amountTotal'], 100, 0), bcmul($value['credit_split_total'], 100, 0), 2) <= 500000) {
                            $jsonWxTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "WeChat_NATIVE",
                                        "order_no": "' . $value['pay_sn_sync'] . '",
                                        "info_list": [{
                                         "open_id": "' . $value['wechat_openid'] . '",
                                          "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                          "real_name":"' . $value['wechat_name'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $idWithdraw . '",  
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
                            $resonWxFailed['credit_split_total'] = $value['credit_split_total'];

                        }

                    } elseif (!empty($value['alipay_openid'])) {
                        //支付宝转账 （最小金额10分）
                        if ((int)bcmul($value['credit_split_total'], 100, 0) >= 10) {

                            $jsonAliTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "AliPay_App",
                                        "order_no": "' . $GLOBALS['only'] . $idWithdraw . '",
                                        "activity_name": "商品分享佣金",
                                        "desc": "商品分享佣金",
                                        "info_list": [{
                                         "account_number": "' . $value['alipay_openid'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $idWithdraw . '",  
                                         "account_type": "ALIPAY_LOGON_ID",
                                         "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                         "real_name":"' . $value['alipay_name'] . '"
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
                    } else {
                        //微信支付宝账号均无
                        $haveAcoount = false;

                    }

                } elseif ((int)$value['pay_type_sync'] == 2) {
                    //支付宝转账
                    if (!empty($value['alipay_openid'])) {
                        if ((int)bcmul($value['credit_split_total'], 100, 0) >= 10) {
                            $jsonAliTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "AliPay_App",
                                        "order_no": "' . $GLOBALS['only'] . $idWithdraw . '",
                                        "activity_name": "商品分享佣金",
                                        "desc": "商品分享佣金",
                                        "info_list": [{
                                         "account_number": "' . $value['alipay_openid'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $idWithdraw . '",  
                                         "account_type": "ALIPAY_LOGON_ID",
                                         "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                         "real_name":"' . $value['alipay_name'] . '"
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

                    } elseif (!empty($value['wechat_openid'])) {
                        //查看每人每天的(微信转账次数 10，和金额数 3*10分 之间 5000*100分)是否超过上限
                        $start = mktime(0, 0, 0, date("m"), date("d"), date("Y"));//当天开始时间戳
                        $end = mktime(23, 59, 59, date("m"), date("d"), date("Y"));//当天结束时间戳
                        bcmul($value['credit_split_total'], 100, 0);
                        $user_wx_transfer_limit = $pdo->query('select count(id_user) as count,sum(amount) as amountTotal   from cms_withdraw where id_user=' . $value['id_user'] . ' and type in (3) and status=6 and create_time between ' . $start . ' and ' . $end)->fetch(PDO::FETCH_ASSOC);

                        if ((int)$user_wx_transfer_limit['count'] < 9 && (int)bcmul($user_wx_transfer_limit['amountTotal'], 100, 0) <= 500000 && (int)bcmul($value['credit_split_total'], 100, 0) >= 30 && bcadd(bcmul($user_wx_transfer_limit['amountTotal'], 100, 0), bcmul($value['credit_split_total'], 100, 0), 2) <= 500000) {
                            $jsonWxTransfer = '{
                                        "app_id": "' . $GLOBALS['app_id'] . '",
                                        "pay_type": "WeChat_NATIVE",
                                        "order_no": "' . $value['pay_sn_sync'] . '", 
                                        "info_list": [{
                                         "open_id": "' . $value['wechat_openid'] . '",
                                          "amount": ' . (int)$valueChange['credit_split_total'] . ',
                                          "real_name":"' . $value['wechat_name'] . '",
                                         "unique_id": "' . $GLOBALS['only'] . $idWithdraw . '",  
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
                            $resonWxFailed['credit_split_total'] = $value['credit_split_total'];

                        }


                    } else {
                        //微信支付宝账号均无
                        $haveAcoount = false;

                    }

                }


                //处理(转账，成功/失败）

                var_dump($data_array);
                $pdo->commit();
            } catch (Exception $e) {
                $pdo->rollBack();
                echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
                exit;
            }

            try {
                $pdo->beginTransaction();
                /***************************************(分账/转账，成功/失败 ，处理逻辑-start)***********************************************/
                if ($data_array['code'] == '00000000' && $data_array['data'][0]['code'] == '00000000') {
                    echo '成功';
                    var_dump($data_array['code']);

                    //代表微信分账/支付宝转账成功 (需要将cms_credit 表中的数据freeze还原,并修改cms_bonus_account表中withdraw_status=2) 还需锁住
                    $user_credit_weixin_personal_success = $pdo->query('select credit,freeze  from cms_credit where id_user=' . $value['id_user'] . ' lock in share mode  ')->fetch(PDO::FETCH_ASSOC);
                    $accountBonusUpdate = $pdo->exec('update cms_bonus_account ba set   ba.withdraw_status=2 where ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['split_status'] . ') ) and id_user=' . $value['id_user'] . ' and is_calc=2 and   id_bonus_account<=' . $value['max_id_bonus_account']);


                    //还原freeze 积分
                    $freezeHy = $pdo->exec('update cms_credit set freeze=' . bcsub($user_credit_weixin_personal_success['freeze'], $value['credit_split_total'], 2) . ' where id_user= ' . $value['id_user']);
                    if ($freezeHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录freeze2积分变动日志记录
                    $strFreeze2 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                    $stmFreeze2 = $GLOBALS['db']->prepare($strFreeze2);
                    $stmFreeze2->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':account', 2, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':type', 7, PDO::PARAM_INT); //7提现成功
                    $stmFreeze2->bindValue(':amount', '-' . $value['credit_split_total'], PDO::PARAM_STR);
                    $stmFreeze2->bindValue(':remain', $user_credit_weixin_personal_success['freeze'], PDO::PARAM_STR);
                    $stmFreeze2->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmFreeze2->bindValue(':memo', '微信个人转账成功,提现' . $value['pay_sn_sync'], PDO::PARAM_STR);
                    } else {
                        $stmFreeze2->bindValue(':memo', '支付宝转账成功,提现' . $value['pay_sn_sync'], PDO::PARAM_STR);
                    }

                    $stmFreeze2->bindValue(':is_sync', 1, PDO::PARAM_INT);
                    $stmFreeze2->bindValue(':sync_time', 0, PDO::PARAM_STR);

                    if ($stmFreeze2->execute() === false) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录cms_withdraw 表( 修改字段 back_reason成功还是失败原因 type 类型 1微信分账3微信转账4支付宝分账6支付宝转账)
                    if ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        //微信转账 type=3 status=6
                        $up2 = $pdo->exec('update cms_withdraw set type=3,status=6,create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up2 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up3 = $pdo->exec('update cms_withdraw_change_log set type=3,status=6,create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up3 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                    } elseif ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        //支付宝转账 type=6 status=6
                        $up4 = $pdo->exec('update cms_withdraw set type=6,status=6,create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up4 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up5 = $pdo->exec('update cms_withdraw_change_log set type=6,status=6,create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up5 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                    }


                } else {
                    echo '失败';
//                    var_dump($resonWxFailed);
                    /************************************新增失败status明确*********************************/
                    switch (true) {
                        //内部限制
                        case $haveAliPay === false :
                            $status = 19; //'小于支付宝最低转账限制';
                            break;
                        case (int)$resonWxFailed['count'] >= 9 :
                            $status = 16; //'超过每天最大转账次数';
                            break;
                        case (int)bcmul($resonWxFailed['credit_split_total'], 100, 0) < 30 && (!empty($resonWxFailed['credit_split_total'])):
                            $status = 17; //'小于微信转账最低限制';
                            break;
                        case (int)bcmul($resonWxFailed['amountTotal'], 100, 0) > 500000 || bcadd(bcmul($resonWxFailed['amountTotal'], 100, 0), bcmul($resonWxFailed['credit_split_total'], 100, 0), 2) > 500000:
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

                    // (需要将cms_credit 表中的数据credit,freeze还原 并修改cms_bonus_account表中withdraw_status=3 or 4) 还需锁住
                    $user_credit_weixin_personal_fail = $pdo->query('select credit,freeze  from cms_credit where id_user=' . $value['id_user'] . ' lock in share mode  ')->fetch(PDO::FETCH_ASSOC);
                    if (empty($data_array['data'][0]['signsign'])) {
                        if ($haveAcoount === false) {
                            //证明没有任何账号 (将cms_bonus_accout 表中withdraw_status=5 ，之后的（转账或分账中(转账失败的)无任何账号的不作处理）)
                            $accountBonusUpdate = $pdo->exec('update cms_bonus_account ba  set  withdraw_status=5 where ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status  in ' . $GLOBALS['split_status'] . ') ) and id_user=' . $value['id_user'] . ' and is_calc=2 and  id_bonus_account<=' . $value['max_id_bonus_account']);

                        }
                    } elseif(!empty($data_array['data'][0]['code'])) {
                        //代表(真正的内部支付接口返回错误问题)微信转账/支付宝转账失败
                        $accountBonusUpdate = $pdo->exec('update cms_bonus_account ba  set  ba. withdraw_status=3 where ((ba.type in ' . $GLOBALS['transfer_type'] . ' and ba.withdraw_status in ' . $GLOBALS['transfer_status'] . ') or ( ba.type in ' . $GLOBALS['split_type'] . ' and ba.withdraw_status in ' . $GLOBALS['split_status'] . ') ) and id_user=' . $value['id_user'] . ' and is_calc=2 and  id_bonus_account<=' . $value['max_id_bonus_account']);


                    }
                    //还原freeze 积分
                    $freezeHy = $pdo->exec('update cms_credit set freeze=' . bcsub($user_credit_weixin_personal_fail['freeze'], $value['credit_split_total'], 2) . ' where id_user= ' . $value['id_user']);
                    if ($freezeHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //还原credit 积分
                    $creditHy = $pdo->exec('update cms_credit set credit=' . bcadd($user_credit_weixin_personal_fail['credit'], $value['credit_split_total'], 2) . ' where id_user= ' . $value['id_user']);
                    if ($creditHy == 0) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录freeze3积分变动日志记录
                    $strFreeze3 = 'insert into `cms_credit_log`(`id_user`,`id_user_operator`,`account`,`type`,`amount`,`remain`,`status`,`status_time`,`create_time`,`memo`,`is_sync`,`sync_time`) values(:id_user, :id_user_operator, :account, :type, :amount, :remain, :status, :status_time, :create_time, :memo, :is_sync,:sync_time)';
                    $stmFreeze3 = $GLOBALS['db']->prepare($strFreeze3);
                    $stmFreeze3->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':account', 2, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':type', 11, PDO::PARAM_INT); //11 解冻 自动提现退回
                    $stmFreeze3->bindValue(':amount', '-' . $value['credit_split_total'], PDO::PARAM_STR);
                    $stmFreeze3->bindValue(':remain', $user_credit_weixin_personal_fail['freeze'], PDO::PARAM_STR);
                    $stmFreeze3->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmFreeze3->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        $stmFreeze3->bindValue(':memo', '支付宝转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } elseif ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmFreeze3->bindValue(':memo', '微信转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } else {
                        if ($haveAcoount === true) {

                            switch (true) {
                                case (int)$resonWxFailed['count'] >= 9 :
                                    $memo = '超过每天最大转账次数:';
                                    break;
                                case (int)bcmul($resonWxFailed['credit_split_total'], 100, 0) < 30 :
                                    $memo = '小于微信转账最低限制:';
                                    break;
                                default:
                                    $memo = '超过微信转账最高限制:';


                            }

                            if ($haveAliPay === false) {
                                $memo = '小于支付宝最低转账限制:';
                            }

                            $stmFreeze3->bindValue(':memo', $memo . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                        } else {

                            $stmFreeze3->bindValue(':memo', '没绑定任何账号:' . '自动提现退回', PDO::PARAM_STR);
                        }
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
                    $stmCredit3->bindValue(':id_user', $value['id_user'], PDO::PARAM_INT);
                    $stmCredit3->bindValue(':id_user_operator', 0, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':account', 1, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':type', 11, PDO::PARAM_INT); //11 解冻 自动提现退回
                    $stmCredit3->bindValue(':amount', $value['credit_split_total'], PDO::PARAM_STR);
                    $stmCredit3->bindValue(':remain', $user_credit_weixin_personal_fail['credit'], PDO::PARAM_STR);
                    $stmCredit3->bindValue(':status', 2, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':status_time', time(), PDO::PARAM_INT);
                    $stmCredit3->bindValue(':create_time', time(), PDO::PARAM_INT);
                    if ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        $stmCredit3->bindValue(':memo', '支付宝转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } elseif ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        $stmCredit3->bindValue(':memo', '微信转账失败原因:' . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                    } else {
                        if ($haveAcoount === true) {

                            switch (true) {
                                case (int)$resonWxFailed['count'] >= 9  :
                                    $memo = '超过每天最大转账次数:';
                                    break;
                                case (int)bcmul($resonWxFailed['credit_split_total'], 100, 0) < 30 :
                                    $memo = '小于微信转账最低限制:';
                                    break;
                                default:
                                    $memo = '超过微信转账最高限制:';


                            }

                            if ($haveAliPay === false) {
                                $memo = '小于支付宝最低转账限制';
                            }
                            $stmCredit3->bindValue(':memo', $memo . $data_array['data'][0]['msg'] . '自动提现退回', PDO::PARAM_STR);
                        } else {
                            $stmCredit3->bindValue(':memo', '没绑定任何账号:' . '自动提现退回', PDO::PARAM_STR);
                        }

                    }

                    $stmCredit3->bindValue(':is_sync', 1, PDO::PARAM_INT);
                    $stmCredit3->bindValue(':sync_time', 0, PDO::PARAM_STR);

                    if ($stmCredit3->execute() === false) {
                        $pdo->rollBack();
                        exit;
                    }
                    //记录cms_withdraw 表( 修改字段 back_reason成功还是失败原因 type 类型 1微信分账3微信转账4支付宝分账6支付宝转账)
                    if ($data_array['data'][0]['signsign'] == 'ali_transfer') {
                        //支付宝转账

                        $up6 = $pdo->exec('update cms_withdraw set type=6,status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up6 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up7 = $pdo->exec('update cms_withdraw_change_log set type=6,status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up7 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                    } elseif ($data_array['data'][0]['signsign'] == 'wx_transfer') {
                        //微信转账
                        $up8 = $pdo->exec('update cms_withdraw set type=3,status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                        if ($up8 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                        $up9 = $pdo->exec('update cms_withdraw_change_log set type=3,status=' . $status . ',create_time=' . time() . ',back_reason="' . $data_array['data'][0]['msg'] . '" ,response_data=' . "'" . $returnData . "'" . '  where id_withdraw= ' . $idWithdraw);
                        if ($up9 == 0) {
                            $pdo->rollBack();
                            exit;
                        }
                    } else {
                        //烂账(不在转账限制范围内或没绑定任何账号) type=200 status=3
                        if ($haveAcoount === true) {

                            switch (true) {
                                case (int)$resonWxFailed['count'] >= 9 :
                                    $memo = '超过每天最大转账次数';
                                    break;
                                case (int)bcmul($resonWxFailed['credit_split_total'], 100, 0) < 30 :
                                    $memo = '小于微信转账最低限制';
                                    break;
                                default:
                                    $memo = '超过微信转账最高限制';


                            }
                            $type = 3;

                            if ($haveAliPay === false) {
                                $memo = '小于支付宝最低转账限制';
                                $type = 6;
                            }
                            $up10 = $pdo->exec('update cms_withdraw set type=' . $type . ',status=' . $status . ' ,create_time=' . time() . ',back_reason="' . $memo . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                            if ($up10 == 0) {
                                $pdo->rollBack();
                                exit;
                            }
                            $up11 = $pdo->exec('update cms_withdraw_change_log set type=' . $type . ',status=' . $status . ' ,create_time=' . time() . ',back_reason="' . $memo . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                            if ($up11 == 0) {
                                $pdo->rollBack();
                                exit;
                            }
                        } else {
                            $back_reason = '没绑定任何账号';
                            //删除cms_withdraw 记录 保留withdraw_log
                            $up12 = $pdo->exec('update cms_withdraw_change_log set type=200,status=' . $status . ' ,create_time=' . time() . ',back_reason="' . $back_reason . '" ,response_data=' . "'" . $returnData . "'" . ' where id_withdraw= ' . $idWithdraw);
                            if ($up12 == 0) {
                                $pdo->rollBack();
                                exit;
                            }
                            $delete1 = $pdo->exec('delete from cms_withdraw where id_withdraw= ' . $idWithdraw);
                            if ($delete1 === false) {
                                $pdo->rollBack();
                                exit;
                            }

                        }

                    }

                }
                $pdo->commit();
            } catch
            (Exception $e) {
                $pdo->rollBack();
                echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
                exit;
            }
            /***************************************(分账/转账，成功/失败 ，处理逻辑-end)***********************************************/
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



