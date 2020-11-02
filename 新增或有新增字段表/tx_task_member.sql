# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:14:51
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "tx_task_member"
#

DROP TABLE IF EXISTS `tx_task_member`;
CREATE TABLE `tx_task_member` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当前海星 （积分余额）',
  `price_all` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总获得海星 （总积分收入）',
  `price_use` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '使用海星 (提现积分总额)',
  `price_freeze` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '新版积分 (冻结金额字段）',
  `task_num` int(10) NOT NULL DEFAULT '0' COMMENT '完成任务数量',
  `remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '签到提醒 0：关闭  1：开启',
  `update_time` int(11) NOT NULL COMMENT '更新时间戳',
  `create_time` int(11) NOT NULL COMMENT '创建时间戳',
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5561 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务用户海星币表';
