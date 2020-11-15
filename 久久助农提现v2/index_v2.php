<?php
error_reporting(E_ALL^E_NOTICE^E_WARNING);
ini_set("display_errors",1);
set_time_limit(0);
require_once '../../www/init.php';
require_once '../../www/init_smarty.php';
require_once FRAMEWORK_PATH . '/library/common.lib.php';
require_once FRAMEWORK_PATH . '/library/mysql.class.php';
require_once FRAMEWORK_PATH . '/library/session.class.php';
require_once FRAMEWORK_PATH . '/module_v2/finance.class.php';
require_once FRAMEWORK_PATH . '/library/PHPExcel.php';
require_once '../../www/tx.config.php';//配置文件
require_once '../menu.php';
require_once FRAMEWORK_PATH . '/library/functions.lib.php';


load_module_config('account');

$GLOBALS['S'] = new cls_session($GLOBALS['MAIN_DOMAIN'], $GLOBALS['ADMIN_MAIN_SID'], $GLOBALS['ADMIN_MAIN_KID']);
$GLOBALS['DB'] = new cls_mysql($GLOBALS['account_settings']['dbserver']['default'] . '/?' . $GLOBALS['account_settings']['dbname']);

$GLOBALS['MC'] = new Memcache;
$GLOBALS['MC']->pconnect( $GLOBALS['account_settings']['mc_server']['default']['ip'], $GLOBALS['account_settings']['mc_server']['default']['port']);


$admin_id = $_SESSION['admin_id'];

$cls_admin_goods = new finance();

if(!$admin_id){
	exit('<script language="javascript">top.location.href="/index.php?act=logout"</script>');
}

$act = $_REQUEST['act'];
$link_id = $_REQUEST['link_id'];
$goods_id = $_REQUEST['goods_id'];

admin_priv('200000');
//判断权限
// if($act == 'list' && $link_id && $goods_id){
// 	admin_priv('goods_manage');
// }else{
// 	admin_priv('comment_manage');
// }
//load模块菜单
load_menu_module();


