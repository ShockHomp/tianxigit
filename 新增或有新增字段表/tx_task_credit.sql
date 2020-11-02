# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:10:05
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "tx_task_credit"
#

DROP TABLE IF EXISTS `tx_task_credit`;
CREATE TABLE `tx_task_credit` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '任务标题',
  `task_type` int(1) NOT NULL DEFAULT '0' COMMENT '任务类型 1积分兑优惠券2积分兑换阳光3积分兑换提现',
  `pic` varchar(200) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '分类图标',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始时间戳',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '结束时间戳',
  `data_time` int(11) NOT NULL DEFAULT '0' COMMENT '数据更新时间，前台数据查询所需的时间戳',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务开关 1：开启  2：关闭',
  `starfish` int(10) NOT NULL DEFAULT '0' COMMENT '普通用户海星数量(变为积分)',
  `starfish_vip` int(10) NOT NULL DEFAULT '0' COMMENT 'VIP用户海星数量',
  `max_num` int(10) NOT NULL DEFAULT '0' COMMENT '当日统计最多数（3看直播，14分享精神）',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间戳',
  `desc` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`),
  KEY `end_time` (`end_time`),
  KEY `sort` (`sort`),
  KEY `start_time` (`start_time`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC COMMENT='任务表';

#
# Data for table "tx_task_credit"
#

INSERT INTO `tx_task_credit` VALUES (1,'积分兑换优惠券值',1,'',0,0,0,0,0,0,0,0,1600270530,NULL),(2,'积分兑换阳光值',2,'',0,0,0,0,0,0,0,0,1600270530,NULL),(3,'积分兑换提现值',3,'',0,0,0,0,0,0,0,0,1600270530,NULL),(4,'阳光值兑换积分',4,'',0,0,0,0,0,0,0,0,1600270530,NULL);
