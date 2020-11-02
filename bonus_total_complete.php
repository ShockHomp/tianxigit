<?php
//header("Content-Type: text/html;charset=utf-8");
//error_reporting(E_ALL);
set_time_limit(0);
//配置文件
include 'config_haixing.php';
//引入文件
require 'phpnsq/phpnsq/PhpNsq.php';
require 'phpnsq/phpnsq/Stream/Reader.php';
require 'phpnsq/phpnsq/Stream/Writer.php';
require 'phpnsq/phpnsq/Stream/Socket.php';
require 'phpnsq/phpnsq/Stream/Message.php';
require 'phpnsq/phpnsq/Stream/IntPacker.php';
require 'phpnsq/phpnsq/Conn/Pool.php';
require 'phpnsq/phpnsq/Conn/Config.php';
require 'phpnsq/phpnsq/Conn/Lookupd.php';
require 'phpnsq/phpnsq/Conn/Nsqd.php';

use OkStuff\PhpNsq\PhpNsq;

//创建日志文件
echo $fp_log_lyf = fopen(dirname(__FILE__) . '/logs/bonus_total_complete.log', 'ab');
try {
    //连接数据库
    $dsn = "mysql:host=" . $GLOBALS['mysql_config']['host'] . ";port=" . $GLOBALS['mysql_config']['port'] . ";dbname=" . $GLOBALS['mysql_config']['database'] . ";charset=" . $GLOBALS['mysql_config']['charset'] . "";
    $GLOBALS['db'] = new PDO($dsn, $GLOBALS['mysql_config']['user'], $GLOBALS['mysql_config']['password']);

} catch (PDOException $e) {
    echo " Failed: " . $e->getMessage();
}
$pdo = $GLOBALS['db'];
////统计积分最大时长 （秒）
//$GLOBALS['bonus_time'] = 2;
////统计积分最大条数
//$GLOBALS['bonus_sum'] = 2;

//汇总积分操作


$haveRowsId = false; //判断初始id_bonus_account
//目前为止每隔10秒轮询一次(限制一次最多轮询200条)
do {
    loop:
    try {
        $pdo->beginTransaction();
        //查询处理到的节点判断
        $rowsMaxId = $pdo->query('select id_bonus_account from cms_bonus_account where is_calc=1  and is_need_calc=2 and reason=1 and type in  ' . $GLOBALS['bonus_type'] . '  order by id_bonus_account asc limit 1')->fetch(PDO::FETCH_ASSOC);
        if (empty($rowsMaxId)) {
            $rowsMaxId = $pdo->query('select id_bonus_account from cms_bonus_account where is_calc=2   and is_need_calc=2 and reason=1 and type in  ' . $GLOBALS['bonus_type'] . ' order by id_bonus_account desc limit 1')->fetch(PDO::FETCH_ASSOC);

        }
        $rowsId = $rowsMaxId;

        if ($limitAfter >= $rowsMaxId['id_bonus_account']) {

            $limitBefore = $rowsMaxId['id_bonus_account'];

        } else {
            if ($haveRowsId === false) {
                $limitBefore = $rowsId['id_bonus_account'];
            } else {
                $limitBefore += $GLOBALS['bonus_sum'];
            }
            $haveRowsId = true;


        }
        $limitAfter = $limitBefore + $GLOBALS['bonus_sum'];
        $a = totalBonusAccount($pdo, $limitBefore, $limitAfter, $fp_log_lyf);

        $pdo->commit();

        echo date("Y-m-d H:i:s") . '间隔时间' . $GLOBALS['bonus_time'] . '起始id值' . $limitBefore . '结束id值' . $limitAfter . '每次处理条数' . $GLOBALS['bonus_sum'] . PHP_EOL;
        sleep($GLOBALS['bonus_time']);//等待时间，进行下一次操作。

    } catch (Exception $e) {
        $pdo->rollBack();
        echo "Failed: " . date("Y-m-d H:i:s") . $e->getMessage();
        sleep(1);
        goto loop;
    }

} while (true);


