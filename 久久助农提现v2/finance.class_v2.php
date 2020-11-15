<?php

class finance
{
    // V2
    public function reconciliation_list()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['shop_name'] = ForceStringFrom('shop_name'); //店铺名称 ||id
        $filter['status'] = ForceStringFrom('status'); //店铺名称 ||id

        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }

        $search = "";
        if (!empty($filter['shop_name'])) {
            if (is_numeric($filter['shop_name'])) {
                $search = "  a.id = " . $filter['shop_name'];
            } else {
                $search = "  a.shop_name like '%{$filter['shop_name']}%'";
            }
        }

        $status = "";
        if (!empty($filter['status'])) {
            if ($filter['status'] == '1') {
                $status = " where b.time is not null";
                if (!empty($filter['shop_name'])) {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " and b.time = '{$nianyue}' and  b.time is not null ";

                } else {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " where b.time is not null ";
                }
            } else {
                $status = " b.time is null ";
            }
        }
        $nian = date('Y');
        $yue = date('m');
        if ($yue == '1') {
            $nian = $nian - 1;
        } else {
            $yue = $yue - 1;
        }
        if ($yue < 10) {
            $yue = '0' . $yue;
        }
        $times = $nian . $yue;

        if (!empty($filter['shop_name']) and !empty($filter['status'])) {
            //全部   查不到不报错

            if ($filter['status'] == 1) {
                //已对账
                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1'   where b.time is not null  and b.time = '{$times}' and {$search} group by a.id " . $limit;
            } else {
//                未对账
                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1' and  {$status}  and b.time = '{$times}' where {$search} group by a.id " . $limit;
            }
        } else {
            if (!empty($filter['shop_name'])) {
                //查询店铺
                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1' and b.time = '{$times}' where {$search} group by a.id " . $limit;
            }

            if (!empty($filter['status'])) {
                //查询状态
                if ($filter['status'] == 1) {
                    $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1'   {$status}  and b.time = '{$times}' group by a.id " . $limit;
                } else {
                    $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1' and  {$status}  and b.time = '{$times}' group by a.id " . $limit;
                }

            }


            if (empty($filter['shop_name']) and empty($filter['status'])) {
                //啥也没有
                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1'  {$status}  and b.time = '{$times}' group by a.id " . $limit;
            }
        }

        $shop = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_shop_base";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);


