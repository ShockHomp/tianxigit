# Host: 10.2.8.114  (Version: 5.7.31-log)
# Date: 2020-11-02 12:06:37
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "base_bankcard"
#

DROP TABLE IF EXISTS `base_bankcard`;
CREATE TABLE `base_bankcard` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '银行卡id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `bank_num` varchar(50) NOT NULL COMMENT '银行卡号',
  `bank_name` varchar(50) NOT NULL COMMENT '银行卡名称',
  `bank_type` varchar(20) NOT NULL COMMENT '银行卡类型',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '绑定状态 0 绑定失败 1已绑定 2解除绑定',
  `is_default` int(1) DEFAULT '0' COMMENT '默认使用卡 1是 0否',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  `name_type` int(11) NOT NULL DEFAULT '1000' COMMENT '名称类型',
  `validDate` varchar(20) DEFAULT NULL COMMENT '信用卡有效期，MM/YY格式',
  `cvv2` varchar(20) DEFAULT NULL COMMENT '信用卡cvv2码',
  `cardSeq` varchar(255) DEFAULT NULL COMMENT '绑卡流水号',
  `phone` varchar(255) NOT NULL COMMENT '手机号',
  `id_card` varchar(255) NOT NULL COMMENT '身份证',
  `real_name` varchar(255) NOT NULL COMMENT '真实姓名',
  `bank_sign_up` varchar(20) NOT NULL DEFAULT '1' COMMENT '签约 1 签约申请 2签约中 3签约成功 4签约失败',
  `order_no` varchar(255) DEFAULT NULL COMMENT '签约订单号',
  `is_del` tinyint(2) DEFAULT '0' COMMENT '是否删除 0未删 1已删',
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  KEY `status` (`status`),
  KEY `is_default` (`is_default`),
  KEY `bank_num` (`bank_num`)
) ENGINE=InnoDB AUTO_INCREMENT=8899 DEFAULT CHARSET=utf8mb4 COMMENT='银行卡';
