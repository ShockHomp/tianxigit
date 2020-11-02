# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:11:28
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "tx_goods_attr_link"
#

DROP TABLE IF EXISTS `tx_goods_attr_link`;
CREATE TABLE `tx_goods_attr_link` (
  `link_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `link_info` text COMMENT '属性（颜色 尺码）',
  `link_price` decimal(11,2) DEFAULT NULL COMMENT ' 销售价格',
  `coupon_amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券金额',
  `original_price` decimal(11,2) DEFAULT '0.00' COMMENT '原价',
  `vip_price` decimal(11,2) DEFAULT NULL COMMENT 'VIP价格',
  `commission` decimal(11,2) DEFAULT NULL COMMENT '佣金',
  `total_num` int(11) DEFAULT NULL COMMENT '销售库存(下单减)',
  `sale_warning` int(11) DEFAULT NULL COMMENT '销售预警值',
  `sale_num` int(11) NOT NULL COMMENT '销量',
  `link_pic` varchar(255) DEFAULT NULL COMMENT '图片',
  `live_commission` decimal(10,2) DEFAULT '0.00' COMMENT '直播间佣金',
  `one` decimal(10,2) DEFAULT '0.00',
  `two` decimal(10,2) DEFAULT '0.00',
  `three` decimal(10,2) DEFAULT NULL,
  `four` decimal(10,2) DEFAULT '0.00',
  `five` decimal(10,2) DEFAULT '0.00',
  `six` decimal(10,2) DEFAULT NULL,
  `seven` decimal(10,2) DEFAULT '0.00',
  `eight` decimal(10,2) DEFAULT '0.00',
  `nine` decimal(10,2) DEFAULT NULL,
  `ten` decimal(10,2) DEFAULT NULL,
  `eleven` decimal(10,2) DEFAULT '0.00',
  `twelve` decimal(10,2) DEFAULT '0.00',
  `share` decimal(10,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL COMMENT '状态 1正常 2禁用 3 删除 4 添加中',
  `limit_num` int(11) NOT NULL COMMENT '0 代表不限购',
  `Version_No` int(11) DEFAULT '1' COMMENT '版本号',
  `live_commission_v2` decimal(11,2) NOT NULL COMMENT '直播佣金',
  `goods_commission` decimal(11,2) NOT NULL COMMENT '商品佣金',
  `attr_info_id` varchar(50) DEFAULT NULL COMMENT '属性id --liuyang',
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1347 DEFAULT CHARSET=utf8;