//        foreach ($shop as $k => $v) {
//            if (empty($v['time'])) {
//                $shop[$k]['status'] = '2';
//                if (date('Ym', $v['join_time']) == date('Ym')) {
//                    $shop[$k]['duizhang'] = '0';
//                } else {
//                    $shop[$k]['duizhang'] = date('Ym', $v['join_time']);
//                }
//            } else {
//                $nian = date('Y'); //当前年
//                $yue = date('m'); //当前月
//                if ($yue == '1') {
//                    $nianyue = $nian - 1 . '12';
//                } else {
//                    $nianyue = $nian . $yue - 1;
//                }
//                if ($v['time'] == $nianyue) {
//                    $shop[$k]['status'] = '1';
//                    $shop[$k]['duizhang'] = $nianyue;
//                } else {
//                    $shop[$k]['status'] = '2';
//                    $shop[$k]['addtime'] = '';
//                    $dui_nian = substr($v['time'], 0, 4);
//                    $dui_yue = substr($v['time'], 4, 2);
//                    if ($dui_yue == '12') {
//                        $shop[$k]['duizhang'] = $dui_nian + 1 . '01';
//                    } else {
//                        $shop[$k]['duizhang'] = $dui_nian . $dui_yue + 1;
//                    }
//                }
//            }
//        }


        foreach ($shop as $k => $v) {
            if (empty($v['time'])) {
                $shop[$k]['status'] = 2;
            } else {
                $shop[$k]['status'] = 1;
            }
            $shop[$k]['duizhang'] = $times;
        }


        foreach ($shop as $k => $v) {
            if ($v['duizhang'] != '0') {
                $nian = substr($v['duizhang'], 0, 4);
                $yue = substr($v['duizhang'], 4, 2);
                $nianyue = $this->mFristAndLast($nian, $yue);
                $sql = "select count(*) as num,sum(real_price) as total_price,sum(real_deliver_fee) as deliver_fee from order_base where pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and shop_id = '{$v['id']}' and v = 2";
                $row = $GLOBALS['DB']->get_row($sql);
                $shop[$k]['number'] = $row['num'];
                if (empty($row['deliver_fee'])) {
                    $shop[$k]['deliver_fee'] = '0.00';
                } else {
                    $shop[$k]['deliver_fee'] = sprintf("%.2f", $row['deliver_fee'], 2);
                }
                if (!empty($row['total_price'])) {
                    $shop[$k]['money'] = sprintf("%.2f", $row['total_price'], 2);
                } else {
                    $shop[$k]['money'] = '0';
                }
            } else {
                $shop[$k]['number'] = '0';
                $shop[$k]['money'] = '0.00';
                $shop[$k]['deliver_fee'] = '0.00';
            }
        }

        foreach ($shop as $k => $v) {
            if (empty($v['number'])) {
                $shop[$k]['number'] = '0';
            }
            if (empty($v['money'])) {
                $shop[$k]['money'] = '0.00';
            }
            if (empty($v['deliver_fee'])) {
                $shop[$k]['deliver_fee'] = '0.00';
            }
        }


        return ['list' => $shop, 'filter' => $filter];
    }


    //对账
    public function reconciliation_reconciliation()
    {

        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        }
        $data['time'] = ForceStringFrom('time');
        $data['type'] = ForceStringFrom('type');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        $sql = "select id,shop_id,pay_type,real_price as total_price,pay_time,real_deliver_fee as deliver_fee from order_base where shop_id = '{$data['shop_id']}' and pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and status = '5' and v = 2 order by pay_time";
        $list = $GLOBALS['DB']->get_results($sql);
        if (empty($list)) {
            $sql = "select id as shop_id,shop_name from tx_shop_base where id = '{$data['shop_id']}'";
            $shop = $GLOBALS['DB']->get_row($sql);
            $shop['number'] = '0';
            $shop['total_wechat'] = '0.00';
            $shop['total_alipay'] = '0.00';
            $shop['total'] = '0.00';
            $shop['deliver_fee'] = '0.00';
            $shop['time'] = ForceStringFrom('time');
            return ['row' => $shop];
        }
        $number = count($list);
        if (empty($list)) {
            return $list;
        }
        foreach ($list as $k => $v) {
            $list[$k]['time_s'] = date('Y-m-d', $v['pay_time']);
        }

        $res = [];
        foreach ($list as $k => $v) {
            if (empty($res[$v['time_s']])) {
                $res[$v['time_s']] = $v;
                $res[$v['time_s']]['order_num'] = 1;
                $res[$v['time_s']]['total'] = $v['total_price'];
                if ($v['pay_type'] == '2') {  //微信
                    $res[$v['time_s']]['wechat'] = $v['total_price'];
                    $res[$v['time_s']]['alipay'] = 0;
                }
                if ($v['pay_type'] == '4') { //支付宝
                    $res[$v['time_s']]['wechat'] = 0;
                    $res[$v['time_s']]['alipay'] = $v['total_price'];
                }
            } else {
                $res[$v['time_s']]['order_num']++;
                $res[$v['time_s']]['total'] += $v['total_price'];
                $res[$v['time_s']]['deliver_fee'] += $v['deliver_fee'];
                if ($v['pay_type'] == '2') {  //微信
                    $res[$v['time_s']]['wechat'] += $v['total_price'];
                }
                if ($v['pay_type'] == '4') { //支付宝
                    $res[$v['time_s']]['alipay'] += $v['total_price'];
                }
            }
        }
        $result = [];
        foreach ($res as $k => $v) {
            $result['total_alipay'] += round($v['alipay'], 2);
            $result['total_wechat'] += round($v['wechat'], 2);
            $result['deliver_fee'] += $v['deliver_fee'];
            $res[$k]['total'] = sprintf("%.2f", round($v['alipay'] + $v['wechat'], 2));
            $res[$k]['wechat'] = sprintf("%.2f", $v['wechat'], 2);
            $res[$k]['alipay'] = sprintf("%.2f", $v['alipay'], 2);
            $res[$k]['deliver_fee'] = sprintf("%.2f", $v['deliver_fee'], 2);
        }

        $result['total_alipay'] = sprintf("%.2f", $result['total_alipay']);
        $result['total_wechat'] = sprintf("%.2f", $result['total_wechat']);
        $result['deliver_fee'] = sprintf("%.2f", $result['deliver_fee']);


        $result['shop_name'] = $GLOBALS['DB']->get_row("select shop_name from tx_shop_base where id = '{$data['shop_id']}'")['shop_name'];
        $result['number'] = $number;
        $result['total'] = sprintf("%.2f", $result['total_alipay'] + $result['total_wechat']);

        $result['time'] = ForceStringFrom('time');
        $result['shop_id'] = $data['shop_id'];
        $result['type'] = $data['type'];


        return ['list' => $res, 'row' => $result];
    }


    //判断数组中指定的key是否有重复
    public function hasRepeatedValues($arrInput, $strKey)
    {
        //参数校验
        if (!is_array($arrInput) || empty($arrInput) || empty($strKey)) {
            return false;
        }

        //获取数组中所有指定Key的值，如果为空则表示键不存在
        $arrValues = array_column($arrInput, $strKey);
        if (empty($arrValues)) {
            return false;
        }

        if (count($arrValues) != count(array_unique($arrValues))) {
            return true;
        }

        return false;
    }


    //对账导出
    public function reconciliation_export()
    {
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        }
        $data['time'] = ForceStringFrom('time');
        $data['type'] = ForceStringFrom('type');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        $sql = "select id,shop_id,pay_type,real_price as total_price,pay_time,real_deliver_fee as deliver_fee from order_base where shop_id = '{$data['shop_id']}' and pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and status = '5' and v = 2 order by pay_time";

        $list = $GLOBALS['DB']->get_results($sql);

        $number = count($list);
        if (empty($list)) {
            return $list;
        }
        foreach ($list as $k => $v) {
            $list[$k]['time_s'] = date('Y-m-d', $v['pay_time']);
        }

        $res = [];
        foreach ($list as $k => $v) {
            if (empty($res[$v['time_s']])) {
                $res[$v['time_s']] = $v;
                $res[$v['time_s']]['order_num'] = 1;
                $res[$v['time_s']]['total'] = $v['total_price'];
                if ($v['pay_type'] == '2') {  //微信
                    $res[$v['time_s']]['wechat'] = $v['total_price'];
                    $res[$v['time_s']]['alipay'] = 0;
                }
                if ($v['pay_type'] == '4') { //支付宝
                    $res[$v['time_s']]['wechat'] = 0;
                    $res[$v['time_s']]['alipay'] = $v['total_price'];
                }
            } else {
                $res[$v['time_s']]['order_num']++;
                $res[$v['time_s']]['total'] += $v['total_price'];
                $res[$v['time_s']]['deliver_fee'] += $v['deliver_fee'];
                if ($v['pay_type'] == '2') {  //微信
                    $res[$v['time_s']]['wechat'] += $v['total_price'];
                }
                if ($v['pay_type'] == '4') { //支付宝
                    $res[$v['time_s']]['alipay'] += $v['total_price'];
                }
            }
        }
        $result = [];
        foreach ($res as $k => $v) {
            $result['total_alipay'] += $v['alipay'];
            $result['total_wechat'] += $v['wechat'];
            $res[$k]['total'] = $v['alipay'] + $v['wechat'];
        }

        $result['shop_name'] = $GLOBALS['DB']->get_row("select shop_name from tx_shop_base where id = '{$data['shop_id']}'")['shop_name'];
        $result['number'] = $number;
        $result['total'] = $result['total_alipay'] + $result['total_wechat'];
        $result['time'] = $data['time'];
        $result['shop_id'] = $data['shop_id'];
        $result['type'] = $data['type'];


        $obj = new PHPExcel();
        $fileName = "金额对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账'); //设置标题
        $obj->getProperties()->setSubject('金额对账'); //设置主题
        $obj->getProperties()->setDescription('金额对账'); //设置描述
        $obj->getProperties()->setKeywords('金额对账');//设置关键词
        $obj->getProperties()->setCategory('金额对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '店铺名称')
            ->setCellValue($list[1] . '1', '日期')
            ->setCellValue($list[2] . '1', '支付宝')
            ->setCellValue($list[3] . '1', '微信')
            ->setCellValue($list[4] . '1', '对账订单')
            ->setCellValue($list[5] . '1', '对账金额');


        $res = array_values($res);


        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $result['shop_name']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['time_s']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), '￥' . $res[$i]['alipay']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), '￥' . $res[$i]['wechat']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['order_num'] . '笔');
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), '￥' . $res[$i]['total']);
        }


        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }

    public function reconciliation_detailed_export()
    {
        $data['pay_type'] = ForceStringFrom('pay_type');
        $filter['page'] = ForceStringFrom('page', '1');
        $data['time'] = ForceStringFrom('time');
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        }

        $where = "";
        $whereand = "";
        if (!empty($data['pay_type'])) {
            $where = ' and a.pay_type = ' . $data['pay_type'];
        }
        if (!empty($data['order_status'])) {
            if ($data['order_status'] < '4') {
                $where .= " and b.type = " . $data['order_status'];
            } elseif ($data['order_status'] == 5) {
                $whereand = " and b.type not in (1,2,3)";
            } else {
                $where .= " and a.status = " . $data['order_status'];
            }
        }
        $start = strtotime($data['time']);
        $end = $start + 3600 * 24 - 1;
        $sql = "select c.pay_no,b.type,a.id,a.status as order_status,a.pay_time,a.refund_status,a.order_no,a.real_price,a.pay_type,a.real_deliver_fee,a.total_price,a.deliver_fee from order_base as a left join tx_return_goods as b on a.id = b.oid {$whereand} left join pay_log as c on a.id = c.oid  where a.pay_time >= '{$start}' and a.pay_time <= '{$end}' and a.v = 2 and a.shop_id = '{$data['shop_id']}' {$where} GROUP BY a.id";
        $order = $GLOBALS['DB']->get_results($sql);
        $filter['pay_type'] = $data['pay_type'];
        $filter['time'] = $data['time'];
        $filter['shop_id'] = $data['shop_id'];
        $ids = "";
        foreach ($order as $k => $v) {
            $ids .= $v['id'] . ',';
        }
        $ids = rtrim($ids, ',');

        $sql = "select a.order_id,c.goods_pic as pic from order_item as a left join tx_goods_attr_price as b on a.goods_id = b.goods_id and a.link_id = b.link_id  left join tx_goods_stock as c on stock_id = c.id  where a.order_id in ({$ids})";
        $goods = $GLOBALS['DB']->get_results($sql);

        $order_goods = [];
        foreach ($goods as $k => $v) {
            if (empty($order_goods[$v['order_id']])) {
                if (!empty($v['pic'])) {
                    $order_goods[$v['order_id']]['pic'][] = $v['pic'];
                } else {
                    $order_goods[$v['order_id']]['pic'] = [];
                }
            } else {
                if (!empty($v['pic'])) {
                    $order_goods[$v['order_id']]['pic'][] = $v['pic'];
                }
            }
        }

        //1 退货 2 退款 3 换货
        foreach ($order as $k => $v) {
            $order[$k]['pic'] = $order_goods[$v['id']]['pic'];
            if ($v['pay_type'] == '2') {
                $order[$k]['pay'] = '微信';
            }
            if ($v['pay_type'] == '4') {
                $order[$k]['pay'] = '支付宝';
            }
            if ($v['type'] == '1') {
                $order[$k]['status'] = '有退货';
            }
            if ($v['type'] == '2') {
                $order[$k]['status'] = '仅退款';
            }
            if ($v['type'] == '3') {
                $order[$k]['status'] = '有换货';
            }
            if (empty($v['type'])) {
                $order[$k]['status'] = $v['order_status'];
            }
        }


        $obj = new PHPExcel();
        $fileName = "金额对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账'); //设置标题
        $obj->getProperties()->setSubject('金额对账'); //设置主题
        $obj->getProperties()->setDescription('金额对账'); //设置描述
        $obj->getProperties()->setKeywords('金额对账');//设置关键词
        $obj->getProperties()->setCategory('金额对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '订单编号')
            ->setCellValue($list[1] . '1', '商品列表')
            ->setCellValue($list[2] . '1', '付款时间')
            ->setCellValue($list[3] . '1', '应付金额(含运费)')
            ->setCellValue($list[4] . '1', '入账金额(含运费)')
            ->setCellValue($list[5] . '1', '支付方式')
            ->setCellValue($list[6] . '1', '交易流水号')
            ->setCellValue($list[7] . '1', '状态');
        define('BASE_PATH', str_replace('\\', '/', realpath(ROOT_PATH . '/')) . "/");
        include BASE_PATH . 'www/tx.config.php';

        foreach ($order as $k => $v) {
            if (is_numeric($v['status'])) {
                $order[$k]['status'] = $tx_config['order_status'][$v['status']];
            }
        }

        $res = array_values($order);

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), "");
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), date('Y-m-d H:i:s', $res[$i]['pay_time']));
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), '￥' . $res[$i]['total_price'] . "(￥" . $res[$i]['deliver_fee'] . ")");
            $obj->getActiveSheet()->setCellValue('E' . (2 + $i), '￥' . $res[$i]['real_price'] . "(￥" . $res[$i]['real_deliver_fee'] . ")");
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), $res[$i]['pay']);
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), $res[$i]['pay_no']);
            $obj->getActiveSheet()->setCellValue("H" . (2 + $i), $res[$i]['status']);
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }


    public function reconciliation_detailed()
    {
        $data['pay_type'] = ForceStringFrom('pay_type');
        $data['order_status'] = ForceStringFrom('order_status');
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $data['time'] = ForceStringFrom('time');
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        }
        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        $where = "";
        $whereand = "";
        if (!empty($data['pay_type'])) {
            $where = ' and a.pay_type = ' . $data['pay_type'];
        }
        if (!empty($data['order_status'])) {
            if ($data['order_status'] < '4') {
                $where .= " and b.type = " . $data['order_status'];
            } elseif ($data['order_status'] == 5) {
                $whereand = " and b.type not in (1,2,3)";
            } else {
                $where .= " and a.status = " . $data['order_status'];
            }
        }
        $start = strtotime($data['time']);
        $end = $start + 3600 * 24 - 1;
        $sql = "select c.pay_no,b.type,a.id,a.status as order_status,a.pay_time,a.refund_status,a.order_no,a.real_price,a.pay_type,a.real_deliver_fee,a.total_price,a.deliver_fee from order_base as a left join tx_return_goods as b on a.id = b.oid {$whereand} left join pay_log as c on a.id = c.oid  where a.pay_time >= '{$start}' and a.pay_time <= '{$end}' and a.shop_id = '{$data['shop_id']}' and a.v = 2 {$where} GROUP BY a.id {$limit}";
        $order = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from order_base as a left join tx_return_goods as b on a.id = b.oid left join pay_log as c on a.id = c.oid  where a.pay_time >= '{$start}' and a.pay_time <= '{$end}' and a.shop_id = '{$data['shop_id']}' and a.v = 2 {$where} GROUP BY a.id ";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        $filter['order_status'] = $data['order_status'];
        $filter['pay_type'] = $data['pay_type'];
        $filter['time'] = $data['time'];
        $filter['shop_id'] = $data['shop_id'];
        $ids = "";
        foreach ($order as $k => $v) {
            $ids .= $v['id'] . ',';
        }
        $ids = rtrim($ids, ',');

        $sql = "select a.order_id,c.goods_pic as pic from order_item as a left join tx_goods_attr_price as b on a.goods_id = b.goods_id and a.link_id = b.link_id  left join tx_goods_stock as c on stock_id = c.id  where a.order_id in ({$ids})";
        $goods = $GLOBALS['DB']->get_results($sql);

        $order_goods = [];
        foreach ($goods as $k => $v) {
            if (empty($order_goods[$v['order_id']])) {
                if (!empty($v['pic'])) {
                    $order_goods[$v['order_id']]['pic'][] = $v['pic'];
                } else {
                    $order_goods[$v['order_id']]['pic'] = [];
                }
            } else {
                if (!empty($v['pic'])) {
                    $order_goods[$v['order_id']]['pic'][] = $v['pic'];
                }
            }
        }

        //1 退货 2 退款 3 换货
        foreach ($order as $k => $v) {
            $order[$k]['pic'] = $order_goods[$v['id']]['pic'];
            if ($v['pay_type'] == '2') {
                $order[$k]['pay'] = '微信';
            }
            if ($v['pay_type'] == '4') {
                $order[$k]['pay'] = '支付宝';
            }
            if ($v['type'] == '1') {
                $order[$k]['status'] = '有退货';
            }
            if ($v['type'] == '2') {
                $order[$k]['status'] = '仅退款';
            }
            if ($v['type'] == '3') {
                $order[$k]['status'] = '有换货';
            }
            if (empty($v['type'])) {
                $order[$k]['status'] = $v['order_status'];
            }
        }

        return ['list' => $order, 'filter' => $filter];
    }


    public function reconciliation_confirm()
    {
        $data['time'] = ForceStringFrom('time');
        $ri = date('d');
        if ($ri < 20) {
            backError("上月账单需在本月20号后进行对账");
        }
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $time = time();
        $sql = "select * from tx_reconciliation where shop_id = '{$data['shop_id']}' and time = '{$data['time']}' and status = '1'";
        $list = $GLOBALS['DB']->get_row($sql);
        if (!empty($list)) {
            backError("已对账，无法再次对账");
            die;
        }
        $sql = "insert into tx_reconciliation set shop_id = '{$data['shop_id']}',time = '{$data['time']}',addtime = '{$time}',status = '1'";
        if ($GLOBALS['DB']->query($sql)) {
            backSuccess('对账成功');
            die;
        } else {
            backError("对账失败");
            die;
        }
    }


    public function reconciliation_record()
    {
        $shop_id = ForceStringFrom('shop_id');
        if (empty($shop_id)) {
            $data['shop_id'] = ForceStringFrom('record');
        } else {
            $data['shop_id'] = $shop_id;
        }

        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }

        $sql = "select * from tx_shop_base where id = " . $data['shop_id'];
        $shop = $GLOBALS['DB']->get_row($sql);

        $strtotime = $shop['join_time'];
        $y = date('Y', $strtotime);
        $ys = date('Y', time());
        $m = (int)date('m', $strtotime);
        $ms = (int)date('m', time());
        $chaY = $ys - $y;
        $chaM = 12 - $m + $ms;
        $yearmeth = $chaM + (($chaY - 1) * 12);  //开店到现在相差几个月

        $sql = "select a.id,a.shop_name,join_time from tx_shop_base as a  where a.id = '{$data['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);

        $sql = "select * from tx_reconciliation where status = '1' and shop_id = '{$data['shop_id']}'";
        $reconciliation = $GLOBALS['DB']->get_results($sql);

        $nian = date('Y', $shop['join_time']);
        $yue = date('m', $shop['join_time']);

        $result = [];
        for ($i = 0; $i < $yearmeth; $i++) {
            $time = $this->mFristAndLast($nian, $yue);

            $sql = "select real_deliver_fee as deliver_fee,id,shop_id,pay_type,status as order_status,pay_time,real_price as total_price from order_base where shop_id = '{$data['shop_id'] }' and pay_time > '{$time['firstday']}' and pay_time < '{$time['lastday']}' and v = 2";
            $result[] = $GLOBALS['DB']->get_results($sql);
            if (empty($result[$i])) {
                $result[$i]['time'] = date('Ym', $time['firstday']);
            }
            if ($yue == '12') {
                $nian = $nian + 1;
            } else {
                $yue = $yue + 1;
            }
        }

        $arr = [];
        foreach ($result as $k => $v) {
            foreach ($v as $key => $val) {
                if (!empty($val['pay_time'])) {
                    $result[$k][$key]['time'] = date('Y', $val['pay_time']) . date('m', $val['pay_time']);
                    $arr[$k]['num'] = count($v);
                    if ($val['pay_type'] == '2') {
                        $arr[$k]['paytype'] = '微信支付';
                        $arr[$k]['wechat'] += $val['total_price'];
                    } elseif ($val['pay_type'] == '4') {
                        $arr[$k]['paytype'] = '支付宝';
                        $arr[$k]['alipay'] += $val['total_price'];
                    }
                    $arr[$k]['total'] += $val['total_price'];
                    $arr[$k]['time'] = date('Y', $val['pay_time']) . date('m', $val['pay_time']);

                    if (!empty($val['deliver_fee'])) {
                        $arr[$k]['deliver_fee'] += $val['deliver_fee'];
                    }
                }
            }

            if (empty($v[$key]['id'])) {
                $arr[$k]['time'] = $v['time'];
                $arr[$k]['paytype'] = "";
                $arr[$k]['alipay'] = "0";
                $arr[$k]['total'] = "0";
                $arr[$k]['wechat'] = "0";
                $arr[$k]['num'] = "0";
                $arr[$k]['deliver_fee'] = "0";
            }
        }

        foreach ($arr as $k => $v) {
            foreach ($reconciliation as $key => $val) {
                if ($v['time'] == $val['time']) {
                    $arr[$k]['status'] = '1';
                    $arr[$k]['addtime'] = $val['addtime'];
                    break;
                } else {
                    $arr[$k]['status'] = '2';
                    $arr[$k]['addtime'] = '0';
                }
            }
            $arr[$k]['shop_id'] = $val['shop_id'];
            $arr[$k]['time_s'] = substr($v['time'], 0, 4) . '-' . substr($v['time'], 4, 2);
        }

        $list = $this->arraySort($arr, 'time', 'a');
        foreach ($list as $k => $v) {
            $list[$k]['alipay'] = sprintf("%.2f", $v['alipay'], 2);
            $list[$k]['wechat'] = sprintf("%.2f", $v['wechat'], 2);
            $list[$k]['total'] = sprintf("%.2f", $v['total'], 2);
            $list[$k]['deliver_fee'] = sprintf("%.2f", $v['deliver_fee'], 2);
        }
        return ['list' => $list, 'shop' => $shop];
    }


    public function reconciliation_list_shop_export()
    {
        $shop_id = ForceStringFrom('shop_id');
        if (empty($shop_id)) {
            $data['shop_id'] = ForceStringFrom('record');
        } else {
            $data['shop_id'] = $shop_id;
        }

        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }

        $sql = "select * from tx_shop_base where id = " . $data['shop_id'];
        $shop = $GLOBALS['DB']->get_row($sql);

        $strtotime = $shop['join_time'];
        $y = date('Y', $strtotime);
        $ys = date('Y', time());
        $m = (int)date('m', $strtotime);
        $ms = (int)date('m', time());
        $chaY = $ys - $y;
        $chaM = 12 - $m + $ms;
        $yearmeth = $chaM + (($chaY - 1) * 12);  //开店到现在相差几个月

        $sql = "select a.id,a.shop_name,join_time from tx_shop_base as a  where a.id = '{$data['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);

        $sql = "select * from tx_reconciliation where status = '1' and shop_id = '{$data['shop_id']}'";
        $reconciliation = $GLOBALS['DB']->get_results($sql);

        $nian = date('Y', $shop['join_time']);
        $yue = date('m', $shop['join_time']);

        $result = [];
        for ($i = 0; $i < $yearmeth; $i++) {
            $time = $this->mFristAndLast($nian, $yue);

            $sql = "select real_deliver_fee as deliver_fee,id,shop_id,pay_type,status as order_status,pay_time,real_price as total_price from order_base where shop_id = '{$data['shop_id'] }' and pay_time > '{$time['firstday']}' and pay_time < '{$time['lastday']}' and v = 2";
            $result[] = $GLOBALS['DB']->get_results($sql);
            if (empty($result[$i])) {
                $result[$i]['time'] = date('Ym', $time['firstday']);
            }
            if ($yue == '12') {
                $nian = $nian + 1;
            } else {
                $yue = $yue + 1;
            }
        }

        $arr = [];
        foreach ($result as $k => $v) {
            foreach ($v as $key => $val) {
                if (!empty($val['pay_time'])) {
                    $result[$k][$key]['time'] = date('Y', $val['pay_time']) . date('m', $val['pay_time']);
                    $arr[$k]['num'] = count($v);
                    if ($val['pay_type'] == '2') {
                        $arr[$k]['paytype'] = '微信支付';
                        $arr[$k]['wechat'] += $val['total_price'];
                    } elseif ($val['pay_type'] == '4') {
                        $arr[$k]['paytype'] = '支付宝';
                        $arr[$k]['alipay'] += $val['total_price'];
                    }
                    $arr[$k]['total'] += $val['total_price'];
                    $arr[$k]['time'] = date('Y', $val['pay_time']) . date('m', $val['pay_time']);

                    if (!empty($val['deliver_fee'])) {
                        $arr[$k]['deliver_fee'] += $val['deliver_fee'];
                    }
                }
            }

            if (empty($v[$key]['id'])) {
                $arr[$k]['time'] = $v['time'];
                $arr[$k]['paytype'] = "";
                $arr[$k]['alipay'] = "0";
                $arr[$k]['total'] = "0";
                $arr[$k]['wechat'] = "0";
                $arr[$k]['num'] = "0";
                $arr[$k]['deliver_fee'] = "0";
            }
        }

        foreach ($arr as $k => $v) {
            foreach ($reconciliation as $key => $val) {
                if ($v['time'] == $val['time']) {
                    $arr[$k]['status'] = '1';
                    $arr[$k]['addtime'] = $val['addtime'];
                    break;
                } else {
                    $arr[$k]['status'] = '2';
                    $arr[$k]['addtime'] = '0';
                }
            }
            $arr[$k]['shop_id'] = $val['shop_id'];
            $arr[$k]['time_s'] = substr($v['time'], 0, 4) . '-' . substr($v['time'], 4, 2);
        }
        $list = $this->arraySort($arr, 'time', 'a');
        $order = $list;

        $obj = new PHPExcel();
        $fileName = "金额对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账'); //设置标题
        $obj->getProperties()->setSubject('金额对账'); //设置主题
        $obj->getProperties()->setDescription('金额对账'); //设置描述
        $obj->getProperties()->setKeywords('金额对账');//设置关键词
        $obj->getProperties()->setCategory('金额对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '对账日期')
            ->setCellValue($list[1] . '1', '账单周期')
            ->setCellValue($list[2] . '1', '支付宝')
            ->setCellValue($list[3] . '1', '微信')
            ->setCellValue($list[4] . '1', '对账订单')
            ->setCellValue($list[5] . '1', '对账金额(含运费)')
            ->setCellValue($list[6] . '1', '对账状态');

        $res = array_values($order);

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), date('Y-m-d H:i:s', $res[$i]['addtime']));
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['time_s']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), '￥' . $res[$i]['alipay']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), '￥' . $res[$i]['wechat']);
            $obj->getActiveSheet()->setCellValue('E' . (2 + $i), $res[$i]['num']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), '￥' . $res[$i]['total'] . "(￥" . $res[$i]['deliver_fee'] . ")");
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), ($res[$i]['status'] == '1' ? "已对账" : '未对账'));
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }


    }


    public function arraySort($array, $keys, $sort = 'asc')
    {
        $newArr = $valArr = array();
        foreach ($array as $key => $value) {
            $valArr[$key] = $value[$keys];
        }
        ($sort == 'asc') ? asort($valArr) : arsort($valArr);
        reset($valArr);
        foreach ($valArr as $key => $value) {
            $newArr[$key] = $array[$key];
        }
        return $newArr;
    }


    //对账goods_number
    public function goods_reconciliation_list()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['shop_name'] = ForceStringFrom('shop_name'); //店铺名称 ||id
        $filter['status'] = ForceStringFrom('status');
        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }

        $search = "";
        if (!empty($filter['shop_name'])) {
            if (is_numeric($filter['shop_name'])) {
                $search = " where a.id = " . $filter['shop_name'];
            } else {
                $search = " where a.shop_name like '%{$filter['shop_name']}%'";
            }
        }


        $status = "";
        if (!empty($filter['status'])) {
            if ($filter['status'] == '1') {
                $status = " where b.time is not null";
                if (!empty($filter['shop_name'])) {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " and b.time = '{$nianyue}' and  b.time is not null";

                } else {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " where  b.time is not null";
                }
            } else {
                $status = " and b.time is null";
            }
        }

        $nian = date('Y');
        $yue = date('m');
        if ($yue == '1') {
            $nian = $nian - 1;
        } else {
            $yue = $yue - 1;
        }
        if ($yue < 10) {
            $yue = '0' . $yue;
        }
        $times = $nian . $yue;

