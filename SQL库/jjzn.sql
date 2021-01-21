# Host: 10.2.8.106  (Version: 5.6.48-log)
# Date: 2021-01-21 14:01:55
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "about_us"
#

DROP TABLE IF EXISTS `about_us`;
CREATE TABLE `about_us` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='关于我们';

#
# Structure for table "account_record"
#

DROP TABLE IF EXISTS `account_record`;
CREATE TABLE `account_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `y_m` varchar(20) NOT NULL COMMENT '年月',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `total_price` decimal(10,2) NOT NULL COMMENT '对账金额',
  `status` int(11) NOT NULL COMMENT '对账状态 0 未对账1 已对账',
  `ck_time` int(11) NOT NULL COMMENT '对账时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COMMENT='对账表';

#
# Structure for table "activity_news"
#

DROP TABLE IF EXISTS `activity_news`;
CREATE TABLE `activity_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `activity_dec` text NOT NULL COMMENT '活动内容',
  `activity_image` varchar(255) NOT NULL COMMENT '活动图片',
  `short_desc` varchar(255) NOT NULL DEFAULT '0' COMMENT '活动简短描述',
  `is_special` tinyint(1) NOT NULL DEFAULT '2' COMMENT '是否专题 1是 2否',
  `c_time` datetime NOT NULL COMMENT '创建时间',
  `check_time` int(11) NOT NULL COMMENT '查看时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '默认1 正常显示 2禁用  3删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `title` (`title`(191)) USING BTREE,
  KEY `is_special` (`is_special`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `activity_image` (`activity_image`(191)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资讯文章列表数据';

#
# Structure for table "admin_account"
#

DROP TABLE IF EXISTS `admin_account`;
CREATE TABLE `admin_account` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` char(50) COLLATE utf8_unicode_ci NOT NULL,
  `password` char(50) COLLATE utf8_unicode_ci NOT NULL,
  `group_id` char(100) COLLATE utf8_unicode_ci NOT NULL,
  `status` char(1) COLLATE utf8_unicode_ci NOT NULL COMMENT '1:正常0:禁用2:删除',
  `action_list` text COLLATE utf8_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_id` int(4) NOT NULL COMMENT '角色ID',
  `parent_id` int(4) NOT NULL COMMENT '添加者',
  `storehouse_id` int(11) NOT NULL COMMENT '库房ID 0是总管理员 大于0的对应库房ID',
  `serial_no` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT '编号-pos',
  `cellphone` varchar(11) COLLATE utf8_unicode_ci NOT NULL COMMENT '手机号码-pos',
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT '姓名-pos',
  `remark` text COLLATE utf8_unicode_ci NOT NULL COMMENT '备注-pos',
  `manager_pw` char(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '店长密码-pos',
  `login_num` bigint(20) NOT NULL,
  `addtime` int(11) DEFAULT NULL COMMENT '创建账号时间',
  `savetime` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `login_time` int(10) NOT NULL DEFAULT '0' COMMENT '登录时间',
  `login_ip` varchar(55) CHARACTER SET utf8 DEFAULT NULL COMMENT '登录ip',
  `login_address` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '登录地址（省市）',
  PRIMARY KEY (`admin_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=182 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='管理员帐号表';

#
# Structure for table "app_switch"
#

DROP TABLE IF EXISTS `app_switch`;
CREATE TABLE `app_switch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '名称',
  `flag` varchar(20) NOT NULL DEFAULT '' COMMENT '标签',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0关闭1开启',
  `remark` varchar(200) NOT NULL DEFAULT '' COMMENT '备注',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后操作时间',
  `admin_id` varchar(32) NOT NULL DEFAULT '0' COMMENT 'admin',
  `last_ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'ip',
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='app功能开关';

#
# Structure for table "article_cate"
#

DROP TABLE IF EXISTS `article_cate`;
CREATE TABLE `article_cate` (
  `login_address` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cate_name` varchar(50) NOT NULL COMMENT '分类名称',
  `cate_icon` varchar(255) NOT NULL COMMENT '分类图片',
  `cate_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态默认1 正常 2 已删除',
  `cate_sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  `is_show` tinyint(1) NOT NULL DEFAULT '2' COMMENT '1 显示 2 不显示',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cate_name` (`cate_name`) USING BTREE,
  KEY `cate_status` (`cate_status`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='资讯文章分类列表';

#
# Structure for table "article_list"
#

DROP TABLE IF EXISTS `article_list`;
CREATE TABLE `article_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章描述',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  `cate_id` int(11) NOT NULL COMMENT '对应分类id',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '默认1 正常显示 2 删除',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '文章排序',
  `c_name` varchar(50) NOT NULL COMMENT '文章创建人',
  `is_show` tinyint(1) NOT NULL DEFAULT '2' COMMENT '1 显示  2 不显示',
  `type` tinyint(2) NOT NULL COMMENT '1图文 2 图片',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `title` (`title`(191)) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资讯文章列表数据';

#
# Structure for table "balance_pay_log"
#

DROP TABLE IF EXISTS `balance_pay_log`;
CREATE TABLE `balance_pay_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `oid` int(11) NOT NULL COMMENT '订单ID',
  `before_amount` decimal(11,2) NOT NULL COMMENT '交易前余额',
  `last_amount` decimal(10,2) NOT NULL COMMENT '交易后余额',
  `price` decimal(10,2) NOT NULL COMMENT '金额',
  `status` int(11) NOT NULL COMMENT '1 成功',
  `time` datetime NOT NULL COMMENT '时间',
  `pay_type` int(11) NOT NULL COMMENT '类型 1 支出 2 收入',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='余额支付日志';

#
# Structure for table "bank_cards"
#

DROP TABLE IF EXISTS `bank_cards`;
CREATE TABLE `bank_cards` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '绑定状态 1：预绑定状态 2：成功绑定状态',
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否为默认银行卡 0：否 1：是',
  `bank_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '银行ID',
  `account_number_show` varchar(50) NOT NULL DEFAULT '' COMMENT '银行卡号 前端显示用',
  `account_number_encode` char(172) NOT NULL DEFAULT '' COMMENT '银行卡号（密文） 支付用',
  `real_name` char(172) NOT NULL DEFAULT '' COMMENT '真实姓名 （密文）',
  `id_card` char(172) NOT NULL DEFAULT '' COMMENT '身份证号 （密文）',
  `mobile` char(172) NOT NULL DEFAULT '' COMMENT '手机 （密文）',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '卡类型 1：储蓄卡 2：信用卡',
  `bind_id` char(172) NOT NULL DEFAULT '' COMMENT '合利宝绑定ID （密文）',
  `user_id` char(172) NOT NULL DEFAULT '' COMMENT '合利宝用户ID （密文）',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '绑定时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_id_member_id_status` (`id`,`member_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COMMENT='绑定银行卡表';

#
# Structure for table "bankofamerica"
#

DROP TABLE IF EXISTS `bankofamerica`;
CREATE TABLE `bankofamerica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bank` varchar(50) NOT NULL DEFAULT '' COMMENT '银行',
  `img_big` varchar(255) NOT NULL DEFAULT '' COMMENT '大图标',
  `img_snall` varchar(255) NOT NULL DEFAULT '' COMMENT '小图标',
  `color` varchar(32) NOT NULL DEFAULT '' COMMENT '颜色',
  `admin_id` varchar(32) NOT NULL DEFAULT '0' COMMENT 'admin_id',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后操作时间',
  `last_ip` varchar(32) NOT NULL DEFAULT '' COMMENT 'ip',
  `letters` varchar(10) NOT NULL DEFAULT '' COMMENT '首字母',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COMMENT='银行卡信息';

#
# Structure for table "base_action"
#

DROP TABLE IF EXISTS `base_action`;
CREATE TABLE `base_action` (
  `login_ip` varchar(255) DEFAULT NULL,
  `action_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL COMMENT '类型 1系统 2库房',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0',
  `action_code` varchar(30) NOT NULL DEFAULT '',
  `relevance` varchar(20) NOT NULL DEFAULT '',
  `cn_name` varchar(500) NOT NULL COMMENT '模块名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1启用0不启用',
  `icon` varchar(32) NOT NULL DEFAULT '' COMMENT '图标',
  `link` varchar(255) NOT NULL DEFAULT '' COMMENT '链接',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`action_id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4294967296 DEFAULT CHARSET=utf8 COMMENT='模块分配表';

#
# Structure for table "base_ad"
#

DROP TABLE IF EXISTS `base_ad`;
CREATE TABLE `base_ad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ad_img` varchar(255) NOT NULL COMMENT '图片',
  `ad_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1 正常 2 删除',
  `ad_show` int(11) DEFAULT '2' COMMENT '1显示 2 不显示',
  `ad_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '跳转类型 具体见配置文件',
  `redirect_id` int(11) NOT NULL DEFAULT '0' COMMENT '跳转对应id',
  `redirect_first_id` int(11) NOT NULL COMMENT '跳转一级分类',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL COMMENT '修改时间',
  `ad_sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `scroll_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '显示位置 对应配置文件',
  `province_id` int(11) NOT NULL COMMENT '省id',
  `city_id` int(11) NOT NULL COMMENT '城市id',
  `area_id` int(11) NOT NULL COMMENT '区id',
  `street_id` int(11) NOT NULL COMMENT '街道id',
  `type` int(11) NOT NULL COMMENT '类型 0 轮播图 1 广告位',
  `title` char(20) NOT NULL COMMENT '标题',
  `subtitle` char(20) NOT NULL COMMENT '副标题',
  `color` char(20) NOT NULL COMMENT '颜色',
  `redirect_url` varchar(255) NOT NULL COMMENT '跳转地址',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ad_img` (`ad_img`(191)) USING BTREE,
  KEY `ad_status` (`ad_status`) USING BTREE,
  KEY `ad_show` (`ad_show`) USING BTREE,
  KEY `ad_type` (`ad_type`) USING BTREE,
  KEY `redirect_id` (`redirect_id`) USING BTREE,
  KEY `redirect_first_id` (`redirect_first_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `title` (`title`) USING BTREE,
  KEY `redirect_url` (`redirect_url`(191)) USING BTREE,
  KEY `scroll_type` (`scroll_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图';

#
# Structure for table "base_advice"
#

DROP TABLE IF EXISTS `base_advice`;
CREATE TABLE `base_advice` (
  `login_ip` varchar(255) DEFAULT NULL,
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 服务 2 商品 3  系统 4  其他',
  `question_str` varchar(255) NOT NULL COMMENT '所选问题id 对应系统配置文件',
  `order_id_str` varchar(255) NOT NULL COMMENT '订单号 ',
  `question_desc` varchar(500) NOT NULL COMMENT '问题描述',
  `question_image` varchar(600) NOT NULL COMMENT '问题图片',
  `c_time` int(10) NOT NULL COMMENT '创建时间',
  `member_id` int(10) NOT NULL COMMENT '会员id',
  `return_desc` varchar(600) NOT NULL COMMENT '商城回复内容',
  `is_return` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1待回复 2 已回复 3忽略',
  `return_time` int(10) NOT NULL COMMENT '回复时间',
  `service_id` varchar(20) NOT NULL COMMENT '工单号',
  `question_select_desc` varchar(500) NOT NULL COMMENT '所选问题对应描述',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='商城反馈数据表';

#
# Structure for table "base_app"
#

DROP TABLE IF EXISTS `base_app`;
CREATE TABLE `base_app` (
  `id` tinyint(1) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `image_url` varchar(255) NOT NULL COMMENT '图片地址',
  `video_url` varchar(255) NOT NULL COMMENT '视频地址',
  `is_show` tinyint(1) NOT NULL DEFAULT '2' COMMENT '是否启用 1 启用 2 关闭',
  `type` tinyint(1) NOT NULL COMMENT '链接类型',
  `redirect_id` int(11) NOT NULL COMMENT '跳转ID',
  `wait_time` tinyint(1) NOT NULL DEFAULT '0' COMMENT '显示时间 s',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 显示 2 删除',
  `start_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 图片 2 视频',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `redirect_first_id` int(11) NOT NULL COMMENT '跳转一级分类ID',
  `redirect_url` text NOT NULL COMMENT '跳转地址',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `image_url` (`image_url`(191)) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `redirect_id` (`redirect_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `start_type` (`start_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COMMENT='首页启动';

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
  `bank_id` int(11) DEFAULT '0' COMMENT 'bankofamerica.id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_default` (`is_default`) USING BTREE,
  KEY `bank_num` (`bank_num`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=167609 DEFAULT CHARSET=utf8mb4 COMMENT='银行卡';

#
# Structure for table "base_brand"
#

DROP TABLE IF EXISTS `base_brand`;
CREATE TABLE `base_brand` (
  `brand_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(90) NOT NULL DEFAULT '',
  `sort` int(4) unsigned NOT NULL DEFAULT '50' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3删除 ',
  PRIMARY KEY (`brand_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COMMENT='品牌表';

#
# Structure for table "base_category"
#

DROP TABLE IF EXISTS `base_category`;
CREATE TABLE `base_category` (
  `cat_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '',
  `type` tinyint(4) NOT NULL COMMENT '1自营 2 秒杀 3 优品汇 4 生活圈',
  `parent_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '父类ID',
  `sort` tinyint(4) NOT NULL COMMENT '排序',
  `cate_pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '分类图片',
  `pic_more` text COLLATE utf8_bin NOT NULL COMMENT '轮播图  cat_show 1 显示  2 禁用   status  1  正常  2  删除',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3删除 ',
  PRIMARY KEY (`cat_id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `cat_name` (`cat_name`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品分类列表';

#
# Structure for table "base_icon"
#

DROP TABLE IF EXISTS `base_icon`;
CREATE TABLE `base_icon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `icon` varchar(255) NOT NULL COMMENT '图标地址',
  `location_id` tinyint(2) NOT NULL COMMENT '位置 对应配置文件',
  `redirect_type` tinyint(2) NOT NULL COMMENT '跳转地址',
  `redirect_id` int(11) NOT NULL COMMENT '跳转id',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `app_desc` varchar(255) NOT NULL COMMENT '描述',
  `c_time` int(10) NOT NULL COMMENT '创建时间',
  `u_time` int(10) NOT NULL COMMENT '修改时间',
  `sort` smallint(5) NOT NULL COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态默认1 正常 2 已删除	',
  `is_show` tinyint(1) NOT NULL DEFAULT '2' COMMENT '1 显示 2 不显示	',
  `redirect_first_id` int(11) NOT NULL COMMENT '分类跳转一级ID',
  `redirect_url` text NOT NULL COMMENT '跳转地址',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `location_id` (`location_id`) USING BTREE,
  KEY `icon` (`icon`(191)) USING BTREE,
  KEY `redirect_type` (`redirect_type`) USING BTREE,
  KEY `redirect_id` (`redirect_id`) USING BTREE,
  KEY `title` (`title`(191)) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COMMENT='平台快捷按钮配置';

#
# Structure for table "base_live_apply"
#

DROP TABLE IF EXISTS `base_live_apply`;
CREATE TABLE `base_live_apply` (
  `apply_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '申请id',
  `live_id` int(11) NOT NULL COMMENT '直播id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `anchor_id` int(11) NOT NULL COMMENT '主播id',
  `apply_reason` char(10) NOT NULL COMMENT '申请原因',
  `apply_time` int(11) NOT NULL COMMENT '申请时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  `apply_status` tinyint(1) NOT NULL COMMENT '申请状态 1 待通过 2 拒绝 3 通过  4 结束 ',
  `operating_id` int(11) NOT NULL,
  PRIMARY KEY (`apply_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `apply_status` (`apply_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播申请连麦记录';

#
# Structure for table "base_live_banned"
#

DROP TABLE IF EXISTS `base_live_banned`;
CREATE TABLE `base_live_banned` (
  `banned_id` int(11) NOT NULL AUTO_INCREMENT,
  `live_id` int(11) NOT NULL COMMENT '直播id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `banned_time` int(11) NOT NULL COMMENT '禁言时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`banned_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播禁言表';

#
# Structure for table "base_live_comment"
#

DROP TABLE IF EXISTS `base_live_comment`;
CREATE TABLE `base_live_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 2 禁用 3 删除',
  `comment` varchar(500) NOT NULL COMMENT '评论内容',
  `comment_time` int(10) NOT NULL COMMENT '评论时间',
  `live_room_id` int(11) NOT NULL COMMENT '直播间 房间ID',
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播评论列表信息';

#
# Structure for table "base_live_like"
#

DROP TABLE IF EXISTS `base_live_like`;
CREATE TABLE `base_live_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `live_id` int(11) NOT NULL COMMENT '直播间id',
  `like_num` int(11) NOT NULL COMMENT '点赞数量',
  `update_time` int(11) NOT NULL COMMENT '变更时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播间点赞表';

#
# Structure for table "base_live_list"
#

DROP TABLE IF EXISTS `base_live_list`;
CREATE TABLE `base_live_list` (
  `bank_sign_up` varchar(20) DEFAULT NULL COMMENT '签约 1 成功 2 失败',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '对应主播id',
  `member_other_id` int(11) NOT NULL COMMENT '另一个主播id',
  `group_id` char(20) NOT NULL COMMENT '群组id',
  `live_name` varchar(100) NOT NULL COMMENT '直播间名称',
  `live_room_id` varchar(255) NOT NULL COMMENT '直播间id',
  `live_start_time` int(10) NOT NULL COMMENT '直播开始时间',
  `live_other_start_time` int(11) NOT NULL COMMENT '主播开始播放时间',
  `live_cover` varchar(255) NOT NULL COMMENT '直播间封面',
  `expire_time` int(11) NOT NULL,
  `playback` char(200) NOT NULL,
  `duration` int(11) NOT NULL COMMENT '回访时长',
  `live_see_num` int(10) NOT NULL COMMENT '直播间观看人数',
  `live_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 直播中 2 直播结束 3 直播封禁 4 删除',
  `live_end_time` int(10) NOT NULL COMMENT '直播结束时间',
  `live_label` varchar(255) NOT NULL COMMENT '直播标签',
  `promotion_id` int(11) NOT NULL COMMENT '活动id',
  `like_num` int(11) NOT NULL,
  `live_type` tinyint(1) NOT NULL COMMENT '直播模式 1 单人 2 pk',
  `manual_operation` tinyint(1) NOT NULL COMMENT '手动操作 1是 0 否',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `member_other_id` (`member_other_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`(191)) USING BTREE,
  KEY `live_see_num` (`live_see_num`) USING BTREE,
  KEY `live_status` (`live_status`) USING BTREE,
  KEY `promotion_id` (`promotion_id`) USING BTREE,
  KEY `live_start_time` (`live_start_time`) USING BTREE,
  KEY `live_type` (`live_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播房间列表信息';

#
# Structure for table "base_live_real"
#

DROP TABLE IF EXISTS `base_live_real`;
CREATE TABLE `base_live_real` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `real_name` varchar(255) NOT NULL COMMENT '真实姓名',
  `card` varchar(255) NOT NULL COMMENT '身份证号',
  `nick_name` varchar(255) NOT NULL COMMENT '昵称',
  `phone` varchar(255) NOT NULL COMMENT '手机号',
  `card_photo` varchar(255) NOT NULL COMMENT '身份证照片',
  `card_photob` varchar(255) NOT NULL,
  `status` tinyint(2) NOT NULL COMMENT '审核状态 1审核中 2审核通过 3审核失败 4 删除',
  `reason` varchar(500) NOT NULL COMMENT '驳回原因',
  `member_id` varchar(255) NOT NULL,
  `add_time` datetime NOT NULL COMMENT '添加时间',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示 1显示 2 不显示',
  `service_id` varchar(30) NOT NULL COMMENT '工单号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COMMENT='实名认证表';

#
# Structure for table "base_live_report"
#

DROP TABLE IF EXISTS `base_live_report`;
CREATE TABLE `base_live_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '举报人id',
  `reason` char(20) NOT NULL COMMENT '违规理由',
  `live_room_id` varchar(255) NOT NULL COMMENT '直播间id',
  `content` varchar(255) NOT NULL COMMENT '举报内容',
  `report_pic` varchar(5000) NOT NULL COMMENT '举报图片',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 审核中 2举报通过 3举报失败 4删除',
  `report_time` datetime NOT NULL COMMENT '举报时间',
  `pass_reason` text NOT NULL COMMENT '审核通过原因',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='直播举报列表';

#
# Structure for table "base_member"
#

DROP TABLE IF EXISTS `base_member`;
CREATE TABLE `base_member` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会员id',
  `login_name` varchar(50) NOT NULL COMMENT '登录账号',
  `login_password` varchar(150) NOT NULL COMMENT '登录密码',
  `nick_name` varchar(100) NOT NULL COMMENT '昵称',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别1 男 2 女',
  `head_image` varchar(255) NOT NULL DEFAULT 'http://api.js.lnysym.com/image/woman.png' COMMENT '头像',
  `small_head_image` varchar(255) NOT NULL COMMENT '小头像',
  `big_head_image` varchar(255) NOT NULL COMMENT '大头像',
  `phone` char(11) NOT NULL COMMENT '手机号',
  `account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '自营钱包',
  `member_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '会员类型 1 普通 2 超级店长',
  `share_number` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '推广码数量',
  `share_money` decimal(10,2) NOT NULL COMMENT '分享红包',
  `freeze_money` decimal(10,2) NOT NULL COMMENT '冻结红包',
  `is_anchor` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为主播 1 是',
  `is_life_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为生活圈店长1 是',
  `is_yp_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为优品汇店长 1 是',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '推广人 id ',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `last_login_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `login_ip` char(15) NOT NULL COMMENT '登录ip',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 2 禁用 3 删除',
  `login_num` int(10) NOT NULL DEFAULT '0' COMMENT '累计登录次数',
  `fans_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播粉丝数量',
  `play_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播 开播次数',
  `pk_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播pk次数',
  `can_play` tinyint(1) NOT NULL DEFAULT '0' COMMENT '当前主播开播权限是否已被禁用 1 已禁用',
  `rand_key` varchar(200) NOT NULL,
  `pay_password` varchar(50) NOT NULL DEFAULT '0' COMMENT '用户支付密码',
  `birthday` varchar(50) NOT NULL COMMENT '会员生日',
  `msg_json` varchar(200) NOT NULL DEFAULT '0' COMMENT '消息json 全局 1 不接受 2 接受',
  `is_authentication` tinyint(2) NOT NULL COMMENT '实名认证 0否 1是',
  `province_id` int(11) NOT NULL COMMENT '省份ID',
  `city_id` int(11) NOT NULL COMMENT '城市ID',
  `area_id` int(11) NOT NULL COMMENT '区域ID',
  `area` varchar(255) NOT NULL COMMENT '具体地址',
  `group_id` char(100) NOT NULL COMMENT '群组id',
  `open_live_num` int(11) NOT NULL COMMENT '已开播数量',
  `close_time` int(10) NOT NULL DEFAULT '0' COMMENT '用户被禁用 或者被删除的时间',
  `jpush_id` varchar(200) NOT NULL DEFAULT '',
  `user_flags` int(11) NOT NULL DEFAULT '0' COMMENT '用户类别 0 新用户 1老用户',
  `user_salt` varchar(255) NOT NULL COMMENT '用户盐值',
  `customer_id` int(11) NOT NULL DEFAULT '0' COMMENT '老会员id',
  `is_sync` tinyint(2) NOT NULL COMMENT '是否同步优惠券 1 ：是 0：否',
  `relation_type` tinyint(2) NOT NULL DEFAULT '2' COMMENT '用户关联关系 2默认随机人 1 非默认',
  `import_integral` decimal(10,2) NOT NULL COMMENT '导入积分',
  `is_vip` int(11) NOT NULL COMMENT '是否是VIP',
  `counter_or_community` tinyint(4) NOT NULL COMMENT '会员是否为专柜或社区等级 1 是 0 否',
  `vip_start_time` int(15) NOT NULL COMMENT 'Vip 开始时间',
  `vip_end_time` int(15) NOT NULL COMMENT 'Vip 结束时间',
  `member_cash_coupon` decimal(11,2) NOT NULL COMMENT '会员现金券金额',
  `member_use_cash_coupon` decimal(11,2) NOT NULL COMMENT '会员已使用的现金券',
  `refer` varchar(50) NOT NULL COMMENT '邀请人账号',
  `consume_level` int(11) NOT NULL DEFAULT '0' COMMENT '会员等级',
  `wx_num` varchar(255) NOT NULL COMMENT '微信号',
  `wx_id` varchar(255) NOT NULL COMMENT '微信ID',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名（微信）',
  `level_time` int(11) NOT NULL DEFAULT '0' COMMENT '升级时间',
  `level` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户级别 1.普通用户  大于1 小助手',
  `manage_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '管理员类别 1超管 2房管',
  `manage_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '管理员状态：1启用 2禁用',
  `last_pay_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后支付时间',
  `count_pay_num` int(10) NOT NULL DEFAULT '0' COMMENT '消费次数',
  `sum_order_pay` decimal(12,2) NOT NULL COMMENT '订单消费金额',
  `order_price_average` decimal(12,2) NOT NULL COMMENT '订单均价',
  `count_order_num` int(10) NOT NULL DEFAULT '0' COMMENT '订单数量（用户）',
  `change_anchor_time` int(10) NOT NULL DEFAULT '0' COMMENT '主播身份状态变更时间',
  `sum_play_time` int(10) NOT NULL DEFAULT '0' COMMENT '直播累计时长',
  `anchor_order_num` int(10) NOT NULL DEFAULT '0' COMMENT '订单数（主播直播）',
  `anchor_total_sales` decimal(12,2) NOT NULL COMMENT '销售额（主播直播）',
  `anchor_commission` decimal(12,2) NOT NULL COMMENT '直播佣金（主播直播）',
  `anchor_playback_order` int(10) NOT NULL DEFAULT '0' COMMENT '订单数（主播回放）',
  `anchor_playback_sales` decimal(12,2) NOT NULL COMMENT '销售额（主播回放）',
  `last_play_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后直播时间',
  `recommend_sort` int(10) NOT NULL DEFAULT '0' COMMENT '推荐排序',
  `is_all_column` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为全频道 1 是',
  `is_all_goods` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为全商品 1 是',
  `mutual_fav_num` int(10) NOT NULL DEFAULT '0' COMMENT '关注数量',
  `mutual_fans_num` int(10) NOT NULL DEFAULT '0' COMMENT '粉丝数量',
  `lng` varchar(20) NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(20) NOT NULL DEFAULT '' COMMENT '纬度',
  `ali_id` varchar(200) NOT NULL DEFAULT '' COMMENT '支付宝ID',
  `ali_num` varchar(200) NOT NULL DEFAULT '' COMMENT '支付宝账号',
  `ali_real_name` varchar(50) NOT NULL DEFAULT '' COMMENT '支付宝真实姓名',
  `ali_openid` varchar(200) NOT NULL DEFAULT '' COMMENT '支付宝openid',
  `red_packet_balance` decimal(10,2) unsigned NOT NULL COMMENT '红包余额',
  `diamond_balance` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '钻石余额 (变为阳光余额)',
  `shell_balance` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '贝壳余额',
  `encode_nick` varchar(500) NOT NULL DEFAULT '' COMMENT '昵称(16进制)',
  `is_fk` tinyint(3) NOT NULL DEFAULT '0' COMMENT '虚拟用户：0.正常 1.虚拟',
  `reg_location_address_id` int(10) NOT NULL DEFAULT '0' COMMENT '注册归属地地址ID字段',
  `live_hot_sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '热门直播推荐排序',
  `live_hot_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '热门直播推荐状态：1.启用 2.禁用',
  `tag_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '热门标签ID',
  `tag_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '热门标签状态：1.启用 2.禁用',
  `goddess_equity` tinyint(3) NOT NULL DEFAULT '0' COMMENT '女神权益：0未开启 1已开启',
  `goddess_card_balance` decimal(10,2) NOT NULL COMMENT '女神卡余额',
  `experience_card_balance` int(10) NOT NULL DEFAULT '0' COMMENT '体验卡数量',
  `public_benefit_number` varchar(30) NOT NULL DEFAULT '' COMMENT '公益编号',
  `auth_role_1` tinyint(1) NOT NULL DEFAULT '1' COMMENT '区代 1否2是',
  `auth_role_2` tinyint(1) NOT NULL DEFAULT '1' COMMENT '社区长 1否2是',
  `channel` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '渠道 1否2是',
  `login_token` varchar(40) NOT NULL COMMENT '登录标识',
  `shareholder` tinyint(1) DEFAULT '1' COMMENT '股东 1否2是',
  `shareholder_cycle` varchar(40) DEFAULT '0' COMMENT '股东(周期)',
  `shareholder_complete_time` varchar(50) DEFAULT '' COMMENT '股东(完成时间)',
  `invalid` tinyint(1) unsigned zerofill DEFAULT '1' COMMENT '是否股东断档 1断档 2不断档',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `rand_key` (`rand_key`(191)) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `login_name` (`login_name`) USING BTREE,
  KEY `login_password` (`login_password`) USING BTREE,
  KEY `nick_name` (`nick_name`) USING BTREE,
  KEY `sex` (`sex`) USING BTREE,
  KEY `head_image` (`head_image`(191)) USING BTREE,
  KEY `phone` (`phone`) USING BTREE,
  KEY `is_anchor` (`is_anchor`) USING BTREE,
  KEY `is_life_manager` (`is_life_manager`) USING BTREE,
  KEY `is_yp_manager` (`is_yp_manager`) USING BTREE,
  KEY `is_fk` (`is_fk`) USING BTREE,
  KEY `ali_id` (`ali_id`(191)) USING BTREE,
  KEY `goddess_equity` (`goddess_equity`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=888890 DEFAULT CHARSET=utf8mb4 COMMENT='会员';

#
# Structure for table "base_member_clan"
#

DROP TABLE IF EXISTS `base_member_clan`;
CREATE TABLE `base_member_clan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `dis_group` tinyint(1) NOT NULL DEFAULT '1' COMMENT '战队  1大组(先放)  2小组 (后放)',
  `group_member_id` int(11) NOT NULL DEFAULT '0' COMMENT '组员',
  `performance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总业绩  ',
  `node_performance1` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '1业绩   对碰',
  `node_performance2` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '2业绩   对碰',
  `people_num1` int(11) NOT NULL DEFAULT '0' COMMENT '1人数',
  `people_num2` int(11) NOT NULL DEFAULT '0' COMMENT '2人数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`,`dis_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=986 DEFAULT CHARSET=utf8 COMMENT='新手指引';

#
# Structure for table "base_member_community_add_log"
#

DROP TABLE IF EXISTS `base_member_community_add_log`;
CREATE TABLE `base_member_community_add_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL COMMENT '社区代理ID 对应 base_member.id & base_member.auth_role1 = 2',
  `coumntuy_id` int(11) DEFAULT NULL COMMENT '社区长ID 对应 base_member.id & base_member.auth_role2 = 2',
  `create_time` int(11) DEFAULT NULL COMMENT '添加时间戳',
  `status` tinyint(1) DEFAULT '1' COMMENT '审核状态 1 待审核 2 已拒绝 3 已通过',
  `status_time` int(11) DEFAULT '0' COMMENT '审核时间',
  `verify_id` int(11) DEFAULT NULL COMMENT '审核人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

#
# Structure for table "base_member_new_relationship"
#

DROP TABLE IF EXISTS `base_member_new_relationship`;
CREATE TABLE `base_member_new_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `node_id` int(11) NOT NULL DEFAULT '0' COMMENT '结点人id',
  `performance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总业绩',
  `node_performance1` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '业绩1',
  `node_performance2` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '业绩2',
  `people_num1` int(11) NOT NULL DEFAULT '0' COMMENT '人数1',
  `people_num2` int(11) NOT NULL COMMENT '人数2',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `area_num` tinyint(1) NOT NULL DEFAULT '1' COMMENT '区',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`) USING BTREE,
  KEY `node_Performance` (`node_performance1`) USING BTREE,
  KEY `people_num` (`people_num1`) USING BTREE,
  KEY `node_id` (`node_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15656 DEFAULT CHARSET=utf8 COMMENT='新手指引';

#
# Structure for table "base_member_old"
#

DROP TABLE IF EXISTS `base_member_old`;
CREATE TABLE `base_member_old` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会员id',
  `login_name` varchar(50) NOT NULL COMMENT '登录账号',
  `login_password` varchar(150) NOT NULL COMMENT '登录密码',
  `nick_name` varchar(100) NOT NULL COMMENT '昵称',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别1 男 2 女',
  `head_image` varchar(255) NOT NULL COMMENT '头像',
  `small_head_image` varchar(255) NOT NULL COMMENT '小头像',
  `big_head_image` varchar(255) NOT NULL COMMENT '大头像',
  `phone` char(11) NOT NULL COMMENT '手机号',
  `account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '自营钱包',
  `member_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '会员类型 1 普通 2 超级店长',
  `share_number` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '推广码数量',
  `share_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分享红包',
  `freeze_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '冻结红包',
  `is_anchor` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为主播 1 是',
  `is_life_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为生活圈店长1 是',
  `is_yp_manager` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为优品汇店长 1 是',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '推广人 id ',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `last_login_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `login_ip` char(15) NOT NULL COMMENT '登录ip',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 2 禁用 3 删除',
  `login_num` int(10) NOT NULL DEFAULT '0' COMMENT '累计登录次数',
  `fans_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播粉丝数量',
  `play_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播 开播次数',
  `pk_num` int(10) NOT NULL DEFAULT '0' COMMENT '主播pk次数',
  `can_play` tinyint(1) NOT NULL DEFAULT '0' COMMENT '当前主播开播权限是否已被禁用 1 已禁用',
  `rand_key` varchar(200) NOT NULL,
  `pay_password` varchar(50) NOT NULL DEFAULT '0' COMMENT '用户支付密码',
  `birthday` varchar(50) NOT NULL COMMENT '会员生日',
  `msg_json` varchar(200) NOT NULL DEFAULT '0' COMMENT '消息json 全局 1 不接受 2 接受',
  `is_authentication` tinyint(2) NOT NULL COMMENT '实名认证 0否 1是',
  `province_id` int(11) NOT NULL COMMENT '省份ID',
  `city_id` int(11) NOT NULL COMMENT '城市ID',
  `area_id` int(11) NOT NULL COMMENT '区域ID',
  `area` varchar(255) NOT NULL COMMENT '具体地址',
  `group_id` char(100) NOT NULL COMMENT '群组id',
  `open_live_num` int(11) NOT NULL COMMENT '已开播数量',
  `close_time` int(10) NOT NULL DEFAULT '0' COMMENT '用户被禁用 或者被删除的时间',
  `jpush_id` varchar(200) NOT NULL,
  `user_flags` int(11) NOT NULL COMMENT '用户类别 0 新用户 1老用户',
  `user_salt` varchar(255) NOT NULL COMMENT '用户盐值',
  `customer_id` int(11) NOT NULL COMMENT '老会员id',
  `is_sync` tinyint(2) NOT NULL COMMENT '是否同步优惠券 1 ：是 0：否',
  `import_integral` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '导入积分',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `rand_key` (`rand_key`(191)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员';

#
# Structure for table "base_member_relationship"
#

DROP TABLE IF EXISTS `base_member_relationship`;
CREATE TABLE `base_member_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `node_id` int(11) NOT NULL DEFAULT '0' COMMENT '结点人id',
  `performance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总业绩 自己加下级',
  `node_performance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '业绩 自己下级 对碰',
  `people_num` int(11) NOT NULL DEFAULT '0' COMMENT '分支人数',
  `community_num` int(11) NOT NULL DEFAULT '0' COMMENT '社区长数量',
  `total_integral` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总积分 ',
  `judgment_integral` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '积分10000上限',
  `judgment_integral_time` int(11) NOT NULL DEFAULT '0' COMMENT '积分更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`) USING BTREE,
  KEY `node_Performance` (`node_performance`) USING BTREE,
  KEY `people_num` (`people_num`) USING BTREE,
  KEY `node_id` (`node_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=913 DEFAULT CHARSET=utf8 COMMENT='新手指引';

#
# Structure for table "base_member_sid"
#

DROP TABLE IF EXISTS `base_member_sid`;
CREATE TABLE `base_member_sid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `sid` varchar(200) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=282970 DEFAULT CHARSET=utf8 COMMENT='用户设备关联表';

#
# Structure for table "base_recharge"
#

DROP TABLE IF EXISTS `base_recharge`;
CREATE TABLE `base_recharge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recharge_money` float NOT NULL COMMENT '充值金额',
  `share_code_amount` int(11) NOT NULL COMMENT '分享码数量',
  `give_money` int(11) NOT NULL COMMENT '赠送金额',
  `is_default` int(11) NOT NULL COMMENT '是否是默认 0 否 1 是',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 1 正常 2 删除',
  `sort` int(11) NOT NULL COMMENT '排序 越大越靠前',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recharge_money` (`recharge_money`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='充值表';

#
# Structure for table "base_region"
#

DROP TABLE IF EXISTS `base_region`;
CREATE TABLE `base_region` (
  `region_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `code` int(11) NOT NULL COMMENT '行政区编码',
  `region_name` varchar(32) NOT NULL,
  `default_city_x` varchar(20) NOT NULL COMMENT '经度坐标',
  `default_city_y` varchar(20) NOT NULL COMMENT '纬度坐标',
  `dafault_range` int(11) NOT NULL COMMENT '配送范围',
  PRIMARY KEY (`region_id`) USING BTREE,
  KEY `code` (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=88889 DEFAULT CHARSET=utf8 COMMENT='行政区划代码';

#
# Structure for table "base_role"
#

DROP TABLE IF EXISTS `base_role`;
CREATE TABLE `base_role` (
  `role_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL COMMENT '类型 1系统角色 2库房角色',
  `role_name` varchar(60) NOT NULL DEFAULT '',
  `action_list` text NOT NULL,
  `role_describe` text NOT NULL,
  `parent_id` int(4) DEFAULT '1' COMMENT '管理员ID',
  `priv` tinyint(1) DEFAULT '0' COMMENT '是否有添加角色的权限1有',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`role_id`) USING BTREE,
  KEY `user_name` (`role_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COMMENT='角色权限分配';

#
# Structure for table "base_search_hot"
#

DROP TABLE IF EXISTS `base_search_hot`;
CREATE TABLE `base_search_hot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `search_title` varchar(200) NOT NULL COMMENT '搜索标题',
  `sort` int(10) NOT NULL DEFAULT '1' COMMENT '搜索排序',
  `addtime` int(10) NOT NULL COMMENT '添加时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态1 正常 2 禁用 3 删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `search_title` (`search_title`(191)) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索页搜索发现';

#
# Structure for table "base_service_label"
#

DROP TABLE IF EXISTS `base_service_label`;
CREATE TABLE `base_service_label` (
  `service_label_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `service_label_name` varchar(90) NOT NULL DEFAULT '' COMMENT '标签名称',
  `label_title` varchar(200) NOT NULL COMMENT '标签描述',
  `sort` int(4) unsigned NOT NULL DEFAULT '50' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3删除 ',
  PRIMARY KEY (`service_label_id`) USING BTREE,
  KEY `service_label_name` (`service_label_name`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='标签表';

#
# Structure for table "base_shipping"
#

DROP TABLE IF EXISTS `base_shipping`;
CREATE TABLE `base_shipping` (
  `shipping_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `shipping_code` varchar(20) NOT NULL DEFAULT '0',
  `shipping_name` varchar(120) NOT NULL DEFAULT '',
  `shipping_desc` varchar(255) NOT NULL DEFAULT '  ',
  `insure` varchar(10) NOT NULL DEFAULT '0',
  `support_cod` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `shipping_print` text NOT NULL,
  `userID` int(8) NOT NULL COMMENT '后台用户ID',
  `shipping_money` float(10,2) DEFAULT NULL COMMENT '满额配送',
  `pay_after` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否货到付款',
  PRIMARY KEY (`shipping_id`) USING BTREE,
  KEY `shipping_code` (`shipping_code`,`enabled`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='快递';

#
# Structure for table "base_shipping_area"
#

DROP TABLE IF EXISTS `base_shipping_area`;
CREATE TABLE `base_shipping_area` (
  `shipping_area_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `shipping_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `configure` text NOT NULL,
  `template_id` int(8) NOT NULL COMMENT '运费模版管理ID',
  `expecial_area` text NOT NULL COMMENT '特殊区域邮费设置',
  `enable` tinyint(1) NOT NULL COMMENT '是否启用',
  PRIMARY KEY (`shipping_area_id`) USING BTREE,
  KEY `shipping_id` (`shipping_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='特殊区域邮费设置';

#
# Structure for table "base_shipping_area_region"
#

DROP TABLE IF EXISTS `base_shipping_area_region`;
CREATE TABLE `base_shipping_area_region` (
  `shipping_area_id` smallint(5) DEFAULT NULL,
  `region_id` smallint(5) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='快递地区';

#
# Structure for table "base_shipping_template"
#

DROP TABLE IF EXISTS `base_shipping_template`;
CREATE TABLE `base_shipping_template` (
  `template_id` int(8) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '运费模版名称',
  `free_fee` tinyint(1) NOT NULL COMMENT '是否免费',
  `enable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否可用 0不可以 1可用',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为默认',
  `userID` int(8) NOT NULL COMMENT '管理ID',
  PRIMARY KEY (`template_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='运费模版表';

#
# Structure for table "business_cooperation"
#

DROP TABLE IF EXISTS `business_cooperation`;
CREATE TABLE `business_cooperation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `company` char(20) NOT NULL COMMENT '品牌/公司',
  `name` char(10) NOT NULL COMMENT '姓名',
  `station` char(10) NOT NULL COMMENT '岗位',
  `phone` char(11) NOT NULL COMMENT '联系电话',
  `intention` char(200) NOT NULL COMMENT '合作意向',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  `check_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '审核状态 1待审核 2申请通过 3申请拒绝',
  `reason` varchar(200) NOT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COMMENT='商务合作';

#
# Structure for table "city_library"
#

DROP TABLE IF EXISTS `city_library`;
CREATE TABLE `city_library` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '城市id',
  `citycode` varchar(20) NOT NULL COMMENT '城市编码',
  `adcode` varchar(20) NOT NULL COMMENT '区域编码',
  `name` varchar(50) NOT NULL COMMENT '行政区名称',
  `first_letter` varchar(5) NOT NULL COMMENT '首字母',
  `parent_id` int(10) NOT NULL DEFAULT '0' COMMENT '父级id',
  `center` varchar(100) NOT NULL COMMENT '城市中心点',
  `level` varchar(20) NOT NULL COMMENT '行政区划级别',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `citycode` (`citycode`) USING BTREE,
  KEY `adcode` (`adcode`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=46281 DEFAULT CHARSET=utf8 COMMENT='城市库表';

#
# Structure for table "cms_bonus_account"
#

DROP TABLE IF EXISTS `cms_bonus_account`;
CREATE TABLE `cms_bonus_account` (
  `id_bonus_account` bigint(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(10) unsigned NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT '0',
  `creator_member_id` bigint(10) unsigned NOT NULL,
  `id_order` bigint(10) unsigned NOT NULL,
  `id_product` bigint(255) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  `credit` decimal(10,2) unsigned NOT NULL,
  `create_time` int(10) unsigned NOT NULL,
  `is_calc` tinyint(1) unsigned NOT NULL,
  `is_need_calc` tinyint(1) unsigned NOT NULL,
  `memo` varchar(200) NOT NULL,
  PRIMARY KEY (`id_bonus_account`) USING BTREE,
  KEY `is_calc` (`is_calc`) USING BTREE,
  KEY `id_order` (`id_order`) USING BTREE,
  KEY `id_user_type` (`member_id`,`type`) USING BTREE,
  KEY `id_user_type_create` (`member_id`,`type`,`creator_member_id`) USING BTREE,
  KEY `is_need_calc` (`is_need_calc`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE,
  KEY `is_calc_reason` (`is_calc`) USING BTREE,
  KEY `type_withdraw_status` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3765 DEFAULT CHARSET=utf8;

#
# Structure for table "cms_invite_reward"
#

DROP TABLE IF EXISTS `cms_invite_reward`;
CREATE TABLE `cms_invite_reward` (
  `id` bigint(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(10) unsigned NOT NULL,
  `channel` tinyint(1) NOT NULL DEFAULT '30',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `create_time` int(10) unsigned NOT NULL,
  `memo` varchar(200) NOT NULL,
  `num` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id_user_type` (`member_id`,`type`) USING BTREE,
  KEY `id_user_type_create` (`member_id`,`type`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE,
  KEY `type_withdraw_status` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "cms_member_settlement"
#

DROP TABLE IF EXISTS `cms_member_settlement`;
CREATE TABLE `cms_member_settlement` (
  `id` bigint(255) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(255) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '周起始时间',
  `date_time` char(10) NOT NULL DEFAULT '' COMMENT '周起始日期',
  `credit_promote` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '推广积分330+ 小于2=0  2=40  3=90  大于3=153  ',
  `credit_promote_config_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '推广配置id',
  `promote_week` int(10) NOT NULL DEFAULT '0' COMMENT '连续推广周数量',
  `helpfarmers` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '助农积分为 最大为配置70',
  `helpfarmers_week_config_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '助农周档位 2=70,18=49,19=28,20=0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5592 DEFAULT CHARSET=utf8;

#
# Structure for table "cms_member_yesterday"
#

DROP TABLE IF EXISTS `cms_member_yesterday`;
CREATE TABLE `cms_member_yesterday` (
  `id` bigint(255) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(255) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日起始时间',
  `date_time` char(10) NOT NULL DEFAULT '' COMMENT '日起始日期',
  `app_num` int(10) NOT NULL DEFAULT '0' COMMENT '打开app次数',
  `live_num` int(10) NOT NULL DEFAULT '0' COMMENT '观看直播时长(秒)',
  `minapp_num` int(10) NOT NULL DEFAULT '0' COMMENT '小程序转发次数',
  `app_config_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'app启动次数配置',
  `app_credit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'app启动积分',
  `live_config_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '直播观看配置',
  `live_credit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '直播观看积分',
  `minapp_config_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '小程序转发配置',
  `minapp_credit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '小程序转发积分',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=30993 DEFAULT CHARSET=utf8;

#
# Structure for table "cms_msg_queue"
#

DROP TABLE IF EXISTS `cms_msg_queue`;
CREATE TABLE `cms_msg_queue` (
  `id_msg_queue` bigint(255) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `member_id` bigint(255) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `status_time` int(10) unsigned NOT NULL DEFAULT '0',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0',
  `data` text NOT NULL,
  `try_times` int(11) unsigned NOT NULL DEFAULT '0',
  `last_try_time` int(11) NOT NULL DEFAULT '0',
  `result` text NOT NULL,
  PRIMARY KEY (`id_msg_queue`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=713 DEFAULT CHARSET=utf8;

#
# Structure for table "comment"
#

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_type` tinyint(4) NOT NULL COMMENT '类型 1 商品 2 店铺',
  `link_id` int(11) NOT NULL COMMENT '关联ID',
  `item_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `user_id` int(11) NOT NULL COMMENT '评论人ID',
  `comment` text NOT NULL COMMENT '评论内容',
  `reply` text NOT NULL COMMENT '回复内容',
  `comment_time` int(11) NOT NULL COMMENT '评论时间',
  `reply_time` int(11) NOT NULL COMMENT '回复时间',
  `comment_status` tinyint(4) NOT NULL COMMENT '状态1.审核通过 2.未审核 3  删除',
  `score` float NOT NULL DEFAULT '0' COMMENT '评分',
  `score_1` float NOT NULL COMMENT '描述相符',
  `score_2` float NOT NULL COMMENT '服务态度',
  `score_3` float NOT NULL COMMENT '物流服务  /  店铺环境',
  `pic` text NOT NULL COMMENT '评论图片',
  `label_json` char(200) NOT NULL COMMENT '评价标签json',
  `advice` varchar(500) NOT NULL COMMENT '审核不通过过原因',
  `anonymous` int(11) NOT NULL COMMENT '是否是匿名评论 1 是 0 否',
  PRIMARY KEY (`comment_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `link_id_2` (`link_id`,`user_id`) USING BTREE,
  KEY `comment_status` (`comment_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=804 DEFAULT CHARSET=utf8 COMMENT='商品/店铺 评论表';

#
# Structure for table "comment_list"
#

DROP TABLE IF EXISTS `comment_list`;
CREATE TABLE `comment_list` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `pwd` varchar(255) NOT NULL,
  `user_salt` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `nick_name` varchar(255) NOT NULL,
  `gender` int(11) NOT NULL,
  `is_mobile` int(11) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `create_time` varchar(20) NOT NULL,
  `credit` decimal(10,2) NOT NULL,
  `refer` varchar(255) NOT NULL,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品/店铺 评论表';

#
# Structure for table "customer_list"
#

DROP TABLE IF EXISTS `customer_list`;
CREATE TABLE `customer_list` (
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `gender` int(11) NOT NULL,
  `is_mobile` int(11) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `create_time` varchar(20) NOT NULL,
  `credit1` decimal(10,2) NOT NULL DEFAULT '0.00',
  `refer` varchar(255) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `credit2` decimal(10,2) NOT NULL DEFAULT '0.00',
  `consume_level` int(11) NOT NULL DEFAULT '0',
  `is_repeat` int(11) NOT NULL DEFAULT '0' COMMENT '重复 0不重复 1重复',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`username`(250)) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=103335 DEFAULT CHARSET=utf8;

#
# Structure for table "customer_list_new"
#

DROP TABLE IF EXISTS `customer_list_new`;
CREATE TABLE `customer_list_new` (
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `gender` int(11) NOT NULL,
  `is_mobile` int(11) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `create_time` varchar(20) NOT NULL,
  `credit1` decimal(10,2) NOT NULL DEFAULT '0.00',
  `refer` varchar(255) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `credit2` decimal(10,2) NOT NULL DEFAULT '0.00',
  `consume_level` int(11) NOT NULL DEFAULT '0',
  `is_repeat` int(11) NOT NULL DEFAULT '0' COMMENT '重复 0不重复 1重复',
  `is_status` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '1更新 2插入',
  `is_child` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`username`(250)) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=104360 DEFAULT CHARSET=utf8;

#
# Structure for table "cz"
#

DROP TABLE IF EXISTS `cz`;
CREATE TABLE `cz` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL DEFAULT '0',
  `login_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=592 DEFAULT CHARSET=latin1;

#
# Structure for table "device_auth"
#

DROP TABLE IF EXISTS `device_auth`;
CREATE TABLE `device_auth` (
  `device_id` int(10) NOT NULL AUTO_INCREMENT,
  `device_SN` char(100) COLLATE utf8_bin NOT NULL,
  `device_mobile` char(50) COLLATE utf8_bin NOT NULL,
  `device_key` char(32) COLLATE utf8_bin NOT NULL,
  `first_auth` datetime NOT NULL,
  `last_auth` datetime NOT NULL,
  PRIMARY KEY (`device_id`) USING BTREE,
  UNIQUE KEY `device_SN` (`device_SN`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=444 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='设备信息';

#
# Structure for table "discount_record"
#

DROP TABLE IF EXISTS `discount_record`;
CREATE TABLE `discount_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '提现id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现金额',
  `discount_time` int(11) NOT NULL COMMENT '提现时间',
  `verify_time` int(11) NOT NULL COMMENT '审核时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '审核 0未审核1审核通过2审核未通过',
  `bank_id` int(11) NOT NULL COMMENT '银行卡id',
  `content` text COMMENT '审核失败原因',
  `del_status` int(11) NOT NULL DEFAULT '0' COMMENT '删除属性',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `bank_id` (`bank_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1103 DEFAULT CHARSET=utf8mb4 COMMENT='提现记录';

#
# Structure for table "discount_record_sync"
#

DROP TABLE IF EXISTS `discount_record_sync`;
CREATE TABLE `discount_record_sync` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '红包同步id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `sync_time` int(11) NOT NULL DEFAULT '0' COMMENT '同步时间',
  `propelling_movement` text NOT NULL COMMENT '重推字段',
  `sync_status` int(4) NOT NULL COMMENT '同步状态',
  `sync_num` varchar(32) NOT NULL COMMENT '同步状态码',
  `sync_msg` varchar(255) NOT NULL COMMENT '同步状态信息',
  `is_show_button` int(11) NOT NULL DEFAULT '0' COMMENT '是否显示按钮 0显示 1不显示',
  `credit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '积分',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;

#
# Structure for table "exchanges"
#

DROP TABLE IF EXISTS `exchanges`;
CREATE TABLE `exchanges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '名称',
  `num` varchar(32) NOT NULL DEFAULT '' COMMENT '股票号码',
  `href` varchar(32) NOT NULL DEFAULT '' COMMENT '网址',
  `time` varchar(32) NOT NULL DEFAULT '' COMMENT '设置售卖时间',
  `places` varchar(32) NOT NULL DEFAULT '' COMMENT '设置售卖名额单日',
  `pdf` varchar(100) NOT NULL DEFAULT '' COMMENT '上传协议pdf路径',
  `company` varchar(32) NOT NULL DEFAULT '' COMMENT '公司',
  `pic` varchar(150) NOT NULL COMMENT '图片',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='交易所信息';

#
# Structure for table "filter_list"
#

DROP TABLE IF EXISTS `filter_list`;
CREATE TABLE `filter_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会员过滤id',
  `usernum` varchar(10) COLLATE utf8mb4_bin NOT NULL COMMENT '会员编号',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '会员标记 0未被使用 1已被使用 2预留 3删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `usernum` (`usernum`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=531442 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='会员过滤表';

#
# Structure for table "goods_attr_link"
#

DROP TABLE IF EXISTS `goods_attr_link`;
CREATE TABLE `goods_attr_link` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `link_colour` varchar(200) NOT NULL COMMENT '颜色',
  `link_pic` text NOT NULL COMMENT '属性图片',
  `link_sku` varchar(200) NOT NULL COMMENT '商品SKU',
  `total_num` int(11) unsigned NOT NULL COMMENT '虚拟库存（下单减）',
  `real_num` int(11) unsigned NOT NULL COMMENT '真实库存（发货减）  ',
  `link_price` decimal(11,2) NOT NULL COMMENT '商品单价',
  `virtual_sales` int(11) NOT NULL COMMENT '虚拟销量',
  `real_sales` int(11) NOT NULL COMMENT '真实销量',
  `status` int(11) NOT NULL COMMENT '状态1：正常 2：下架3：删除',
  `pic_text` text NOT NULL COMMENT '图文描述(优品汇商品)',
  `link_price_gray` decimal(12,2) NOT NULL COMMENT '原价',
  `link_weight` decimal(11,2) NOT NULL COMMENT '重量',
  `vip_price` decimal(11,2) NOT NULL COMMENT 'VIP 价格',
  `vip_date` int(11) NOT NULL COMMENT 'VIP 天数',
  PRIMARY KEY (`link_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `link_colour` (`link_colour`(191)) USING BTREE,
  KEY `link_price` (`link_price`) USING BTREE,
  KEY `virtual_sales` (`virtual_sales`) USING BTREE,
  KEY `real_sales` (`real_sales`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1464 DEFAULT CHARSET=utf8mb4 COMMENT='商品属性关联表';

#
# Structure for table "goods_attr_price"
#

DROP TABLE IF EXISTS `goods_attr_price`;
CREATE TABLE `goods_attr_price` (
  `goods_attr_id` int(8) NOT NULL AUTO_INCREMENT,
  `goods_id` int(8) NOT NULL COMMENT '商品ID',
  `link_id` int(11) NOT NULL,
  `attr_name` varchar(50) NOT NULL COMMENT '尺码',
  `attr_sku` char(50) NOT NULL COMMENT '商品sku',
  `attr_price` decimal(10,2) NOT NULL COMMENT '价格',
  `total_num` int(8) unsigned NOT NULL COMMENT '虚拟库存（下单减）',
  `real_num` int(11) unsigned NOT NULL COMMENT '真实库存（发货减）',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:上架 2：下架 3：删除',
  `attr_price_gray` char(50) NOT NULL COMMENT '原价',
  `attr_weight` decimal(11,2) NOT NULL COMMENT '重量',
  `attr_vip_price` decimal(11,2) NOT NULL COMMENT 'VIP 价格',
  `attr_vip_date` int(11) NOT NULL COMMENT 'VIP 天数',
  PRIMARY KEY (`goods_attr_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `attr_name` (`attr_name`) USING BTREE,
  KEY `attr_price` (`attr_price`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=420 DEFAULT CHARSET=utf8 COMMENT='商品属性';

#
# Structure for table "goods_base"
#

DROP TABLE IF EXISTS `goods_base`;
CREATE TABLE `goods_base` (
  `goods_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '商品名称',
  `short_intro` text COLLATE utf8_bin NOT NULL COMMENT '简短介绍',
  `cat_id` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '分类ID',
  `pic` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '图片',
  `small_pic` text COLLATE utf8_bin NOT NULL COMMENT '小图片',
  `pic_arr` text COLLATE utf8_bin NOT NULL COMMENT '批量图片',
  `goods_video` text COLLATE utf8_bin NOT NULL COMMENT '商品视频',
  `goods_video_cover` text COLLATE utf8_bin NOT NULL COMMENT '视频封面',
  `goods_compress` text COLLATE utf8_bin NOT NULL COMMENT '商品图片压缩',
  `goods_compress_pic` text COLLATE utf8_bin NOT NULL COMMENT '压缩图片列表',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `start_time` int(10) NOT NULL COMMENT '上架时间',
  `end_time` int(10) DEFAULT '0' COMMENT '有效期时间',
  `uptime` datetime DEFAULT NULL COMMENT '更新时间',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否上架  1：上架   2下架',
  `order` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1正常，2禁用，3 删除',
  `allow_multy` int(11) NOT NULL COMMENT '	是否允许营销活动并发 1：是 0：否',
  `rg_id` int(11) NOT NULL COMMENT '满减满赠活动id',
  `brand_id` int(11) NOT NULL COMMENT '品牌ID',
  `service_label_id` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '商品服务标签ID',
  `service_title` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '服务描述',
  `server_info` text COLLATE utf8_bin NOT NULL COMMENT '服务详情（生活圈用）',
  `buy_instruction` text COLLATE utf8_bin NOT NULL COMMENT '购买须知（生活圈用）',
  `real_sales` int(11) NOT NULL COMMENT '真实销量',
  `virtual_sales` int(11) NOT NULL COMMENT '虚拟销量',
  `self_label_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '自营标签',
  `service_des` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '服务描述',
  `is_seckill` tinyint(1) NOT NULL COMMENT '0 :自营 1:秒杀 2 优品汇 3生活圈',
  `now_price` decimal(11,2) NOT NULL COMMENT '商品现价（生活圈用）',
  `price` decimal(11,2) NOT NULL COMMENT '商品原价',
  `red_paper` decimal(10,2) NOT NULL,
  `shop_id` int(11) NOT NULL COMMENT '商家id',
  `reasons` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '下架原因',
  `delivery` char(50) COLLATE utf8_bin NOT NULL COMMENT '配送方式(优品汇用) 1 快递发货',
  `goods_freight` decimal(10,2) NOT NULL COMMENT '运费',
  `is_bear` int(11) NOT NULL COMMENT '卖家是否承担运费 1是 2否',
  `time_appointment` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '预约信息',
  `apply_member` int(11) NOT NULL COMMENT '适用人数',
  `change_deliver_fee` decimal(10,2) NOT NULL COMMENT '换货退回运费',
  `is_sync` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否同步过',
  `vip_style` int(11) NOT NULL COMMENT '0：正常商品（秒杀，生活圈，优品汇）1 VIP特权 2 VIP 专享 ',
  `is_new` int(11) NOT NULL COMMENT '2 不是新品推荐 1 是新品推荐',
  `is_recommend` int(11) NOT NULL COMMENT '是否是为你推荐 0否 1是',
  PRIMARY KEY (`goods_id`) USING BTREE,
  KEY `cat_id` (`cat_id`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `goods_name` (`goods_name`) USING BTREE,
  KEY `cat_id_2` (`cat_id`) USING BTREE,
  KEY `pic` (`pic`) USING BTREE,
  KEY `is_show_2` (`is_show`) USING BTREE,
  KEY `status_2` (`status`) USING BTREE,
  KEY `rg_id` (`rg_id`) USING BTREE,
  KEY `real_sales` (`real_sales`) USING BTREE,
  KEY `virtual_sales` (`virtual_sales`) USING BTREE,
  KEY `is_seckill` (`is_seckill`) USING BTREE,
  KEY `now_price` (`now_price`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1510 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品表';

#
# Structure for table "goods_cart"
#

DROP TABLE IF EXISTS `goods_cart`;
CREATE TABLE `goods_cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` int(11) NOT NULL COMMENT '1 自营 2 商铺',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `member_id` int(11) unsigned DEFAULT NULL COMMENT '会员ID',
  `goods_id` int(10) unsigned DEFAULT NULL COMMENT '商品ID',
  `link_id` int(11) NOT NULL COMMENT '商品一级属性ID',
  `goods_attr_id` int(4) NOT NULL DEFAULT '0' COMMENT '商品二级属性ID',
  `num` int(5) unsigned DEFAULT NULL COMMENT '数量',
  `checked` tinyint(1) NOT NULL COMMENT '购物车选中状态 1 选中 0 未选',
  `time` int(11) unsigned DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_attr_id` (`goods_attr_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5934 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='购物车';

#
# Structure for table "goods_coupons"
#

DROP TABLE IF EXISTS `goods_coupons`;
CREATE TABLE `goods_coupons` (
  `id` int(8) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `type` int(11) NOT NULL COMMENT '优惠券类型 1 自营 2 秒杀 3生活圈 4优品汇 5全站通用',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID （优惠券类型为商铺时有值）',
  `member_id` int(11) NOT NULL COMMENT '主播id',
  `live_id` int(11) NOT NULL COMMENT '直播间id',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '优惠券描述',
  `content` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '优惠券介绍',
  `pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '优惠券图片',
  `wordcolor` char(10) COLLATE utf8_bin NOT NULL COMMENT '优惠券文字颜色',
  `price` float NOT NULL COMMENT '价格',
  `limit_price` float NOT NULL COMMENT '优惠券使用限额',
  `add_time` int(10) NOT NULL COMMENT '添加时间',
  `time_type` tinyint(1) NOT NULL COMMENT '失效时间计算规则0.时间范围 2.领取时开始计算',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `expire_time` int(10) NOT NULL COMMENT '过期时间 过去时间类型为2时的时间长度(单位秒)',
  `num` int(8) NOT NULL COMMENT '优惠券个数',
  `max_have` int(8) NOT NULL DEFAULT '1' COMMENT '每人限领个数',
  `status` tinyint(1) NOT NULL COMMENT '1：正常  2：禁用 3：删除',
  `userID` int(8) NOT NULL COMMENT '所属用户ID',
  `goods_ids` char(200) CHARACTER SET utf8 NOT NULL COMMENT '关联商品id',
  `cate_ids` char(200) CHARACTER SET utf8 NOT NULL COMMENT '关联商品分类id',
  `pro_type` int(11) NOT NULL COMMENT '绑定活动类型',
  `is_home_page` tinyint(2) NOT NULL COMMENT '是否首页推荐 0否 1是',
  `is_show` int(11) NOT NULL DEFAULT '1' COMMENT '后台是否可见 1可见 0不可见',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `num` (`num`) USING BTREE,
  KEY `max_have` (`max_have`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='优惠券';

#
# Structure for table "goods_deliver"
#

DROP TABLE IF EXISTS `goods_deliver`;
CREATE TABLE `goods_deliver` (
  `deliver_id` int(11) NOT NULL AUTO_INCREMENT,
  `company` varchar(30) CHARACTER SET utf8 NOT NULL COMMENT '快递公司',
  `express_code` char(10) CHARACTER SET utf8 NOT NULL COMMENT '快递编码',
  `express_num` varchar(30) CHARACTER SET utf8 NOT NULL COMMENT '快递单号',
  `send_time` int(11) NOT NULL COMMENT '发货时间',
  `order_item_id` int(10) NOT NULL COMMENT '订单编号',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`deliver_id`) USING BTREE,
  UNIQUE KEY `order_item_id` (`order_item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品快递详情';

#
# Structure for table "goods_label"
#

DROP TABLE IF EXISTS `goods_label`;
CREATE TABLE `goods_label` (
  `label_id` int(11) NOT NULL AUTO_INCREMENT,
  `label_name` char(50) NOT NULL COMMENT '标签名称',
  `label_pic` text NOT NULL COMMENT '标签图片',
  `sort` int(11) NOT NULL COMMENT '排序',
  `status` tinyint(2) NOT NULL COMMENT '1:正常 2：禁用 3：删除',
  PRIMARY KEY (`label_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='商品标签表';

#
# Structure for table "goods_pro_relation"
#

DROP TABLE IF EXISTS `goods_pro_relation`;
CREATE TABLE `goods_pro_relation` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) NOT NULL COMMENT '商品id',
  `goods_attr_id` int(10) NOT NULL COMMENT '商品属性id',
  `act_id` int(10) NOT NULL COMMENT '活动id',
  `start_time` int(10) NOT NULL COMMENT '营销活动开始时间',
  `end_time` int(10) NOT NULL COMMENT '营销活动结束时间',
  `type` int(1) NOT NULL COMMENT '活动类型  0：无类型  1：秒杀  2：团购  3：预售  4：满减满赠  5：砍价  7：试吃   8：限时特价 21：线下满减满赠 22：线下限时特价',
  `price` decimal(10,2) NOT NULL COMMENT '活动价格',
  `num` int(10) NOT NULL COMMENT '活动中商品数量',
  `total_num` int(10) NOT NULL COMMENT '实际出售数量',
  `show_num` int(10) NOT NULL COMMENT '显示出售数量',
  `status` int(1) NOT NULL COMMENT '1:关联  0：取消',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `goods_attr_id` (`goods_attr_id`) USING BTREE,
  KEY `act_id` (`act_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品与所有营销活动关联表';

#
# Structure for table "goods_promotion"
#

DROP TABLE IF EXISTS `goods_promotion`;
CREATE TABLE `goods_promotion` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `name` char(50) NOT NULL COMMENT '活动名称',
  `start_time` int(10) NOT NULL COMMENT '活动开始时间',
  `end_time` int(10) NOT NULL COMMENT '活动结束时间',
  `pic` char(200) NOT NULL COMMENT '活动图片',
  `related_goods` varchar(200) NOT NULL COMMENT '关联主品ID',
  `sell_point` char(200) NOT NULL COMMENT '活动描述',
  `status` int(1) NOT NULL COMMENT '活动状态  1：开启  0：关闭  2：已删除',
  `type` int(1) NOT NULL COMMENT '活动类型  1：秒杀  2：团购  3：预售  4：满减满赠  5：砍价  6：分享  7：试吃  8：限时特价  21：线下满减满赠  22：线下限时特价  24：组合特价',
  `seckill_time` int(10) NOT NULL COMMENT '秒杀活动的预先显示时间',
  `rg_type` int(1) NOT NULL COMMENT '满减满赠类型 1：满减  2：满赠',
  `rg_limit` int(1) NOT NULL COMMENT '满减满赠限制类型1：限制金额  2：限制数量',
  `rg_limit_price` float NOT NULL COMMENT '满减满赠限制的金额',
  `rg_limit_num` int(10) NOT NULL COMMENT '满减满赠限制的数量',
  `rg_price` float NOT NULL COMMENT '满减金额',
  `rg_param` text NOT NULL COMMENT '满减阶梯设置',
  `rg_gift` varchar(255) NOT NULL COMMENT '满赠礼品信息',
  `sale_time` int(10) NOT NULL COMMENT '预售活动的预先显示时间',
  `share_limit` float NOT NULL COMMENT '分享活动限制金额',
  `share_money_id` int(10) NOT NULL COMMENT '分享活动赠送红包id',
  `share_coupon_id` int(10) NOT NULL COMMENT '分享活动赠送优惠券id',
  `lt_time` int(10) NOT NULL COMMENT '限时特价活动预先显示时间',
  `act_info` text NOT NULL COMMENT '活动说明',
  `cat_id` char(100) NOT NULL COMMENT '关联商品分类',
  `rel_type` tinyint(1) NOT NULL COMMENT '1：关联商品 2：关联商品分类',
  `max_num` int(11) NOT NULL COMMENT '最大领取数量',
  `cover_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1：覆盖城市  2：覆盖门店',
  `is_banner` int(11) NOT NULL COMMENT '是否显示banner',
  `storehouse_id` int(11) NOT NULL COMMENT '三方商家ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `related_goods` (`related_goods`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `rg_type` (`rg_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='商品营销优惠活动表';

#
# Structure for table "goods_reduce_give_relation"
#

DROP TABLE IF EXISTS `goods_reduce_give_relation`;
CREATE TABLE `goods_reduce_give_relation` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) NOT NULL COMMENT '商品id',
  `goods_attr_id` int(10) NOT NULL COMMENT '商品属性id',
  `rg_id` int(10) NOT NULL COMMENT '满减满赠活动id',
  `status` int(1) NOT NULL COMMENT '1：关联  0：取消',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `rg_id` (`rg_id`) USING BTREE,
  KEY `goods_attr_id` (`goods_attr_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品与满减满赠活动关联表';

#
# Structure for table "goods_special_link"
#

DROP TABLE IF EXISTS `goods_special_link`;
CREATE TABLE `goods_special_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_base_id` int(11) NOT NULL COMMENT '商品id',
  `goods_base_link_id` int(11) NOT NULL COMMENT '商品的link_id',
  `goods_id` int(11) NOT NULL COMMENT '秒杀商品id',
  `link_id` int(11) NOT NULL COMMENT '秒杀商品link-id',
  `goods_attr_id` int(11) NOT NULL COMMENT '秒杀商品attr_id',
  `num` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3 删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `goods_base_id` (`goods_base_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8mb4 COMMENT='营销商品';

#
# Structure for table "goods_visit_log"
#

DROP TABLE IF EXISTS `goods_visit_log`;
CREATE TABLE `goods_visit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户ID',
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `time` datetime NOT NULL COMMENT '访问时间',
  `sn` varchar(500) NOT NULL COMMENT 'SN码  一台设备一个',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺访问日志';

#
# Structure for table "group_id_list"
#

DROP TABLE IF EXISTS `group_id_list`;
CREATE TABLE `group_id_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `number` int(11) unsigned DEFAULT NULL COMMENT 'group_id 号码 ',
  `member_id` int(11) unsigned DEFAULT '0' COMMENT 'base_member 表member_id',
  `member_use` tinyint(1) unsigned DEFAULT '0' COMMENT '1已用 0未使用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_number` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=900001 DEFAULT CHARSET=utf8mb4 COMMENT='主播IM聊天组号表';

#
# Structure for table "hlb_log"
#

DROP TABLE IF EXISTS `hlb_log`;
CREATE TABLE `hlb_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
  `method` char(10) NOT NULL DEFAULT '' COMMENT '请求方式',
  `data` text NOT NULL COMMENT '请求数据',
  `response` varchar(255) NOT NULL DEFAULT '' COMMENT '响应结果',
  `error` varchar(255) NOT NULL DEFAULT '' COMMENT '错误信息',
  `header` text NOT NULL COMMENT '请求头',
  `user_agent` varchar(255) NOT NULL DEFAULT '' COMMENT 'USER_AGENT',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '请求时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=388 DEFAULT CHARSET=utf8mb4 COMMENT='合利宝请求';

#
# Structure for table "import_log"
#

DROP TABLE IF EXISTS `import_log`;
CREATE TABLE `import_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` varchar(100) NOT NULL DEFAULT '' COMMENT '编号',
  `admin_id` varchar(32) NOT NULL DEFAULT '' COMMENT '管理员',
  `message` varchar(32) NOT NULL DEFAULT '' COMMENT '内容',
  `memo` varchar(32) NOT NULL DEFAULT '' COMMENT '备注',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8mb4;

#
# Structure for table "jjpay_log"
#

DROP TABLE IF EXISTS `jjpay_log`;
CREATE TABLE `jjpay_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `msg` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4;

#
# Structure for table "jpush_log"
#

DROP TABLE IF EXISTS `jpush_log`;
CREATE TABLE `jpush_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `push_id` int(11) NOT NULL COMMENT '后台人工推送id',
  `push_act` varchar(10) NOT NULL,
  `jpush_id` varchar(100) NOT NULL,
  `push_time` datetime NOT NULL,
  `content` varchar(200) NOT NULL,
  `title` varchar(200) NOT NULL,
  `type` int(11) NOT NULL COMMENT '1：订单消息  2 交易物流 3 系统消息 4 活动消息 5 红包消息 6app消息',
  `push_data` text NOT NULL COMMENT '推送的跳转参数',
  `status` int(11) NOT NULL COMMENT '推送状态 0 未推送 1 推送成功 2 推送失败',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=278360 DEFAULT CHARSET=utf8 COMMENT='推送日志';

#
# Structure for table "life_circle_services"
#

DROP TABLE IF EXISTS `life_circle_services`;
CREATE TABLE `life_circle_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `services` text NOT NULL COMMENT '服务描述',
  `type` tinyint(2) NOT NULL COMMENT '1图片 2详情',
  `status` tinyint(2) NOT NULL COMMENT '1:正常 2：删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb4 COMMENT='生活圈商品服务详情';

#
# Structure for table "live_about_log"
#

DROP TABLE IF EXISTS `live_about_log`;
CREATE TABLE `live_about_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `live_id` int(11) NOT NULL,
  `promotion_id` int(11) NOT NULL,
  `add_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播上报日志';

#
# Structure for table "lucky_draw"
#

DROP TABLE IF EXISTS `lucky_draw`;
CREATE TABLE `lucky_draw` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '抽奖id',
  `title` varchar(255) NOT NULL COMMENT '抽奖名称',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '结束时间',
  `coefficient` varchar(20) NOT NULL DEFAULT '1' COMMENT '红包系数',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '活动创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 活动正常 2 活动禁用 3 活动删除',
  `content` text NOT NULL COMMENT '抽奖说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='幸运抽奖';

#
# Structure for table "lucky_draw_link"
#

DROP TABLE IF EXISTS `lucky_draw_link`;
CREATE TABLE `lucky_draw_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '次数id',
  `lid` int(11) NOT NULL DEFAULT '0' COMMENT '抽奖id',
  `start_int` int(11) NOT NULL DEFAULT '0' COMMENT '开始积分',
  `end_int` int(11) NOT NULL DEFAULT '0' COMMENT '结束积分',
  `num` smallint(5) NOT NULL DEFAULT '0' COMMENT '抽奖次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COMMENT='抽奖次数id';

#
# Structure for table "member_address"
#

DROP TABLE IF EXISTS `member_address`;
CREATE TABLE `member_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) unsigned NOT NULL COMMENT '会员ID',
  `name` varchar(40) COLLATE utf8_bin NOT NULL COMMENT '联系人',
  `provinceid` int(11) NOT NULL COMMENT '省ID',
  `cityid` int(11) NOT NULL COMMENT '市ID',
  `areaid` int(11) NOT NULL COMMENT '区ID',
  `area` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '省市区',
  `address` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '地址',
  `zip` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '邮编',
  `tel` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '电话',
  `mobile` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '手机',
  `default` tinyint(1) DEFAULT '0' COMMENT '是否默认   1是  0否',
  `label` tinyint(1) NOT NULL DEFAULT '1' COMMENT '标签：1.家 2.公司 3.学校 4.⻔店',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=33246 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='收货地址表';

#
# Structure for table "member_anchor_fav"
#

DROP TABLE IF EXISTS `member_anchor_fav`;
CREATE TABLE `member_anchor_fav` (
  `fav_id` int(11) NOT NULL AUTO_INCREMENT,
  `anchor_id` int(11) NOT NULL COMMENT '主播id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`fav_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='主播关注表';

#
# Structure for table "member_buy_give_money"
#

DROP TABLE IF EXISTS `member_buy_give_money`;
CREATE TABLE `member_buy_give_money` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '邀请者id',
  `buy_member_id` int(10) NOT NULL COMMENT '购买者id',
  `order_id` int(10) NOT NULL COMMENT '订单id',
  `type` tinyint(1) NOT NULL COMMENT '购买类型 1：秒杀 2：自营 3：优品汇 4：生活圈',
  `goods_num` int(10) NOT NULL COMMENT '购买商品数',
  `give_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送红包',
  `add_time` int(10) NOT NULL COMMENT '赠送时间',
  `is_range` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 是否在名额之内 2 不在名额之内',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `buy_member_id` (`buy_member_id`) USING BTREE,
  KEY `give_money` (`give_money`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COMMENT='会员购买赠送红包记录表';

#
# Structure for table "member_cash_coupon"
#

DROP TABLE IF EXISTS `member_cash_coupon`;
CREATE TABLE `member_cash_coupon` (
  `ca_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `amount` decimal(11,2) NOT NULL COMMENT '金额',
  `limit_price` decimal(11,2) NOT NULL COMMENT '门槛',
  `improt_time` datetime NOT NULL COMMENT '导入时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3删除 ',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  PRIMARY KEY (`ca_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户可用现金券';

#
# Structure for table "member_coupons"
#

DROP TABLE IF EXISTS `member_coupons`;
CREATE TABLE `member_coupons` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `coupon_id` int(10) NOT NULL COMMENT '优惠券ID',
  `coupon_no` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '优惠券编号',
  `use_time` int(10) NOT NULL DEFAULT '0' COMMENT '使用时间',
  `get_time` int(11) NOT NULL COMMENT '领取时间',
  `use_exp_time` int(11) NOT NULL COMMENT '使用过期时间',
  `status` tinyint(1) NOT NULL COMMENT '0：已生成  1：已领取  2：已使用  3：已删除',
  `oid` int(4) NOT NULL COMMENT '订单ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='会员优惠券';

#
# Structure for table "member_fav"
#

DROP TABLE IF EXISTS `member_fav`;
CREATE TABLE `member_fav` (
  `fav_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '收藏表',
  `fav_type` int(11) NOT NULL COMMENT '1 自营商品 2 优品汇商品 3 生活圈服务',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `goods_id` int(10) NOT NULL COMMENT '商品ID',
  `promotions_id` int(11) NOT NULL COMMENT '活动ID',
  `promotions_type` int(11) NOT NULL COMMENT '活动类型',
  `add_time` int(10) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`fav_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `fav_type` (`fav_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='会员收藏表';

#
# Structure for table "member_fund"
#

DROP TABLE IF EXISTS `member_fund`;
CREATE TABLE `member_fund` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `fund` decimal(15,2) NOT NULL COMMENT '余额',
  `give_fund` decimal(15,2) NOT NULL COMMENT '当前余额中包含的赠送金额',
  `share_code_amount` int(11) NOT NULL COMMENT '分享码数量',
  `grand_total_fund` decimal(10,2) NOT NULL COMMENT '累计充值',
  `blocked_fund` decimal(15,2) NOT NULL,
  `point` int(11) NOT NULL COMMENT '积分',
  `consume_fund` decimal(15,2) NOT NULL COMMENT '消费金额',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `fund` (`fund`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3601021 DEFAULT CHARSET=utf8 COMMENT='用户红包/分享码';

#
# Structure for table "member_fund_old"
#

DROP TABLE IF EXISTS `member_fund_old`;
CREATE TABLE `member_fund_old` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `fund` decimal(15,2) NOT NULL COMMENT '余额',
  `give_fund` decimal(15,2) NOT NULL COMMENT '当前余额中包含的赠送金额',
  `share_code_amount` int(11) NOT NULL COMMENT '分享码数量',
  `grand_total_fund` decimal(10,2) NOT NULL COMMENT '累计充值',
  `blocked_fund` decimal(15,2) NOT NULL,
  `point` int(11) NOT NULL COMMENT '积分',
  `consume_fund` decimal(15,2) NOT NULL COMMENT '消费金额',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户红包/分享码';

#
# Structure for table "member_fund_share"
#

DROP TABLE IF EXISTS `member_fund_share`;
CREATE TABLE `member_fund_share` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `fund` decimal(15,2) DEFAULT NULL COMMENT '余额',
  `give_fund` decimal(15,2) DEFAULT NULL COMMENT '当前余额中包含的赠送金额',
  `share_code_amount` int(11) DEFAULT NULL COMMENT '分享码数量',
  `grand_total_fund` decimal(10,2) DEFAULT NULL COMMENT '累计充值',
  `blocked_fund` decimal(15,2) DEFAULT NULL,
  `point` int(11) DEFAULT NULL COMMENT '积分',
  `consume_fund` decimal(15,2) DEFAULT NULL COMMENT '消费金额',
  `share_url` varchar(255) DEFAULT NULL COMMENT 'qrcode未处理的原图',
  `param` text COMMENT 'qrcode中的参数',
  `share_full_url` varchar(255) DEFAULT NULL COMMENT '处理过后的qrcode',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `fund` (`fund`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=361147 DEFAULT CHARSET=utf8 COMMENT='用户红包/分享码';

#
# Structure for table "member_invite_log"
#

DROP TABLE IF EXISTS `member_invite_log`;
CREATE TABLE `member_invite_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '被邀请者id',
  `invite_mid` int(10) NOT NULL COMMENT '邀请者id',
  `add_time` int(10) NOT NULL COMMENT '邀请时间',
  `is_range` int(11) NOT NULL COMMENT '是否在范围内 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `invite_mid` (`invite_mid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=334538 DEFAULT CHARSET=utf8mb4 COMMENT='会员邀请记录表';

#
# Structure for table "member_invite_log_old"
#

DROP TABLE IF EXISTS `member_invite_log_old`;
CREATE TABLE `member_invite_log_old` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '被邀请者id',
  `invite_mid` int(10) NOT NULL COMMENT '邀请者id',
  `add_time` int(10) NOT NULL COMMENT '邀请时间',
  `is_range` int(11) NOT NULL COMMENT '是否在范围内 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `invite_mid` (`invite_mid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COMMENT='会员邀请记录表';

#
# Structure for table "member_invoice"
#

DROP TABLE IF EXISTS `member_invoice`;
CREATE TABLE `member_invoice` (
  `invoice_id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_company` varchar(255) NOT NULL COMMENT '单位名称',
  `invoice_identifier` varchar(100) NOT NULL COMMENT '识别号',
  `invoice_address` varchar(500) NOT NULL COMMENT '注册地址',
  `invoice_phone` varchar(20) NOT NULL COMMENT '注册电话',
  `invoice_bank` varchar(100) NOT NULL COMMENT '开户银行',
  `invoice_account` varchar(50) NOT NULL COMMENT '银行账号',
  `c_time` int(10) NOT NULL COMMENT '添加时间',
  `member_id` int(10) NOT NULL COMMENT '会员id',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 2删除',
  `is_checked` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 未被选中 2 被选中',
  PRIMARY KEY (`invoice_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `invoice_company` (`invoice_company`(191)) USING BTREE,
  KEY `is_checked` (`is_checked`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='会员发票信息数据表';

#
# Structure for table "member_jpush_list"
#

DROP TABLE IF EXISTS `member_jpush_list`;
CREATE TABLE `member_jpush_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `jpush_id` varchar(200) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `jpush_id` (`jpush_id`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=142159 DEFAULT CHARSET=utf8mb4 COMMENT='会员jpush列表';

#
# Structure for table "member_real_name_auth"
#

DROP TABLE IF EXISTS `member_real_name_auth`;
CREATE TABLE `member_real_name_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `real_name` varchar(10) NOT NULL COMMENT '用户真名',
  `card` varchar(30) NOT NULL COMMENT '身份证号',
  `card_first` varchar(300) NOT NULL COMMENT '身份证正面图',
  `card_last` varchar(300) NOT NULL COMMENT '身份证反面图',
  `time` int(11) NOT NULL COMMENT '申请时间',
  `status` int(11) NOT NULL COMMENT '0 未审核 1 审核通过 2 审核驳回',
  `reason` varchar(300) NOT NULL COMMENT '驳回原因',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员实名认证';

#
# Structure for table "member_share_qrcode"
#

DROP TABLE IF EXISTS `member_share_qrcode`;
CREATE TABLE `member_share_qrcode` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '会员id',
  `qrcode_url` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '会员推广码链接',
  `invite_code` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '会员邀请码',
  `add_time` int(10) NOT NULL COMMENT '添加时间',
  `expire_time` int(10) NOT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `qrcode_url` (`qrcode_url`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=61865 DEFAULT CHARSET=utf8mb4 COMMENT='会员推广码表';

#
# Structure for table "member_shop_fav"
#

DROP TABLE IF EXISTS `member_shop_fav`;
CREATE TABLE `member_shop_fav` (
  `fav_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '收藏表',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `shop_id` int(10) NOT NULL COMMENT '店铺ID',
  `type` int(11) NOT NULL COMMENT '类型 1 优品汇店铺 2 生活圈店铺',
  `add_time` int(10) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`fav_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='会员收藏表';

#
# Structure for table "member_sync_log"
#

DROP TABLE IF EXISTS `member_sync_log`;
CREATE TABLE `member_sync_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '同步id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '同步类型 0用户同步 1用户状态同步',
  `sync_time` int(11) NOT NULL DEFAULT '0' COMMENT '同步时间',
  `propelling_movement` text NOT NULL COMMENT '重推字段',
  `sync_status` int(4) NOT NULL COMMENT '同步状态',
  `sync_num` varchar(32) NOT NULL COMMENT '同步状态码',
  `sync_msg` varchar(255) NOT NULL COMMENT '同步状态信息',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Structure for table "member_task"
#

DROP TABLE IF EXISTS `member_task`;
CREATE TABLE `member_task` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0',
  `yes` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `month` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `day` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `today_people` int(11) NOT NULL DEFAULT '0' COMMENT '今日开通',
  `today_integral` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '今日收益',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '当天时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=828565 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务表';

#
# Structure for table "msg_info"
#

DROP TABLE IF EXISTS `msg_info`;
CREATE TABLE `msg_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `push_id` int(11) NOT NULL COMMENT '后台人工推送id',
  `type` int(11) NOT NULL COMMENT '消息类型 1 订单消息（通知卖家） 2 交易物流 （通知买家）3 系统消息 4活动信息 5 红包消息 6app推送 7粉丝关注 8账户通知 9商家评价 \\r \\n60 佣金消息  --liuyang',
  `type_s` int(20) NOT NULL COMMENT '消息子类型 1-1 新订单 1-2 订单已完成 1-3 新退款申请 1-4 退款已完成  1-7 换货申请 1-8 换货已完成 ',
  `link_id` int(11) NOT NULL COMMENT '关联ID',
  `title` varchar(200) NOT NULL COMMENT '后台自定义消息标题',
  `content` text NOT NULL COMMENT '内容',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `check_time` int(11) NOT NULL DEFAULT '0' COMMENT '查看时间',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1 正常 2 禁用 3 删除',
  `redirect_url` varchar(255) DEFAULT NULL COMMENT '增加app推送信息',
  `v2` int(1) unsigned DEFAULT '1' COMMENT '是否为新版本',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `type_s` (`type_s`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10692350 DEFAULT CHARSET=utf8mb4 COMMENT='站内信消息';

#
# Structure for table "msg_status_log"
#

DROP TABLE IF EXISTS `msg_status_log`;
CREATE TABLE `msg_status_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `msg_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'msg_info表主键',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态 1已读 2删除',
  PRIMARY KEY (`id`),
  KEY `idx_msg_id_member_id` (`msg_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COMMENT='推送消息状态表';

#
# Structure for table "newbie_guide"
#

DROP TABLE IF EXISTS `newbie_guide`;
CREATE TABLE `newbie_guide` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` char(20) NOT NULL COMMENT '标题',
  `cover_image` char(200) NOT NULL COMMENT '封面图',
  `content` text NOT NULL COMMENT '内容',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COMMENT='新手指引';

#
# Structure for table "operation_log"
#

DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log` (
  `LogIdentity` int(11) NOT NULL AUTO_INCREMENT,
  `LogType` tinyint(4) NOT NULL COMMENT '类型：添加1，删除2，更新3  分享 4',
  `LogModule` tinyint(4) NOT NULL COMMENT '1 商品管理 2 商家管理 3 订单管理 4 会员管理  5 直播管理  6 营销管理 7 对账管理 8 文章管理 9 评论管理 10 广告管理 11 系统设置  12 活动消息 13 红包提现 14 店铺提现 15 数据分析 16 系统角色',
  `DataID` varchar(200) DEFAULT '0' COMMENT '操作数据ID，逗号分割',
  `LogLinkID` varchar(200) NOT NULL,
  `LogUser` int(11) NOT NULL COMMENT '操作人',
  `LogRemark` varchar(500) NOT NULL COMMENT '备注',
  `LogTime` int(11) NOT NULL COMMENT '操作时间',
  `type` int(1) DEFAULT '0' COMMENT '0 总后台日志',
  PRIMARY KEY (`LogIdentity`) USING BTREE,
  KEY `LogType` (`LogType`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=21666 DEFAULT CHARSET=utf8 COMMENT='操作日志';

#
# Structure for table "order_base"
#

DROP TABLE IF EXISTS `order_base`;
CREATE TABLE `order_base` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_type` tinyint(2) NOT NULL COMMENT '订单类型1自营  2优品汇 3生活圈  4 新人商品 12 秒杀 11 助农 ',
  `shop_id` int(11) NOT NULL COMMENT '店铺id',
  `room_id` int(11) NOT NULL COMMENT '直播间ID',
  `anchor_id` int(11) NOT NULL COMMENT '直播ID',
  `member_id` int(11) unsigned DEFAULT '0' COMMENT '会员ID',
  `order_no` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '订单编号',
  `total_price` decimal(10,2) DEFAULT NULL COMMENT '订单总费用',
  `total_point` int(11) NOT NULL COMMENT '订单总积分',
  `original_totle_price` float(10,2) NOT NULL COMMENT '订单原来价格',
  `weixin_pay` decimal(12,2) NOT NULL COMMENT '微信支付金额  线下订单第一种支付方式',
  `alipay` decimal(12,2) NOT NULL COMMENT '支付宝支付金额   线下订单第二种支付方式',
  `union_pay` decimal(12,2) NOT NULL COMMENT '银联支付',
  `pay_type` tinyint(4) NOT NULL COMMENT '支付方式  1支付宝 2 微信  3  余额支付 11合利宝',
  `order_time` int(15) unsigned DEFAULT NULL COMMENT '下单时间',
  `order_status` tinyint(1) NOT NULL COMMENT '定单状态 1生成 2取消 3过期 4处理中 5已完成',
  `deliver_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '配送方式： 0自取  1快递',
  `deliver_fee` float(5,2) NOT NULL DEFAULT '0.00' COMMENT '快递费用',
  `deliver_time` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '配送时间',
  `deliver_company` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '快递公司',
  `deliver_no` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '快递单号',
  `finish_time` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '完成时间',
  `member_coupon_id` char(20) COLLATE utf8_bin NOT NULL COMMENT '优惠券id',
  `pay_time` int(15) unsigned DEFAULT '0' COMMENT '付款时间',
  `pay_status` int(1) DEFAULT '0' COMMENT '支付状态0未支付 1已支付 ',
  `sign_for_status` int(11) NOT NULL COMMENT '签收状态 0 未签收 1 已签收 2 退签 3 退回',
  `shipping_status` int(1) NOT NULL DEFAULT '0' COMMENT '物流状态 0未发货 1已发货 2收获确认 ',
  `refund_status` int(11) NOT NULL COMMENT '退单表状态 1待处理  2退货中  3换货中  4已完成   5已拒绝',
  `shipping_time` int(15) NOT NULL COMMENT '发货时间',
  `sign_for_time` int(11) NOT NULL COMMENT '签收时间',
  `end_time` int(11) NOT NULL COMMENT '确认收货时间',
  `s_name` varchar(40) COLLATE utf8_bin NOT NULL COMMENT '收货联系人',
  `s_province` varchar(60) COLLATE utf8_bin NOT NULL COMMENT '省',
  `s_city` varchar(60) COLLATE utf8_bin NOT NULL COMMENT '市',
  `s_area` varchar(60) COLLATE utf8_bin NOT NULL COMMENT '区',
  `s_zip` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '邮编',
  `address` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '地址',
  `s_tel` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '电话',
  `invoice_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发票类型 0不要发票 1个人 2公司',
  `invoice_content` char(50) COLLATE utf8_bin NOT NULL COMMENT '发票内容',
  `invoice_company` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '公司名称',
  `invoice_identifier` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '纳税人识别号',
  `invoice_phone` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT '注册电话',
  `invoice_address` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '注册地址',
  `invoice_bank` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '开户行',
  `invoice_account` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '银行账号',
  `updateTime` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `order_remark` text COLLATE utf8_bin NOT NULL COMMENT '备注信息',
  `rg_price` decimal(10,2) NOT NULL COMMENT '满减金额',
  `coupon_fee` decimal(10,2) NOT NULL COMMENT '优惠券低值',
  `share_fund` decimal(10,2) NOT NULL COMMENT '分享红包抵扣',
  `already_comment` int(11) NOT NULL COMMENT '是否评论 0 否1 是',
  `invoice_id` int(11) NOT NULL COMMENT '发票ID',
  `write_off_code` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '生活圈核销码',
  `activity_json` text COLLATE utf8_bin NOT NULL COMMENT '活动 json  rel_type：1商品 2分类   pre_type  1满减 2优惠券  cut_price  金额',
  `promotion_id` int(11) NOT NULL COMMENT '营销活动ID',
  `promotion_type` tinyint(2) NOT NULL COMMENT '1直播秒杀 2pk秒杀',
  `user_del` int(11) NOT NULL COMMENT '用户是否删除订单 0 否 1 是',
  `buyer_is_read` int(11) NOT NULL COMMENT '买家是否已读 0  未读  1  已读',
  `seller_is_read` int(11) NOT NULL COMMENT '卖家是否已读 0  未读  1  已读',
  `is_get_deliver` int(11) NOT NULL COMMENT '秒杀订单是否请求过物流接口 0 否 1 是',
  `is_all_refund` int(11) NOT NULL COMMENT '是否全部商品退款 0 否 1 是',
  `seller_all_read` int(11) NOT NULL COMMENT '卖家是否全部已读 0 否 1 是',
  `is_batch_send` int(11) NOT NULL COMMENT '是否批量发货 0 否 1 是',
  `batch_send_fail` varchar(200) COLLATE utf8_bin NOT NULL,
  `is_sync_order` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否同步过 0 未同步 1 已同步',
  `order_vip_date` int(11) NOT NULL COMMENT '成为VIP的天数',
  `order_is_vip` int(11) NOT NULL COMMENT '0 否 1是',
  `is_special` int(11) NOT NULL COMMENT '是否专柜 0 否 1是',
  `special_type` int(11) NOT NULL COMMENT '1 Vip特权 2 Vip专享 0 正常',
  `is_notice_no_pay` tinyint(4) NOT NULL COMMENT '是否提示未支付 0 否 1 是',
  `veri_status` tinyint(2) NOT NULL COMMENT '0:默认 1 验证中 2 验证通过',
  `cancel_order_time` datetime NOT NULL COMMENT '订单取消时间',
  `coupons_id` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '优惠券活动id集合（新增）',
  `gift_id` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '满赠活动id集合（新增）',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '新版订单状态 1：待付款 2：待发货 3：已发货 4：待评价 5：已完成 6：已关闭',
  `v` int(1) DEFAULT NULL COMMENT '订单版本号： 2：v2版订单',
  `goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '购买商品数量',
  `member_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '买家用户帐号',
  `shop_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '店铺名称',
  `invoice_status` int(1) NOT NULL DEFAULT '0' COMMENT '开发票状态 1：待开票  2：已开票  3：已关闭',
  `invoice_remark` text COLLATE utf8_bin COMMENT '发票备注',
  `real_price` decimal(10,2) DEFAULT NULL COMMENT '订单最终的真实价格',
  `real_sku_sales` int(10) DEFAULT NULL COMMENT 'sku真实销量',
  `real_deliver_fee` decimal(10,2) DEFAULT NULL COMMENT '订单最终的真实运费',
  `del` int(1) NOT NULL DEFAULT '0' COMMENT '订单删除状态  1已删除',
  `comment_time` int(10) DEFAULT NULL COMMENT '评论时间',
  `order_text` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '订单备注（下单时用户提交）',
  `parent_order_no` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '调支付总订单号',
  `deliver_com` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '快递公司编码,一律用小写字母',
  `deliver_serial_no` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '发货单流水号',
  `provinceid` int(10) DEFAULT '0' COMMENT '省份ID',
  `cityid` int(10) DEFAULT '0' COMMENT '城市ID',
  `areaid` int(10) DEFAULT '0' COMMENT '地区ID',
  `reconciliation_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '对账状态',
  `total_woman_price` decimal(10,2) NOT NULL COMMENT '余额订单总费用',
  `original_totle_woman_price` decimal(10,2) NOT NULL COMMENT '余额支付订单原来价格',
  `return_credit` tinyint(1) NOT NULL DEFAULT '1' COMMENT '扣回积分1否  2是',
  `opening` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开通小助手 1是 ',
  `type` tinyint(1) DEFAULT '0' COMMENT '0 old 1开通 2升级 小助手订单类型',
  `shareholder` tinyint(1) DEFAULT '1' COMMENT '股东续费标识 1否2是 ',
  `level` tinyint(1) NOT NULL DEFAULT '0',
  `periods` tinyint(1) DEFAULT '0' COMMENT '第几期',
  `hlb_order_no` char(24) COLLATE utf8_bin DEFAULT '' COMMENT '合利宝订单号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `room_id` (`room_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `order_status` (`order_status`) USING BTREE,
  KEY `pay_status` (`pay_status`) USING BTREE,
  KEY `shipping_status` (`shipping_status`) USING BTREE,
  KEY `refund_status` (`refund_status`) USING BTREE,
  KEY `buyer_is_read` (`buyer_is_read`) USING BTREE,
  KEY `seller_is_read` (`seller_is_read`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `v` (`v`) USING BTREE,
  KEY `del` (`del`) USING BTREE,
  KEY `parent_order_no` (`parent_order_no`) USING BTREE,
  KEY `reconciliation_status` (`reconciliation_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6455 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='订单表';

#
# Structure for table "order_item"
#

DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id` int(10) DEFAULT NULL COMMENT '订单ID',
  `goods_id` int(11) unsigned DEFAULT NULL COMMENT '商品ID',
  `link_id` int(11) NOT NULL COMMENT '一级属性ID',
  `goods_attr_id` int(4) NOT NULL DEFAULT '0' COMMENT '价格属性ID',
  `item_type` tinyint(1) NOT NULL COMMENT '1赠品 0正常',
  `code` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '商品SKU',
  `goods_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '商品名称',
  `pic` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '产品图片',
  `price` decimal(10,2) unsigned DEFAULT NULL COMMENT '订单商品总价格',
  `attr_price` decimal(10,2) NOT NULL COMMENT '单品价格',
  `goods_costing` decimal(10,2) NOT NULL COMMENT '单个商品成本',
  `point` int(11) NOT NULL COMMENT '积分',
  `num` int(5) unsigned DEFAULT NULL COMMENT '数量',
  `remark` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '留言',
  `deliver_id` int(4) NOT NULL COMMENT '快递公司ID',
  `deliver_fee` decimal(4,2) NOT NULL COMMENT '运费',
  `buyer_comment` tinyint(1) NOT NULL DEFAULT '0' COMMENT '买家是否评论',
  `seller_comment` tinyint(1) NOT NULL DEFAULT '0' COMMENT '卖家是否评论',
  `already_comment` tinyint(1) NOT NULL COMMENT '是否已经评论  0：未评论 1：已评论',
  `promotion_id` int(10) NOT NULL COMMENT '营销活动id',
  `promotion_type` tinyint(1) NOT NULL COMMENT '营销活动类型  1：秒杀  2：团购  3：预售  4：满减满赠  5：砍价  7：试吃   8：限时特价',
  `return_goods_status` int(11) NOT NULL COMMENT '1 申请退款中 （生活圈只退款 正常订单退货退款）2 退款成功 3 退款失败  4 申请换货中  5 换货成功 6 换货失败',
  `user_del_item` int(11) NOT NULL COMMENT '是否删除  1  已删除  （退货列表用）',
  `brand_id` int(10) DEFAULT '0' COMMENT '品牌ID(新增)',
  `freight_id` int(10) DEFAULT NULL COMMENT '运费模版ID',
  `commission` decimal(10,2) DEFAULT NULL COMMENT '佣金(新增)',
  `live_commission` decimal(10,2) DEFAULT NULL COMMENT '直播佣金比例',
  `share` decimal(10,2) DEFAULT NULL COMMENT '分享佣金比例',
  `one` decimal(10,2) DEFAULT NULL,
  `two` decimal(10,2) DEFAULT NULL,
  `three` decimal(10,2) DEFAULT NULL,
  `four` decimal(10,2) DEFAULT NULL,
  `five` decimal(10,2) DEFAULT NULL,
  `six` decimal(10,2) DEFAULT NULL,
  `seven` decimal(10,2) DEFAULT NULL,
  `eight` decimal(10,2) DEFAULT NULL,
  `nine` decimal(10,2) DEFAULT NULL,
  `ten` decimal(10,2) DEFAULT NULL,
  `eleven` decimal(10,2) DEFAULT NULL,
  `twelve` decimal(10,2) DEFAULT NULL,
  `live_commission_v2` decimal(10,2) DEFAULT NULL COMMENT '直播佣金  v2',
  `goods_commission` decimal(10,2) DEFAULT NULL COMMENT '商品佣金',
  `link_info` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '属性详细',
  `live_id` int(10) DEFAULT '0' COMMENT '直播ID',
  `source_live_status` int(10) DEFAULT '0' COMMENT '直播状态来源：1.直播中 2.结束 3.未开始 4.过期',
  `live_room_id` int(10) DEFAULT '0' COMMENT '直播间ID',
  `anchor_id` int(10) DEFAULT '0' COMMENT '直播ID',
  `member_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `total_price` decimal(10,2) DEFAULT NULL COMMENT '商品订单价钱',
  `Version_No` int(10) DEFAULT '1' COMMENT '版本号',
  `ad_id` int(10) DEFAULT '0' COMMENT '广告位ID',
  `ad_type` int(1) DEFAULT '0' COMMENT '广告位   1 探索发现  2 多功能推送   3 商品推送   4 Banner',
  `order_time` int(10) DEFAULT NULL COMMENT '下单时间',
  `reconciliation_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '对账状态',
  `woman_price` decimal(10,2) NOT NULL COMMENT '余额支付单价',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id` (`order_id`,`goods_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `goods_attr_id` (`goods_attr_id`) USING BTREE,
  KEY `user_del_item` (`user_del_item`) USING BTREE,
  KEY `return_goods_status` (`return_goods_status`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `source_live_status` (`source_live_status`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `reconciliation_status` (`reconciliation_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2595 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='订单子表';

#
# Structure for table "order_log"
#

DROP TABLE IF EXISTS `order_log`;
CREATE TABLE `order_log` (
  `log_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `wms_log_id` int(10) NOT NULL COMMENT 'wms 日志LOGid',
  `order_no` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '订单号',
  `wms_oid` int(10) NOT NULL DEFAULT '0',
  `status` int(2) NOT NULL,
  `mark` int(1) NOT NULL COMMENT '1:订单状态; 2:付款状态; 3:发货状态; 0:备注信息',
  `updateTime` datetime NOT NULL,
  `updateUser` varchar(100) COLLATE utf8_bin NOT NULL,
  `remark` varchar(255) COLLATE utf8_bin NOT NULL,
  `success` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否同步成功',
  PRIMARY KEY (`log_id`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='wms订单日志操作记录表';

#
# Structure for table "order_return_pay"
#

DROP TABLE IF EXISTS `order_return_pay`;
CREATE TABLE `order_return_pay` (
  `return_id` int(11) NOT NULL AUTO_INCREMENT,
  `return_goods_id` int(11) NOT NULL COMMENT '退换货记录id',
  `price` decimal(10,2) NOT NULL COMMENT '退换货金额',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `pay_status` tinyint(1) NOT NULL COMMENT '支付状态 1 是 0 否',
  `pay_time` int(11) NOT NULL COMMENT '支付时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`return_id`) USING BTREE,
  KEY `return_goods_id` (`return_goods_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退换货记录';

#
# Structure for table "order_sync_log"
#

DROP TABLE IF EXISTS `order_sync_log`;
CREATE TABLE `order_sync_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单同步log id',
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `sync_status` int(4) NOT NULL COMMENT '同步状态',
  `sync_num` varchar(32) NOT NULL COMMENT '同步状态码',
  `sync_msg` varchar(255) NOT NULL COMMENT '同步状态信息',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '同步类型 0订单同步1订单状态同步',
  `sync_time` int(11) NOT NULL DEFAULT '0' COMMENT '同步时间',
  `propelling_movement` text NOT NULL COMMENT '重推字段',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_no` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单同步log';

#
# Structure for table "pay_log"
#

DROP TABLE IF EXISTS `pay_log`;
CREATE TABLE `pay_log` (
  `pay_id` int(11) NOT NULL AUTO_INCREMENT,
  `oid` varchar(10000) COLLATE utf8_bin NOT NULL,
  `return_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `pay_type_id` int(11) NOT NULL COMMENT '支付类型 1 支付宝 2 微信 3 银联',
  `tail_pay` tinyint(4) NOT NULL COMMENT '1.支付尾款',
  `pay_No` varchar(200) COLLATE utf8_bin NOT NULL,
  `parent_order_no` varchar(32) COLLATE utf8_bin NOT NULL DEFAULT '',
  `check_no` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '验证单号（订单号或随机生成单号）',
  `uid` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL COMMENT '充值金额',
  `real_amount` decimal(15,2) NOT NULL COMMENT '实际支付金额',
  `refund` decimal(12,2) NOT NULL COMMENT '退款金额',
  `update_time` datetime NOT NULL,
  `pay_date` datetime NOT NULL,
  `trade_no` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '商户交易号',
  `status` tinyint(1) NOT NULL COMMENT '0未支付 1已支付',
  `admin_id` int(11) NOT NULL COMMENT '登录用户id',
  `give_amount` decimal(10,2) NOT NULL COMMENT '赠送金额',
  `recharge_json` char(200) COLLATE utf8_bin NOT NULL COMMENT '充值档位json',
  `sales_admin_id` int(11) NOT NULL COMMENT '销售员',
  `member_mflog_id` int(11) NOT NULL COMMENT '关联线下充值记录表',
  `contrast_json_before` text COLLATE utf8_bin NOT NULL COMMENT '充值前json',
  `contrast_json_after` text COLLATE utf8_bin NOT NULL COMMENT '充值后json',
  `prepay_id` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '微信支付ID',
  `union_json_data` text COLLATE utf8_bin NOT NULL COMMENT '银联支付请求数据',
  `union_return_data` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`pay_id`) USING BTREE,
  KEY `oid` (`oid`(255)) USING BTREE,
  KEY `return_id` (`return_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `pay_type_id` (`pay_type_id`) USING BTREE,
  KEY `pay_No` (`pay_No`) USING BTREE,
  KEY `parent_order_no` (`parent_order_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=131826 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='支付记录';

#
# Structure for table "pay_or_refund_log"
#

DROP TABLE IF EXISTS `pay_or_refund_log`;
CREATE TABLE `pay_or_refund_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL COMMENT '对账ID',
  `type` int(11) NOT NULL COMMENT '类型1 付款 2 退款',
  `oid` int(11) NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `rid` int(11) NOT NULL COMMENT '退款ID',
  `return_no` varchar(50) NOT NULL COMMENT '退款单号',
  `pay_price` decimal(10,2) NOT NULL COMMENT '支付金额（支付成功插入）',
  `refund_price` decimal(10,2) NOT NULL COMMENT '退款金额（退款成功插入）',
  `update_time` int(11) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `account_id` (`account_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='付款或退款日志表';

#
# Structure for table "phone_area_code"
#

DROP TABLE IF EXISTS `phone_area_code`;
CREATE TABLE `phone_area_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
  `country` varchar(30) DEFAULT '' COMMENT '国家名称',
  `area_code` int(5) NOT NULL DEFAULT '0' COMMENT '区号',
  `continent` varchar(20) DEFAULT '' COMMENT '所在大洲',
  `country_en` varchar(30) NOT NULL DEFAULT '' COMMENT '英文名',
  `short_flag` varchar(10) NOT NULL DEFAULT '' COMMENT '国际域名缩写',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0关闭1开启',
  `admin_id` varchar(32) NOT NULL DEFAULT '0' COMMENT 'admin.id',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后操作时间',
  `last_ip` varchar(32) NOT NULL DEFAULT '' COMMENT 'ip',
  `is_del` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0删除1正常',
  `letters` char(1) NOT NULL DEFAULT '' COMMENT '字母',
  PRIMARY KEY (`id`),
  KEY `en` (`country_en`) USING BTREE,
  KEY `code` (`area_code`) USING BTREE,
  KEY `name` (`country`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=216 DEFAULT CHARSET=utf8mb4 COMMENT='国际电话区号表';

#
# Structure for table "phone_base"
#

DROP TABLE IF EXISTS `phone_base`;
CREATE TABLE `phone_base` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `problem_type` varchar(255) NOT NULL COMMENT '问题类型',
  `sort` int(11) NOT NULL COMMENT '排序',
  `status` int(11) NOT NULL COMMENT '状态1正常  2 禁用 3删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COMMENT='问题基础表';

#
# Structure for table "promotion_base"
#

DROP TABLE IF EXISTS `promotion_base`;
CREATE TABLE `promotion_base` (
  `promotion_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `promotion_name` varchar(50) NOT NULL COMMENT '活动名称',
  `promotion_type` tinyint(1) NOT NULL COMMENT '活动类型 1 直播秒杀 2 pk秒杀',
  `discount` decimal(2,1) NOT NULL COMMENT '折扣',
  `self_label` char(20) NOT NULL COMMENT '标签',
  `duration` int(11) NOT NULL COMMENT '持续时间',
  `play_video` char(200) NOT NULL COMMENT '播放视频',
  `play_duration` int(11) NOT NULL COMMENT '视频时长',
  `play_start_time` int(11) NOT NULL COMMENT '视频播放开始时间',
  `play_end_time` int(11) NOT NULL COMMENT '视频播放结束时间',
  `start_time` int(11) NOT NULL COMMENT '开始时间',
  `end_time` int(11) NOT NULL COMMENT '结束时间',
  `banner_image` text NOT NULL COMMENT '展示图片',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `content` text NOT NULL,
  `pk_member_ida` int(11) NOT NULL COMMENT 'pk秒杀参与人员',
  `pk_member_idb` int(11) NOT NULL COMMENT 'pk秒杀参与人员',
  `pk_duration` int(11) NOT NULL COMMENT 'pk直播时长',
  `punish_duration` int(11) NOT NULL COMMENT 'pk惩罚时间',
  `pk_start_time` int(11) NOT NULL COMMENT 'pk开始时间',
  `pk_end_time` int(11) NOT NULL COMMENT 'pk结束时间',
  `virtual_live_num` int(11) NOT NULL COMMENT '虚拟基础观看人数',
  `promotion_sort` int(11) NOT NULL COMMENT '排序',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`promotion_id`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `promotion_type` (`promotion_type`) USING BTREE,
  KEY `promotion_name` (`promotion_name`) USING BTREE,
  KEY `play_video` (`play_video`(191)) USING BTREE,
  KEY `play_start_time` (`play_start_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=333 DEFAULT CHARSET=utf8mb4 COMMENT='营销活动表';

#
# Structure for table "promotion_goods"
#

DROP TABLE IF EXISTS `promotion_goods`;
CREATE TABLE `promotion_goods` (
  `goods_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `promotion_id` int(11) NOT NULL COMMENT '活动id',
  `goods_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '商品名称',
  `price` decimal(10,2) NOT NULL COMMENT '原价',
  `real_price` decimal(10,2) NOT NULL COMMENT '实际价格',
  `use_coupon_price` decimal(10,2) NOT NULL COMMENT '用券价格',
  `can_use_coupon_price` decimal(10,2) NOT NULL COMMENT '可用现金券金额',
  `num` int(11) NOT NULL COMMENT '可用库存',
  `max_num` int(11) NOT NULL COMMENT ' 最大购买数量',
  `real_num` int(11) NOT NULL COMMENT '实际库存',
  `pic` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '图片',
  `is_spread` tinyint(1) NOT NULL COMMENT '是否可用推广红包 1 是 0 否',
  `spread_price` decimal(10,2) NOT NULL COMMENT '推广红包金额',
  `sort` int(11) NOT NULL COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1正常，2禁用，3 删除',
  PRIMARY KEY (`goods_id`) USING BTREE,
  KEY `promotion_id` (`promotion_id`) USING BTREE,
  KEY `is_spread` (`is_spread`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `goods_name` (`goods_name`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `real_price` (`real_price`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1976 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀活动商品表';

#
# Structure for table "promotion_link"
#

DROP TABLE IF EXISTS `promotion_link`;
CREATE TABLE `promotion_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_goods_id` int(11) NOT NULL COMMENT '营销商品id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `link_id` int(11) NOT NULL,
  `goods_attr_id` int(11) NOT NULL,
  `num` int(11) NOT NULL,
  `is_gift` tinyint(1) NOT NULL COMMENT '是否为赠品',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1正常 2禁用 3 删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `promotion_goods_id` (`promotion_goods_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2207 DEFAULT CHARSET=utf8mb4 COMMENT='营销商品';

#
# Structure for table "promotion_pk_link"
#

DROP TABLE IF EXISTS `promotion_pk_link`;
CREATE TABLE `promotion_pk_link` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) NOT NULL COMMENT '活动id',
  `pk_start_time` int(11) NOT NULL COMMENT 'pk开始时间',
  `pk_end_time` int(11) NOT NULL COMMENT 'pk结束时间',
  `punish_duration` int(11) NOT NULL COMMENT '惩罚时间',
  `pk_member_ida` int(11) NOT NULL COMMENT 'pk主播1',
  `pk_member_idb` int(11) NOT NULL COMMENT 'pk主播2',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`link_id`) USING BTREE,
  KEY `promotion_id` (`promotion_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COMMENT='活动关联pk';

#
# Structure for table "push_msg"
#

DROP TABLE IF EXISTS `push_msg`;
CREATE TABLE `push_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `send_type` tinyint(4) NOT NULL COMMENT '发送类型1推送   ',
  `addtime` int(11) DEFAULT NULL COMMENT '添加时间',
  `title` varchar(500) NOT NULL COMMENT '标题',
  `content` varchar(300) DEFAULT NULL COMMENT '内容',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 1成功 2失败 3推送中',
  `admin_id` int(11) DEFAULT NULL COMMENT '管理员ID',
  `all_or_alone` tinyint(4) NOT NULL COMMENT '1  全部推送  0  选择用户推送',
  `push_time` int(11) NOT NULL DEFAULT '0' COMMENT '推送时间,0兼容版本1 --刘洋5.27',
  `member_ids` varchar(500) DEFAULT NULL COMMENT '推送的会员id,配合all_or_alone使用 --刘洋',
  `redirect_url` varchar(255) DEFAULT NULL COMMENT '跳转地址或ID --刘洋',
  `ad_type` tinyint(1) DEFAULT NULL COMMENT '关联类型：1无关联 2链接 3商品 4直播间 5店铺 6VIP礼包列表  --刘洋',
  `delete_time` int(11) DEFAULT NULL COMMENT '软删除 --刘洋',
  `msg_type` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '推送类型0系统消息，1活动，2app 8账户 9直播预告',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8 COMMENT='推送信息表';

#
# Structure for table "push_switch"
#

DROP TABLE IF EXISTS `push_switch`;
CREATE TABLE `push_switch` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `reminder_anchor` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '主播直播 0：不提醒 1：设置提醒',
  `reminder_fans` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '新粉丝关注 0：不设置提醒 1：设置提醒',
  PRIMARY KEY (`id`),
  KEY `idx_member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='推送开关表';

#
# Structure for table "recharge_log"
#

DROP TABLE IF EXISTS `recharge_log`;
CREATE TABLE `recharge_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '类型 1 充值 2 消费 3 退款',
  `oid` int(11) NOT NULL COMMENT '订单ID  消费时有值',
  `rid` int(11) NOT NULL COMMENT '退换货ID  自营 换货支付运费 或 退款',
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `pay_type_id` int(11) NOT NULL COMMENT '支付类型 1 支付宝 2 微信 3 银联 0 余额消费',
  `recharge_before_amount` decimal(11,2) NOT NULL COMMENT '交易前金额',
  `recharge_last_amount` decimal(11,2) NOT NULL COMMENT '交易后金额',
  `recharge_money` decimal(10,2) NOT NULL COMMENT '交易金额',
  `give_money` int(11) NOT NULL COMMENT '赠送金额',
  `share_code_amount` int(11) NOT NULL COMMENT '分享码数量',
  `time` datetime NOT NULL COMMENT '交易时间',
  `status` int(11) NOT NULL COMMENT '1 交易成功 2 交易失败',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `rid` (`rid`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='充值日志';

#
# Structure for table "return_goods"
#

DROP TABLE IF EXISTS `return_goods`;
CREATE TABLE `return_goods` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `r_type` int(11) NOT NULL COMMENT '1 自营 2 优品汇 3 生活圈',
  `return_no` varchar(50) NOT NULL COMMENT '退货单号',
  `uid` int(11) NOT NULL COMMENT '会员ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `oiid` int(11) NOT NULL COMMENT '子订单ID',
  `oid` int(11) NOT NULL COMMENT '订单ID',
  `gid` int(11) NOT NULL COMMENT '商品ID',
  `refund_price` decimal(11,2) NOT NULL COMMENT '退款金额',
  `rg_num` int(11) NOT NULL COMMENT '退回数量',
  `type` int(1) NOT NULL COMMENT '1 仅退款 2 退货退款 3 换货',
  `photo` varchar(1000) NOT NULL COMMENT '图片',
  `name` char(50) NOT NULL COMMENT '联系人',
  `tel` char(50) NOT NULL COMMENT '联系电话',
  `reason` varchar(500) NOT NULL COMMENT '退货原因',
  `refund_explain` varchar(500) NOT NULL COMMENT '退款说明',
  `feedback` varchar(500) NOT NULL COMMENT '回馈',
  `apply_is_receive_goods` int(11) NOT NULL COMMENT '我要退款（无需退货） 有物流状态时有值  1  未收到货 2 已收到货',
  `sub_time` int(11) NOT NULL COMMENT '提交时间',
  `deal_time` int(11) NOT NULL COMMENT '通过或驳回时间',
  `seller_send_time` int(11) NOT NULL COMMENT '卖家发货时间',
  `seller_receive_time` int(11) NOT NULL COMMENT '卖家收到货物时间',
  `buyer_send_time` int(11) NOT NULL COMMENT '买家寄出货物时间',
  `status` int(11) NOT NULL COMMENT '状态 0 未审核 1 已审核  2 审核驳回  3 取消申请',
  `seller_is_send_address` int(11) NOT NULL COMMENT '卖家是否发送地址到买家  1  已发送 0 未发送',
  `change_deliver_no` varchar(50) NOT NULL COMMENT '换货物流单号（卖家发到买家的物流）',
  `change_deliver_company` varchar(20) NOT NULL COMMENT '换货物流公司',
  `seller_is_receive_goods` int(11) NOT NULL COMMENT '卖家是否收到货 1 已收到 0 未收到',
  `seller_receive_province` varchar(30) NOT NULL COMMENT '卖家收货省（退换货用）',
  `seller_receive_city` varchar(30) NOT NULL COMMENT '卖家收货市',
  `seller_receive_area` varchar(30) NOT NULL COMMENT '卖家收货区',
  `seller_receive_address` varchar(500) NOT NULL COMMENT '卖家收货详细地址',
  `seller_receive_name` varchar(20) NOT NULL COMMENT '卖家收货人',
  `seller_receive_tel` varchar(15) NOT NULL COMMENT '卖家收货电话',
  `buyer_is_send` int(11) NOT NULL COMMENT '买家是否寄出货物 0 未寄出 1 已寄出',
  `buyer_deliver_company` varchar(50) NOT NULL COMMENT '物流公司（买家寄到卖家物流）',
  `buyer_deliver_no` varchar(50) NOT NULL COMMENT '物流单号',
  `return_pay_id` int(11) NOT NULL COMMENT '退换货运费支付记录id',
  `return_pay_status` tinyint(1) NOT NULL COMMENT '退换货运费支付状态 1支付 0 未支付',
  `change_deliver_fee` decimal(11,2) NOT NULL COMMENT '换货运费',
  `is_refund` int(11) NOT NULL COMMENT '是否已经退款 0 未退款 1 已退款',
  `buyer_is_read` int(11) NOT NULL COMMENT '买家是否已读 0 未读 1 已读',
  `seller_is_read` int(11) NOT NULL COMMENT '卖家是否已读 0 未读 1 已读',
  `seller_all_read` int(11) NOT NULL COMMENT '卖家是否全部已读 0 否 1 是',
  `reason_reject` text NOT NULL COMMENT '驳回原因',
  PRIMARY KEY (`rid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `oiid` (`oiid`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `gid` (`gid`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `return_no` (`return_no`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='退货表';

#
# Structure for table "return_reason"
#

DROP TABLE IF EXISTS `return_reason`;
CREATE TABLE `return_reason` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='退换货原因';

#
# Structure for table "sel_count"
#

DROP TABLE IF EXISTS `sel_count`;
CREATE TABLE `sel_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `is_child` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=207628 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

#
# Structure for table "send_member_counts"
#

DROP TABLE IF EXISTS `send_member_counts`;
CREATE TABLE `send_member_counts` (
  `id` int(11) NOT NULL,
  `link_id` int(11) NOT NULL COMMENT '优惠券ID',
  `name` varchar(255) NOT NULL COMMENT '活动名称',
  `start_time` int(11) NOT NULL COMMENT '活动开始时间',
  `end_time` int(11) NOT NULL COMMENT '活动结束时间',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '1:正常 2：禁用 3：删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新人赠送优惠券';

#
# Structure for table "send_sms_log"
#

DROP TABLE IF EXISTS `send_sms_log`;
CREATE TABLE `send_sms_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tel` varchar(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `add_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=62327 DEFAULT CHARSET=utf8 COMMENT='发送短信日志';

#
# Structure for table "share_link_member"
#

DROP TABLE IF EXISTS `share_link_member`;
CREATE TABLE `share_link_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '分享者用户id',
  `phone` varchar(20) NOT NULL COMMENT '被分享者手机号',
  `share_time` datetime NOT NULL COMMENT '分享时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

#
# Structure for table "shop_account_detail"
#

DROP TABLE IF EXISTS `shop_account_detail`;
CREATE TABLE `shop_account_detail` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `order_id` int(10) NOT NULL COMMENT '订单id',
  `c_time` int(10) NOT NULL COMMENT '创建时间',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 收入 2 提现',
  `shop_id` int(10) NOT NULL COMMENT '店铺id',
  `withdrawal_price` decimal(10,2) NOT NULL COMMENT '提现金额信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 2 删除',
  `audit_status` int(1) NOT NULL DEFAULT '1' COMMENT '1 未审核 2 已审核 3 审核未通过',
  `bank_id` int(11) NOT NULL COMMENT '银行卡id',
  `verify_time` int(11) NOT NULL COMMENT '审核时间',
  `content` text COMMENT '审核失败原因',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `bank_id` (`bank_id`) USING BTREE,
  KEY `audit_status` (`audit_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家收支明细数据表';

#
# Structure for table "shop_audit"
#

DROP TABLE IF EXISTS `shop_audit`;
CREATE TABLE `shop_audit` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '审核id',
  `member_id` int(11) NOT NULL COMMENT '申请人ID',
  `type` tinyint(1) NOT NULL COMMENT '1 优品汇 2 生活圈',
  `cate_id` int(11) NOT NULL COMMENT '商家分类id',
  `cate_second_id` int(11) NOT NULL COMMENT '商家二级分类',
  `province_id` int(11) NOT NULL COMMENT '省id',
  `city_id` int(11) NOT NULL COMMENT '市id',
  `area_id` int(11) NOT NULL COMMENT '区id',
  `address_describe` varchar(300) NOT NULL COMMENT '地址描述',
  `business_license` text NOT NULL COMMENT '营业执照照片',
  `supp_materials` text NOT NULL COMMENT '补充材料',
  `shop_headimage` varchar(500) NOT NULL COMMENT '店铺头像',
  `shop_name` char(20) NOT NULL COMMENT '商家名称',
  `check_time` int(11) NOT NULL COMMENT '审核时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1未审核 2 审核失败 3审核通过  4删除',
  `check_advice` char(200) NOT NULL COMMENT '审核失败理由',
  `creat_time` int(11) NOT NULL COMMENT '提交时间',
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `shop_type_id` (`cate_second_id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `shop_name` (`shop_name`) USING BTREE,
  KEY `cate_id_2` (`cate_id`) USING BTREE,
  KEY `cate_id_3` (`cate_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺审核';

#
# Structure for table "shop_base"
#

DROP TABLE IF EXISTS `shop_base`;
CREATE TABLE `shop_base` (
  `shop_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商家id',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 优品汇 2 生活圈 3明星店铺',
  `member_id` int(11) NOT NULL COMMENT '用户ID',
  `shop_name` char(20) NOT NULL COMMENT '商家名称',
  `shop_headimage` varchar(500) NOT NULL COMMENT '店铺头像',
  `level` int(11) NOT NULL COMMENT '店铺等级',
  `address` char(100) NOT NULL COMMENT '地址',
  `address_describe` varchar(300) NOT NULL COMMENT '地址描述',
  `qualification` char(100) NOT NULL COMMENT '资质',
  `cover_image` text NOT NULL COMMENT '封面图',
  `contact` char(20) NOT NULL COMMENT '申请人',
  `contact_phone` char(13) NOT NULL COMMENT '申请人联系方式',
  `run_start_time` char(10) NOT NULL COMMENT '营业时间（开始）',
  `run_end_time` char(10) NOT NULL COMMENT '营业时间（结束）',
  `shop_type_id` int(11) NOT NULL COMMENT '商家类型id',
  `cate_id` int(11) NOT NULL COMMENT '商家分类id',
  `cate_second_id` int(11) NOT NULL COMMENT '商家二级分类id',
  `cate_third_id` int(11) NOT NULL COMMENT '商家三级分类id',
  `lng` char(20) NOT NULL COMMENT '经度',
  `lat` char(20) NOT NULL COMMENT '纬度',
  `shop_account` char(20) NOT NULL COMMENT '商家账号',
  `shop_password` char(20) NOT NULL COMMENT '商家密码',
  `open_live` tinyint(1) NOT NULL COMMENT '是否开通直播 1 是 0 否',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `fav_num` int(11) unsigned DEFAULT '0' COMMENT '关注数',
  `sort` int(4) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `real_sales` int(11) DEFAULT '0' COMMENT '真实销量',
  `introduction` text NOT NULL COMMENT '简介',
  `logistics_service` decimal(3,1) NOT NULL COMMENT '物流服务',
  `descr_consis` decimal(3,1) NOT NULL COMMENT '描述相符',
  `service_attitude` decimal(3,1) NOT NULL COMMENT '服务态度',
  `average_score` decimal(3,1) NOT NULL COMMENT '平均评分',
  `per_consume` int(11) NOT NULL COMMENT '人均消费',
  `province_id` int(11) NOT NULL COMMENT '省id',
  `city_id` int(11) NOT NULL COMMENT '市id',
  `area_id` int(11) NOT NULL COMMENT '区id',
  `street_id` int(11) NOT NULL COMMENT '街道id',
  `environmental_science` varchar(50) NOT NULL COMMENT '环境',
  `decoration_style` varchar(100) NOT NULL COMMENT '装修风格',
  `measure_of_area` varchar(50) NOT NULL COMMENT '门店面积',
  `open_time` datetime NOT NULL COMMENT '开业时间',
  `server_num` varchar(10) NOT NULL COMMENT '服务人员数量',
  `consume_method` varchar(50) NOT NULL COMMENT '消费方式',
  `link_id` int(11) NOT NULL COMMENT '审核ID',
  `status` int(11) NOT NULL COMMENT '-1未审核 -2 审核失败 1正常 2禁用 3 删除',
  `send_province` int(11) NOT NULL COMMENT '发货省',
  `send_city` int(11) NOT NULL COMMENT '发货市',
  `send_area` int(11) NOT NULL COMMENT '发货区',
  `send_address` varchar(255) NOT NULL COMMENT '发货详细地址',
  `return_province` int(11) NOT NULL COMMENT '退货省',
  `return_city` int(11) NOT NULL COMMENT '退货市',
  `return_area` int(11) NOT NULL COMMENT '退货区',
  `return_address` varchar(200) NOT NULL COMMENT '退货详细地址',
  `shop_qrcode` varchar(255) NOT NULL COMMENT '商家二维码',
  `shop_assets` int(11) NOT NULL COMMENT '店铺资产',
  `can_use_account` decimal(10,2) NOT NULL COMMENT '商家可用余额',
  `login_rand_key` varchar(200) NOT NULL COMMENT '商家扫码登录 唯一码',
  `is_deposit` int(11) NOT NULL DEFAULT '0' COMMENT '是否缴纳保证金 1是 0否',
  `wait_settlement` decimal(10,2) NOT NULL COMMENT '待结算',
  `is_perfect` int(11) NOT NULL COMMENT '是否完善过信息 0 否 1 是',
  `check_advice` varchar(255) NOT NULL COMMENT '店家下架原因',
  `add_type` tinyint(2) NOT NULL COMMENT '1前端 2后台',
  PRIMARY KEY (`shop_id`) USING BTREE,
  KEY `shop_type_id` (`shop_type_id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `cate_second_id` (`cate_second_id`) USING BTREE,
  KEY `cate_third_id` (`cate_third_id`) USING BTREE,
  KEY `shop_name` (`shop_name`) USING BTREE,
  KEY `contact` (`contact_phone`) USING BTREE,
  KEY `cate_id_2` (`cate_id`,`cate_second_id`) USING BTREE,
  KEY `cate_id_3` (`cate_id`,`cate_second_id`,`cate_third_id`) USING BTREE,
  KEY `shop_headimage` (`shop_headimage`(191)) USING BTREE,
  KEY `fav_num` (`fav_num`) USING BTREE,
  KEY `real_sales` (`real_sales`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `per_consume` (`per_consume`) USING BTREE,
  KEY `is_deposit` (`is_deposit`) USING BTREE,
  KEY `is_perfect` (`is_perfect`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家店铺表';

#
# Structure for table "shop_industry_cate"
#

DROP TABLE IF EXISTS `shop_industry_cate`;
CREATE TABLE `shop_industry_cate` (
  `cate_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL COMMENT '上级id',
  `cate_name` char(50) NOT NULL COMMENT '分类名称',
  `icon` char(200) NOT NULL COMMENT '图标',
  `sort` int(11) NOT NULL COMMENT '排序',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  `type` int(11) NOT NULL COMMENT '1 优品汇 2生活圈',
  `cate_bond` char(20) NOT NULL COMMENT '保证金',
  PRIMARY KEY (`cate_id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `cate_name` (`cate_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺分类表';

#
# Structure for table "shop_notice"
#

DROP TABLE IF EXISTS `shop_notice`;
CREATE TABLE `shop_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '公告id',
  `title` text NOT NULL COMMENT '公告标题',
  `content` text NOT NULL COMMENT '公告内容',
  `start_time` int(11) NOT NULL COMMENT '开始时间',
  `end_time` int(11) NOT NULL COMMENT '结束时间',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '标记 1 开启 0关闭 2删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家公告';

#
# Structure for table "shop_type"
#

DROP TABLE IF EXISTS `shop_type`;
CREATE TABLE `shop_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(50) NOT NULL COMMENT '分类名称',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `status` tinyint(1) NOT NULL COMMENT '状态 1 正常 2 禁用 3 删除',
  PRIMARY KEY (`type_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家分类';

#
# Structure for table "shop_version"
#

DROP TABLE IF EXISTS `shop_version`;
CREATE TABLE `shop_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '版本号id',
  `is_force_update` tinyint(4) DEFAULT '0' COMMENT '是否强制更新 0.否 1.是',
  `force_update_level` int(11) NOT NULL COMMENT '强制更新的最高版本号',
  `version` int(11) NOT NULL COMMENT '版本号',
  `link` varchar(255) DEFAULT NULL COMMENT '链接',
  `u_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `content` text NOT NULL,
  `ver_descr` varchar(255) NOT NULL COMMENT '版本描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='版本号';

#
# Structure for table "shop_visit_log"
#

DROP TABLE IF EXISTS `shop_visit_log`;
CREATE TABLE `shop_visit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `time` datetime NOT NULL COMMENT '访问时间',
  `sn` varchar(500) NOT NULL COMMENT 'SN码  一台设备一个',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺访问日志';

#
# Structure for table "socket_error_log"
#

DROP TABLE IF EXISTS `socket_error_log`;
CREATE TABLE `socket_error_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '接口名称',
  `errorCode` varchar(10) NOT NULL COMMENT '错误码',
  `exceptDesc` varchar(20) NOT NULL COMMENT '错误描述',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `orderSn` varchar(100) NOT NULL COMMENT '订单号',
  `sn` varchar(50) NOT NULL COMMENT '同步流水号',
  `idCard` varchar(30) NOT NULL COMMENT '身份证号',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `cardSeq` varchar(50) NOT NULL COMMENT '绑卡流水号',
  `createTime` int(10) NOT NULL COMMENT '记录时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`username`) USING BTREE,
  KEY `orderSn` (`orderSn`) USING BTREE,
  KEY `idCard` (`idCard`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE,
  KEY `cardSeq` (`cardSeq`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口错误日志';

#
# Structure for table "stock"
#

DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock` (
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `storehouse_id` int(11) NOT NULL COMMENT '库房ID',
  `num` int(11) NOT NULL COMMENT '可用库存数量',
  `real_num` int(11) NOT NULL COMMENT '真实数量',
  `default_num` int(11) NOT NULL COMMENT '默认进货数量',
  `min_stock` int(11) NOT NULL COMMENT '最低库存',
  `time` int(11) NOT NULL COMMENT '更新时间',
  `price_change` tinyint(1) NOT NULL COMMENT '进货价格变动提示',
  `sale_price_change` tinyint(4) NOT NULL COMMENT '销售价格变动提示 0 已查 1 未查',
  UNIQUE KEY `goods_id` (`goods_id`,`storehouse_id`) USING BTREE,
  KEY `goods_id_2` (`goods_id`) USING BTREE,
  KEY `storehouse_id` (`storehouse_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存';

#
# Structure for table "stock_update_log"
#

DROP TABLE IF EXISTS `stock_update_log`;
CREATE TABLE `stock_update_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '1  扣减库存  2  回退库存',
  `type_s` int(11) NOT NULL COMMENT '1  下单  2  取消订单  3  退款',
  `before_num` int(11) NOT NULL COMMENT '操作前库存',
  `num` int(11) NOT NULL,
  `after_num` int(11) NOT NULL COMMENT '操作后库存',
  `goods_id` int(11) NOT NULL,
  `link_id` int(11) NOT NULL,
  `oid` int(11) NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='库存变更日志';

#
# Structure for table "system_set"
#

DROP TABLE IF EXISTS `system_set`;
CREATE TABLE `system_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '类型 1 优品汇店铺评分平均分挡位 2 订单自动确认收货时间 单位天 3 生活圈订单自动完成时间 单位小时 4 订单自动关闭时间 单位小时 5 分享码规则说明 textarea 6 客服电话 7 开播注意事项标题 8 优品汇店铺可选物流公司 9 服务/售后反馈问题 10 商品/活动反馈问题 11 系统/功能反馈问题 12 其他反馈问题 13 连麦授权声明 textarea 14 自营商城退换货协议 textarea 15 提现限额 16 提现手续费 17 自营换货卖家信息 18 直播举报原因 19 用户每日连麦次数限制 20 开播注意事项内容 21 用户隐私条例 22 直播规范  23 服务顾问指南标题  24 服务顾问指南内容',
  `content` text NOT NULL,
  `sort` int(11) NOT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置文件设置';

#
# Structure for table "thaw_record"
#

DROP TABLE IF EXISTS `thaw_record`;
CREATE TABLE `thaw_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '申请id',
  `shop_id` int(11) NOT NULL COMMENT '店铺id',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '解冻金额',
  `discount_time` int(11) NOT NULL COMMENT '申请时间',
  `verify_time` int(11) NOT NULL COMMENT '审核时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '审核 0未审核1审核通过2审核未通过',
  `bank_id` int(11) NOT NULL COMMENT '银行卡id',
  `content` text COMMENT '审核失败原因',
  `del_status` int(11) NOT NULL DEFAULT '0' COMMENT '删除属性',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `bank_id` (`bank_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `del_status` (`del_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COMMENT='保证金解冻记录';

#
# Structure for table "tianxi"
#

DROP TABLE IF EXISTS `tianxi`;
CREATE TABLE `tianxi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `sn` varchar(255) NOT NULL COMMENT 'sn',
  `sid` varchar(255) NOT NULL COMMENT 'sid',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `visit_time` int(11) NOT NULL DEFAULT '0' COMMENT '访问时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sn` (`sn`(191)) USING BTREE,
  KEY `sid` (`sid`(191)) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='设备访问记录表';

#
# Structure for table "tx_aaa"
#

DROP TABLE IF EXISTS `tx_aaa`;
CREATE TABLE `tx_aaa` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `username` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '用户ID',
  `credit` int(10) NOT NULL DEFAULT '0' COMMENT '签到获得的金币数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2369 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='原海星数据表';

#
# Structure for table "tx_address_book_invitation"
#

DROP TABLE IF EXISTS `tx_address_book_invitation`;
CREATE TABLE `tx_address_book_invitation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tel` char(11) NOT NULL COMMENT '邀请人手机号',
  `phone` char(11) NOT NULL COMMENT '通讯录手机号',
  `status` int(2) NOT NULL DEFAULT '0' COMMENT '1已邀请',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tel` (`tel`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1765 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_admin_role"
#

DROP TABLE IF EXISTS `tx_admin_role`;
CREATE TABLE `tx_admin_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL COMMENT '关联角色表id',
  `admin_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='后台权限关联角色 后台用户表';

#
# Structure for table "tx_article"
#

DROP TABLE IF EXISTS `tx_article`;
CREATE TABLE `tx_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章内容',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '文章状态  1开启 2关闭',
  `addtime` int(11) NOT NULL COMMENT '文章添加时间',
  `savetime` int(11) NOT NULL DEFAULT '0' COMMENT '文章修改时间',
  `top` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '置顶1开启 0关闭',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类型：0 交易所相关新闻',
  `source` varchar(80) NOT NULL DEFAULT '0' COMMENT '来源',
  `ord` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '排序倒叙',
  `author` varchar(10) NOT NULL DEFAULT '' COMMENT '作者',
  `img` varchar(100) NOT NULL DEFAULT '' COMMENT '封面图',
  `link` varchar(100) NOT NULL DEFAULT '' COMMENT '链接',
  `info` varchar(32) NOT NULL DEFAULT '' COMMENT '简介',
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT 'icon',
  `cate_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='文章表';

#
# Structure for table "tx_base_ad"
#

DROP TABLE IF EXISTS `tx_base_ad`;
CREATE TABLE `tx_base_ad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '广告名称',
  `ad_site` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '广告位置：1.首页 2.海贝专柜 3.久久超市',
  `img` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '图片',
  `ad_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '关联类型：1无关联 2链接 3商品 4直播间 5店铺 6VIP礼包列表',
  `redirect_url` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '跳转地址或ID',
  `clicks` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `order_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单数',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到期时间',
  `ad_sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_read` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0未读，1已读',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ad_site` (`ad_site`) USING BTREE,
  KEY `ad_type` (`ad_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='轮播图';

#
# Structure for table "tx_base_app"
#

DROP TABLE IF EXISTS `tx_base_app`;
CREATE TABLE `tx_base_app` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '开屏广告ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '广告名称',
  `resource_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '资源类型：1图片 2视频',
  `resource_url` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '上传地址',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `wait_time` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '显示时间 s',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='开屏广告';

#
# Structure for table "tx_brand"
#

DROP TABLE IF EXISTS `tx_brand`;
CREATE TABLE `tx_brand` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '中文名称',
  `en_name` varchar(90) COLLATE utf8_bin NOT NULL COMMENT '英文名称',
  `initial` varchar(10) COLLATE utf8_bin NOT NULL COMMENT '首字母',
  `brief` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '品牌简介',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `initial` (`initial`) USING BTREE,
  KEY `en_name` (`en_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品品牌表 -后台 品牌管理\r';

#
# Structure for table "tx_business_log"
#

DROP TABLE IF EXISTS `tx_business_log`;
CREATE TABLE `tx_business_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商务合作审核记录ID',
  `business_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商务申请id',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `status` tinyint(1) unsigned NOT NULL COMMENT '2申请通过 3申请拒绝',
  `reason` varchar(200) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '审核备注原因',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='商务合作审核记录';

#
# Structure for table "tx_collection"
#

DROP TABLE IF EXISTS `tx_collection`;
CREATE TABLE `tx_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '用户id',
  `type` int(1) NOT NULL DEFAULT '1' COMMENT '收藏类型 1：店铺  2：商品',
  `goods_id` int(10) DEFAULT '0' COMMENT '商品id',
  `shop_id` int(10) DEFAULT '0' COMMENT '店铺id',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2671 DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

#
# Structure for table "tx_comment"
#

DROP TABLE IF EXISTS `tx_comment`;
CREATE TABLE `tx_comment` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `order_id` int(11) NOT NULL COMMENT '订单ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `user_id` int(11) NOT NULL COMMENT '评论人ID',
  `item_id` int(11) NOT NULL COMMENT 'order_item 的 主键ID',
  `comment` text NOT NULL COMMENT '评论内容',
  `reply` text NOT NULL COMMENT '回复内容',
  `comment_time` int(11) NOT NULL COMMENT '评论时间',
  `reply_time` int(11) NOT NULL COMMENT '回复时间',
  `comment_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态1.展示 2 隐藏',
  `score` float NOT NULL DEFAULT '0' COMMENT '评分',
  `score_1` float NOT NULL COMMENT '描述相符',
  `score_2` float NOT NULL COMMENT '服务态度',
  `score_3` float NOT NULL COMMENT '物流服务  /  店铺环境',
  `pic` text NOT NULL COMMENT '评论图片',
  `label_json` char(200) NOT NULL COMMENT '评价标签json',
  `advice` varchar(500) NOT NULL COMMENT '审核不通过过原因',
  `anonymous` int(11) NOT NULL COMMENT '是否是匿名评论 1 是 0 否',
  `like_num` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `share_num` int(11) NOT NULL DEFAULT '0' COMMENT '分享数',
  `IP` varchar(255) NOT NULL,
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `operation` tinyint(1) NOT NULL DEFAULT '0' COMMENT '操作(待评价中的隐藏操作) 默认0,1操作后',
  PRIMARY KEY (`comment_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `comment_status` (`comment_status`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=327 DEFAULT CHARSET=utf8 COMMENT='商品/店铺 评论表';

#
# Structure for table "tx_comment_code_pic"
#

DROP TABLE IF EXISTS `tx_comment_code_pic`;
CREATE TABLE `tx_comment_code_pic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `ciphertext` char(11) NOT NULL COMMENT '密令',
  `qrcode_url` varchar(100) NOT NULL COMMENT '二维码图片地址',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `ciphertext` (`ciphertext`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='评论分享二维码图文';

#
# Structure for table "tx_comment_like"
#

DROP TABLE IF EXISTS `tx_comment_like`;
CREATE TABLE `tx_comment_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL COMMENT '用户id',
  `comment_id` int(10) NOT NULL COMMENT '评论id',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `comment_id` (`comment_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COMMENT='评论点赞明细表';

#
# Structure for table "tx_config"
#

DROP TABLE IF EXISTS `tx_config`;
CREATE TABLE `tx_config` (
  `name` varchar(255) NOT NULL,
  `value` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "tx_config_20200930"
#

DROP TABLE IF EXISTS `tx_config_20200930`;
CREATE TABLE `tx_config_20200930` (
  `name` varchar(255) NOT NULL,
  `value` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "tx_config_log"
#

DROP TABLE IF EXISTS `tx_config_log`;
CREATE TABLE `tx_config_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule` longtext,
  `admin` varchar(50) DEFAULT NULL COMMENT '操作人',
  `addtime` int(11) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='tx_config  rule  备份和操作记录';

#
# Structure for table "tx_coupons"
#

DROP TABLE IF EXISTS `tx_coupons`;
CREATE TABLE `tx_coupons` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '优惠券名称',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '店铺ID(如为0为通用券)',
  `p_ids` text COLLATE utf8_bin NOT NULL COMMENT '关联商品ID集合',
  `num` int(10) NOT NULL COMMENT '发型总量',
  `give_num` int(10) NOT NULL DEFAULT '0' COMMENT '领取数量',
  `use_num` int(10) NOT NULL DEFAULT '0' COMMENT '使用数量',
  `price` decimal(10,2) NOT NULL COMMENT '面额',
  `limit_price` decimal(10,2) NOT NULL COMMENT '优惠券使用门槛',
  `max_have` int(8) NOT NULL DEFAULT '1' COMMENT '每人限领个数',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `member` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '参与会员',
  `status` tinyint(1) NOT NULL COMMENT '1：启用  2：禁用',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1：删除',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `use_limit` tinyint(3) NOT NULL DEFAULT '1' COMMENT '使用时长1 否 2是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='优惠券表';

#
# Structure for table "tx_credit_config"
#

DROP TABLE IF EXISTS `tx_credit_config`;
CREATE TABLE `tx_credit_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '配置名',
  `addtime` int(11) NOT NULL,
  `name_com` varchar(50) NOT NULL DEFAULT '' COMMENT '数值',
  `updatetime` int(11) DEFAULT NULL COMMENT '最后一次变更时间',
  `memo` varchar(255) NOT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_express"
#

DROP TABLE IF EXISTS `tx_express`;
CREATE TABLE `tx_express` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '快递名称',
  `addtime` int(11) NOT NULL,
  `name_com` varchar(50) NOT NULL COMMENT '快递公司编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_find_official_picture"
#

DROP TABLE IF EXISTS `tx_find_official_picture`;
CREATE TABLE `tx_find_official_picture` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_base_id` int(11) DEFAULT NULL,
  `content` text COMMENT '图文内容',
  `picname` text COMMENT '图片组',
  `addtime` int(11) DEFAULT NULL COMMENT '添加时间',
  `type` int(255) NOT NULL DEFAULT '1' COMMENT '1图文2视频',
  `video` varchar(255) DEFAULT NULL COMMENT '视频',
  `cover` varchar(255) DEFAULT NULL COMMENT '视频封面',
  `category` int(11) NOT NULL DEFAULT '0' COMMENT '视频的1横着2竖着',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8 COMMENT='官方图文';

#
# Structure for table "tx_find_word"
#

DROP TABLE IF EXISTS `tx_find_word`;
CREATE TABLE `tx_find_word` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '探索发现词ID',
  `word` varchar(50) NOT NULL DEFAULT '' COMMENT '探索名称',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `clicks` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `order_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单数',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='探索发现';

#
# Structure for table "tx_flow"
#

DROP TABLE IF EXISTS `tx_flow`;
CREATE TABLE `tx_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '店铺id',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1首页2商品分类页3.商品详情页4直播间5店铺',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `num` int(11) NOT NULL DEFAULT '1' COMMENT '次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "tx_freight"
#

DROP TABLE IF EXISTS `tx_freight`;
CREATE TABLE `tx_freight` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sort` int(11) NOT NULL DEFAULT '999' COMMENT '序号',
  `name` varchar(255) NOT NULL COMMENT '模板名称',
  `type` tinyint(3) NOT NULL COMMENT '计费类型 1重量 2体积',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  `status` int(255) NOT NULL DEFAULT '1' COMMENT '是否开启  1 开启  2不开启',
  `static` int(255) NOT NULL DEFAULT '2' COMMENT '是否默认  1 默认  2 不默认',
  `province` varchar(255) NOT NULL COMMENT '发货地址 省',
  `city` varchar(255) NOT NULL COMMENT '发货地址 市',
  `shop_id` int(11) NOT NULL COMMENT '店铺id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8 COMMENT='运费模板表  关联  tx_freight_company  运费计量单位';

#
# Structure for table "tx_freight_company"
#

DROP TABLE IF EXISTS `tx_freight_company`;
CREATE TABLE `tx_freight_company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `freight_id` int(11) NOT NULL COMMENT ' tx_freight 表id',
  `weight` int(11) NOT NULL COMMENT '重量',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `overweight` int(11) NOT NULL COMMENT '超重',
  `overprice` decimal(10,2) NOT NULL COMMENT '超重价',
  `status` int(10) NOT NULL DEFAULT '2' COMMENT '2非默认1默认',
  `city` text NOT NULL COMMENT '城市id多个',
  `city_ids` text NOT NULL COMMENT '城市id',
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=474 DEFAULT CHARSET=utf8 COMMENT=' tx_freight_company 计量模板运费表';

#
# Structure for table "tx_gift"
#

DROP TABLE IF EXISTS `tx_gift`;
CREATE TABLE `tx_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '赠品ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '赠品名称',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `sku` varchar(100) COLLATE utf8_bin NOT NULL COMMENT 'SKU',
  `sku_id` int(10) NOT NULL COMMENT 'SKU ID',
  `sku_name` varchar(200) COLLATE utf8_bin NOT NULL COMMENT 'SKU名称',
  `sku_pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT 'SKU图片',
  `sku_price` decimal(10,2) NOT NULL COMMENT 'SKU价钱',
  `p_ids` text COLLATE utf8_bin NOT NULL COMMENT '关联商品ID集合',
  `num` int(10) NOT NULL COMMENT '发型总量',
  `use_num` int(10) NOT NULL DEFAULT '0' COMMENT '购买数量',
  `limit_price` decimal(10,2) NOT NULL COMMENT '赠品使用门槛',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `status` tinyint(1) NOT NULL COMMENT '1：启用  2：禁用',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1：删除',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `sku` (`sku`) USING BTREE,
  KEY `sku_id` (`sku_id`) USING BTREE,
  KEY `sku_name` (`sku_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='赠品表';

#
# Structure for table "tx_goods_attr_link"
#

DROP TABLE IF EXISTS `tx_goods_attr_link`;
CREATE TABLE `tx_goods_attr_link` (
  `link_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `link_info` text COMMENT '属性（颜色 尺码）',
  `link_price` decimal(11,2) DEFAULT NULL COMMENT ' 销售价格',
  `coupon_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠券金额',
  `original_price` decimal(11,2) DEFAULT NULL COMMENT '原价',
  `vip_price` decimal(11,2) DEFAULT NULL COMMENT 'VIP价格',
  `commission` decimal(11,2) DEFAULT NULL COMMENT '佣金',
  `total_num` int(11) DEFAULT NULL COMMENT '销售库存(下单减)',
  `sale_warning` int(11) DEFAULT NULL COMMENT '销售预警值',
  `sale_num` int(11) NOT NULL COMMENT '销量',
  `link_pic` varchar(255) DEFAULT NULL COMMENT '图片',
  `live_commission` decimal(10,2) DEFAULT NULL COMMENT '直播间佣金',
  `one` decimal(10,2) DEFAULT NULL,
  `two` decimal(10,2) DEFAULT NULL,
  `three` decimal(10,2) DEFAULT NULL,
  `four` decimal(10,2) DEFAULT NULL,
  `five` decimal(10,2) DEFAULT NULL,
  `six` decimal(10,2) DEFAULT NULL,
  `seven` decimal(10,2) DEFAULT NULL,
  `eight` decimal(10,2) DEFAULT NULL,
  `nine` decimal(10,2) DEFAULT NULL,
  `ten` decimal(10,2) DEFAULT NULL,
  `eleven` decimal(10,2) DEFAULT NULL,
  `twelve` decimal(10,2) DEFAULT NULL,
  `share` decimal(10,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL COMMENT '状态 1正常 2禁用 3 删除 4 添加中',
  `limit_num` int(11) NOT NULL COMMENT '0 代表不限购',
  `Version_No` int(11) DEFAULT '1' COMMENT '版本号',
  `live_commission_v2` decimal(11,2) NOT NULL COMMENT '直播佣金',
  `goods_commission` decimal(11,2) NOT NULL COMMENT '商品佣金',
  `attr_info_id` varchar(50) DEFAULT NULL COMMENT '属性id --liuyang',
  PRIMARY KEY (`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1657 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_goods_attr_link_copy"
#

DROP TABLE IF EXISTS `tx_goods_attr_link_copy`;
CREATE TABLE `tx_goods_attr_link_copy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `link_id` int(11) DEFAULT NULL COMMENT '属性ID',
  `link_info` text COMMENT '属性（颜色 尺码）',
  `link_price` decimal(11,2) DEFAULT NULL COMMENT ' 销售价格',
  `coupon_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠券金额',
  `original_price` decimal(11,2) DEFAULT NULL COMMENT '原价',
  `vip_price` decimal(11,2) DEFAULT NULL COMMENT 'VIP价格',
  `commission` decimal(11,2) DEFAULT NULL COMMENT '佣金',
  `total_num` int(11) DEFAULT NULL COMMENT '销售库存(下单减)',
  `sale_warning` int(11) DEFAULT NULL COMMENT '销售预警值',
  `link_pic` varchar(255) DEFAULT NULL COMMENT '图片',
  `live_commission` decimal(10,2) DEFAULT NULL COMMENT '直播间佣金',
  `one` decimal(10,2) DEFAULT NULL,
  `two` decimal(10,2) DEFAULT NULL,
  `three` decimal(10,2) DEFAULT NULL,
  `four` decimal(10,2) DEFAULT NULL,
  `five` decimal(10,2) DEFAULT NULL,
  `six` decimal(10,2) DEFAULT NULL,
  `seven` decimal(10,2) DEFAULT NULL,
  `eight` decimal(10,2) DEFAULT NULL,
  `nine` decimal(10,2) DEFAULT NULL,
  `ten` decimal(10,2) DEFAULT NULL,
  `eleven` decimal(10,2) DEFAULT NULL,
  `twelve` decimal(10,2) DEFAULT NULL,
  `share` decimal(10,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL COMMENT '状态 1正常 2禁用 3 删除 4 添加中',
  `Version_No` int(11) DEFAULT '1' COMMENT '版本号',
  `live_commission_v2` decimal(11,2) NOT NULL COMMENT '直播佣金',
  `goods_commission` decimal(11,2) NOT NULL COMMENT '商品佣金',
  `limit_num` int(11) NOT NULL COMMENT '0 代表不限购',
  `attr_info_id` varchar(50) DEFAULT NULL,
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44910 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_goods_attr_price"
#

DROP TABLE IF EXISTS `tx_goods_attr_price`;
CREATE TABLE `tx_goods_attr_price` (
  `attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL COMMENT 'goods_base的主键ID',
  `link_id` int(11) DEFAULT NULL COMMENT 'goods_attr_link表 主键ID',
  `stock_id` int(11) DEFAULT NULL COMMENT 'goods_stock表 主键ID',
  `attr_num` int(11) DEFAULT NULL COMMENT '商品数量',
  `status` tinyint(1) DEFAULT NULL COMMENT '1 正常 2禁用 3删除 4 添加中',
  PRIMARY KEY (`attr_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1853 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_goods_attr_price_copy"
#

DROP TABLE IF EXISTS `tx_goods_attr_price_copy`;
CREATE TABLE `tx_goods_attr_price_copy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL COMMENT 'goods_base的主键ID',
  `link_id` int(11) DEFAULT NULL COMMENT 'goods_attr_link表 主键ID',
  `attr_id` int(11) DEFAULT NULL,
  `stock_id` int(11) DEFAULT NULL COMMENT 'goods_stock表 主键ID',
  `attr_num` int(11) DEFAULT NULL COMMENT '商品数量',
  `Version_No` int(11) NOT NULL COMMENT '版本号',
  `status` tinyint(1) DEFAULT NULL COMMENT '1 正常 2禁用 3删除 4 添加中',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26449 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_goods_base"
#

DROP TABLE IF EXISTS `tx_goods_base`;
CREATE TABLE `tx_goods_base` (
  `goods_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_type` tinyint(1) DEFAULT '0' COMMENT '1 自营商品 2 店铺商品 3 VIP礼包 4 新人专区 5 专区商品 6 体验商品',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `original_price` decimal(11,2) DEFAULT NULL COMMENT '商品原价',
  `goods_price` decimal(11,2) DEFAULT NULL COMMENT '商品最低价钱（现价）',
  `coupon_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠券金额',
  `vip_price` decimal(11,2) DEFAULT NULL COMMENT 'vip价格',
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
  PRIMARY KEY (`goods_id`) USING BTREE,
  KEY `goods_type` (`goods_type`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `audit_status` (`audit_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1196 DEFAULT CHARSET=utf8 COMMENT='商品';

#
# Structure for table "tx_goods_browse"
#

DROP TABLE IF EXISTS `tx_goods_browse`;
CREATE TABLE `tx_goods_browse` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品浏览记录',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品id',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `hot` tinyint(1) NOT NULL DEFAULT '0' COMMENT '热门商品标签 1：热门商品 0：普通商品',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `hot_time` int(10) NOT NULL DEFAULT '0' COMMENT '浏览热门商品更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `hot` (`hot`) USING BTREE,
  KEY `c_time` (`c_time`) USING BTREE,
  KEY `hot_time` (`hot_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=124489 DEFAULT CHARSET=utf8 COMMENT='足迹-商品浏览记录';

#
# Structure for table "tx_goods_cart"
#

DROP TABLE IF EXISTS `tx_goods_cart`;
CREATE TABLE `tx_goods_cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `shop_id` int(11) DEFAULT '0' COMMENT '店铺ID',
  `member_id` int(11) DEFAULT NULL COMMENT '会员ID',
  `goods_id` int(10) DEFAULT NULL COMMENT '商品ID',
  `link_id` int(11) DEFAULT '0' COMMENT '商品一级属性ID',
  `num` int(5) DEFAULT '1' COMMENT '数量',
  `live_id` int(10) DEFAULT '0' COMMENT '直播ID',
  `live_status` int(10) DEFAULT '0' COMMENT '直播状态来源：1.直播中 2.直播回放',
  `ad_id` int(10) NOT NULL DEFAULT '0' COMMENT '广告位 ID',
  `ad_type` int(1) NOT NULL DEFAULT '0' COMMENT '广告位   1 探索发现  2 多功能推送   3 商品推送   4 Banner',
  `checked` tinyint(1) DEFAULT '0' COMMENT '购物车选中状态 1 选中 0 未选',
  `time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14643 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='购物车';

#
# Structure for table "tx_goods_category"
#

DROP TABLE IF EXISTS `tx_goods_category`;
CREATE TABLE `tx_goods_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '分类名称',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父类ID',
  `level` int(1) NOT NULL COMMENT '分类级别',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '分类图片',
  `attr` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '分类属性',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '状态 1正常 2禁用 3删除 ',
  `create_time` int(10) NOT NULL,
  `label` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '标签一级分类有',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `level` (`level`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=840 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品分类表';

#
# Structure for table "tx_goods_category_attr"
#

DROP TABLE IF EXISTS `tx_goods_category_attr`;
CREATE TABLE `tx_goods_category_attr` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '属性名称',
  `cate_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分类ID',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1377 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺分类类型表';

#
# Structure for table "tx_goods_category_attr_img"
#

DROP TABLE IF EXISTS `tx_goods_category_attr_img`;
CREATE TABLE `tx_goods_category_attr_img` (
  `tx_goods_attr_link_img_id` int(50) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tx_goods_category_attr_id` int(50) NOT NULL COMMENT '分类属性的ID',
  `goods_id` int(50) NOT NULL,
  `pic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delete_time` int(100) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`tx_goods_attr_link_img_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7455 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='分类属性关联图片表 --liuyang';

#
# Structure for table "tx_goods_category_copy1"
#

DROP TABLE IF EXISTS `tx_goods_category_copy1`;
CREATE TABLE `tx_goods_category_copy1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '分类名称',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父类ID',
  `level` int(1) NOT NULL COMMENT '分类级别',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '分类图片',
  `attr` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '分类属性',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '状态 1正常 2禁用 3删除 ',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `level` (`level`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=714 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品分类表';

#
# Structure for table "tx_goods_commission"
#

DROP TABLE IF EXISTS `tx_goods_commission`;
CREATE TABLE `tx_goods_commission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL COMMENT '商铺id',
  `name` varchar(255) NOT NULL COMMENT '模板名称',
  `live_commission` decimal(10,2) DEFAULT NULL COMMENT '直播佣金',
  `one` decimal(10,2) DEFAULT NULL,
  `two` decimal(10,2) DEFAULT NULL,
  `three` decimal(10,2) DEFAULT NULL,
  `four` decimal(10,2) DEFAULT NULL,
  `five` decimal(10,2) DEFAULT NULL,
  `six` decimal(10,2) DEFAULT NULL,
  `seven` decimal(10,2) DEFAULT NULL,
  `eight` decimal(10,2) DEFAULT NULL,
  `nine` decimal(10,2) DEFAULT NULL,
  `ten` decimal(10,2) DEFAULT NULL,
  `eleven` decimal(10,2) DEFAULT NULL,
  `twelve` decimal(10,2) DEFAULT NULL,
  `share` decimal(10,2) DEFAULT NULL COMMENT '分享佣金',
  `status` int(10) DEFAULT '1' COMMENT '是否启用',
  `addtime` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品佣金';

#
# Structure for table "tx_goods_encryption"
#

DROP TABLE IF EXISTS `tx_goods_encryption`;
CREATE TABLE `tx_goods_encryption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `encryption` char(11) NOT NULL COMMENT '加密',
  `addtime` int(11) NOT NULL COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8 COMMENT='体验商品加密';

#
# Structure for table "tx_goods_pv_uv"
#

DROP TABLE IF EXISTS `tx_goods_pv_uv`;
CREATE TABLE `tx_goods_pv_uv` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `addtime` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=286717 DEFAULT CHARSET=utf8 COMMENT='商品uv pv表  统计用';

#
# Structure for table "tx_goods_stock"
#

DROP TABLE IF EXISTS `tx_goods_stock`;
CREATE TABLE `tx_goods_stock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL COMMENT '店铺ID 0 自营 其余店铺ID',
  `stock_name` varchar(255) DEFAULT NULL COMMENT '库存名称',
  `prefix_1` varchar(20) NOT NULL COMMENT 'SKU前缀 1',
  `prefix_2` varchar(50) NOT NULL COMMENT 'SKU前缀 2',
  `sku` varchar(255) DEFAULT NULL COMMENT '商品SKU',
  `sku_com` varchar(255) NOT NULL COMMENT '组合SKU',
  `sku_name` varchar(255) DEFAULT NULL COMMENT 'SKU名称',
  `total_num` int(11) DEFAULT '0' COMMENT '库存数量(下单减)',
  `goods_price` decimal(11,2) DEFAULT NULL COMMENT '商品原价',
  `goods_warning` int(11) DEFAULT NULL COMMENT '库存预警',
  `goods_weight` varchar(50) DEFAULT NULL COMMENT '商品重量',
  `goods_length` varchar(50) DEFAULT NULL COMMENT '商品长',
  `goods_width` varchar(50) DEFAULT NULL,
  `goods_high` varchar(50) DEFAULT NULL COMMENT '商品高度',
  `goods_pic` varchar(255) DEFAULT NULL COMMENT 'SKU图片',
  `creat_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` tinyint(1) DEFAULT NULL COMMENT '1 正常(上架) 2禁用(下架) 3删除',
  `send_province` int(11) DEFAULT NULL COMMENT '发货省',
  `send_city` int(11) DEFAULT NULL COMMENT '发货城市',
  `send_area` int(11) DEFAULT NULL COMMENT '发货区',
  `sale_num` int(11) DEFAULT '0' COMMENT '销量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8 COMMENT='自营库存列表\r';

#
# Structure for table "tx_group_coupons"
#

DROP TABLE IF EXISTS `tx_group_coupons`;
CREATE TABLE `tx_group_coupons` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '优惠券名称',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `p_ids` text COLLATE utf8_bin NOT NULL COMMENT '关联商品ID集合',
  `price` decimal(10,2) NOT NULL COMMENT '面额',
  `limit_price` decimal(10,2) NOT NULL COMMENT '优惠券使用门槛',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `type` varchar(10) COLLATE utf8_bin NOT NULL COMMENT '会员组',
  `coupons_id` int(10) NOT NULL COMMENT '优惠券ID',
  `create_time` int(10) NOT NULL COMMENT '赠送时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='赠送分组优惠券表';

#
# Structure for table "tx_invoice_record"
#

DROP TABLE IF EXISTS `tx_invoice_record`;
CREATE TABLE `tx_invoice_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '操作人',
  `addtime` int(11) NOT NULL COMMENT '操作时间',
  `order_no` varchar(50) NOT NULL COMMENT '订单编号',
  `content` text COMMENT '操作了什么',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COMMENT='发票操作记录';

#
# Structure for table "tx_licence"
#

DROP TABLE IF EXISTS `tx_licence`;
CREATE TABLE `tx_licence` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL COMMENT '标题',
  `desc` varchar(255) NOT NULL COMMENT '描述',
  `content` text NOT NULL COMMENT '富文本',
  `addtime` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='证照信息';

#
# Structure for table "tx_live_apply"
#

DROP TABLE IF EXISTS `tx_live_apply`;
CREATE TABLE `tx_live_apply` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播申请ID',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `phone` char(11) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '联系电话',
  `wx_num` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '微信号',
  `intro` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '个人简介',
  `apply_pic` varchar(2000) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '申请图片',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '审核状态 1审核中 2申请通过 3申请拒绝 4 删除',
  `reason` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '审核备注原因',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到期时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='直播申请审核';

#
# Structure for table "tx_live_apply_log"
#

DROP TABLE IF EXISTS `tx_live_apply_log`;
CREATE TABLE `tx_live_apply_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播申请审核记录ID',
  `apply_id` int(10) NOT NULL COMMENT '申请id',
  `admin_id` int(11) NOT NULL COMMENT '管理员ID',
  `status` tinyint(1) NOT NULL COMMENT '2申请通过 3申请拒绝',
  `reason` varchar(255) CHARACTER SET utf8mb4 NOT NULL COMMENT '审核备注原因',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COMMENT='直播申请审核记录';

#
# Structure for table "tx_live_credit_log"
#

DROP TABLE IF EXISTS `tx_live_credit_log`;
CREATE TABLE `tx_live_credit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '贝壳流水ID',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `credit_num` decimal(10,2) unsigned NOT NULL COMMENT '积分数',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.直播打赏 2.提现 3.提现退回 4.提现到账',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝（type-2/3）4.银行卡',
  `reward_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '直播打赏ID（type-1）',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '打赏用户id（type-1）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8 COMMENT='积分流水记录表';

#
# Structure for table "tx_live_diamond"
#

DROP TABLE IF EXISTS `tx_live_diamond`;
CREATE TABLE `tx_live_diamond` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '钻石充值ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `pay_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '付款时间',
  `pay_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态：0未支付 1已支付 ',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：1.微信 2.支付宝 3.苹果',
  `trade_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '商户交易号',
  `order_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_price` decimal(10,2) unsigned NOT NULL COMMENT '订单金额',
  `price` decimal(10,2) unsigned NOT NULL COMMENT '充值金额',
  `diamond_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '钻石数量',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `hlb_order_no` varchar(50) NOT NULL COMMENT '合利宝订单编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `pay_status` (`pay_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8 COMMENT='钻石充值表';

#
# Structure for table "tx_live_diamond_log"
#

DROP TABLE IF EXISTS `tx_live_diamond_log`;
CREATE TABLE `tx_live_diamond_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '钻石流水ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `diamond_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '钻石数量',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.直播打赏 2.钻石充值',
  `reward_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '直播打赏ID（type-1）',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播打赏主播id（type-1）',
  `diamond_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '钻石充值ID（type-2）',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '钻石充值支付方式：1.微信 2.支付宝 3.苹果（type-2）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8 COMMENT='钻石流水记录表';

#
# Structure for table "tx_live_gd"
#

DROP TABLE IF EXISTS `tx_live_gd`;
CREATE TABLE `tx_live_gd` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '提现ID',
  `serial_number` varchar(32) NOT NULL DEFAULT '' COMMENT '提现流水号',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `source_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '提现来源ID',
  `source_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现类型：1.红包提现 2.贝壳提现 3.积分提现 4.股东(分发积分)',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝 4.银行卡',
  `shell_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提现贝壳数',
  `price` decimal(10,2) unsigned NOT NULL COMMENT '提现金额',
  `account_price` decimal(10,2) unsigned NOT NULL COMMENT '到账金额',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现状态：1.待处理 2.提现成功 3.提现失败 4.提现处理中 5.脚本处理中',
  `deal_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '处理时间',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `credit` decimal(10,2) DEFAULT NULL COMMENT '扣除积分(如股东发放,就增加积分)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `serial_number` (`serial_number`) USING BTREE,
  KEY `source_type` (`source_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=454 DEFAULT CHARSET=utf8 COMMENT='贝壳/红包提现表';

#
# Structure for table "tx_live_get_packet"
#

DROP TABLE IF EXISTS `tx_live_get_packet`;
CREATE TABLE `tx_live_get_packet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播领红包ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `get_price` decimal(10,2) unsigned NOT NULL COMMENT '领取金额',
  `give_packet_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '发红包ID',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `give_packet_id` (`give_packet_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='直播领红包表';

#
# Structure for table "tx_live_gift"
#

DROP TABLE IF EXISTS `tx_live_gift`;
CREATE TABLE `tx_live_gift` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '礼物ID',
  `gift_name` varchar(50) NOT NULL DEFAULT '' COMMENT '礼物名称',
  `diamond_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '钻石数量',
  `gift_icon` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '礼物图标',
  `gift_remind` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '礼物提醒',
  `gift_effects` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '动画特效',
  `gift_sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `operate_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '预处理状态：1列表显示，2列表隐藏',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `gift_name` (`gift_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='礼物表';

#
# Structure for table "tx_live_give_packet"
#

DROP TABLE IF EXISTS `tx_live_give_packet`;
CREATE TABLE `tx_live_give_packet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '发红包ID',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `pay_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '付款时间',
  `pay_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态：0未支付 1已支付 ',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：1.微信 2.支付宝',
  `trade_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '商户交易号',
  `order_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_price` decimal(10,2) unsigned NOT NULL COMMENT '订单金额',
  `packet_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '红包类型：1普通 2拼手气',
  `packet_price` decimal(10,2) unsigned NOT NULL COMMENT '红包金额',
  `packet_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '红包数量',
  `residue_price` decimal(10,2) unsigned NOT NULL COMMENT '剩余红包金额',
  `residue_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '剩余红包数量',
  `is_return` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否退回：0.未退回 1.已退回',
  `return_price` decimal(10,2) unsigned NOT NULL COMMENT '退回金额',
  `return_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退回时间',
  `get_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '领取类别：1.立即发送 2.倒计时',
  `get_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `pay_status` (`pay_status`) USING BTREE,
  KEY `packet_type` (`pay_type`) USING BTREE,
  KEY `is_return` (`is_return`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='直播发红包表';

#
# Structure for table "tx_live_goods"
#

DROP TABLE IF EXISTS `tx_live_goods`;
CREATE TABLE `tx_live_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播间商品ID',
  `live_id` int(10) NOT NULL DEFAULT '0' COMMENT '直播ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '主播id',
  `group_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '群组id',
  `shop_id` int(10) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sales_volume` int(10) NOT NULL DEFAULT '0' COMMENT '销售数量',
  `total_sales` decimal(12,2) NOT NULL COMMENT '销售额',
  `playback_sales_volume` int(10) NOT NULL DEFAULT '0' COMMENT '销售数量（回放）',
  `playback_total_sales` decimal(12,2) NOT NULL COMMENT '销售额（回放）',
  `start_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '开始类型：1.预告发起 2.直播发起',
  `explain_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '讲解状态：0未讲解 1讲解中 2已讲解',
  `sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(3) NOT NULL DEFAULT '1' COMMENT '前端是否显示：1显示 2隐藏',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `start_type` (`start_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8 COMMENT='直播间商品';

#
# Structure for table "tx_live_green_screen"
#

DROP TABLE IF EXISTS `tx_live_green_screen`;
CREATE TABLE `tx_live_green_screen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '绿幕ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `image` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '图片',
  `video` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '视频',
  `sort` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='绿幕表';

#
# Structure for table "tx_live_limit"
#

DROP TABLE IF EXISTS `tx_live_limit`;
CREATE TABLE `tx_live_limit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '受限ID',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '受限用户ID',
  `operator_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `is_silent` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否禁言：1正常 2禁言',
  `silent_time` int(10) NOT NULL DEFAULT '0' COMMENT '禁言变更时间',
  `is_kick` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否踢出：1正常 2踢出',
  `kick_time` int(10) NOT NULL DEFAULT '0' COMMENT '踢出变更时间',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `operator_id` (`operator_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='用户直播间受限表';

#
# Structure for table "tx_live_list"
#

DROP TABLE IF EXISTS `tx_live_list`;
CREATE TABLE `tx_live_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '主播id',
  `group_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '群组id',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `live_name` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间标题名称',
  `encode_live_name` varchar(1000) NOT NULL DEFAULT '' COMMENT '直播标题(16进制)',
  `live_cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间封面',
  `live_column` tinyint(3) NOT NULL DEFAULT '0' COMMENT '频道栏目：1.海贝(HB)直播 2.休闲娱乐 3.线上培训',
  `is_show_location` tinyint(3) NOT NULL DEFAULT '0' COMMENT '位置展示：1.开启 0.关闭',
  `is_find_location` tinyint(3) NOT NULL DEFAULT '0' COMMENT '位置查找：1.开启 0.关闭',
  `is_senior_live` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否高级直播：1.高级 0.普通',
  `live_background` varchar(255) NOT NULL DEFAULT '' COMMENT '直播背景',
  `shop_id` int(10) NOT NULL DEFAULT '0' COMMENT '店铺id',
  `notice_goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数（预告）',
  `notice_start_time` int(10) NOT NULL DEFAULT '0' COMMENT '开播时间（预告）',
  `goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数',
  `live_start_time` int(10) NOT NULL DEFAULT '0' COMMENT '直播开始时间',
  `start_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '开始类型：1.预告发起 2.直播发起',
  `live_end_time` int(10) NOT NULL DEFAULT '0' COMMENT '直播结束时间',
  `end_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '结束类型：1.主播关闭 2.平台关闭 3.网络掉线关闭',
  `live_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '直播间观看人数,最后在线',
  `now_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '直播观看人次',
  `like_num` int(10) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `virtual_live_num` int(10) NOT NULL DEFAULT '0' COMMENT '虚拟基础观看人数',
  `live_duration` int(10) NOT NULL DEFAULT '0' COMMENT '直播时长',
  `live_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '直播状态：1.直播中 2.结束 3.未开始 4.过期 5.删除',
  `lng` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '纬度',
  `province_id` int(10) NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int(10) NOT NULL DEFAULT '0' COMMENT '市id',
  `city_area` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '省市地址',
  `address` varchar(100) NOT NULL DEFAULT '' COMMENT '直播地址',
  `detailed_address` varchar(200) NOT NULL DEFAULT '' COMMENT '详细地址',
  `order_num` int(10) NOT NULL DEFAULT '0' COMMENT '订单数',
  `total_sales` decimal(12,2) NOT NULL COMMENT '销售额',
  `commission` decimal(12,2) NOT NULL COMMENT '直播佣金',
  `playback_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '回放观看人次',
  `playback_order_num` int(10) NOT NULL DEFAULT '0' COMMENT '回放订单数',
  `playback_total_sales` decimal(12,2) NOT NULL COMMENT '回放销售额',
  `is_show` tinyint(3) NOT NULL DEFAULT '1' COMMENT '展示状态(回放、预告)：1否 2是',
  `video_fileId` text COMMENT '云点播视频ID集合，逗号分割',
  `playback` varchar(200) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '视频地址',
  `is_video_post` tinyint(3) NOT NULL DEFAULT '0' COMMENT '视频是否合成：1已合成',
  `video_post_time` int(10) NOT NULL DEFAULT '0' COMMENT '视频合成时间',
  `task_id` varchar(200) DEFAULT NULL COMMENT '编辑视频ID',
  `qrcode_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码图片',
  `qrcode_token` varchar(100) NOT NULL DEFAULT '' COMMENT '二维码加密串',
  `live_see_member` int(10) NOT NULL DEFAULT '0' COMMENT '观看人数（全）',
  `give_packet_price` decimal(10,2) NOT NULL COMMENT '发红包金额',
  `give_packet_num` int(10) NOT NULL DEFAULT '0' COMMENT '发红包次数',
  `shell_num` int(10) NOT NULL DEFAULT '0' COMMENT '贝壳数量(新版本的积分）',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sun_num` int(10) DEFAULT '0' COMMENT '阳光值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `live_column` (`live_column`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `notice_start_time` (`notice_start_time`) USING BTREE,
  KEY `start_type` (`start_type`) USING BTREE,
  KEY `live_status` (`live_status`) USING BTREE,
  KEY `city_id` (`city_id`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `is_video_post` (`is_video_post`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8 COMMENT='直播列表信息';

#
# Structure for table "tx_live_list_copy1"
#

DROP TABLE IF EXISTS `tx_live_list_copy1`;
CREATE TABLE `tx_live_list_copy1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '主播id',
  `group_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '群组id',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `live_name` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间标题名称',
  `encode_live_name` varchar(1000) NOT NULL DEFAULT '' COMMENT '直播标题(16进制)',
  `live_cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间封面',
  `live_column` tinyint(3) NOT NULL DEFAULT '0' COMMENT '频道栏目：1.海贝(HB)直播 2.休闲娱乐 3.线上培训',
  `is_show_location` tinyint(3) NOT NULL DEFAULT '0' COMMENT '位置展示：1.开启 0.关闭',
  `is_find_location` tinyint(3) NOT NULL DEFAULT '0' COMMENT '位置查找：1.开启 0.关闭',
  `is_senior_live` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否高级直播：1.高级 0.普通',
  `live_background` varchar(255) NOT NULL DEFAULT '' COMMENT '直播背景',
  `shop_id` int(10) NOT NULL DEFAULT '0' COMMENT '店铺id',
  `notice_goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数（预告）',
  `notice_start_time` int(10) NOT NULL DEFAULT '0' COMMENT '开播时间（预告）',
  `goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数',
  `live_start_time` int(10) NOT NULL DEFAULT '0' COMMENT '直播开始时间',
  `start_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '开始类型：1.预告发起 2.直播发起',
  `live_end_time` int(10) NOT NULL DEFAULT '0' COMMENT '直播结束时间',
  `end_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '结束类型：1.主播关闭 2.平台关闭 3.网络掉线关闭',
  `live_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '直播间观看人数,最后在线',
  `now_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '直播观看人次',
  `like_num` int(10) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `virtual_live_num` int(10) NOT NULL DEFAULT '0' COMMENT '虚拟基础观看人数',
  `live_duration` int(10) NOT NULL DEFAULT '0' COMMENT '直播时长',
  `live_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '直播状态：1.直播中 2.结束 3.未开始 4.过期 5.删除',
  `lng` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '纬度',
  `province_id` int(10) NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int(10) NOT NULL DEFAULT '0' COMMENT '市id',
  `city_area` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '省市地址',
  `address` varchar(100) NOT NULL DEFAULT '' COMMENT '直播地址',
  `detailed_address` varchar(200) NOT NULL DEFAULT '' COMMENT '详细地址',
  `order_num` int(10) NOT NULL DEFAULT '0' COMMENT '订单数',
  `total_sales` decimal(12,2) NOT NULL COMMENT '销售额',
  `commission` decimal(12,2) NOT NULL COMMENT '直播佣金',
  `playback_see_num` int(10) NOT NULL DEFAULT '0' COMMENT '回放观看人次',
  `playback_order_num` int(10) NOT NULL DEFAULT '0' COMMENT '回放订单数',
  `playback_total_sales` decimal(12,2) NOT NULL COMMENT '回放销售额',
  `is_show` tinyint(3) NOT NULL DEFAULT '1' COMMENT '展示状态(回放、预告)：1否 2是',
  `video_fileId` text COMMENT '云点播视频ID集合，逗号分割',
  `playback` varchar(200) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '视频地址',
  `is_video_post` tinyint(3) NOT NULL DEFAULT '0' COMMENT '视频是否合成：1已合成',
  `video_post_time` int(10) NOT NULL DEFAULT '0' COMMENT '视频合成时间',
  `task_id` varchar(200) DEFAULT NULL COMMENT '编辑视频ID',
  `qrcode_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码图片',
  `qrcode_token` varchar(100) NOT NULL DEFAULT '' COMMENT '二维码加密串',
  `live_see_member` int(10) NOT NULL DEFAULT '0' COMMENT '观看人数（全）',
  `give_packet_price` decimal(10,2) NOT NULL COMMENT '发红包金额',
  `give_packet_num` int(10) NOT NULL DEFAULT '0' COMMENT '发红包次数',
  `shell_num` int(10) NOT NULL DEFAULT '0' COMMENT '贝壳数量',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `live_column` (`live_column`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `notice_start_time` (`notice_start_time`) USING BTREE,
  KEY `start_type` (`start_type`) USING BTREE,
  KEY `live_status` (`live_status`) USING BTREE,
  KEY `city_id` (`city_id`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `is_video_post` (`is_video_post`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播列表信息';

#
# Structure for table "tx_live_manage"
#

DROP TABLE IF EXISTS `tx_live_manage`;
CREATE TABLE `tx_live_manage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主播管理员关联表ID',
  `anchor_id` int(11) NOT NULL DEFAULT '0' COMMENT '主播id',
  `manage_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `manage_id` (`manage_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='主播管理员关联表';

#
# Structure for table "tx_live_manage_log"
#

DROP TABLE IF EXISTS `tx_live_manage_log`;
CREATE TABLE `tx_live_manage_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '管理员操作日志id',
  `operator_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `group_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '群组id',
  `live_id` int(10) NOT NULL DEFAULT '0' COMMENT '直播id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '被操作用户',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '操作类别：1.全平台管理 2.取消全平台管理 3.直播间管理 4.取消直播间管理 5禁言 6踢出直播间',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='管理员操作日志';

#
# Structure for table "tx_live_message"
#

DROP TABLE IF EXISTS `tx_live_message`;
CREATE TABLE `tx_live_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '群消息ID',
  `message` varchar(100) NOT NULL DEFAULT '' COMMENT '消息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='群消息表';

#
# Structure for table "tx_live_notice_remind"
#

DROP TABLE IF EXISTS `tx_live_notice_remind`;
CREATE TABLE `tx_live_notice_remind` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '开播提醒ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='直播预告开播提醒';

#
# Structure for table "tx_live_packet_log"
#

DROP TABLE IF EXISTS `tx_live_packet_log`;
CREATE TABLE `tx_live_packet_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '红包流水ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `price` decimal(10,2) unsigned NOT NULL COMMENT '金额',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.领红包 2.提现成功 3.提现失败 4申请',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝（type-2/3）4.银行卡',
  `give_packet_id` bigint(20) unsigned NOT NULL COMMENT '发红包ID（type-1）',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID（type-1）',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id（type-1）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='红包流水记录表';

#
# Structure for table "tx_live_report_log"
#

DROP TABLE IF EXISTS `tx_live_report_log`;
CREATE TABLE `tx_live_report_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播举报审核记录id',
  `report_id` int(11) NOT NULL COMMENT '举报id',
  `admin_id` int(11) NOT NULL COMMENT '管理员ID',
  `status` tinyint(1) NOT NULL COMMENT '2举报通过 3举报失败',
  `pass_reason` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '审核备注',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='直播举报审核记录';

#
# Structure for table "tx_live_reward"
#

DROP TABLE IF EXISTS `tx_live_reward`;
CREATE TABLE `tx_live_reward` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播打赏ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `gift_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '礼物ID',
  `gift_name` varchar(50) NOT NULL DEFAULT '' COMMENT '礼物名称',
  `diamond_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '钻石数量',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE,
  KEY `live_room_id` (`live_room_id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8 COMMENT='直播打赏记录表';

#
# Structure for table "tx_live_share"
#

DROP TABLE IF EXISTS `tx_live_share`;
CREATE TABLE `tx_live_share` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播分享记录ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `live_id` int(10) NOT NULL DEFAULT '0' COMMENT '直播ID',
  `live_room_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '直播间id',
  `live_token` varchar(100) NOT NULL DEFAULT '' COMMENT '二维码加密串',
  `qrcode_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码图片',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `live_token` (`live_token`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='直播分享记录表';

#
# Structure for table "tx_live_shell_log"
#

DROP TABLE IF EXISTS `tx_live_shell_log`;
CREATE TABLE `tx_live_shell_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '贝壳流水ID',
  `anchor_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主播id',
  `shell_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '贝壳数',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.直播打赏 2.提现 3.提现退回',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝（type-2/3）4.银行卡',
  `reward_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '直播打赏ID（type-1）',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '打赏用户id（type-1）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `anchor_id` (`anchor_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8 COMMENT='贝壳流水记录表';

#
# Structure for table "tx_live_shield"
#

DROP TABLE IF EXISTS `tx_live_shield`;
CREATE TABLE `tx_live_shield` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '屏蔽词ID',
  `word` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '屏蔽词',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1正常，2删除',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='屏蔽词汇';

#
# Structure for table "tx_live_tag"
#

DROP TABLE IF EXISTS `tx_live_tag`;
CREATE TABLE `tx_live_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播标签ID',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '标签名称',
  `image` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '标签图片',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类别：0系统添加 1数据库配置（不可修改删除）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播标签表';

#
# Structure for table "tx_live_viewing"
#

DROP TABLE IF EXISTS `tx_live_viewing`;
CREATE TABLE `tx_live_viewing` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播观看时长ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `viewing_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '观看时长',
  `date_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当天零点时间戳',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `c_time` (`c_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8 COMMENT='直播观看时长表';

#
# Structure for table "tx_live_watch"
#

DROP TABLE IF EXISTS `tx_live_watch`;
CREATE TABLE `tx_live_watch` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播观看ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `live_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直播ID',
  `live_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '直播状态：1.直播中 2.结束',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `live_id` (`live_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=726 DEFAULT CHARSET=utf8 COMMENT='直播观看记录表';

#
# Structure for table "tx_live_withdraw"
#

DROP TABLE IF EXISTS `tx_live_withdraw`;
CREATE TABLE `tx_live_withdraw` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '提现ID',
  `serial_number` varchar(32) NOT NULL DEFAULT '' COMMENT '提现流水号',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `source_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '提现来源ID',
  `source_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现类型：1.红包提现 2.贝壳提现 3.积分提现',
  `withdraw_way` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1.微信 2.支付宝 4.银行卡',
  `shell_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提现贝壳数',
  `price` decimal(10,2) unsigned NOT NULL COMMENT '提现金额',
  `account_price` decimal(10,2) unsigned NOT NULL COMMENT '到账金额',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现状态：1.待处理 2.提现成功 3.提现失败 4.提现处理中 5.脚本处理中6.失败已处理',
  `deal_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '处理时间',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `credit` decimal(10,2) DEFAULT NULL COMMENT '扣除积分(如股东发放,就增加积分)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `serial_number` (`serial_number`) USING BTREE,
  KEY `source_type` (`source_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=utf8 COMMENT='贝壳/红包提现表';

#
# Structure for table "tx_live_withdraw_config"
#

DROP TABLE IF EXISTS `tx_live_withdraw_config`;
CREATE TABLE `tx_live_withdraw_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '提现显示配置ID',
  `version_number` varchar(100) NOT NULL DEFAULT '' COMMENT '版本号',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '2' COMMENT '状态：1.显示 2.隐藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='提现显示配置表';

#
# Structure for table "tx_live_withdraw_log"
#

DROP TABLE IF EXISTS `tx_live_withdraw_log`;
CREATE TABLE `tx_live_withdraw_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '提现操作日志',
  `withdraw_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '提现ID',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `status` int(3) unsigned NOT NULL DEFAULT '0' COMMENT '提现状态：1.待处理 2.提现成功 3.提现失败 4提现退回',
  `reason` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '审核备注原因',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `withdraw_id` (`withdraw_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=416 DEFAULT CHARSET=utf8 COMMENT='提现操作日志';

#
# Structure for table "tx_maidian_log"
#

DROP TABLE IF EXISTS `tx_maidian_log`;
CREATE TABLE `tx_maidian_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '埋点类型1：启动APP 2：直播观看时长 3：转发小程序',
  `w_date` int(10) unsigned DEFAULT '0' COMMENT '记录时间 例：20201125',
  `num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '次数、观看时长（秒）等',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_member_id_type_w_date` (`member_id`,`type`,`w_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1366 DEFAULT CHARSET=utf8 COMMENT='埋点记录表';

#
# Structure for table "tx_member_coupons"
#

DROP TABLE IF EXISTS `tx_member_coupons`;
CREATE TABLE `tx_member_coupons` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '优惠券名称',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `shop_name` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '店铺名称',
  `p_ids` text COLLATE utf8_bin NOT NULL COMMENT '关联商品ID集合',
  `price` decimal(10,2) NOT NULL COMMENT '面额',
  `limit_price` decimal(10,2) NOT NULL COMMENT '优惠券使用门槛',
  `coupon_id` int(10) NOT NULL COMMENT '优惠券ID',
  `use_time` int(10) NOT NULL DEFAULT '0' COMMENT '使用时间',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `use` tinyint(1) DEFAULT '0' COMMENT '1：已使用',
  `oid` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '订单ID',
  `group_id` int(10) NOT NULL COMMENT '后台分组赠送ID',
  `create_time` int(10) NOT NULL COMMENT '领取时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7030 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='会员领取优惠券';

#
# Structure for table "tx_member_gift"
#

DROP TABLE IF EXISTS `tx_member_gift`;
CREATE TABLE `tx_member_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '用户赠品ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '赠品名称',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `order_id` int(10) NOT NULL DEFAULT '0' COMMENT '订单ID',
  `stock_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '库存名称',
  `sku` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT 'SKU',
  `sku_id` int(10) NOT NULL DEFAULT '0' COMMENT 'SKU ID',
  `sku_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT 'SKU名称',
  `sku_pic` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT 'SKU图片',
  `sku_price` decimal(10,2) DEFAULT NULL COMMENT 'SKU价钱',
  `num` int(10) NOT NULL COMMENT '数量',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `sku_id` (`sku_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户领取赠品表';

#
# Structure for table "tx_member_goddess"
#

DROP TABLE IF EXISTS `tx_member_goddess`;
CREATE TABLE `tx_member_goddess` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '女神卡充值ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `login_name` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '登录账号',
  `pay_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '付款时间',
  `pay_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态：0未支付 1已支付 ',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：1.微信 2.支付宝',
  `trade_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '商户交易号',
  `order_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `recharge_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '充值金额',
  `give_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '赠送金额',
  `experience_card` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '体验卡数量',
  `commission` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `version_no` varchar(30) NOT NULL DEFAULT '' COMMENT '版本号',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `pay_status` (`pay_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='女神卡充值表';

#
# Structure for table "tx_member_goddess_log"
#

DROP TABLE IF EXISTS `tx_member_goddess_log`;
CREATE TABLE `tx_member_goddess_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '女神卡流水记录ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '变动金额',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1.充值+ 2.消费- 3.退款+ 4.手动充值+',
  `goddess_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '女神卡充值ID（type-1）',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：1.微信 2.支付宝（type-1）',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID（type-2/type-3）',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='女神卡流水记录表';

#
# Structure for table "tx_member_login_log"
#

DROP TABLE IF EXISTS `tx_member_login_log`;
CREATE TABLE `tx_member_login_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '登录日志ID',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `login_ip` varchar(15) CHARACTER SET utf8mb4 NOT NULL COMMENT '登录ip',
  `city_info` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '省市地址',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=60958 DEFAULT CHARSET=utf8 COMMENT='用户登录日志';

#
# Structure for table "tx_member_mutual_fav"
#

DROP TABLE IF EXISTS `tx_member_mutual_fav`;
CREATE TABLE `tx_member_mutual_fav` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户相互关注ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `fav_member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关注用户id',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30159 DEFAULT CHARSET=utf8 COMMENT='用户相互关注表';

#
# Structure for table "tx_member_tag"
#

DROP TABLE IF EXISTS `tx_member_tag`;
CREATE TABLE `tx_member_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户标签表',
  `name` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '标签名',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父级ID',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1学历 2职业 3兴趣',
  `sort` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用 2禁用 3删除',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8 COMMENT='用户标签表';

#
# Structure for table "tx_member_tag_mapping"
#

DROP TABLE IF EXISTS `tx_member_tag_mapping`;
CREATE TABLE `tx_member_tag_mapping` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户标签关联表',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `tag_id` int(10) NOT NULL DEFAULT '0' COMMENT '标签ID',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类别：1学历 2职业 3兴趣',
  `c_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `tag_id` (`tag_id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2342 DEFAULT CHARSET=utf8 COMMENT='用户标签关联表';

#
# Structure for table "tx_new_commission"
#

DROP TABLE IF EXISTS `tx_new_commission`;
CREATE TABLE `tx_new_commission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '佣金V2',
  `channel` decimal(10,2) NOT NULL COMMENT '渠道',
  `operation` decimal(10,2) NOT NULL COMMENT '运营中心',
  `platform` decimal(10,2) NOT NULL COMMENT '平台',
  `new_retail` decimal(10,2) NOT NULL COMMENT '新零售',
  `one` decimal(10,2) NOT NULL,
  `two` decimal(10,2) NOT NULL,
  `three` decimal(10,2) NOT NULL,
  `four` decimal(10,2) NOT NULL,
  `recommend` decimal(10,2) DEFAULT NULL COMMENT '推荐佣金',
  `generation_community` decimal(10,2) DEFAULT NULL COMMENT '一代社区',
  `second_generation_community` decimal(10,2) DEFAULT NULL COMMENT '二代社会',
  `counter_subsidy` decimal(10,2) DEFAULT NULL COMMENT '专柜补贴',
  `v2_one` decimal(10,2) DEFAULT NULL COMMENT '一代专柜',
  `v2_two` decimal(10,2) DEFAULT NULL COMMENT '二代专柜',
  `v2_three` decimal(10,2) DEFAULT NULL COMMENT '直播',
  `v2_four` decimal(10,2) DEFAULT NULL COMMENT '社区',
  `commission_offline_one` decimal(10,2) NOT NULL COMMENT '商品佣金下线百分比',
  `commission_offline_two` decimal(10,2) NOT NULL COMMENT '商品佣金下线金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_new_flow"
#

DROP TABLE IF EXISTS `tx_new_flow`;
CREATE TABLE `tx_new_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `home_page_pv` int(10) NOT NULL COMMENT '首页的pv    number',
  `home_page_uv` int(10) NOT NULL COMMENT '首页的uv    num',
  `goods_class_pv` int(10) NOT NULL COMMENT '商品分类的pv',
  `goods_class_uv` int(10) NOT NULL,
  `goods_details_pv` int(10) NOT NULL COMMENT '商品详情',
  `goods_details_uv` int(10) NOT NULL,
  `live_pv` int(10) NOT NULL,
  `live_uv` int(10) NOT NULL,
  `addtime` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=554696 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_novice"
#

DROP TABLE IF EXISTS `tx_novice`;
CREATE TABLE `tx_novice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '标题',
  `picname` varchar(255) NOT NULL COMMENT '封面图',
  `content` text NOT NULL COMMENT '详情',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态 1开启2关闭',
  `addtime` int(11) NOT NULL,
  `savetime` int(11) NOT NULL DEFAULT '0',
  `sort` int(11) NOT NULL DEFAULT '999' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='新手指引';

#
# Structure for table "tx_order_estimate"
#

DROP TABLE IF EXISTS `tx_order_estimate`;
CREATE TABLE `tx_order_estimate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_estimate` int(11) NOT NULL COMMENT '订单预计多久发货',
  `hot_goods_num` int(10) DEFAULT '4' COMMENT '热销商品数量',
  `shop_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_order_first"
#

DROP TABLE IF EXISTS `tx_order_first`;
CREATE TABLE `tx_order_first` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `phone` varchar(11) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '手机号',
  `order_time` int(11) NOT NULL DEFAULT '0' COMMENT '首单时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE,
  KEY `order_time` (`order_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户首单表';

#
# Structure for table "tx_order_log"
#

DROP TABLE IF EXISTS `tx_order_log`;
CREATE TABLE `tx_order_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `order_id` int(10) NOT NULL COMMENT '订单ID',
  `operator` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '操作人',
  `order_status` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '订单状态',
  `pay_status` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '未支付' COMMENT '付款状态',
  `send_status` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '未发货' COMMENT '发货状态',
  `text` text COLLATE utf8_bin NOT NULL COMMENT '备注',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=238 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='订单操作记录表';

#
# Structure for table "tx_post_withdraw_log"
#

DROP TABLE IF EXISTS `tx_post_withdraw_log`;
CREATE TABLE `tx_post_withdraw_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID(type=23 主播id)',
  `invite_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '被邀请人ID（邀请任务完成需要添）',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '(积分类型)\\r\\n20推广红包 \\r\\n21助农红包\\r\\n22社区长红包\\r\\n23直播打赏积分\\r\\n 7提现成功(失败) 6申请提现',
  `channel` int(3) NOT NULL DEFAULT '0' COMMENT '领取途径',
  `gear` int(2) NOT NULL DEFAULT '0' COMMENT '任务档位',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '海星数量 (积分)',
  `title` varchar(200) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '积分描述',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  `reward_id` int(10) NOT NULL DEFAULT '0' COMMENT '直播打赏ID(type=23)',
  `reward_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '打赏人ID(type=23)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `channel` (`channel`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='提现申请日志';

#
# Structure for table "tx_receiving_address"
#

DROP TABLE IF EXISTS `tx_receiving_address`;
CREATE TABLE `tx_receiving_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '地址名称',
  `username` varchar(50) NOT NULL COMMENT '收货人姓名',
  `phone` varchar(20) NOT NULL COMMENT '联系电话',
  `province` int(11) NOT NULL COMMENT '省',
  `city` int(11) NOT NULL COMMENT '市',
  `area` int(11) NOT NULL COMMENT '区',
  `address` text CHARACTER SET utf32 NOT NULL COMMENT '详细地址',
  `status` int(255) NOT NULL DEFAULT '1' COMMENT '1启用2不启用',
  `type` int(255) NOT NULL DEFAULT '2' COMMENT '1默认2非默认',
  `shop_id` int(11) NOT NULL,
  `addtime` int(11) NOT NULL,
  `province_name` varchar(255) NOT NULL,
  `city_name` varchar(255) NOT NULL,
  `area_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_recommend_goods"
#

DROP TABLE IF EXISTS `tx_recommend_goods`;
CREATE TABLE `tx_recommend_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品推荐ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `clicks` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `order_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单数',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='商品推荐';

#
# Structure for table "tx_recommend_synthesis"
#

DROP TABLE IF EXISTS `tx_recommend_synthesis`;
CREATE TABLE `tx_recommend_synthesis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '多功能推送ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '消息标题',
  `content` varchar(200) NOT NULL DEFAULT '' COMMENT '消息内容',
  `img` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '图片',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `ad_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '关联类型：1无关联 2链接 3商品 4直播间 5店铺 6VIP礼包列表',
  `redirect_url` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '跳转地址或ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1开启 2关闭 3删除',
  `clicks` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `order_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单数',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ad_type` (`ad_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COMMENT='多功能推送';

#
# Structure for table "tx_reconciliation"
#

DROP TABLE IF EXISTS `tx_reconciliation`;
CREATE TABLE `tx_reconciliation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL COMMENT '对账店铺',
  `time` varchar(255) NOT NULL COMMENT '202005   时间',
  `addtime` int(11) NOT NULL COMMENT '对账时间',
  `status` int(11) NOT NULL COMMENT '1对账金额 2对账销量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='对账表';

#
# Structure for table "tx_reconciliation_operation_record"
#

DROP TABLE IF EXISTS `tx_reconciliation_operation_record`;
CREATE TABLE `tx_reconciliation_operation_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL COMMENT '订单id',
  `content` text NOT NULL,
  `shop_id` int(11) NOT NULL COMMENT '店铺id',
  `addtime` int(11) NOT NULL,
  `total_price` decimal(10,0) NOT NULL COMMENT '对账金额',
  `order_no` char(30) NOT NULL COMMENT '订单编号',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1付款的2退款的',
  `admin` char(20) NOT NULL COMMENT '操作这',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='对账提现记录';

#
# Structure for table "tx_red_bag_member"
#

DROP TABLE IF EXISTS `tx_red_bag_member`;
CREATE TABLE `tx_red_bag_member` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当前红包余额',
  `price_all` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '红包总收入',
  `price_use` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '使用了多少红包',
  `price_freeze` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '冻结金额',
  `task_num` int(10) NOT NULL DEFAULT '0' COMMENT '完成任务数量',
  `remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '签到提醒 0：关闭  1：开启',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间戳',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6448 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户红包汇总表';

#
# Structure for table "tx_return_goods"
#

DROP TABLE IF EXISTS `tx_return_goods`;
CREATE TABLE `tx_return_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `return_no` varchar(50) NOT NULL COMMENT '退货单号',
  `order_no` varchar(50) NOT NULL COMMENT '订单单号',
  `uid` int(11) NOT NULL COMMENT '会员ID',
  `shop_id` int(11) NOT NULL COMMENT '店铺ID',
  `oiid` int(11) NOT NULL COMMENT '子订单ID',
  `oid` int(11) NOT NULL COMMENT '订单ID',
  `gid` int(11) NOT NULL COMMENT '商品ID',
  `link_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品属性ID',
  `goods_name` varchar(100) NOT NULL COMMENT '商品名称',
  `goods_pic` varchar(100) NOT NULL COMMENT '商品图片',
  `member_name` varchar(100) NOT NULL COMMENT '用户帐号',
  `price` decimal(10,2) NOT NULL COMMENT '订单商品总计',
  `refund_price` decimal(10,2) NOT NULL COMMENT '退款金额',
  `refund_freight` decimal(10,2) NOT NULL COMMENT '退回的运费',
  `rg_num` int(11) NOT NULL COMMENT '退回数量',
  `type` int(1) NOT NULL COMMENT '1 退货 2 退款 3 换货',
  `photo` text NOT NULL COMMENT '图片',
  `name` char(50) NOT NULL COMMENT '联系人',
  `tel` char(50) NOT NULL COMMENT '联系电话',
  `reason` varchar(500) NOT NULL COMMENT '退货原因',
  `reason_id` int(11) NOT NULL COMMENT '退货原因ID',
  `refund_explain` varchar(500) NOT NULL COMMENT '问题描述',
  `feedback` varchar(500) NOT NULL COMMENT '回馈',
  `apply_is_receive_goods` int(11) NOT NULL DEFAULT '0' COMMENT '我要退款（无需退货） 有物流状态时有值  1  未收到货 2 已收到货',
  `sub_time` int(11) NOT NULL COMMENT '提交时间',
  `sub_date` int(11) NOT NULL COMMENT '申请日期',
  `deal_time` int(11) NOT NULL COMMENT '通过或驳回时间',
  `seller_send_time` int(11) NOT NULL COMMENT '卖家发货时间',
  `seller_receive_time` int(11) NOT NULL COMMENT '卖家收到货物时间',
  `buyer_send_time` int(11) NOT NULL COMMENT '买家寄出货物时间',
  `buyer_receive_time` int(10) NOT NULL COMMENT '买家收到换回货物的确认时间',
  `status` int(11) NOT NULL COMMENT '状态 1待处理  2退货中  3换货中  4已完成   5已拒绝',
  `seller_is_send_address` int(11) NOT NULL COMMENT '卖家是否发送地址到买家  1  已发送 0 未发送',
  `change_deliver_no` varchar(50) NOT NULL COMMENT '换货物流单号（卖家发到买家的物流）',
  `change_deliver_company` varchar(20) NOT NULL COMMENT '换货物流公司（卖家发到买家的物流）',
  `change_deliver_com` varchar(50) NOT NULL COMMENT '快递公司编码,一律用小写字母（卖家发到买家的物流）',
  `seller_is_receive_goods` int(11) NOT NULL COMMENT '卖家是否收到货 1 已收到 0 未收到',
  `seller_receive_province` varchar(30) NOT NULL COMMENT '卖家收货省（退换货用）',
  `seller_receive_city` varchar(30) NOT NULL COMMENT '卖家收货市',
  `seller_receive_area` varchar(30) NOT NULL COMMENT '卖家收货区',
  `seller_receive_address` varchar(500) NOT NULL COMMENT '卖家收货详细地址',
  `seller_receive_name` varchar(20) NOT NULL COMMENT '卖家收货人',
  `seller_receive_tel` varchar(15) NOT NULL COMMENT '卖家收货电话',
  `buyer_is_send` int(11) NOT NULL COMMENT '买家是否寄出货物 0 未寄出 1 已寄出',
  `buyer_deliver_company` varchar(50) NOT NULL COMMENT '物流公司（买家寄到卖家物流）',
  `buyer_deliver_no` varchar(50) NOT NULL COMMENT '物流单号（买家寄到卖家物流）',
  `buyer_deliver_com` varchar(50) NOT NULL COMMENT '快递公司编码,一律用小写字母（买家寄到卖家物流）',
  `change_deliver_fee` decimal(11,2) NOT NULL COMMENT '换货运费',
  `is_refund` int(11) NOT NULL COMMENT '是否已经退款 0 未退款 1 已退款',
  `buyer_is_read` int(11) NOT NULL COMMENT '买家是否已读 0 未读 1 已读',
  `seller_is_read` int(11) NOT NULL COMMENT '卖家是否已读 0 未读 1 已读',
  `seller_all_read` int(11) NOT NULL COMMENT '卖家是否全部已读 0 否 1 是',
  `reason_reject` text NOT NULL COMMENT '驳回原因',
  `freight_id` int(11) NOT NULL DEFAULT '0' COMMENT '运费模版ID',
  `return_freight_status` int(1) DEFAULT '0' COMMENT '退换货运费支付状态 1支付 0 未支付',
  `order_type` int(1) NOT NULL DEFAULT '0' COMMENT '订单类型 1自营 2三方 3VIP 4新人 5女性 6体验',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `oiid` (`oiid`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `gid` (`gid`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `return_no` (`return_no`) USING BTREE,
  KEY `order_type` (`order_type`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='退款退货换货表 -- 现使用';

#
# Structure for table "tx_return_log"
#

DROP TABLE IF EXISTS `tx_return_log`;
CREATE TABLE `tx_return_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `return_id` int(10) NOT NULL COMMENT '申请ID',
  `operator` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '处理人员',
  `text` text COLLATE utf8_bin NOT NULL COMMENT '处理备注',
  `create_time` int(10) NOT NULL COMMENT '处理时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `return_id` (`return_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='退货、退款、换货操作记录表';

#
# Structure for table "tx_search_base"
#

DROP TABLE IF EXISTS `tx_search_base`;
CREATE TABLE `tx_search_base` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT '搜索名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1857 DEFAULT CHARSET=utf8 COMMENT='统计 搜索关键词';

#
# Structure for table "tx_search_item"
#

DROP TABLE IF EXISTS `tx_search_item`;
CREATE TABLE `tx_search_item` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `search_id` int(11) NOT NULL,
  `number` int(11) NOT NULL COMMENT '搜素的结果',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `search_id` (`search_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18555 DEFAULT CHARSET=utf8 COMMENT='统计搜素 子表';

#
# Structure for table "tx_seckill"
#

DROP TABLE IF EXISTS `tx_seckill`;
CREATE TABLE `tx_seckill` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '秒杀活动ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '秒杀活动名称',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数量',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '秒刷活动状态 1：启用  2：禁用',
  `use` int(1) NOT NULL DEFAULT '0' COMMENT '1：已在线  2：未在线',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1：删除',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `push_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '推送时间',
  `seckill_index_id` int(10) NOT NULL DEFAULT '0' COMMENT '主活动ID',
  `remind_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '推送状态 1：已推送 0：未推送',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `remind_status` (`remind_status`) USING BTREE,
  KEY `seckill_index_id` (`seckill_index_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀活动表';

#
# Structure for table "tx_seckill_goods"
#

DROP TABLE IF EXISTS `tx_seckill_goods`;
CREATE TABLE `tx_seckill_goods` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `seckill_id` int(10) NOT NULL COMMENT '秒杀活动ID',
  `goods_id` int(10) NOT NULL COMMENT '商品ID',
  `link_id` int(10) NOT NULL COMMENT '商品一级属性ID',
  `attr1` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '属性1',
  `attr2` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '属性2',
  `goods_pic` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '商品主图',
  `link_price` decimal(10,2) NOT NULL COMMENT '普通会员价',
  `vip_price` decimal(10,2) NOT NULL COMMENT 'vip价',
  `seckill_price` decimal(10,2) NOT NULL COMMENT '秒杀价',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '秒杀数量',
  `limit_num` int(10) NOT NULL COMMENT '限购数量',
  `commission` decimal(10,2) NOT NULL COMMENT '佣金',
  `live_commission` decimal(10,2) NOT NULL COMMENT '直播佣金',
  `share` decimal(10,2) NOT NULL COMMENT '分享佣金',
  `one` decimal(10,2) NOT NULL,
  `two` decimal(10,2) NOT NULL,
  `three` decimal(10,2) NOT NULL,
  `four` decimal(10,2) NOT NULL,
  `five` decimal(10,2) NOT NULL,
  `six` decimal(10,2) NOT NULL,
  `seven` decimal(10,2) NOT NULL,
  `eight` decimal(10,2) NOT NULL,
  `nine` decimal(10,2) NOT NULL,
  `ten` decimal(10,2) NOT NULL,
  `eleven` decimal(10,2) NOT NULL,
  `twelve` decimal(10,2) NOT NULL,
  `isvip` int(10) NOT NULL COMMENT '是否vip 1：vip 2：全部',
  `Version_No` int(10) NOT NULL DEFAULT '0' COMMENT '原商品版本号',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1：删除',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `live_commission_v2` decimal(10,2) NOT NULL COMMENT '直播佣金  v2',
  `goods_commission` decimal(10,2) NOT NULL COMMENT '商品佣金',
  `use` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品是否上线',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `start_time` (`live_commission`) USING BTREE,
  KEY `end_time` (`isvip`) USING BTREE,
  KEY `name` (`goods_pic`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE,
  KEY `use` (`use`) USING BTREE,
  KEY `seckill_id` (`seckill_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀活动产品关联表';

#
# Structure for table "tx_seckill_index"
#

DROP TABLE IF EXISTS `tx_seckill_index`;
CREATE TABLE `tx_seckill_index` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '秒杀活动ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '秒杀活动名称',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数量',
  `start_time` int(10) NOT NULL COMMENT '开始时间',
  `end_time` int(10) NOT NULL COMMENT '结束时间',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '秒刷活动状态 1：启用  2：禁用',
  `use` int(1) NOT NULL DEFAULT '0' COMMENT '1：已在线  2：未在线',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1：删除',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀活动主表';

#
# Structure for table "tx_seckill_member"
#

DROP TABLE IF EXISTS `tx_seckill_member`;
CREATE TABLE `tx_seckill_member` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '秒杀活动ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `seckill_id` int(10) NOT NULL DEFAULT '0' COMMENT '秒杀ID',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `seckill_id` (`seckill_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀商品提醒表';

#
# Structure for table "tx_seckill_relation"
#

DROP TABLE IF EXISTS `tx_seckill_relation`;
CREATE TABLE `tx_seckill_relation` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '秒杀活动ID',
  `seckill_id` int(10) NOT NULL DEFAULT '0' COMMENT '秒杀ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `link_id` int(10) NOT NULL DEFAULT '0' COMMENT '属性ID',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `seckill_id` (`seckill_id`) USING BTREE,
  KEY `link_id` (`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='秒杀商品关联表';

#
# Structure for table "tx_send_sms"
#

DROP TABLE IF EXISTS `tx_send_sms`;
CREATE TABLE `tx_send_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `mobile` char(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '短信内容',
  `code` char(8) NOT NULL DEFAULT '' COMMENT '验证码',
  `is_succeed` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否发送成功 1:失败 2:成功',
  `sms_response` text COMMENT '短信接口请求结果',
  `sms_error` char(50) NOT NULL DEFAULT '' COMMENT '短信接口请求结果 status 具体原因 ',
  `sms_result` char(20) NOT NULL DEFAULT '' COMMENT '短信接口请求结果 result 短信提交错误具体原因 ',
  `response_error` text COMMENT '请求短信接口错误',
  `response_info` text COMMENT '请求短信接口信息',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '短信类型 1:验证码 2:通知 3.其他',
  `is_used` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否使用 1:未使用 2:已使用',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '请求时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_mobile_is_succeed_type_is_used` (`mobile`,`is_succeed`,`type`,`is_used`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=771 DEFAULT CHARSET=utf8 COMMENT='短信表';

#
# Structure for table "tx_set_goods"
#

DROP TABLE IF EXISTS `tx_set_goods`;
CREATE TABLE `tx_set_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `explains` varchar(255) NOT NULL COMMENT '说明',
  `details` text COMMENT '详情',
  `status` int(255) NOT NULL DEFAULT '1' COMMENT '启用状态1 2',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  `sort` int(255) NOT NULL DEFAULT '1' COMMENT '排序',
  `type` int(11) NOT NULL COMMENT '1商品说明2常见问题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_set_reason"
#

DROP TABLE IF EXISTS `tx_set_reason`;
CREATE TABLE `tx_set_reason` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '原因',
  `parent_id` int(255) NOT NULL COMMENT '父id',
  `status` int(10) NOT NULL DEFAULT '1' COMMENT '1显示2不显示   12 售后 34 举报 56反馈',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_share_official_pictures"
#

DROP TABLE IF EXISTS `tx_share_official_pictures`;
CREATE TABLE `tx_share_official_pictures` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `base_member_id` int(11) NOT NULL COMMENT '分享人',
  `addtime` int(11) NOT NULL COMMENT '分享时间',
  `date_time` int(11) NOT NULL DEFAULT '0' COMMENT '分享日期 时间戳',
  `find_id` int(11) NOT NULL COMMENT '分享图文id',
  `ciphertext` char(11) NOT NULL COMMENT '密令',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `tx_share_official_pictures` (`ciphertext`) USING BTREE,
  KEY `addtime` (`addtime`) USING BTREE,
  KEY `date_time` (`date_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10131 DEFAULT CHARSET=utf8 COMMENT='谁分享了官方图文';

#
# Structure for table "tx_shareholder_info"
#

DROP TABLE IF EXISTS `tx_shareholder_info`;
CREATE TABLE `tx_shareholder_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `stage` tinyint(1) NOT NULL DEFAULT '1' COMMENT '阶段',
  `shares_num` int(11) NOT NULL DEFAULT '0' COMMENT '当前股份数量',
  `begin_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始分红时间',
  `finish_time` int(11) NOT NULL DEFAULT '0' COMMENT '成为股东时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '身份（月亮花会员）1是0否',
  PRIMARY KEY (`id`),
  KEY `member` (`member_id`) USING BTREE,
  KEY `stage` (`stage`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='股东信息表';

#
# Structure for table "tx_shares_log"
#

DROP TABLE IF EXISTS `tx_shares_log`;
CREATE TABLE `tx_shares_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `shares_price` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '每股价格【购买当时的股价】',
  `stage` tinyint(1) NOT NULL DEFAULT '1' COMMENT '阶段',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0,完成计划1,送股2,交易',
  `current_num` int(11) NOT NULL DEFAULT '0' COMMENT '现有股份',
  `modify_num` int(11) NOT NULL DEFAULT '0' COMMENT '变更股份',
  `old_num` int(11) NOT NULL DEFAULT '0' COMMENT '原有股份',
  `modify_time` int(11) NOT NULL DEFAULT '0' COMMENT '变更时间',
  `admin_id` varchar(20) NOT NULL DEFAULT '' COMMENT '后台管理员',
  `ip` varchar(32) NOT NULL DEFAULT '' COMMENT 'IP',
  `remark` varchar(150) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `member` (`member_id`) USING BTREE,
  KEY `stage` (`stage`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COMMENT='股份流水表';

#
# Structure for table "tx_shop_base"
#

DROP TABLE IF EXISTS `tx_shop_base`;
CREATE TABLE `tx_shop_base` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `shop_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '店铺名称',
  `type` int(1) NOT NULL COMMENT '店铺类型 1：自营店 2：三方店',
  `level1` int(10) NOT NULL COMMENT '店铺一级类目',
  `level2` int(10) NOT NULL COMMENT '店铺二级类目',
  `shop_headimage` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '店铺头像',
  `cover_image` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '封面图',
  `top_image` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '新版封面图',
  `contact_name` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '联系人',
  `contact_phone` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '联系方式',
  `introduction` text COLLATE utf8_bin NOT NULL COMMENT '店铺介绍',
  `official` int(1) NOT NULL DEFAULT '0' COMMENT '官方认证',
  `bond` int(1) NOT NULL DEFAULT '0' COMMENT '保证金',
  `seven_days` int(1) NOT NULL DEFAULT '0' COMMENT '7天无理由',
  `descr_consis` decimal(3,1) NOT NULL COMMENT '描述相符',
  `logistics_service` decimal(3,1) NOT NULL COMMENT '物流服务',
  `service_attitude` decimal(3,1) NOT NULL COMMENT '服务态度',
  `score` decimal(3,1) NOT NULL COMMENT '店铺总分',
  `goods_num` int(10) NOT NULL DEFAULT '0' COMMENT '商品数量',
  `goods_status_num` int(10) NOT NULL DEFAULT '0' COMMENT '正常上架的商品数量',
  `comments_num` int(10) NOT NULL DEFAULT '0' COMMENT '评论数量',
  `sale_num` int(10) NOT NULL DEFAULT '0' COMMENT '销售数量',
  `fans_num` int(10) NOT NULL DEFAULT '0' COMMENT '粉丝数量',
  `sale_money` decimal(10,2) NOT NULL COMMENT '总销售金额（元）',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `tui` int(1) NOT NULL DEFAULT '0' COMMENT '店铺推荐',
  `dgj` int(1) NOT NULL DEFAULT '0' COMMENT '是否接入店管家 1：已接入 2：未接入',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '店铺状态 1:开启 2:禁止',
  `admin` int(1) NOT NULL DEFAULT '0' COMMENT '总管理员店铺 1：总后台管理  0：子后台管理',
  `join_time` int(10) NOT NULL COMMENT '入驻时间',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `cumulative_reconciliation` decimal(10,2) NOT NULL COMMENT '累计对账金额',
  `return_cumulative_reconciliation` decimal(10,2) NOT NULL COMMENT '累计对账金额(退款)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `level1` (`level1`) USING BTREE,
  KEY `level2` (`level2`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `contact_name` (`contact_name`) USING BTREE,
  KEY `contact_phone` (`contact_phone`) USING BTREE,
  KEY `join_time` (`join_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺表';

#
# Structure for table "tx_shop_category"
#

DROP TABLE IF EXISTS `tx_shop_category`;
CREATE TABLE `tx_shop_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '类目名称',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父类ID',
  `level` int(1) NOT NULL COMMENT '类目级别',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '状态 1正常 2禁用 3删除 ',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `level` (`level`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺类目表';

#
# Structure for table "tx_shop_class"
#

DROP TABLE IF EXISTS `tx_shop_class`;
CREATE TABLE `tx_shop_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(90) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '分类名称',
  `shop_id` int(10) NOT NULL COMMENT '店铺ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父类ID',
  `level` int(1) NOT NULL COMMENT '分类级别',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '状态 1正常 2禁用 3删除 ',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `level` (`level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺分类表';

#
# Structure for table "tx_shop_class_relation"
#

DROP TABLE IF EXISTS `tx_shop_class_relation`;
CREATE TABLE `tx_shop_class_relation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `shop_id` int(10) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `level1` int(10) NOT NULL COMMENT '一级分类ID',
  `level2` int(10) NOT NULL COMMENT '二级分类ID',
  `goods_id` int(10) NOT NULL COMMENT '商品ID',
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `level1` (`level1`) USING BTREE,
  KEY `level2` (`level2`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺商品分类关联表';

#
# Structure for table "tx_shop_flow"
#

DROP TABLE IF EXISTS `tx_shop_flow`;
CREATE TABLE `tx_shop_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL,
  `shop_pv` int(11) NOT NULL,
  `shop_uv` int(11) NOT NULL,
  `addtime` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_shop_member"
#

DROP TABLE IF EXISTS `tx_shop_member`;
CREATE TABLE `tx_shop_member` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '店铺用户关联ID',
  `member_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `shop_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺id',
  `c_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `u_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `shop_id` (`shop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='店铺用户关联表';

#
# Structure for table "tx_shop_notice"
#

DROP TABLE IF EXISTS `tx_shop_notice`;
CREATE TABLE `tx_shop_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content` text COMMENT '公告内容',
  `savetime` int(11) NOT NULL,
  `status` int(255) NOT NULL DEFAULT '1' COMMENT '1显示2记录',
  `operator` varchar(255) NOT NULL COMMENT '操作者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_shop_score"
#

DROP TABLE IF EXISTS `tx_shop_score`;
CREATE TABLE `tx_shop_score` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `field` varchar(255) NOT NULL COMMENT '栏位',
  `min` decimal(10,2) NOT NULL,
  `max` decimal(10,2) NOT NULL,
  `savetime` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT=' 店铺评分  （设置里面）';

#
# Structure for table "tx_shop_verify"
#

DROP TABLE IF EXISTS `tx_shop_verify`;
CREATE TABLE `tx_shop_verify` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `member_account` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '用户帐号',
  `contact_name` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '联系人',
  `contact_phone` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '联系方式',
  `shop_name` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '店铺名称',
  `shop_type` int(1) NOT NULL COMMENT '店铺类型 1:旗舰店 2:专卖店 3:专营店',
  `level1` int(10) NOT NULL COMMENT '经营类目（一级类目）',
  `brand` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '店铺品牌',
  `pic1` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '图片1',
  `pic2` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '图片2',
  `pic3` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '图片3',
  `link_add` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '网站地址',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '审核状态 1:待审核 2:已通过 3:已拒绝',
  `text` text COLLATE utf8_bin COMMENT '审核备注',
  `verify_member` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '审核人帐号',
  `verify_time` int(10) DEFAULT NULL COMMENT '审核时间',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `contact_name` (`contact_name`) USING BTREE,
  KEY `contact_phone` (`contact_phone`) USING BTREE,
  KEY `shop_type` (`shop_type`) USING BTREE,
  KEY `level1` (`level1`) USING BTREE,
  KEY `member_account` (`member_account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺审核表';

#
# Structure for table "tx_shop_verify_log"
#

DROP TABLE IF EXISTS `tx_shop_verify_log`;
CREATE TABLE `tx_shop_verify_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `operator` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '操作人账号',
  `text` text COLLATE utf8_bin COMMENT '操作记录',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺审核日志表';

#
# Structure for table "tx_shop_verify_new"
#

DROP TABLE IF EXISTS `tx_shop_verify_new`;
CREATE TABLE `tx_shop_verify_new` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `member_id` int(10) NOT NULL COMMENT '会员ID',
  `contact_name` varchar(50) COLLATE utf8_bin DEFAULT '' COMMENT '联系人',
  `contact_phone` varchar(50) COLLATE utf8_bin DEFAULT '' COMMENT '联系方式',
  `shop_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '店铺名称',
  `shop_type` int(1) DEFAULT NULL COMMENT '店铺类型 1:旗舰店 2:专卖店 3:专营店',
  `level1` int(10) DEFAULT NULL COMMENT '经营类目（一级类目）',
  `shop_introduce` text COLLATE utf8_bin COMMENT '店铺简介',
  `zz_photo` longtext COLLATE utf8_bin COMMENT '资质信息',
  `auth_type` int(1) DEFAULT NULL COMMENT '认证方式：1法定代表人认证  2代理人认证',
  `sfz_photo` longtext COLLATE utf8_bin COMMENT '身份证照片',
  `sfz_agent_photo` longtext COLLATE utf8_bin COMMENT '代理身份证照片',
  `warrant_photo` longtext COLLATE utf8_bin COMMENT '代理授权书照片',
  `license_photo` text COLLATE utf8_bin COMMENT '营业执照',
  `bank_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '银行名称',
  `bank_open` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '开户行',
  `bank_card` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '银行卡号',
  `brand` longtext COLLATE utf8_bin COMMENT '品牌',
  `brand_num` int(10) DEFAULT '0' COMMENT '品牌数量',
  `status` int(1) DEFAULT '0' COMMENT '审核状态 0:保存未提交1:待审核 2:已通过 3:已拒绝',
  `shop_id` int(1) DEFAULT '0' COMMENT '审核通过关联的店铺ID',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `contact_name` (`contact_name`) USING BTREE,
  KEY `contact_phone` (`contact_phone`) USING BTREE,
  KEY `shop_type` (`shop_type`) USING BTREE,
  KEY `level1` (`level1`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `auth_type` (`auth_type`) USING BTREE,
  KEY `brand_num` (`brand_num`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='店铺审核表';

#
# Structure for table "tx_shortcut_button"
#

DROP TABLE IF EXISTS `tx_shortcut_button`;
CREATE TABLE `tx_shortcut_button` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '按钮名称',
  `ad_site` int(11) NOT NULL DEFAULT '1' COMMENT '显示位置  1首页 2专柜',
  `redirect_url` varchar(255) DEFAULT NULL COMMENT '跳转地址',
  `picname` varchar(255) NOT NULL COMMENT '图片路径',
  `content` text COMMENT '按钮描述',
  `ad_type` int(11) NOT NULL DEFAULT '0' COMMENT '关联类型：1无关联 2链接 3商品 4直播间 5店铺 6VIP礼包列表',
  `addtime` int(11) NOT NULL COMMENT '添加时间',
  `savetime` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` int(11) DEFAULT '1' COMMENT '是否启用 启用1 ',
  `sort` int(255) DEFAULT '999' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_starfish"
#

DROP TABLE IF EXISTS `tx_starfish`;
CREATE TABLE `tx_starfish` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID',
  `phone` varchar(11) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '手机号',
  `price` int(10) NOT NULL DEFAULT '0' COMMENT '领取海星数量',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '完成的件数 条数 次数',
  `channel` int(3) NOT NULL COMMENT '领取途径',
  `task_type` int(1) NOT NULL COMMENT '任务类型 1单次任务 2每日重置 3完成重置',
  `gear` int(2) NOT NULL DEFAULT '0' COMMENT '任务档位',
  `get_day` int(11) NOT NULL COMMENT '领取日期时间戳',
  `get_time` int(11) NOT NULL COMMENT '领取时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `channel` (`channel`) USING BTREE,
  KEY `stak_type` (`task_type`) USING BTREE,
  KEY `get_day` (`get_day`) USING BTREE,
  KEY `get_time` (`get_time`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10907 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='海星领取数据表';

#
# Structure for table "tx_starfish_config"
#

DROP TABLE IF EXISTS `tx_starfish_config`;
CREATE TABLE `tx_starfish_config` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '标题名称',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '兑换比例的海星币数量',
  `get_day` int(10) NOT NULL DEFAULT '0' COMMENT '领取日期时间戳',
  `get_time` int(10) NOT NULL DEFAULT '0' COMMENT '领取时间时间戳',
  `all_price` decimal(10,2) NOT NULL COMMENT '总金额',
  `get_price` decimal(10,2) NOT NULL COMMENT '领取金额',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1：可领取  2：不可领取',
  `create_time` int(11) NOT NULL COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `get_day` (`get_day`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='海星设置表';

#
# Structure for table "tx_starfish_config_gear"
#

DROP TABLE IF EXISTS `tx_starfish_config_gear`;
CREATE TABLE `tx_starfish_config_gear` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `config_id` int(10) NOT NULL DEFAULT '0' COMMENT '设置ID',
  `price` int(11) NOT NULL DEFAULT '0' COMMENT '人民币',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '次数',
  `use_num` int(11) NOT NULL DEFAULT '0' COMMENT '领取次数',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `config_id` (`config_id`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='海星设置档位表';

#
# Structure for table "tx_starfish_day"
#

DROP TABLE IF EXISTS `tx_starfish_day`;
CREATE TABLE `tx_starfish_day` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `price` int(10) NOT NULL COMMENT '海星总量',
  `get_day` int(11) NOT NULL COMMENT '领取日期时间戳',
  `update_time` int(11) NOT NULL COMMENT '更新时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `get_day` (`get_day`) USING BTREE,
  KEY `update_time` (`update_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=79252 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='日排行列表';

#
# Structure for table "tx_starfish_log"
#

DROP TABLE IF EXISTS `tx_starfish_log`;
CREATE TABLE `tx_starfish_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID(type=23 主播id)',
  `invite_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '被邀请人ID（邀请任务完成需要添）',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '(积分类型) 7提现成功(失败) 6申请提现 20推广积分 21助农积分 22社区积分  23直播打赏 24商品佣金推荐人 25商品佣金社区长  26商品佣金主播 27股东分红',
  `channel` int(3) NOT NULL DEFAULT '0' COMMENT '领取途径',
  `gear` int(2) NOT NULL DEFAULT '0' COMMENT '任务档位',
  `price` decimal(10,2) NOT NULL COMMENT '海星数量 (积分)',
  `title` varchar(200) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '积分描述',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  `reward_id` int(10) NOT NULL DEFAULT '0' COMMENT '直播打赏ID(type=23)',
  `reward_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '打赏人ID(type=23)',
  `proportion` float(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '股东分成比例',
  `shareholder_money` decimal(10,2) NOT NULL COMMENT '本次分红总额',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `channel` (`channel`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13913 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='海星日志表';

#
# Structure for table "tx_task"
#

DROP TABLE IF EXISTS `tx_task`;
CREATE TABLE `tx_task` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '任务标题',
  `task_type` int(1) NOT NULL DEFAULT '0' COMMENT '任务类型 1单次任务 2每日重置 3完成重置',
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务表';

#
# Structure for table "tx_task_credit"
#

DROP TABLE IF EXISTS `tx_task_credit`;
CREATE TABLE `tx_task_credit` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `name` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '任务标题',
  `task_type` int(1) NOT NULL DEFAULT '0' COMMENT '任务类型 1积分兑优惠券2积分兑换阳光3积分兑换提现4阳光值兑换积分5周期兑换自然月',
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `start_time` (`start_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务表';

#
# Structure for table "tx_task_gear"
#

DROP TABLE IF EXISTS `tx_task_gear`;
CREATE TABLE `tx_task_gear` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `task_id` int(10) NOT NULL DEFAULT '0' COMMENT '任务ID',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '任务数量',
  `starfish` int(11) NOT NULL DEFAULT '0' COMMENT '普通用户海星数量（变为积分）',
  `starfish_vip` int(10) NOT NULL DEFAULT '0' COMMENT 'VIP用户海星数量',
  `sun` int(11) NOT NULL DEFAULT '0' COMMENT '普通用户阳光值',
  `sun_vip` int(11) NOT NULL DEFAULT '0' COMMENT 'VIP用户阳光值',
  `gear` int(2) NOT NULL DEFAULT '0' COMMENT '档位',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `start_time` (`num`) USING BTREE,
  KEY `end_time` (`starfish`) USING BTREE,
  KEY `sort` (`starfish_vip`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=569 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务档位表';

#
# Structure for table "tx_task_gear_credit"
#

DROP TABLE IF EXISTS `tx_task_gear_credit`;
CREATE TABLE `tx_task_gear_credit` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `task_id` int(10) NOT NULL DEFAULT '0' COMMENT '任务ID',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '任务数量',
  `starfish` int(11) NOT NULL DEFAULT '0' COMMENT '积分兑换个单位数值',
  `gear` int(2) NOT NULL DEFAULT '0' COMMENT '档位',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  `status` tinyint(3) NOT NULL DEFAULT '1' COMMENT '状态1关闭 2开启',
  `limit_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '人数上限',
  `shares_price` int(11) NOT NULL DEFAULT '0' COMMENT '每股价格',
  `shares_num` int(11) NOT NULL DEFAULT '0' COMMENT '股份数量',
  `begin_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始分红时间',
  `recruit_price` int(6) unsigned NOT NULL DEFAULT '0' COMMENT '招募价格(元)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `end_time` (`starfish`) USING BTREE,
  KEY `start_time` (`num`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=924 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务档位表';

#
# Structure for table "tx_task_getprice"
#

DROP TABLE IF EXISTS `tx_task_getprice`;
CREATE TABLE `tx_task_getprice` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `config_id` int(10) NOT NULL DEFAULT '0' COMMENT '设置ID(新版为tx_task_credit 中task_id)',
  `member_id` int(10) NOT NULL COMMENT '用户ID',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现金额',
  `get_day` int(11) NOT NULL COMMENT '领取日期',
  `create_time` int(11) NOT NULL COMMENT '创建时间戳（get_day+get_time）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务用户提现记录表';

#
# Structure for table "tx_task_goods"
#

DROP TABLE IF EXISTS `tx_task_goods`;
CREATE TABLE `tx_task_goods` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务热门商品表（浏览商品任务）';

#
# Structure for table "tx_task_invite"
#

DROP TABLE IF EXISTS `tx_task_invite`;
CREATE TABLE `tx_task_invite` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `invite_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '被邀请人会员ID',
  `invite_phone` varchar(11) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '被邀请人手机号',
  `source` tinyint(1) NOT NULL DEFAULT '0' COMMENT '邀请来源 1通讯录 2微信 3扫码',
  `price_all` int(10) NOT NULL DEFAULT '0' COMMENT '邀请获得的海星数',
  `price` int(10) NOT NULL DEFAULT '0' COMMENT '普通会员获得海星',
  `price_vip` int(10) NOT NULL DEFAULT '0' COMMENT 'VIP会员获得海星',
  `get_day` int(10) NOT NULL DEFAULT '0' COMMENT '邀请日期 时间戳',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `invite_phone` (`invite_phone`) USING BTREE,
  KEY `invite_member_id` (`invite_member_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1149 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务邀请表';

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
  `price_shareholder_all` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '股东累计积分',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6444 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务用户海星币表';

#
# Structure for table "tx_task_sharing"
#

DROP TABLE IF EXISTS `tx_task_sharing`;
CREATE TABLE `tx_task_sharing` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ciphertext` char(11) NOT NULL COMMENT '邀请码',
  `member_id` int(11) NOT NULL,
  `picname` varchar(255) NOT NULL,
  `addtime` int(11) NOT NULL,
  `hb_user` varchar(20) NOT NULL COMMENT '用户账号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8678 DEFAULT CHARSET=utf8;

#
# Structure for table "tx_task_sign"
#

DROP TABLE IF EXISTS `tx_task_sign`;
CREATE TABLE `tx_task_sign` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID',
  `price` int(10) NOT NULL DEFAULT '0' COMMENT '签到获得的金币数',
  `num` int(1) NOT NULL DEFAULT '0' COMMENT '联系签到次数',
  `get_day` int(10) NOT NULL DEFAULT '0' COMMENT '签到日期 时间戳',
  `create_time` int(11) NOT NULL COMMENT '创建时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3955 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务签到表';

#
# Structure for table "tx_task_sign_remind"
#

DROP TABLE IF EXISTS `tx_task_sign_remind`;
CREATE TABLE `tx_task_sign_remind` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `member_id` int(10) NOT NULL COMMENT '用户ID',
  `remind_day` int(10) NOT NULL DEFAULT '0' COMMENT '提醒签到日期 时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1546 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='任务签到表';

#
# Structure for table "tx_trial_member"
#

DROP TABLE IF EXISTS `tx_trial_member`;
CREATE TABLE `tx_trial_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '直播分享记录ID',
  `member_id` int(10) NOT NULL DEFAULT '0' COMMENT '推广用户id',
  `member_name` varchar(50) DEFAULT '' COMMENT '推广人用户帐号',
  `phone` varchar(11) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '手机号',
  `trial_member_id` int(10) NOT NULL DEFAULT '0' COMMENT '体验人用户ID',
  `oid` int(11) NOT NULL DEFAULT '0' COMMENT '订单ID',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '购买商品ID',
  `goods_name` varchar(200) NOT NULL DEFAULT '' COMMENT '购买商品名称',
  `order_time` int(10) NOT NULL DEFAULT '0' COMMENT '下单时间',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '体验状态 1.领取 2.下单 3.支付成功 4.取消',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `trial_member_id` (`trial_member_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户领取体验表';

#
# Structure for table "union_use_log"
#

DROP TABLE IF EXISTS `union_use_log`;
CREATE TABLE `union_use_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `bk_id` int(11) NOT NULL COMMENT '银行卡ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `bk_id` (`bk_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8mb4 COMMENT='银行卡日志';

#
# Structure for table "user_coupon_return_queue"
#

DROP TABLE IF EXISTS `user_coupon_return_queue`;
CREATE TABLE `user_coupon_return_queue` (
  `sun` int(11) unsigned DEFAULT NULL COMMENT '普通用户阳光值数量',
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '会员ID',
  `sn` varchar(200) NOT NULL COMMENT '流水号',
  `userName` varchar(200) NOT NULL COMMENT '用户名',
  `amount` decimal(11,2) NOT NULL COMMENT '扣现金券金额，单位是分',
  `createTime` varchar(255) NOT NULL COMMENT '操作时间',
  `memo` varchar(255) NOT NULL COMMENT '备注',
  `status` int(11) NOT NULL COMMENT '1 正常',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Structure for table "winning_record"
#

DROP TABLE IF EXISTS `winning_record`;
CREATE TABLE `winning_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '抽奖记录id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `win_int` varchar(50) NOT NULL DEFAULT '0' COMMENT '中奖积分',
  `c_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '标记 0未删除 1删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

#
# Structure for table "yo_calendar"
#

DROP TABLE IF EXISTS `yo_calendar`;
CREATE TABLE `yo_calendar` (
  `datelist` date DEFAULT NULL,
  UNIQUE KEY `datelist` (`datelist`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

#
# Procedure "put_coupons"
#

DROP PROCEDURE IF EXISTS `put_coupons`;
CREATE PROCEDURE `put_coupons`(in cname varchar(100) , in num int(11))
BEGIN

DECLARE start_time INT;
DECLARE end_time INT;
DECLARE i INT DEFAULT 1;
DECLARE memberID INT;
DECLARE s int DEFAULT 0;

DECLARE consume CURSOR FOR select DISTINCT member_id from order_base 
where order_type = 11 and type = 1 and pay_status = 1 
and member_id not in (
select DISTINCT member_id from tx_member_coupons where name like '开通%' 
);

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET s=1;

SET start_time = UNIX_TIMESTAMP(now());
SET end_time = UNIX_TIMESTAMP(date_add(  now() , interval  1   year ));

 OPEN consume;
 
  FETCH consume into memberID; 
  while s <> 1 do  
	
	 WHILE i <= num DO
					INSERT INTO `tx_member_coupons`( `name`, `member_id`, `shop_id`, `shop_name`, `p_ids`, `price`, `limit_price`, `coupon_id`, `use_time`, `start_time`, `end_time`, `use`, `oid`, `group_id`, `create_time`) VALUES ( cname, memberID, 0, '久久超市', '', 1.00, 2.00, 19, 0, start_time, end_time, 0, '', 0, UNIX_TIMESTAMP());
	SET i=i+1;
	END WHILE;
	SET i=1;
	
   FETCH consume into memberID; 
  end while;
 CLOSE consume;

END;

#
# Procedure "put_increment_data"
#

DROP PROCEDURE IF EXISTS `put_increment_data`;
CREATE PROCEDURE `put_increment_data`(in start_val int , in len int,in table_name varchar(50),in column_name varchar(50))
begin
 DECLARE n int DEFAULT 0;
 set @exesql = concat('insert into ',table_name,' (',column_name,') values ');
 set @exedata = '';
 set len = len + 1;
 WHILE n < len DO
 set @exedata = concat(@exedata,"(",start_val+n,")");
 if n % 1000 = 0 or n = (len-1)
 then
  set @exesql = concat(@exesql,@exedata,";");
  prepare stmt from @exesql;
  execute stmt;
  DEALLOCATE prepare stmt;
  commit; 
 set @exesql = concat('insert into ',table_name,' (',column_name,') values ');
  set @exedata = '';
 else
  set @exedata = concat(@exedata,',');
 end if;
 set n = n + 1;
 END WHILE;
end;
