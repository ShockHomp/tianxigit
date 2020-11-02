# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:11:04
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "tx_goods_base"
#

DROP TABLE IF EXISTS `tx_goods_base`;
CREATE TABLE `tx_goods_base` (
  `goods_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_type` tinyint(1) DEFAULT '0' COMMENT '1 自营商品 2 店铺商品 3 VIP礼包 4 新人专区 5 专区商品 6 体验商品',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `original_price` decimal(11,2) DEFAULT '0.00' COMMENT '商品原价',
  `goods_price` decimal(11,2) DEFAULT '0.00' COMMENT '商品最低价钱（现价）',
  `coupon_amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券金额',
  `vip_price` decimal(11,2) DEFAULT '0.00' COMMENT 'vip价格',
  `commission` decimal(11,2) NOT NULL COMMENT '佣金',
  `goods_commission` decimal(11,2) NOT NULL COMMENT '商品佣金',
  `live_commission` decimal(11,2) NOT NULL COMMENT '直播佣金',
  `level_1` int(11) NOT NULL COMMENT '一级分类',
  `level_2` int(11) NOT NULL COMMENT '二级分类',
  `level_3` int(11) NOT NULL COMMENT '二级分类',
  `cat_id` varchar(255) DEFAULT NULL COMMENT '分类ID',
  `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称',
  `brand_id` int(11) DEFAULT '0' COMMENT '品牌ID',
  `self_label_id` varchar(255) DEFAULT NULL COMMENT '商品标签',
  `service_label_id` varchar(255) DEFAULT NULL COMMENT '服务标签',
  `freight_id` int(11) DEFAULT NULL COMMENT '运费模板ID',
  `pic` varchar(255) DEFAULT NULL COMMENT '商品主图',
  `pic_arr` text COMMENT '商品图片',
  `goods_video` varchar(255) DEFAULT NULL COMMENT '商品视频',
  `short_intro` text COMMENT '商品详情',
  `update_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `creat_time` datetime DEFAULT NULL COMMENT '创建时间',
  `virtual_sales` int(11) DEFAULT '0' COMMENT '虚拟销量',
  `sale_num` int(11) DEFAULT '0' COMMENT '销量',
  `comments_num` int(11) DEFAULT '0' COMMENT '评论数',
  `is_package` tinyint(1) DEFAULT '0' COMMENT '是否包邮 1包邮 2 不包邮',
  `pv` int(11) DEFAULT '0' COMMENT '浏览量',
  `vip_gift_time` int(11) NOT NULL COMMENT 'VIP赠送时间',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(3) DEFAULT NULL COMMENT '是否上架 1 上架 2下架 3 删除',
  `audit_status` tinyint(3) DEFAULT NULL COMMENT '1 审核通过 2审核拒绝 3待审核',
  `audit_reasons` varchar(255) NOT NULL COMMENT '审核原因',
  `seckill` int(11) NOT NULL DEFAULT '0' COMMENT '0 不是秒杀商品 1 是秒杀商品',
  PRIMARY KEY (`goods_id`),
  KEY `goods_type` (`goods_type`),
  KEY `shop_id` (`shop_id`),
  KEY `is_show` (`is_show`),
  KEY `audit_status` (`audit_status`)
) ENGINE=InnoDB AUTO_INCREMENT=1328 DEFAULT CHARSET=utf8;