//        if(!empty($filter['shop_name']) && !empty($filter['status'])){
//            $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.time = '{$times}' and  b.status = '2'  {$search} {$status}  group by a.id " . $limit;
//        }else{
//            if(!empty($filter['shop_name'])){
//                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.time = '{$times}' and  b.status = '2'  {$search} {$status}  group by a.id " . $limit;
//            }
//            if(!empty($filter['status'])){
//                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.time = '{$times}' and  b.status = '2'  {$search} {$status}  group by a.id " . $limit;
//            }
//            if(empty($filter['shop_name']) && empty($filter['status'])){
//                $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.time = '{$times}' and  b.status = '2'  {$search} {$status}  group by a.id " . $limit;
//            }
//        }


        $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.time = '{$times}' and  b.status = '2'  {$search} {$status}  group by a.id " . $limit;

        $shop = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_shop_base";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        foreach ($shop as $k => $v) {
            if (empty($v['time'])) {
                $shop[$k]['status'] = '2';
                if (date('Ym', $v['join_time']) == date('Ym')) {
                    $shop[$k]['duizhang'] = '0';
                } else {
                    $shop[$k]['duizhang'] = date('Ym', $v['join_time']);
                }
            } else {
                $nian = date('Y'); //当前年
                $yue = date('m'); //当前月
                if ($yue == '1') {
                    $nianyue = $nian - 1 . '12';
                } else {
                    $nianyue = $nian . $yue - 1;
                }
                if ($v['time'] == $nianyue) {
                    $shop[$k]['status'] = '1';
                    $shop[$k]['duizhang'] = $nianyue;
                } else {
                    $shop[$k]['status'] = '2';
                    $shop[$k]['addtime'] = '';
                    $dui_nian = substr($v['time'], 0, 4);
                    $dui_yue = substr($v['time'], 4, 2);
                    if ($dui_yue == '12') {
                        $shop[$k]['duizhang'] = $dui_nian + 1 . '01';
                    } else {
                        $shop[$k]['duizhang'] = $dui_nian . $dui_yue + 1;
                    }
                }
            }
        }


        foreach ($shop as $k => $v) {
            if ($v['duizhang'] > '0') {
                $nian = substr($v['duizhang'], 0, 4);
                $yue = substr($v['duizhang'], 4, 2);
                $nianyue = $this->mFristAndLast($nian, $yue);
                $sql = "select count(*) as total_num,sum(real_sku_sales) as goods_num from order_base as a where shop_id = '{$v['id']}' and pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and status = '5' and v = 2";

                $row = $GLOBALS['DB']->get_row($sql);

                if (empty($row['goods_num'])) {
                    $row['goods_num'] = 0;
                }

                $shop[$k]['total_num'] = $row['total_num'];  //订单数量
                $shop[$k]['goods_num'] = $row['goods_num'];  //商品数量
            }

            if ($shop[$k]['total_num'] == '') {
                $shop[$k]['total_num'] = '0';
            }

            if ($shop[$k]['goods_num'] == '') {
                $shop[$k]['goods_num'] = '0';  //商品数量
            }
        }

        return ['list' => $shop, 'filter' => $filter];
    }

    //对账导出
    public function goods_reconciliation_list_export()
    {
        $filter['shop_name'] = ForceStringFrom('shop_name'); //店铺名称 ||id
        $filter['status'] = ForceStringFrom('status'); //店铺名称 ||id


        $search = "";
        if (!empty($filter['shop_name'])) {
            if (is_numeric($filter['shop_name'])) {
                $search = " where a.id = " . $filter['shop_name'];
            } else {
                $search = " where a.shop_name like '%{$filter['shop_name']}%'";
            }
        }


        $status = "";
        if (!empty($filter['status'])) {
            if ($filter['status'] == '1') {
                if (!empty($filter['shop_name'])) {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " and b.time = " . $nianyue;

                } else {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " where b.time = " . $nianyue;
                }
            }
        }

        $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,b.addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '2' {$search} {$status} group by a.id ";
        $shop = $GLOBALS['DB']->get_results($sql);

        foreach ($shop as $k => $v) {
            if (empty($v['time'])) {
                $shop[$k]['status'] = '2';
                if (date('Ym', $v['join_time']) == date('Ym')) {
                    $shop[$k]['duizhang'] = '0';
                } else {
                    $shop[$k]['duizhang'] = date('Ym', $v['join_time']);
                }
            } else {
                $nian = date('Y'); //当前年
                $yue = date('m'); //当前月
                if ($yue == '1') {
                    $nianyue = $nian - 1 . '12';
                } else {
                    $nianyue = $nian . $yue - 1;
                }
                if ($v['time'] == $nianyue) {
                    $shop[$k]['status'] = '1';
                    $shop[$k]['duizhang'] = $nianyue;
                } else {
                    $shop[$k]['status'] = '2';
                    $shop[$k]['addtime'] = '';
                    $dui_nian = substr($v['time'], 0, 4);
                    $dui_yue = substr($v['time'], 4, 2);
                    if ($dui_yue == '12') {
                        $shop[$k]['duizhang'] = $dui_nian + 1 . '01';
                    } else {
                        $shop[$k]['duizhang'] = $dui_nian . $dui_yue + 1;
                    }
                }
            }
        }


        foreach ($shop as $k => $v) {
            if ($v['duizhang'] > '0') {
                $nian = substr($v['duizhang'], 0, 4);
                $yue = substr($v['duizhang'], 4, 2);
                $nianyue = $this->mFristAndLast($nian, $yue);
                $sql = "select count(*) as total_num,sum(real_sku_sales) as goods_num from order_base as a where shop_id = '{$v['id']}' and pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and status = '5' and v = 2";

                $row = $GLOBALS['DB']->get_row($sql);

                if (empty($row['goods_num'])) {
                    $row['goods_num'] = 0;
                }

                $shop[$k]['total_num'] = $row['total_num'];  //订单数量
                $shop[$k]['goods_num'] = $row['goods_num'];  //商品数量
            }

            if ($shop[$k]['total_num'] == '') {
                $shop[$k]['total_num'] = '0';
            }

            if ($shop[$k]['goods_num'] == '') {
                $shop[$k]['goods_num'] = '0';  //商品数量
            }
        }


        $obj = new PHPExcel();
        $fileName = "销量对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('销量对账'); //设置标题
        $obj->getProperties()->setSubject('销量对账'); //设置主题
        $obj->getProperties()->setDescription('销量对账'); //设置描述
        $obj->getProperties()->setKeywords('销量对账');//设置关键词
        $obj->getProperties()->setCategory('销量对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('销量对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '店铺ID')
            ->setCellValue($list[1] . '1', '店铺名称')
            ->setCellValue($list[2] . '1', '对账销量')
            ->setCellValue($list[3] . '1', '对账订单')
            ->setCellValue($list[4] . '1', '对账时间')
            ->setCellValue($list[5] . '1', '对账状态');

        $res = array_values($shop);
        for ($i = 0; $i < count($res); $i++) {
            if ($res[$i]['addtime']) {
                $time = date("Y-m-d H:i:s", $res[$i]['addtime']);
            } else {
                $time = "";
            }

            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['id']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['shop_name']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['goods_num']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['total_num']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $time);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), ($res[$i]['status'] == '1' ? "已对账" : "未对账"));
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }

    }

    public function goods_reconciliation_list_shop()
    {
        $shop_id = ForceStringFrom('shop_id');
        if (empty($shop_id)) {
            $data['shop_id'] = ForceStringFrom('record');
        } else {
            $data['shop_id'] = $shop_id;
        }

        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $sql = "select * from tx_shop_base where id = " . $data['shop_id'];
        $shop = $GLOBALS['DB']->get_row($sql);
        $strtotime = $shop['join_time'];
        $y = date('Y', $strtotime);
        $ys = date('Y', time());
        $m = (int)date('m', $strtotime);
        $ms = (int)date('m', time());
        $chaY = $ys - $y;
        $chaM = 12 - $m + $ms;
        $yearmeth = $chaM + (($chaY - 1) * 12);  //开店到现在相差几个月
        $start_n = date('Y', $shop['join_time']);
        $start_y = date('m', $shop['join_time']);

        $result = [];
        for ($i = 0; $i < $yearmeth; $i++) {
            $time = $this->mFristAndLast($start_n, $start_y);
            $sql = "select count(*) as num,sum(goods_num) as real_sku_sales from order_base where shop_id = '{$data['shop_id']}' and pay_time > '{$time['firstday']}' and pay_time < '{$time['lastday']}' and status = 5 and v = 2";

            $arr = $GLOBALS['DB']->get_row($sql);
            if (empty($arr['num'])) {
                $result[$i]['num'] = 0;
            } else {
                $result[$i]['num'] = $arr['num'];
            }
            if (empty($arr['real_sku_sales'])) {
                $result[$i]['real_sku_sales'] = 0;
            } else {
                $result[$i]['real_sku_sales'] = $arr['real_sku_sales'];
            }
            $result[$i]['time'] = date('Ym', $time['firstday']);
            $result[$i]['time_s'] = date('Y-m', $time['firstday']);
            if ($start_y == 12) {
                $start_n--;
                $start_y = 1;
            } else {
                $start_y++;
            }
        }

        //对账表
        $sql = "select * from tx_reconciliation where status = '2' and shop_id = '{$data['shop_id']}'";
        $row = $GLOBALS['DB']->get_results($sql);
        $res = [];
        foreach ($row as $k => $v) {
            $res[$v['time']] = $v;
        }

        foreach ($result as $k => $v) {
            if (empty($res[$v['time']])) {
                $result[$k]['addtime'] = "";
                $result[$k]['res_sttaus'] = 2;
            } else {
                $result[$k]['addtime'] = $res[$v['time']]['addtime'];
                $result[$k]['res_sttaus'] = 1;
            }
        }
        return ['list' => $result, 'shop' => $shop];
    }

    public function goods_reconciliation_price_export()
    {
        $shop_id = ForceStringFrom('shop_id');
        if (empty($shop_id)) {
            $data['shop_id'] = ForceStringFrom('record');
        } else {
            $data['shop_id'] = $shop_id;
        }

        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $sql = "select * from tx_shop_base where id = " . $data['shop_id'];
        $shop = $GLOBALS['DB']->get_row($sql);
        $strtotime = $shop['join_time'];
        $y = date('Y', $strtotime);
        $ys = date('Y', time());
        $m = (int)date('m', $strtotime);
        $ms = (int)date('m', time());
        $chaY = $ys - $y;
        $chaM = 12 - $m + $ms;
        $yearmeth = $chaM + (($chaY - 1) * 12);  //开店到现在相差几个月
        $start_n = date('Y', $shop['join_time']);
        $start_y = date('m', $shop['join_time']);

        $result = [];
        for ($i = 0; $i < $yearmeth; $i++) {
            $time = $this->mFristAndLast($start_n, $start_y);
            $sql = "select count(*) as num,sum(goods_num) as real_sku_sales from order_base where shop_id = '{$data['shop_id']}' and pay_time > '{$time['firstday']}' and pay_time < '{$time['lastday']}' and status = 5 and v = 2";

            $arr = $GLOBALS['DB']->get_row($sql);
            if (empty($arr['num'])) {
                $result[$i]['num'] = 0;
            } else {
                $result[$i]['num'] = $arr['num'];
            }
            if (empty($arr['real_sku_sales'])) {
                $result[$i]['real_sku_sales'] = 0;
            } else {
                $result[$i]['real_sku_sales'] = $arr['real_sku_sales'];
            }
            $result[$i]['time'] = date('Ym', $time['firstday']);
            $result[$i]['time_s'] = date('Y-m', $time['firstday']);
            if ($start_y == 12) {
                $start_n--;
                $start_y = 1;
            } else {
                $start_y++;
            }
        }

        //对账表
        $sql = "select * from tx_reconciliation where status = '2' and shop_id = '{$data['shop_id']}'";
        $row = $GLOBALS['DB']->get_results($sql);
        $res = [];
        foreach ($row as $k => $v) {
            $res[$v['time']] = $v;
        }

        foreach ($result as $k => $v) {
            if (empty($res[$v['time']])) {
                $result[$k]['addtime'] = "";
                $result[$k]['res_sttaus'] = 2;
            } else {
                $result[$k]['addtime'] = $res[$v['time']]['addtime'];
                $result[$k]['res_sttaus'] = 1;
            }
        }


        $obj = new PHPExcel();
        $fileName = "销量对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('销量对账'); //设置标题
        $obj->getProperties()->setSubject('销量对账'); //设置主题
        $obj->getProperties()->setDescription('销量对账'); //设置描述
        $obj->getProperties()->setKeywords('销量对账');//设置关键词
        $obj->getProperties()->setCategory('销量对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('销量对账');


        $list = ['A', 'B', 'C', 'D', 'E'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '对账日期')
            ->setCellValue($list[1] . '1', '账单周期')
            ->setCellValue($list[2] . '1', '对账订单')
            ->setCellValue($list[3] . '1', '对账销量')
            ->setCellValue($list[4] . '1', '对账状态');

        $res = array_values($result);
        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), date('Y-m-d H:i:s', $res[$i]['addtime']));
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['time_s']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['num']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['real_sku_sales']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), ($res[$i]['res_sttaus'] == '1' ? "已对账" : "未对账"));
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }


    }


    public function goods_reconciliation_reconciliation()
    {
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $data['time'] = ForceStringFrom('time');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        $sql = "select id,shop_name from tx_shop_base where id = '{$data['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);
        $shop['time'] = $data['time'];
        $sql = "select count(*) as total_num,sum(goods_num) as goods_num from order_base where shop_id = {$shop['id']} and pay_time > '{$nianyue['firstday']}'  and pay_time < '{$nianyue['lastday']}' and v = 2";


        $order = $GLOBALS['DB']->get_row($sql);

        $shop['total_num'] = $order['total_num']; //订单

        $shop['goods_num'] = $order['goods_num'];//销量

        //status = 成功
        $sql = "select a.id,(select sum(goods_num) from order_base where pay_time > '{$nianyue['firstday']}'  and pay_time < '{$nianyue['lastday']}' and shop_id = '{$shop['id']}' and v = 2) as num,d.sku,d.sku_name,d.goods_pic,b.goods_id from order_base as a left join order_item as b on a.id = b.order_id left join tx_goods_attr_price as c on b.goods_id = c.goods_id and b.link_id = c.link_id left join tx_goods_stock as d on c.stock_id = d.id and a.shop_id = d.shop_id where  a.pay_time > '{$nianyue['firstday']}'  and a.pay_time < '{$nianyue['lastday']}' and a.shop_id = '{$shop['id']}' and a.v = 2 group by d.id";


        $goods = $GLOBALS['DB']->get_results($sql);

//        $arr = [];
//        foreach($goods as $k =>$v){
//            if(empty($arr[$v['goods_id']])){
//                $arr[$v['goods_id']] = $v;
//            }else{
//                $arr[$v['goods_id']]['num'] += $v['num'];
//            }
//        }

        return ['list' => $goods, 'shop' => $shop];
    }

    public function goods_reconciliation_confirm()
    {
        $data['time'] = ForceStringFrom('time');
        $data['shop_id'] = ForceStringFrom('shop_id');
        $time = time();
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $sql = "select * from tx_reconciliation where shop_id = '{$data['shop_id']}' and time = '{$data['time']}' and status = '2'";
        $list = $GLOBALS['DB']->get_row($sql);
        if (!empty($list)) {
            backError("已对账，无法再次对账");
            die;
        }
        $sql = "insert into tx_reconciliation set shop_id = '{$data['shop_id']}',time = '{$data['time']}',addtime = '{$time}',status = '2'";
        if ($GLOBALS['DB']->query($sql)) {
            backSuccess('对账成功');
            die;
        } else {
            backError("对账失败");
            die;
        }
    }


    //销量
    public function goods_reconciliation_export()
    {
        $data['shop_id'] = ForceStringFrom('shop_id');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $data['time'] = ForceStringFrom('time');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        $sql = "select id,shop_name from tx_shop_base where id = '{$data['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);
        $shop['time'] = $data['time'];
        $sql = "select count(*) as total_num,sum(goods_num) as goods_num from order_base where shop_id = {$shop['id']} and pay_time > '{$nianyue['firstday']}'  and pay_time < '{$nianyue['lastday']}' and v = 2";


        $order = $GLOBALS['DB']->get_row($sql);

        $shop['total_num'] = $order['total_num']; //订单

        $shop['goods_num'] = $order['goods_num'];//销量

        //status = 成功
        $sql = "select a.id,a.goods_num as num,d.sku,d.sku_name,d.goods_pic,b.goods_id from order_base as a left join order_item as b on a.id = b.order_id left join tx_goods_attr_price as c on b.goods_id = c.goods_id and b.link_id = c.link_id left join tx_goods_stock as d on c.stock_id = d.id and a.shop_id = d.shop_id where  a.pay_time > '{$nianyue['firstday']}'  and a.pay_time < '{$nianyue['lastday']}' and a.shop_id = '{$shop['id']}' and a.v = 2 group by a.id";

        $goods = $GLOBALS['DB']->get_results($sql);
        $arr = [];
        foreach ($goods as $k => $v) {
            if (empty($arr[$v['goods_id']])) {
                $arr[$v['goods_id']] = $v;
            } else {
                $arr[$v['goods_id']]['num'] += $v['num'];
            }
        }


        $obj = new PHPExcel();
        $fileName = "销量对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('销量对账'); //设置标题
        $obj->getProperties()->setSubject('销量对账'); //设置主题
        $obj->getProperties()->setDescription('销量对账'); //设置描述
        $obj->getProperties()->setKeywords('销量对账');//设置关键词
        $obj->getProperties()->setCategory('销量对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('销量对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '店铺名称')
            ->setCellValue($list[1] . '1', '总订单')
            ->setCellValue($list[2] . '1', '总销量')
            ->setCellValue($list[3] . '1', 'SKU')
            ->setCellValue($list[4] . '1', 'SKU名称')
            ->setCellValue($list[5] . '1', '对账销量');


        $res = array_values($arr);
        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $shop['shop_name']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $shop['total_num']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $shop['goods_num']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['sku']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['sku_name']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), $res[$i]['num']);
        }


        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }


    public function goods_reconciliation_detailed()
    {
        $data['pay_type'] = ForceStringFrom('pay_type');
        $data['order_status'] = ForceStringFrom('order_status');
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $data['time'] = ForceStringFrom('time');
        $data['shop_id'] = ForceStringFrom('shop_id');
        $data['order_id'] = ForceStringFrom('order_id');
        $data['goods_id'] = ForceStringFrom('goods_id');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }

        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }

        $where = "";
        $whereand = "";
        if (!empty($data['pay_type'])) {
            $where = ' and b.pay_type = ' . $data['pay_type'];
        }

        if (!empty($data['order_status'])) {
            if ($data['order_status'] < '4') {
                $where .= " and c.type = " . $data['order_status'];
            } elseif ($data['order_status'] == 5) {
                $whereand = " and c.type not in (1,2,3)";
            } else {
                $where .= " and a.status = " . $data['order_status'];
            }
        }
        $sql = "select b.status,d.pay_no,c.type,b.real_sku_sales,b.id,b.order_no,b.pay_time,b.pay_type,b.goods_num from order_item as a left join order_base as b on b.id = a.order_id left join tx_return_goods as c on a.id = c.oiid and c.status = 4 {$whereand} left join pay_log as d on b.id = d.oid  where a.goods_id = '{$data['goods_id']}' and  b.shop_id = '{$data['shop_id']}' and b.status = 5 and b.pay_time > '{$nianyue['firstday']}' and b.pay_time < '{$nianyue['lastday']}' and b.v = 2 {$where} group by