switch($act){
    case 'reconciliation_list':
        admin_priv('201010'); //查看权限
        $record = ForceStringFrom('record');
        if($_SESSION['shop_id'] <= 0 && $record == ""){
            //总后台
            $list = $cls_admin_goods->reconciliation_list();
            $GLOBALS['T']->assign('list',$list['list']);
            $GLOBALS['T']->assign('filter',$list['filter']);
            $GLOBALS['T']->display('admin_v2/reconciliation/reconciliation_list.html');
        }elseif (!empty($record) || $_SESSION['shop_id'] > 0){
            $list = $cls_admin_goods->reconciliation_record();
            $GLOBALS['T']->assign('list',$list['list']);
            $GLOBALS['T']->assign('shop',$list['shop']);
            $GLOBALS['T']->display('admin_v2/reconciliation/reconciliation_list.html');
        }
        break;
        //对账
    case 'reconciliation_reconciliation':
        $type = ForceStringFrom('type');
        if($type){
            admin_priv('201010'); //查看权限
        }else{
            admin_priv('201011'); //对账权限
        }
        $list = $cls_admin_goods->reconciliation_reconciliation();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('row',$list['row']);
        $GLOBALS['T']->display('admin_v2/reconciliation/reconciliation_reconciliation.html');
        break;
    //对账导出
    case 'reconciliation_export':
        admin_priv('201012'); //导出权限
        $cls_admin_goods->reconciliation_export();
        break;

    case "reconciliation_detailed_export":
        admin_priv('201112'); //导出权限
        $cls_admin_goods->reconciliation_detailed_export();
        break;

    //明细
    case "reconciliation_detailed":
        admin_priv('201011'); //对账权限
        $list = $cls_admin_goods->reconciliation_detailed();
        foreach($list['list'] as $k => $v){
            if(is_numeric($v['status'])){
                $list['list'][$k]['status'] = $tx_config['order_status'][$v['status']];
            }
        }
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/reconciliation_detailed.html');
        break;

    case 'reconciliation_confirm':
        admin_priv('201011'); //对账权限
        $list = $cls_admin_goods->reconciliation_confirm();
        break;

    case 'goods_reconciliation_list':
        admin_priv('201110'); //查看权限
        $record = ForceStringFrom('record');
        if($_SESSION['shop_id'] <= 0 && $record == ""){
            //总后台
            $list = $cls_admin_goods->goods_reconciliation_list();
            $GLOBALS['T']->assign('list',$list['list']);
            $GLOBALS['T']->assign('filter',$list['filter']);
            $GLOBALS['T']->display('admin_v2/reconciliation/goods_reconciliation_list.html');
        }elseif (!empty($record) || $_SESSION['shop_id'] > 0){
            $list = $cls_admin_goods->goods_reconciliation_list_shop();
            $GLOBALS['T']->assign('list',$list['list']);
            $GLOBALS['T']->assign('shop',$list['shop']);
            $GLOBALS['T']->display('admin_v2/reconciliation/goods_reconciliation_list.html');
        }
        break;


    case "goods_reconciliation_list_export":
        admin_priv('201112'); //导出权限
        $cls_admin_goods->goods_reconciliation_list_export();
        break;

    //销量
    case 'goods_reconciliation_reconciliation':
        admin_priv('201110'); //查看权限
        $list = $cls_admin_goods->goods_reconciliation_reconciliation();
        $type = ForceStringFrom('type','1');
        $GLOBALS['T']->assign('type',$type);
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('shop',$list['shop']);
        $GLOBALS['T']->display('admin_v2/reconciliation/goods_reconciliation_reconciliation.html');
        break;
        //销量对账
    case 'goods_reconciliation_confirm':
        admin_priv('201011'); //对账权限
        $cls_admin_goods->goods_reconciliation_confirm();
        break;
        //销量导出
    case 'goods_reconciliation_export':
        admin_priv('201112'); //导出权限
        $cls_admin_goods->goods_reconciliation_export();
        break;

    case 'goods_reconciliation_detailed':
        admin_priv('201010'); //查看权限
        $list = $cls_admin_goods->goods_reconciliation_detailed();
        foreach($list['list'] as $k => $v){
            if(empty($v['app_status'])){
                $list['list'][$k]['app_status'] = $tx_config['order_status'][$v['status']];
            }
        }
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('data',$list['data']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/goods_reconciliation_detailed.html');
        break;

        //导出
    case "goods_reconciliation_detailed_export":
        admin_priv('201012'); //导出权限
         $cls_admin_goods->goods_reconciliation_detailed_export();
        break;

    case "goods_reconciliation_price_export":
        admin_priv('201112'); //导出权限
        $cls_admin_goods->goods_reconciliation_price_export();
    break;

    //发票
    case 'invoice_list':
        admin_priv('201210'); //查看权限
        $list = $cls_admin_goods->invoice_list();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->assign('search',$list['search']);
        $GLOBALS['T']->display('admin_v2/reconciliation/invoice_list.html');
        break;

    case "invoice_close":
        $status = ForceStringFrom('status');
        if($status == 10){
            admin_priv('201211','8'); //修改权限
        }else{
            admin_priv('201211'); //修改权限
        }
        $cls_admin_goods->invoice_close();
        break;

    case "invoice_list_export":
        admin_priv('201212'); //导出权限
        $cls_admin_goods->invoice_list_export();
        break;

    case 'invoice_see':
        $invoice_status = ForceStringFrom('invoice_status');
        if($invoice_status){
            admin_priv('201211');
            $cls_admin_goods->invoice_see_edit();
        }else{
            admin_priv('201210'); //查看权限
            $list = $cls_admin_goods->invoice_see();
            $GLOBALS['T']->assign('list',$list);
            $GLOBALS['T']->display('admin_v2/reconciliation/invoice_see.html');
        }
        break;

    case 'reconciliation_list_export': //总后台列表导出
        admin_priv('201112'); //导出权限
        $cls_admin_goods->reconciliation_list_export();
        break;

    case "reconciliation_list_shop_export":
        admin_priv('201012'); //导出权限
        $cls_admin_goods->reconciliation_list_shop_export();
        break;

    case "recharge_record":
        admin_priv('201310'); //查看权限   充值
        $list = $cls_admin_goods->recharge_record();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/recharge_record.html');
        break;
    //导出
    case "recharge_record_export":
        admin_priv('201314'); //查看权限   充值
        $cls_admin_goods->recharge_record_export();
        break;

    case "red_envelopes":
        admin_priv('201310'); //查看权限   充值
        $list = $cls_admin_goods->red_envelopes();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/red_envelopes.html');
        break;

    case "red_envelopes_export":
        admin_priv('201314'); //查看权限   充值
        $cls_admin_goods->red_envelopes_export();
        break;

        //提现管理
    case "withdrawal_list":
        admin_priv('201410'); //查看权限  提现
        $list = $cls_admin_goods->withdrawal_list();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/withdrawal_list.html');
        break;
        //批量提现
    case "withdrawal_batch":
        admin_priv('201410'); // 权限 批量提现
        $redisLink=$GLOBALS['redis_config'];
        $list = $cls_admin_goods->withdrawal_batch($redisLink);
        break;

    case "withdrawal_list_export":
        admin_priv('201414'); //导出
        $cls_admin_goods->withdrawal_list_export();
        break;

    case "withdrawal_see":
        admin_priv('201410'); //查看权限  查看
        $list = $cls_admin_goods->withdrawal_see();
        $GLOBALS['T']->assign('list',$list);
        $GLOBALS['T']->display('admin_v2/reconciliation/withdrawal_see.html');
    break;

    case "ajax_withdrawal_save":
            admin_priv('201412','8'); //查看权限  提现
            $id = ForceStringFrom('id');
            $source_type = ForceStringFrom('source_type');
            $GLOBALS['T']->assign('id',$id);
            $GLOBALS['T']->assign('source_type',$source_type);
            $GLOBALS['T']->display('admin_v2/reconciliation/ajax_withdrawal_save.html');
            break;
    case "ajax_withdrawal_edit":
            $cls_admin_goods->ajax_withdrawal_save();
        break;
    //微信商户付款
    case "merchants_pay":
        $cls_admin_goods->merchants_pay();
        break;

    case "text_alipay":
        $cls_admin_goods->text_alipay();
        break;



        // v2 版本对账 ----------------------------------------
    //第三方对账列表
    case "v2_reconciliation_list":
        admin_priv('201010'); //查看权限
        $list = $cls_admin_goods->v2_reconciliation_list();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/v2_reconciliation_list.html');
        break;


    //第三方对账列表导出表格
    case "v2_reconciliation_list_export":
        admin_priv('201012'); //查看权限
        $list = $cls_admin_goods->v2_reconciliation_list_export();
        break;


        //店铺明细
    case "v2_details":
        admin_priv('201010','8'); //查看权限
        $list = $cls_admin_goods->v2_details();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('shop',$list['shop']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/v2_details.html');
        break;

    //店铺明细导出表格
    case "v2_details_export":
        admin_priv('201012'); //查看权限
        $list = $cls_admin_goods->v2_details_export();
        break;

        //对账信息
    case "v2_reconciliation":
        admin_priv('201011','8'); //对账权限
        $list = $cls_admin_goods->v2_reconciliation();
        $GLOBALS['T']->assign('row',$list['row']);
        $GLOBALS['T']->assign('number',$list['number']);
        $GLOBALS['T']->assign('ids',$list['ids']);
        $GLOBALS['T']->assign('shop_id',$list['shop_id']);
        $GLOBALS['T']->assign('pay_status',$list['pay_status']);
        $GLOBALS['T']->display('admin_v2/reconciliation/v2_reconciliation.html');
        break;
        //对账入库
    case "v2_reconciliation_record":
        admin_priv('201011','8'); //对账权限
        $cls_admin_goods->v2_reconciliation_record();
        break;

    case "v2_reconciliation_see":
        admin_priv('201010','8'); //查看权限
        $list = $cls_admin_goods->v2_reconciliation_see();
        $GLOBALS['T']->assign('list',$list);
        $GLOBALS['T']->display('admin_v2/reconciliation/v2_reconciliation_see.html');
        break;

        //储值记录
    case "v2_stored_record":
        admin_priv('201610'); //查看权限
        $list = $cls_admin_goods->v2_stored_record();
        $GLOBALS['T']->assign('list',$list['list']);
        $GLOBALS['T']->assign('filter',$list['filter']);
        $GLOBALS['T']->display('admin_v2/reconciliation/v2_stored_record.html');
        break;

    case "v2_stored_record_export":
        admin_priv('201611'); //导出权限
        $list = $cls_admin_goods->v2_stored_record_export();
        break;
}
?>