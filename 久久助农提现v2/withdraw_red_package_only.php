<?php
/**
 * 代付
 **/
error_reporting(E_ALL ^ E_NOTICE);
//配置文件
include 'config.php';
//创建提现日志文件
$fp_log_lyf = fopen(dirname(__FILE__) . '/withdraw_red_package.log', 'ab');
//数据库配置
//----------线上-----------****（清库时候要修改）
$GLOBALS['only'] = 'TJJZNHB1'; // 线上
$GLOBALS['num']  = 8; // $GLOBALS['only'] 为几位 num 就为几
// $GLOBALS['only'] = 'JJZNHB2'; // 线上
// $GLOBALS['num']  = 7; // $GLOBALS['only'] 为几位 num 就为几
//----------线上-----------****
//天溪app_id
$GLOBALS['app_id'] = '20200114150548';
//key数值
$GLOBALS['key']         = 'ghj4hd9f4g6qa';
$GLOBALS['pay_address'] = 'http://test.dingmei.net';
try {
    //连接数据库
    $dsn           = "mysql:host=" . $GLOBALS['mysql_config']['host'] . ";port=" . $GLOBALS['mysql_config']['port'] . ";dbname=" . $GLOBALS['mysql_config']['database'] . ";charset=" . $GLOBALS['mysql_config']['charset'] . "";
    $GLOBALS['db'] = new PDO($dsn, $GLOBALS['mysql_config']['user'], $GLOBALS['mysql_config']['password']);

} catch (PDOException $e) {
    echo " Failed: " . $e->getMessage() . "\r\n";
    exit();
}
$pdo = $GLOBALS['db'];
//V2 提现 单条执行-----------------------------------------------------------
withdrawBatch($pdo, $fp_log_lyf);
/**
 *单条执行
 */