b.id {$limit}";

        $list = $GLOBALS['DB']->get_results($sql);


        $sql = "select count(*) from (select count(*) from order_item as a left join order_base as b on b.id = a.order_id left join tx_return_goods as c on a.id = c.oiid and c.status = 4 {$whereand} left join pay_log as d on b.id = d.oid  where a.goods_id = '{$data['goods_id']}' and  b.shop_id = '{$data['shop_id']}' and b.status = 5 and b.pay_time > '{$nianyue['firstday']}' and b.pay_time < '{$nianyue['lastday']}' and b.v = 2 {$where} group by b.id) as abc";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        foreach ($list as $k => $v) {
            if ($v['pay_type'] == '2') {
                $list[$k]['app_pay'] = "微信";
            } else {
                $list[$k]['app_pay'] = "支付宝";
            }

            if (!empty($v['type'])) {
                if ($v['type'] == '1') {
                    $list[$k]['app_status'] = "有退货";
                }
                if ($v['type'] == '2') {
                    $list[$k]['app_status'] = "仅退款";
                }
                if ($v['type'] == '3') {
                    $list[$k]['app_status'] = "有换货";
                }
            }
        }
        return ['list' => $list, 'filter' => $filter, 'data' => $data];
    }

    //导出
    public function goods_reconciliation_detailed_export()
    {
        $data['pay_type'] = ForceStringFrom('pay_type');
        $data['order_status'] = ForceStringFrom('order_status');
        $data['time'] = ForceStringFrom('time');
        $data['shop_id'] = ForceStringFrom('shop_id');
        $data['order_id'] = ForceStringFrom('order_id');
        $data['goods_id'] = ForceStringFrom('goods_id');
        $dui_nian = substr($data['time'], 0, 4);
        $dui_yue = substr($data['time'], 4, 2);
        $nianyue = $this->mFristAndLast($dui_nian, $dui_yue);
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }


        $where = "";
        $whereand = "";
        if (!empty($data['pay_type'])) {
            $where = ' and b.pay_type = ' . $data['pay_type'];
        }

        if (!empty($data['order_status'])) {
            if ($data['order_status'] < '4') {
                $where .= " and c.type = " . $data['order_status'];
            } elseif ($data['order_status'] == 5) {
                $whereand = " and c.type not in (1,2,3)";
            } else {
                $where .= " and a.status = " . $data['order_status'];
            }
        }
        $sql = "select b.status,d.pay_no,c.type,b.real_sku_sales,b.id,b.order_no,b.pay_time,b.pay_type,b.goods_num from order_item as a left join order_base as b on b.id = a.order_id left join tx_return_goods as c on a.id = c.oiid and c.status = 4 {$whereand} left join pay_log as d on b.id = d.oid  where a.goods_id = '{$data['goods_id']}' and  b.shop_id = '{$data['shop_id']}' and b.status = 5 and b.pay_time > '{$nianyue['firstday']}' and b.pay_time < '{$nianyue['lastday']}' {$where} and b.v = 2 group by