function totalBonusAccount($pdo, $limitBefore, $limitAfter, $fp_log_lyf)
{
    //根据用户查询统计积分(type=10,11区域落地 不做统计)

    $bonusTotal = $pdo->query('select *,sum(CASE WHEN type = 1 THEN credit ELSE 0 END) as service
                                         ,sum(CASE WHEN type = 2 THEN credit ELSE 0 END) as cash
                                         ,sum(CASE WHEN type = 3 THEN credit ELSE 0 END) as reward
                                         ,sum(CASE WHEN type = 4 THEN credit ELSE 0 END) as areaService
                                         ,sum(CASE WHEN type = 5 THEN credit ELSE 0 END) as areaSubsidy
                                         ,sum(CASE WHEN type = 6 THEN credit ELSE 0 END) as deliverService
                                         ,sum(CASE WHEN type = 7 THEN credit ELSE 0 END) as deliverSubsidy 
                                         ,sum(CASE WHEN type = 8 THEN credit ELSE 0 END) as presenterSubsidy
                                         ,sum(CASE WHEN type = 9 THEN credit ELSE 0 END) as serviceSubsidy
                                         ,sum(CASE WHEN type = 10 THEN credit ELSE 0 END) as areaDeliver
                                         ,sum(CASE WHEN type = 11 THEN credit ELSE 0 END) as vipSubsidy
                                         ,sum(CASE WHEN type = 12 THEN credit ELSE 0 END) as channelSubsidy
                                         ,sum(CASE WHEN type = 13 THEN credit ELSE 0 END) as advisorSubsidy
                                         ,sum(CASE WHEN type = 14 THEN credit ELSE 0 END) as cardSubsidy
                                         ,sum(CASE WHEN type = 15 THEN credit ELSE 0 END) as vipRecommend 
                                         ,sum(CASE WHEN type = 16 THEN credit ELSE 0 END) as vipSubsidy2 
                                         ,sum(CASE WHEN type = 17 THEN credit ELSE 0 END) as vipCommission 
                                         ,sum(CASE WHEN type = 18 THEN credit ELSE 0 END) as channelReward
                                         ,max(id_bonus_account) as max_id_bonus_account
                                          from cms_bonus_account where is_calc=1 and is_need_calc=2 and reason=1 and type in  ' . $GLOBALS['bonus_type'] . ' and ' . $limitBefore . '<=id_bonus_account and id_bonus_account<' . $limitAfter . ' group by id_user ');
//    var_dump($bonusTotal);


    while ($v = $bonusTotal->fetch(PDO::FETCH_ASSOC)) {
        if (is_array($v)) {

            if ($v['service'] == null) {
                $v['service'] = 0;
            }
            if ($v['cash'] == null) {
                $v['cash'] = 0;
            }
            if ($v['reward'] == null) {
                $v['reward'] = 0;
            }
            if ($v['areaService'] == null) {
                $v['areaService'] = 0;
            }
            if ($v['areaSubsidy'] == null) {
                $v['areaSubsidy'] = 0;
            }
            if ($v['deliverService'] == null) {
                $v['deliverService'] = 0;
            }
            if ($v['deliverSubsidy'] == null) {
                $v['deliverSubsidy'] = 0;
            }
            if ($v['presenterSubsidy'] == null) {
                $v['presenterSubsidy'] = 0;
            }
            if ($v['serviceSubsidy'] == null) {
                $v['serviceSubsidy'] = 0;
            }
            if ($v['areaDeliver'] == null) {
                $v['areaDeliver'] = 0;
            }
            if ($v['vipSubsidy'] == null) {
                $v['vipSubsidy'] = 0;
            }
            if ($v['channelSubsidy'] == null) {
                $v['channelSubsidy'] = 0;
            }
            if ($v['advisorSubsidy'] == null) {
                $v['advisorSubsidy'] = 0;
            }
            if ($v['cardSubsidy'] == null) {
                $v['cardSubsidy'] = 0;
            }
            if ($v['vipRecommend'] == null) {
                $v['vipRecommend'] = 0;
            }
            if ($v['vipSubsidy2'] == null) {
                $v['vipSubsidy2'] = 0;
            }
            if ($v['vipCommission'] == null) {
                $v['vipCommission'] = 0;
            }
            if ($v['channelReward'] == null) {
                $v['channelReward'] = 0;
            }

            $total = round($v['service'] + $v['cash'] + $v['reward'] + $v['areaService'] + $v['areaSubsidy'] + $v['deliverService'] + $v['deliverSubsidy'] + $v['presenterSubsidy'] + $v['serviceSubsidy'] + $v['areaDeliver'] + $v['vipSubsidy'] + $v['channelSubsidy'] + $v['advisorSubsidy'] + $v['cardSubsidy'] + $v['vipRecommend'] + $v['vipSubsidy2'] + $v['vipCommission'] + $v['channelReward'], 2);
            $sql = 'insert into `cms_bonus`(`id_user`,`period`,`is_grant`,`grant_time`,`create_time`,`id_user_update`,`tax`,`service`,`cash`,`reward`,`area_service`,`area_subsidy`,`deliver_service`,`deliver_subsidy`,`presenter_subsidy`,`service_subsidy`,`area_deliver`,`vip_subsidy`,`channel_subsidy`,`advisor_subsidy`,`card_subsidy`,`vip_recommend`,`vip_subsidy2`,`vip_commission`,`channel_reward`,`is_part_revoke`,`total`,`memo`,`update_time`)
     values(' . $v['id_user'] . ',0' . ',1' . ',' . time() . ',' . time() . ',0' . ',0' . ',' . $v['service'] . ',' . $v['cash'] . ',' . $v['reward'] . ',' . $v['areaService'] . ',' . $v['areaSubsidy'] . ',' . $v['deliverService'] . ',' . $v['deliverSubsidy'] . ',' . $v['presenterSubsidy'] . ',' . $v['serviceSubsidy'] . ',' . $v['areaDeliver'] . ',' . $v['vipSubsidy'] . ',' . $v['channelSubsidy'] . ',' . $v['advisorSubsidy'] . ',' . $v['cardSubsidy'] . ',' . $v['vipRecommend'] . ',' . $v['vipSubsidy2'] . ',' . $v['vipCommission'] . ',' . $v['channelReward'] . ',' . '1,' . $total . ',' . "'积分汇总'" . ',' . time() . ')';
//            echo $sql.PHP_EOL;
            $pdoStmt = $pdo->prepare($sql);
            if ($pdoStmt->execute() === false) {
                $pdo->rollBack();
                exit;

            }
            $idBonus = (int)$pdo->lastInsertId();

            $logs = array(
                'id_user' => $v['id_user'],
                'service' => $v['service'],
                'cash' => $v['cash'],
                'reward' => $v['reward'],
                'area_service' => $v['areaService'],
                'area_subsidy' => $v['areaSubsidy'],
                'deliver_service' => $v['deliverService'],
                'deliver_subsidy' => $v['deliverSubsidy'],
                'presenter_subsidy' => $v['presenterSubsidy'],
                'service_subsidy' => $v['serviceSubsidy'],
                'area_deliver' => $v['areaDeliver'],
                'vip_subsidy' => $v['vipSubsidy'],
                'channel_subsidy' => $v['channelSubsidy'],
                'advisor_subsidy' => $v['advisorSubsidy'],
                'card_subsidy' => $v['cardSubsidy'],
                'vip_recommend ' => $v['vipRecommend'],
                'vip_subsidy2 ' => $v['vipSubsidy2'],
                'vip_commission ' => $v['vipCommission'],
                'channel_reward ' => $v['channelReward'],
                'total' => $total,
                'create_time' => time(),
                'memo' => '积分汇总'


            );
            fwrite($fp_log_lyf, date("Y-m-d H:i:s") . "cms_bonus表" . json_encode($logs, JSON_UNESCAPED_UNICODE) . PHP_EOL);
            //修改统计完的 cms_bonus_account 表状态
            $pdoUpdate = $pdo->exec('update cms_bonus_account set is_calc=2 ,id_bonus=' . $idBonus . '  where is_calc=1 and is_need_calc=2 and reason=1 and id_user=' . $v['id_user'] . ' and id_bonus_account  between  ' . $limitBefore . ' and ' . $v['max_id_bonus_account'] . ' and type in ' . $GLOBALS['bonus_type']);
            if ($pdoUpdate == 0) {
                $pdo->rollBack();
                exit;
            }
        }


    }


}