function withdrawBatch($pdo, $fp_log_lyf)
{
    try {
        //内部支付返回结果response_data
        $returnData = '';
        $jsonBank = '';
        $lastId     = 0;
        $withdrawId = 0;
        //查询提现所需参数
        //  w.status=4 提现中
        $sql = 'select
			   w.id as withdraw_id,w.price,w.status,w.source_id,
			   m.login_name,m.member_id,
			   b.bank_num,b.phone,b.real_name,b.id_card
				from tx_live_withdraw w
				left join base_member m on m.member_id=w.member_id
				left join base_bankcard b on b.member_id=w.member_id
				where  w.status=4 and source_type=1 and b.is_del = 0 order by b.id asc limit 1';
        $sqlQuery = $pdo->query($sql);
        $values   = $sqlQuery->fetch(PDO::FETCH_ASSOC);
        if (!$values) {
            echo date("Y-m-d H:i:s") . '暂无处理数据' . PHP_EOL;
            exit();
        } else {
            $pdo->beginTransaction();
            // 修改处理中 status=5
            $sql             = 'update tx_live_withdraw w set   w.status= 5  where w.status=4 and w.source_type=1 and w.id=' . $values['withdraw_id'];
            $withdrawUpdate5 = $pdo->exec($sql);
            if ($withdrawUpdate5 == 0) {
                echo "修改处理中状态失败：SQL-" . $sql . PHP_EOL;
                $pdo->rollBack();
                exit(0);
            }
            // 添加log
            $strWithDrawLog1 = 'insert into `tx_live_withdraw_log`(`withdraw_id`,`admin_id`,`status`,`reason`,`c_time`)
		 values(' . $values['withdraw_id'] . ',' . $values['source_id'] . ',1' . ',' . "'" . '提现处理中' . "'" . ',' . time() . ')';
            $stmWithDrawLog = $pdo->prepare($strWithDrawLog1);
            if ($stmWithDrawLog->execute() === false) {
                echo "添加log：SQL-" . $strWithDrawLog1 . PHP_EOL;
                $pdo->rollBack();
                exit();
            }
            $lastId     = (int) $pdo->lastInsertId();
            $withdrawId = (int) $values['withdraw_id'];
            $pdo->commit();

            $resultAll[0]['account_number'] = $values['bank_num'];
            $resultAll[0]['amount']         = (string) ($values['price'] * 100);
            $resultAll[0]['id_card']        = $values['id_card'];
            $resultAll[0]['mobile_no']      = $values['phone'];
            $resultAll[0]['order_no']       = (string) ($GLOBALS['only'] . $lastId); //订单号(不能重复 全局唯一,提交失败后也不能重复)
            $resultAll[0]['pay_type']       = 'Wk_Bank';
            $resultAll[0]['real_name']      = $values['real_name'];
            $resultAll[0]['sort']           = '1';

            //提交给接口 执行提现操作
            $resultEnd['app_id']    = $GLOBALS['app_id'];
            $resultEnd['info_list'] = array_values($resultAll);
            $resultEnd['key']       = $GLOBALS['key'];
            $resultEnd['timestamp'] = (string) time();
            ksort($resultEnd, SORT_STRING);
            $jsonMd5           = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
            $sign              = md5($jsonMd5);
            $resultEnd['sign'] = $sign;
            $jsonBank          = json_encode($resultEnd, JSON_UNESCAPED_UNICODE);
            //调用代付接口
            $returnData = postCurls($GLOBALS['pay_address'] . "/order/repay", $jsonBank);
            //返回数据
            $data_array = json_decode($returnData, true);
            var_dump($data_array);
            $pdo->beginTransaction();
            //(代付接口结果返回处理) (//积分提现)
            //进行每一条提现记录判断 && $data_array['code'] == '00000000'
            if (!empty($data_array) && isset($data_array['code'])
                && isset($data_array['info_list']) && !empty($data_array['info_list'])
                && isset($data_array['info_list'][0]) && !empty($data_array['info_list'][0])
                && isset($data_array['info_list'][0]['code']) && $data_array['info_list'][0]['code'] == '00000000'
                && isset($data_array['info_list'][0]['order_no']) && !empty($data_array['info_list'][0]['order_no'])) {
                //先查询该用户基本信息 （member_id）
                $w_id          = substr($data_array['info_list'][0]['order_no'], strripos($data_array['info_list'][0]['order_no'], $GLOBALS['only']) + $GLOBALS['num']);
                $baseMemberSql = 'select m.member_id,m.red_packet_balance,m.shell_balance ,
                w.source_type,w.price,w.withdraw_way,w.id,w.credit,w.source_id
                from base_member m,tx_live_withdraw w,tx_live_withdraw_log wl
                where  m.member_id=w.member_id and w.id=wl.withdraw_id and wl.id=' . $w_id;
                $baseMemberSelect = $pdo->query($baseMemberSql)->fetch(PDO::FETCH_ASSOC);
                if (!$baseMemberSelect) {
                    echo "查询该用户基本信息error;SQL-" . $baseMemberSql . PHP_EOL;
                    $pdo->rollBack();exit();
                }
                //查找原表中积分
                $memberSql     = 'select price,price_freeze from tx_red_bag_member where member_id=' . $baseMemberSelect['member_id'] . ' lock in share mode ';
                $member_credit = $pdo->query($memberSql)->fetch(PDO::FETCH_ASSOC);
                if (!$member_credit) {
                    echo "查找原表中积分;SQL-" . $memberSql . PHP_EOL;
                    $pdo->rollBack();exit();
                }
                //代表成功(修改提现状态)tx_live_withdraw 还原冻结积分
                $status        = 2;
                $account_price = $baseMemberSelect['price']; //到账金额
                $type          = 4;
                $memo          = '提现成功';
                $returnReturn  = '1'; // 结果返回
                //还原(tx_red_bag_member) price_freeze 冻结 积分  //修改积分(原来海星总数)
                $priceUseHy = $pdo->exec('update tx_red_bag_member set price_freeze=' . bcsub($member_credit['price_freeze'], $baseMemberSelect['price'], 2) . ' where member_id= ' . $baseMemberSelect['member_id']);
                if ($priceUseHy == 0) {
                    echo "提现成功处理冻结积分出错：SQL-";
                    echo 'update tx_red_bag_member set price_freeze=' . bcsub($member_credit['price_freeze'], $baseMemberSelect['price'], 2) . ' where member_id= ' . $baseMemberSelect['member_id'] . PHP_EOL;
                    $pdo->rollBack();exit();
                }
                //添加红包流水表
                $strFreeze2 = 'insert into `tx_live_packet_log`(`member_id`,`price`,`type`,`withdraw_way`,`c_time`) values(:member_id, :price, :type, :withdraw_way, :c_time)';
                $stmFreeze2 = $GLOBALS['db']->prepare($strFreeze2);
                $stmFreeze2->bindValue(':member_id', $baseMemberSelect['member_id'], PDO::PARAM_INT);
                $stmFreeze2->bindValue(':price', '-' . $baseMemberSelect['price'], PDO::PARAM_STR);
                $stmFreeze2->bindValue(':type', $status, PDO::PARAM_INT); // 7提现
                $stmFreeze2->bindValue(':withdraw_way', 4, PDO::PARAM_STR);
                $stmFreeze2->bindValue(':c_time', time(), PDO::PARAM_STR);
                if ($stmFreeze2->execute() === false) {
                    echo "插入tx_live_packet_log表错误：SQL-";
                    echo $strFreeze2 . PHP_EOL;
                    $pdo->rollBack();exit();
                }
            } else {
                $status        = 3;
                $account_price = 0;
                $type          = 3;
                $memo          = '提现失败';
                $returnReturn  = '3';
                // 这里不做积分返还  由后台管理员手动操作
                $baseMemberSql = 'select m.member_id,m.red_packet_balance,m.shell_balance ,
                w.source_type,w.price,w.withdraw_way,w.id,w.credit,w.source_id
                from base_member m,tx_live_withdraw w,tx_live_withdraw_log wl
                where  m.member_id=w.member_id and w.id=wl.withdraw_id and wl.id=' . $lastId;
                $baseMemberSelect = $pdo->query($baseMemberSql)->fetch(PDO::FETCH_ASSOC);
                if (!$baseMemberSelect) {
                    echo "查询该用户基本信息error;SQL-" . $baseMemberSql . PHP_EOL;
                    $pdo->rollBack();exit();
                }

                //添加红包流水表
                $strFreeze2 = 'insert into `tx_live_packet_log`(`member_id`,`price`,`type`,`withdraw_way`,`c_time`) values(:member_id, :price, :type, :withdraw_way, :c_time)';
                $stmFreeze2 = $GLOBALS['db']->prepare($strFreeze2);
                $stmFreeze2->bindValue(':member_id', $baseMemberSelect['member_id'], PDO::PARAM_INT);
                $stmFreeze2->bindValue(':price', '-' . $baseMemberSelect['price'], PDO::PARAM_STR);
                $stmFreeze2->bindValue(':type', $status, PDO::PARAM_INT); // 7提现
                $stmFreeze2->bindValue(':withdraw_way', 4, PDO::PARAM_STR);
                $stmFreeze2->bindValue(':c_time', time(), PDO::PARAM_STR);
                if ($stmFreeze2->execute() === false) {
                    echo "插入tx_live_packet_log表错误：SQL-";
                    echo $strFreeze2 . PHP_EOL;
                    $pdo->rollBack();exit();
                }
            }
            //修改提现表和提现日志表的状态(tx_live_withdraw tx_live_withdraw_log) status 2提现成功 3提现失败
            $withdrawUpdate = 'update tx_live_withdraw w ,tx_live_withdraw_log wl set  w.account_price= ' . $account_price . ' , w.status= ' . $status . ' , w.deal_time= ' . time() . '  where w.id=wl.withdraw_id and w.source_type=1 and w.status=5 and wl.id=' . $lastId;
            $UpdateWithdraw = $pdo->exec($withdrawUpdate);
            if ($UpdateWithdraw == 0) {
                echo "修改提现表和提现日志表的状态错误；SQL-" . $withdrawUpdate . PHP_EOL;
                $pdo->rollBack();exit();
            }
            //提现成功或失败 log tx_live_withdraw_log
            $strWithDrawLogYesNo = 'insert into `tx_live_withdraw_log` (`withdraw_id`,`admin_id`,`status`,`reason`,`c_time`)  values(:withdraw_id, :admin_id, :status, :reason, :c_time)';
            $stmWithDrawLogYesNo = $pdo->prepare($strWithDrawLogYesNo);
            $stmWithDrawLogYesNo->bindValue(':withdraw_id', $baseMemberSelect['id'], PDO::PARAM_INT);
            $stmWithDrawLogYesNo->bindValue(':admin_id', $baseMemberSelect['source_id'], PDO::PARAM_INT); //ADMIN_ID 为 $_SESSION['admin_id']
            $stmWithDrawLogYesNo->bindValue(':status', $status, PDO::PARAM_INT);
            //$stmWithDrawLogYesNo->bindValue(':reason', $memo, PDO::PARAM_STR);
            //1210 修改 将内部支付返回结果存在 reason 中
            $stmWithDrawLogYesNo->bindValue(':reason', $data_array['info_list'][0]['msg'], PDO::PARAM_STR);
            $stmWithDrawLogYesNo->bindValue(':c_time', time(), PDO::PARAM_INT);
            if ($stmWithDrawLogYesNo->execute() === false) {
                echo "修改提现表和提现日志表的状态错误；SQL-" . $strWithDrawLogYesNo . PHP_EOL;
                $pdo->rollBack();exit();
            }
            //发站内推送
            if ($status == 2) {
                withdrawal_push_success($baseMemberSelect['member_id'], $account_price);
            }
            $pdo->commit();
        }
        //echo '=========================提现成功===============';
        wrlog($fp_log_lyf, $jsonBank,$returnData, $withdrawId);
    } catch (Exception $e) {
        echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage() . PHP_EOL;
        wrlog($fp_log_lyf, $e->getMessage(), $withdrawId);
        exit();
    }
}