b.id";

        $list = $GLOBALS['DB']->get_results($sql);

        foreach ($list as $k => $v) {
            if ($v['pay_type'] == '2') {
                $list[$k]['app_pay'] = "微信";
            } else {
                $list[$k]['app_pay'] = "支付宝";
            }

            if (!empty($v['type'])) {
                if ($v['type'] == '1') {
                    $list[$k]['app_status'] = "有退货";
                }
                if ($v['type'] == '2') {
                    $list[$k]['app_status'] = "仅退款";
                }
                if ($v['type'] == '3') {
                    $list[$k]['app_status'] = "有换货";
                }
            }
        }


        define('BASE_PATH', str_replace('\\', '/', realpath(ROOT_PATH . '/')) . "/");
        include BASE_PATH . 'www/tx.config.php';
        foreach ($list as $k => $v) {
            if (empty($v['app_status'])) {
                $list[$k]['app_status'] = $tx_config['order_status'][$v['status']];
            }
        }
        $res = $list;

        $obj = new PHPExcel();
        $fileName = "金额对账列表";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账列表'); //设置标题
        $obj->getProperties()->setSubject('金额对账列表'); //设置主题
        $obj->getProperties()->setDescription('金额对账列表'); //设置描述
        $obj->getProperties()->setKeywords('金额对账列表');//设置关键词
        $obj->getProperties()->setCategory('金额对账列表');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '订单编号')
            ->setCellValue($list[1] . '1', '付款时间')
            ->setCellValue($list[2] . '1', '销售数量')
            ->setCellValue($list[3] . '1', '对账数量')
            ->setCellValue($list[4] . '1', '支付方式')
            ->setCellValue($list[5] . '1', '交易流水号')
            ->setCellValue($list[6] . '1', '状态');
        $res = array_values($res);

        for ($i = 0; $i < count($res); $i++) {
            if ($res[$i]['pay_time']) {
                $time = date('Y-m-d H:i:s', $res[$i]['pay_time']);
            } else {
                $time = "";
            }
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $time);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['goods_num']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['real_sku_sales']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['app_pay']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), $res[$i]['pay_no']);
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), $res[$i]['app_status']);
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }


    public function invoice_list()
    {
        $data['order_no'] = ForceStringFrom('order_no');  //订单编号
        $data['invoice_type'] = ForceStringFrom('invoice_type');  //发票类型 0不要发票 1个人 2公司
        $data['shop_name'] = ForceStringFrom('shop_name');  //店铺名称/账号
        $data['nick_name'] = ForceStringFrom('nick_name');  //用户昵称/账号
        $data['time_s'] = ForceStringFrom('time_s');  // 开始
        $data['time_e'] = ForceStringFrom('time_e');  // 结束
        $data['shop_id'] = ForceStringFrom('shop_id');  // 店铺
        $data['tab'] = ForceStringFrom('tab');  // 开票状态
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $where = "";
        $tab = "";
        if (!empty($data['order_no'])) {
            $where = " and a.order_no like '%{$data['order_no']}%'";
        }

        if (!empty($data['tab'])) {
            $tab = " and a.invoice_status = {$data['tab']}";
        }

        if (!empty($data['invoice_type'])) {
            $where .= " and a.invoice_type = {$data['invoice_type']}";
        } else {
            $where .= " and a.invoice_type != 0";
        }

        if (!empty($data['nick_name'])) {
            $where .= " and c.login_name like '%{$data['nick_name']}%'";
        }

        if ($_SESSION['shop_id'] == 0) {
            if (!empty($data['shop_name'])) {
                $where .= " and b.shop_name like '%{$data['shop_name']}%'";
            }
        }

        if ($_SESSION['shop_id'] > 0) {
            $where .= " and b.id = {$_SESSION['shop_id']}";
        }

        if (!empty($data['shop_id'])) {
            $where .= " and b.id = {$data['shop_id']}";
        }

        $data['time_s'] = ForceStringFrom('time_s');  // 开始
        $data['time_e'] = ForceStringFrom('time_e');  // 结束

        if (!empty($data['time_s']) && !empty($data['time_e'])) {
            $start = strtotime($data['time_s']);
            $end = strtotime($data['time_e']);
            $where .= " and a.end_time > {$start} and a.end_time < {$end}";
        }


        if (!empty($data['time_s'])) {
            $start = strtotime($data['time_s']);
            $where .= " and a.end_time > {$start}";
        }

        if (!empty($data['time_e'])) {
            $end = strtotime($data['time_e']);
            $where .= " and a.end_time < {$end}";
        }


        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        //real_price  发票金额（实际金额）
        $sql = "select a.id,a.invoice_phone as phone,a.order_no,b.shop_name,c.login_name,a.end_time,a.invoice_type,a.real_price,a.invoice_status,a.invoice_content from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' {$where} {$tab} order by a.end_time desc {$limit} ";


        $list = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' {$where} {$tab}";

        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);


        $data['status4'] = $GLOBALS['DB']->get_var("select count(*) from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2'  {$where}");


        $data['status1'] = $GLOBALS['DB']->get_var("select count(*) from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' and a.invoice_status = '1'  {$where}");
        $data['status2'] = $GLOBALS['DB']->get_var("select count(*) from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' and a.invoice_status = '2'  {$where}");
        $data['status3'] = $GLOBALS['DB']->get_var("select count(*) from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' and a.invoice_status = '3'  {$where}");
        return ['list' => $list, 'filter' => $filter, 'search' => $data];

    }

    public function invoice_list_export()
    {
        $data['order_no'] = ForceStringFrom('order_no');  //订单编号
        $data['invoice_type'] = ForceStringFrom('invoice_type');  //发票类型 0不要发票 1个人 2公司
        $data['shop_name'] = ForceStringFrom('shop_name');  //店铺名称/账号
        $data['nick_name'] = ForceStringFrom('nick_name');  //用户昵称/账号
        $data['time_s'] = ForceStringFrom('time_s');  // 开始
        $data['time_e'] = ForceStringFrom('time_e');  // 结束
        $data['shop_id'] = ForceStringFrom('shop_id');  // 店铺
        $data['tab'] = ForceStringFrom('tab');  // 开票状态
        if ($_SESSION['shop_id'] > 0) {
            $data['shop_id'] = $_SESSION['shop_id'];
        } else {
            $data['shop_id'] = $GLOBALS['DB']->get_row("select id from tx_shop_base where admin = '1'")['id'];
        }
        $where = "";
        $tab = "";
        if (!empty($data['order_no'])) {
            $where = " and a.order_no like '%{$data['order_no']}%'";
        }

        if (!empty($data['tab'])) {
            $tab = " and a.invoice_status = {$data['tab']}";
        }

        if (!empty($data['invoice_type'])) {
            $where .= " and a.invoice_type = {$data['invoice_type']}";
        } else {
            $where .= " and a.invoice_type != 0";
        }

        if (!empty($data['nick_name'])) {
            $where .= " and c.login_name like '%{$data['nick_name']}%'";
        }

        if ($_SESSION['shop_id'] == 0) {
            if (!empty($data['shop_name'])) {
                $where .= " and b.shop_name like '%{$data['shop_name']}%'";
            }
        }

        if ($_SESSION['shop_id'] > 0) {
            $where .= " and b.id = {$_SESSION['shop_id']}";
        }

        if (!empty($data['shop_id'])) {
            $where .= " and b.id = {$data['shop_id']}";
        }

        $data['time_s'] = ForceStringFrom('time_s');  // 开始
        $data['time_e'] = ForceStringFrom('time_e');  // 结束

        if (!empty($data['time_s']) && !empty($data['time_e'])) {
            $start = strtotime($data['time_s']);
            $end = strtotime($data['time_e']);
            $where .= " and a.end_time > {$start} and a.end_time < {$end}";
        }


        if (!empty($data['time_s'])) {
            $start = strtotime($data['time_s']);
            $where .= " and a.end_time > {$start}";
        }

        if (!empty($data['time_e'])) {
            $end = strtotime($data['time_e']);
            $where .= " and a.end_time < {$end}";
        }


        //real_price  发票金额（实际金额）
        $sql = "select a.invoice_phone as phone,a.order_no,b.shop_name,c.login_name,a.end_time,a.invoice_type,a.real_price,a.invoice_status,a.invoice_content from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.v = '2' {$where} {$tab} order by a.end_time desc ";
        $res = $GLOBALS['DB']->get_results($sql);


        $obj = new PHPExcel();
        $fileName = "发票导出";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账列表'); //设置标题
        $obj->getProperties()->setSubject('金额对账列表'); //设置主题
        $obj->getProperties()->setDescription('金额对账列表'); //设置描述
        $obj->getProperties()->setKeywords('金额对账列表');//设置关键词
        $obj->getProperties()->setCategory('金额对账列表');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
        //$bottom_ri;
        // 填充第一行数据

        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '订单编号')
            ->setCellValue($list[1] . '1', '用户账号')
            ->setCellValue($list[2] . '1', '收货时间')
            ->setCellValue($list[3] . '1', '发票金额')
            ->setCellValue($list[4] . '1', '发票抬头')
            ->setCellValue($list[5] . '1', '收票人手机')
            ->setCellValue($list[6] . '1', '发票内容')
            ->setCellValue($list[7] . '1', '状态');
        $res = array_values($res);

        for ($i = 0; $i < count($res); $i++) {
            if ($res[$i]['invoice_status'] == '1') {
                $name = "待开票";
            } elseif ($res[$i]['invoice_status'] == '2') {
                $name = "已开票";
            } elseif ($res[$i]['invoice_status'] == '3') {
                $name = "已关闭";
            } else {
                $name = "一期数据";
            }
            if (!empty($res[$i]['end_time'])) {
                $time = date("Y-m-d H:i:s", $res[$i]['end_time']);
            } else {
                $time = "";
            }
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['login_name']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $time);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['real_price']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), ($res[$i]['invoice_type'] == '1' ? "个人" : "公司"));
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), $res[$i]['phone']);
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), $res[$i]['invoice_content']);
            $obj->getActiveSheet()->setCellValue("H" . (2 + $i), $name);
        }

        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }


    }

    public function invoice_close()
    {
        $id = ForceStringFrom('id');
        $status = ForceStringFrom('status');
        $content = "关闭";
        $time = time();
        $sql = "select order_no from order_base where id in ({$id})";
        $list = $GLOBALS['DB']->get_results($sql);
        foreach ($list as $k => $v) {
            $sql = "insert into tx_invoice_record set name = '{$_SESSION['admin_name']}',addtime = '{$time}',order_no = '{$v['order_no']}',content = '{$content}'";
            $GLOBALS['DB']->query($sql);
        }
        $sql = "update order_base set invoice_status = 3 where id in ({$id})";
        if ($status == '1') {
            if ($GLOBALS['DB']->query($sql)) {
                backSuccess("关闭成功");
            } else {
                backError('关闭失败');
            }
        } else {
            if ($GLOBALS['DB']->query($sql)) {
                echo '1';
            } else {
                echo '2';
            }
        }
    }


    public function invoice_see()
    {
        $order_no = ForceStringFrom('order_no');  //订单编号
        $sql = "select a.invoice_remark as order_remark,a.invoice_company,a.invoice_identifier,a.order_no,a.invoice_status,a.order_time,a.pay_time,a.end_time,b.shop_name,c.login_name,a.invoice_type,a.invoice_phone,a.real_price,a.s_tel,a.invoice_address,a.invoice_bank,a.invoice_account from order_base as a left join tx_shop_base as b on a.shop_id = b.id left join base_member as c on a.member_id = c.member_id where a.order_no = '{$order_no}'  and a.v = 2";
        $list = $GLOBALS['DB']->get_row($sql);

        $sql = "select d.stock_name from order_base as a left join order_item as b on a.id = b.order_id left join tx_goods_attr_price as c on b.goods_id = c.goods_id and b.link_id = c.link_id left join tx_goods_stock_link as d on c.stock_id = d.id where a.order_no = '{$order_no}' and a.v = 2";

        $list['goods_name'] = $GLOBALS['DB']->get_results($sql);
        $sql = "select * from tx_invoice_record where order_no = '{$order_no}' order by addtime desc";
        $list['record'] = $GLOBALS['DB']->get_results($sql);
        return $list;
    }


    public function invoice_see_edit()
    {
        $data['order_no'] = ForceStringFrom('order_no');
        $data['content'] = ForceStringFrom('order_remark', '暂无备注');
        $data['invoice_status'] = ForceStringFrom('invoice_status');
        $str = "";
        if ($data['invoice_status'] == '1') {
            $str = "改为待开票";
        }
        if ($data['invoice_status'] == '2') {
            $str = "改为已开票";
        }
        if ($data['invoice_status'] == '3') {
            $str = "改为已关闭";
        }

        $sql = "update order_base set invoice_remark = '{$data['content']}', invoice_status = '{$data['invoice_status']}' where order_no = '{$data['order_no']}' and v = 2";
        if ($GLOBALS['DB']->query($sql)) {
            $time = time();
            $sql = "insert into tx_invoice_record set name = '{$_SESSION['admin_name']}',addtime = '{$time}',content = '{$str}',order_no = '{$data['order_no']}'";
            if ($GLOBALS['DB']->query($sql)) {
                backSuccess('关闭成功');
            } else {
                backError('修改失败');
            }
        } else {
            backError('修改失败');
        }
    }

    public function reconciliation_list_export()
    {
        $filter['shop_name'] = ForceStringFrom('shop_name'); //店铺名称 ||id
        $filter['status'] = ForceStringFrom('status'); //店铺名称 ||id
        $search = "";
        if (!empty($filter['shop_name'])) {
            if (is_numeric($filter['shop_name'])) {
                $search = " where a.id = " . $filter['shop_name'];
            } else {
                $search = " where a.shop_name like '%{$filter['shop_name']}%'";
            }
        }

        $status = "";
        if (!empty($filter['status'])) {
            if ($filter['status'] == '1') {
                if (!empty($filter['shop_name'])) {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " and b.time = " . $nianyue;

                } else {
                    $nian = date('Y');
                    $yue = date('m');
                    if ($yue == '1') {
                        $nianyue = $nian - 1 . '12';
                    } else {
                        $nianyue = $nian . $yue - 1;
                    }
                    $status = " where b.time = " . $nianyue;
                }
            }
        }

        $sql = "select a.id,a.shop_name,a.join_time,max(b.time) as time,FROM_UNIXTIME(b.addtime,'%Y-%m-%d %h:%i:%s') as addtime from tx_shop_base as a left join tx_reconciliation as b on a.id = b.shop_id and b.status = '1' {$search} {$status} group by a.id ";

        $shop = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_shop_base";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);

        foreach ($shop as $k => $v) {
            if (empty($v['time'])) {
                $shop[$k]['status'] = '2';
                if (date('Ym', $v['join_time']) == date('Ym')) {
                    $shop[$k]['duizhang'] = '0';
                } else {
                    $shop[$k]['duizhang'] = date('Ym', $v['join_time']);
                }
            } else {
                $nian = date('Y'); //当前年
                $yue = date('m'); //当前月
                if ($yue == '1') {
                    $nianyue = $nian - 1 . '12';
                } else {
                    $nianyue = $nian . $yue - 1;
                }
                if ($v['time'] == $nianyue) {
                    $shop[$k]['status'] = '1';
                    $shop[$k]['duizhang'] = $nianyue;
                } else {
                    $shop[$k]['status'] = '2';
                    $shop[$k]['addtime'] = '';
                    $dui_nian = substr($v['time'], 0, 4);
                    $dui_yue = substr($v['time'], 4, 2);
                    if ($dui_yue == '12') {
                        $shop[$k]['duizhang'] = $dui_nian + 1 . '01';
                    } else {
                        $shop[$k]['duizhang'] = $dui_nian . $dui_yue + 1;
                    }
                }
            }
        }


        foreach ($shop as $k => $v) {
            if ($v['duizhang'] != '0') {
                $nian = substr($v['duizhang'], 0, 4);
                $yue = substr($v['duizhang'], 4, 2);
                $nianyue = $this->mFristAndLast($nian, $yue);
                $sql = "select count(*) as num,sum(real_price) as total_price,sum(real_deliver_fee) as deliver_fee from order_base where pay_time > '{$nianyue['firstday']}' and pay_time < '{$nianyue['lastday']}' and shop_id = '{$v['id']}' and v = 2";

                $row = $GLOBALS['DB']->get_row($sql);
                $shop[$k]['number'] = $row['num'];
                if (empty($row['deliver_fee'])) {
                    $shop[$k]['deliver_fee'] = 0;
                } else {
                    $shop[$k]['deliver_fee'] = $row['deliver_fee'];
                }
                if (!empty($row['total_price'])) {
                    $shop[$k]['money'] = $row['total_price'];
                } else {
                    $shop[$k]['money'] = '0';
                }
            } else {
                $shop[$k]['number'] = '0';
                $shop[$k]['money'] = '0';
                $shop[$k]['deliver_fee'] = 0;
            }
        }

        $obj = new PHPExcel();
        $fileName = "金额对账列表";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('金额对账列表'); //设置标题
        $obj->getProperties()->setSubject('金额对账列表'); //设置主题
        $obj->getProperties()->setDescription('金额对账列表'); //设置描述
        $obj->getProperties()->setKeywords('金额对账列表');//设置关键词
        $obj->getProperties()->setCategory('金额对账列表');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('金额对账');


        $list = ['A', 'B', 'C', 'D', 'E', 'F'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '店铺id')
            ->setCellValue($list[1] . '1', '店铺名称')
            ->setCellValue($list[2] . '1', '对账金额（含运费）')
            ->setCellValue($list[3] . '1', '对账订单')
            ->setCellValue($list[4] . '1', '对账时间')
            ->setCellValue($list[5] . '1', '对账状态');
        $res = array_values($shop);

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['id']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['shop_name']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), '￥' . $res[$i]['money'] . '(' . $res[$i]['deliver_fee'] . ')');
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['number']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['addtime']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), ($res[$i]['total'] == '1' ? "已对账" : "未对账"));
        }


        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }

    }


    public function mFristAndLast($y = "", $m = "")
    {
        if ($y == "") $y = date("Y");
        if ($m == "") $m = date("m");
        $m = sprintf("%02d", intval($m));
        $y = str_pad(intval($y), 4, "0", STR_PAD_RIGHT);

        $m > 12 || $m < 1 ? $m = 1 : $m = $m;
        $firstday = strtotime($y . $m . "01000000");
        $firstdaystr = date("Y-m-01", $firstday);
        $lastday = strtotime(date('Y-m-d 23:59:59', strtotime("$firstdaystr +1 month -1 day")));

        return array(
            "firstday" => $firstday,
            "lastday" => $lastday
        );
    }





    //新增需求

    //充值列表
    public function recharge_record()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');
        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        $where = "";
        if (!empty($filter['order_no'])) {
            $where = " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.member_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }

        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time =< '{$end}'";
        }

        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }

        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time =< '{$end}'";
        }

        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}' and a.price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}'";
        }

        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price <= '{$filter['end_money']}'";
        }


        $sql = "select a.c_time,a.order_no,b.login_name,b.nick_name,a.price,a.diamond_num,a.pay_type from tx_live_diamond as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where} order by c_time desc {$limit} ";

        $list = $GLOBALS['DB']->get_results($sql);

        $sql = "select count(*) from tx_live_diamond as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where}  ";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);

        $sql = "select count(*) from tx_live_give_packet where pay_status = '1'";
        $filter['red_envelopes'] = $GLOBALS['DB']->get_var($sql);
        $filter['recharge'] = $filter['record_count'];

        return ['list' => $list, 'filter' => $filter];
    }


    //导出
    public function recharge_record_export()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');
        $where = "";
        if (!empty($filter['order_no'])) {
            $where = " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.member_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }

        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time <= '{$end}'";
        }

        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }

        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time <= '{$end}'";
        }

        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}' and a.price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}'";
        }

        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price <= '{$filter['end_money']}'";
        }
        $sql = "select a.c_time,a.order_no,b.login_name,a.price,a.diamond_num,a.pay_type from tx_live_diamond as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where}  ";
        $res = $GLOBALS['DB']->get_results($sql);

        $sql = "select count(*) from tx_live_diamond as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where}  ";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        $sql = "select count(*) from tx_live_give_packet where pay_status = '1'";
        $filter['red_envelopes'] = $GLOBALS['DB']->get_var($sql);
        $filter['recharge'] = $filter['record_count'];
        $obj = new PHPExcel();
        $fileName = "直播充值对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('直播充值对账'); //设置标题
        $obj->getProperties()->setSubject('直播充值对账'); //设置主题
        $obj->getProperties()->setDescription('直播充值对账'); //设置描述
        $obj->getProperties()->setKeywords('直播充值对账');//设置关键词
        $obj->getProperties()->setCategory('直播充值对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('直播充值对账');

        $list = ['A', 'B', 'C', 'D', 'E', 'F'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '支付时间')
            ->setCellValue($list[1] . '1', '充值流水号')
            ->setCellValue($list[2] . '1', '用户ID')
            ->setCellValue($list[3] . '1', '充值金额')
            ->setCellValue($list[4] . '1', '充值阳光')
            ->setCellValue($list[5] . '1', '支付方式');

        $res = array_values($res);

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), date('Y-m-d H:i:s', $res[$i]['c_time']));
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['login_name']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['price']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['diamond_num']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), ($res[$i]['pay_type'] == '1' ? "微信" : ($res[$i]['pay_type'] == '2' ? "支付宝" : "苹果")));
        }


        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }


    //红包
    public function red_envelopes()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');
        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        $where = "";
        if (!empty($filter['order_no'])) {
            $where = " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.anchor_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }

        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time <= '{$end}'";
        }

        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }

        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time <= '{$end}'";
        }


        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.packet_price >= '{$filter['start_money']}' and a.packet_price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.packet_price >= '{$filter['start_money']}'";
        }

        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.packet_price <= '{$filter['end_money']}'";
        }

        $sql = "select a.c_time,a.order_no,b.login_name,b.nick_name,a.packet_price,a.packet_num,a.packet_type,a.residue_price,a.residue_num from tx_live_give_packet as a left join base_member as b on a.anchor_id = b.member_id where a.pay_status = 1 {$where} {$limit} ";

        $list = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_live_give_packet as a left join base_member as b on a.anchor_id = b.member_id where a.pay_status = 1 {$where} ";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        $sql = "select count(*) from tx_live_diamond where pay_status = '1'";
        $filter['red_envelopes'] = $filter['record_count'];
        $filter['recharge'] = $GLOBALS['DB']->get_var($sql);
        return ['list' => $list, 'filter' => $filter];
    }

    public function red_envelopes_export()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');

        $where = "";
        if (!empty($filter['order_no'])) {
            $where = " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.anchor_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }

        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time <= '{$end}'";
        }

        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }

        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time <= '{$end}'";
        }


        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.packet_price >= '{$filter['start_money']}' and a.packet_price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.packet_price >= '{$filter['start_money']}'";
        }

        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.packet_price <= '{$filter['end_money']}'";
        }

        $sql = "select a.c_time,a.order_no,b.login_name,a.packet_price,a.packet_num,a.packet_type,a.residue_price,a.residue_num from tx_live_give_packet as a left join base_member as b on a.anchor_id = b.member_id where a.pay_status = 1 {$where}";

        $res = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_live_give_packet as a left join base_member as b on a.anchor_id = b.member_id where a.pay_status = 1 {$where}  ";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        $sql = "select count(*) from tx_live_diamond where pay_status = '1'";
        $filter['red_envelopes'] = $filter['record_count'];
        $filter['recharge'] = $GLOBALS['DB']->get_var($sql);
        $obj = new PHPExcel();
        $fileName = "直播红包对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('直播红包对账'); //设置标题
        $obj->getProperties()->setSubject('直播红包对账'); //设置主题
        $obj->getProperties()->setDescription('直播红包对账'); //设置描述
        $obj->getProperties()->setKeywords('直播红包对账');//设置关键词
        $obj->getProperties()->setCategory('直播红包对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('直播充值对账');

        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '时间')
            ->setCellValue($list[1] . '1', '充值流水号')
            ->setCellValue($list[2] . '1', '用户ID')
            ->setCellValue($list[3] . '1', '红包金额')
            ->setCellValue($list[4] . '1', '红包数量')
            ->setCellValue($list[5] . '1', '红包类型')
            ->setCellValue($list[6] . '1', '剩余金额')
            ->setCellValue($list[7] . '1', '剩余数量');

        $res = array_values($res);

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), date('Y-m-d H:i:s', $res[$i]['c_time']));
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['login_name']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['packet_price']);
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['packet_num']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), ($res[$i]['pay_type'] == '1' ? "普通" : "拼手气"));
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), $res[$i]['residue_price']);
            $obj->getActiveSheet()->setCellValue("H" . (2 + $i), $res[$i]['residue_num']);
        }


        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);


        // 导出

        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }

    }


    //提现管理
    public function withdrawal_list()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');
        $filter['source_type'] = ForceStringFrom('source_type');
        $filter['tab'] = ForceStringFrom('tab', 0);

        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        $where = "";
        if (!empty($filter['order_no'])) {
            $where .= " and a.serial_number like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.member_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }

        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time <= '{$end}'";
        }

        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }

        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time <= '{$end}'";
        }


        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}' and a.price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}'";
        }

        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price <= '{$filter['end_money']}'";
        }

        if (!empty($filter['source_type'])) {
            $where .= " and a.source_type = '{$filter['source_type']}'";
        }
        $status = "";

        if (!empty($filter['tab'])) {
            $status .= " and a.status = '{$filter['tab']}'";
        }
        //排序
        if ($filter['tab'] == 0 || $filter['tab'] == 1) {
            $sql = "select a.credit,a.id,a.c_time,a.serial_number,b.login_name,b.nick_name,a.source_type,a.price,a.account_price,a.status,a.deal_time,a.member_id from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.id > 0 {$where} {$status} order by a.c_time desc {$limit} ";
        } else {
            $sql = "select a.credit,a.id,a.c_time,a.serial_number,b.login_name,b.nick_name,a.source_type,a.price,a.account_price,a.status,a.deal_time,a.member_id from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.id > 0 {$where} {$status} order by a.deal_time desc {$limit} ";
        }


        $res = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where  a.id > 0  {$where} {$status}";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        //全部
        $filter['total_num'] = $GLOBALS['DB']->get_var("select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.id > 0 {$where}");
        //待处理
        $filter['pending_num'] = $GLOBALS['DB']->get_var("select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.status = '1' {$where}");
        //提现中
        $filter['ing_num'] = $GLOBALS['DB']->get_var("select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.status = '4' {$where}");
        //成功
        $filter['success_num'] = $GLOBALS['DB']->get_var("select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.status = '2' {$where} ");
        //失败
        $filter['error_num'] = $GLOBALS['DB']->get_var("select count(*) from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.status = '3' {$where} ");
        //*******************1112--新增公司账户余额***********************************/
        $json = '{
 "app_id":"20200114150548",
 "pay_type":"Wk_Bank",
 "sign":"292e0d0e2ccccba50e42f6c3dfad5aca"
}';
//        $url = 'http://test.dingmei.net/order/balance ';
        $url = 'http://116.255.142.142:11130/WuKong/Balance?AppId=20200114150548 ';
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
        $returnData = curl_exec($ch);
