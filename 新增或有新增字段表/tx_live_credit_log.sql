# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:09:30
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "tx_live_credit_log"
#

DROP TABLE IF EXISTS `tx_live_credit_log`;
CREATE TABLE `tx_live_credit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '贝壳流水ID',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `credit_num` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '积分数',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.直播打赏 2.提现 3.提现退回 4.提现到账',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝（type-2/3）4.银行卡',
  `reward_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '直播打赏ID（type-1）',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '打赏用户id（type-1）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=114238 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='积分流水记录表';