////添加日志文件
function wrlog($fp_log_lyf,$jsonBank,$returnData, $withdrawId = 0)
{
    $logs = [
        'withdraw_id' => $withdrawId,
        'admin_id'    => '脚本',
        'returnBefore'      =>  $jsonBank,
        'return'      => $returnData,
        'memo'        => '提现日志记录',
    ];
    fwrite($fp_log_lyf, date("Y-m-d H:i:s") . "tx_live_withdraw_log表提现" . json_encode($logs, JSON_UNESCAPED_UNICODE) . PHP_EOL);
}

//
function postCurls($url, $json)
{
    $ch = curl_init();
    // 设置超时
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false); //严格校验
    // 设置header
    curl_setopt($ch, CURLOPT_HEADER, false);
    // 要求结果为字符串且输出到屏幕上
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // post提交方式
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    // 运行curl
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}

/**
 * 提现到账成功
 * @param int    $member_id 用户ID
 * @param string $price 提现金额
 */
function withdrawal_push_success($member_id, $price)
{
    $title = '提现到账提醒';
    $msg   = "您的{$price}元的提现申请通过，将原路返回您的账户，请注意查收~";
    push_msg($member_id, $title, $msg);
}

/**
 * 提现到账失败
 * @param int    $member_id 用户ID
 * @param string $price 提现金额
 * @param string $reason 提现失败原因
 */
function withdrawal_push_fail($member_id, $price, $reason)
{
    $title = '提现进展提醒';
    $msg   = "您的{$price}元的提现申请未通过！\n原因：{$reason}";
    push_msg($member_id, $title, $msg);
}

function push_msg($member_id, $title, $msg)
{
    $path = dirname(dirname(__FILE__));
    require_once $path . '/current/framework/library/mysql.class.php';
    require_once $path . '/current/www/project_config/module_config/account.config.php';

    $GLOBALS['DB'] = new cls_mysql($GLOBALS['account_settings']['dbserver']['default'] . '/?' . $GLOBALS['account_settings']['dbname']);

    // 插入计划任务
    $time = time();
    $GLOBALS['DB']->query("INSERT INTO `push_msg` (`send_type`, `addtime`, `title`, `content`, `admin_id`, `all_or_alone`, `push_time`, `member_ids`, `msg_type`) VALUES (1, {$time}, '{$title}', '{$msg}', null, 0, {$time}, '{$member_id}', 8)");
}