//        var_dump($returnData);

        curl_close($ch);
        $data_array = json_decode($returnData, true);
        if ($data_array['code'] == '00000000') {
            $filter['company_balance'] = $data_array['balance'];
        } else {
            $filter['company_balance'] = '保密';
        }

        return ['list' => $res, 'filter' => $filter];
    }


    //提现管理导出
    public function withdrawal_list_export()
    {

        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['start_time'] = ForceStringFrom('start_time');
        $filter['end_time'] = ForceStringFrom('end_time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');
        $filter['source_type'] = ForceStringFrom('source_type');
        $filter['tab'] = ForceStringFrom('tab', 0);
//        var_dump($filter);exit;
        $where = "";
        if (!empty($filter['order_no'])) {
            $where .= " and a.serial_number like '%{$filter['order_no']}%'";
        }
        if (!empty($filter['member_id'])) {
            if (is_numeric($filter['member_id'])) {
                $where .= " and a.member_id = '{$filter['member_id']}'";
            } else {
                $where .= " and b.login_name like '%{$filter['member_id']}%'";
            }
        }
        if (!empty($filter['start_time']) && !empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time >= '{$statr}' and a.c_time <= '{$end}'";
        }
        if (!empty($filter['start_time']) && empty($filter['end_time'])) {
            $statr = strtotime($filter['start_time']);
            $where .= " and a.c_time >= '{$statr}'";
        }
        if (empty($filter['start_time']) && !empty($filter['end_time'])) {
            $end = strtotime($filter['end_time']);
            $where .= " and a.c_time <= '{$end}'";
        }
        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}' and a.price <= '{$filter['end_money']}'";
        }
        if (!empty($filter['start_money']) && empty($filter['end_money'])) {
            $where .= " and a.price >= '{$filter['start_money']}'";
        }
        if (empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.price <= '{$filter['end_money']}'";
        }
        if (!empty($filter['source_type'])) {
            $where .= " and a.source_type = '{$filter['source_type']}'";
        }
        $status = "";
        if (!empty($filter['tab'])) {
            $status .= " and a.status = '{$filter['tab']}'";
        }
        $sql = "select a.c_time,a.serial_number,b.login_name,a.source_type,a.price,a.account_price,a.status,a.deal_time from tx_live_withdraw as a left join base_member as b on a.member_id = b.member_id where a.id > 0 {$where} {$status} order by a.c_time desc";
        $res = $GLOBALS['DB']->get_results($sql);
        $obj = new PHPExcel();
        $fileName = "提现对账";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('提现对账'); //设置标题
        $obj->getProperties()->setSubject('提现对账'); //设置主题
        $obj->getProperties()->setDescription('提现对账'); //设置描述
        $obj->getProperties()->setKeywords('提现对账');//设置关键词
        $obj->getProperties()->setCategory('提现对账');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);
        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('提现对账');
        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '申请时间')
            ->setCellValue($list[1] . '1', '提现流水号')
            ->setCellValue($list[2] . '1', '用户ID')
            ->setCellValue($list[3] . '1', '提现类型')
            ->setCellValue($list[4] . '1', '提现金额')
            ->setCellValue($list[5] . '1', '到账金额')
            ->setCellValue($list[6] . '1', '提现状态')
            ->setCellValue($list[7] . '1', '处理时间');
        $res = array_values($res);

        for ($i = 0; $i < count($res); $i++) {
            if ($res[$i]['deal_time']) {
                $time = date('Y-m-d H:i:s', $res[$i]['deal_time']);
            } else {
                $time = "";
            }
            if ($res[$i]['c_time']) {
                $times = date('Y-m-d H:i:s', $res[$i]['c_time']);
            } else {
                $times = "";
            }
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $times);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['serial_number']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['login_name']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), ($res[$i]['source_type']) == '1' ? "红包提现" : ($res[$i]['source_type']) == '2' ? "积分提现" : "积分提现");
            $obj->getActiveSheet()->setCellValue("E" . (2 + $i), $res[$i]['price']);
            $obj->getActiveSheet()->setCellValue("F" . (2 + $i), $res[$i]['account_price']);
//            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), ($res[$i]['status']) == '1' ? "待处理" : ($res[$i]['status'] == '2' ? "提现成功" : "提现失败"));
            $obj->getActiveSheet()->setCellValue("G" . (2 + $i), ($res[$i]['status']) == '1' ? "待处理" : ($res[$i]['status'] == '2' ? "提现成功" :($res[$i]['status'] == '3' ? "提现失败" : "提现中")));
            $obj->getActiveSheet()->setCellValue("H" . (2 + $i), $time);
        }
        // 设置列宽
        $obj->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $obj->getActiveSheet()->getColumnDimension('C')->setWidth(15);
        // 导出
        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }
    }


    public function withdrawal_see()
    {
        $id = ForceStringFrom('id');
        $sql = "select b.admin_name,a.status,a.reason,a.c_time from tx_live_withdraw_log as a left join admin_account as b on a.admin_id = b.admin_id where a.withdraw_id = '{$id}'";
        $list = $GLOBALS['DB']->get_results($sql);
        return $list;
    }

    public function ajax_withdrawal_save()
    {
        $id = ForceStringFrom('id');
        $status = ForceStringFrom('status');
        $source_type = ForceStringFrom('source_type');
        $reason = ForceStringFrom('reason');
        $time = time();
        $sql = "select * from  tx_live_withdraw where id = '{$id}'";
        $list = $GLOBALS['DB']->get_row($sql);
        if ($list['status'] > 1) {
            echo '3';
            die;
        }
        $time = time();
        try {
            //开启事务
            $GLOBALS['DB']->autocommit(false);
            $sql = "insert into tx_live_withdraw_log set withdraw_id = '{$id}',admin_id = '{$_SESSION['admin_id']}',status = '{$status}',reason = '{$reason}',c_time = '{$time}'";
            $GLOBALS['DB']->query($sql);

            //1 红包 2贝壳（积分） 3海星（积分）
            if ($status == '3') {
                if ($source_type == '1') {
                    $sql = "insert into  tx_live_packet_log set member_id = '{$list['member_id']}',price= '{$list['price']}',`type` = 3,withdraw_way = '{$list['withdraw_way']}',c_time = '{$time}'";
                    $GLOBALS['DB']->query($sql);
                    $sql = "update base_member set red_packet_balance = red_packet_balance + '{$list['price']}' where member_id = '{$list['member_id']}'";
                    $GLOBALS['DB']->query($sql);
                }

                if ($source_type == '2') {
                    $sql = "insert into tx_live_shell_log set anchor_id = '{$list['member_id']}',shell_num = '{$list['shell_num']}',`type` = 3,withdraw_way = '{$list['withdraw_way']}',c_time = '{$time}'";
                    $GLOBALS['DB']->query($sql);
                    $sql = "update base_member set shell_balance = shell_balance + '{$list['shell_num']}' where member_id = '{$list['member_id']}'";
                    $GLOBALS['DB']->query($sql);
                }
                // east 2020-10-23 add -- start
                if ($source_type == '3') {
                    $sql = "insert into tx_live_credit_log set anchor_id = '{$list['member_id']}',create_num = '{$list['price']}',`type` = 3,withdraw_way = '{$list['withdraw_way']}',c_time = '{$time}'";
                    $GLOBALS['DB']->query($sql);
                    $sql = "update tx_task_member set price = price + '{$list['price']}' where member_id = '{$list['member_id']}'";
                    $GLOBALS['DB']->query($sql);
                }
                // ------end


            }
            $sql = "update tx_live_withdraw set status = '{$status}', deal_time = '{$time}' where id = '{$id}'";
            $GLOBALS['DB']->query($sql);
            //提交事务
            $GLOBALS['DB']->commit();
            echo '1';
        } catch (PDOException $e) {
            echo '2';
            $GLOBALS['DB']->rollBack();
        }


    }

    //微信提现.
    public function merchants_pay()
    {

//        const APPID = 'wxd4d34addf94ebcf3';
//        const MCHID = '1531076541';
//        const KEY = 'FKSFK2232JFSKFjdfjskjfksjfkdjfsk';
//          openid = "o_KaZxKr4FUz8iVJ1dwJ2fcEm5II";

        $key = "FKSFK2232JFSKFjdfjskjfksjfkdjfsk";

        //证书路径
//        $keyFile = $certDir . '/privkey.pem';
//        $certFile = $certDir . '/certs/crt.pem';

        define('BASE_PATH', str_replace('\\', '/', realpath(ROOT_PATH . '/')) . "/");


        $keyFile = BASE_PATH . "api_v2/pay/wxpay/cert/apiclient_key_new.pem";
        $certFile = BASE_PATH . "api_v2/pay/wxpay/cert/apiclient_cert.pem";
        $amount = '1';   //金额
        $check_name = "FORCE_CHECK";
        $desc = "久久助农陶提现";
        $mchid = "1531076541";
        $mch_appid = "wxd4d34addf94ebcf3";
        $nonce_str = md5(time() . mt_rand(1000000, 9999999));  //随机字符串
        $openid = "o_KaZxKr4FUz8iVJ1dwJ2fcEm5II";
        //$partner_trade_no = md5(md5(time() . mt_rand(1000000,9999999)));
        $partner_trade_no = "d8ffc068e752e1c525066857e31a8fd7";
        $re_user_name = "杜文杰";

        $str = "amount={$amount}&check_name={$check_name}&desc={$desc}&mch_appid={$mch_appid}&mchid={$mchid}&nonce_str={$nonce_str}&openid={$openid}&partner_trade_no={$partner_trade_no}&re_user_name={$re_user_name}";
        $stringSignTemp = $str . "&key={$key}";
        $sign = strtoupper(MD5($stringSignTemp));
        //$sign=strtoupper(hash_hmac("sha256",$stringSignTemp,$key));

        $url = "https://api.mch.weixin.qq.com/mmpaymkttransfers/promotion/transfers";
        $xml = "
           <xml>
            <mch_appid>{$mch_appid}</mch_appid>
            <mchid>{$mchid}</mchid>
            <nonce_str>{$nonce_str}</nonce_str>
            <partner_trade_no>{$partner_trade_no}</partner_trade_no>
            <openid>{$openid}</openid>
            <check_name>{$check_name}</check_name>
            <re_user_name>{$re_user_name}</re_user_name>
            <amount>{$amount}</amount>
            <desc>{$desc}</desc>
            <sign>{$sign}</sign>
          </xml>
        ";
        $this->pay_curl($url, $xml, $keyFile, $certFile);


    }

    public function pay_curl($url, $xmlData, $key, $cart)
    {
        $ch = curl_init();  // 初始一个curl会话
        curl_setopt($ch, CURLOPT_URL, $url);    // 设置url
        curl_setopt($ch, CURLOPT_POST, 1);  // post 请求
        curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type:text/xml; charset=utf-8"));    // 一定要定义content-type为xml，要不然默认是text/html！


        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSLCERTTYPE, 'PEM');//证书类型
        curl_setopt($ch, CURLOPT_SSLCERT, $cart);//证书位置

        curl_setopt($ch, CURLOPT_SSLKEYTYPE, 'PEM');//CURLOPT_SSLKEY中规定的私钥的加密类型
        curl_setopt($ch, CURLOPT_SSLKEY, $key);//证书位置

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $xmlData);//post提交的数据包
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3); // PHP脚本在成功连接服务器前等待多久，单位秒
        curl_setopt($ch, CURLOPT_HEADER, 0);
        $result = curl_exec($ch);   // 抓取URL并把它传递给浏览器
// 是否报错

        var_dump($result);
        echo $result;
        die;
        if (curl_errno($ch)) {
            print curl_error($ch);
        }
        curl_close($ch);    // //关闭cURL资源，并且释放系统资源

    }


    public function text_alipay()
    {
        $appid = '2021001156613511';
        $rsaPrivateKey = 'MIIEpQIBAAKCAQEA83ZtCpJLF6AZNQqcZD7mmxc2MaYdydwXjCdOgLSBAQlggflL53SieHkhYAQdwZG5HbKZ19IUNlVaLh9qhFKKpGfqdyQRixkLJe3tT7D0F7kUZtgHQY9U1KbtILteGde52su0FxdeVJeJdSVnXjw35Lg+Yc40xK1/6MBW0Lzo+NBR3+k5ZGWeyj6hXAc/rKFUEU7rgrWqA7Vy5Bj0Q2gGtmyYLvXCjkQOSUNWZsOVpc6dgSeSj+ESSaUVzEhqltMUA1Y9XIfbTc5x/gz1pgCwZlBel6ejewNBIP9LWfY7rXZ1wgQd9pRYIxeQoLB01ZqSOnOIGIqxNHZIxZfBRK3lMwIDAQABAoIBAGRLZwQx3AlxhLDbHC4X03wUhdjSK/daWcD8+FQBCBvbNwyUHHbPD5c9n0gkqfVyCKZ5SvMjsfvoEWxquMCmGEM+I9LM4wVAXd1UNKzdotCbCBKN7/9MApBP6+PODCftPL0rqZbRo6SJgLDnpbumZwgr9lboUcisCMNjaOA40mic60jTAcUKdbJRBcf75dbxB+Z0Qqfj/nUjiSAgOxdwhHNzxyl2+srmUmc+ooKyvnzREw4HE39iaLXyJC3lmKyi98VVc08TacROapJ0CbsvLHMGzLmcqfKbu4g+QDVE2Z8wDGPUgqxBVR3I1M6VfTjV/cZG8M1agJd0MKTus23lEeECgYEA/Jq3syA+M6Ap0J4K6S3iwxFAWpIeT+h/gYI/LrA/E/W1Bp/Hnu5AiJZjib07djYMxC/Hz9fAiAnQdBKecHNKHDn62Nd9e4y81kABGmY2lgIRHfdZtky+01N8mCMbUj6QQBgbJojKC4yK6a6J0oj4ITNOhqSR8ZaRZZrMS/zOCIkCgYEA9rw/vfurhHSavaeI8P1mLzmOKrhuev+srSH3P/R9IdKZKbLZ0jZQlMKzGk8FmUlqWTjaFdXwopih9S/j1PxDYj/pIFGfC/QLE4gzYF4RJaePCbOT91CJ+Ey+mq3O/mhNgzXNN4Vrdt43XR+Ho3jZEnM3OF78FjVfwa81zo8x2NsCgYEAkm2FazqXlAmV866JmJ3Ww0juyxHErIGT2BkOUxwrlIBsDYj1iHWHxyWWUbP2EhJG2DryUtM4ciNuSLq6SWkrXq1lcemIfeQZWwEDIrB5l/9euMY3pOtb+th8cxx2q/hEWkMfCfllVciEhe19SyPG4kgBjx860pZ7djCDmNDVBjECgYEAoyvZh73BL0ah8xyxrpYWFtMcVtpDjio5uwHEbtI0UsLgsbfq3182KTsdkR+DV1067KhxaZFjo1QHf4vdQ0RVF8umU85GvXP2Q0OGnot3EYzfRo4xI5Rquf+e6dJaGttFr6lL/xTH/gN1X6tzW0OXYuE5OpluYw2HNyK1FdaTI5MCgYEA30adAeBMYnbB6fA5FOJ1D2VaxYoos+cSw0kOhEk2UmexHfdgEX9ALgExbV+s4ajXOR6BRCbaaYm851yH9wrz8uh9xqUG0joirlnhlgXN2TMv349QEZQT8IE9ObELTgW8dOGzNVEcItq39anISsXmJ795VVYWKxtwmlIYQgmhbU4=';
        $alipayrsaPublicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA83ZtCpJLF6AZNQqcZD7mmxc2MaYdydwXjCdOgLSBAQlggflL53SieHkhYAQdwZG5HbKZ19IUNlVaLh9qhFKKpGfqdyQRixkLJe3tT7D0F7kUZtgHQY9U1KbtILteGde52su0FxdeVJeJdSVnXjw35Lg+Yc40xK1/6MBW0Lzo+NBR3+k5ZGWeyj6hXAc/rKFUEU7rgrWqA7Vy5Bj0Q2gGtmyYLvXCjkQOSUNWZsOVpc6dgSeSj+ESSaUVzEhqltMUA1Y9XIfbTc5x/gz1pgCwZlBel6ejewNBIP9LWfY7rXZ1wgQd9pRYIxeQoLB01ZqSOnOIGIqxNHZIxZfBRK3lMwIDAQAB";

        $url = "https://openapi.alipay.com/gateway.do?appid={$appid}&rsaPrivateKey={$rsaPrivateKey}&alipayrsaPublicKey={$alipayrsaPublicKey}";
        $a = $this->getUrl($url);
        var_dump($a);
    }


    public function getUrl($url)
    {
        $curl = curl_init();
        //设置抓取的url
        curl_setopt($curl, CURLOPT_URL, $url);
        //  curl_setopt($curl, CURLOPT_HEADER, 1);        //设置头文件的信息作为数据流输出
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);//设置获取的信息以文件流的形式返回，而不是直接输出
        $data = curl_exec($curl);                     //执行命令
        curl_close($curl);                            //关闭URL请求
        return ($data);  //显示获得的数据
    }

    //v2 版本财务对账
    //第三方对账
    public function v2_reconciliation_list()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['shop_id'] = ForceStringFrom('shop_id');
        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }
        if (!empty($filter['shop_id'])) {
            $where = "and (id like '%{$filter['shop_id']}%' || shop_name like '%{$filter['shop_id']}%')";
        }
        $sql = "select a.id,a.shop_name,(select max(addtime) from tx_reconciliation_operation_record where shop_id = a.id) as addtime  from tx_shop_base as a where a.id > '0' {$where} order by addtime desc {$limit}";
        $list = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*)  from tx_shop_base where id > '0' {$where}";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        return ['list' => $list, 'filter' => $filter];
    }


    public function v2_reconciliation_list_export()
    {
        $filter['shop_id'] = ForceStringFrom('shop_id');
        if (!empty($filter['shop_id'])) {
            $where = "and (id like '%{$filter['shop_id']}%' || shop_name like '%{$filter['shop_id']}%')";
        }
        $sql = "select a.id,a.shop_name,(select max(addtime) from tx_reconciliation_operation_record where shop_id = a.id) as addtime  from tx_shop_base as a where a.id > '0' {$where} order by addtime desc";
        $res = $GLOBALS['DB']->get_results($sql);

        $obj = new PHPExcel();
        $fileName = "第三方对账列表";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('第三方对账列表'); //设置标题
        $obj->getProperties()->setSubject('第三方对账列表'); //设置主题
        $obj->getProperties()->setDescription('第三方对账列表'); //设置描述
        $obj->getProperties()->setKeywords('第三方对账列表');//设置关键词
        $obj->getProperties()->setCategory('第三方对账列表');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('第三方对账列表');

        $list = ['A', 'B', 'C'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '店铺id')
            ->setCellValue($list[1] . '1', '店铺名称')
            ->setCellValue($list[2] . '1', '最近对账时间');

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['id']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['shop_name']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), ($res[$i]['addtime'] == '' ? "" : date('Y-m-d H:i:s', $res[$i]['addtime'])));
        }

        // 导出
        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }


    }

    public function v2_details()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['shop_id'] = ForceStringFrom('shop_id');  //店铺id
        $filter['order_no'] = ForceStringFrom('order_no');  //订单编号
        $filter['pay_time'] = ForceStringFrom('pay_time');  //时间
        $filter['tab'] = ForceStringFrom('tab');  // 1已对账  2未对账
        $filter['pay_status'] = ForceStringFrom('pay', 1);  //1 付款 2退款

        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }

        $where_bian = "";
        $where = '';
        if (!empty($filter['order_no'])) {
            $where .= " and a.order_no like '%{$filter['order_no']}%'";
            $where_bian .= " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['pay_time'])) {
            $arr = explode(' - ', $filter['pay_time']);
            $start = strtotime($arr[0]);
            $end = strtotime($arr[1]);
            $where .= " and a.pay_time >= '{$start}' and a.pay_time <= '{$end}'";
            $where_bian .= " and a.pay_time >= '{$start}' and a.pay_time <= '{$end}'";
        }
        //$field 店铺
        //$field_order 订单的
        if ($filter['pay_status'] == '1') {
            $field = "cumulative_reconciliation as cumulative_reconciliation";
            $field_order = "a.reconciliation_status";
            //付款的已对账 未对账
            //$where .= ' and b.return_goods_status != 2 and b.return_goods_status != 8';
            if ($filter['tab'] == '1') {
                $where .= " and a.reconciliation_status = 1";
            } elseif ($filter['tab'] == '2') {
                $where .= " and a.reconciliation_status != 1";
            }

        } else {
            //退款的已对账 未对账
            $field_order = "b.reconciliation_status";
            $field = " return_cumulative_reconciliation as cumulative_reconciliation";
            $where .= ' and (b.return_goods_status = 2 or b.return_goods_status = 8)';
            if ($filter['tab'] == '1') {
                $where .= " and b.reconciliation_status = 1";
            } elseif ($filter['tab'] == '2') {
                $where .= " and b.reconciliation_status != 1";
            }
        }
        $sql = "select id,shop_name,{$field} from tx_shop_base where id = '{$filter['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);
        $sql = "select a.pay_time,a.id,{$field_order},a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.pay_status = 1 {$where}  group by a.id {$limit}";

        $list = $GLOBALS['DB']->get_results($sql);

        $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.pay_status = 1 {$where}  group by a.id";
        $filter['record_count'] = count($GLOBALS['DB']->get_results($sql));

        foreach ($list as $k => $v) {
            $list[$k]['total_price'] = $v['total_price'] - ($v['live_commission_v2'] + $v['goods_commission']);
        }

        $shop['reconciliation_money'] = 0;
        if ($filter['pay_status'] == '1') {
            $sql = "select a.pay_time,a.id,a.reconciliation_status,a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = {$filter['shop_id']} and a.pay_status = 1  and a.reconciliation_status != 1 group by a.id";
        } else {
            $sql = "select a.pay_time,a.id,b.reconciliation_status,a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = {$filter['shop_id']} and a.pay_status = 1 and (b.return_goods_status = 2 or b.return_goods_status = 8) group by a.id";
        }
        $results = $GLOBALS['DB']->get_results($sql);
        foreach ($results as $k => $v) {
            if ($v['reconciliation_status'] != 1) {
                $shop['reconciliation_money'] = ($shop['reconciliation_money'] + $v['total_price']) - ($v['live_commission_v2'] + $v['goods_commission']);

            }
        }


        //付款的
        if ($filter['pay_status'] == 1) {
            //全部多少条付款的
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['all'] = count($GLOBALS['DB']->get_results($sql));
            //已对账多少条
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.reconciliation_status = 1 and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['reconciled'] = count($GLOBALS['DB']->get_results($sql));
            //未对账多少条
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.reconciliation_status != 1 and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['no_reconciliation'] = count($GLOBALS['DB']->get_results($sql));
        } else {
            //退款的
            //全部多少条付款的
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['all'] = count($GLOBALS['DB']->get_results($sql));
            //已对账
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and b.reconciliation_status = 1 and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['reconciled'] = count($GLOBALS['DB']->get_results($sql));
            //未对账
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and b.reconciliation_status != 1 and a.pay_status = 1 {$where_bian} group by a.id";
            $shop['no_reconciliation'] = count($GLOBALS['DB']->get_results($sql));
        }
        return ['shop' => $shop, 'list' => $list, 'filter' => $filter];
    }

    public function v2_details_export()
    {
        $filter['shop_id'] = ForceStringFrom('shop_id');  //店铺id
        $filter['pay_time'] = ForceStringFrom('pay_time');  //时间
        $filter['tab'] = ForceStringFrom('tab');  // 1已对账  2未对账
        $filter['pay_status'] = ForceStringFrom('pay', 1);  //1 付款 2退款
        $filter['order_no'] = ForceStringFrom('order_no');  //订单编号

        $where = '';
        if (!empty($filter['order_no'])) {
            $where .= " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['pay_time'])) {
            $arr = explode(' - ', $filter['pay_time']);
            $start = strtotime($arr[0]);
            $end = strtotime($arr[1]);
            $where .= " and a.pay_time >= '{$start}' and a.pay_time <= '{$end}'";
        }
        //$field 店铺
        //$field_order 订单的
        if ($filter['pay_status'] == '1') {
            $field = "cumulative_reconciliation as cumulative_reconciliation";
            $field_order = "a.reconciliation_status";
            //付款的已对账 未对账
            //$where .= ' and b.return_goods_status != 2 and b.return_goods_status != 8';
            if ($filter['tab'] == '1') {
                $where .= " and a.reconciliation_status = 1";
            } elseif ($filter['tab'] == '2') {
                $where .= " and a.reconciliation_status != 1";
            }
        } else {
            //退款的已对账 未对账
            $field_order = "b.reconciliation_status";
            $field = " return_cumulative_reconciliation as cumulative_reconciliation";
            $where .= ' and (b.return_goods_status = 2 or b.return_goods_status = 8)';
            if ($filter['tab'] == '1') {
                $where .= " and b.reconciliation_status = 1";
            } elseif ($filter['tab'] == '2') {
                $where .= " and b.reconciliation_status != 1";
            }
        }
        $sql = "select id,shop_name,{$field} from tx_shop_base where id = '{$filter['shop_id']}'";
        $shop = $GLOBALS['DB']->get_row($sql);
        $sql = "select a.pay_time,a.id,{$field_order},a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.pay_status = 1 {$where}  group by a.id";

        $list = $GLOBALS['DB']->get_results($sql);

        $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' {$where}  group by a.id";
        $filter['record_count'] = count($GLOBALS['DB']->get_results($sql));

        foreach ($list as $k => $v) {
            $list[$k]['total_price'] = $v['total_price'] - ($v['live_commission_v2'] + $v['goods_commission']);
        }

        $shop['reconciliation_money'] = 0;
        if ($filter['pay_status'] == '1') {
            $sql = "select a.pay_time,a.id,a.reconciliation_status,a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = {$filter['shop_id']} and a.pay_status = 1  and a.reconciliation_status != 1 group by a.id";
        } else {
            $sql = "select a.pay_time,a.id,b.reconciliation_status,a.order_no,sum(b.total_price) as total_price,sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = {$filter['shop_id']} and a.pay_status = 1 and (b.return_goods_status = 2 or b.return_goods_status = 8) group by a.id";
        }
        $results = $GLOBALS['DB']->get_results($sql);
        foreach ($results as $k => $v) {
            if ($v['reconciliation_status'] != 1) {
                $shop['reconciliation_money'] = ($shop['reconciliation_money'] + $v['total_price']) - ($v['live_commission_v2'] + $v['goods_commission']);

            }
        }


        //付款的
        if ($filter['pay_status'] == 1) {
            //全部多少条付款的
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.pay_status = 1 group by a.id";
            $shop['all'] = count($GLOBALS['DB']->get_results($sql));
            //已对账多少条
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.reconciliation_status = 1 and a.pay_status = 1 group by a.id";
            $shop['reconciled'] = count($GLOBALS['DB']->get_results($sql));
            //未对账多少条
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and a.reconciliation_status != 1 and a.pay_status = 1 group by a.id";
            $shop['no_reconciliation'] = count($GLOBALS['DB']->get_results($sql));
        } else {
            //退款的
            //全部多少条付款的
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and a.pay_status = 1 group by a.id";
            $shop['all'] = count($GLOBALS['DB']->get_results($sql));
            //已对账
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and b.reconciliation_status = 1 and a.pay_status = 1 group by a.id";
            $shop['reconciled'] = count($GLOBALS['DB']->get_results($sql));
            //未对账
            $sql = "select count(*) from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$filter['shop_id']}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and b.reconciliation_status != 1 and a.pay_status = 1 group by a.id";
            $shop['no_reconciliation'] = count($GLOBALS['DB']->get_results($sql));
        }
        $res = $list;
        $obj = new PHPExcel();
        $fileName = "第三方对账明细";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('第三方对账明细'); //设置标题
        $obj->getProperties()->setSubject('第三方对账明细'); //设置主题
        $obj->getProperties()->setDescription('第三方对账明细'); //设置描述
        $obj->getProperties()->setKeywords('第三方对账明细');//设置关键词
        $obj->getProperties()->setCategory('第三方对账明细');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('第三方对账明细');

        $list = ['A', 'B', 'C', 'D'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '订单编号')
            ->setCellValue($list[1] . '1', '对账金额')
            ->setCellValue($list[2] . '1', '状态')
            ->setCellValue($list[3] . '1', '付款时间');

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['total_price']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), ($res[$i]['reconciliation_status'] == '1' ? "已对账" : "未对账"));
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), ($res[$i]['pay_time'] == '' ? "" : date('Y-m-d H:i:s', $res[$i]['pay_time'])));
        }

        // 导出
        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }

    }

    public function v2_reconciliation()
    {
        $ids = ForceStringFrom('id');
        $tab = ForceStringFrom('pay_status');
        $shop_id = ForceStringFrom('shop_id');
        $number = count(explode(',', $ids));
        //查看多条订单是否存在对账的 已存在返回去对账错误
        if ($tab == '1') {
            //付款的
            $sql = "select sum(b.total_price) as total_price,a.reconciliation_status from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}' and a.id in ({$ids}) group by a.id";
        } else {
            //退款的
            $sql = "select sum(b.total_price) as total_price,b.reconciliation_status from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}'  and (b.return_goods_status = 2 or b.return_goods_status = 8) and a.id in ({$ids}) group by a.id";

        }
        $results = $GLOBALS['DB']->get_results($sql);
        foreach ($results as $k => $v) {
            if ($v['reconciliation_status'] == 1) {
                echo '3';
                die;
            }
        }

        //判断对账退款还是付款
        if ($tab == '1') {
            //付款
            $sql = "select sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission,sum(b.total_price) as total_price from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}' and a.id in ({$ids}) group by a.id";
        } else {
            //退款
            $sql = "select sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission,sum(b.total_price) as total_price from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}'  and (b.return_goods_status = 2 or b.return_goods_status = 8) and a.id in ({$ids}) group by a.id";
        }

        $row = $GLOBALS['DB']->get_results($sql);
        $res = 0;
        foreach ($row as $k => $v) {
            $res = ($res + $v['total_price']) - ($v['live_commission_v2'] + $v['goods_commission']);
        }
        return ['number' => $number, 'row' => $res, 'ids' => $ids, 'shop_id' => $shop_id, 'pay_status' => $tab];
    }

    public function v2_reconciliation_record()
    {
        $ids = ForceStringFrom('ids');
        $tab = ForceStringFrom('pay_status');
        $shop_id = ForceStringFrom('shop_id');
        $content = ForceStringFrom('content', '空');
        if ($tab == '1') {
            //付款
            $sql = "select sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission,a.id,sum(b.total_price) as total_price,a.order_no from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}' and a.id in ({$ids}) group by a.id";
        } else {
            //退款
            $sql = "select sum(b.live_commission_v2) as live_commission_v2,sum(b.goods_commission) as goods_commission,a.id,sum(b.total_price) as total_price,a.order_no from order_base as a left join order_item as b on a.id = b.order_id where a.shop_id = '{$shop_id}'  and (b.return_goods_status = 2 or b.return_goods_status = 8) and a.id in ({$ids}) group by a.id";
        }

        $list = $GLOBALS['DB']->get_results($sql);
        $time = time();
        $shop_money = 0;
        foreach ($list as $k => $v) {
            $shop_money = ($shop_money + $v['total_price']) - ($v['live_commission_v2'] + $v['goods_commission']);
            $sql = "insert into tx_reconciliation_operation_record set order_id = '{$v['id']}',content = '{$content}',shop_id= '{$shop_id}',addtime = '{$time}',total_price = '{$v['total_price']}',order_no = '{$v['order_no']}',`type` = '{$tab}',admin = '{$_SESSION['admin_name']}'";
            $GLOBALS['DB']->query($sql);
        }

        if ($tab == '1') {
            $sql = "update tx_shop_base set cumulative_reconciliation = cumulative_reconciliation + '{$shop_money}' where id = '{$shop_id}'";
        } else {
            $sql = "update tx_shop_base set return_cumulative_reconciliation = return_cumulative_reconciliation + '{$shop_money}' where id = '{$shop_id}'";
        }
        $GLOBALS['DB']->query($sql);

        if ($tab == '1') {
            //付款
            $sql = "update order_base set reconciliation_status = 1 where shop_id = '{$shop_id}' and id in ({$ids})";
        } else {
            //退款
            $sql = "update order_base as a,order_item as b set b.reconciliation_status = 1 where a.shop_id = '{$shop_id}' and (b.return_goods_status = 2 or b.return_goods_status = 8) and  a.id = b.order_id and a.id in ({$ids})";
        }
        if ($GLOBALS['DB']->query($sql)) {
            echo '1';
        } else {
            echo '2';
        }
    }

    public function v2_reconciliation_see()
    {
        $id = ForceStringFrom('id');
        $sql = "select * from tx_reconciliation_operation_record where order_id = '{$id}'";
        $list = $GLOBALS['DB']->get_results($sql);
        return $list;
    }

    public function v2_stored_record()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['time'] = ForceStringFrom('time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');

        $where = "";
        if (!empty($filter['order_no'])) {
            $where .= " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            $where .= " and (b.nick_name like '%{$filter['member_id']}%' or b.login_name like '%{$filter['member_id']}%')";
        }

        if (!empty($filter['time'])) {
            $time = explode(' - ', $filter['time']);
            $start = strtotime($time[0]);
            $end = strtotime($time[1]);
            $where .= " and a.pay_time >= '{$start}' and a.pay_time <= '{$end}'";
        }

        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.recharge_price >= '{$filter['start_money']}' and a.recharge_price <= '{$filter['end_money']}'";
        }

        $limit = ' limit';
        if ($filter['page'] == '1') {
            $limit = ' limit 0,' . $filter['page_size'];
        } else {
            $start = $filter['page'] * $filter['page_size'] - $filter['page_size'];
            $limit = ' limit ' . $start . ' , ' . $filter['page_size'];
        }

        $sql = "select a.pay_time,a.order_no,b.nick_name,b.login_name,a.recharge_price,a.give_price,a.experience_card,a.pay_type from tx_member_goddess as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where} order by a.id desc {$limit} ";
        $list = $GLOBALS['DB']->get_results($sql);
        $sql = "select count(*) from tx_member_goddess as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where}";
        $filter['record_count'] = $GLOBALS['DB']->get_var($sql);
        return ['list' => $list, 'filter' => $filter];
    }

    public function v2_stored_record_export()
    {
        $filter['page_size'] = ForceStringFrom('page_size', '15');
        $filter['page'] = ForceStringFrom('page', '1');
        $filter['order_no'] = ForceStringFrom('order_no');
        $filter['member_id'] = ForceStringFrom('member_id');
        $filter['time'] = ForceStringFrom('time');
        $filter['start_money'] = ForceStringFrom('start_money');
        $filter['end_money'] = ForceStringFrom('end_money');

        $where = "";
        if (!empty($filter['order_no'])) {
            $where .= " and a.order_no like '%{$filter['order_no']}%'";
        }

        if (!empty($filter['member_id'])) {
            $where .= " and (b.member_id like '%{$filter['nick_name']}%' or b.login_name like '%{$filter['member_id']}%')";
        }

        if (!empty($filter['time'])) {
            $time = explode(' - ', $filter['time']);
            $start = strtotime($time[0]);
            $end = strtotime($time[1]);
            $where .= " and a.pay_time >= '{$start}' and a.pay_time <= '{$end}'";
        }

        if (!empty($filter['start_money']) && !empty($filter['end_money'])) {
            $where .= " and a.recharge_price >= '{$filter['start_money']}' and a.recharge_price <= '{$filter['end_money']}'";
        }

        $sql = "select a.pay_time,a.order_no,b.nick_name,b.login_name,a.recharge_price,a.give_price,a.experience_card,a.pay_type from tx_member_goddess as a left join base_member as b on a.member_id = b.member_id where a.pay_status = 1 {$where} order by a.id desc";
        $res = $GLOBALS['DB']->get_results($sql);

        $obj = new PHPExcel();
        $fileName = "储值记录";
        $fileType = "xlsx";
        // 以下内容是excel文件的信息描述信息
        $obj->getProperties()->setCreator(''); //设置创建者
        $obj->getProperties()->setLastModifiedBy(''); //设置修改者
        $obj->getProperties()->setTitle('储值记录'); //设置标题
        $obj->getProperties()->setSubject('储值记录'); //设置主题
        $obj->getProperties()->setDescription('储值记录'); //设置描述
        $obj->getProperties()->setKeywords('储值记录');//设置关键词
        $obj->getProperties()->setCategory('储值记录');//设置类型
        // 设置当前sheet
        $obj->setActiveSheetIndex(0);

        // 设置当前sheet的名称
        $obj->getActiveSheet()->setTitle('储值记录');

        $list = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
        //$bottom_ri;
        // 填充第一行数据
        $obj->getActiveSheet()
            ->setCellValue($list[0] . '1', '支付时间')
            ->setCellValue($list[1] . '1', '储值流水号')
            ->setCellValue($list[2] . '1', '用户ID')
            ->setCellValue($list[3] . '1', '储值金额')
            ->setCellValue($list[4] . '1', '赠送金额')
            ->setCellValue($list[5] . '1', '体验卡')
            ->setCellValue($list[6] . '1', '支付方式');

        for ($i = 0; $i < count($res); $i++) {
            $obj->getActiveSheet()->setCellValue('A' . (2 + $i), ($res[$i]['pay_time'] == '' ? "" : date('Y-m-d H:i:s', $res[$i]['pay_time'])));
            $obj->getActiveSheet()->setCellValue('B' . (2 + $i), $res[$i]['order_no']);
            $obj->getActiveSheet()->setCellValue('C' . (2 + $i), $res[$i]['nick_name'] . '<br/>' . $res[$i]['login_name']);
            $obj->getActiveSheet()->setCellValue('D' . (2 + $i), $res[$i]['recharge_price']);
            $obj->getActiveSheet()->setCellValue('E' . (2 + $i), $res[$i]['give_price']);
            $obj->getActiveSheet()->setCellValue('F' . (2 + $i), $res[$i]['experience_card']);
            $obj->getActiveSheet()->setCellValue('G' . (2 + $i), ($res[$i]['pay_type'] == '1' ? "微信" : "支付宝"));
        }

        // 导出
        //ob_clean();
        iconv();
        if ($fileType == 'xls') {
            @ob_end_clean();
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xls');
            header('Cache-Control: max-age=1');
            $objWriter = new \PHPExcel_Writer_Excel5($obj);
            $objWriter->save('php://output');
            exit;
        } elseif ($fileType == 'xlsx') {
            @ob_end_clean();
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '.xlsx');
            header('Cache-Control: max-age=1');
            $objWriter = \PHPExcel_IOFactory::createWriter($obj, 'Excel2007');
            $objWriter->save('php://output');
            exit;
        }


    }

    //提现批量改导出
    public function withdrawal_batch($redisLink)
    {
//        var_dump($_POST);exit;
        $id = ForceStringFrom('id');
        $company_balance = ForceStringFrom('company_balance');
        $arrayPost = array(
            'withdraw_id' => $id,
            'admin_id' => $_SESSION['admin_id'],
            'status' => 1, //代申请
            'reason' => '提现处理中'

        );
        /**************************************(二期)放在redis队列中******************************/

//        var_dump($redisLink);exit;
//        $GLOBALS['redis_config'] = $redisLink;
//        $GLOBALS['redis'] = new Redis();
//        $GLOBALS['redis']->connect($GLOBALS['redis_config']['host'], $GLOBALS['redis_config']['port'], $GLOBALS['redis_config']['pass']);
//        $GLOBALS['redis']->auth($GLOBALS['redis_config']['pass']);
//        $GLOBALS['redis']->select($GLOBALS['redis_config']['database']);
//        $redisWithdraw = $GLOBALS['redis']->lpush('withdraw_batch', json_encode($arrayPost));
//        var_dump($redisWithdraw);
        //统计所选提现数据总金额 和 公司账户余额比较
        $sqlSelect="select sum(price) as sumPrice from tx_live_withdraw where id in  ( " . $arrayPost['withdraw_id'] . " )";
        $resultPrice = $GLOBALS['DB']->get_row($sqlSelect);
        if((string)$resultPrice['sumPrice']>(string)$company_balance){
//            10 大于账户所剩余额
            echo   10;
            exit;
        }

        //批量修改tx_live_withdraw  状态 提现状态：1.待处理 2.提现成功 3.提现失败 4.提现处理中
        $time = time();
        $sql = "update tx_live_withdraw set status = '4', deal_time = '{$time}',source_id = ".$arrayPost['admin_id']. " where id in ( " . $arrayPost['withdraw_id'] . " )";
        if ($GLOBALS['DB']->query($sql)) {
            echo 1;
        } else {
            echo 4;
        }
        exit;
        /**************************************放在redis队列中******************************/

    }
}


?>