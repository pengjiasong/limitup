/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.115
Source Server Version : 50625
Source Host           : 192.168.1.115:3306
Source Database       : newdbbase

Target Server Type    : MYSQL
Target Server Version : 50625
File Encoding         : 65001

Date: 2018-11-05 14:28:19
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for api_auth_node
-- ----------------------------
DROP TABLE IF EXISTS `api_auth_node`;
CREATE TABLE `api_auth_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` tinyint(3) DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `status` enum('1','0') DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of api_auth_node
-- ----------------------------
INSERT INTO `api_auth_node` VALUES ('1', '0', 'jinkou', '1');
INSERT INTO `api_auth_node` VALUES ('2', '1', 'index', '1');
INSERT INTO `api_auth_node` VALUES ('3', '1', 'read', '1');
INSERT INTO `api_auth_node` VALUES ('4', '0', 'jporangebook', '1');
INSERT INTO `api_auth_node` VALUES ('5', '4', 'index', '1');
INSERT INTO `api_auth_node` VALUES ('6', '4', 'read', '1');
INSERT INTO `api_auth_node` VALUES ('7', '0', 'rldlist', '1');
INSERT INTO `api_auth_node` VALUES ('8', '7', 'index', '1');
INSERT INTO `api_auth_node` VALUES ('9', '7', 'read', '1');
INSERT INTO `api_auth_node` VALUES ('10', '0', 'epyp', '1');
INSERT INTO `api_auth_node` VALUES ('11', '10', 'index', '1');
INSERT INTO `api_auth_node` VALUES ('12', '10', 'read', '1');
INSERT INTO `api_auth_node` VALUES ('13', '0', 'fda', '1');
INSERT INTO `api_auth_node` VALUES ('14', '13', 'index', '1');
INSERT INTO `api_auth_node` VALUES ('15', '13', 'read', '1');
INSERT INTO `api_auth_node` VALUES ('16', '13', 'getzlxx', '1');
INSERT INTO `api_auth_node` VALUES ('17', '10', 'emadetail', '1');
INSERT INTO `api_auth_node` VALUES ('18', '10', 'hmadetail', '1');

-- ----------------------------
-- Table structure for api_auth_user
-- ----------------------------
DROP TABLE IF EXISTS `api_auth_user`;
CREATE TABLE `api_auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appkey` int(8) NOT NULL,
  `appsecret` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `status` enum('1','0') DEFAULT '1',
  `auth` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of api_auth_user
-- ----------------------------
INSERT INTO `api_auth_user` VALUES ('1', '99902607', 'cf471a176db9ebf07aa49e3f46ba1816', null, '2018-08-31 09:55:59', '1', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18');

-- ----------------------------
-- Table structure for sys_access_token
-- ----------------------------
DROP TABLE IF EXISTS `sys_access_token`;
CREATE TABLE `sys_access_token` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `access_token` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '用户登录后token值',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID，一般不返回，只用作后台关联用',
  `username` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '用户信息',
  `email` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `comname` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '公司名称',
  `mobile` varchar(11) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `grade_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '权限等级ID',
  `grade_name` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '等级名称',
  `starttime` int(10) NOT NULL DEFAULT '0' COMMENT '会员开始时间',
  `endtime` int(10) NOT NULL DEFAULT '0' COMMENT '会员结束时间',
  `timelong` tinyint(4) NOT NULL DEFAULT '0' COMMENT '使用期限',
  `num` int(5) NOT NULL DEFAULT '0' COMMENT '次数',
  `firsttime` int(10) NOT NULL DEFAULT '0' COMMENT '登陆时间',
  `is_admin` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否管理员(0:不是;1:是)',
  `registration_id` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '极光推送registration_id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of sys_access_token
-- ----------------------------
INSERT INTO `sys_access_token` VALUES ('2', '3f1d42397cade5a581c5288497fb736e', '586766', 'test666', '', '', '0', '1', '默认用户组', '0', '0', '0', '0', '1534924163', '0', '171976fa8ad43ca23f3');
INSERT INTO `sys_access_token` VALUES ('3', 'e134f714457925cc24250747207c8867', '391988', 'yang1993', '3426328938@qq.com', 'zxzc xzczczcxz', '18381307228', '11', '数据库顾问', '1538323200', '1541779200', '0', '0', '1540548608', '0', '');

-- ----------------------------
-- Table structure for sys_action
-- ----------------------------
DROP TABLE IF EXISTS `sys_action`;
CREATE TABLE `sys_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '行为唯一标识',
  `title` char(80) NOT NULL DEFAULT '' COMMENT '行为说明',
  `remark` char(140) NOT NULL DEFAULT '' COMMENT '行为描述',
  `rule` text COMMENT '行为规则',
  `log` text COMMENT '日志规则',
  `type` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '类型',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='系统行为表';

-- ----------------------------
-- Records of sys_action
-- ----------------------------
INSERT INTO `sys_action` VALUES ('1', 'user_login', '用户登录', '积分+10，每天一次，嘿嘿', 'table:member|field:score|condition:uid={$self} AND status>-1|rule:score+10|cycle:24|max:1;', '[user|get_nickname]在[time|time_format]登录了后台', '1', '1', '1469853599');
INSERT INTO `sys_action` VALUES ('2', 'add_article', '发布文章', '积分+5，每天上限5次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:5', '', '2', '1', '1380173180');
INSERT INTO `sys_action` VALUES ('3', 'review', '评论', '评论积分+1，无限制', 'table:member|field:score|condition:uid={$self}|rule:score+1', '', '2', '1', '1383285646');
INSERT INTO `sys_action` VALUES ('4', 'add_document', '发表文档', '积分+10，每天上限5次', 'table:member|field:score|condition:uid={$self}|rule:score+10|cycle:24|max:5', '[user|get_nickname]在[time|time_format]发表了一篇文章。\r\n表[model]，记录编号[record]。', '2', '1', '1386139726');
INSERT INTO `sys_action` VALUES ('5', 'add_document_topic', '发表讨论', '积分+5，每天上限10次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:10', '', '2', '1', '1383285551');
INSERT INTO `sys_action` VALUES ('6', 'update_config', '更新配置', '新增或修改或删除配置', '', '', '1', '1', '1383294988');
INSERT INTO `sys_action` VALUES ('7', 'update_model', '更新模型', '新增或修改模型', '', '', '1', '1', '1383295057');
INSERT INTO `sys_action` VALUES ('8', 'update_attribute', '更新属性', '新增或更新或删除属性', '', '', '1', '1', '1383295963');
INSERT INTO `sys_action` VALUES ('9', 'update_channel', '更新导航', '新增或修改或删除导航', '', '', '1', '1', '1383296301');
INSERT INTO `sys_action` VALUES ('10', 'update_menu', '更新菜单', '新增或修改或删除菜单', '', '', '1', '1', '1383296392');
INSERT INTO `sys_action` VALUES ('11', 'update_category', '更新分类', '新增或修改或删除分类', '', '', '1', '1', '1383296765');

-- ----------------------------
-- Table structure for sys_action_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_action_log`;
CREATE TABLE `sys_action_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行为id',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行用户id',
  `action_ip` bigint(20) NOT NULL COMMENT '执行行为者ip',
  `model` varchar(50) NOT NULL DEFAULT '' COMMENT '触发行为的表',
  `record_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '触发行为的数据id',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '日志备注',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行行为的时间',
  PRIMARY KEY (`id`),
  KEY `action_ip_ix` (`action_ip`) USING BTREE,
  KEY `action_id_ix` (`action_id`) USING BTREE,
  KEY `user_id_ix` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1121 DEFAULT CHARSET=utf8 COMMENT='行为日志表';

-- ----------------------------
-- Records of sys_action_log
-- ----------------------------
INSERT INTO `sys_action_log` VALUES ('1', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 09:44:16登录了后台', '1', '1499996656');
INSERT INTO `sys_action_log` VALUES ('2', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 09:51:51登录了后台', '1', '1499997111');
INSERT INTO `sys_action_log` VALUES ('3', '1', '2', '2130706433', 'member', '2', 'luotest在2017-07-14 10:02:15登录了后台', '1', '1499997735');
INSERT INTO `sys_action_log` VALUES ('4', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 10:10:18登录了后台', '1', '1499998218');
INSERT INTO `sys_action_log` VALUES ('5', '1', '1', '0', 'member', '1', 'admin在2017-07-14 10:11:20登录了后台', '1', '1499998280');
INSERT INTO `sys_action_log` VALUES ('6', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 10:15:24登录了后台', '1', '1499998524');
INSERT INTO `sys_action_log` VALUES ('7', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 10:13:39登录了后台', '1', '1499998419');
INSERT INTO `sys_action_log` VALUES ('8', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 10:24:41登录了后台', '1', '1499999081');
INSERT INTO `sys_action_log` VALUES ('9', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 10:49:45登录了后台', '1', '1500000585');
INSERT INTO `sys_action_log` VALUES ('10', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 11:28:45登录了后台', '1', '1500002925');
INSERT INTO `sys_action_log` VALUES ('11', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 11:37:14登录了后台', '1', '1500003434');
INSERT INTO `sys_action_log` VALUES ('12', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 11:38:55登录了后台', '1', '1500003535');
INSERT INTO `sys_action_log` VALUES ('13', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 11:59:57登录了后台', '1', '1500004797');
INSERT INTO `sys_action_log` VALUES ('14', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 14:12:35登录了后台', '1', '1500012755');
INSERT INTO `sys_action_log` VALUES ('15', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 14:15:01登录了后台', '1', '1500012901');
INSERT INTO `sys_action_log` VALUES ('16', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:12:03登录了后台', '1', '1500016323');
INSERT INTO `sys_action_log` VALUES ('17', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:13:31登录了后台', '1', '1500016411');
INSERT INTO `sys_action_log` VALUES ('18', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:15:55登录了后台', '1', '1500016555');
INSERT INTO `sys_action_log` VALUES ('19', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:17:54登录了后台', '1', '1500016674');
INSERT INTO `sys_action_log` VALUES ('20', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:19:24登录了后台', '1', '1500016764');
INSERT INTO `sys_action_log` VALUES ('21', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:22:40登录了后台', '1', '1500016960');
INSERT INTO `sys_action_log` VALUES ('22', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-14 15:24:32登录了后台', '1', '1500017072');
INSERT INTO `sys_action_log` VALUES ('23', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 08:37:18登录了后台', '1', '1500251838');
INSERT INTO `sys_action_log` VALUES ('24', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 08:49:32登录了后台', '1', '1500252572');
INSERT INTO `sys_action_log` VALUES ('25', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 09:08:19登录了后台', '1', '1500253699');
INSERT INTO `sys_action_log` VALUES ('26', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 10:24:51登录了后台', '1', '1500258291');
INSERT INTO `sys_action_log` VALUES ('27', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 11:08:27登录了后台', '1', '1500260907');
INSERT INTO `sys_action_log` VALUES ('28', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 11:10:44登录了后台', '1', '1500261044');
INSERT INTO `sys_action_log` VALUES ('29', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 11:26:06登录了后台', '1', '1500261966');
INSERT INTO `sys_action_log` VALUES ('30', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-17 11:28:43登录了后台', '1', '1500262123');
INSERT INTO `sys_action_log` VALUES ('31', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 08:42:30登录了后台', '1', '1500338550');
INSERT INTO `sys_action_log` VALUES ('32', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 08:43:20登录了后台', '1', '1500338600');
INSERT INTO `sys_action_log` VALUES ('33', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 09:03:38登录了后台', '1', '1500339818');
INSERT INTO `sys_action_log` VALUES ('34', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 09:17:24登录了后台', '1', '1500340644');
INSERT INTO `sys_action_log` VALUES ('35', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 11:47:23登录了后台', '1', '1500349643');
INSERT INTO `sys_action_log` VALUES ('36', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 13:49:15登录了后台', '1', '1500356955');
INSERT INTO `sys_action_log` VALUES ('37', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 16:11:38登录了后台', '1', '1500365498');
INSERT INTO `sys_action_log` VALUES ('38', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 16:14:17登录了后台', '1', '1500365657');
INSERT INTO `sys_action_log` VALUES ('39', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 16:20:13登录了后台', '1', '1500366013');
INSERT INTO `sys_action_log` VALUES ('40', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 16:31:15登录了后台', '1', '1500366675');
INSERT INTO `sys_action_log` VALUES ('41', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 16:51:58登录了后台', '1', '1500367918');
INSERT INTO `sys_action_log` VALUES ('42', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 17:04:37登录了后台', '1', '1500368677');
INSERT INTO `sys_action_log` VALUES ('43', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 17:13:10登录了后台', '1', '1500369190');
INSERT INTO `sys_action_log` VALUES ('44', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 17:25:48登录了后台', '1', '1500369948');
INSERT INTO `sys_action_log` VALUES ('45', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 17:26:59登录了后台', '1', '1500370019');
INSERT INTO `sys_action_log` VALUES ('46', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-18 17:27:53登录了后台', '1', '1500370073');
INSERT INTO `sys_action_log` VALUES ('47', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-19 08:35:48登录了后台', '1', '1500424548');
INSERT INTO `sys_action_log` VALUES ('48', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-19 08:45:49登录了后台', '1', '1500425149');
INSERT INTO `sys_action_log` VALUES ('49', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-19 08:57:31登录了后台', '1', '1500425851');
INSERT INTO `sys_action_log` VALUES ('50', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-19 10:26:03登录了后台', '1', '1500431163');
INSERT INTO `sys_action_log` VALUES ('51', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-19 11:58:06登录了后台', '1', '1500436686');
INSERT INTO `sys_action_log` VALUES ('52', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 08:27:26登录了后台', '1', '1500510446');
INSERT INTO `sys_action_log` VALUES ('53', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 08:38:37登录了后台', '1', '1500511117');
INSERT INTO `sys_action_log` VALUES ('54', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 09:02:20登录了后台', '1', '1500512540');
INSERT INTO `sys_action_log` VALUES ('55', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 10:14:55登录了后台', '1', '1500516895');
INSERT INTO `sys_action_log` VALUES ('56', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 10:28:07登录了后台', '1', '1500517687');
INSERT INTO `sys_action_log` VALUES ('57', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 10:48:58登录了后台', '1', '1500518938');
INSERT INTO `sys_action_log` VALUES ('58', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 10:50:30登录了后台', '1', '1500519030');
INSERT INTO `sys_action_log` VALUES ('59', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 11:37:19登录了后台', '1', '1500521839');
INSERT INTO `sys_action_log` VALUES ('60', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 11:38:02登录了后台', '1', '1500521882');
INSERT INTO `sys_action_log` VALUES ('61', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 11:45:59登录了后台', '1', '1500522359');
INSERT INTO `sys_action_log` VALUES ('62', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 12:00:20登录了后台', '1', '1500523220');
INSERT INTO `sys_action_log` VALUES ('63', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 13:52:53登录了后台', '1', '1500529973');
INSERT INTO `sys_action_log` VALUES ('64', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 13:55:06登录了后台', '1', '1500530106');
INSERT INTO `sys_action_log` VALUES ('65', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 14:01:01登录了后台', '1', '1500530461');
INSERT INTO `sys_action_log` VALUES ('66', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 14:44:05登录了后台', '1', '1500533045');
INSERT INTO `sys_action_log` VALUES ('67', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 14:47:57登录了后台', '1', '1500533277');
INSERT INTO `sys_action_log` VALUES ('68', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-20 15:56:49登录了后台', '1', '1500537409');
INSERT INTO `sys_action_log` VALUES ('69', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-21 09:08:11登录了后台', '1', '1500599291');
INSERT INTO `sys_action_log` VALUES ('70', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-21 10:59:11登录了后台', '1', '1500605951');
INSERT INTO `sys_action_log` VALUES ('71', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-21 17:26:50登录了后台', '1', '1500629210');
INSERT INTO `sys_action_log` VALUES ('72', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 09:32:54登录了后台', '1', '1500859974');
INSERT INTO `sys_action_log` VALUES ('73', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 09:45:27登录了后台', '1', '1500860727');
INSERT INTO `sys_action_log` VALUES ('74', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 10:53:42登录了后台', '1', '1500864822');
INSERT INTO `sys_action_log` VALUES ('75', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:15:12登录了后台', '1', '1500876912');
INSERT INTO `sys_action_log` VALUES ('76', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:36:28登录了后台', '1', '1500878188');
INSERT INTO `sys_action_log` VALUES ('77', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:39:30登录了后台', '1', '1500878370');
INSERT INTO `sys_action_log` VALUES ('78', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:41:06登录了后台', '1', '1500878466');
INSERT INTO `sys_action_log` VALUES ('79', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:42:10登录了后台', '1', '1500878530');
INSERT INTO `sys_action_log` VALUES ('80', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:44:26登录了后台', '1', '1500878666');
INSERT INTO `sys_action_log` VALUES ('81', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:45:56登录了后台', '1', '1500878756');
INSERT INTO `sys_action_log` VALUES ('82', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:47:18登录了后台', '1', '1500878838');
INSERT INTO `sys_action_log` VALUES ('83', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:50:17登录了后台', '1', '1500879017');
INSERT INTO `sys_action_log` VALUES ('84', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 14:50:53登录了后台', '1', '1500879053');
INSERT INTO `sys_action_log` VALUES ('85', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-24 16:05:05登录了后台', '1', '1500883505');
INSERT INTO `sys_action_log` VALUES ('86', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-25 08:35:50登录了后台', '1', '1500942950');
INSERT INTO `sys_action_log` VALUES ('87', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-25 15:58:27登录了后台', '1', '1500969507');
INSERT INTO `sys_action_log` VALUES ('88', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-25 16:44:28登录了后台', '1', '1500972268');
INSERT INTO `sys_action_log` VALUES ('89', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-26 09:08:54登录了后台', '1', '1501031334');
INSERT INTO `sys_action_log` VALUES ('90', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-26 13:27:40登录了后台', '1', '1501046860');
INSERT INTO `sys_action_log` VALUES ('91', '1', '1', '2130706433', 'member', '1', 'admin在2017-07-26 16:45:08登录了后台', '1', '1501058708');
INSERT INTO `sys_action_log` VALUES ('92', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-07 10:14:12登录了后台', '1', '1502072052');
INSERT INTO `sys_action_log` VALUES ('93', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-07 10:31:20登录了后台', '1', '1502073080');
INSERT INTO `sys_action_log` VALUES ('94', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-08 10:47:54登录了后台', '1', '1502160474');
INSERT INTO `sys_action_log` VALUES ('95', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-14 16:20:33登录了后台', '1', '1502698833');
INSERT INTO `sys_action_log` VALUES ('96', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-21 08:57:03登录了后台', '1', '1503277023');
INSERT INTO `sys_action_log` VALUES ('97', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-21 10:31:12登录了后台', '1', '1503282672');
INSERT INTO `sys_action_log` VALUES ('98', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-22 10:44:54登录了后台', '1', '1503369894');
INSERT INTO `sys_action_log` VALUES ('99', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-23 10:23:56登录了后台', '1', '1503455036');
INSERT INTO `sys_action_log` VALUES ('100', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-24 09:10:40登录了后台', '1', '1503537040');
INSERT INTO `sys_action_log` VALUES ('101', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-24 17:30:33登录了后台', '1', '1503567033');
INSERT INTO `sys_action_log` VALUES ('102', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-25 08:33:45登录了后台', '1', '1503621225');
INSERT INTO `sys_action_log` VALUES ('103', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-25 09:33:07登录了后台', '1', '1503624787');
INSERT INTO `sys_action_log` VALUES ('104', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-29 10:21:27登录了后台', '1', '1503973287');
INSERT INTO `sys_action_log` VALUES ('105', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-29 13:54:51登录了后台', '1', '1503986091');
INSERT INTO `sys_action_log` VALUES ('106', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-29 17:01:37登录了后台', '1', '1503997297');
INSERT INTO `sys_action_log` VALUES ('107', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-29 17:11:09登录了后台', '1', '1503997869');
INSERT INTO `sys_action_log` VALUES ('108', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-30 08:35:30登录了后台', '1', '1504053330');
INSERT INTO `sys_action_log` VALUES ('109', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-30 13:58:34登录了后台', '1', '1504072714');
INSERT INTO `sys_action_log` VALUES ('110', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-30 14:13:48登录了后台', '1', '1504073628');
INSERT INTO `sys_action_log` VALUES ('111', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-30 14:16:10登录了后台', '1', '1504073770');
INSERT INTO `sys_action_log` VALUES ('112', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-30 16:02:13登录了后台', '1', '1504080133');
INSERT INTO `sys_action_log` VALUES ('113', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-31 08:38:01登录了后台', '1', '1504139881');
INSERT INTO `sys_action_log` VALUES ('114', '1', '1', '2130706433', 'member', '1', 'admin在2017-08-31 17:05:33登录了后台', '1', '1504170333');
INSERT INTO `sys_action_log` VALUES ('115', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-01 08:48:09登录了后台', '1', '1504226889');
INSERT INTO `sys_action_log` VALUES ('116', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-01 11:03:32登录了后台', '1', '1504235012');
INSERT INTO `sys_action_log` VALUES ('117', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-04 09:00:44登录了后台', '1', '1504486844');
INSERT INTO `sys_action_log` VALUES ('118', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-04 09:09:11登录了后台', '1', '1504487351');
INSERT INTO `sys_action_log` VALUES ('119', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-04 09:44:53登录了后台', '1', '1504489493');
INSERT INTO `sys_action_log` VALUES ('120', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-04 10:10:12登录了后台', '1', '1504491012');
INSERT INTO `sys_action_log` VALUES ('121', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-04 13:55:33登录了后台', '1', '1504504533');
INSERT INTO `sys_action_log` VALUES ('122', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 08:51:00登录了后台', '1', '1504572660');
INSERT INTO `sys_action_log` VALUES ('123', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:06:27登录了后台', '1', '1504573587');
INSERT INTO `sys_action_log` VALUES ('124', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:07:37登录了后台', '1', '1504573657');
INSERT INTO `sys_action_log` VALUES ('125', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:07:50登录了后台', '1', '1504573670');
INSERT INTO `sys_action_log` VALUES ('126', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:30:31登录了后台', '1', '1504575031');
INSERT INTO `sys_action_log` VALUES ('127', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:43:45登录了后台', '1', '1504575825');
INSERT INTO `sys_action_log` VALUES ('128', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:44:36登录了后台', '1', '1504575876');
INSERT INTO `sys_action_log` VALUES ('129', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:47:27登录了后台', '1', '1504576047');
INSERT INTO `sys_action_log` VALUES ('130', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:48:25登录了后台', '1', '1504576105');
INSERT INTO `sys_action_log` VALUES ('131', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:52:40登录了后台', '1', '1504576360');
INSERT INTO `sys_action_log` VALUES ('132', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:52:48登录了后台', '1', '1504576368');
INSERT INTO `sys_action_log` VALUES ('133', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 09:53:54登录了后台', '1', '1504576434');
INSERT INTO `sys_action_log` VALUES ('134', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 10:01:40登录了后台', '1', '1504576900');
INSERT INTO `sys_action_log` VALUES ('135', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 10:02:20登录了后台', '1', '1504576940');
INSERT INTO `sys_action_log` VALUES ('136', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 10:03:04登录了后台', '1', '1504576984');
INSERT INTO `sys_action_log` VALUES ('137', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 10:10:30登录了后台', '1', '1504577430');
INSERT INTO `sys_action_log` VALUES ('138', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 10:25:01登录了后台', '1', '1504578301');
INSERT INTO `sys_action_log` VALUES ('139', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 13:56:18登录了后台', '1', '1504590978');
INSERT INTO `sys_action_log` VALUES ('140', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 15:00:38登录了后台', '1', '1504594838');
INSERT INTO `sys_action_log` VALUES ('141', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 16:10:40登录了后台', '1', '1504599040');
INSERT INTO `sys_action_log` VALUES ('142', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-05 16:14:52登录了后台', '1', '1504599292');
INSERT INTO `sys_action_log` VALUES ('143', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-06 09:26:51登录了后台', '1', '1504661211');
INSERT INTO `sys_action_log` VALUES ('144', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-06 09:32:17登录了后台', '1', '1504661537');
INSERT INTO `sys_action_log` VALUES ('145', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-06 09:34:50登录了后台', '1', '1504661690');
INSERT INTO `sys_action_log` VALUES ('146', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-06 10:54:03登录了后台', '1', '1504666443');
INSERT INTO `sys_action_log` VALUES ('147', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-07 08:51:37登录了后台', '1', '1504745497');
INSERT INTO `sys_action_log` VALUES ('148', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-07 14:43:43登录了后台', '1', '1504766623');
INSERT INTO `sys_action_log` VALUES ('149', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-07 17:08:07登录了后台', '1', '1504775287');
INSERT INTO `sys_action_log` VALUES ('150', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-11 08:53:42登录了后台', '1', '1505091222');
INSERT INTO `sys_action_log` VALUES ('151', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-12 09:18:51登录了后台', '1', '1505179131');
INSERT INTO `sys_action_log` VALUES ('152', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-12 11:10:04登录了后台', '1', '1505185804');
INSERT INTO `sys_action_log` VALUES ('153', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-12 16:38:09登录了后台', '1', '1505205489');
INSERT INTO `sys_action_log` VALUES ('154', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-12 16:41:27登录了后台', '1', '1505205687');
INSERT INTO `sys_action_log` VALUES ('155', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-13 09:48:15登录了后台', '1', '1505267295');
INSERT INTO `sys_action_log` VALUES ('156', '1', '1', '2130706433', 'member', '1', 'admin在2017-09-13 10:48:34登录了后台', '1', '1505270914');
INSERT INTO `sys_action_log` VALUES ('157', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:04:22登录了后台', '1', '1505282662');
INSERT INTO `sys_action_log` VALUES ('158', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:13:10登录了后台', '1', '1505283190');
INSERT INTO `sys_action_log` VALUES ('159', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:20:15登录了后台', '1', '1505283615');
INSERT INTO `sys_action_log` VALUES ('160', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:29:05登录了后台', '1', '1505284145');
INSERT INTO `sys_action_log` VALUES ('161', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:35:10登录了后台', '1', '1505284510');
INSERT INTO `sys_action_log` VALUES ('162', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 14:35:41登录了后台', '1', '1505284541');
INSERT INTO `sys_action_log` VALUES ('163', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-13 16:57:49登录了后台', '1', '1505293069');
INSERT INTO `sys_action_log` VALUES ('164', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-14 08:51:28登录了后台', '1', '1505350288');
INSERT INTO `sys_action_log` VALUES ('165', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-14 09:02:18登录了后台', '1', '1505350938');
INSERT INTO `sys_action_log` VALUES ('166', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-14 10:57:06登录了后台', '1', '1505357826');
INSERT INTO `sys_action_log` VALUES ('167', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-14 16:38:42登录了后台', '1', '1505378322');
INSERT INTO `sys_action_log` VALUES ('168', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-14 16:39:51登录了后台', '1', '1505378391');
INSERT INTO `sys_action_log` VALUES ('169', '1', '1', '1784090201', 'member', '1', 'admin在2017-09-15 14:07:31登录了后台', '1', '1505455651');
INSERT INTO `sys_action_log` VALUES ('170', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 08:42:54登录了后台', '1', '1505695374');
INSERT INTO `sys_action_log` VALUES ('171', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 09:09:01登录了后台', '1', '1505696941');
INSERT INTO `sys_action_log` VALUES ('172', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 09:10:29登录了后台', '1', '1505697029');
INSERT INTO `sys_action_log` VALUES ('173', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 10:45:55登录了后台', '1', '1505702755');
INSERT INTO `sys_action_log` VALUES ('174', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 10:50:35登录了后台', '1', '1505703035');
INSERT INTO `sys_action_log` VALUES ('175', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 11:11:27登录了后台', '1', '1505704287');
INSERT INTO `sys_action_log` VALUES ('176', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 11:24:55登录了后台', '1', '1505705095');
INSERT INTO `sys_action_log` VALUES ('177', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 14:21:25登录了后台', '1', '1505715685');
INSERT INTO `sys_action_log` VALUES ('178', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-18 14:30:26登录了后台', '1', '1505716226');
INSERT INTO `sys_action_log` VALUES ('179', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-19 08:34:29登录了后台', '1', '1505781269');
INSERT INTO `sys_action_log` VALUES ('180', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-19 08:49:58登录了后台', '1', '1505782198');
INSERT INTO `sys_action_log` VALUES ('181', '1', '1', '1784090174', 'member', '1', 'admin在2017-09-19 09:08:35登录了后台', '1', '1505783315');
INSERT INTO `sys_action_log` VALUES ('182', '1', '1', '241786659', 'member', '1', 'admin在2017-09-19 15:03:14登录了后台', '1', '1505804594');
INSERT INTO `sys_action_log` VALUES ('183', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 08:43:15登录了后台', '1', '1505868195');
INSERT INTO `sys_action_log` VALUES ('184', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 10:05:15登录了后台', '1', '1505873115');
INSERT INTO `sys_action_log` VALUES ('185', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 10:20:37登录了后台', '1', '1505874037');
INSERT INTO `sys_action_log` VALUES ('186', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 10:46:09登录了后台', '1', '1505875569');
INSERT INTO `sys_action_log` VALUES ('187', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 16:02:44登录了后台', '1', '1505894564');
INSERT INTO `sys_action_log` VALUES ('188', '1', '1', '241786659', 'member', '1', 'admin在2017-09-20 16:42:11登录了后台', '1', '1505896931');
INSERT INTO `sys_action_log` VALUES ('189', '1', '1', '241786659', 'member', '1', 'admin在2017-09-21 08:55:12登录了后台', '1', '1505955312');
INSERT INTO `sys_action_log` VALUES ('190', '1', '1', '241786659', 'member', '1', 'admin在2017-09-21 09:56:52登录了后台', '1', '1505959012');
INSERT INTO `sys_action_log` VALUES ('191', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 15:10:02登录了后台', '1', '1505977802');
INSERT INTO `sys_action_log` VALUES ('192', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 15:14:14登录了后台', '1', '1505978054');
INSERT INTO `sys_action_log` VALUES ('193', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 15:17:06登录了后台', '1', '1505978226');
INSERT INTO `sys_action_log` VALUES ('194', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 15:20:12登录了后台', '1', '1505978412');
INSERT INTO `sys_action_log` VALUES ('195', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 15:45:21登录了后台', '1', '1505979921');
INSERT INTO `sys_action_log` VALUES ('196', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-21 16:05:39登录了后台', '1', '1505981139');
INSERT INTO `sys_action_log` VALUES ('197', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-22 09:16:10登录了后台', '1', '1506042970');
INSERT INTO `sys_action_log` VALUES ('198', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-22 09:48:25登录了后台', '1', '1506044905');
INSERT INTO `sys_action_log` VALUES ('199', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-22 11:59:51登录了后台', '1', '1506052791');
INSERT INTO `sys_action_log` VALUES ('200', '1', '1', '1784466276', 'member', '1', 'admin在2017-09-22 14:10:13登录了后台', '1', '1506060613');
INSERT INTO `sys_action_log` VALUES ('201', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 08:39:58登录了后台', '1', '1506299998');
INSERT INTO `sys_action_log` VALUES ('202', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 08:48:26登录了后台', '1', '1506300506');
INSERT INTO `sys_action_log` VALUES ('203', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 09:04:24登录了后台', '1', '1506301464');
INSERT INTO `sys_action_log` VALUES ('204', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 09:12:50登录了后台', '1', '1506301970');
INSERT INTO `sys_action_log` VALUES ('205', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 11:28:33登录了后台', '1', '1506310113');
INSERT INTO `sys_action_log` VALUES ('206', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 11:29:00登录了后台', '1', '1506310140');
INSERT INTO `sys_action_log` VALUES ('207', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 11:30:36登录了后台', '1', '1506310236');
INSERT INTO `sys_action_log` VALUES ('208', '1', '1', '1784466037', 'member', '1', 'admin在2017-09-25 14:32:21登录了后台', '1', '1506321141');
INSERT INTO `sys_action_log` VALUES ('209', '1', '1', '1784466299', 'member', '1', 'admin在2017-09-25 16:03:02登录了后台', '1', '1506326582');
INSERT INTO `sys_action_log` VALUES ('210', '1', '1', '1784466299', 'member', '1', 'admin在2017-09-25 16:31:55登录了后台', '1', '1506328315');
INSERT INTO `sys_action_log` VALUES ('211', '1', '1', '1784466410', 'member', '1', 'admin在2017-09-26 08:46:47登录了后台', '1', '1506386807');
INSERT INTO `sys_action_log` VALUES ('212', '1', '1', '1784466410', 'member', '1', 'admin在2017-09-26 10:40:49登录了后台', '1', '1506393649');
INSERT INTO `sys_action_log` VALUES ('213', '1', '1', '241786874', 'member', '1', 'admin在2017-09-26 14:43:55登录了后台', '1', '1506408235');
INSERT INTO `sys_action_log` VALUES ('214', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 08:36:10登录了后台', '1', '1506472570');
INSERT INTO `sys_action_log` VALUES ('215', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 10:10:57登录了后台', '1', '1506478257');
INSERT INTO `sys_action_log` VALUES ('216', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 10:15:24登录了后台', '1', '1506478524');
INSERT INTO `sys_action_log` VALUES ('217', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 11:15:52登录了后台', '1', '1506482152');
INSERT INTO `sys_action_log` VALUES ('218', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 11:38:24登录了后台', '1', '1506483504');
INSERT INTO `sys_action_log` VALUES ('219', '1', '1', '241786874', 'member', '1', 'admin在2017-09-27 15:05:00登录了后台', '1', '1506495900');
INSERT INTO `sys_action_log` VALUES ('220', '1', '1', '241786874', 'member', '1', 'admin在2017-09-28 08:52:54登录了后台', '1', '1506559974');
INSERT INTO `sys_action_log` VALUES ('221', '1', '1', '241786874', 'member', '1', 'admin在2017-09-28 09:07:09登录了后台', '1', '1506560829');
INSERT INTO `sys_action_log` VALUES ('222', '1', '1', '241786874', 'member', '1', 'admin在2017-09-28 09:53:36登录了后台', '1', '1506563616');
INSERT INTO `sys_action_log` VALUES ('223', '1', '1', '241786874', 'member', '1', 'admin在2017-09-28 10:12:55登录了后台', '1', '1506564775');
INSERT INTO `sys_action_log` VALUES ('224', '1', '1', '1784090432', 'member', '1', 'admin在2017-09-28 11:28:16登录了后台', '1', '1506569296');
INSERT INTO `sys_action_log` VALUES ('225', '1', '1', '241771069', 'member', '1', 'admin在2017-10-11 14:47:02登录了后台', '1', '1507704422');
INSERT INTO `sys_action_log` VALUES ('226', '1', '1', '241771361', 'member', '1', 'admin在2017-10-12 09:55:22登录了后台', '1', '1507773322');
INSERT INTO `sys_action_log` VALUES ('227', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 14:31:32登录了后台', '1', '1507789892');
INSERT INTO `sys_action_log` VALUES ('228', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 14:42:37登录了后台', '1', '1507790557');
INSERT INTO `sys_action_log` VALUES ('229', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 15:02:58登录了后台', '1', '1507791778');
INSERT INTO `sys_action_log` VALUES ('230', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 15:27:03登录了后台', '1', '1507793223');
INSERT INTO `sys_action_log` VALUES ('231', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 15:40:59登录了后台', '1', '1507794059');
INSERT INTO `sys_action_log` VALUES ('232', '1', '1', '241771463', 'member', '1', 'admin在2017-10-12 16:33:13登录了后台', '1', '1507797193');
INSERT INTO `sys_action_log` VALUES ('233', '1', '1', '241771311', 'member', '1', 'admin在2017-10-13 08:40:20登录了后台', '1', '1507855220');
INSERT INTO `sys_action_log` VALUES ('234', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 09:56:40登录了后台', '1', '1508119000');
INSERT INTO `sys_action_log` VALUES ('235', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 10:00:13登录了后台', '1', '1508119213');
INSERT INTO `sys_action_log` VALUES ('236', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 10:07:40登录了后台', '1', '1508119660');
INSERT INTO `sys_action_log` VALUES ('237', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 11:12:10登录了后台', '1', '1508123530');
INSERT INTO `sys_action_log` VALUES ('238', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 11:37:24登录了后台', '1', '1508125044');
INSERT INTO `sys_action_log` VALUES ('239', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 11:39:52登录了后台', '1', '1508125192');
INSERT INTO `sys_action_log` VALUES ('240', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 11:42:39登录了后台', '1', '1508125359');
INSERT INTO `sys_action_log` VALUES ('241', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 11:53:58登录了后台', '1', '1508126038');
INSERT INTO `sys_action_log` VALUES ('242', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 17:06:13登录了后台', '1', '1508144773');
INSERT INTO `sys_action_log` VALUES ('243', '1', '1', '241771058', 'member', '1', 'admin在2017-10-16 17:29:22登录了后台', '1', '1508146162');
INSERT INTO `sys_action_log` VALUES ('244', '1', '1', '241771058', 'member', '1', 'admin在2017-10-17 08:45:54登录了后台', '1', '1508201154');
INSERT INTO `sys_action_log` VALUES ('245', '1', '1', '241771058', 'member', '1', 'admin在2017-10-17 09:31:41登录了后台', '1', '1508203901');
INSERT INTO `sys_action_log` VALUES ('246', '1', '1', '241771058', 'member', '1', 'admin在2017-10-17 09:39:49登录了后台', '1', '1508204389');
INSERT INTO `sys_action_log` VALUES ('247', '1', '1', '241771456', 'member', '1', 'admin在2017-10-17 15:41:26登录了后台', '1', '1508226086');
INSERT INTO `sys_action_log` VALUES ('248', '1', '1', '241771456', 'member', '1', 'admin在2017-10-17 16:34:33登录了后台', '1', '1508229273');
INSERT INTO `sys_action_log` VALUES ('249', '1', '1', '241771456', 'member', '1', 'admin在2017-10-17 17:27:37登录了后台', '1', '1508232457');
INSERT INTO `sys_action_log` VALUES ('250', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 08:45:30登录了后台', '1', '1508287530');
INSERT INTO `sys_action_log` VALUES ('251', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 08:49:00登录了后台', '1', '1508287740');
INSERT INTO `sys_action_log` VALUES ('252', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 09:23:59登录了后台', '1', '1508289839');
INSERT INTO `sys_action_log` VALUES ('253', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 14:13:49登录了后台', '1', '1508307229');
INSERT INTO `sys_action_log` VALUES ('254', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 14:18:59登录了后台', '1', '1508307539');
INSERT INTO `sys_action_log` VALUES ('255', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 14:26:13登录了后台', '1', '1508307973');
INSERT INTO `sys_action_log` VALUES ('256', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 14:29:07登录了后台', '1', '1508308147');
INSERT INTO `sys_action_log` VALUES ('257', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 14:31:24登录了后台', '1', '1508308284');
INSERT INTO `sys_action_log` VALUES ('258', '1', '1', '241771456', 'member', '1', 'admin在2017-10-18 16:32:57登录了后台', '1', '1508315577');
INSERT INTO `sys_action_log` VALUES ('259', '1', '1', '241771456', 'member', '1', 'admin在2017-10-19 13:46:28登录了后台', '1', '1508391988');
INSERT INTO `sys_action_log` VALUES ('260', '1', '1', '241771456', 'member', '1', 'admin在2017-10-19 13:56:35登录了后台', '1', '1508392595');
INSERT INTO `sys_action_log` VALUES ('261', '1', '1', '241771456', 'member', '1', 'admin在2017-10-19 14:22:23登录了后台', '1', '1508394143');
INSERT INTO `sys_action_log` VALUES ('262', '1', '1', '241771280', 'member', '1', 'admin在2017-10-20 08:37:36登录了后台', '1', '1508459856');
INSERT INTO `sys_action_log` VALUES ('263', '1', '1', '241771280', 'member', '1', 'admin在2017-10-20 10:08:11登录了后台', '1', '1508465291');
INSERT INTO `sys_action_log` VALUES ('264', '1', '1', '241771280', 'member', '1', 'admin在2017-10-20 11:35:56登录了后台', '1', '1508470556');
INSERT INTO `sys_action_log` VALUES ('265', '1', '1', '241771280', 'member', '1', 'admin在2017-10-20 11:47:41登录了后台', '1', '1508471261');
INSERT INTO `sys_action_log` VALUES ('266', '1', '1', '241771348', 'member', '1', 'admin在2017-10-23 14:14:49登录了后台', '1', '1508739289');
INSERT INTO `sys_action_log` VALUES ('267', '1', '1', '241771151', 'member', '1', 'admin在2017-10-23 15:24:15登录了后台', '1', '1508743455');
INSERT INTO `sys_action_log` VALUES ('268', '1', '1', '241771151', 'member', '1', 'admin在2017-10-23 15:52:52登录了后台', '1', '1508745172');
INSERT INTO `sys_action_log` VALUES ('269', '1', '1', '241771151', 'member', '1', 'admin在2017-10-24 10:03:33登录了后台', '1', '1508810613');
INSERT INTO `sys_action_log` VALUES ('270', '1', '1', '241771151', 'member', '1', 'admin在2017-10-24 10:48:26登录了后台', '1', '1508813306');
INSERT INTO `sys_action_log` VALUES ('271', '1', '1', '241771151', 'member', '1', 'admin在2017-10-25 11:16:27登录了后台', '1', '1508901387');
INSERT INTO `sys_action_log` VALUES ('272', '1', '1', '241771157', 'member', '1', 'admin在2017-10-25 14:29:25登录了后台', '1', '1508912965');
INSERT INTO `sys_action_log` VALUES ('273', '1', '1', '241771157', 'member', '1', 'admin在2017-10-25 14:37:53登录了后台', '1', '1508913473');
INSERT INTO `sys_action_log` VALUES ('274', '1', '1', '241771157', 'member', '1', 'admin在2017-10-25 16:08:03登录了后台', '1', '1508918883');
INSERT INTO `sys_action_log` VALUES ('275', '1', '1', '241771157', 'member', '1', 'admin在2017-10-25 16:11:03登录了后台', '1', '1508919063');
INSERT INTO `sys_action_log` VALUES ('276', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 08:38:24登录了后台', '1', '1508978304');
INSERT INTO `sys_action_log` VALUES ('277', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 09:41:16登录了后台', '1', '1508982076');
INSERT INTO `sys_action_log` VALUES ('278', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 10:13:03登录了后台', '1', '1508983983');
INSERT INTO `sys_action_log` VALUES ('279', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 11:10:34登录了后台', '1', '1508987434');
INSERT INTO `sys_action_log` VALUES ('280', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 14:03:31登录了后台', '1', '1508997811');
INSERT INTO `sys_action_log` VALUES ('281', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 14:09:47登录了后台', '1', '1508998187');
INSERT INTO `sys_action_log` VALUES ('282', '1', '1', '241771157', 'member', '1', 'admin在2017-10-26 17:25:25登录了后台', '1', '1509009925');
INSERT INTO `sys_action_log` VALUES ('283', '1', '1', '241771157', 'member', '1', 'admin在2017-10-27 08:42:03登录了后台', '1', '1509064923');
INSERT INTO `sys_action_log` VALUES ('284', '1', '1', '241771418', 'member', '1', 'admin在2017-10-27 17:25:40登录了后台', '1', '1509096340');
INSERT INTO `sys_action_log` VALUES ('285', '1', '1', '241771166', 'member', '1', 'admin在2017-10-30 08:46:57登录了后台', '1', '1509324417');
INSERT INTO `sys_action_log` VALUES ('286', '1', '1', '241771166', 'member', '1', 'admin在2017-10-31 08:39:41登录了后台', '1', '1509410381');
INSERT INTO `sys_action_log` VALUES ('287', '1', '1', '241771166', 'member', '1', 'admin在2017-10-31 11:06:50登录了后台', '1', '1509419210');
INSERT INTO `sys_action_log` VALUES ('288', '1', '1', '241771166', 'member', '1', 'admin在2017-10-31 11:42:02登录了后台', '1', '1509421322');
INSERT INTO `sys_action_log` VALUES ('289', '1', '1', '241771166', 'member', '1', 'admin在2017-10-31 13:45:26登录了后台', '1', '1509428726');
INSERT INTO `sys_action_log` VALUES ('290', '1', '1', '241771273', 'member', '1', 'admin在2017-10-31 14:45:39登录了后台', '1', '1509432339');
INSERT INTO `sys_action_log` VALUES ('291', '1', '1', '241771273', 'member', '1', 'admin在2017-10-31 17:10:58登录了后台', '1', '1509441058');
INSERT INTO `sys_action_log` VALUES ('292', '1', '1', '241771273', 'member', '1', 'admin在2017-10-31 17:15:45登录了后台', '1', '1509441345');
INSERT INTO `sys_action_log` VALUES ('293', '1', '1', '241771273', 'member', '1', 'admin在2017-10-31 17:19:01登录了后台', '1', '1509441541');
INSERT INTO `sys_action_log` VALUES ('294', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 08:33:36登录了后台', '1', '1509496416');
INSERT INTO `sys_action_log` VALUES ('295', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 08:57:07登录了后台', '1', '1509497827');
INSERT INTO `sys_action_log` VALUES ('296', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 09:13:23登录了后台', '1', '1509498803');
INSERT INTO `sys_action_log` VALUES ('297', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 09:29:11登录了后台', '1', '1509499751');
INSERT INTO `sys_action_log` VALUES ('298', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 10:17:19登录了后台', '1', '1509502639');
INSERT INTO `sys_action_log` VALUES ('299', '1', '1', '241771273', 'member', '1', 'admin在2017-11-01 10:19:51登录了后台', '1', '1509502791');
INSERT INTO `sys_action_log` VALUES ('300', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 08:32:32登录了后台', '1', '1509582752');
INSERT INTO `sys_action_log` VALUES ('301', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 08:49:43登录了后台', '1', '1509583783');
INSERT INTO `sys_action_log` VALUES ('302', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 09:24:50登录了后台', '1', '1509585890');
INSERT INTO `sys_action_log` VALUES ('303', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 09:53:03登录了后台', '1', '1509587583');
INSERT INTO `sys_action_log` VALUES ('304', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 11:39:49登录了后台', '1', '1509593989');
INSERT INTO `sys_action_log` VALUES ('305', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 14:11:52登录了后台', '1', '1509603112');
INSERT INTO `sys_action_log` VALUES ('306', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 14:18:24登录了后台', '1', '1509603504');
INSERT INTO `sys_action_log` VALUES ('307', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 16:11:01登录了后台', '1', '1509610261');
INSERT INTO `sys_action_log` VALUES ('308', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 16:11:22登录了后台', '1', '1509610282');
INSERT INTO `sys_action_log` VALUES ('309', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 16:17:59登录了后台', '1', '1509610679');
INSERT INTO `sys_action_log` VALUES ('310', '1', '1', '241771176', 'member', '1', 'admin在2017-11-02 16:18:06登录了后台', '1', '1509610686');
INSERT INTO `sys_action_log` VALUES ('311', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 10:29:50登录了后台', '1', '1509676190');
INSERT INTO `sys_action_log` VALUES ('312', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 11:01:51登录了后台', '1', '1509678111');
INSERT INTO `sys_action_log` VALUES ('313', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 11:12:49登录了后台', '1', '1509678769');
INSERT INTO `sys_action_log` VALUES ('314', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 11:34:33登录了后台', '1', '1509680073');
INSERT INTO `sys_action_log` VALUES ('315', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 11:52:46登录了后台', '1', '1509681166');
INSERT INTO `sys_action_log` VALUES ('316', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 13:36:58登录了后台', '1', '1509687418');
INSERT INTO `sys_action_log` VALUES ('317', '1', '1', '241771176', 'member', '1', 'admin在2017-11-03 15:19:34登录了后台', '1', '1509693574');
INSERT INTO `sys_action_log` VALUES ('318', '1', '1', '241771171', 'member', '1', 'admin在2017-11-03 16:02:43登录了后台', '1', '1509696163');
INSERT INTO `sys_action_log` VALUES ('319', '1', '1', '241771171', 'member', '1', 'admin在2017-11-03 16:37:49登录了后台', '1', '1509698269');
INSERT INTO `sys_action_log` VALUES ('320', '1', '1', '241771143', 'member', '1', 'admin在2017-11-06 08:55:31登录了后台', '1', '1509929731');
INSERT INTO `sys_action_log` VALUES ('321', '1', '1', '241771143', 'member', '1', 'admin在2017-11-06 09:03:57登录了后台', '1', '1509930237');
INSERT INTO `sys_action_log` VALUES ('322', '1', '1', '241771143', 'member', '1', 'admin在2017-11-06 09:05:19登录了后台', '1', '1509930319');
INSERT INTO `sys_action_log` VALUES ('323', '1', '1', '241771143', 'member', '1', 'admin在2017-11-06 09:11:26登录了后台', '1', '1509930686');
INSERT INTO `sys_action_log` VALUES ('324', '1', '1', '241771143', 'member', '1', 'admin在2017-11-06 10:50:33登录了后台', '1', '1509936633');
INSERT INTO `sys_action_log` VALUES ('325', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 08:25:30登录了后台', '1', '1510014330');
INSERT INTO `sys_action_log` VALUES ('326', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 09:05:26登录了后台', '1', '1510016726');
INSERT INTO `sys_action_log` VALUES ('327', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 09:07:37登录了后台', '1', '1510016857');
INSERT INTO `sys_action_log` VALUES ('328', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 09:14:15登录了后台', '1', '1510017255');
INSERT INTO `sys_action_log` VALUES ('329', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 10:08:37登录了后台', '1', '1510020517');
INSERT INTO `sys_action_log` VALUES ('330', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 11:27:03登录了后台', '1', '1510025223');
INSERT INTO `sys_action_log` VALUES ('331', '1', '1', '241771143', 'member', '1', 'admin在2017-11-07 15:21:55登录了后台', '1', '1510039315');
INSERT INTO `sys_action_log` VALUES ('332', '1', '1', '241771182', 'member', '1', 'admin在2017-11-07 15:35:03登录了后台', '1', '1510040103');
INSERT INTO `sys_action_log` VALUES ('333', '1', '1', '241771182', 'member', '1', 'admin在2017-11-07 15:36:46登录了后台', '1', '1510040206');
INSERT INTO `sys_action_log` VALUES ('334', '1', '1', '241771182', 'member', '1', 'admin在2017-11-07 16:56:16登录了后台', '1', '1510044976');
INSERT INTO `sys_action_log` VALUES ('335', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 08:38:24登录了后台', '1', '1510101504');
INSERT INTO `sys_action_log` VALUES ('336', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 09:00:15登录了后台', '1', '1510102815');
INSERT INTO `sys_action_log` VALUES ('337', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:04:18登录了后台', '1', '1510106658');
INSERT INTO `sys_action_log` VALUES ('338', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:05:35登录了后台', '1', '1510106735');
INSERT INTO `sys_action_log` VALUES ('339', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:13:10登录了后台', '1', '1510107190');
INSERT INTO `sys_action_log` VALUES ('340', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:22:11登录了后台', '1', '1510107731');
INSERT INTO `sys_action_log` VALUES ('341', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:23:29登录了后台', '1', '1510107809');
INSERT INTO `sys_action_log` VALUES ('342', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 10:27:35登录了后台', '1', '1510108055');
INSERT INTO `sys_action_log` VALUES ('343', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 11:45:25登录了后台', '1', '1510112725');
INSERT INTO `sys_action_log` VALUES ('344', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 11:55:11登录了后台', '1', '1510113311');
INSERT INTO `sys_action_log` VALUES ('345', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 15:05:21登录了后台', '1', '1510124721');
INSERT INTO `sys_action_log` VALUES ('346', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 15:53:23登录了后台', '1', '1510127603');
INSERT INTO `sys_action_log` VALUES ('347', '1', '1', '241771182', 'member', '1', 'admin在2017-11-08 16:36:43登录了后台', '1', '1510130203');
INSERT INTO `sys_action_log` VALUES ('348', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 10:46:10登录了后台', '1', '1510195570');
INSERT INTO `sys_action_log` VALUES ('349', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 11:13:01登录了后台', '1', '1510197181');
INSERT INTO `sys_action_log` VALUES ('350', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 11:40:51登录了后台', '1', '1510198851');
INSERT INTO `sys_action_log` VALUES ('351', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 15:03:22登录了后台', '1', '1510211002');
INSERT INTO `sys_action_log` VALUES ('352', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 15:08:48登录了后台', '1', '1510211328');
INSERT INTO `sys_action_log` VALUES ('353', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 15:17:02登录了后台', '1', '1510211822');
INSERT INTO `sys_action_log` VALUES ('354', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 15:31:02登录了后台', '1', '1510212662');
INSERT INTO `sys_action_log` VALUES ('355', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 16:30:43登录了后台', '1', '1510216243');
INSERT INTO `sys_action_log` VALUES ('356', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 16:34:02登录了后台', '1', '1510216442');
INSERT INTO `sys_action_log` VALUES ('357', '1', '1', '241771051', 'member', '1', 'admin在2017-11-09 16:36:21登录了后台', '1', '1510216581');
INSERT INTO `sys_action_log` VALUES ('358', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 08:44:18登录了后台', '1', '1510274658');
INSERT INTO `sys_action_log` VALUES ('359', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 08:47:54登录了后台', '1', '1510274874');
INSERT INTO `sys_action_log` VALUES ('360', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 09:04:13登录了后台', '1', '1510275853');
INSERT INTO `sys_action_log` VALUES ('361', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 09:09:05登录了后台', '1', '1510276145');
INSERT INTO `sys_action_log` VALUES ('362', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 09:45:43登录了后台', '1', '1510278343');
INSERT INTO `sys_action_log` VALUES ('363', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 09:46:19登录了后台', '1', '1510278379');
INSERT INTO `sys_action_log` VALUES ('364', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 09:48:33登录了后台', '1', '1510278513');
INSERT INTO `sys_action_log` VALUES ('365', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 11:50:32登录了后台', '1', '1510285832');
INSERT INTO `sys_action_log` VALUES ('366', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 13:56:21登录了后台', '1', '1510293381');
INSERT INTO `sys_action_log` VALUES ('367', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 14:46:22登录了后台', '1', '1510296382');
INSERT INTO `sys_action_log` VALUES ('368', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 14:47:09登录了后台', '1', '1510296429');
INSERT INTO `sys_action_log` VALUES ('369', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:11:12登录了后台', '1', '1510297872');
INSERT INTO `sys_action_log` VALUES ('370', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:20:41登录了后台', '1', '1510298441');
INSERT INTO `sys_action_log` VALUES ('371', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:23:40登录了后台', '1', '1510298620');
INSERT INTO `sys_action_log` VALUES ('372', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:24:44登录了后台', '1', '1510298684');
INSERT INTO `sys_action_log` VALUES ('373', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:25:47登录了后台', '1', '1510298747');
INSERT INTO `sys_action_log` VALUES ('374', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 15:59:13登录了后台', '1', '1510300753');
INSERT INTO `sys_action_log` VALUES ('375', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 17:03:11登录了后台', '1', '1510304591');
INSERT INTO `sys_action_log` VALUES ('376', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 17:20:53登录了后台', '1', '1510305653');
INSERT INTO `sys_action_log` VALUES ('377', '1', '1', '241771051', 'member', '1', 'admin在2017-11-10 17:34:31登录了后台', '1', '1510306471');
INSERT INTO `sys_action_log` VALUES ('378', '1', '1', '241771161', 'member', '1', 'admin在2017-11-13 08:07:15登录了后台', '1', '1510531635');
INSERT INTO `sys_action_log` VALUES ('379', '1', '1', '241771161', 'member', '1', 'admin在2017-11-13 08:20:30登录了后台', '1', '1510532430');
INSERT INTO `sys_action_log` VALUES ('380', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 08:46:09登录了后台', '1', '1510533969');
INSERT INTO `sys_action_log` VALUES ('381', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 09:00:21登录了后台', '1', '1510534821');
INSERT INTO `sys_action_log` VALUES ('382', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 09:01:01登录了后台', '1', '1510534861');
INSERT INTO `sys_action_log` VALUES ('383', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 09:03:03登录了后台', '1', '1510534983');
INSERT INTO `sys_action_log` VALUES ('384', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 09:25:08登录了后台', '1', '1510536308');
INSERT INTO `sys_action_log` VALUES ('385', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 09:46:33登录了后台', '1', '1510537593');
INSERT INTO `sys_action_log` VALUES ('386', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 10:02:03登录了后台', '1', '1510538523');
INSERT INTO `sys_action_log` VALUES ('387', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 10:39:13登录了后台', '1', '1510540753');
INSERT INTO `sys_action_log` VALUES ('388', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 10:43:29登录了后台', '1', '1510541009');
INSERT INTO `sys_action_log` VALUES ('389', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 10:58:11登录了后台', '1', '1510541891');
INSERT INTO `sys_action_log` VALUES ('390', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 10:59:32登录了后台', '1', '1510541972');
INSERT INTO `sys_action_log` VALUES ('391', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 11:01:25登录了后台', '1', '1510542085');
INSERT INTO `sys_action_log` VALUES ('392', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 11:12:37登录了后台', '1', '1510542757');
INSERT INTO `sys_action_log` VALUES ('393', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 11:49:39登录了后台', '1', '1510544979');
INSERT INTO `sys_action_log` VALUES ('394', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 13:42:40登录了后台', '1', '1510551760');
INSERT INTO `sys_action_log` VALUES ('395', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 13:55:23登录了后台', '1', '1510552523');
INSERT INTO `sys_action_log` VALUES ('396', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 16:11:13登录了后台', '1', '1510560673');
INSERT INTO `sys_action_log` VALUES ('397', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 17:16:31登录了后台', '1', '1510564591');
INSERT INTO `sys_action_log` VALUES ('398', '1', '1', '241771216', 'member', '1', 'admin在2017-11-13 18:04:12登录了后台', '1', '1510567452');
INSERT INTO `sys_action_log` VALUES ('399', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 08:33:46登录了后台', '1', '1510619626');
INSERT INTO `sys_action_log` VALUES ('400', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 08:36:17登录了后台', '1', '1510619777');
INSERT INTO `sys_action_log` VALUES ('401', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 08:41:06登录了后台', '1', '1510620066');
INSERT INTO `sys_action_log` VALUES ('402', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 08:42:26登录了后台', '1', '1510620146');
INSERT INTO `sys_action_log` VALUES ('403', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 08:49:20登录了后台', '1', '1510620560');
INSERT INTO `sys_action_log` VALUES ('404', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 09:04:18登录了后台', '1', '1510621458');
INSERT INTO `sys_action_log` VALUES ('405', '1', '1', '241771216', 'member', '1', 'admin在2017-11-14 09:20:59登录了后台', '1', '1510622459');
INSERT INTO `sys_action_log` VALUES ('406', '1', '1', '241771255', 'member', '1', 'admin在2017-11-14 13:40:12登录了后台', '1', '1510638012');
INSERT INTO `sys_action_log` VALUES ('407', '1', '1', '241771255', 'member', '1', 'admin在2017-11-14 13:50:00登录了后台', '1', '1510638600');
INSERT INTO `sys_action_log` VALUES ('408', '1', '1', '241771255', 'member', '1', 'admin在2017-11-14 15:40:57登录了后台', '1', '1510645257');
INSERT INTO `sys_action_log` VALUES ('409', '1', '1', '241771255', 'member', '1', 'admin在2017-11-14 16:25:44登录了后台', '1', '1510647944');
INSERT INTO `sys_action_log` VALUES ('410', '1', '1', '1784394608', 'member', '1', 'admin在2017-11-14 20:00:09登录了后台', '1', '1510660809');
INSERT INTO `sys_action_log` VALUES ('411', '1', '1', '3736519756', 'member', '1', 'admin在2017-11-14 20:46:19登录了后台', '1', '1510663579');
INSERT INTO `sys_action_log` VALUES ('412', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 08:34:40登录了后台', '1', '1510706080');
INSERT INTO `sys_action_log` VALUES ('413', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 08:35:26登录了后台', '1', '1510706126');
INSERT INTO `sys_action_log` VALUES ('414', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 09:05:12登录了后台', '1', '1510707912');
INSERT INTO `sys_action_log` VALUES ('415', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 09:23:12登录了后台', '1', '1510708992');
INSERT INTO `sys_action_log` VALUES ('416', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 09:33:01登录了后台', '1', '1510709581');
INSERT INTO `sys_action_log` VALUES ('417', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 09:46:34登录了后台', '1', '1510710394');
INSERT INTO `sys_action_log` VALUES ('418', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 15:43:31登录了后台', '1', '1510731811');
INSERT INTO `sys_action_log` VALUES ('419', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 16:00:13登录了后台', '1', '1510732813');
INSERT INTO `sys_action_log` VALUES ('420', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 16:23:56登录了后台', '1', '1510734236');
INSERT INTO `sys_action_log` VALUES ('421', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 16:39:04登录了后台', '1', '1510735144');
INSERT INTO `sys_action_log` VALUES ('422', '1', '1', '241771255', 'member', '1', 'admin在2017-11-15 17:20:52登录了后台', '1', '1510737652');
INSERT INTO `sys_action_log` VALUES ('423', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 08:39:18登录了后台', '1', '1510792758');
INSERT INTO `sys_action_log` VALUES ('424', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 08:41:12登录了后台', '1', '1510792872');
INSERT INTO `sys_action_log` VALUES ('425', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 09:02:51登录了后台', '1', '1510794171');
INSERT INTO `sys_action_log` VALUES ('426', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 09:28:39登录了后台', '1', '1510795719');
INSERT INTO `sys_action_log` VALUES ('427', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 09:42:37登录了后台', '1', '1510796557');
INSERT INTO `sys_action_log` VALUES ('428', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 10:28:01登录了后台', '1', '1510799281');
INSERT INTO `sys_action_log` VALUES ('429', '1', '1', '241771255', 'member', '1', 'admin在2017-11-16 10:33:14登录了后台', '1', '1510799594');
INSERT INTO `sys_action_log` VALUES ('430', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 10:50:16登录了后台', '1', '1510800616');
INSERT INTO `sys_action_log` VALUES ('431', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 10:53:23登录了后台', '1', '1510800803');
INSERT INTO `sys_action_log` VALUES ('432', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 10:55:29登录了后台', '1', '1510800929');
INSERT INTO `sys_action_log` VALUES ('433', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 10:56:28登录了后台', '1', '1510800988');
INSERT INTO `sys_action_log` VALUES ('434', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 10:58:14登录了后台', '1', '1510801094');
INSERT INTO `sys_action_log` VALUES ('435', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 11:00:03登录了后台', '1', '1510801203');
INSERT INTO `sys_action_log` VALUES ('436', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 14:34:49登录了后台', '1', '1510814089');
INSERT INTO `sys_action_log` VALUES ('437', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-16 16:34:42登录了后台', '1', '1510821282');
INSERT INTO `sys_action_log` VALUES ('438', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 09:06:31登录了后台', '1', '1510880791');
INSERT INTO `sys_action_log` VALUES ('439', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 10:28:24登录了后台', '1', '1510885704');
INSERT INTO `sys_action_log` VALUES ('440', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 10:38:52登录了后台', '1', '1510886332');
INSERT INTO `sys_action_log` VALUES ('441', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 10:41:44登录了后台', '1', '1510886504');
INSERT INTO `sys_action_log` VALUES ('442', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 10:42:13登录了后台', '1', '1510886533');
INSERT INTO `sys_action_log` VALUES ('443', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 14:20:34登录了后台', '1', '1510899634');
INSERT INTO `sys_action_log` VALUES ('444', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 14:27:26登录了后台', '1', '1510900046');
INSERT INTO `sys_action_log` VALUES ('445', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 14:28:12登录了后台', '1', '1510900092');
INSERT INTO `sys_action_log` VALUES ('446', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 15:50:08登录了后台', '1', '1510905008');
INSERT INTO `sys_action_log` VALUES ('447', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 15:50:33登录了后台', '1', '1510905033');
INSERT INTO `sys_action_log` VALUES ('448', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 15:53:15登录了后台', '1', '1510905195');
INSERT INTO `sys_action_log` VALUES ('449', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 15:56:19登录了后台', '1', '1510905379');
INSERT INTO `sys_action_log` VALUES ('450', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 16:06:27登录了后台', '1', '1510905987');
INSERT INTO `sys_action_log` VALUES ('451', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 16:06:45登录了后台', '1', '1510906005');
INSERT INTO `sys_action_log` VALUES ('452', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 16:07:41登录了后台', '1', '1510906061');
INSERT INTO `sys_action_log` VALUES ('453', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 16:25:56登录了后台', '1', '1510907156');
INSERT INTO `sys_action_log` VALUES ('454', '1', '1', '3736517862', 'member', '1', 'admin在2017-11-17 16:47:56登录了后台', '1', '1510908476');
INSERT INTO `sys_action_log` VALUES ('455', '1', '3', '3736517862', 'member', '3', 'dengchunping在2017-11-17 16:59:08登录了后台', '1', '1510909148');
INSERT INTO `sys_action_log` VALUES ('456', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-20 11:56:16登录了后台', '1', '1511150176');
INSERT INTO `sys_action_log` VALUES ('457', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-20 13:43:33登录了后台', '1', '1511156613');
INSERT INTO `sys_action_log` VALUES ('458', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-20 15:17:14登录了后台', '1', '1511162234');
INSERT INTO `sys_action_log` VALUES ('459', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 09:10:36登录了后台', '1', '1511226636');
INSERT INTO `sys_action_log` VALUES ('460', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 09:27:59登录了后台', '1', '1511227679');
INSERT INTO `sys_action_log` VALUES ('461', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 09:31:52登录了后台', '1', '1511227912');
INSERT INTO `sys_action_log` VALUES ('462', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 09:32:32登录了后台', '1', '1511227952');
INSERT INTO `sys_action_log` VALUES ('463', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 10:07:50登录了后台', '1', '1511230070');
INSERT INTO `sys_action_log` VALUES ('464', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 13:41:05登录了后台', '1', '1511242865');
INSERT INTO `sys_action_log` VALUES ('465', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 14:21:21登录了后台', '1', '1511245281');
INSERT INTO `sys_action_log` VALUES ('466', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 14:35:22登录了后台', '1', '1511246122');
INSERT INTO `sys_action_log` VALUES ('467', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 14:35:42登录了后台', '1', '1511246142');
INSERT INTO `sys_action_log` VALUES ('468', '1', '1', '3736517792', 'member', '1', 'admin在2017-11-21 14:57:36登录了后台', '1', '1511247456');
INSERT INTO `sys_action_log` VALUES ('469', '1', '1', '241771020', 'member', '1', 'admin在2017-11-22 16:12:55登录了后台', '1', '1511338375');
INSERT INTO `sys_action_log` VALUES ('470', '1', '1', '241771020', 'member', '1', 'admin在2017-11-22 17:21:39登录了后台', '1', '1511342499');
INSERT INTO `sys_action_log` VALUES ('471', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 08:22:26登录了后台', '1', '1511396546');
INSERT INTO `sys_action_log` VALUES ('472', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 08:42:35登录了后台', '1', '1511397755');
INSERT INTO `sys_action_log` VALUES ('473', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 08:52:04登录了后台', '1', '1511398324');
INSERT INTO `sys_action_log` VALUES ('474', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 08:57:44登录了后台', '1', '1511398664');
INSERT INTO `sys_action_log` VALUES ('475', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 10:17:17登录了后台', '1', '1511403437');
INSERT INTO `sys_action_log` VALUES ('476', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 10:35:24登录了后台', '1', '1511404524');
INSERT INTO `sys_action_log` VALUES ('477', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 16:30:02登录了后台', '1', '1511425802');
INSERT INTO `sys_action_log` VALUES ('478', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 16:42:27登录了后台', '1', '1511426547');
INSERT INTO `sys_action_log` VALUES ('479', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 17:25:28登录了后台', '1', '1511429128');
INSERT INTO `sys_action_log` VALUES ('480', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 17:28:09登录了后台', '1', '1511429289');
INSERT INTO `sys_action_log` VALUES ('481', '1', '1', '241771020', 'member', '1', 'admin在2017-11-23 17:30:28登录了后台', '1', '1511429428');
INSERT INTO `sys_action_log` VALUES ('482', '1', '9', '241771020', 'member', '9', 'taoceshi在2017-11-23 17:30:55登录了后台', '1', '1511429455');
INSERT INTO `sys_action_log` VALUES ('483', '1', '1', '241771020', 'member', '1', 'admin在2017-11-24 08:33:03登录了后台', '1', '1511483583');
INSERT INTO `sys_action_log` VALUES ('484', '1', '1', '241771020', 'member', '1', 'admin在2017-11-24 08:52:08登录了后台', '1', '1511484728');
INSERT INTO `sys_action_log` VALUES ('485', '1', '1', '241771020', 'member', '1', 'admin在2017-11-24 08:57:49登录了后台', '1', '1511485069');
INSERT INTO `sys_action_log` VALUES ('486', '1', '1', '241771020', 'member', '1', 'admin在2017-11-24 10:04:29登录了后台', '1', '1511489069');
INSERT INTO `sys_action_log` VALUES ('487', '1', '1', '241771220', 'member', '1', 'admin在2017-11-24 11:25:41登录了后台', '1', '1511493941');
INSERT INTO `sys_action_log` VALUES ('488', '1', '1', '241771220', 'member', '1', 'admin在2017-11-24 11:38:09登录了后台', '1', '1511494689');
INSERT INTO `sys_action_log` VALUES ('489', '1', '1', '241771220', 'member', '1', 'admin在2017-11-24 15:44:05登录了后台', '1', '1511509445');
INSERT INTO `sys_action_log` VALUES ('490', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 08:57:41登录了后台', '1', '1511744261');
INSERT INTO `sys_action_log` VALUES ('491', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 09:20:59登录了后台', '1', '1511745659');
INSERT INTO `sys_action_log` VALUES ('492', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 09:38:19登录了后台', '1', '1511746699');
INSERT INTO `sys_action_log` VALUES ('493', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 10:34:24登录了后台', '1', '1511750064');
INSERT INTO `sys_action_log` VALUES ('494', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 10:38:06登录了后台', '1', '1511750286');
INSERT INTO `sys_action_log` VALUES ('495', '1', '3', '241771065', 'member', '3', 'dengchunping在2017-11-27 11:38:03登录了后台', '1', '1511753883');
INSERT INTO `sys_action_log` VALUES ('496', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 11:56:47登录了后台', '1', '1511755007');
INSERT INTO `sys_action_log` VALUES ('497', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 14:23:05登录了后台', '1', '1511763785');
INSERT INTO `sys_action_log` VALUES ('498', '1', '1', '241771065', 'member', '1', 'admin在2017-11-27 14:29:13登录了后台', '1', '1511764153');
INSERT INTO `sys_action_log` VALUES ('499', '1', '1', '241771342', 'member', '1', 'admin在2017-11-27 15:22:19登录了后台', '1', '1511767339');
INSERT INTO `sys_action_log` VALUES ('500', '1', '1', '241771342', 'member', '1', 'admin在2017-11-27 15:59:04登录了后台', '1', '1511769544');
INSERT INTO `sys_action_log` VALUES ('501', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 08:32:12登录了后台', '1', '1511829132');
INSERT INTO `sys_action_log` VALUES ('502', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 08:33:48登录了后台', '1', '1511829228');
INSERT INTO `sys_action_log` VALUES ('503', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 08:54:10登录了后台', '1', '1511830450');
INSERT INTO `sys_action_log` VALUES ('504', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 08:54:47登录了后台', '1', '1511830487');
INSERT INTO `sys_action_log` VALUES ('505', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 08:58:37登录了后台', '1', '1511830717');
INSERT INTO `sys_action_log` VALUES ('506', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 09:13:33登录了后台', '1', '1511831613');
INSERT INTO `sys_action_log` VALUES ('507', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 10:05:26登录了后台', '1', '1511834726');
INSERT INTO `sys_action_log` VALUES ('508', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 10:10:37登录了后台', '1', '1511835037');
INSERT INTO `sys_action_log` VALUES ('509', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 16:08:58登录了后台', '1', '1511856538');
INSERT INTO `sys_action_log` VALUES ('510', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 16:46:34登录了后台', '1', '1511858794');
INSERT INTO `sys_action_log` VALUES ('511', '1', '10', '241771342', 'member', '10', 'test1234在2017-11-28 16:47:17登录了后台', '1', '1511858837');
INSERT INTO `sys_action_log` VALUES ('512', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 16:48:08登录了后台', '1', '1511858888');
INSERT INTO `sys_action_log` VALUES ('513', '1', '10', '241771342', 'member', '10', 'test1234在2017-11-28 16:49:26登录了后台', '1', '1511858966');
INSERT INTO `sys_action_log` VALUES ('514', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 16:50:09登录了后台', '1', '1511859009');
INSERT INTO `sys_action_log` VALUES ('515', '1', '10', '241771342', 'member', '10', 'test1234在2017-11-28 16:53:22登录了后台', '1', '1511859202');
INSERT INTO `sys_action_log` VALUES ('516', '1', '10', '241771342', 'member', '10', 'test1234在2017-11-28 17:13:39登录了后台', '1', '1511860419');
INSERT INTO `sys_action_log` VALUES ('517', '1', '1', '241771342', 'member', '1', 'admin在2017-11-28 17:29:05登录了后台', '1', '1511861345');
INSERT INTO `sys_action_log` VALUES ('518', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 08:38:12登录了后台', '1', '1511915892');
INSERT INTO `sys_action_log` VALUES ('519', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 08:41:21登录了后台', '1', '1511916081');
INSERT INTO `sys_action_log` VALUES ('520', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 08:47:44登录了后台', '1', '1511916464');
INSERT INTO `sys_action_log` VALUES ('521', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 09:17:24登录了后台', '1', '1511918244');
INSERT INTO `sys_action_log` VALUES ('522', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 10:43:39登录了后台', '1', '1511923419');
INSERT INTO `sys_action_log` VALUES ('523', '1', '11', '241771342', 'member', '11', 'test666在2017-11-29 10:47:40登录了后台', '1', '1511923660');
INSERT INTO `sys_action_log` VALUES ('524', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 11:23:49登录了后台', '1', '1511925829');
INSERT INTO `sys_action_log` VALUES ('525', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 11:26:07登录了后台', '1', '1511925967');
INSERT INTO `sys_action_log` VALUES ('526', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 11:59:24登录了后台', '1', '1511927964');
INSERT INTO `sys_action_log` VALUES ('527', '1', '1', '241771342', 'member', '1', 'admin在2017-11-29 15:05:28登录了后台', '1', '1511939128');
INSERT INTO `sys_action_log` VALUES ('528', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-29 15:45:06登录了后台', '1', '1511941506');
INSERT INTO `sys_action_log` VALUES ('529', '1', '11', '3736517739', 'member', '11', 'test666在2017-11-29 15:54:07登录了后台', '1', '1511942047');
INSERT INTO `sys_action_log` VALUES ('530', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-29 15:57:38登录了后台', '1', '1511942258');
INSERT INTO `sys_action_log` VALUES ('531', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-29 16:00:11登录了后台', '1', '1511942411');
INSERT INTO `sys_action_log` VALUES ('532', '1', '11', '3736517739', 'member', '11', 'test666在2017-11-29 16:08:24登录了后台', '1', '1511942904');
INSERT INTO `sys_action_log` VALUES ('533', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-29 16:34:20登录了后台', '1', '1511944460');
INSERT INTO `sys_action_log` VALUES ('534', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-30 08:45:40登录了后台', '1', '1512002740');
INSERT INTO `sys_action_log` VALUES ('535', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-30 08:49:16登录了后台', '1', '1512002956');
INSERT INTO `sys_action_log` VALUES ('536', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-30 08:57:53登录了后台', '1', '1512003473');
INSERT INTO `sys_action_log` VALUES ('537', '1', '1', '3736517739', 'member', '1', 'admin在2017-11-30 08:58:44登录了后台', '1', '1512003524');
INSERT INTO `sys_action_log` VALUES ('538', '1', '1', '3736517739', 'member', '1', 'administrator在2017-11-30 09:00:08登录了后台', '1', '1512003608');
INSERT INTO `sys_action_log` VALUES ('539', '1', '1', '3736517739', 'member', '1', 'administrator在2017-11-30 10:01:36登录了后台', '1', '1512007296');
INSERT INTO `sys_action_log` VALUES ('540', '1', '1', '3736517739', 'member', '1', 'administrator在2017-11-30 11:53:13登录了后台', '1', '1512013993');
INSERT INTO `sys_action_log` VALUES ('541', '1', '1', '3736517739', 'member', '1', 'administrator在2017-11-30 16:11:06登录了后台', '1', '1512029466');
INSERT INTO `sys_action_log` VALUES ('542', '1', '1', '3736517739', 'member', '1', 'administrator在2017-11-30 17:25:08登录了后台', '1', '1512033908');
INSERT INTO `sys_action_log` VALUES ('543', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:06:16登录了后台', '1', '1512090376');
INSERT INTO `sys_action_log` VALUES ('544', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:11:15登录了后台', '1', '1512090675');
INSERT INTO `sys_action_log` VALUES ('545', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:11:57登录了后台', '1', '1512090717');
INSERT INTO `sys_action_log` VALUES ('546', '1', '10', '3736517739', 'member', '10', 'test1234在2017-12-01 09:13:04登录了后台', '1', '1512090784');
INSERT INTO `sys_action_log` VALUES ('547', '1', '10', '3736517739', 'member', '10', 'test1234在2017-12-01 09:20:34登录了后台', '1', '1512091234');
INSERT INTO `sys_action_log` VALUES ('548', '1', '10', '3736517739', 'member', '10', 'test1234在2017-12-01 09:21:03登录了后台', '1', '1512091263');
INSERT INTO `sys_action_log` VALUES ('549', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:22:19登录了后台', '1', '1512091339');
INSERT INTO `sys_action_log` VALUES ('550', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 09:23:40登录了后台', '1', '1512091420');
INSERT INTO `sys_action_log` VALUES ('551', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:29:29登录了后台', '1', '1512091769');
INSERT INTO `sys_action_log` VALUES ('552', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 09:34:37登录了后台', '1', '1512092077');
INSERT INTO `sys_action_log` VALUES ('553', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 09:39:12登录了后台', '1', '1512092352');
INSERT INTO `sys_action_log` VALUES ('554', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 09:50:42登录了后台', '1', '1512093042');
INSERT INTO `sys_action_log` VALUES ('555', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 10:15:13登录了后台', '1', '1512094513');
INSERT INTO `sys_action_log` VALUES ('556', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 10:26:08登录了后台', '1', '1512095168');
INSERT INTO `sys_action_log` VALUES ('557', '1', '11', '3736517739', 'member', '11', 'test22在2017-12-01 10:27:24登录了后台', '1', '1512095244');
INSERT INTO `sys_action_log` VALUES ('558', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 10:29:30登录了后台', '1', '1512095370');
INSERT INTO `sys_action_log` VALUES ('559', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 11:09:29登录了后台', '1', '1512097769');
INSERT INTO `sys_action_log` VALUES ('560', '1', '11', '3736517739', 'member', '11', 'test22在2017-12-01 11:15:38登录了后台', '1', '1512098138');
INSERT INTO `sys_action_log` VALUES ('561', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 11:16:36登录了后台', '1', '1512098196');
INSERT INTO `sys_action_log` VALUES ('562', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 11:53:10登录了后台', '1', '1512100390');
INSERT INTO `sys_action_log` VALUES ('563', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 11:57:24登录了后台', '1', '1512100644');
INSERT INTO `sys_action_log` VALUES ('564', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 13:44:02登录了后台', '1', '1512107042');
INSERT INTO `sys_action_log` VALUES ('565', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 14:10:13登录了后台', '1', '1512108613');
INSERT INTO `sys_action_log` VALUES ('566', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 14:30:17登录了后台', '1', '1512109817');
INSERT INTO `sys_action_log` VALUES ('567', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 14:31:01登录了后台', '1', '1512109861');
INSERT INTO `sys_action_log` VALUES ('568', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 14:41:50登录了后台', '1', '1512110510');
INSERT INTO `sys_action_log` VALUES ('569', '1', '1', '3736517739', 'member', '1', 'administrator在2017-12-01 14:54:32登录了后台', '1', '1512111272');
INSERT INTO `sys_action_log` VALUES ('570', '1', '10', '3736517739', 'member', '10', 'test3333在2017-12-01 14:57:59登录了后台', '1', '1512111479');
INSERT INTO `sys_action_log` VALUES ('571', '1', '1', '3736517757', 'member', '1', 'administrator在2017-12-01 15:17:22登录了后台', '1', '1512112642');
INSERT INTO `sys_action_log` VALUES ('572', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:12:04登录了后台', '1', '1512349924');
INSERT INTO `sys_action_log` VALUES ('573', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:12:19登录了后台', '1', '1512349939');
INSERT INTO `sys_action_log` VALUES ('574', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:13:20登录了后台', '1', '1512350000');
INSERT INTO `sys_action_log` VALUES ('575', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:13:40登录了后台', '1', '1512350020');
INSERT INTO `sys_action_log` VALUES ('576', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:14:52登录了后台', '1', '1512350092');
INSERT INTO `sys_action_log` VALUES ('577', '1', '4', '3736517865', 'member', '4', 'xujianhua在2017-12-04 09:15:26登录了后台', '1', '1512350126');
INSERT INTO `sys_action_log` VALUES ('578', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 09:33:59登录了后台', '1', '1512351239');
INSERT INTO `sys_action_log` VALUES ('579', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 09:43:47登录了后台', '1', '1512351827');
INSERT INTO `sys_action_log` VALUES ('580', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 09:49:00登录了后台', '1', '1512352140');
INSERT INTO `sys_action_log` VALUES ('581', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 09:51:44登录了后台', '1', '1512352304');
INSERT INTO `sys_action_log` VALUES ('582', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 09:59:29登录了后台', '1', '1512352769');
INSERT INTO `sys_action_log` VALUES ('583', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:03:40登录了后台', '1', '1512353020');
INSERT INTO `sys_action_log` VALUES ('584', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:05:30登录了后台', '1', '1512353130');
INSERT INTO `sys_action_log` VALUES ('585', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 10:08:47登录了后台', '1', '1512353327');
INSERT INTO `sys_action_log` VALUES ('586', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 10:09:07登录了后台', '1', '1512353347');
INSERT INTO `sys_action_log` VALUES ('587', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 10:11:57登录了后台', '1', '1512353517');
INSERT INTO `sys_action_log` VALUES ('588', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:14:50登录了后台', '1', '1512353690');
INSERT INTO `sys_action_log` VALUES ('589', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 10:15:17登录了后台', '1', '1512353717');
INSERT INTO `sys_action_log` VALUES ('590', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:15:48登录了后台', '1', '1512353748');
INSERT INTO `sys_action_log` VALUES ('591', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 10:17:06登录了后台', '1', '1512353826');
INSERT INTO `sys_action_log` VALUES ('592', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 10:17:35登录了后台', '1', '1512353855');
INSERT INTO `sys_action_log` VALUES ('593', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:17:48登录了后台', '1', '1512353868');
INSERT INTO `sys_action_log` VALUES ('594', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 10:18:56登录了后台', '1', '1512353936');
INSERT INTO `sys_action_log` VALUES ('595', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-04 10:20:59登录了后台', '1', '1512354059');
INSERT INTO `sys_action_log` VALUES ('596', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:23:57登录了后台', '1', '1512354237');
INSERT INTO `sys_action_log` VALUES ('597', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 10:25:36登录了后台', '1', '1512354336');
INSERT INTO `sys_action_log` VALUES ('598', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 10:29:22登录了后台', '1', '1512354562');
INSERT INTO `sys_action_log` VALUES ('599', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 14:59:28登录了后台', '1', '1512370768');
INSERT INTO `sys_action_log` VALUES ('600', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 15:16:12登录了后台', '1', '1512371772');
INSERT INTO `sys_action_log` VALUES ('601', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:01:18登录了后台', '1', '1512374478');
INSERT INTO `sys_action_log` VALUES ('602', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:02:59登录了后台', '1', '1512374579');
INSERT INTO `sys_action_log` VALUES ('603', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 16:03:59登录了后台', '1', '1512374639');
INSERT INTO `sys_action_log` VALUES ('604', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:06:22登录了后台', '1', '1512374782');
INSERT INTO `sys_action_log` VALUES ('605', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:07:45登录了后台', '1', '1512374865');
INSERT INTO `sys_action_log` VALUES ('606', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:08:42登录了后台', '1', '1512374922');
INSERT INTO `sys_action_log` VALUES ('607', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:10:18登录了后台', '1', '1512375018');
INSERT INTO `sys_action_log` VALUES ('608', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-04 16:12:18登录了后台', '1', '1512375138');
INSERT INTO `sys_action_log` VALUES ('609', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-04 16:13:41登录了后台', '1', '1512375221');
INSERT INTO `sys_action_log` VALUES ('610', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 08:35:38登录了后台', '1', '1512434138');
INSERT INTO `sys_action_log` VALUES ('611', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 08:37:45登录了后台', '1', '1512434265');
INSERT INTO `sys_action_log` VALUES ('612', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 08:39:11登录了后台', '1', '1512434351');
INSERT INTO `sys_action_log` VALUES ('613', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 08:45:26登录了后台', '1', '1512434726');
INSERT INTO `sys_action_log` VALUES ('614', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 08:54:26登录了后台', '1', '1512435266');
INSERT INTO `sys_action_log` VALUES ('615', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 08:55:01登录了后台', '1', '1512435301');
INSERT INTO `sys_action_log` VALUES ('616', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 08:59:22登录了后台', '1', '1512435562');
INSERT INTO `sys_action_log` VALUES ('617', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 09:07:58登录了后台', '1', '1512436078');
INSERT INTO `sys_action_log` VALUES ('618', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 09:12:25登录了后台', '1', '1512436345');
INSERT INTO `sys_action_log` VALUES ('619', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-05 10:31:14登录了后台', '1', '1512441074');
INSERT INTO `sys_action_log` VALUES ('620', '1', '11', '3736517865', 'member', '11', 'test22在2017-12-05 10:40:24登录了后台', '1', '1512441624');
INSERT INTO `sys_action_log` VALUES ('621', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 10:43:03登录了后台', '1', '1512441783');
INSERT INTO `sys_action_log` VALUES ('622', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 11:16:22登录了后台', '1', '1512443782');
INSERT INTO `sys_action_log` VALUES ('623', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 11:17:30登录了后台', '1', '1512443850');
INSERT INTO `sys_action_log` VALUES ('624', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 11:53:53登录了后台', '1', '1512446033');
INSERT INTO `sys_action_log` VALUES ('625', '1', '1', '3736517865', 'member', '1', 'administrator在2017-12-05 11:56:08登录了后台', '1', '1512446168');
INSERT INTO `sys_action_log` VALUES ('626', '1', '22', '3736517865', 'member', '22', 'tianjuan在2017-12-05 14:05:41登录了后台', '1', '1512453941');
INSERT INTO `sys_action_log` VALUES ('627', '1', '10', '3736517865', 'member', '10', 'test3333在2017-12-05 14:49:06登录了后台', '1', '1512456546');
INSERT INTO `sys_action_log` VALUES ('628', '1', '7', '3736517865', 'member', '7', 'zhouyi在2017-12-05 14:50:33登录了后台', '1', '1512456633');
INSERT INTO `sys_action_log` VALUES ('629', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-05 14:57:03登录了后台', '1', '1512457023');
INSERT INTO `sys_action_log` VALUES ('630', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-05 15:10:28登录了后台', '1', '1512457828');
INSERT INTO `sys_action_log` VALUES ('631', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-06 08:43:00登录了后台', '1', '1512520980');
INSERT INTO `sys_action_log` VALUES ('632', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-06 08:59:58登录了后台', '1', '1512521998');
INSERT INTO `sys_action_log` VALUES ('633', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-06 09:13:27登录了后台', '1', '1512522807');
INSERT INTO `sys_action_log` VALUES ('634', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-06 11:05:06登录了后台', '1', '1512529506');
INSERT INTO `sys_action_log` VALUES ('635', '1', '4', '241771082', 'member', '4', 'xujianhua在2017-12-06 11:42:54登录了后台', '1', '1512531774');
INSERT INTO `sys_action_log` VALUES ('636', '1', '11', '241771082', 'member', '11', 'test666在2017-12-06 14:20:12登录了后台', '1', '1512541212');
INSERT INTO `sys_action_log` VALUES ('637', '1', '7', '241771082', 'member', '7', 'zhouyi在2017-12-06 14:34:16登录了后台', '1', '1512542056');
INSERT INTO `sys_action_log` VALUES ('638', '1', '10', '241771082', 'member', '10', 'test3333在2017-12-06 14:46:28登录了后台', '1', '1512542788');
INSERT INTO `sys_action_log` VALUES ('639', '1', '7', '241771082', 'member', '7', 'zhouyi在2017-12-06 16:52:37登录了后台', '1', '1512550357');
INSERT INTO `sys_action_log` VALUES ('640', '1', '4', '241771082', 'member', '4', 'xujianhua在2017-12-07 08:53:18登录了后台', '1', '1512607998');
INSERT INTO `sys_action_log` VALUES ('641', '1', '7', '241771082', 'member', '7', 'zhouyi在2017-12-07 08:58:14登录了后台', '1', '1512608294');
INSERT INTO `sys_action_log` VALUES ('642', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 08:58:48登录了后台', '1', '1512608328');
INSERT INTO `sys_action_log` VALUES ('643', '1', '4', '241771082', 'member', '4', 'xujianhua在2017-12-07 09:00:50登录了后台', '1', '1512608450');
INSERT INTO `sys_action_log` VALUES ('644', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 09:07:24登录了后台', '1', '1512608844');
INSERT INTO `sys_action_log` VALUES ('645', '1', '7', '241771082', 'member', '7', 'zhouyi在2017-12-07 09:37:39登录了后台', '1', '1512610659');
INSERT INTO `sys_action_log` VALUES ('646', '1', '10', '241771082', 'member', '10', 'test3333在2017-12-07 10:19:07登录了后台', '1', '1512613147');
INSERT INTO `sys_action_log` VALUES ('647', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 10:21:26登录了后台', '1', '1512613286');
INSERT INTO `sys_action_log` VALUES ('648', '1', '21', '241771082', 'member', '21', 'test88在2017-12-07 10:27:22登录了后台', '1', '1512613642');
INSERT INTO `sys_action_log` VALUES ('649', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 10:27:39登录了后台', '1', '1512613659');
INSERT INTO `sys_action_log` VALUES ('650', '1', '21', '241771082', 'member', '21', 'test88在2017-12-07 10:28:27登录了后台', '1', '1512613707');
INSERT INTO `sys_action_log` VALUES ('651', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 10:28:53登录了后台', '1', '1512613733');
INSERT INTO `sys_action_log` VALUES ('652', '1', '21', '241771082', 'member', '21', 'test88在2017-12-07 10:30:00登录了后台', '1', '1512613800');
INSERT INTO `sys_action_log` VALUES ('653', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 10:30:13登录了后台', '1', '1512613813');
INSERT INTO `sys_action_log` VALUES ('654', '1', '1', '241771082', 'member', '1', 'administrator在2017-12-07 10:51:03登录了后台', '1', '1512615063');
INSERT INTO `sys_action_log` VALUES ('655', '1', '2', '241771082', 'member', '2', 'luotest在2017-12-07 10:56:16登录了后台', '1', '1512615376');
INSERT INTO `sys_action_log` VALUES ('656', '1', '2', '241771082', 'member', '2', 'luotest在2017-12-07 10:57:11登录了后台', '1', '1512615431');
INSERT INTO `sys_action_log` VALUES ('657', '1', '1', '241771152', 'member', '1', 'administrator在2017-12-08 14:44:44登录了后台', '1', '1512715484');
INSERT INTO `sys_action_log` VALUES ('658', '1', '7', '241771152', 'member', '7', 'zhouyi在2017-12-08 15:10:57登录了后台', '1', '1512717057');
INSERT INTO `sys_action_log` VALUES ('659', '1', '7', '241771068', 'member', '7', 'zhouyi在2017-12-11 08:45:59登录了后台', '1', '1512953159');
INSERT INTO `sys_action_log` VALUES ('660', '1', '1', '241771068', 'member', '1', 'administrator在2017-12-11 10:25:21登录了后台', '1', '1512959121');
INSERT INTO `sys_action_log` VALUES ('661', '1', '1', '241771068', 'member', '1', 'administrator在2017-12-12 10:52:14登录了后台', '1', '1513047134');
INSERT INTO `sys_action_log` VALUES ('662', '1', '1', '241771320', 'member', '1', 'administrator在2017-12-13 08:49:53登录了后台', '1', '1513126193');
INSERT INTO `sys_action_log` VALUES ('663', '1', '1', '241771320', 'member', '1', 'administrator在2017-12-13 08:52:06登录了后台', '1', '1513126326');
INSERT INTO `sys_action_log` VALUES ('664', '1', '1', '241771320', 'member', '1', 'administrator在2017-12-13 08:52:45登录了后台', '1', '1513126365');
INSERT INTO `sys_action_log` VALUES ('665', '1', '1', '241771175', 'member', '1', 'administrator在2017-12-15 08:09:42登录了后台', '1', '1513296582');
INSERT INTO `sys_action_log` VALUES ('666', '1', '1', '241771454', 'member', '1', 'administrator在2017-12-15 08:58:32登录了后台', '1', '1513299512');
INSERT INTO `sys_action_log` VALUES ('667', '1', '1', '241771454', 'member', '1', 'administrator在2017-12-15 14:03:40登录了后台', '1', '1513317820');
INSERT INTO `sys_action_log` VALUES ('668', '1', '1', '241771454', 'member', '1', 'administrator在2017-12-15 16:13:16登录了后台', '1', '1513325596');
INSERT INTO `sys_action_log` VALUES ('669', '1', '1', '241771156', 'member', '1', 'administrator在2017-12-18 15:07:08登录了后台', '1', '1513580828');
INSERT INTO `sys_action_log` VALUES ('670', '1', '1', '241771156', 'member', '1', 'administrator在2017-12-18 15:09:41登录了后台', '1', '1513580981');
INSERT INTO `sys_action_log` VALUES ('671', '1', '1', '241771156', 'member', '1', 'administrator在2017-12-20 11:09:56登录了后台', '1', '1513739396');
INSERT INTO `sys_action_log` VALUES ('672', '1', '7', '3736517707', 'member', '7', 'zhouyi在2017-12-20 15:38:43登录了后台', '1', '1513755523');
INSERT INTO `sys_action_log` VALUES ('673', '1', '4', '3736517707', 'member', '4', 'xujianhua在2017-12-20 16:10:42登录了后台', '1', '1513757442');
INSERT INTO `sys_action_log` VALUES ('674', '1', '7', '3736517707', 'member', '7', 'zhouyi在2017-12-20 17:04:22登录了后台', '1', '1513760662');
INSERT INTO `sys_action_log` VALUES ('675', '1', '7', '3736517707', 'member', '7', 'zhouyi在2017-12-21 09:04:07登录了后台', '1', '1513818247');
INSERT INTO `sys_action_log` VALUES ('676', '1', '1', '3736517707', 'member', '1', 'administrator在2017-12-21 09:30:52登录了后台', '1', '1513819852');
INSERT INTO `sys_action_log` VALUES ('677', '1', '1', '3736517707', 'member', '1', 'administrator在2017-12-22 09:22:14登录了后台', '1', '1513905734');
INSERT INTO `sys_action_log` VALUES ('678', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-22 14:37:09登录了后台', '1', '1513924629');
INSERT INTO `sys_action_log` VALUES ('679', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-22 15:34:24登录了后台', '1', '1513928064');
INSERT INTO `sys_action_log` VALUES ('680', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-24 11:16:02登录了后台', '1', '1514085362');
INSERT INTO `sys_action_log` VALUES ('681', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-25 08:50:56登录了后台', '1', '1514163056');
INSERT INTO `sys_action_log` VALUES ('682', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-25 09:11:20登录了后台', '1', '1514164280');
INSERT INTO `sys_action_log` VALUES ('683', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 08:34:14登录了后台', '1', '1514248454');
INSERT INTO `sys_action_log` VALUES ('684', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 10:35:52登录了后台', '1', '1514255752');
INSERT INTO `sys_action_log` VALUES ('685', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 11:07:33登录了后台', '1', '1514257653');
INSERT INTO `sys_action_log` VALUES ('686', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 11:08:58登录了后台', '1', '1514257738');
INSERT INTO `sys_action_log` VALUES ('687', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 14:46:54登录了后台', '1', '1514270814');
INSERT INTO `sys_action_log` VALUES ('688', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 15:04:13登录了后台', '1', '1514271853');
INSERT INTO `sys_action_log` VALUES ('689', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-26 19:54:49登录了后台', '1', '1514289289');
INSERT INTO `sys_action_log` VALUES ('690', '1', '1', '3736517830', 'member', '1', 'administrator在2017-12-28 13:51:18登录了后台', '1', '1514440278');
INSERT INTO `sys_action_log` VALUES ('691', '1', '7', '3736517877', 'member', '7', 'zhouyi在2018-01-03 13:52:34登录了后台', '1', '1514958754');
INSERT INTO `sys_action_log` VALUES ('692', '1', '1', '3736517877', 'member', '1', 'administrator在2018-01-03 14:00:13登录了后台', '1', '1514959213');
INSERT INTO `sys_action_log` VALUES ('693', '1', '7', '3736517806', 'member', '7', 'zhouyi在2018-01-03 15:15:40登录了后台', '1', '1514963740');
INSERT INTO `sys_action_log` VALUES ('694', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-09 11:59:30登录了后台', '1', '1515470370');
INSERT INTO `sys_action_log` VALUES ('695', '1', '7', '241771316', 'member', '7', 'zhouyi在2018-01-09 14:41:51登录了后台', '1', '1515480111');
INSERT INTO `sys_action_log` VALUES ('696', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-09 14:52:01登录了后台', '1', '1515480721');
INSERT INTO `sys_action_log` VALUES ('697', '1', '7', '241771316', 'member', '7', 'zhouyi在2018-01-09 14:55:05登录了后台', '1', '1515480905');
INSERT INTO `sys_action_log` VALUES ('698', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-09 14:56:11登录了后台', '1', '1515480971');
INSERT INTO `sys_action_log` VALUES ('699', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-10 08:52:56登录了后台', '1', '1515545576');
INSERT INTO `sys_action_log` VALUES ('700', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-10 08:56:19登录了后台', '1', '1515545779');
INSERT INTO `sys_action_log` VALUES ('701', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-10 08:58:16登录了后台', '1', '1515545896');
INSERT INTO `sys_action_log` VALUES ('702', '1', '7', '241771316', 'member', '7', 'zhouyi在2018-01-10 09:09:35登录了后台', '1', '1515546575');
INSERT INTO `sys_action_log` VALUES ('703', '1', '7', '241771316', 'member', '7', 'zhouyi在2018-01-10 09:34:02登录了后台', '1', '1515548042');
INSERT INTO `sys_action_log` VALUES ('704', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-10 10:05:15登录了后台', '1', '1515549915');
INSERT INTO `sys_action_log` VALUES ('705', '1', '1', '241771316', 'member', '1', 'administrator在2018-01-10 10:43:54登录了后台', '1', '1515552234');
INSERT INTO `sys_action_log` VALUES ('706', '1', '4', '241771316', 'member', '4', 'xujianhua在2018-01-10 10:48:26登录了后台', '1', '1515552506');
INSERT INTO `sys_action_log` VALUES ('707', '1', '1', '241771470', 'member', '1', 'administrator在2018-01-11 10:49:06登录了后台', '1', '1515638946');
INSERT INTO `sys_action_log` VALUES ('708', '1', '1', '241771470', 'member', '1', 'administrator在2018-01-11 16:41:13登录了后台', '1', '1515660073');
INSERT INTO `sys_action_log` VALUES ('709', '1', '1', '241771470', 'member', '1', 'administrator在2018-01-11 17:39:15登录了后台', '1', '1515663555');
INSERT INTO `sys_action_log` VALUES ('710', '1', '5', '241771470', 'member', '5', 'chenhong在2018-01-12 12:04:28登录了后台', '1', '1515729868');
INSERT INTO `sys_action_log` VALUES ('711', '1', '7', '241771148', 'member', '7', 'zhouyi在2018-01-15 10:45:51登录了后台', '1', '1515984351');
INSERT INTO `sys_action_log` VALUES ('712', '1', '1', '241771148', 'member', '1', 'administrator在2018-01-15 11:08:27登录了后台', '1', '1515985707');
INSERT INTO `sys_action_log` VALUES ('713', '1', '1', '241771148', 'member', '1', 'administrator在2018-01-15 11:41:35登录了后台', '1', '1515987695');
INSERT INTO `sys_action_log` VALUES ('714', '1', '1', '241771148', 'member', '1', 'administrator在2018-01-15 11:45:52登录了后台', '1', '1515987952');
INSERT INTO `sys_action_log` VALUES ('715', '1', '1', '241771148', 'member', '1', 'administrator在2018-01-15 14:05:49登录了后台', '1', '1515996349');
INSERT INTO `sys_action_log` VALUES ('716', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-16 14:42:45登录了后台', '1', '1516084965');
INSERT INTO `sys_action_log` VALUES ('717', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-16 14:44:27登录了后台', '1', '1516085067');
INSERT INTO `sys_action_log` VALUES ('718', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-16 14:58:11登录了后台', '1', '1516085891');
INSERT INTO `sys_action_log` VALUES ('719', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 11:44:12登录了后台', '1', '1516160652');
INSERT INTO `sys_action_log` VALUES ('720', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 11:46:00登录了后台', '1', '1516160760');
INSERT INTO `sys_action_log` VALUES ('721', '1', '11', '241771478', 'member', '11', 'test666在2018-01-17 11:47:31登录了后台', '1', '1516160851');
INSERT INTO `sys_action_log` VALUES ('722', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 11:48:02登录了后台', '1', '1516160882');
INSERT INTO `sys_action_log` VALUES ('723', '1', '11', '241771478', 'member', '11', 'test666在2018-01-17 15:05:28登录了后台', '1', '1516172728');
INSERT INTO `sys_action_log` VALUES ('724', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 15:34:32登录了后台', '1', '1516174472');
INSERT INTO `sys_action_log` VALUES ('725', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 15:36:19登录了后台', '1', '1516174579');
INSERT INTO `sys_action_log` VALUES ('726', '1', '11', '241771478', 'member', '11', 'test666在2018-01-17 15:36:34登录了后台', '1', '1516174594');
INSERT INTO `sys_action_log` VALUES ('727', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 15:37:44登录了后台', '1', '1516174664');
INSERT INTO `sys_action_log` VALUES ('728', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-17 15:39:10登录了后台', '1', '1516174750');
INSERT INTO `sys_action_log` VALUES ('729', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-18 11:09:38登录了后台', '1', '1516244978');
INSERT INTO `sys_action_log` VALUES ('730', '1', '1', '241771478', 'member', '1', 'administrator在2018-01-18 13:37:33登录了后台', '1', '1516253853');
INSERT INTO `sys_action_log` VALUES ('731', '1', '1', '241771116', 'member', '1', 'administrator在2018-01-19 08:54:20登录了后台', '1', '1516323260');
INSERT INTO `sys_action_log` VALUES ('732', '1', '1', '241771116', 'member', '1', 'administrator在2018-01-19 09:07:46登录了后台', '1', '1516324066');
INSERT INTO `sys_action_log` VALUES ('733', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-22 10:26:58登录了后台', '1', '1516588018');
INSERT INTO `sys_action_log` VALUES ('734', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-22 10:28:07登录了后台', '1', '1516588087');
INSERT INTO `sys_action_log` VALUES ('735', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-22 10:36:09登录了后台', '1', '1516588569');
INSERT INTO `sys_action_log` VALUES ('736', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-23 08:30:00登录了后台', '1', '1516667400');
INSERT INTO `sys_action_log` VALUES ('737', '1', '7', '241771301', 'member', '7', 'zhouyi在2018-01-23 09:43:32登录了后台', '1', '1516671812');
INSERT INTO `sys_action_log` VALUES ('738', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-23 09:52:17登录了后台', '1', '1516672337');
INSERT INTO `sys_action_log` VALUES ('739', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-23 10:26:04登录了后台', '1', '1516674364');
INSERT INTO `sys_action_log` VALUES ('740', '1', '1', '241771301', 'member', '1', 'administrator在2018-01-23 10:52:54登录了后台', '1', '1516675974');
INSERT INTO `sys_action_log` VALUES ('741', '1', '7', '241771019', 'member', '7', 'zhouyi在2018-01-25 08:35:43登录了后台', '1', '1516840543');
INSERT INTO `sys_action_log` VALUES ('742', '1', '1', '241771019', 'member', '1', 'administrator在2018-01-25 08:44:00登录了后台', '1', '1516841040');
INSERT INTO `sys_action_log` VALUES ('743', '1', '1', '241771073', 'member', '1', 'administrator在2018-01-25 14:00:06登录了后台', '1', '1516860006');
INSERT INTO `sys_action_log` VALUES ('744', '1', '1', '241771073', 'member', '1', 'administrator在2018-01-25 14:43:12登录了后台', '1', '1516862592');
INSERT INTO `sys_action_log` VALUES ('745', '1', '7', '241771073', 'member', '7', 'zhouyi在2018-01-25 14:50:10登录了后台', '1', '1516863010');
INSERT INTO `sys_action_log` VALUES ('746', '1', '1', '242149733', 'member', '1', 'administrator在2018-01-26 08:26:20登录了后台', '1', '1516926380');
INSERT INTO `sys_action_log` VALUES ('747', '1', '1', '242149733', 'member', '1', 'administrator在2018-01-26 08:51:54登录了后台', '1', '1516927914');
INSERT INTO `sys_action_log` VALUES ('748', '1', '1', '242149733', 'member', '1', 'administrator在2018-01-26 08:54:57登录了后台', '1', '1516928097');
INSERT INTO `sys_action_log` VALUES ('749', '1', '7', '242151197', 'member', '7', 'zhouyi在2018-01-30 09:45:34登录了后台', '1', '1517276734');
INSERT INTO `sys_action_log` VALUES ('750', '1', '1', '242151197', 'member', '1', 'administrator在2018-01-31 08:41:17登录了后台', '1', '1517359277');
INSERT INTO `sys_action_log` VALUES ('751', '1', '1', '242151197', 'member', '1', 'administrator在2018-01-31 09:07:26登录了后台', '1', '1517360846');
INSERT INTO `sys_action_log` VALUES ('752', '1', '7', '242151197', 'member', '7', 'zhouyi在2018-01-31 09:07:45登录了后台', '1', '1517360865');
INSERT INTO `sys_action_log` VALUES ('753', '1', '1', '242149812', 'member', '1', 'administrator在2018-01-31 16:38:54登录了后台', '1', '1517387934');
INSERT INTO `sys_action_log` VALUES ('754', '1', '1', '242149812', 'member', '1', 'administrator在2018-02-01 08:42:19登录了后台', '1', '1517445739');
INSERT INTO `sys_action_log` VALUES ('755', '1', '23', '242149812', 'member', '23', 'suntao在2018-02-01 08:45:09登录了后台', '1', '1517445909');
INSERT INTO `sys_action_log` VALUES ('756', '1', '1', '242149812', 'member', '1', 'administrator在2018-02-01 10:31:04登录了后台', '1', '1517452264');
INSERT INTO `sys_action_log` VALUES ('757', '1', '7', '242149812', 'member', '7', 'zhouyi在2018-02-01 14:12:00登录了后台', '1', '1517465520');
INSERT INTO `sys_action_log` VALUES ('758', '1', '1', '242149812', 'member', '1', 'administrator在2018-02-01 14:56:32登录了后台', '1', '1517468192');
INSERT INTO `sys_action_log` VALUES ('759', '1', '1', '242149812', 'member', '1', 'administrator在2018-02-02 08:29:43登录了后台', '1', '1517531383');
INSERT INTO `sys_action_log` VALUES ('760', '1', '7', '242150425', 'member', '7', 'zhouyi在2018-02-03 10:10:46登录了后台', '1', '1517623846');
INSERT INTO `sys_action_log` VALUES ('761', '1', '1', '242150425', 'member', '1', 'administrator在2018-02-03 10:31:43登录了后台', '1', '1517625103');
INSERT INTO `sys_action_log` VALUES ('762', '1', '7', '242150798', 'member', '7', 'zhouyi在2018-02-05 13:38:58登录了后台', '1', '1517809138');
INSERT INTO `sys_action_log` VALUES ('763', '1', '7', '242150798', 'member', '7', 'zhouyi在2018-02-05 14:27:23登录了后台', '1', '1517812043');
INSERT INTO `sys_action_log` VALUES ('764', '1', '1', '242149629', 'member', '1', 'administrator在2018-02-07 13:42:20登录了后台', '1', '1517982140');
INSERT INTO `sys_action_log` VALUES ('765', '1', '1', '242149629', 'member', '1', 'administrator在2018-02-07 14:02:56登录了后台', '1', '1517983376');
INSERT INTO `sys_action_log` VALUES ('766', '1', '1', '242150443', 'member', '1', 'administrator在2018-02-07 16:13:53登录了后台', '1', '1517991233');
INSERT INTO `sys_action_log` VALUES ('767', '1', '1', '242150443', 'member', '1', 'administrator在2018-02-08 09:27:46登录了后台', '1', '1518053266');
INSERT INTO `sys_action_log` VALUES ('768', '1', '1', '242150443', 'member', '1', 'administrator在2018-02-08 09:58:35登录了后台', '1', '1518055115');
INSERT INTO `sys_action_log` VALUES ('769', '1', '1', '242151064', 'member', '1', 'administrator在2018-02-08 11:51:25登录了后台', '1', '1518061885');
INSERT INTO `sys_action_log` VALUES ('770', '1', '24', '242151064', 'member', '24', 'absolutenessofli在2018-02-08 14:50:32登录了后台', '1', '1518072632');
INSERT INTO `sys_action_log` VALUES ('771', '1', '1', '242150282', 'member', '1', 'administrator在2018-02-09 10:03:39登录了后台', '1', '1518141819');
INSERT INTO `sys_action_log` VALUES ('772', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-23 15:23:02登录了后台', '1', '1519370582');
INSERT INTO `sys_action_log` VALUES ('773', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-23 16:02:35登录了后台', '1', '1519372955');
INSERT INTO `sys_action_log` VALUES ('774', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 08:28:37登录了后台', '1', '1519432117');
INSERT INTO `sys_action_log` VALUES ('775', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 09:31:47登录了后台', '1', '1519435907');
INSERT INTO `sys_action_log` VALUES ('776', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 09:40:22登录了后台', '1', '1519436422');
INSERT INTO `sys_action_log` VALUES ('777', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 09:47:05登录了后台', '1', '1519436825');
INSERT INTO `sys_action_log` VALUES ('778', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 10:24:42登录了后台', '1', '1519439082');
INSERT INTO `sys_action_log` VALUES ('779', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 14:04:59登录了后台', '1', '1519452299');
INSERT INTO `sys_action_log` VALUES ('780', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 14:08:36登录了后台', '1', '1519452516');
INSERT INTO `sys_action_log` VALUES ('781', '1', '1', '242149594', 'member', '1', 'administrator在2018-02-24 14:40:21登录了后台', '1', '1519454421');
INSERT INTO `sys_action_log` VALUES ('782', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-24 15:52:59登录了后台', '1', '1519458779');
INSERT INTO `sys_action_log` VALUES ('783', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 08:50:30登录了后台', '1', '1519606230');
INSERT INTO `sys_action_log` VALUES ('784', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 08:57:30登录了后台', '1', '1519606650');
INSERT INTO `sys_action_log` VALUES ('785', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 08:58:54登录了后台', '1', '1519606734');
INSERT INTO `sys_action_log` VALUES ('786', '1', '11', '242150565', 'member', '11', 'test666在2018-02-26 09:26:02登录了后台', '1', '1519608362');
INSERT INTO `sys_action_log` VALUES ('787', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 09:27:20登录了后台', '1', '1519608440');
INSERT INTO `sys_action_log` VALUES ('788', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 09:33:56登录了后台', '1', '1519608836');
INSERT INTO `sys_action_log` VALUES ('789', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 10:16:30登录了后台', '1', '1519611390');
INSERT INTO `sys_action_log` VALUES ('790', '1', '21', '242150565', 'member', '21', 'test88在2018-02-26 10:17:16登录了后台', '1', '1519611436');
INSERT INTO `sys_action_log` VALUES ('791', '1', '21', '242150565', 'member', '21', 'test88在2018-02-26 13:45:59登录了后台', '1', '1519623959');
INSERT INTO `sys_action_log` VALUES ('792', '1', '1', '242150565', 'member', '1', 'administrator在2018-02-26 14:11:36登录了后台', '1', '1519625496');
INSERT INTO `sys_action_log` VALUES ('793', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-26 16:11:22登录了后台', '1', '1519632682');
INSERT INTO `sys_action_log` VALUES ('794', '1', '7', '242149885', 'member', '7', 'zhouyi在2018-02-27 08:48:30登录了后台', '1', '1519692510');
INSERT INTO `sys_action_log` VALUES ('795', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 14:39:54登录了后台', '1', '1519713594');
INSERT INTO `sys_action_log` VALUES ('796', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 14:43:30登录了后台', '1', '1519713810');
INSERT INTO `sys_action_log` VALUES ('797', '1', '11', '242149885', 'member', '11', 'test666在2018-02-27 14:48:49登录了后台', '1', '1519714129');
INSERT INTO `sys_action_log` VALUES ('798', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 14:50:19登录了后台', '1', '1519714219');
INSERT INTO `sys_action_log` VALUES ('799', '1', '21', '242149885', 'member', '21', 'test88在2018-02-27 14:50:51登录了后台', '1', '1519714251');
INSERT INTO `sys_action_log` VALUES ('800', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 14:51:55登录了后台', '1', '1519714315');
INSERT INTO `sys_action_log` VALUES ('801', '1', '21', '242149885', 'member', '21', 'test88在2018-02-27 14:54:49登录了后台', '1', '1519714489');
INSERT INTO `sys_action_log` VALUES ('802', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 15:02:17登录了后台', '1', '1519714937');
INSERT INTO `sys_action_log` VALUES ('803', '1', '21', '242149885', 'member', '21', 'test88在2018-02-27 16:39:46登录了后台', '1', '1519720786');
INSERT INTO `sys_action_log` VALUES ('804', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-27 16:40:23登录了后台', '1', '1519720823');
INSERT INTO `sys_action_log` VALUES ('805', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-28 08:52:18登录了后台', '1', '1519779138');
INSERT INTO `sys_action_log` VALUES ('806', '1', '1', '242149885', 'member', '1', 'administrator在2018-02-28 11:18:04登录了后台', '1', '1519787884');
INSERT INTO `sys_action_log` VALUES ('807', '1', '1', '242151293', 'member', '1', 'administrator在2018-03-05 17:19:18登录了后台', '1', '1520241558');
INSERT INTO `sys_action_log` VALUES ('808', '1', '1', '242151293', 'member', '1', 'administrator在2018-03-06 08:45:49登录了后台', '1', '1520297149');
INSERT INTO `sys_action_log` VALUES ('809', '1', '1', '242151293', 'member', '1', 'administrator在2018-03-06 09:40:24登录了后台', '1', '1520300424');
INSERT INTO `sys_action_log` VALUES ('810', '1', '1', '242151293', 'member', '1', 'administrator在2018-03-06 10:55:49登录了后台', '1', '1520304949');
INSERT INTO `sys_action_log` VALUES ('811', '1', '1', '242149797', 'member', '1', 'administrator在2018-03-06 15:49:27登录了后台', '1', '1520322567');
INSERT INTO `sys_action_log` VALUES ('812', '1', '1', '242149797', 'member', '1', 'administrator在2018-03-06 17:26:59登录了后台', '1', '1520328419');
INSERT INTO `sys_action_log` VALUES ('813', '1', '1', '242149797', 'member', '1', 'administrator在2018-03-07 08:41:50登录了后台', '1', '1520383310');
INSERT INTO `sys_action_log` VALUES ('814', '1', '1', '242149797', 'member', '1', 'administrator在2018-03-07 09:57:28登录了后台', '1', '1520387848');
INSERT INTO `sys_action_log` VALUES ('815', '1', '1', '242150932', 'member', '1', 'administrator在2018-03-19 14:35:34登录了后台', '1', '1521441334');
INSERT INTO `sys_action_log` VALUES ('816', '1', '1', '242150932', 'member', '1', 'administrator在2018-03-19 15:12:42登录了后台', '1', '1521443562');
INSERT INTO `sys_action_log` VALUES ('817', '1', '1', '242149978', 'member', '1', 'administrator在2018-03-30 15:04:27登录了后台', '1', '1522393467');
INSERT INTO `sys_action_log` VALUES ('818', '1', '1', '242150760', 'member', '1', 'administrator在2018-04-08 08:57:14登录了后台', '1', '1523149034');
INSERT INTO `sys_action_log` VALUES ('819', '1', '1', '242151240', 'member', '1', 'administrator在2018-04-18 09:17:42登录了后台', '1', '1524014262');
INSERT INTO `sys_action_log` VALUES ('820', '1', '1', '242151003', 'member', '1', 'administrator在2018-04-19 16:21:41登录了后台', '1', '1524126101');
INSERT INTO `sys_action_log` VALUES ('821', '1', '1', '242150777', 'member', '1', 'administrator在2018-06-01 14:16:52登录了后台', '1', '1527833812');
INSERT INTO `sys_action_log` VALUES ('822', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-25 10:50:02登录了后台', '1', '1529895002');
INSERT INTO `sys_action_log` VALUES ('823', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-25 15:02:37登录了后台', '1', '1529910157');
INSERT INTO `sys_action_log` VALUES ('824', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-26 09:07:15登录了后台', '1', '1529975235');
INSERT INTO `sys_action_log` VALUES ('825', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-26 09:41:01登录了后台', '1', '1529977261');
INSERT INTO `sys_action_log` VALUES ('826', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-26 17:43:05登录了后台', '1', '1530006185');
INSERT INTO `sys_action_log` VALUES ('827', '1', '1', '242151342', 'member', '1', 'administrator在2018-06-26 18:49:37登录了后台', '1', '1530010177');
INSERT INTO `sys_action_log` VALUES ('828', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 08:39:52登录了后台', '1', '1530059992');
INSERT INTO `sys_action_log` VALUES ('829', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 10:40:54登录了后台', '1', '1530067254');
INSERT INTO `sys_action_log` VALUES ('830', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 10:45:06登录了后台', '1', '1530067506');
INSERT INTO `sys_action_log` VALUES ('831', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 10:50:17登录了后台', '1', '1530067817');
INSERT INTO `sys_action_log` VALUES ('832', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 10:58:27登录了后台', '1', '1530068307');
INSERT INTO `sys_action_log` VALUES ('833', '1', '1', '242149574', 'member', '1', 'administrator在2018-06-27 14:53:31登录了后台', '1', '1530082411');
INSERT INTO `sys_action_log` VALUES ('834', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 08:43:52登录了后台', '1', '1530492232');
INSERT INTO `sys_action_log` VALUES ('835', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 09:51:11登录了后台', '1', '1530496271');
INSERT INTO `sys_action_log` VALUES ('836', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 10:20:12登录了后台', '1', '1530498012');
INSERT INTO `sys_action_log` VALUES ('837', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 11:07:15登录了后台', '1', '1530500835');
INSERT INTO `sys_action_log` VALUES ('838', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 14:51:02登录了后台', '1', '1530514262');
INSERT INTO `sys_action_log` VALUES ('839', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 15:10:00登录了后台', '1', '1530515400');
INSERT INTO `sys_action_log` VALUES ('840', '1', '23', '242150369', 'member', '23', 'suntao在2018-07-02 15:36:59登录了后台', '1', '1530517019');
INSERT INTO `sys_action_log` VALUES ('841', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 17:17:10登录了后台', '1', '1530523030');
INSERT INTO `sys_action_log` VALUES ('842', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 17:19:34登录了后台', '1', '1530523174');
INSERT INTO `sys_action_log` VALUES ('843', '1', '21', '242150369', 'member', '21', 'test88在2018-07-02 17:21:48登录了后台', '1', '1530523308');
INSERT INTO `sys_action_log` VALUES ('844', '1', '1', '242150369', 'member', '1', 'administrator在2018-07-02 17:28:56登录了后台', '1', '1530523736');
INSERT INTO `sys_action_log` VALUES ('845', '1', '21', '242151150', 'member', '21', 'test88在2018-07-03 08:40:01登录了后台', '1', '1530578401');
INSERT INTO `sys_action_log` VALUES ('846', '1', '1', '242151150', 'member', '1', 'administrator在2018-07-04 08:45:17登录了后台', '1', '1530665117');
INSERT INTO `sys_action_log` VALUES ('847', '1', '1', '242151150', 'member', '1', 'administrator在2018-07-04 08:57:46登录了后台', '1', '1530665866');
INSERT INTO `sys_action_log` VALUES ('848', '1', '21', '242151150', 'member', '21', 'test88在2018-07-04 16:56:41登录了后台', '1', '1530694601');
INSERT INTO `sys_action_log` VALUES ('849', '1', '21', '242150294', 'member', '21', 'test88在2018-07-06 13:55:16登录了后台', '1', '1530856516');
INSERT INTO `sys_action_log` VALUES ('850', '1', '21', '242150399', 'member', '21', 'test88在2018-07-09 16:28:48登录了后台', '1', '1531124928');
INSERT INTO `sys_action_log` VALUES ('851', '1', '1', '242150399', 'member', '1', 'administrator在2018-07-10 15:49:56登录了后台', '1', '1531208996');
INSERT INTO `sys_action_log` VALUES ('852', '1', '21', '242150399', 'member', '21', 'test88在2018-07-10 15:56:39登录了后台', '1', '1531209399');
INSERT INTO `sys_action_log` VALUES ('853', '1', '21', '242150399', 'member', '21', 'test88在2018-07-10 16:48:46登录了后台', '1', '1531212526');
INSERT INTO `sys_action_log` VALUES ('854', '1', '1', '242150516', 'member', '1', 'administrator在2018-07-12 17:26:46登录了后台', '1', '1531387606');
INSERT INTO `sys_action_log` VALUES ('855', '1', '1', '242150596', 'member', '1', 'administrator在2018-07-13 09:05:59登录了后台', '1', '1531443959');
INSERT INTO `sys_action_log` VALUES ('856', '1', '1', '242150186', 'member', '1', 'administrator在2018-07-16 17:15:36登录了后台', '1', '1531732536');
INSERT INTO `sys_action_log` VALUES ('857', '1', '1', '242150446', 'member', '1', 'administrator在2018-07-23 11:01:00登录了后台', '1', '1532314860');
INSERT INTO `sys_action_log` VALUES ('858', '1', '1', '242150446', 'member', '1', 'administrator在2018-07-24 14:04:27登录了后台', '1', '1532412267');
INSERT INTO `sys_action_log` VALUES ('859', '1', '1', '242150131', 'member', '1', 'administrator在2018-07-25 11:12:18登录了后台', '1', '1532488338');
INSERT INTO `sys_action_log` VALUES ('860', '1', '1', '242150131', 'member', '1', 'administrator在2018-07-25 11:15:42登录了后台', '1', '1532488542');
INSERT INTO `sys_action_log` VALUES ('861', '1', '1', '242150131', 'member', '1', 'administrator在2018-07-25 11:25:28登录了后台', '1', '1532489128');
INSERT INTO `sys_action_log` VALUES ('862', '1', '1', '242150131', 'member', '1', 'administrator在2018-07-25 14:25:45登录了后台', '1', '1532499945');
INSERT INTO `sys_action_log` VALUES ('863', '1', '1', '242149621', 'member', '1', 'administrator在2018-07-27 08:49:37登录了后台', '1', '1532652577');
INSERT INTO `sys_action_log` VALUES ('864', '1', '1', '242149621', 'member', '1', 'administrator在2018-07-27 09:56:29登录了后台', '1', '1532656589');
INSERT INTO `sys_action_log` VALUES ('865', '1', '1', '242150456', 'member', '1', 'administrator在2018-07-30 08:44:19登录了后台', '1', '1532911459');
INSERT INTO `sys_action_log` VALUES ('866', '1', '1', '242150478', 'member', '1', 'administrator在2018-08-03 11:54:29登录了后台', '1', '1533268469');
INSERT INTO `sys_action_log` VALUES ('867', '1', '1', '242150478', 'member', '1', 'administrator在2018-08-03 14:17:16登录了后台', '1', '1533277036');
INSERT INTO `sys_action_log` VALUES ('868', '1', '21', '242150478', 'member', '21', 'test88在2018-08-03 14:32:05登录了后台', '1', '1533277925');
INSERT INTO `sys_action_log` VALUES ('869', '1', '1', '242150478', 'member', '1', 'administrator在2018-08-03 14:35:00登录了后台', '1', '1533278100');
INSERT INTO `sys_action_log` VALUES ('870', '1', '1', '2130706433', 'member', '1', '在2018-08-06 15:13:03登录了后台', '1', '1533539583');
INSERT INTO `sys_action_log` VALUES ('871', '1', '1', '2130706433', 'member', '1', '在2018-08-06 15:15:05登录了后台', '1', '1533539705');
INSERT INTO `sys_action_log` VALUES ('872', '1', '1', '2130706433', 'member', '1', '在2018-08-06 15:19:00登录了后台', '1', '1533539940');
INSERT INTO `sys_action_log` VALUES ('873', '1', '1', '2130706433', 'member', '1', '在2018-08-06 15:19:24登录了后台', '1', '1533539964');
INSERT INTO `sys_action_log` VALUES ('874', '1', '1', '2130706433', 'member', '1', '在2018-08-06 15:23:33登录了后台', '1', '1533540213');
INSERT INTO `sys_action_log` VALUES ('875', '1', '1', '3232235917', 'member', '1', '在2018-08-09 14:19:55登录了后台', '1', '1533795595');
INSERT INTO `sys_action_log` VALUES ('876', '1', '1', '3232235917', 'member', '1', '在2018-08-09 14:19:57登录了后台', '1', '1533795597');
INSERT INTO `sys_action_log` VALUES ('877', '1', '1', '2130706433', 'member', '1', '在2018-08-09 16:15:13登录了后台', '1', '1533802513');
INSERT INTO `sys_action_log` VALUES ('878', '1', '1', '2130706433', 'member', '1', '在2018-08-10 08:50:35登录了后台', '1', '1533862235');
INSERT INTO `sys_action_log` VALUES ('879', '1', '1', '2130706433', 'member', '1', '在2018-08-10 08:51:05登录了后台', '1', '1533862265');
INSERT INTO `sys_action_log` VALUES ('880', '1', '1', '3232235917', 'member', '1', '在2018-08-10 08:55:59登录了后台', '1', '1533862559');
INSERT INTO `sys_action_log` VALUES ('881', '1', '1', '3232235917', 'member', '1', '在2018-08-10 08:56:00登录了后台', '1', '1533862560');
INSERT INTO `sys_action_log` VALUES ('882', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:54:19登录了后台', '1', '1533866059');
INSERT INTO `sys_action_log` VALUES ('883', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:54:36登录了后台', '1', '1533866076');
INSERT INTO `sys_action_log` VALUES ('884', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:54:38登录了后台', '1', '1533866078');
INSERT INTO `sys_action_log` VALUES ('885', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:54:53登录了后台', '1', '1533866093');
INSERT INTO `sys_action_log` VALUES ('886', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:55:22登录了后台', '1', '1533866122');
INSERT INTO `sys_action_log` VALUES ('887', '1', '1', '3232235917', 'member', '1', '在2018-08-10 09:55:46登录了后台', '1', '1533866146');
INSERT INTO `sys_action_log` VALUES ('888', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:03:05登录了后台', '1', '1533866585');
INSERT INTO `sys_action_log` VALUES ('889', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:03:34登录了后台', '1', '1533866614');
INSERT INTO `sys_action_log` VALUES ('890', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:03:35登录了后台', '1', '1533866615');
INSERT INTO `sys_action_log` VALUES ('891', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:04:17登录了后台', '1', '1533866657');
INSERT INTO `sys_action_log` VALUES ('892', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:04:40登录了后台', '1', '1533866680');
INSERT INTO `sys_action_log` VALUES ('893', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:07:57登录了后台', '1', '1533866877');
INSERT INTO `sys_action_log` VALUES ('894', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:07:59登录了后台', '1', '1533866879');
INSERT INTO `sys_action_log` VALUES ('895', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:08:36登录了后台', '1', '1533866916');
INSERT INTO `sys_action_log` VALUES ('896', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:09:41登录了后台', '1', '1533866981');
INSERT INTO `sys_action_log` VALUES ('897', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:09:43登录了后台', '1', '1533866983');
INSERT INTO `sys_action_log` VALUES ('898', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:10:06登录了后台', '1', '1533867006');
INSERT INTO `sys_action_log` VALUES ('899', '1', '1', '3232235917', 'member', '1', '在2018-08-10 10:11:43登录了后台', '1', '1533867103');
INSERT INTO `sys_action_log` VALUES ('900', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:14:04登录了后台', '1', '1533867244');
INSERT INTO `sys_action_log` VALUES ('901', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:14:31登录了后台', '1', '1533867271');
INSERT INTO `sys_action_log` VALUES ('902', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:20:17登录了后台', '1', '1533867617');
INSERT INTO `sys_action_log` VALUES ('903', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:52:04登录了后台', '1', '1533869524');
INSERT INTO `sys_action_log` VALUES ('904', '1', '1', '2130706433', 'member', '1', '在2018-08-10 10:55:38登录了后台', '1', '1533869738');
INSERT INTO `sys_action_log` VALUES ('905', '1', '1', '3232235917', 'member', '1', '在2018-08-10 11:18:49登录了后台', '1', '1533871129');
INSERT INTO `sys_action_log` VALUES ('906', '1', '1', '3232235917', 'member', '1', '在2018-08-10 11:18:50登录了后台', '1', '1533871130');
INSERT INTO `sys_action_log` VALUES ('907', '1', '1', '3232235917', 'member', '1', '在2018-08-10 11:19:06登录了后台', '1', '1533871146');
INSERT INTO `sys_action_log` VALUES ('908', '1', '1', '3232235917', 'member', '1', '在2018-08-10 11:19:07登录了后台', '1', '1533871147');
INSERT INTO `sys_action_log` VALUES ('909', '1', '1', '3232235917', 'member', '1', '在2018-08-10 11:20:07登录了后台', '1', '1533871207');
INSERT INTO `sys_action_log` VALUES ('910', '1', '1', '2130706433', 'member', '1', '在2018-08-10 11:22:18登录了后台', '1', '1533871338');
INSERT INTO `sys_action_log` VALUES ('911', '1', '1', '3232235917', 'member', '1', '在2018-08-10 16:02:49登录了后台', '1', '1533888169');
INSERT INTO `sys_action_log` VALUES ('912', '1', '1', '3232235917', 'member', '1', '在2018-08-10 16:03:24登录了后台', '1', '1533888204');
INSERT INTO `sys_action_log` VALUES ('913', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:05:14登录了后台', '1', '1533888314');
INSERT INTO `sys_action_log` VALUES ('914', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:05:19登录了后台', '1', '1533888319');
INSERT INTO `sys_action_log` VALUES ('915', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:05:37登录了后台', '1', '1533888337');
INSERT INTO `sys_action_log` VALUES ('916', '1', '1', '2130706433', 'member', '1', '在2018-08-10 16:06:45登录了后台', '1', '1533888405');
INSERT INTO `sys_action_log` VALUES ('917', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:08:31登录了后台', '1', '1533888511');
INSERT INTO `sys_action_log` VALUES ('918', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:08:52登录了后台', '1', '1533888532');
INSERT INTO `sys_action_log` VALUES ('919', '1', '1', '2130706433', 'member', '1', '在2018-08-10 16:09:16登录了后台', '1', '1533888556');
INSERT INTO `sys_action_log` VALUES ('920', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:09:50登录了后台', '1', '1533888590');
INSERT INTO `sys_action_log` VALUES ('921', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:13:42登录了后台', '1', '1533888822');
INSERT INTO `sys_action_log` VALUES ('922', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:15:05登录了后台', '1', '1533888905');
INSERT INTO `sys_action_log` VALUES ('923', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:16:04登录了后台', '1', '1533888964');
INSERT INTO `sys_action_log` VALUES ('924', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:16:52登录了后台', '1', '1533889012');
INSERT INTO `sys_action_log` VALUES ('925', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:16:59登录了后台', '1', '1533889019');
INSERT INTO `sys_action_log` VALUES ('926', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:18:21登录了后台', '1', '1533889101');
INSERT INTO `sys_action_log` VALUES ('927', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:23:54登录了后台', '1', '1533889434');
INSERT INTO `sys_action_log` VALUES ('928', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:25:06登录了后台', '1', '1533889506');
INSERT INTO `sys_action_log` VALUES ('929', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:28:16登录了后台', '1', '1533889696');
INSERT INTO `sys_action_log` VALUES ('930', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:29:56登录了后台', '1', '1533889796');
INSERT INTO `sys_action_log` VALUES ('931', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:30:03登录了后台', '1', '1533889803');
INSERT INTO `sys_action_log` VALUES ('932', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:30:20登录了后台', '1', '1533889820');
INSERT INTO `sys_action_log` VALUES ('933', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:58:06登录了后台', '1', '1533891486');
INSERT INTO `sys_action_log` VALUES ('934', '1', '1', '3232235889', 'member', '1', '在2018-08-10 16:58:13登录了后台', '1', '1533891493');
INSERT INTO `sys_action_log` VALUES ('935', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:00:28登录了后台', '1', '1533891628');
INSERT INTO `sys_action_log` VALUES ('936', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:00:37登录了后台', '1', '1533891637');
INSERT INTO `sys_action_log` VALUES ('937', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:00:48登录了后台', '1', '1533891648');
INSERT INTO `sys_action_log` VALUES ('938', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:00:53登录了后台', '1', '1533891653');
INSERT INTO `sys_action_log` VALUES ('939', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:06:46登录了后台', '1', '1533892006');
INSERT INTO `sys_action_log` VALUES ('940', '1', '1', '2130706433', 'member', '1', '在2018-08-10 17:07:41登录了后台', '1', '1533892061');
INSERT INTO `sys_action_log` VALUES ('941', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:09:25登录了后台', '1', '1533892165');
INSERT INTO `sys_action_log` VALUES ('942', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:09:37登录了后台', '1', '1533892177');
INSERT INTO `sys_action_log` VALUES ('943', '1', '1', '2130706433', 'member', '1', '在2018-08-10 17:13:10登录了后台', '1', '1533892390');
INSERT INTO `sys_action_log` VALUES ('944', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:14:03登录了后台', '1', '1533892443');
INSERT INTO `sys_action_log` VALUES ('945', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:18:57登录了后台', '1', '1533892737');
INSERT INTO `sys_action_log` VALUES ('946', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:29:11登录了后台', '1', '1533893351');
INSERT INTO `sys_action_log` VALUES ('947', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:30:10登录了后台', '1', '1533893410');
INSERT INTO `sys_action_log` VALUES ('948', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:30:38登录了后台', '1', '1533893438');
INSERT INTO `sys_action_log` VALUES ('949', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:30:46登录了后台', '1', '1533893446');
INSERT INTO `sys_action_log` VALUES ('950', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:30:58登录了后台', '1', '1533893458');
INSERT INTO `sys_action_log` VALUES ('951', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:31:04登录了后台', '1', '1533893464');
INSERT INTO `sys_action_log` VALUES ('952', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:31:08登录了后台', '1', '1533893468');
INSERT INTO `sys_action_log` VALUES ('953', '1', '1', '3232235889', 'member', '1', '在2018-08-10 17:31:13登录了后台', '1', '1533893473');
INSERT INTO `sys_action_log` VALUES ('954', '1', '1', '3232235889', 'member', '1', '在2018-08-13 09:16:53登录了后台', '1', '1534123013');
INSERT INTO `sys_action_log` VALUES ('955', '1', '1', '3232235889', 'member', '1', '在2018-08-13 09:16:59登录了后台', '1', '1534123019');
INSERT INTO `sys_action_log` VALUES ('956', '1', '1', '3232235889', 'member', '1', '在2018-08-13 09:18:41登录了后台', '1', '1534123121');
INSERT INTO `sys_action_log` VALUES ('957', '1', '1', '2130706433', 'member', '1', '在2018-08-13 09:43:07登录了后台', '1', '1534124587');
INSERT INTO `sys_action_log` VALUES ('958', '1', '1', '3232235984', 'member', '1', '在2018-08-21 10:08:21登录了后台', '1', '1534817301');
INSERT INTO `sys_action_log` VALUES ('959', '1', '1', '3232235984', 'member', '1', '在2018-08-21 10:08:25登录了后台', '1', '1534817305');
INSERT INTO `sys_action_log` VALUES ('960', '1', '1', '2130706433', 'member', '1', '在2018-08-29 16:27:51登录了后台', '1', '1535531271');
INSERT INTO `sys_action_log` VALUES ('961', '1', '1', '2130706433', 'member', '1', '在2018-08-29 16:27:56登录了后台', '1', '1535531276');
INSERT INTO `sys_action_log` VALUES ('962', '1', '1', '2130706433', 'member', '1', '在2018-08-29 16:29:04登录了后台', '1', '1535531344');
INSERT INTO `sys_action_log` VALUES ('963', '1', '1', '2130706433', 'member', '1', '在2018-08-29 16:31:07登录了后台', '1', '1535531467');
INSERT INTO `sys_action_log` VALUES ('964', '1', '1', '2130706433', 'member', '1', '在2018-08-31 16:46:10登录了后台', '1', '1535705170');
INSERT INTO `sys_action_log` VALUES ('965', '1', '1', '2130706433', 'member', '1', '在2018-08-31 16:46:13登录了后台', '1', '1535705173');
INSERT INTO `sys_action_log` VALUES ('966', '1', '1', '2130706433', 'member', '1', '在2018-09-05 17:11:51登录了后台', '1', '1536138711');
INSERT INTO `sys_action_log` VALUES ('967', '1', '1', '2130706433', 'member', '1', '在2018-09-05 17:11:56登录了后台', '1', '1536138716');
INSERT INTO `sys_action_log` VALUES ('968', '1', '1', '2130706433', 'member', '1', '在2018-09-05 17:11:57登录了后台', '1', '1536138717');
INSERT INTO `sys_action_log` VALUES ('969', '1', '1', '2130706433', 'member', '1', '在2018-09-12 08:34:14登录了后台', '1', '1536712454');
INSERT INTO `sys_action_log` VALUES ('970', '1', '1', '2130706433', 'member', '1', '在2018-09-12 08:34:21登录了后台', '1', '1536712461');
INSERT INTO `sys_action_log` VALUES ('971', '1', '1', '2130706433', 'member', '1', '在2018-09-12 11:14:59登录了后台', '1', '1536722099');
INSERT INTO `sys_action_log` VALUES ('972', '1', '1', '2130706433', 'member', '1', '在2018-09-13 08:53:58登录了后台', '1', '1536800038');
INSERT INTO `sys_action_log` VALUES ('973', '1', '1', '2130706433', 'member', '1', '在2018-09-13 17:00:38登录了后台', '1', '1536829238');
INSERT INTO `sys_action_log` VALUES ('974', '1', '1', '2130706433', 'member', '1', '在2018-09-14 08:37:28登录了后台', '1', '1536885448');
INSERT INTO `sys_action_log` VALUES ('975', '1', '1', '2130706433', 'member', '1', '在2018-09-17 15:11:35登录了后台', '1', '1537168295');
INSERT INTO `sys_action_log` VALUES ('976', '1', '1', '2130706433', 'member', '1', '在2018-09-17 15:11:37登录了后台', '1', '1537168297');
INSERT INTO `sys_action_log` VALUES ('977', '1', '1', '2130706433', 'member', '1', '在2018-09-18 10:49:41登录了后台', '1', '1537238981');
INSERT INTO `sys_action_log` VALUES ('978', '1', '1', '2130706433', 'member', '1', '在2018-09-18 15:45:21登录了后台', '1', '1537256721');
INSERT INTO `sys_action_log` VALUES ('979', '1', '1', '3232235831', 'member', '1', '在2018-09-18 16:56:22登录了后台', '1', '1537260982');
INSERT INTO `sys_action_log` VALUES ('980', '1', '1', '3232235831', 'member', '1', '在2018-09-19 08:32:25登录了后台', '1', '1537317145');
INSERT INTO `sys_action_log` VALUES ('981', '1', '1', '2130706433', 'member', '1', '在2018-09-19 08:38:30登录了后台', '1', '1537317510');
INSERT INTO `sys_action_log` VALUES ('982', '1', '1', '3232236027', 'member', '1', '在2018-09-19 13:26:51登录了后台', '1', '1537334811');
INSERT INTO `sys_action_log` VALUES ('983', '1', '1', '2130706433', 'member', '1', '在2018-09-19 14:11:10登录了后台', '1', '1537337470');
INSERT INTO `sys_action_log` VALUES ('984', '1', '1', '2130706433', 'member', '1', '在2018-09-20 09:43:22登录了后台', '1', '1537407802');
INSERT INTO `sys_action_log` VALUES ('985', '1', '1', '3232235831', 'member', '1', '在2018-09-20 11:54:08登录了后台', '1', '1537415648');
INSERT INTO `sys_action_log` VALUES ('986', '1', '1', '2130706433', 'member', '1', '在2018-09-20 16:25:55登录了后台', '1', '1537431955');
INSERT INTO `sys_action_log` VALUES ('987', '1', '1', '2130706433', 'member', '1', '在2018-09-20 16:25:57登录了后台', '1', '1537431957');
INSERT INTO `sys_action_log` VALUES ('988', '1', '1', '2130706433', 'member', '1', '在2018-09-21 09:07:45登录了后台', '1', '1537492065');
INSERT INTO `sys_action_log` VALUES ('989', '1', '1', '3232236027', 'member', '1', '在2018-09-25 08:39:12登录了后台', '1', '1537835952');
INSERT INTO `sys_action_log` VALUES ('990', '1', '1', '3232236027', 'member', '1', '在2018-09-25 08:39:24登录了后台', '1', '1537835964');
INSERT INTO `sys_action_log` VALUES ('991', '1', '1', '2130706433', 'member', '1', '在2018-09-25 09:51:38登录了后台', '1', '1537840298');
INSERT INTO `sys_action_log` VALUES ('992', '1', '1', '3232236027', 'member', '1', '在2018-09-26 08:28:25登录了后台', '1', '1537921705');
INSERT INTO `sys_action_log` VALUES ('993', '1', '1', '2130706433', 'member', '1', '在2018-09-26 08:38:46登录了后台', '1', '1537922326');
INSERT INTO `sys_action_log` VALUES ('994', '1', '1', '3232235831', 'member', '1', '在2018-09-26 10:24:27登录了后台', '1', '1537928667');
INSERT INTO `sys_action_log` VALUES ('995', '1', '1', '3232235831', 'member', '1', '在2018-09-26 10:24:28登录了后台', '1', '1537928668');
INSERT INTO `sys_action_log` VALUES ('996', '1', '1', '3232235831', 'member', '1', '在2018-09-26 15:46:55登录了后台', '1', '1537948015');
INSERT INTO `sys_action_log` VALUES ('997', '1', '1', '2130706433', 'member', '1', '在2018-09-27 10:45:43登录了后台', '1', '1538016343');
INSERT INTO `sys_action_log` VALUES ('998', '1', '1', '3232235831', 'member', '1', '在2018-09-27 14:48:19登录了后台', '1', '1538030899');
INSERT INTO `sys_action_log` VALUES ('999', '1', '1', '3232235831', 'member', '1', '在2018-09-28 11:03:58登录了后台', '1', '1538103838');
INSERT INTO `sys_action_log` VALUES ('1000', '1', '1', '2130706433', 'member', '1', '在2018-09-28 14:04:59登录了后台', '1', '1538114699');
INSERT INTO `sys_action_log` VALUES ('1001', '1', '1', '2130706433', 'member', '1', '在2018-09-28 15:08:22登录了后台', '1', '1538118502');
INSERT INTO `sys_action_log` VALUES ('1002', '1', '1', '3232235831', 'member', '1', '在2018-09-29 08:36:57登录了后台', '1', '1538181417');
INSERT INTO `sys_action_log` VALUES ('1003', '1', '1', '2130706433', 'member', '1', '在2018-09-29 08:43:08登录了后台', '1', '1538181788');
INSERT INTO `sys_action_log` VALUES ('1004', '1', '1', '3232236027', 'member', '1', '在2018-09-29 08:46:04登录了后台', '1', '1538181964');
INSERT INTO `sys_action_log` VALUES ('1005', '1', '1', '3232235913', 'member', '1', '在2018-10-08 09:03:39登录了后台', '1', '1538960619');
INSERT INTO `sys_action_log` VALUES ('1006', '1', '1', '3232235913', 'member', '1', '在2018-10-08 09:04:51登录了后台', '1', '1538960691');
INSERT INTO `sys_action_log` VALUES ('1007', '1', '1', '3232235913', 'member', '1', '在2018-10-08 11:41:38登录了后台', '1', '1538970098');
INSERT INTO `sys_action_log` VALUES ('1008', '1', '1', '3232235913', 'member', '1', '在2018-10-08 14:08:49登录了后台', '1', '1538978929');
INSERT INTO `sys_action_log` VALUES ('1009', '1', '1', '2130706433', 'member', '1', '在2018-10-09 11:40:59登录了后台', '1', '1539056459');
INSERT INTO `sys_action_log` VALUES ('1010', '1', '1', '2130706433', 'member', '1', '在2018-10-09 14:56:57登录了后台', '1', '1539068217');
INSERT INTO `sys_action_log` VALUES ('1011', '1', '1', '3232235913', 'member', '1', '在2018-10-09 16:53:33登录了后台', '1', '1539075213');
INSERT INTO `sys_action_log` VALUES ('1012', '1', '1', '3232235913', 'member', '1', '在2018-10-10 09:35:33登录了后台', '1', '1539135333');
INSERT INTO `sys_action_log` VALUES ('1013', '1', '1', '3232235913', 'member', '1', '在2018-10-10 11:30:15登录了后台', '1', '1539142215');
INSERT INTO `sys_action_log` VALUES ('1014', '1', '1', '3232235913', 'member', '1', '在2018-10-10 17:14:28登录了后台', '1', '1539162868');
INSERT INTO `sys_action_log` VALUES ('1015', '1', '1', '2130706433', 'member', '1', '在2018-10-11 14:58:13登录了后台', '1', '1539241093');
INSERT INTO `sys_action_log` VALUES ('1016', '1', '1', '3232235913', 'member', '1', '在2018-10-11 16:26:53登录了后台', '1', '1539246413');
INSERT INTO `sys_action_log` VALUES ('1017', '1', '1', '2130706433', 'member', '1', '在2018-10-12 08:49:33登录了后台', '1', '1539305373');
INSERT INTO `sys_action_log` VALUES ('1018', '1', '1', '3232235831', 'member', '1', '在2018-10-12 09:44:43登录了后台', '1', '1539308683');
INSERT INTO `sys_action_log` VALUES ('1019', '1', '1', '2130706433', 'member', '1', '在2018-10-12 10:16:29登录了后台', '1', '1539310589');
INSERT INTO `sys_action_log` VALUES ('1020', '1', '1', '3232235980', 'member', '1', '在2018-10-12 11:59:14登录了后台', '1', '1539316754');
INSERT INTO `sys_action_log` VALUES ('1021', '1', '1', '3232235980', 'member', '1', '在2018-10-12 11:59:16登录了后台', '1', '1539316756');
INSERT INTO `sys_action_log` VALUES ('1022', '1', '1', '2130706433', 'member', '1', '在2018-10-12 16:47:16登录了后台', '1', '1539334036');
INSERT INTO `sys_action_log` VALUES ('1023', '1', '1', '2130706433', 'member', '1', '在2018-10-15 08:41:28登录了后台', '1', '1539564088');
INSERT INTO `sys_action_log` VALUES ('1024', '1', '1', '2130706433', 'member', '1', '在2018-10-15 08:41:30登录了后台', '1', '1539564090');
INSERT INTO `sys_action_log` VALUES ('1025', '1', '1', '3232235980', 'member', '1', '在2018-10-15 10:56:05登录了后台', '1', '1539572165');
INSERT INTO `sys_action_log` VALUES ('1026', '1', '1', '3232235913', 'member', '1', '在2018-10-16 11:20:50登录了后台', '1', '1539660050');
INSERT INTO `sys_action_log` VALUES ('1027', '1', '1', '3232235913', 'member', '1', '在2018-10-16 11:20:55登录了后台', '1', '1539660055');
INSERT INTO `sys_action_log` VALUES ('1028', '1', '1', '2130706433', 'member', '1', '在2018-10-16 15:34:14登录了后台', '1', '1539675254');
INSERT INTO `sys_action_log` VALUES ('1029', '1', '1', '2130706433', 'member', '1', '在2018-10-16 16:42:26登录了后台', '1', '1539679346');
INSERT INTO `sys_action_log` VALUES ('1030', '1', '1', '3232235913', 'member', '1', '在2018-10-17 09:47:38登录了后台', '1', '1539740858');
INSERT INTO `sys_action_log` VALUES ('1031', '1', '1', '2130706433', 'member', '1', '在2018-10-17 10:51:16登录了后台', '1', '1539744676');
INSERT INTO `sys_action_log` VALUES ('1032', '1', '1', '3232235831', 'member', '1', '在2018-10-17 11:15:17登录了后台', '1', '1539746117');
INSERT INTO `sys_action_log` VALUES ('1033', '1', '1', '3232236027', 'member', '1', '在2018-10-17 13:49:43登录了后台', '1', '1539755383');
INSERT INTO `sys_action_log` VALUES ('1034', '1', '1', '2130706433', 'member', '1', '在2018-10-17 15:42:53登录了后台', '1', '1539762173');
INSERT INTO `sys_action_log` VALUES ('1035', '1', '1', '3232235913', 'member', '1', '在2018-10-17 16:28:23登录了后台', '1', '1539764903');
INSERT INTO `sys_action_log` VALUES ('1036', '1', '1', '3232235913', 'member', '1', '在2018-10-17 17:15:03登录了后台', '1', '1539767703');
INSERT INTO `sys_action_log` VALUES ('1037', '1', '1', '3232235831', 'member', '1', '在2018-10-17 18:38:50登录了后台', '1', '1539772730');
INSERT INTO `sys_action_log` VALUES ('1038', '1', '1', '2130706433', 'member', '1', '在2018-10-18 08:50:21登录了后台', '1', '1539823821');
INSERT INTO `sys_action_log` VALUES ('1039', '1', '1', '3232235831', 'member', '1', '在2018-10-18 10:18:52登录了后台', '1', '1539829132');
INSERT INTO `sys_action_log` VALUES ('1040', '1', '1', '2130706433', 'member', '1', '在2018-10-18 10:53:31登录了后台', '1', '1539831211');
INSERT INTO `sys_action_log` VALUES ('1041', '1', '1', '3232236027', 'member', '1', '在2018-10-18 16:01:42登录了后台', '1', '1539849702');
INSERT INTO `sys_action_log` VALUES ('1042', '1', '1', '3232235980', 'member', '1', '在2018-10-18 16:13:26登录了后台', '1', '1539850406');
INSERT INTO `sys_action_log` VALUES ('1043', '1', '1', '3232235913', 'member', '1', '在2018-10-18 16:15:10登录了后台', '1', '1539850510');
INSERT INTO `sys_action_log` VALUES ('1044', '1', '1', '2130706433', 'member', '1', '在2018-10-19 09:27:50登录了后台', '1', '1539912470');
INSERT INTO `sys_action_log` VALUES ('1045', '1', '1', '3232236027', 'member', '1', '在2018-10-19 10:32:18登录了后台', '1', '1539916338');
INSERT INTO `sys_action_log` VALUES ('1046', '1', '1', '2130706433', 'member', '1', '在2018-10-19 10:52:07登录了后台', '1', '1539917527');
INSERT INTO `sys_action_log` VALUES ('1047', '1', '1', '2130706433', 'member', '1', '在2018-10-22 10:28:59登录了后台', '1', '1540175339');
INSERT INTO `sys_action_log` VALUES ('1048', '1', '1', '2130706433', 'member', '1', '在2018-10-22 10:29:47登录了后台', '1', '1540175387');
INSERT INTO `sys_action_log` VALUES ('1049', '1', '1', '2130706433', 'member', '1', '在2018-10-22 11:53:33登录了后台', '1', '1540180413');
INSERT INTO `sys_action_log` VALUES ('1050', '1', '1', '3232235980', 'member', '1', '在2018-10-22 15:35:13登录了后台', '1', '1540193713');
INSERT INTO `sys_action_log` VALUES ('1051', '1', '1', '2130706433', 'member', '1', '在2018-10-23 08:32:48登录了后台', '1', '1540254768');
INSERT INTO `sys_action_log` VALUES ('1052', '1', '1', '2130706433', 'member', '1', '在2018-10-23 08:32:54登录了后台', '1', '1540254774');
INSERT INTO `sys_action_log` VALUES ('1053', '1', '1', '2130706433', 'member', '1', '在2018-10-23 08:32:57登录了后台', '1', '1540254777');
INSERT INTO `sys_action_log` VALUES ('1054', '1', '1', '3232235831', 'member', '1', '在2018-10-23 09:48:50登录了后台', '1', '1540259330');
INSERT INTO `sys_action_log` VALUES ('1055', '1', '1', '2130706433', 'member', '1', '在2018-10-23 15:05:32登录了后台', '1', '1540278332');
INSERT INTO `sys_action_log` VALUES ('1056', '1', '1', '2130706433', 'member', '1', '在2018-10-23 19:21:15登录了后台', '1', '1540293675');
INSERT INTO `sys_action_log` VALUES ('1057', '1', '1', '3232236027', 'member', '1', '在2018-10-24 09:24:54登录了后台', '1', '1540344294');
INSERT INTO `sys_action_log` VALUES ('1058', '1', '1', '2130706433', 'member', '1', '在2018-10-24 09:25:42登录了后台', '1', '1540344342');
INSERT INTO `sys_action_log` VALUES ('1059', '1', '1', '2130706433', 'member', '1', '在2018-10-24 09:25:44登录了后台', '1', '1540344344');
INSERT INTO `sys_action_log` VALUES ('1060', '1', '1', '2130706433', 'member', '1', '在2018-10-24 09:27:51登录了后台', '1', '1540344471');
INSERT INTO `sys_action_log` VALUES ('1061', '1', '1', '2130706433', 'member', '1', '在2018-10-24 09:32:59登录了后台', '1', '1540344779');
INSERT INTO `sys_action_log` VALUES ('1062', '1', '1', '2130706433', 'member', '1', '在2018-10-24 09:33:05登录了后台', '1', '1540344785');
INSERT INTO `sys_action_log` VALUES ('1063', '1', '1', '3232235940', 'member', '1', '在2018-10-24 11:33:31登录了后台', '1', '1540352011');
INSERT INTO `sys_action_log` VALUES ('1064', '1', '1', '2130706433', 'member', '1', '在2018-10-24 14:54:33登录了后台', '1', '1540364073');
INSERT INTO `sys_action_log` VALUES ('1065', '1', '1', '2130706433', 'member', '1', '在2018-10-24 17:20:24登录了后台', '1', '1540372824');
INSERT INTO `sys_action_log` VALUES ('1066', '1', '1', '2130706433', 'member', '1', '在2018-10-25 08:57:57登录了后台', '1', '1540429077');
INSERT INTO `sys_action_log` VALUES ('1067', '1', '1', '3232235831', 'member', '1', '在2018-10-25 09:22:51登录了后台', '1', '1540430571');
INSERT INTO `sys_action_log` VALUES ('1068', '1', '1', '2130706433', 'member', '1', '在2018-10-25 09:39:35登录了后台', '1', '1540431575');
INSERT INTO `sys_action_log` VALUES ('1069', '1', '1', '2130706433', 'member', '1', '在2018-10-25 09:53:16登录了后台', '1', '1540432396');
INSERT INTO `sys_action_log` VALUES ('1070', '1', '1', '2130706433', 'member', '1', '在2018-10-25 10:18:28登录了后台', '1', '1540433908');
INSERT INTO `sys_action_log` VALUES ('1071', '1', '1', '3232235940', 'member', '1', '在2018-10-25 11:54:32登录了后台', '1', '1540439672');
INSERT INTO `sys_action_log` VALUES ('1072', '1', '1', '2130706433', 'member', '1', '在2018-10-25 15:57:31登录了后台', '1', '1540454251');
INSERT INTO `sys_action_log` VALUES ('1073', '1', '1', '3232235940', 'member', '1', '在2018-10-25 19:09:08登录了后台', '1', '1540465748');
INSERT INTO `sys_action_log` VALUES ('1074', '1', '1', '2130706433', 'member', '1', '在2018-10-26 08:47:44登录了后台', '1', '1540514864');
INSERT INTO `sys_action_log` VALUES ('1075', '1', '1', '3232235831', 'member', '1', '在2018-10-26 09:23:28登录了后台', '1', '1540517008');
INSERT INTO `sys_action_log` VALUES ('1076', '1', '1', '2130706433', 'member', '1', '在2018-10-26 09:43:22登录了后台', '1', '1540518202');
INSERT INTO `sys_action_log` VALUES ('1077', '1', '1', '3232235940', 'member', '1', '在2018-10-26 09:59:00登录了后台', '1', '1540519140');
INSERT INTO `sys_action_log` VALUES ('1078', '1', '1', '2130706433', 'member', '1', '在2018-10-26 10:33:54登录了后台', '1', '1540521234');
INSERT INTO `sys_action_log` VALUES ('1079', '1', '1', '3232235940', 'member', '1', '在2018-10-26 11:59:06登录了后台', '1', '1540526346');
INSERT INTO `sys_action_log` VALUES ('1080', '1', '1', '3232235940', 'member', '1', '在2018-10-26 14:30:13登录了后台', '1', '1540535413');
INSERT INTO `sys_action_log` VALUES ('1081', '1', '1', '3232235975', 'member', '1', '在2018-10-26 14:39:00登录了后台', '1', '1540535940');
INSERT INTO `sys_action_log` VALUES ('1082', '1', '1', '3232235975', 'member', '1', '在2018-10-26 15:33:01登录了后台', '1', '1540539181');
INSERT INTO `sys_action_log` VALUES ('1083', '1', '1', '3232235940', 'member', '1', '在2018-10-26 17:26:36登录了后台', '1', '1540545996');
INSERT INTO `sys_action_log` VALUES ('1084', '1', '1', '2130706433', 'member', '1', '在2018-10-26 17:37:45登录了后台', '1', '1540546665');
INSERT INTO `sys_action_log` VALUES ('1085', '1', '1', '3232235894', 'member', '1', '在2018-10-29 10:30:12登录了后台', '1', '1540780212');
INSERT INTO `sys_action_log` VALUES ('1086', '1', '1', '3232235894', 'member', '1', '在2018-10-29 10:30:14登录了后台', '1', '1540780214');
INSERT INTO `sys_action_log` VALUES ('1087', '1', '1', '2130706433', 'member', '1', '在2018-10-29 11:14:23登录了后台', '1', '1540782863');
INSERT INTO `sys_action_log` VALUES ('1088', '1', '1', '2130706433', 'member', '1', '在2018-10-29 11:14:26登录了后台', '1', '1540782866');
INSERT INTO `sys_action_log` VALUES ('1089', '1', '1', '2130706433', 'member', '1', '在2018-10-29 11:14:30登录了后台', '1', '1540782870');
INSERT INTO `sys_action_log` VALUES ('1090', '1', '1', '2130706433', 'member', '1', '在2018-10-29 11:22:57登录了后台', '1', '1540783377');
INSERT INTO `sys_action_log` VALUES ('1091', '1', '1', '3232235988', 'member', '1', '在2018-10-29 16:58:06登录了后台', '1', '1540803486');
INSERT INTO `sys_action_log` VALUES ('1092', '1', '1', '3232235988', 'member', '1', '在2018-10-29 16:58:08登录了后台', '1', '1540803488');
INSERT INTO `sys_action_log` VALUES ('1093', '1', '1', '3232235988', 'member', '1', '在2018-10-29 16:58:09登录了后台', '1', '1540803489');
INSERT INTO `sys_action_log` VALUES ('1094', '1', '1', '3232235975', 'member', '1', '在2018-10-29 17:22:15登录了后台', '1', '1540804935');
INSERT INTO `sys_action_log` VALUES ('1095', '1', '1', '3232235975', 'member', '1', '在2018-10-29 18:30:44登录了后台', '1', '1540809044');
INSERT INTO `sys_action_log` VALUES ('1096', '1', '1', '2130706433', 'member', '1', '在2018-10-30 09:17:55登录了后台', '1', '1540862275');
INSERT INTO `sys_action_log` VALUES ('1097', '1', '1', '3232235899', 'member', '1', '在2018-10-30 09:58:29登录了后台', '1', '1540864709');
INSERT INTO `sys_action_log` VALUES ('1098', '1', '1', '3232235995', 'member', '1', '在2018-10-30 14:09:02登录了后台', '1', '1540879742');
INSERT INTO `sys_action_log` VALUES ('1099', '1', '1', '2130706433', 'member', '1', '在2018-10-30 14:40:14登录了后台', '1', '1540881614');
INSERT INTO `sys_action_log` VALUES ('1100', '1', '1', '3232235995', 'member', '1', '在2018-10-30 19:06:07登录了后台', '1', '1540897567');
INSERT INTO `sys_action_log` VALUES ('1101', '1', '1', '2130706433', 'member', '1', '在2018-10-31 09:04:58登录了后台', '1', '1540947898');
INSERT INTO `sys_action_log` VALUES ('1102', '1', '1', '3232235995', 'member', '1', '在2018-10-31 09:24:59登录了后台', '1', '1540949099');
INSERT INTO `sys_action_log` VALUES ('1103', '1', '1', '2130706433', 'member', '1', '在2018-10-31 11:09:58登录了后台', '1', '1540955398');
INSERT INTO `sys_action_log` VALUES ('1104', '1', '1', '3232235810', 'member', '1', '在2018-10-31 16:48:09登录了后台', '1', '1540975689');
INSERT INTO `sys_action_log` VALUES ('1105', '1', '1', '2130706433', 'member', '1', '在2018-11-01 08:37:04登录了后台', '1', '1541032624');
INSERT INTO `sys_action_log` VALUES ('1106', '1', '1', '3232235995', 'member', '1', '在2018-11-01 15:03:17登录了后台', '1', '1541055797');
INSERT INTO `sys_action_log` VALUES ('1107', '1', '1', '3232235890', 'member', '1', '在2018-11-01 16:28:14登录了后台', '1', '1541060894');
INSERT INTO `sys_action_log` VALUES ('1108', '1', '1', '2130706433', 'member', '1', '在2018-11-01 16:43:26登录了后台', '1', '1541061806');
INSERT INTO `sys_action_log` VALUES ('1109', '1', '1', '3232235810', 'member', '1', '在2018-11-01 17:53:39登录了后台', '1', '1541066019');
INSERT INTO `sys_action_log` VALUES ('1110', '1', '1', '3232235988', 'member', '1', '在2018-11-02 09:17:15登录了后台', '1', '1541121435');
INSERT INTO `sys_action_log` VALUES ('1111', '1', '1', '2130706433', 'member', '1', '在2018-11-02 09:17:35登录了后台', '1', '1541121455');
INSERT INTO `sys_action_log` VALUES ('1112', '1', '1', '2130706433', 'member', '1', '在2018-11-02 13:38:34登录了后台', '1', '1541137114');
INSERT INTO `sys_action_log` VALUES ('1113', '1', '1', '3232235988', 'member', '1', '在2018-11-02 15:07:06登录了后台', '1', '1541142426');
INSERT INTO `sys_action_log` VALUES ('1114', '1', '1', '3232235995', 'member', '1', '在2018-11-02 15:33:49登录了后台', '1', '1541144029');
INSERT INTO `sys_action_log` VALUES ('1115', '1', '1', '2130706433', 'member', '1', '在2018-11-05 09:39:34登录了后台', '1', '1541381974');
INSERT INTO `sys_action_log` VALUES ('1116', '1', '1', '2130706433', 'member', '1', '在2018-11-05 09:39:42登录了后台', '1', '1541381982');
INSERT INTO `sys_action_log` VALUES ('1117', '1', '1', '3232235890', 'member', '1', '在2018-11-05 10:53:05登录了后台', '1', '1541386385');
INSERT INTO `sys_action_log` VALUES ('1118', '1', '1', '2130706433', 'member', '1', '在2018-11-05 13:38:59登录了后台', '1', '1541396339');
INSERT INTO `sys_action_log` VALUES ('1119', '1', '1', '3232235975', 'member', '1', '在2018-11-05 14:11:00登录了后台', '1', '1541398260');
INSERT INTO `sys_action_log` VALUES ('1120', '1', '1', '3232235975', 'member', '1', '在2018-11-05 14:11:02登录了后台', '1', '1541398262');

-- ----------------------------
-- Table structure for sys_app_access_token
-- ----------------------------
DROP TABLE IF EXISTS `sys_app_access_token`;
CREATE TABLE `sys_app_access_token` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `access_token` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '用户登录后token值',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID，一般不返回，只用作后台关联用',
  `username` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '用户信息',
  `email` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT '手机号',
  `grade_id` tinyint(3) DEFAULT '0' COMMENT '权限等级ID',
  `grade_name` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '等级名称',
  `starttime` int(10) NOT NULL DEFAULT '0' COMMENT '会员开始时间',
  `endtime` int(10) NOT NULL DEFAULT '0' COMMENT '会员结束时间',
  `timelong` tinyint(4) NOT NULL DEFAULT '0' COMMENT '使用期限',
  `num` int(5) NOT NULL DEFAULT '0' COMMENT '次数',
  `firsttime` int(10) NOT NULL DEFAULT '0' COMMENT '登陆时间',
  `is_admin` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否管理员(0:不是;1:是)',
  `registration_id` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '极光推送registration_id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of sys_app_access_token
-- ----------------------------
INSERT INTO `sys_app_access_token` VALUES ('2', '3f1d42397cade5a581c5288497fb736e', '586766', 'panlaosong', '', '0', '1', '默认用户组', '0', '0', '0', '0', '1534924163', '0', '171976fa8ad43ca23f3');
INSERT INTO `sys_app_access_token` VALUES ('3', '0a7d0948ef45aed80f28adf93c4770ed', '586774', '18725751250ph285', '', '18725751250', '0', null, '0', '0', '0', '0', '1540109327', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('4', '8e7266a6494334a6511a44fecfed06ce', '586775', '18725751251ph999', '', '18725751251', '0', null, '0', '0', '0', '0', '1540109564', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('5', '58d7d73c1b631818f678043727564de8', '586776', '18725751252ph333', '', '18725751252', '0', null, '0', '0', '0', '0', '0', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('6', 'fe25e3145b54c54ed8a3b8344aee9f9b', '586777', '', '', '18725751253', '0', '', '0', '0', '0', '0', '1540117755', '0', '1111111111');
INSERT INTO `sys_app_access_token` VALUES ('7', '530bbb860b8cb7ef3103efe84c650b93', '586778', '18725751254ph993', '', '18725751254', '0', null, '0', '0', '0', '0', '1540123317', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('8', '40370ae1f482233eedac7c3064cea86e', '586780', '15998964153ph784', '', '15998964153', '0', null, '0', '0', '0', '0', '1540280725', '0', '1104a897928f4d2c911');
INSERT INTO `sys_app_access_token` VALUES ('9', '87990b2a1764dcac87df7b6da276657f', '586781', '13628223997ph585', '', '13628223997', '0', null, '0', '0', '0', '0', '1540284481', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('10', 'e2953dfec4a03d2cafa2129b729930f9', '586782', '15998964153ph773', '', '15998964153', '0', null, '0', '0', '0', '0', '1540285949', '0', '1104a897928f4d2c911');
INSERT INTO `sys_app_access_token` VALUES ('11', 'c0b1d161c47f5971e18db3588a662847', '586783', '17316785806ph582', '', '17316785806', '0', null, '0', '0', '0', '0', '1540345262', '0', '');
INSERT INTO `sys_app_access_token` VALUES ('12', 'b0ffebc852d16d892bbc3fc74a19d5e7', '586784', '15998964153ph407', '', '15998964153', '0', null, '0', '0', '0', '0', '1540429848', '0', '');

-- ----------------------------
-- Table structure for sys_app_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_app_user`;
CREATE TABLE `sys_app_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `uid` int(8) NOT NULL DEFAULT '0' COMMENT '用户id',
  `mobile` char(15) NOT NULL DEFAULT '' COMMENT '用户手机',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '用户邮箱',
  `weixin_openid` varchar(100) NOT NULL DEFAULT '' COMMENT '微信openid',
  `qq_openid` varchar(100) NOT NULL DEFAULT '' COMMENT 'QQopenid',
  `weibo_openid` varchar(100) NOT NULL DEFAULT '' COMMENT '微博openid',
  `reg_source` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0原用户；10手机（ios），11手机(android)；20微信（ios），21微信（android）；30微信（ios），31微信（android）；40qq（ios），41qq（android）；50微博（ios），51微博（android）',
  `type_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '类型ID',
  `grade_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '等级ID',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` bigint(20) NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '用户状态',
  `starttime` int(10) NOT NULL DEFAULT '0' COMMENT '会员开始时间',
  `endtime` int(10) NOT NULL DEFAULT '0' COMMENT '会员结束时间',
  `department` varchar(50) NOT NULL DEFAULT '' COMMENT '部门',
  `truename` varchar(10) NOT NULL DEFAULT '' COMMENT '联系人',
  `address` varchar(30) NOT NULL DEFAULT '' COMMENT '联系地址',
  `comname` varchar(30) NOT NULL DEFAULT '' COMMENT '单位名称',
  `comtel` varchar(30) NOT NULL DEFAULT '' COMMENT '联系电话',
  `remark` varchar(60) NOT NULL DEFAULT '' COMMENT '备注',
  `client` varchar(15) NOT NULL DEFAULT '' COMMENT '平台',
  `timelong` tinyint(4) NOT NULL DEFAULT '0' COMMENT '使用期限',
  `num` int(5) NOT NULL DEFAULT '0' COMMENT '次数',
  `iplow` varchar(16) NOT NULL DEFAULT '' COMMENT 'IP起始段',
  `ipup` varchar(16) NOT NULL DEFAULT '' COMMENT 'IP结束段',
  `third_party` varchar(50) DEFAULT '' COMMENT '第三方（1：qq；2：微信；3：微博）',
  `is_autoload` int(5) NOT NULL DEFAULT '0' COMMENT '非wifi不加载图片(0:关闭；1：打开)',
  `is_useflows` int(5) DEFAULT '0' COMMENT '使用流量下载图片(1:使用；0：不使用)',
  `is_admin` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否管理员(0:不是;1:是)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COMMENT='APP用户表';

-- ----------------------------
-- Records of sys_app_user
-- ----------------------------
INSERT INTO `sys_app_user` VALUES ('38', 'panlaosong', '586766', '13628223997', '573298584@qq.com', '', '04851A11396A246F2D59BC632D42DAFB', '', '0', '0', '1', '1535700408', '0', '0', '0', '-1', '1538293047', '1548295047', '', '', '', '', '', '', '', '0', '0', '', '', '1,2,3', '0', '0', '1');
INSERT INTO `sys_app_user` VALUES ('51', '15998964153ph773', '586782', '15998964154', '', '', '', '', '0', '0', '0', '1540285948', '0', '0', '0', '-1', '0', '0', '', '', '', '', '', '', '', '0', '0', '', '', '', '0', '0', '0');
INSERT INTO `sys_app_user` VALUES ('54', '17316785806ph582', '586783', '17316785806', '', '', '', '', '0', '0', '0', '1540345261', '0', '0', '0', '-1', '0', '0', '', '', '', '', '', '', '', '0', '0', '', '', '', '0', '0', '0');
INSERT INTO `sys_app_user` VALUES ('55', '15998964153ph407', '586784', '15998964153', '', '', '', '', '0', '0', '0', '1540429847', '0', '0', '0', '-1', '0', '0', '', '', '', '', '', '', '', '0', '0', '', '', '', '0', '0', '0');

-- ----------------------------
-- Table structure for sys_auth_extend
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_extend`;
CREATE TABLE `sys_auth_extend` (
  `group_id` mediumint(10) unsigned NOT NULL COMMENT '用户id',
  `extend_id` mediumint(8) unsigned NOT NULL COMMENT '扩展表中数据的id',
  `type` tinyint(1) unsigned NOT NULL COMMENT '扩展类型标识 1:栏目分类权限;2:模型权限',
  UNIQUE KEY `group_extend_type` (`group_id`,`extend_id`,`type`) USING BTREE,
  KEY `uid` (`group_id`) USING BTREE,
  KEY `group_id` (`extend_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组与分类的对应关系表';

-- ----------------------------
-- Records of sys_auth_extend
-- ----------------------------
INSERT INTO `sys_auth_extend` VALUES ('1', '1', '1');

-- ----------------------------
-- Table structure for sys_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_group`;
CREATE TABLE `sys_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组id,自增主键',
  `module` varchar(20) NOT NULL DEFAULT '' COMMENT '用户组所属模块',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '组类型',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) NOT NULL DEFAULT '' COMMENT '描述信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户组状态：为1正常，为0禁用,-1为删除',
  `rules` varchar(500) NOT NULL DEFAULT '' COMMENT '用户组拥有的规则id，多个规则 , 隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_auth_group
-- ----------------------------
INSERT INTO `sys_auth_group` VALUES ('1', 'admin', '1', '默认用户组', '', '1', '1,3,22,26,61,65,66,70,74,100,102,103,107,108,207,231,233,238,239,240,241,242,243,244,249,250,251,252,253,254,255,256,257,259,267,268,269,270,271,272,273,274,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,369,370,371');
INSERT INTO `sys_auth_group` VALUES ('2', 'admin', '1', '测试用户', '测试用户', '-1', '1,3,22,26,61,66,100,102,103,108,109,207,231,233,238,239,240,241,242,243,244,249,250,251,252,253,254,255,256,257,259,288,289,290,291,322');
INSERT INTO `sys_auth_group` VALUES ('3', 'admin', '1', '运营', '运营管理人员用户组', '1', '1,65,108,294,296,315,316,317,318,319,320,321,331,332,333,334,336,337');
INSERT INTO `sys_auth_group` VALUES ('4', 'admin', '1', '营销中心', '', '1', '1,108,294,312,313,314,315,316,317,320,321,323,324,325,326,327,328,329,330,331,332,333,334,338,339,340,341,342,343,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,369,370,371');
INSERT INTO `sys_auth_group` VALUES ('5', 'admin', '1', 'test', '', '1', '1,312,314,325,340,341,352,353,357');

-- ----------------------------
-- Table structure for sys_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_group_access`;
CREATE TABLE `sys_auth_group_access` (
  `uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `group_id` mediumint(8) unsigned NOT NULL COMMENT '用户组id',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_auth_group_access
-- ----------------------------
INSERT INTO `sys_auth_group_access` VALUES ('2', '1');
INSERT INTO `sys_auth_group_access` VALUES ('2', '2');
INSERT INTO `sys_auth_group_access` VALUES ('3', '3');
INSERT INTO `sys_auth_group_access` VALUES ('4', '4');
INSERT INTO `sys_auth_group_access` VALUES ('5', '4');
INSERT INTO `sys_auth_group_access` VALUES ('6', '4');
INSERT INTO `sys_auth_group_access` VALUES ('7', '4');
INSERT INTO `sys_auth_group_access` VALUES ('8', '4');
INSERT INTO `sys_auth_group_access` VALUES ('9', '4');
INSERT INTO `sys_auth_group_access` VALUES ('10', '4');
INSERT INTO `sys_auth_group_access` VALUES ('11', '4');
INSERT INTO `sys_auth_group_access` VALUES ('21', '4');
INSERT INTO `sys_auth_group_access` VALUES ('22', '4');
INSERT INTO `sys_auth_group_access` VALUES ('23', '4');
INSERT INTO `sys_auth_group_access` VALUES ('24', '4');
INSERT INTO `sys_auth_group_access` VALUES ('1', '8');

-- ----------------------------
-- Table structure for sys_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_rule`;
CREATE TABLE `sys_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '规则所属module',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1-url;2-主菜单',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(300) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  PRIMARY KEY (`id`),
  KEY `module` (`module`,`status`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=865 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_auth_rule
-- ----------------------------
INSERT INTO `sys_auth_rule` VALUES ('1', 'admin', '2', 'admin/Index/index', '首页', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('3', 'admin', '2', 'admin/User/index', '会员系统', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('22', 'admin', '1', 'admin/User/setStatus', '单个更新（启用、禁用、删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('26', 'admin', '1', 'admin/User/index', '会员管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('61', 'admin', '1', 'admin/Deploy/edit', '新增或编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('65', 'admin', '1', 'admin/Deploy/group', '网站配置', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('66', 'admin', '1', 'admin/Deploy/index', '配置管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('70', 'admin', '1', 'admin/Channel/index', '导航菜单', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('74', 'admin', '1', 'admin/Category/index', '分类管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('100', 'admin', '1', 'admin/Menu/index', '菜单管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('102', 'admin', '1', 'admin/Menu/add', '新增', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('103', 'admin', '1', 'admin/Menu/edit', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('107', 'admin', '1', 'admin/Action/actionlog', '行为日志', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('108', 'admin', '1', 'admin/User/updatePassword', '修改密码', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('109', 'admin', '1', 'admin/User/updateNickname', '修改昵称', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('172', 'admin', '2', 'admin/Deploy/group', '系统', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('207', 'admin', '1', 'admin/Menu/import', '导入', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('231', 'admin', '1', 'admin/User/edit', '新增用户', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('233', 'admin', '1', 'admin/AuthManager/index', '权限管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('238', 'admin', '1', 'admin/AuthManager/editgroup', '新增和编辑', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('239', 'admin', '1', 'admin/AuthManager/writegroup', '保存和编辑用户组', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('240', 'admin', '1', 'admin/AuthManager/group', '授权', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('241', 'admin', '1', 'admin/AuthManager/access', '访问授权', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('242', 'admin', '1', 'admin/AuthManager/user', '成员授权', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('243', 'admin', '1', 'admin/AuthManager/removeFromGroup', '解除授权', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('244', 'admin', '1', 'admin/AuthManager/addtogroup', '保存成员授权', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('249', 'admin', '1', 'admin/User/batchupdate', '批量更新(启用、禁用、删除)', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('250', 'admin', '1', 'admin/AuthManager/batchupdate', '批量用户组状态变更', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('251', 'admin', '1', 'admin/AuthManager/setstatus', '单个用户组状态变更', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('252', 'admin', '1', 'admin/AuthManager/rulesarrayupdate', '访问授权保存', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('253', 'admin', '1', 'admin/Menu/toogle', '仅开发者模式显示和隐藏', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('254', 'admin', '1', 'admin/Menu/setStatus', '单个菜单状态更改', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('255', 'admin', '1', 'admin/Menu/batchupdate', '批量菜单删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('256', 'admin', '1', 'admin/Deploy/setStatus', '单个删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('257', 'admin', '1', 'admin/Deploy/batchupdate', '批量删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('259', 'admin', '1', 'admin/Action/index', '管理员行为', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('267', 'admin', '1', 'admin/Action/detailed', '日志详情', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('268', 'admin', '1', 'admin/Database/index', '数据库设置', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('269', 'admin', '1', 'admin/DataBase/export', '数据备份', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('270', 'admin', '1', 'admin/DataBase/optimize', '优化表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('271', 'admin', '1', 'admin/DataBase/repair', '修复表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('272', 'admin', '1', 'admin/DataBase/import', '还原数据库', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('273', 'admin', '1', 'admin/DataBase/revert', '数据还原', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('274', 'admin', '1', 'admin/DataBase/del', '备份数据删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('275', 'admin', '1', 'admin/Article/batchupdate', '批量更新(禁用、删除、启用、审核、还原)', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('276', 'admin', '1', 'admin/Article/physicaldelete', '物理删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('277', 'admin', '1', 'admin/Article/ajaxmydocument', '搜索', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('278', 'admin', '1', 'admin/Article/add', '新增', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('279', 'admin', '1', 'admin/Article/move', '移动', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('280', 'admin', '1', 'admin/Article/copy', '复制', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('281', 'admin', '1', 'admin/Article/paste', '粘贴', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('283', 'admin', '2', 'admin/Article/mydocument', '测试内容2', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('286', 'admin', '1', 'admin/Article/recycle', '回收站', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('287', 'admin', '1', 'admin/Article/index', '文章列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('288', 'admin', '1', 'admin/Action/edit', '新增或者编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('289', 'admin', '1', 'admin/Action/setStatus', '单个变更行为状态', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('290', 'admin', '1', 'admin/Action/batchupdate', '批量变更用户行为', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('291', 'admin', '1', 'admin/Action/renew', '保存或者更新', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('292', 'admin', '1', 'admin/Action/clear', '清空', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('293', 'admin', '1', 'admin/Action/remove', '删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('294', 'admin', '1', 'admin/User/portrait', '头像', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('295', 'admin', '1', 'admin/User/photogallery', '相册', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('296', 'admin', '1', 'admin/Deploy/setUp', '配置更新', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('297', 'admin', '1', 'admin/Channel/add', '新增', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('298', 'admin', '1', 'admin/Channel/batchupdate', '批量更新（启用、删除、禁用）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('299', 'admin', '1', 'admin/Channel/setStatus', '单个更新（禁用、删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('300', 'admin', '1', 'admin/Channel/renew', '保存', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('301', 'admin', '1', 'admin/Deploy/renew', '保存', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('302', 'admin', '1', 'admin/Category/add', '新增', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('303', 'admin', '1', 'admin/Category/setStatus', '单个更新（禁用、启用）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('304', 'admin', '1', 'admin/Category/remove', '删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('305', 'admin', '1', 'admin/Category/move', '移动', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('306', 'admin', '1', 'admin/Category/renew', '保存', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('307', 'admin', '1', 'admin/Article/articlePicture', '上传图片', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('308', 'admin', '1', 'admin/Article/articleFile', '上传文件', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('309', 'admin', '1', 'admin/Article/autoSave', '存草稿', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('310', 'admin', '1', 'admin/Article/renew', '保存', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('311', 'admin', '1', 'admin/Article/contact', '其他', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('312', 'admin', '1', 'admin/Report/index', '报告列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('313', 'admin', '1', 'admin/Report/tagIndex', '报告标签', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('314', 'admin', '2', 'admin/Report/index', '内容', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('315', 'admin', '1', 'admin/Operate/index', '广告列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('316', 'admin', '1', 'admin/Operate/add', '新增广告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('317', 'admin', '1', 'admin/Operate/positionList', '广告位', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('318', 'admin', '1', 'admin/Links/index', '链接列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('319', 'admin', '1', 'admin/Links/edit', '新增链接', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('320', 'admin', '1', 'admin/Operate/positionEdit', '添加广告位', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('321', 'admin', '2', 'admin/Operate/index', '运营', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('322', 'admin', '2', 'admin/Deploy/index', '系统', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('323', 'admin', '1', 'admin/Order/orderAdd', '编辑订单', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('324', 'admin', '1', 'admin/Order/index', '订单统计', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('325', 'admin', '1', 'admin/Article/contactIndex', '联系人', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('326', 'admin', '1', 'admin/Analyst/index', '报告分析师', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('327', 'admin', '1', 'admin/Report/catlist', '报告分类', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('328', 'admin', '1', 'admin/Catalog/index', '目录列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('329', 'admin', '1', 'admin/Catalog/catlist', '目录分类', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('330', 'admin', '1', 'admin/Report/set', '报告设置', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('331', 'admin', '1', 'admin/Operate/renew', '保存广告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('332', 'admin', '1', 'admin/Operate/positionRenew', '保存广告位', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('333', 'admin', '1', 'admin/Operate/positionSetStatus', '单个更新（删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('334', 'admin', '1', 'admin/Operate/positionBatchUpdate', '批量更新（删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('335', 'admin', '1', 'admin/menu/currentSort', '更新排序', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('336', 'admin', '1', 'admin/Links/changeField', '更新状态（显示）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('337', 'admin', '1', 'admin/Links/del', '删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('338', 'admin', '1', 'admin/Order/batchUpdateStatus', '删除订单', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('339', 'admin', '1', 'admin/Order/exportOrder', '导出数据', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('340', 'admin', '1', 'admin/Report/articleAdd', '编辑报告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('341', 'admin', '1', 'admin/Report/batchUpdateStatus', '启用，禁用报告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('342', 'admin', '1', 'admin/Report/import', '批量导入报告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('343', 'admin', '1', 'admin/Report/setClassic', '设置（定制精选、经典案例）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('344', 'admin', '1', 'admin/Report/catEdit', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('345', 'admin', '1', 'admin/Report/catDel', '删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('346', 'admin', '1', 'admin/Report/tagAdd', '编辑标签', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('347', 'admin', '1', 'admin/Report/setStatus', '单个更新（禁用、启用、删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('348', 'admin', '1', 'admin/Report/batchUpdate', '批量更新（禁用、启用、删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('349', 'admin', '1', 'admin/Report/checkName', '检测关键字', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('350', 'admin', '1', 'admin/Report/modifySet', '编辑临界值（最火、最新）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('351', 'admin', '1', 'admin/article/contactAdd', '添加', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('352', 'admin', '1', 'admin/article/contactEdit', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('353', 'admin', '1', 'admin/article/setContactStatus', '更新状态', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('354', 'admin', '1', 'admin/Report/selectCatalog', '选择目录类型', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('355', 'admin', '1', 'admin/Report/selectCatalogTwo', '选择目录', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('356', 'admin', '1', 'admin/Report/checkKeyword', '查找标签', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('357', 'admin', '1', 'admin/Article/setSort', '排序', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('358', 'admin', '1', 'admin/Analyst/analystAdd', '添加', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('359', 'admin', '1', 'admin/Analyst/analystEdit', '修改', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('360', 'admin', '1', 'admin/Analyst/analystSetStatus', '单个或批量更新状态', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('361', 'admin', '1', 'admin/Analyst/analyst_edit_sort', '排序', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('362', 'admin', '1', 'admin/Catalog/add', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('363', 'admin', '1', 'admin/Catalog/batchUpdateStatus', '单个或批量更新（启用、禁用、删除）', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('364', 'admin', '1', 'admin/Catalog/catEdit', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('365', 'admin', '1', 'admin/Catalog/catDel', '删除', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('366', 'admin', '1', 'admin/User/add', '保存用户', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('367', 'admin', '1', 'admin/User/useredit', '编辑', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('368', 'admin', '1', 'admin/Report/deletereport', '删除报告', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('369', 'admin', '1', 'admin/Order/demandList', '需求列表', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('370', 'admin', '1', 'admin/Order/exportDemand', '需求导出', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('371', 'admin', '1', 'admin/Order/demandInfo', '需求详情', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('372', 'admin', '1', 'admin/Manager/index', '管理员信息管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('373', 'admin', '1', 'admin/Manager/edit', '新增用户', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('374', 'admin', '1', 'admin/Manager/add', '保存用户', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('375', 'admin', '1', 'admin/Manager/useredit', '编辑', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('376', 'admin', '1', 'admin/User/type', '类型管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('377', 'admin', '1', 'admin/User/grade', '等级管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('378', 'admin', '1', 'admin/Manager/updatePassword', '修改密码', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('379', 'admin', '1', 'admin/Manager/batchupdate', '批量更新(启用、禁用、删除)', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('380', 'admin', '1', 'admin/Manager/setStatus', '单个更新（启用、禁用、删除）', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('381', 'admin', '1', 'admin/Manager/portrait', '头像', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('382', 'admin', '1', 'admin/Manager/photogallery', '相册', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('383', 'admin', '2', 'admin/Manager/index', '管理员', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('384', 'admin', '1', 'admin/UserType/index', '类型管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('385', 'admin', '1', 'admin/UserGrade/grade', '等级管理', '-1', '');
INSERT INTO `sys_auth_rule` VALUES ('386', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('387', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('388', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('389', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('390', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('391', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('392', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('393', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('394', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('395', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('396', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('397', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('398', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('399', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('400', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('401', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('402', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('403', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('404', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('405', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('406', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('407', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('408', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('409', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('410', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('411', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('412', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('413', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('414', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('415', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('416', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('417', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('418', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('419', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('420', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('421', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('422', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('423', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('424', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('425', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('426', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('427', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('428', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('429', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('430', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('431', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('432', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('433', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('434', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('435', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('436', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('437', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('438', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('439', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('440', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('441', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('442', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('443', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('444', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('445', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('446', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('447', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('448', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('449', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('450', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('451', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('452', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('453', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('454', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('455', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('456', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('457', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('458', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('459', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('460', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('461', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('462', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('463', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('464', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('465', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('466', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('467', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('468', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('469', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('470', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('471', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('472', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('473', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('474', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('475', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('476', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('477', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('478', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('479', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('480', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('481', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('482', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('483', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('484', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('485', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('486', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('487', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('488', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('489', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('490', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('491', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('492', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('493', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('494', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('495', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('496', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('497', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('498', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('499', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('500', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('501', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('502', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('503', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('504', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('505', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('506', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('507', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('508', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('509', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('510', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('511', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('512', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('513', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('514', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('515', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('516', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('517', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('518', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('519', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('520', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('521', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('522', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('523', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('524', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('525', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('526', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('527', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('528', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('529', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('530', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('531', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('532', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('533', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('534', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('535', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('536', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('537', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('538', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('539', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('540', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('541', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('542', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('543', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('544', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('545', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('546', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('547', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('548', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('549', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('550', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('551', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('552', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('553', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('554', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('555', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('556', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('557', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('558', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('559', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('560', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('561', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('562', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('563', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('564', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('565', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('566', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('567', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('568', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('569', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('570', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('571', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('572', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('573', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('574', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('575', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('576', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('577', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('578', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('579', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('580', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('581', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('582', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('583', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('584', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('585', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('586', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('587', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('588', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('589', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('590', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('591', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('592', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('593', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('594', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('595', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('596', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('597', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('598', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('599', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('600', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('601', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('602', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('603', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('604', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('605', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('606', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('607', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('608', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('609', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('610', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('611', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('612', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('613', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('614', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('615', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('616', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('617', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('618', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('619', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('620', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('621', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('622', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('623', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('624', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('625', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('626', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('627', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('628', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('629', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('630', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('631', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('632', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('633', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('634', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('635', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('636', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('637', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('638', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('639', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('640', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('641', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('642', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('643', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('644', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('645', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('646', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('647', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('648', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('649', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('650', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('651', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('652', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('653', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('654', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('655', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('656', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('657', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('658', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('659', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('660', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('661', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('662', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('663', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('664', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('665', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('666', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('667', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('668', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('669', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('670', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('671', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('672', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('673', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('674', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('675', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('676', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('677', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('678', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('679', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('680', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('681', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('682', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('683', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('684', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('685', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('686', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('687', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('688', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('689', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('690', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('691', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('692', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('693', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('694', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('695', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('696', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('697', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('698', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('699', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('700', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('701', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('702', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('703', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('704', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('705', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('706', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('707', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('708', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('709', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('710', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('711', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('712', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('713', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('714', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('715', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('716', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('717', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('718', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('719', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('720', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('721', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('722', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('723', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('724', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('725', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('726', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('727', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('728', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('729', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('730', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('731', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('732', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('733', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('734', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('735', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('736', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('737', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('738', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('739', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('740', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('741', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('742', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('743', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('744', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('745', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('746', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('747', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('748', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('749', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('750', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('751', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('752', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('753', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('754', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('755', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('756', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('757', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('758', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('759', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('760', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('761', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('762', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('763', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('764', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('765', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('766', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('767', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('768', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('769', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('770', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('771', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('772', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('773', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('774', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('775', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('776', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('777', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('778', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('779', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('780', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('781', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('782', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('783', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('784', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('785', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('786', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('787', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('788', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('789', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('790', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('791', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('792', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('793', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('794', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('795', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('796', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('797', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('798', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('799', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('800', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('801', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('802', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('803', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('804', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('805', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('806', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('807', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('808', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('809', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('810', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('811', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('812', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('813', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('814', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('815', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('816', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('817', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('818', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('819', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('820', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('821', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('822', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('823', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('824', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('825', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('826', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('827', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('828', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('829', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('830', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('831', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('832', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('833', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('834', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('835', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('836', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('837', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('838', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('839', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('840', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('841', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('842', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('843', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('844', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('845', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('846', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('847', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('848', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('849', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('850', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('851', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('852', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('853', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('854', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('855', '', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('856', '', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('857', '', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('858', 'admin', '1', 'admin/UserGrade/index', '等级管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('859', 'admin', '1', 'admin/UserType/edit', '新增类型', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('860', 'admin', '1', 'admin/UserGrade/edit', '新增等级', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('861', 'admin', '1', 'admin/User/viptrial', '试用申请', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('862', 'admin', '2', 'admin/Database/index', '数据库管理', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('863', 'admin', '1', 'admin/DbNav/index', '数据库分类', '1', '');
INSERT INTO `sys_auth_rule` VALUES ('864', 'admin', '1', 'admin/DbNav/edit', '新增数据库分类', '1', '');

-- ----------------------------
-- Table structure for sys_deploy
-- ----------------------------
DROP TABLE IF EXISTS `sys_deploy`;
CREATE TABLE `sys_deploy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '配置名称',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置类型',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '配置说明',
  `group` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置分组',
  `extra` varchar(255) NOT NULL DEFAULT '' COMMENT '配置值',
  `remark` varchar(100) NOT NULL DEFAULT '' COMMENT '配置说明',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `value` text COMMENT '配置值',
  `sort` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `group` (`group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_deploy
-- ----------------------------
INSERT INTO `sys_deploy` VALUES ('1', 'WEB_SITE_TITLE', '1', '网站标题', '1', '', '网站标题前台显示标题', '1378898976', '1379235274', '1', '药智报告—中国医药定制报告服务平台', '1');
INSERT INTO `sys_deploy` VALUES ('2', 'WEB_SITE_DESCRIPTION', '2', '网站描述', '1', '', '网站搜索引擎描述', '1378898976', '1379235841', '1', '药智报告是中国医药定制报告服务平台，以医药、研发、生物提供定制数据，解决用户医药报告需求。', '3');
INSERT INTO `sys_deploy` VALUES ('3', 'WEB_SITE_KEYWORD', '2', '网站关键字', '1', '', '网站搜索引擎关键字', '1378898976', '1381390100', '1', '定制报告、CDE报告,医药定制,定制服务,医药报告,定制数据、批件转让、行业调研', '2');
INSERT INTO `sys_deploy` VALUES ('4', 'WEB_SITE_CLOSE', '4', '网站状态', '1', '0:关闭,1:开启', '站点关闭后其他用户不能访问，管理员可以正常访问', '1378898976', '1379235296', '1', '1', '4');
INSERT INTO `sys_deploy` VALUES ('9', 'CONFIG_TYPE_LIST', '3', '配置类型列表', '4', '', '主要用于数据解析和页面表单的生成', '1378898976', '1469355722', '1', '0:数字\r\n1:字符\r\n2:文本\r\n3:数组\r\n4:枚举\r\n5:多维枚举', '2');
INSERT INTO `sys_deploy` VALUES ('10', 'WEB_SITE_ICP', '1', '网站备案号', '1', '', '设置在网站底部显示的备案号，如“沪ICP备12007941号-2', '1378900335', '1379235859', '1', '渝ICP备10200070号', '9');
INSERT INTO `sys_deploy` VALUES ('11', 'DOCUMENT_POSITION', '3', '文档推荐位', '2', '', '文档推荐位，推荐到多个位置KEY值相加即可', '1379053380', '1379235329', '1', '1:列表推荐\r\n2:频道推荐\r\n4:首页推荐', '3');
INSERT INTO `sys_deploy` VALUES ('12', 'DOCUMENT_DISPLAY', '3', '文档可见性', '2', '', '文章可见性仅影响前台显示，后台不收影响', '1379056370', '1379235322', '1', '0:所有人可见\r\n1:仅注册会员可见\r\n2:仅管理员可见', '4');
INSERT INTO `sys_deploy` VALUES ('20', 'CONFIG_GROUP_LIST', '3', '配置分组', '4', '', '配置分组', '1379228036', '1469346241', '1', '1:基本\r\n2:内容\r\n3:用户\r\n4:系统\r\n5:登录', '4');
INSERT INTO `sys_deploy` VALUES ('23', 'OPEN_DRAFTBOX', '4', '是否开启草稿功能', '2', '0:关闭草稿功能\r\n1:开启草稿功能\r\n', '新增文章时的草稿功能配置', '1379484332', '1379484591', '1', '1', '1');
INSERT INTO `sys_deploy` VALUES ('24', 'DRAFT_AOTOSAVE_INTERVAL', '0', '自动保存草稿时间', '2', '', '自动保存草稿的时间间隔，单位：秒', '1379484574', '1386143323', '1', '30', '2');
INSERT INTO `sys_deploy` VALUES ('25', 'LIST_ROWS', '0', '后台每页记录数', '2', '', '后台数据每页显示记录数', '1379503896', '1380427745', '1', '10', '10');
INSERT INTO `sys_deploy` VALUES ('26', 'USER_ALLOW_REGISTER', '4', '是否允许用户注册', '3', '0:关闭注册\r\n1:允许注册', '是否开放用户注册', '1379504487', '1379504580', '1', '1', '3');
INSERT INTO `sys_deploy` VALUES ('28', 'DATA_BACKUP_PATH', '1', '数据库备份根路径', '4', '', '路径必须以 / 结尾', '1381482411', '1381482411', '1', '../data/', '5');
INSERT INTO `sys_deploy` VALUES ('29', 'DATA_BACKUP_PART_SIZE', '0', '数据库备份卷大小', '4', '', '该值用于限制压缩后的分卷最大长度。单位：B；建议设置20M', '1381482488', '1381729564', '1', '20971520', '7');
INSERT INTO `sys_deploy` VALUES ('30', 'DATA_BACKUP_COMPRESS', '4', '数据库备份文件是否启用压缩', '4', '0:不压缩\r\n1:启用压缩', '压缩备份文件需要PHP环境支持gzopen,gzwrite函数', '1381713345', '1381729544', '1', '1', '9');
INSERT INTO `sys_deploy` VALUES ('31', 'DATA_BACKUP_COMPRESS_LEVEL', '4', '数据库备份文件压缩级别', '4', '1:普通\r\n4:一般\r\n9:最高', '数据库备份文件的压缩级别，该配置在开启压缩时生效', '1381713408', '1381713408', '1', '9', '10');
INSERT INTO `sys_deploy` VALUES ('32', 'DEVELOP_MODE', '4', '开启开发者模式', '4', '0:关闭\r\n1:开启', '是否开启开发者模式', '1383105995', '1383291877', '1', '0', '11');
INSERT INTO `sys_deploy` VALUES ('33', 'ALLOW_VISIT', '3', '不受限控制器方法', '0', '', '', '1386644047', '1476177234', '1', '0:Article/draftbox\r\n1:Article/mydocument\r\n2:Category/tree\r\n3:Index/verify\r\n4:Article/editorPicture\r\n5:User/headPortrait\r\n6:User/updatePassword\r\n7:User/updateNickname\r\n8:User/submitPassword\r\n9:User/submitNickname\r\n10:User/uploader\r\n11:Article/examine\r\n12:Login/logout', '0');
INSERT INTO `sys_deploy` VALUES ('34', 'DENY_VISIT', '3', '超管专限控制器方法', '0', '', '仅超级管理员可访问的控制器方法', '1386644141', '1386644659', '1', '0:Addons/addhook\r\n1:Addons/edithook\r\n2:Addons/delhook\r\n3:Addons/updateHook\r\n4:Admin/getMenus\r\n5:Admin/recordList\r\n6:AuthManager/updateRules\r\n7:AuthManager/tree', '0');
INSERT INTO `sys_deploy` VALUES ('35', 'REPLY_LIST_ROWS', '0', '回复列表每页条数', '2', '', '', '1386645376', '1387178083', '1', '10', '0');
INSERT INTO `sys_deploy` VALUES ('36', 'ADMIN_ALLOW_IP', '2', '后台允许访问IP', '4', '', '多个用逗号分隔，如果不配置表示不限制IP访问', '1387165454', '1387165553', '1', '', '12');
INSERT INTO `sys_deploy` VALUES ('37', 'APP_TRACE', '4', '是否显示页面Trace', '4', '0:关闭\r\n1:开启', '是否显示页面Trace信息', '1387165685', '1469354735', '1', '1', '1');
INSERT INTO `sys_deploy` VALUES ('41', 'TRACE', '3', 'Trace显示方式', '4', '', '支持Html,Console,Socket 设为false则不显示', '1469354929', '1469453893', '1', 'type:html', '0');
INSERT INTO `sys_deploy` VALUES ('42', 'WEB_SITE_CLOSE_NOTICE', '2', '关闭公告', '1', '', '站点关闭公示内容', '1500012908', '1500012908', '1', '', '5');
INSERT INTO `sys_deploy` VALUES ('43', 'STATS_CODE', '2', '统计代码', '1', '', '站点统计代码', '1500013136', '1500013136', '1', '<script>\r\n  (function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){\r\n  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\r\n  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\r\n  })(window,document,\'script\',\'//www.google-analytics.com/analytics.js\',\'ga\');\r\n  ga(\'create\', \'UA-73321472-15\', {\'userId\': \'252948\'});\r\n    ga(\'set\', \'dimension1\', \'360312\');\r\n    ga(\'set\', \'dimension2\', \'taozijy\');\r\n    ga(\'set\', \'dimension3\', \'内部专用\');\r\n    ga(\'set\', \'dimension4\', \'重庆康洲大数据有限公司\');\r\n    ga(\'set\', \'dimension5\', \'18580004366\');\r\n    ga(\'set\', \'dimension6\', \'2018-05-05\');\r\n    ga(\'send\', \'pageview\');\r\n</script>\r\n\r\n<script>\r\nvar _hmt = _hmt || [];\r\n(function() {\r\n  var hm = document.createElement(\"script\");\r\n  hm.src = \"https://hm.baidu.com/hm.js?65968db3ac154c3089d7f9a4cbb98c94\";\r\n  var s = document.getElementsByTagName(\"script\")[0]; \r\n  s.parentNode.insertBefore(hm, s);\r\n})();\r\n</script>', '6');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序（同级有效）',
  `url` char(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `hide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `tip` varchar(255) NOT NULL DEFAULT '' COMMENT '提示',
  `group` varchar(50) DEFAULT '' COMMENT '分组',
  `is_dev` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否仅开发者模式可见',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=349 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('16', '管理员', '0', '3', 'Manager/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('17', '管理员信息管理', '16', '0', 'Manager/index', '0', '', '用户管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('18', '新增用户', '17', '0', 'Manager/edit', '0', '添加新用户', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('27', '权限管理', '16', '0', 'AuthManager/index', '0', '', '用户管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('32', '新增和编辑', '27', '0', 'AuthManager/editgroup', '0', '新增、编辑用户组名称和描述', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('33', '保存和编辑用户组', '27', '0', 'AuthManager/writegroup', '0', '新增和编辑用户组的 保存 按钮', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('34', '授权', '27', '0', 'AuthManager/group', '0', ' 后台 \\ 用户 \\ 用户信息 列表页的 授权 操作按钮,用于设置用户所属用户组', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('35', '访问授权', '27', '0', 'AuthManager/access', '0', ' 后台 \\ 用户 \\ 权限管理 列表页的 访问授权 操作按钮', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('36', '成员授权', '27', '0', 'AuthManager/user', '0', ' 后台 \\ 用户 \\ 权限管理 列表页的 成员授权 操作按钮', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('37', '解除授权', '27', '0', 'AuthManager/removeFromGroup', '0', ' 成员授权 列表页内的解除授权操作按钮', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('38', '保存成员授权', '27', '0', 'AuthManager/addtogroup', '0', ' 用户信息 列表页 授权 时的 保存 按钮和 成员授权 里右上角的 添加 按钮)', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('39', '单个用户组状态变更', '27', '0', 'AuthManager/setstatus', '0', ' 后台 \\ 用户 \\ 权限管理 用户组状态 启用 禁用 删除', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('108', '修改密码', '16', '0', 'Manager/updatePassword', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('109', '修改昵称', '16', '0', 'Manager/updateNickname', '1', '', '', '0', '-1');
INSERT INTO `sys_menu` VALUES ('185', '批量用户组状态变更', '27', '0', 'AuthManager/batchupdate', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('186', '访问授权保存', '27', '0', 'AuthManager/rulesarrayupdate', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('220', '批量更新(启用、禁用、删除)', '17', '0', 'Manager/batchupdate', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('221', '授权', '17', '0', 'AuthManager/group', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('222', '单个更新（启用、禁用、删除）', '17', '0', 'Manager/setStatus', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('227', '头像', '16', '0', 'Manager/portrait', '0', '', '', '0', '0');
INSERT INTO `sys_menu` VALUES ('228', '相册', '16', '0', 'Manager/photogallery', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('313', '保存用户', '17', '0', 'Manager/add', '0', '', '', '0', '0');
INSERT INTO `sys_menu` VALUES ('314', '编辑', '17', '0', 'Manager/useredit', '0', '', '', '0', '0');
INSERT INTO `sys_menu` VALUES ('319', '会员系统', '0', '3', 'User/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('321', '等级管理', '319', '0', 'UserGrade/index', '0', '', '会员管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('322', '会员管理', '319', '0', 'User/index', '0', '', '会员管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('324', '新增等级', '321', '0', 'UserGrade/edit', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('325', '数据库管理', '0', '4', 'Database/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('326', '数据库分类', '325', '0', 'DbCategory/index', '0', '', '数据库分类', '0', '1');
INSERT INTO `sys_menu` VALUES ('327', '数据库设置', '325', '0', 'Database/index', '0', '', '数据库管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('328', '新增数据库分类', '326', '0', 'DbCategory/edit', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('333', '试用申请', '319', '0', 'User/viptrial', '0', '', '会员管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('334', '导航管理', '0', '5', 'Nav/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('335', '导航分类', '334', '0', 'DbNav/index', '0', '', '导航分类', '0', '1');
INSERT INTO `sys_menu` VALUES ('336', '导航设置', '334', '0', 'Nav/index', '0', '', '导航管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('337', '新增导航分类', '335', '0', 'DbNav/edit', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('338', 'APP数据库管理', '0', '6', 'AppDatabase/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('339', 'APP数据库分类', '338', '0', 'AppDbCategory/index', '0', '', 'APP数据库分类', '0', '1');
INSERT INTO `sys_menu` VALUES ('340', 'APP数据库设置', '338', '0', 'AppDatabase/index', '0', '', 'APP数据库管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('341', 'App导航管理', '0', '7', 'AppNav/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('342', 'App导航分类', '341', '0', 'AppDbNav/index', '0', '', 'App导航分类', '0', '1');
INSERT INTO `sys_menu` VALUES ('343', 'App导航设置', '341', '0', 'AppNav/index', '0', '', 'App导航管理', '0', '1');
INSERT INTO `sys_menu` VALUES ('344', 'App新增导航分类', '342', '0', 'AppDbNav/edit', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('345', '帮助中心', '0', '8', 'HelpCategory/index', '0', '', '', '0', '1');
INSERT INTO `sys_menu` VALUES ('346', '帮助分类', '345', '0', 'HelpCategory/index', '0', '', '帮助中心', '0', '1');
INSERT INTO `sys_menu` VALUES ('347', '帮助标签', '345', '0', 'HelpLabel/index', '0', '', '帮助标签', '0', '1');
INSERT INTO `sys_menu` VALUES ('348', '帮助列表', '345', '0', 'Help/index', '0', '', '帮助列表', '0', '1');

-- ----------------------------
-- Table structure for sys_picture
-- ----------------------------
DROP TABLE IF EXISTS `sys_picture`;
CREATE TABLE `sys_picture` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id自增',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '图片链接',
  `md5` char(32) NOT NULL DEFAULT '' COMMENT '文件md5',
  `sha1` char(40) NOT NULL DEFAULT '' COMMENT '文件 sha1编码',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='图片表';

-- ----------------------------
-- Records of sys_picture
-- ----------------------------
INSERT INTO `sys_picture` VALUES ('1', '/upload/default/picture/596c6ef216831.jpg', '', '49f5f832670097cbd8d8247b1204305d', '19416bc23337612ee54972f8afc5ca39f8ce02c6', '1', '1500278514');
INSERT INTO `sys_picture` VALUES ('2', '/upload/default/picture/596dae7c0d2f3.jpg', '', '80a3381f9f33b2964ad8bf643f0e6579', '1990bf6bffc91e695d530331a3952e549f632524', '1', '1500360316');
INSERT INTO `sys_picture` VALUES ('3', '/upload/default/picture/596eff450efd8.jpg', '', 'e5f1da2422b713306b977b1199a10ac7', 'f8f583e8361668c3a3bd42d51e571f4292da3064', '1', '1500446533');
INSERT INTO `sys_picture` VALUES ('4', '/upload/default/picture/596f010c06338.jpg', '', 'e46810a575e9644c27d01ac89c38d8c4', 'e36f7f5b8a10908ad4e046cf9e921f6a987a09a8', '1', '1500446988');
INSERT INTO `sys_picture` VALUES ('5', '/upload/default/picture/596f0111dad90.jpg', '', '18926eccc414dce61e719fd89f56aba6', '943f47346acc9c00e9c757ee3ac3a04d093d52f8', '1', '1500446993');
INSERT INTO `sys_picture` VALUES ('6', '/upload/default/picture/596f0125b4078.gif', '', 'df9667e847fd2617fd79df7063a26123', 'a3900d904dc8036f4361f3e8073b966ba01d066b', '1', '1500447013');
INSERT INTO `sys_picture` VALUES ('7', '/upload/default/picture/596f0696d57a0.jpg', '', '63280d3e173095ca511e6d33c2253ca4', '01db9133dd15343e634e4c62af48f25d26afcc57', '1', '1500448406');
INSERT INTO `sys_picture` VALUES ('8', '/upload/default/picture/596f069b75c60.jpg', '', '8e3d06326c81617233d48052a8cc7a3d', 'f21ab4c7842a10ceafab4040f8b7c953046cddec', '1', '1500448411');
INSERT INTO `sys_picture` VALUES ('9', '/upload/default/picture/596f1058a3eb5.jpg', '', '6b1ff83ff55ac71b165ee647e650bba0', '2bf0f3b23218c650a9f9654fe892d6ad7f1bcdb7', '1', '1500450904');
INSERT INTO `sys_picture` VALUES ('10', '/upload/default/picture/596f124cb09d5.jpg', '', '9d97d6ce6f365d12ffbf154d5f819c3d', 'cbabca9d3586bc55c4d53b4f1b2dd7c0ff39ce60', '1', '1500451404');
INSERT INTO `sys_picture` VALUES ('11', '/upload/default/picture/596f126ae0b5d.jpg', '', '60e7beedcf5022c706b385cd587a4175', '50e09a05b1f61f4540576acc57fe1aef9dc81450', '1', '1500451434');
INSERT INTO `sys_picture` VALUES ('12', '/upload/default/picture/596f1348cdaad.jpg', '', 'e24e1d9116f3ed986706a29957090173', '4b808f0b0c04eb5e5d0c0587fe238d4aeb5fa8d1', '1', '1500451656');
INSERT INTO `sys_picture` VALUES ('13', '/upload/default/picture/596f13ea295c5.jpg', '', '384c5c109a8495b5712ce5a50b29c542', '98af30a1060e61de3ec01af65b8e95494a66a7ed', '1', '1500451818');
INSERT INTO `sys_picture` VALUES ('14', '/upload/default/picture/59704449cf148.jpg', '', '00bc6591d92c7bb1c4bafff4fbc06d4d', '02cd5f9851624bee8a42c0a724e442fe4a3c5336', '1', '1500529737');
INSERT INTO `sys_picture` VALUES ('15', '/upload/default/picture/59705bb883e28.jpg', '', '154e548317fb5dfe25f8f1ba97cb753a', '492e04ebdfd92a15c2ea62655faf246f454745aa', '1', '1500535736');
INSERT INTO `sys_picture` VALUES ('16', '/upload/default/picture/59705bd247180.jpg', '', 'afb66eb21da4821fe5e19d21e13e284b', '06fd2e9396d49f76addb4e488ee76160089a89ec', '1', '1500535762');
INSERT INTO `sys_picture` VALUES ('17', '/upload/default/picture/59705c4b76f20.jpg', '', '2aade33049375242357b48e9bb446dd9', '821632777b423f28ef8df5903feeae06bc934041', '1', '1500535883');
INSERT INTO `sys_picture` VALUES ('18', '/upload/default/picture/59705d17dc438.jpg', '', 'ea5e3e166615968612b19bb943691629', '794a5ee17bb812a90d133bc3aa36269cae8ae992', '1', '1500536087');
INSERT INTO `sys_picture` VALUES ('19', '/upload/default/picture/59705d8d7d4b0.jpg', '', 'f243a15cd53f00813de9bae57f4774a1', '1d4a223b42be03825c6191b4b8870df7760590b0', '1', '1500536205');
INSERT INTO `sys_picture` VALUES ('20', '/upload/default/picture/59705de34e2c8.jpg', '', '8e6966ad0bfc5df0b690499639c69c7a', '1902656eb6b75a307dd5b5562fc86ef8c7a47654', '1', '1500536291');
INSERT INTO `sys_picture` VALUES ('21', '/upload/default/picture/59705e2902008.jpg', '', 'aef29287aa65b4ddb0ac00c150f17e2b', '9016926a7bf23e7f17533b19cbb45f7849350ff5', '1', '1500536361');
INSERT INTO `sys_picture` VALUES ('22', '/upload/default/picture/59705e4e67908.jpg', '', '4011d645c33c3939df2012ed53f872fd', 'ec17e57b97ea8d624831a267013c14fa80f0d31b', '1', '1500536398');
INSERT INTO `sys_picture` VALUES ('23', '/upload/default/picture/59706185bdbf0.jpg', '', '0195dc4af05ff10c48d07cfc0f3e4c31', '68d8b2432443d08416aa3d22012268293f2a090b', '1', '1500537221');
INSERT INTO `sys_picture` VALUES ('24', '/upload/head_portrait/uid_1.png', '', 'e98102feece1ba81e70950b548cdd857', 'af89f716a1f597c9f7877b9fb936429570f3ca12', '1', '1512528950');

-- ----------------------------
-- Table structure for sys_ucenter_manager
-- ----------------------------
DROP TABLE IF EXISTS `sys_ucenter_manager`;
CREATE TABLE `sys_ucenter_manager` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` char(16) NOT NULL COMMENT '用户名',
  `truename` char(50) NOT NULL COMMENT '真实姓名',
  `password` char(32) NOT NULL COMMENT '密码',
  `email` char(32) DEFAULT NULL COMMENT '用户邮箱',
  `mobile` char(15) NOT NULL DEFAULT '' COMMENT '用户手机',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `reg_ip` bigint(20) NOT NULL DEFAULT '0' COMMENT '注册IP',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` bigint(20) NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) DEFAULT '0' COMMENT '用户状态',
  `nickname` varchar(16) NOT NULL DEFAULT '' COMMENT '昵称',
  `login` int(10) DEFAULT '0' COMMENT '登录次数',
  `portrait` int(10) NOT NULL DEFAULT '0' COMMENT '用户头像',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of sys_ucenter_manager
-- ----------------------------
INSERT INTO `sys_ucenter_manager` VALUES ('1', 'administrator', '超级管理员', 'e452f760549bc64ff5eee239d9936ecc', '374145071@qq.com', '', '1499996400', '2130706433', '1541398262', '3232235975', '1541398262', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('2', 'luotest', '罗元平', '0b0ca992d369fb97853638fd20ca75c2', '374145070@qq.com', '', '1499996732', '2130706433', '1512615431', '241771082', '1512615431', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('3', 'dengchunping', '郭大娃', '15e0c1c17b37e55d24ecb9526e2be494', '3367539763@qq.com', '', '1510885918', '3736517862', '1511753883', '241771065', '1511753883', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('4', 'xujianhua', '郭二娃', '693cac05a425037110b224b49ff15db3', '2946026885@qq.com', '', '1511428516', '241771020', '1515552506', '241771316', '1515552506', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('5', 'chenhong', '郭三娃', '6791a4e76c511cebb971b1c540f6d8ce', '3383821800@qq.com', '', '1511428684', '241771020', '1515729868', '241771470', '1515729868', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('6', 'taianjuan', '郭四娃', '3d540c1233b37bf6d8c1e04ee94d0130', '26615515@qq.com', '', '1511428740', '241771020', '0', '0', '1511428740', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('7', 'zhouyi', '郭五娃', '9584ed4d62900b1188cef58711fcdd74', '486779728@qq.com', '', '1511429053', '241771020', '1519692510', '242149885', '1519692510', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('8', 'songchenchen', '郭六娃', 'a3477c6e0fe39b3a0a68ddd2de5b22e8', '2028108157@qq.com', '', '1511429081', '241771020', '0', '0', '1511429081', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('9', 'taoceshi', '郭七娃', 'de3f0d814707884ce4c011343896adaa', '2914869626@qq.com', '', '1511429242', '241771020', '1511429455', '241771020', '1511429455', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('10', 'test1234', 'test', 'e452f760549bc64ff5eee239d9936ecc', '111111@qq.com', '', '1511858738', '241771342', '1512613147', '241771082', '1512613147', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('11', 'test666', 'test', 'e452f760549bc64ff5eee239d9936ecc', '', '', '1511923499', '241771342', '1519714129', '242149885', '1519714129', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('13', 'testwei', 'wq', 'e452f760549bc64ff5eee239d9936ecc', '3426328938@qq.com', '', '1512354681', '3736517865', '0', '0', '1512354681', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('18', 'test11', 'test', 'e452f760549bc64ff5eee239d9936ecc', '', '', '1512371840', '3736517865', '0', '0', '1512371840', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('19', 'test111111', 'test', 'e452f760549bc64ff5eee239d9936ecc', '123456@qq.com', '', '1512372307', '3736517865', '0', '0', '1512372307', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('20', 'test123456', 'test', 'e452f760549bc64ff5eee239d9936ecc', '123456@qq.com', '', '1512443994', '3736517865', '0', '0', '1512443994', '-1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('21', 'test88', 'test9999', '0b0ca992d369fb97853638fd20ca75c2', '1234567890@qq.com', '', '1512444038', '3736517865', '1531212526', '242150399', '1531212526', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('22', 'tianjuan', '田娟', '3d540c1233b37bf6d8c1e04ee94d0130', '26615515@qq.com', '', '1512453171', '3736517865', '1531896736', '2130706433', '1531896737', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('23', 'suntao', '孙涛', '066e98e1a74ca4463401cdaf73d86d9a', '', '', '1517445774', '242149812', '1530517019', '242150369', '1530517019', '1', '', null, '0');
INSERT INTO `sys_ucenter_manager` VALUES ('24', 'absolutenessofli', '郭翔', 'ccd8c7188986b5edae032b5e88bdbc73', '2190204773@qq.com', '', '1518071691', '242151064', '1531882149', '2130706433', '1531882149', '1', '', null, '0');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` char(16) NOT NULL COMMENT '用户名',
  `uid` int(8) NOT NULL DEFAULT '0' COMMENT '用户id',
  `email` char(32) NOT NULL DEFAULT '' COMMENT '用户邮箱',
  `mobile` char(15) NOT NULL DEFAULT '' COMMENT '用户手机',
  `type_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '类型ID',
  `grade_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '等级ID',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` bigint(20) NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '用户状态',
  `starttime` int(10) NOT NULL DEFAULT '0' COMMENT '会员开始时间',
  `endtime` int(10) NOT NULL DEFAULT '0' COMMENT '会员结束时间',
  `department` varchar(50) NOT NULL DEFAULT '' COMMENT '部门',
  `truename` varchar(10) NOT NULL DEFAULT '' COMMENT '联系人',
  `address` varchar(30) NOT NULL DEFAULT '' COMMENT '联系地址',
  `comname` varchar(30) NOT NULL DEFAULT '' COMMENT '单位名称',
  `comtel` varchar(30) NOT NULL DEFAULT '' COMMENT '联系电话',
  `remark` varchar(60) NOT NULL DEFAULT '' COMMENT '备注',
  `client` varchar(15) NOT NULL DEFAULT '' COMMENT '平台',
  `timelong` tinyint(4) NOT NULL DEFAULT '0' COMMENT '使用期限',
  `num` int(5) NOT NULL DEFAULT '0' COMMENT '次数',
  `third_party` varchar(50) DEFAULT '' COMMENT '第三方（1：qq；2：微信；3：微博）',
  `is_autoload` int(5) NOT NULL DEFAULT '0' COMMENT '非wifi不加载图片(0:关闭；1：打开)',
  `is_useflows` int(5) DEFAULT '0' COMMENT '使用流量下载图片(1:使用；0：不使用)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('25', 'penjiasong', '303522', '1234567890@qq.com', '', '3', '16', '0', '0', '0', '0', '1', '1538323200', '1541779200', '', '', '', '', '', '发送到', '', '0', '9', null, '1', '0');
INSERT INTO `sys_user` VALUES ('32', 'pengjiasong1', '586756', '1234567890@qq.com', '', '3', '16', '0', '0', '0', '0', '1', '1531882149', '1535882149', 'xxx2', 'xxx3', 'xxx6', 'xxx1', 'xxx4', '发送到', '', '0', '9', null, '0', '0');
INSERT INTO `sys_user` VALUES ('38', 'test666', '586766', '573298584@qq.com', '15802337928', '0', '1', '1535700408', '0', '0', '0', '1', '1538293047', '1548295047', '', '', '', '', '', '', '', '0', '0', null, '0', '0');
INSERT INTO `sys_user` VALUES ('39', 'test99999', '586767', '', '', '0', '11', '1536219857', '0', '0', '0', '1', '0', '0', '', '', '', '', '', '', '', '0', '0', null, '0', '0');
INSERT INTO `sys_user` VALUES ('43', 'yang1993', '391988', '3426328938@qq.com', '18381307228', '0', '11', '0', '0', '0', '0', '1', '1538323200', '1541347200', '', '', '', 'zxzc xzczczcxz', '', '', '', '0', '0', '', '0', '0');
INSERT INTO `sys_user` VALUES ('45', '小小新', '482583', '', '', '0', '11', '0', '0', '0', '0', '-1', '0', '0', '', '', '', '', '', '', '', '0', '0', '', '0', '0');

-- ----------------------------
-- Table structure for sys_userlogin_history
-- ----------------------------
DROP TABLE IF EXISTS `sys_userlogin_history`;
CREATE TABLE `sys_userlogin_history` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `uid` int(10) DEFAULT NULL,
  `addtime` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `appname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=804 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_userlogin_history
-- ----------------------------
INSERT INTO `sys_userlogin_history` VALUES ('1', '303522', '1533862531', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('2', '303522', '1533870089', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('3', '303522', '1533870147', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('4', '303522', '1533870181', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('5', '303522', '1533870191', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('6', '303522', '1533870253', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('7', '303522', '1533870300', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('8', '303522', '1533870305', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('9', '303522', '1533870464', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('10', '303522', '1533870739', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('11', '303522', '1533881418', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('12', '586756', '1533886298', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('13', '586756', '1533886633', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('14', '303522', '1534213103', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('15', '303522', '1534213949', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('16', '303522', '1534217941', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('17', '303522', '1534218731', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('18', '303522', '1534218771', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('19', '303522', '1534218783', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('20', '303522', '1534218975', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('21', '303522', '1534219005', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('22', '303522', '1534219019', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('23', '303522', '1534219099', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('24', '303522', '1534228077', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('25', '303522', '1534228949', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('26', '303522', '1534232969', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('27', '0', '1534233466', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('28', '0', '1534233711', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('29', '0', '1534323174', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('30', '0', '1534472306', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('31', '0', '1534497552', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('32', '0', '1534816114', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('33', '0', '1534819383', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('34', '0', '1534819703', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('35', '0', '1534821562', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('36', '0', '1534822908', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('37', '0', '1534822910', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('38', '0', '1534823196', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('39', '0', '1534823405', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('40', '0', '1534823406', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('41', '0', '1534823485', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('42', '0', '1534823539', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('43', '0', '1534823580', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('44', '0', '1534823643', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('45', '0', '1534823698', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('46', '0', '1534823792', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('47', '0', '1534824076', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('48', '0', '1534830844', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('49', '0', '1534831123', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('50', '0', '1534831378', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('51', '0', '1534832502', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('52', '0', '1534832575', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('53', '0', '1534832806', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('54', '0', '1534833045', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('55', '0', '1534833080', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('56', '0', '1534833081', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('57', '0', '1534833559', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('58', '0', '1534833936', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('59', '0', '1534834138', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('60', '0', '1534834310', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('61', '0', '1534834583', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('62', '0', '1534834666', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('63', '0', '1534834755', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('64', '0', '1534834897', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('65', '0', '1534835011', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('66', '0', '1534835069', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('67', '0', '1534835459', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('68', '0', '1534835678', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('69', '0', '1534837061', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('70', '0', '1534837169', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('71', '0', '1534837290', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('72', '0', '1534837510', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('73', '0', '1534837617', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('74', '0', '1534837689', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('75', '0', '1534837768', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('76', '0', '1534837822', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('77', '0', '1534837866', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('78', '0', '1534837952', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('79', '0', '1534838017', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('80', '0', '1534838423', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('81', '0', '1534838429', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('82', '0', '1534838440', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('83', '0', '1534838585', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('84', '0', '1534838982', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('85', '0', '1534839008', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('86', '0', '1534839112', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('87', '0', '1534839189', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('88', '0', '1534839245', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('89', '0', '1534839401', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('90', '0', '1534839768', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('91', '0', '1534842102', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('92', '0', '1534842255', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('93', '0', '1534844147', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('94', '0', '1534844273', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('95', '0', '1534845470', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('96', '0', '1534897852', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('97', '0', '1534898293', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('98', '0', '1534899248', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('99', '0', '1534899380', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('100', '0', '1534899501', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('101', '0', '1534899582', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('102', '0', '1534899662', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('103', '0', '1534899758', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('104', '0', '1534899985', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('105', '0', '1534900146', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('106', '0', '1534900140', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('107', '0', '1534900211', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('108', '0', '1534900391', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('109', '0', '1534900941', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('110', '0', '1534900985', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('111', '0', '1534901860', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('112', '0', '1534902179', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('113', '0', '1534902295', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('114', '0', '1534902798', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('115', '0', '1534903536', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('116', '0', '1534903860', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('117', '0', '1534903958', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('118', '0', '1534904099', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('119', '0', '1534904202', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('120', '0', '1534904390', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('121', '0', '1534904436', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('122', '0', '1534904563', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('123', '0', '1534904642', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('124', '0', '1534904759', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('125', '0', '1534904913', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('126', '0', '1534904989', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('127', '0', '1534905150', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('128', '0', '1534905315', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('129', '0', '1534905428', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('130', '0', '1534905468', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('131', '0', '1534905687', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('132', '0', '1534905759', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('133', '0', '1534905760', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('134', '0', '1534905938', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('135', '0', '1534906132', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('136', '0', '1534906289', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('137', '0', '1534906331', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('138', '0', '1534906363', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('139', '0', '1534906397', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('140', '0', '1534906969', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('141', '0', '1534906970', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('142', '0', '1534907321', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('143', '0', '1534907388', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('144', '0', '1534907476', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('145', '0', '1534907605', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('146', '0', '1534907680', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('147', '0', '1534907833', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('148', '0', '1534908043', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('149', '0', '1534909102', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('150', '0', '1534909174', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('151', '0', '1534910366', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('152', '0', '1534911817', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('153', '0', '1534919038', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('154', '0', '1534920484', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('155', '0', '1534920952', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('156', '0', '1534921739', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('157', '0', '1534922146', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('158', '0', '1534922554', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('159', '303522', '1534923694', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('160', '0', '1534924163', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('161', '0', '1534924302', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('162', '0', '1534924403', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('163', '0', '1534924615', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('164', '0', '1534924658', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('165', '0', '1534924819', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('166', '303522', '1534924929', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('167', '0', '1534925038', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('168', '0', '1534925087', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('169', '0', '1534925387', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('170', '0', '1534926154', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('171', '0', '1534926325', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('172', '0', '1534926473', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('173', '0', '1534926579', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('174', '0', '1534926616', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('175', '0', '1534926655', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('176', '0', '1534926824', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('177', '0', '1534926858', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('178', '0', '1534927077', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('179', '0', '1534927245', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('180', '303522', '1534927341', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('181', '0', '1534928240', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('182', '0', '1534986559', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('183', '0', '1534986647', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('184', '0', '1534986780', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('185', '0', '1534986865', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('186', '0', '1534987425', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('187', '0', '1534988228', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('188', '0', '1534988711', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('189', '0', '1534989899', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('190', '0', '1534990534', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('191', '0', '1534991016', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('192', '0', '1534991017', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('193', '0', '1534991221', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('194', '0', '1534991738', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('195', '0', '1534992096', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('196', '0', '1534992252', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('197', '0', '1534992253', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('198', '0', '1534992367', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('199', '0', '1534992681', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('200', '0', '1534992801', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('201', '0', '1534992900', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('202', '0', '1534993287', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('203', '0', '1534995579', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('204', '0', '1534996030', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('205', '0', '1534996298', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('206', '0', '1534996603', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('207', '0', '1534998864', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('208', '0', '1534998905', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('209', '0', '1534999527', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('210', '0', '1535003112', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('211', '0', '1535003193', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('212', '0', '1535003330', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('213', '0', '1535003479', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('214', '0', '1535003801', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('215', '0', '1535003868', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('216', '0', '1535003971', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('217', '0', '1535004036', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('218', '0', '1535004113', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('219', '0', '1535004204', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('220', '0', '1535004367', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('221', '0', '1535004487', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('222', '0', '1535004592', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('223', '0', '1535004685', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('224', '0', '1535004718', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('225', '0', '1535004859', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('226', '0', '1535004904', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('227', '0', '1535004973', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('228', '0', '1535004979', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('229', '0', '1535005125', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('230', '0', '1535005278', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('231', '0', '1535005305', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('232', '0', '1535005629', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('233', '0', '1535005725', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('234', '0', '1535005775', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('235', '0', '1535005872', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('236', '0', '1535005950', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('237', '0', '1535006282', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('238', '0', '1535006625', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('239', '0', '1535006669', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('240', '0', '1535006804', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('241', '0', '1535007581', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('242', '0', '1535007756', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('243', '0', '1535007881', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('244', '0', '1535008202', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('245', '0', '1535009088', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('246', '0', '1535009276', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('247', '0', '1535009408', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('248', '0', '1535009538', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('249', '0', '1535009630', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('250', '0', '1535009728', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('251', '0', '1535009798', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('252', '0', '1535010074', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('253', '0', '1535010126', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('254', '0', '1535010303', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('255', '0', '1535010876', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('256', '0', '1535010911', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('257', '0', '1535011120', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('258', '0', '1535011301', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('259', '0', '1535011367', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('260', '0', '1535011479', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('261', '0', '1535011674', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('262', '0', '1535011877', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('263', '0', '1535012050', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('264', '0', '1535012108', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('265', '0', '1535012150', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('266', '0', '1535012289', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('267', '0', '1535012699', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('268', '0', '1535013061', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('269', '0', '1535013324', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('270', '0', '1535013448', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('271', '0', '1535013522', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('272', '0', '1535013596', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('273', '0', '1535013903', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('274', '0', '1535015117', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('275', '0', '1535015336', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('276', '0', '1535015542', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('277', '0', '1535015700', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('278', '0', '1535016954', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('279', '0', '1535017026', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('280', '0', '1535017077', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('281', '0', '1535072299', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('282', '0', '1535076871', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('283', '0', '1535077033', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('284', '0', '1535077034', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('285', '0', '1535077693', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('286', '0', '1535077827', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('287', '0', '1535078436', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('288', '0', '1535078552', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('289', '0', '1535078661', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('290', '0', '1535078708', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('291', '0', '1535079150', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('292', '0', '1535079226', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('293', '0', '1535079424', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('294', '0', '1535080064', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('295', '0', '1535080146', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('296', '0', '1535080260', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('297', '0', '1535080484', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('298', '0', '1535080568', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('299', '0', '1535081110', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('300', '0', '1535081176', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('301', '0', '1535081329', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('302', '0', '1535081427', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('303', '0', '1535081511', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('304', '0', '1535081571', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('305', '0', '1535081741', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('306', '0', '1535081832', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('307', '0', '1535081972', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('308', '0', '1535082082', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('309', '0', '1535082319', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('310', '0', '1535082408', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('311', '0', '1535082456', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('312', '0', '1535082615', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('313', '0', '1535083084', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('314', '0', '1535083156', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('315', '0', '1535083228', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('316', '0', '1535089858', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('317', '0', '1535090140', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('318', '0', '1535090246', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('319', '0', '1535090612', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('320', '0', '1535090688', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('321', '0', '1535092389', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('322', '0', '1535094116', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('323', '0', '1535094464', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('324', '0', '1535094613', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('325', '0', '1535094734', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('326', '0', '1535094824', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('327', '0', '1535094938', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('328', '0', '1535095083', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('329', '0', '1535095122', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('330', '0', '1535095234', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('331', '0', '1535095530', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('332', '0', '1535095695', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('333', '0', '1535095953', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('334', '0', '1535096132', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('335', '0', '1535096262', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('336', '0', '1535096637', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('337', '0', '1535096638', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('338', '0', '1535096713', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('339', '0', '1535096734', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('340', '0', '1535096826', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('341', '0', '1535096869', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('342', '0', '1535097112', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('343', '0', '1535097397', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('344', '0', '1535097673', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('345', '0', '1535098267', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('346', '0', '1535098421', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('347', '0', '1535098796', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('348', '0', '1535099744', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('349', '0', '1535100053', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('350', '0', '1535100095', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('351', '0', '1535100371', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('352', '0', '1535100835', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('353', '0', '1535101076', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('354', '0', '1535101152', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('355', '0', '1535102331', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('356', '0', '1535102427', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('357', '0', '1535102555', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('358', '0', '1535103337', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('359', '0', '1535104273', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('360', '0', '1535104361', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('361', '0', '1535104438', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('362', '0', '1535104637', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('363', '0', '1535104922', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('364', '0', '1535331457', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('365', '0', '1535332260', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('366', '0', '1535333991', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('367', '0', '1535336467', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('368', '0', '1535336546', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('369', '0', '1535338029', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('370', '0', '1535338737', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('371', '0', '1535340360', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('372', '0', '1535340396', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('373', '0', '1535340391', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('374', '0', '1535340544', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('375', '0', '1535340667', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('376', '0', '1535340774', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('377', '0', '1535340815', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('378', '0', '1535341339', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('379', '0', '1535349307', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('380', '0', '1535351730', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('381', '0', '1535351856', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('382', '0', '1535351948', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('383', '0', '1535352076', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('384', '0', '1535352259', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('385', '0', '1535356321', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('386', '0', '1535356440', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('387', '0', '1535356739', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('388', '0', '1535357575', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('389', '0', '1535358147', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('390', '0', '1535358646', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('391', '0', '1535359149', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('392', '0', '1535359630', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('393', '0', '1535359796', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('394', '0', '1535359901', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('395', '0', '1535360334', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('396', '0', '1535360557', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('397', '0', '1535360768', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('398', '0', '1535361034', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('399', '0', '1535361606', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('400', '0', '1535361687', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('401', '0', '1535361869', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('402', '0', '1535361957', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('403', '0', '1535362737', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('404', '0', '1535363013', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('405', '0', '1535363179', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('406', '0', '1535363318', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('407', '0', '1535363799', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('408', '0', '1535363900', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('409', '0', '1535364004', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('410', '0', '1535418041', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('411', '0', '1535418664', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('412', '0', '1535418963', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('413', '0', '1535424745', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('414', '0', '1535427303', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('415', '0', '1535427436', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('416', '0', '1535427681', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('417', '0', '1535427858', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('418', '0', '1535428130', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('419', '0', '1535428587', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('420', '0', '1535428694', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('421', '0', '1535436470', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('422', '0', '1535436585', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('423', '0', '1535437553', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('424', '0', '1535438187', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('425', '0', '1535439612', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('426', '0', '1535439670', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('427', '0', '1535439712', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('428', '0', '1535439769', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('429', '0', '1535439847', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('430', '0', '1535439962', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('431', '0', '1535440093', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('432', '0', '1535440244', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('433', '0', '1535440387', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('434', '0', '1535440431', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('435', '0', '1535440533', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('436', '0', '1535441898', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('437', '0', '1535442077', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('438', '0', '1535442434', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('439', '0', '1535442511', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('440', '0', '1535446146', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('441', '0', '1535446147', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('442', '0', '1535446589', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('443', '0', '1535447000', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('444', '0', '1535504300', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('445', '0', '1535513869', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('446', '0', '1535514536', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('447', '0', '1535526634', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('448', '0', '1535526868', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('449', '0', '1535527227', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('450', '0', '1535528584', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('451', '0', '1535528737', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('452', '0', '1535529910', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('453', '0', '1535530082', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('454', '0', '1535530312', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('455', '0', '1535590909', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('456', '0', '1535591304', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('457', '0', '1535591532', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('458', '0', '1535591702', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('459', '0', '1535591759', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('460', '0', '1535591849', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('461', '0', '1535592494', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('462', '0', '1535592801', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('463', '0', '1535593001', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('464', '0', '1535593444', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('465', '0', '1535594140', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('466', '0', '1535594542', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('467', '0', '1535594670', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('468', '0', '1535594845', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('469', '0', '1535599576', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('470', '0', '1535599655', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('471', '0', '1535600458', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('472', '0', '1535600569', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('473', '0', '1535609678', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('474', '0', '1535609829', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('475', '0', '1535610009', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('476', '0', '1535611474', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('477', '0', '1535613932', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('478', '0', '1535614303', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('479', '0', '1535614529', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('480', '0', '1535614564', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('481', '0', '1535619932', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('482', '0', '1535620024', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('483', '0', '1535620233', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('484', '0', '1535620403', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('485', '0', '1535621426', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('486', '0', '1535621560', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('487', '0', '1535621843', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('488', '0', '1535621914', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('489', '0', '1535622389', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('490', '0', '1535622437', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('491', '0', '1535676806', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('492', '0', '1535682294', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('493', '0', '1535683312', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('494', '0', '1535683374', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('495', '0', '1535683712', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('496', '0', '1535684658', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('497', '0', '1535685277', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('498', '0', '1535685774', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('499', '0', '1535685825', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('500', '0', '1535685875', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('501', '0', '1535685980', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('502', '0', '1535686098', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('503', '0', '1535686253', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('504', '0', '1535686304', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('505', '0', '1535686392', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('506', '0', '1535686536', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('507', '0', '1535686649', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('508', '0', '1535686684', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('509', '0', '1535686761', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('510', '0', '1535686808', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('511', '0', '1535688062', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('512', '0', '1535688364', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('513', '0', '1535689830', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('514', '0', '1535689951', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('515', '0', '1535691189', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('516', '0', '1535694581', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('517', '0', '1535694951', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('518', '0', '1535695386', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('519', '0', '1535695572', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('520', '0', '1535695664', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('521', '0', '1535695731', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('522', '0', '1535695830', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('523', '0', '1535695889', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('524', '0', '1535696182', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('525', '0', '1535696988', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('526', '0', '1535697244', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('527', '0', '1535698833', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('528', '0', '1535698909', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('529', '0', '1535699077', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('530', '0', '1535699132', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('531', '0', '1535699166', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('532', '0', '1535702776', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('533', '0', '1535703163', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('534', '0', '1535705714', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('535', '0', '1535705789', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('536', '0', '1535707653', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('537', '0', '1535939384', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('538', '0', '1535953926', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('539', '0', '1535954937', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('540', '0', '1535954977', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('541', '0', '1535956197', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('542', '0', '1535958751', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('543', '0', '1535958833', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('544', '0', '1535959082', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('545', '0', '1535963349', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('546', '0', '1535964870', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('547', '0', '1535965427', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('548', '0', '1535965560', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('549', '0', '1535965890', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('550', '0', '1535966127', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('551', '0', '1535966339', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('552', '0', '1536022842', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('553', '0', '1536029923', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('554', '0', '1536029923', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('555', '0', '1536030168', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('556', '0', '1536030732', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('557', '0', '1536031675', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('558', '0', '1536032436', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('559', '0', '1536041904', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('560', '0', '1536042332', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('561', '0', '1536042687', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('562', '0', '1536042738', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('563', '0', '1536043157', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('564', '0', '1536043874', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('565', '0', '1536045682', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('566', '0', '1536045904', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('567', '0', '1536046532', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('568', '0', '1536046533', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('569', '0', '1536049320', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('570', '0', '1536049412', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('571', '0', '1536049988', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('572', '0', '1536050057', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('573', '0', '1536050226', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('574', '0', '1536051147', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('575', '0', '1536053888', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('576', '0', '1536053955', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('577', '0', '1536054041', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('578', '0', '1536054452', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('579', '0', '1536054605', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('580', '0', '1536109886', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('581', '0', '1536112771', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('582', '0', '1536118905', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('583', '0', '1536119146', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('584', '0', '1536119365', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('585', '0', '1536119535', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('586', '0', '1536119684', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('587', '0', '1536130810', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('588', '0', '1536131682', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('589', '0', '1536131774', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('590', '0', '1536132542', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('591', '0', '1536132837', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('592', '0', '1536133121', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('593', '0', '1536133170', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('594', '0', '1536133276', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('595', '0', '1536133332', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('596', '0', '1536133441', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('597', '0', '1536134770', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('598', '0', '1536134858', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('599', '0', '1536134982', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('600', '0', '1536135306', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('601', '0', '1536135481', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('602', '0', '1536135542', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('603', '0', '1536135615', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('604', '0', '1536135729', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('605', '0', '1536135818', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('606', '0', '1536135897', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('607', '0', '1536136058', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('608', '0', '1536136243', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('609', '0', '1536136323', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('610', '0', '1536136382', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('611', '0', '1536136553', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('612', '0', '1536136727', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('613', '0', '1536137031', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('614', '0', '1536137180', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('615', '0', '1536137242', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('616', '0', '1536140398', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('617', '0', '1536140502', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('618', '0', '1536141286', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('619', '0', '1536196367', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('620', '0', '1536196725', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('621', '0', '1536197165', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('622', '0', '1536197349', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('623', '0', '1536197403', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('624', '0', '1536197962', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('625', '0', '1536198040', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('626', '0', '1536198205', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('627', '0', '1536202440', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('628', '0', '1536202440', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('629', '0', '1536202440', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('630', '0', '1536212774', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('631', '0', '1536215914', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('632', '586767', '1536219881', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('633', '586767', '1536220094', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('634', '586767', '1536220249', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('635', '586767', '1536220368', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('636', '586767', '1536220381', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('637', '586767', '1536221029', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('638', '586767', '1536221049', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('639', '586767', '1536221622', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('640', '586766', '1538100905', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('641', '586766', '1538101197', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('642', '586766', '1538101546', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('643', '586766', '1538102396', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('644', '586766', '1538102420', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('645', '586766', '1538102932', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('646', '586766', '1538103001', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('647', '586766', '1538104109', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('648', '586766', '1538104291', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('649', '586766', '1538104888', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('650', '586766', '1538979437', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('651', '586766', '1538979477', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('652', '586766', '1539570542', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('653', '586766', '1539570653', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('654', '586766', '1539591576', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('655', '586766', '1539592186', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('656', '586766', '1539592453', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('657', '586766', '1539592596', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('658', '586766', '1539592754', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('659', '586766', '1539617756', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('660', '586766', '1539617823', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('661', '586766', '1539650156', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('662', '586766', '1539650625', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('663', '586766', '1539650649', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('664', '586766', '1539650676', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('665', '586766', '1539651002', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('666', '586766', '1539711040', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('667', '586766', '1539739599', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('668', '586766', '1539739898', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('669', '586766', '1539741497', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('670', '586766', '1539747870', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('671', '586766', '1539747929', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('672', '586766', '1539748079', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('673', '586766', '1539843406', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('674', '586766', '1539843437', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('675', '586766', '1539850188', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('676', '586766', '1539914127', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('677', '586766', '1539914279', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('678', '586766', '1539919583', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('679', '586766', '1539930281', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('680', '586766', '1539930452', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('681', '586766', '1539932525', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('682', '586766', '1539934309', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('683', '586766', '1539934447', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('684', '586766', '1539935313', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('685', '586766', '1539936634', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('686', '586766', '1539937322', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('687', '586766', '1539938972', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('688', '586766', '1539939222', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('689', '586766', '1539939493', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('690', '586766', '1539939721', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('691', '586766', '1539940113', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('692', '586766', '1539941964', null, null, null);
INSERT INTO `sys_userlogin_history` VALUES ('693', '586766', '1539944834', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('694', '586766', '1539944864', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('695', '586766', '1539945601', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('696', '586766', '1540103214', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('697', '586766', '1540103347', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('698', '586766', '1540103467', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('699', '586766', '1540103484', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('700', '586766', '1540103607', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('701', '586766', '1540106803', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('702', '586774', '1540109327', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('703', '586775', '1540109564', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('704', '586776', '1540109749', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('705', '586776', '1540109999', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('706', '586776', '1540110066', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('707', '586776', '1540110138', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('708', '586776', '1540110353', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('709', '586776', '1540110414', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('710', '586776', '1540110502', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('711', '586776', '1540110540', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('712', '586776', '1540110617', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('713', '586776', '1540117578', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('714', '586777', '1540117755', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('715', '586766', '1540118732', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('716', '586766', '1540118885', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('717', '586766', '1540118900', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('718', '586766', '1540119019', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('719', '586766', '1540119078', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('720', '586766', '1540119274', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('721', '586766', '1540119323', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('722', '586766', '1540119380', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('723', '586766', '1540119400', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('724', '586766', '1540122558', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('725', '586778', '1540123317', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('726', '586766', '1540123542', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('727', '586766', '1540123615', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('728', '586766', '1540200060', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('729', '586766', '1540200080', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('730', '586766', '1540254153', null, 'iOS', null);
INSERT INTO `sys_userlogin_history` VALUES ('731', '586780', '1540280725', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('732', '586780', '1540281260', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('733', '586780', '1540281295', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('734', '586780', '1540281563', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('735', '586780', '1540281694', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('736', '586780', '1540281752', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('737', '586766', '1540282219', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('738', '586766', '1540282252', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('739', '586766', '1540282255', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('740', '586766', '1540283003', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('741', '586766', '1540284341', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('742', '586781', '1540284481', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('743', '586781', '1540284493', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('744', '586766', '1540284525', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('745', '586766', '1540284906', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('746', '586766', '1540285002', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('747', '586766', '1540285052', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('748', '586780', '1540285249', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('749', '586782', '1540285949', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('750', '586782', '1540286029', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('751', '586782', '1540286158', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('752', '586782', '1540286666', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('753', '586782', '1540286907', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('754', '586782', '1540287030', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('755', '586782', '1540287064', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('756', '586782', '1540287322', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('757', '586782', '1540287334', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('758', '586782', '1540287408', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('759', '586766', '1540287856', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('760', '586766', '1540287894', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('761', '586766', '1540287998', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('762', '586766', '1540288022', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('763', '586766', '1540288265', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('764', '586766', '1540288289', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('765', '586766', '1540288627', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('766', '586766', '1540288653', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('767', '586766', '1540288692', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('768', '586766', '1540288744', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('769', '586766', '1540289413', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('770', '586766', '1540289500', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('771', '586766', '1540289646', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('772', '586766', '1540290166', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('773', '586766', '1540290183', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('774', '586766', '1540342465', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('775', '586766', '1540343693', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('776', '586766', '1540343800', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('777', '586766', '1540344320', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('778', '586766', '1540344330', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('779', '586783', '1540345262', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('780', '586783', '1540345269', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('781', '586766', '1540360164', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('782', '586766', '1540368348', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('783', '586783', '1540377817', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('784', '586784', '1540429848', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('785', '586766', '1540433999', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('786', '586766', '1540434932', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('787', '586766', '1540535250', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('788', '391988', '1540548608', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('789', '391988', '1540548735', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('790', '391988', '1540548765', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('791', '391988', '1540549344', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('792', '391988', '1540775415', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('793', '391988', '1540806393', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('794', '391988', '1540806795', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('795', '391988', '1540808318', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('796', '391988', '1540867609', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('797', '391988', '1540952098', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('798', '586783', '1540952858', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('799', '391988', '1540978133', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('800', '391988', '1541125228', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('801', '391988', '1541125260', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('802', '391988', '1541131190', null, 'Android', null);
INSERT INTO `sys_userlogin_history` VALUES ('803', '391988', '1541144035', null, 'Android', null);

-- ----------------------------
-- Table structure for sys_user_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_auth_rule`;
CREATE TABLE `sys_user_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1-url;2-主菜单',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '规则名称',
  `action` varchar(60) NOT NULL DEFAULT '' COMMENT '模型名',
  `dbname` varchar(20) NOT NULL DEFAULT '' COMMENT '数据库名称',
  `inputname` varchar(20) NOT NULL DEFAULT '' COMMENT 'input框的名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `dbid` int(5) NOT NULL DEFAULT '0' COMMENT '数据库id',
  `field` varchar(30) NOT NULL DEFAULT '' COMMENT '特殊字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_user_auth_rule
-- ----------------------------
INSERT INTO `sys_user_auth_rule` VALUES ('2', '1', '高级搜索', 'index', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('3', '1', '条件筛选', 'index', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('4', '1', '可视化', 'visualization', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('5', '1', '列表', 'index', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('6', '1', '特殊列表', '', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('7', '1', '详情页', 'read', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('8', '1', '特殊详情', '', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('9', '1', '导出200', 'outdata', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('13', '1', '翻页限制75', '', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('14', '3', '注册订阅', '', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('15', '3', '药物报告-词冠查询', '', '', '', '1', '0', '');
INSERT INTO `sys_user_auth_rule` VALUES ('28', '4', '功能主治', 'index', '中药材基本信息库', '', '1', '53', 'use');
INSERT INTO `sys_user_auth_rule` VALUES ('29', '4', '原拉丁植物动物矿物名', 'read', '中药材基本信息库', '', '1', '53', 'lading');
INSERT INTO `sys_user_auth_rule` VALUES ('30', '4', '药材名称', 'index', '中药材基本信息库', '', '1', '62', 'name');
INSERT INTO `sys_user_auth_rule` VALUES ('31', '4', '药材名称1', 'index', '中药材基本信息库', '', '1', '62', 'name');
INSERT INTO `sys_user_auth_rule` VALUES ('32', '4', '登记号', 'index', '中国临床试验数据库', '', '1', '65', 'me_id');
INSERT INTO `sys_user_auth_rule` VALUES ('33', '4', '药材名称', 'index', '中药材基本信息库', '', '1', '80', 'name');
INSERT INTO `sys_user_auth_rule` VALUES ('36', '1', '时光轴', 'timeline', '', '', '1', '0', '');

-- ----------------------------
-- Table structure for sys_user_grade
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_grade`;
CREATE TABLE `sys_user_grade` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组id,自增主键',
  `type_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '组类型',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) NOT NULL DEFAULT '' COMMENT '描述信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户组状态：为1正常，为0禁用,-1为删除',
  `rules` varchar(500) NOT NULL DEFAULT '' COMMENT '用户组拥有的规则id，多个规则 , 隔开',
  `dbrules` varchar(500) NOT NULL DEFAULT '' COMMENT '数据库权限',
  `change_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  `admin` varchar(20) NOT NULL DEFAULT '' COMMENT '修改人',
  `db_num` tinyint(4) NOT NULL DEFAULT '0' COMMENT '数据库数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_user_grade
-- ----------------------------
INSERT INTO `sys_user_grade` VALUES ('1', '1', '默认用户组', '', '-1', '2,3,4,5,6,7,13,14,15', '0,1,2,25,0,53,29', '1539765841', '超级管理员', '7');
INSERT INTO `sys_user_grade` VALUES ('2', '1', '测试用户', '测试用户', '-1', '1,3,22,26,61,66,100,102,103,108,109,207,231,233,238,239,240,241,242,243,244,249,250,251,252,253,254,255,256,257,259,288,289,290,291,322', '', '0', '', '0');
INSERT INTO `sys_user_grade` VALUES ('3', '1', '运营', '运营管理人员用户组', '-1', '1,2,6,15', '0,1,2', '1533005825', 'administrator', '3');
INSERT INTO `sys_user_grade` VALUES ('4', '1', '营销中心', 'a', '-1', '1,108,294,312,313,314,315,316,317,320,321,323,324,325,326,327,328,329,330,331,332,333,334,338,339,340,341,342,343,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,369,370,371', '', '1532049613', '', '0');
INSERT INTO `sys_user_grade` VALUES ('5', '1', 'test', '', '-1', '1,312,314,325,340,341,352,353,357', '', '0', '', '0');
INSERT INTO `sys_user_grade` VALUES ('6', '1', 'test', 'bbbbb', '-1', '', '', '0', '', '0');
INSERT INTO `sys_user_grade` VALUES ('7', '0', 'adfasdfdddd', 'aa', '-1', '', '', '1532055586', 'administrator', '0');
INSERT INTO `sys_user_grade` VALUES ('8', '0', 'testaa', 'vvvv', '-1', '', '', '1532055563', 'administrator', '0');
INSERT INTO `sys_user_grade` VALUES ('9', '0', '发的发', '', '-1', '4,6,15', '', '1533006308', 'administrator', '0');
INSERT INTO `sys_user_grade` VALUES ('10', '0', '初级', '', '-1', '', '', '1533009143', 'administrator', '0');
INSERT INTO `sys_user_grade` VALUES ('11', '0', '数据库顾问', '营销中心', '1', '', '', '1540546592', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('12', '10', '测试', '', '-1', '', '', '1539755272', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('13', '10', '测试22', '', '-1', '', '', '1539756407', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('14', '9', '12123', '', '-1', '', '29', '1539765339', '超级管理员', '1');
INSERT INTO `sys_user_grade` VALUES ('15', '1', '初级测试', '测试', '1', '', '1,2,80', '1539765976', '超级管理员', '3');
INSERT INTO `sys_user_grade` VALUES ('16', '11', '综合特级', '', '1', '6,8,29,29,28', '0,1,2,0,0,53,0,29,0', '1540808744', '超级管理员', '9');
INSERT INTO `sys_user_grade` VALUES ('17', '7', '测试123', '', '-1', '2,3,4,5,6,7,13,14,15,28,29,30,31', '', '1540515002', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('18', '0', 'ttttt', 'asfasdf', '-1', '', '', '1540546603', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('19', '0', '数据库顾问', 'fasdf', '-1', '', '', '1540546865', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('20', '0', 'fasdfasdfasd', 'fasdfasdddddd', '-1', '', '', '1540546901', '超级管理员', '0');
INSERT INTO `sys_user_grade` VALUES ('21', '0', 'fasdf', 'fasdfa', '1', '', '', '1540547696', '超级管理员', '0');

-- ----------------------------
-- Table structure for sys_user_iplogin
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_iplogin`;
CREATE TABLE `sys_user_iplogin` (
  `ip_id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `iplow` varchar(100) NOT NULL,
  `ipup` varchar(100) NOT NULL,
  `ukey` varchar(100) DEFAULT NULL,
  `no_allowed_login` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ip_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_user_iplogin
-- ----------------------------
INSERT INTO `sys_user_iplogin` VALUES ('6', '303522', '127.0.0.1', '127.0.0.1', null, '0');
INSERT INTO `sys_user_iplogin` VALUES ('23', '391988', '123.147.248.187', '123.147.248.187', null, '0');
INSERT INTO `sys_user_iplogin` VALUES ('24', '586767', '14.110.236.1', '14.110.236.200', null, '0');
INSERT INTO `sys_user_iplogin` VALUES ('25', '586767', '14.110.233.1', '14.110.233.200', null, '0');
INSERT INTO `sys_user_iplogin` VALUES ('26', '586767', '14.110.233.223', '14.110.233.223', null, '0');
INSERT INTO `sys_user_iplogin` VALUES ('27', '586767', '14.110.236.1', '14.110.236.201', null, '0');

-- ----------------------------
-- Table structure for sys_vipoperation
-- ----------------------------
DROP TABLE IF EXISTS `sys_vipoperation`;
CREATE TABLE `sys_vipoperation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `sygrade` varchar(50) DEFAULT NULL,
  `systarttime` int(11) DEFAULT NULL,
  `syendtime` int(11) DEFAULT NULL,
  `qystarttime` int(11) DEFAULT NULL,
  `qyendtime` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `beizhu` varchar(300) DEFAULT NULL,
  `qygrade` varchar(50) DEFAULT NULL,
  `update` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_vipoperation
-- ----------------------------
INSERT INTO `sys_vipoperation` VALUES ('1', '2909', 'admin', '1511834568', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('2', '2909', 'admin', '1511834593', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('3', '2909', 'admin', '1511834598', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('4', '2910', 'admin', '1511835243', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('5', '2910', 'admin', '1511835262', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('6', '2910', 'admin', '1511835266', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('7', '2907', 'admin', '1511835312', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('8', '2910', 'admin', '1511835361', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('9', '2910', 'admin', '1511837316', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('10', '2910', 'admin', '1511837353', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('11', '2905', 'admin', '1511839029', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('12', '2908', 'admin', '1511839654', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('13', '2910', 'admin', '1511839681', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('14', '2909', 'admin', '1511856856', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('15', '2902', 'admin', '1511935588', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('16', '2901', 'admin', '1511935700', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('17', '2903', 'admin', '1513929960', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('18', '2903', 'admin', '1513930171', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('19', '2900', 'admin', '1513930320', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('20', '2899', 'admin', '1514166641', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('21', '2898', 'admin', '1514167015', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('22', '2898', 'admin', '1514167175', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('23', '2898', 'admin', '1514167304', null, null, null, null, null, null, null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('24', '2897', 'admin', '1514171220', null, null, null, null, null, '5', null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('25', '2897', 'admin', '1514171244', null, null, null, '1514131200', '1514563200', '3', null, '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('26', '2897', 'admin', '1514172574', '营销中级（试用）', '1513094400', '1513872000', null, null, '1', null, null, null);
INSERT INTO `sys_vipoperation` VALUES ('27', '2897', 'admin', '1514172657', null, null, null, '1514563200', '1514563200', '3', 'Cesare鼎折覆餗大润发', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('28', '2897', 'admin', '1514180476', null, null, null, '1514563200', '1514563200', '3', '签约备注', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('29', '2897', 'admin', '1514183657', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为郭浩)');
INSERT INTO `sys_vipoperation` VALUES ('30', '2897', 'admin', '1514184021', null, null, null, null, null, null, null, null, '负责人变更(由郭浩2变更为郭浩2)');
INSERT INTO `sys_vipoperation` VALUES ('31', '2897', 'admin', '1514184859', '营销中级（试用）', '1513094400', '1513872000', null, null, '1', '测试使用2017年12月25日14:54:16', null, null);
INSERT INTO `sys_vipoperation` VALUES ('32', '2897', 'admin', '1514184962', '营销中级（试用）', '1513094400', '1513872000', null, null, '1', '测试使用2017年12月25日14:56:01', null, null);
INSERT INTO `sys_vipoperation` VALUES ('33', '2896', 'admin', '1514186446', null, null, null, null, null, '5', '很多歌太阳', null, null);
INSERT INTO `sys_vipoperation` VALUES ('34', '14', 'admin', '1514189169', null, null, null, null, null, '5', '打发时间是', null, null);
INSERT INTO `sys_vipoperation` VALUES ('35', '13', 'admin', '1514189201', null, null, null, null, null, '5', '发生的人', null, null);
INSERT INTO `sys_vipoperation` VALUES ('36', '2910', 'admin', '1514258224', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('37', '2909', 'admin', '1514258989', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('38', '2910', 'admin', '1514267499', null, null, null, null, null, '7', '黄金客户看', null, null);
INSERT INTO `sys_vipoperation` VALUES ('39', '2909', 'admin', '1514267554', null, null, null, null, null, '7', '1', null, null);
INSERT INTO `sys_vipoperation` VALUES ('40', '2910', 'admin', '1514273685', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为admin)');
INSERT INTO `sys_vipoperation` VALUES ('41', '2910', 'admin', '1514274075', null, null, null, null, null, '7', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('42', '2910', 'admin', '1514274116', null, null, null, null, null, '7', '1', null, null);
INSERT INTO `sys_vipoperation` VALUES ('43', '2895', 'admin', '1514274290', null, null, null, null, null, '5', 'gx开始处理', null, null);
INSERT INTO `sys_vipoperation` VALUES ('44', '2892', 'admin', '1514275641', null, null, null, null, null, '7', '12321', null, null);
INSERT INTO `sys_vipoperation` VALUES ('45', '2894', 'admin', '1514277200', null, null, null, null, null, '7', 'gfh', null, null);
INSERT INTO `sys_vipoperation` VALUES ('46', '2910', 'admin', '1514336040', null, null, null, null, null, '6', '看见过和结果', null, null);
INSERT INTO `sys_vipoperation` VALUES ('47', '2910', 'admin', '1514337594', null, null, null, null, null, '4', 'sadfs f sdf sdg', null, null);
INSERT INTO `sys_vipoperation` VALUES ('48', '2834', 'admin', '1514338601', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('49', '2910', 'admin', '1514341119', '营销特级（试用）', '2017', '2017', null, null, '1', '123213', null, null);
INSERT INTO `sys_vipoperation` VALUES ('50', '2910', 'admin', '1514342041', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('51', '2905', 'admin', '1514342182', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('52', '2900', 'admin', '1514343191', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('53', '2896', 'admin', '1514343696', '综合初级（试用）', '1514217600', '1514390400', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('54', '2896', 'admin', '1514343706', '综合初级（试用）', '1514217600', '1514390400', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('55', '2896', 'admin', '1514343722', '综合初级（试用）', '1514217600', '1514390400', null, null, '1', '123456', null, null);
INSERT INTO `sys_vipoperation` VALUES ('56', '2910', 'admin', '1514353741', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为admin)');
INSERT INTO `sys_vipoperation` VALUES ('57', '1929', 'admin', '1514355147', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('58', '1929', 'admin', '1514356898', '综合初级（试用）', '1514217600', '1514390400', null, null, '1', 'test', null, null);
INSERT INTO `sys_vipoperation` VALUES ('59', '1929', 'admin', '1514356923', null, null, null, null, null, '6', '不需要了', null, null);
INSERT INTO `sys_vipoperation` VALUES ('60', '1929', 'admin', '1514356941', null, null, null, null, null, '7', '又想用了', null, null);
INSERT INTO `sys_vipoperation` VALUES ('61', '1929', 'admin', '1514356962', null, null, null, null, null, '4', '还是不想要', null, null);
INSERT INTO `sys_vipoperation` VALUES ('62', '2833', 'admin', '1514357744', null, null, null, '1513094400', '1514476800', '3', 'dsafdsaf', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('63', '1929', 'admin', '1514358010', '综合初级（试用）', '1514217600', '1514390400', null, null, '1', 'test', null, null);
INSERT INTO `sys_vipoperation` VALUES ('64', '1929', 'admin', '1514358049', null, null, null, '1512057600', '1514217600', '3', '', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('65', '2905', 'admin', '1514358643', null, null, null, null, null, '6', 'fdsfds', null, null);
INSERT INTO `sys_vipoperation` VALUES ('66', '2910', 'admin', '1514359250', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('67', '2910', 'admin', '1514359429', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为admin)');
INSERT INTO `sys_vipoperation` VALUES ('68', '2910', 'admin', '1514359514', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('69', '2910', 'admin', '1514359704', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为admin)');
INSERT INTO `sys_vipoperation` VALUES ('70', '2832', 'admin', '1514363669', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('71', '2910', 'admin', '1514364270', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('72', '2910', 'admin', '1514364356', null, null, null, null, null, null, null, null, '负责人变更(由蒋大哥变更为admin)');
INSERT INTO `sys_vipoperation` VALUES ('73', '2334', 'admin', '1514364360', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('74', '2334', 'admin', '1514364413', null, null, null, null, null, '7', 'df gdfgh', null, null);
INSERT INTO `sys_vipoperation` VALUES ('75', '2333', 'admin', '1514421416', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('76', '1919', 'admin', '1514423436', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('77', '1919', 'admin', '1514423465', '综合初级（试用）', '1514044800', '1514304000', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('78', '1919', 'admin', '1514423488', null, null, null, null, null, '6', '不需要了', null, null);
INSERT INTO `sys_vipoperation` VALUES ('79', '1919', 'admin', '1514423505', null, null, null, null, null, '7', '又想用了', null, null);
INSERT INTO `sys_vipoperation` VALUES ('80', '1919', 'admin', '1514423519', null, null, null, null, null, '4', '111', null, null);
INSERT INTO `sys_vipoperation` VALUES ('81', '1919', 'admin', '1514423545', null, null, null, '1512057600', '1513008000', '3', '123456', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('82', '1919', 'admin', '1514423579', null, null, null, null, null, null, null, null, '负责人变更(由admin变更为蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('83', '2908', 'admin', '1514423747', null, null, null, '1512057600', '1514131200', '3', '123456', '综合初级', null);
INSERT INTO `sys_vipoperation` VALUES ('84', '2900', 'admin', '1514423783', '综合高级（试用）', '1513180800', '1514304000', null, null, '1', '111', null, null);
INSERT INTO `sys_vipoperation` VALUES ('85', '2900', 'admin', '1514423833', null, null, null, null, null, '7', '1234', null, null);
INSERT INTO `sys_vipoperation` VALUES ('86', '2895', 'admin', '1514424090', '综合初级（试用）', '1514390400', '1514390400', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('87', '2910', 'admin', '1514424253', null, null, null, null, null, '6', '看见过和结果fdef', null, null);
INSERT INTO `sys_vipoperation` VALUES ('88', '2910', 'admin', '1514424274', null, null, null, null, null, '4', 'sadfs f sdf sdsdafdsafg', null, null);
INSERT INTO `sys_vipoperation` VALUES ('89', '2910', 'admin', '1514424553', null, null, null, null, null, '7', '1dsfsf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('90', '2910', 'admin', '1514424559', null, null, null, null, null, '7', '1dsfsf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('91', '2910', 'admin', '1514424564', null, null, null, null, null, '7', '1dsfsf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('92', '2910', 'admin', '1514424569', null, null, null, null, null, '7', '1dsfsf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('93', '2910', 'admin', '1514424723', null, null, null, null, null, '4', 'sadfs f sdf sdsfrsddafdsafg', null, null);
INSERT INTO `sys_vipoperation` VALUES ('94', '2332', 'admin', '1514424734', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('95', '2910', 'admin', '1514424738', null, null, null, null, null, '6', '看见过和结果fdefsdfsdf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('96', '2910', 'admin', '1514424753', '综合特级（试用）', '1514304000', '1514563200', null, null, '1', '123213', null, null);
INSERT INTO `sys_vipoperation` VALUES ('97', '2910', null, '1515637398', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给郭浩)');
INSERT INTO `sys_vipoperation` VALUES ('98', '2910', 'admin', '1515637474', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给郭浩SB)');
INSERT INTO `sys_vipoperation` VALUES ('99', '2910', 'admin', '1515638291', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('100', '1939', 'admin', '1515640405', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('101', '2910', 'admin', '1515641880', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('102', '1930', 'admin', '1515642431', null, null, null, null, null, '5', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('103', '1918', 'admin', '1515642967', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('104', '1918', 'admin', '1515643042', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('105', '1918', 'admin', '1515643095', null, null, null, null, null, null, '似懂非懂是', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('106', '1918', 'admin', '1515643172', null, null, null, null, null, null, '阿萨德萨达啊', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('107', '1918', 'admin', '1515646773', null, null, null, null, null, null, 'fdsfsd fsdf sdf', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('108', '1917', 'admin', '1515655782', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('109', '1871', 'admin', '1515655789', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('110', '1840', 'admin', '1515655855', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('111', '1468', 'admin', '1515655862', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('112', '2909', 'yang1993', '1515656699', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('113', '2907', 'yang1993', '1515656809', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('114', '2906', 'yang1993', '1515656872', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('115', '2902', 'yang1993', '1515657371', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('116', '2905', 'yang1993', '1515657379', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('117', '2899', 'yang1993', '1515657421', null, null, null, null, null, null, '', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('118', '2910', 'admin', '1515719137', null, null, null, null, null, '6', '看见过和结果fdefsdfsdf', null, null);
INSERT INTO `sys_vipoperation` VALUES ('119', '1841', 'admin', '1515719838', null, null, null, null, null, null, '测试', null, '负责人分配：(由admin分配给郭翔)');
INSERT INTO `sys_vipoperation` VALUES ('120', '1918', 'admin', '1515720428', null, null, null, null, null, null, '测试', null, '负责人分配：(由admin分配给郭翔)');
INSERT INTO `sys_vipoperation` VALUES ('121', '1918', '郭翔', '1515721426', '综合初级（试用）', '1515686400', '1515772800', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('122', '1918', '郭翔', '1515721459', null, null, null, null, null, '6', '测试', null, null);
INSERT INTO `sys_vipoperation` VALUES ('123', '1918', '郭翔', '1515721466', null, null, null, null, null, '7', '测试', null, null);
INSERT INTO `sys_vipoperation` VALUES ('124', '1918', '郭翔', '1515721484', null, null, null, null, null, '4', '测试', null, null);
INSERT INTO `sys_vipoperation` VALUES ('125', '2909', '郭翔', '1515721788', null, null, null, null, null, null, '测试', null, '负责人分配：(由郭翔分配给郭浩)');
INSERT INTO `sys_vipoperation` VALUES ('126', '1841', '郭翔', '1515721975', null, null, null, null, null, '7', '测试', null, null);
INSERT INTO `sys_vipoperation` VALUES ('127', '2909', 'yang1993', '1515722135', null, null, null, null, null, null, '测试', null, '负责人分配：(由yang1993分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('128', '2909', 'yang1993', '1515722230', null, null, null, null, null, '7', '1', null, null);
INSERT INTO `sys_vipoperation` VALUES ('129', '2901', 'admin', '1515725918', null, null, null, null, null, '7', 'asdsadsa', null, null);
INSERT INTO `sys_vipoperation` VALUES ('130', '2897', 'admin', '1515727474', null, null, null, null, null, '7', '测得额跟进', null, null);
INSERT INTO `sys_vipoperation` VALUES ('131', '2907', 'admin', '1515727613', '综合初级（试用）', '1497456000', '1497456000', null, null, '1', '测试1;', null, null);
INSERT INTO `sys_vipoperation` VALUES ('132', '2907', 'admin', '1515727620', null, null, null, null, null, '7', '1', null, null);
INSERT INTO `sys_vipoperation` VALUES ('133', '2901', 'admin', '1515728067', null, null, null, null, null, '7', 'asdsadsa水电费', null, null);
INSERT INTO `sys_vipoperation` VALUES ('134', '2909', 'admin', '1515728115', null, null, null, null, null, '7', '2', null, null);
INSERT INTO `sys_vipoperation` VALUES ('135', '2909', 'admin', '1515728122', null, null, null, null, null, '7', '3', null, null);
INSERT INTO `sys_vipoperation` VALUES ('136', '2909', 'yang1993', '1515739291', null, null, null, null, null, '7', '666', null, null);
INSERT INTO `sys_vipoperation` VALUES ('137', '2902', 'yang1993', '1515739322', '综合初级（试用）', '1509465600', '1509638400', null, null, '1', '111', null, null);
INSERT INTO `sys_vipoperation` VALUES ('138', '2902', 'yang1993', '1515739342', null, null, null, null, null, '7', '11111', null, null);
INSERT INTO `sys_vipoperation` VALUES ('139', '2902', 'yang1993', '1515739348', null, null, null, null, null, '7', '666', null, null);
INSERT INTO `sys_vipoperation` VALUES ('140', '2902', 'yang1993', '1515739354', null, null, null, null, null, '7', '555', null, null);
INSERT INTO `sys_vipoperation` VALUES ('141', '2893', 'admin', '1515978373', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('142', '1839', 'admin', '1515978422', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('143', '2906', 'admin', '1515978593', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('144', '2906', 'admin', '1515978803', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给郭翔)');
INSERT INTO `sys_vipoperation` VALUES ('145', '1838', 'admin', '1515978844', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给yang1993)');
INSERT INTO `sys_vipoperation` VALUES ('146', '2904', 'admin', '1515979658', null, null, null, null, null, null, '', null, '负责人分配：(由admin分配给蒋大哥)');
INSERT INTO `sys_vipoperation` VALUES ('147', '21413', 'administrator', '1537233626', null, null, null, null, null, null, null, null, '负责人分配：(由administrator分配给郭六娃)');
INSERT INTO `sys_vipoperation` VALUES ('148', '21413', 'administrator', '1537233772', null, null, null, null, null, null, null, null, '负责人分配：(由administrator分配给郭大娃)');
INSERT INTO `sys_vipoperation` VALUES ('149', '21413', 'administrator', '1537233892', null, null, null, null, null, null, null, null, '负责人分配：(由administrator分配给田娟)');
INSERT INTO `sys_vipoperation` VALUES ('150', '21413', 'administrator', '1537239304', '1', '0', '0', null, null, '1', '试用', null, null);
INSERT INTO `sys_vipoperation` VALUES ('151', '21413', 'administrator', '1537249171', null, null, null, '1525449600', '1580572800', '3', '签约', '5', null);
INSERT INTO `sys_vipoperation` VALUES ('152', '21413', '超级管理员', '1539768551', null, null, null, null, null, null, null, null, '负责人分配：(由超级管理员分配给wq)');
INSERT INTO `sys_vipoperation` VALUES ('153', '21414', '超级管理员', '1539770168', null, null, null, null, null, null, null, null, '负责人分配：(由超级管理员分配给郭大娃)');
INSERT INTO `sys_vipoperation` VALUES ('154', '21415', '超级管理员', '1539770345', null, null, null, null, null, null, null, null, '负责人分配：(由超级管理员分配给超级管理员)');
INSERT INTO `sys_vipoperation` VALUES ('155', '21415', '超级管理员', '1539770370', null, null, null, null, null, '5', 'test', null, null);
INSERT INTO `sys_vipoperation` VALUES ('156', '21415', '超级管理员', '1539770429', null, null, null, null, null, '7', 'ces ', null, null);
INSERT INTO `sys_vipoperation` VALUES ('157', '21415', '超级管理员', '1539770448', '5', '1539835248', '0', null, null, '1', '', null, null);
INSERT INTO `sys_vipoperation` VALUES ('158', '21415', '超级管理员', '1539770471', null, null, null, null, null, '4', '拒绝', null, null);

-- ----------------------------
-- Table structure for sys_viptrial
-- ----------------------------
DROP TABLE IF EXISTS `sys_viptrial`;
CREATE TABLE `sys_viptrial` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `zhanghu` varchar(100) DEFAULT NULL COMMENT '账户',
  `name` varchar(80) DEFAULT '' COMMENT '姓名',
  `company` varchar(200) DEFAULT '' COMMENT '公司',
  `branch` varchar(200) DEFAULT '' COMMENT '部门',
  `position` varchar(200) DEFAULT '' COMMENT '职位',
  `email` varchar(70) DEFAULT '' COMMENT 'Email',
  `phone` varchar(20) DEFAULT '' COMMENT '电话',
  `qq` varchar(20) DEFAULT '' COMMENT 'QQ',
  `addtime` varchar(13) DEFAULT '' COMMENT '添加时间',
  `mobile` varchar(15) DEFAULT NULL COMMENT '手机',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `source` varchar(50) DEFAULT NULL COMMENT '来源',
  `status` int(1) DEFAULT '0' COMMENT '1 表示已处理',
  `qystarttime` varchar(13) DEFAULT NULL COMMENT '签约时间开始时间',
  `qyendtime` varchar(13) DEFAULT NULL COMMENT '签约结束时间',
  `beizhu` varchar(300) DEFAULT NULL COMMENT '备注',
  `qyren` varchar(20) DEFAULT NULL COMMENT '签约人',
  `systarttime` varchar(13) DEFAULT NULL COMMENT '试用开始时间',
  `syendtime` varchar(13) DEFAULT NULL COMMENT '试用结束时间',
  `sygrade` varchar(30) DEFAULT NULL COMMENT '试用等级',
  `qygrade` varchar(30) DEFAULT NULL COMMENT '签约等级',
  `type` int(1) DEFAULT '0',
  `beizhu_refuse` varchar(300) DEFAULT NULL COMMENT '拒绝备注',
  `beizhu_sign` varchar(300) DEFAULT NULL COMMENT '签约备注',
  `admintime` varchar(13) DEFAULT NULL COMMENT '后台编辑提交时间',
  `user` varchar(50) DEFAULT NULL COMMENT '操作人',
  `user_operation_time` int(11) DEFAULT NULL COMMENT '操作时间',
  `beizhu_ing` varchar(300) DEFAULT NULL COMMENT '处理中备注信息',
  `beizhu_not` varchar(300) DEFAULT NULL COMMENT '不试用备注信息',
  `beizhu_gj` varchar(300) DEFAULT NULL COMMENT '跟进中 备注信息',
  `fuzeren` varchar(30) DEFAULT NULL COMMENT '负责人',
  `sjzhanghu` varchar(50) DEFAULT NULL COMMENT '实际开通账户',
  `sourcestatus` int(1) NOT NULL DEFAULT '1' COMMENT '来源状态1为PC 2为APP',
  `viptype` tinyint(1) DEFAULT NULL COMMENT '1专，2app，3专+app',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21504 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_viptrial
-- ----------------------------
INSERT INTO `sys_viptrial` VALUES ('21413', '123', '郭浩SB', '郭浩大数据', '专业背锅部', '资深背锅侠', 'guohao@.qq.com', '5942B', '5942B', '', '123123', '重庆', 'QQ群', '3', '1525449600', '1580572800', '试用', '郭浩', '', '', '1', '5', '1', 'sadsad', '签约', 'sadsa', 'dsad', '1539768551', 'dsad', '萨达啊实打实啊萨达的ad撒', 'sadsa', 'dasd', 'sad sa a as', '1', null);
INSERT INTO `sys_viptrial` VALUES ('21414', 'dsafd', 'fsdf', 'sdfsd', 'fsdfsd', 'sdfsdf', 'sdfsdf', '', '', '1537253924', null, 'sdfsdf', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, '1539770168', null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21415', 'guohao123', '郭二娃', '康州大数据', '背锅部门', '资深背锅侠', '583689582@qq.com', '', '', '1537255215', null, '四川简阳', null, '4', null, null, '', null, '1539835248', '', '5', null, '0', '拒绝', null, null, null, '1539770471', 'test', null, 'ces ', null, 'yang', '1', null);
INSERT INTO `sys_viptrial` VALUES ('21416', 'guohao123', '郭二娃', '康州大数据', '背锅部门', '资深背锅侠', '583689582@qq.com', '', '', '1537255266', null, '四川简阳', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21417', 'xiaxia123', '蒋二娃', '康州大数据', '背锅部门', '资深背锅侠', '756846385@qq.com', '', '', '1537256285', null, '四川简阳', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21418', '', '郭二娃', '康州大数据', '背锅部门', '资深背锅侠', '583689582@qq.com', '', '', '1537256543', null, '四川简阳', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21419', 'guohao123', '郭二娃', 'cc', '背锅部门', '资深背锅侠', '583689582@qq.com', '', '', '1537259604', null, 'sdf', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21420', '', '', '', '', '', '', '', '', '1537426446', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21421', '', '', '', '', '', '', '', '', '1537426515', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21422', '', '', '', '', '', '', '', '', '1537426782', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21423', 'asdf', '', '', '', '', 'safd', '', '', '1537426797', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21424', '', '', '', '', '', '', '', '', '1537426805', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21425', '', '', '', '', '', '', '', '', '1537427681', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21426', '', '', '', '', '', '', '', '', '1537427689', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21427', '', '', '', '', '', '', '', '', '1537427701', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21428', '', '', '', '', '', '', '', '', '1537428018', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21429', '', '', '', '', '', '', '', '', '1537428036', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21430', '', '', '', '', '', '', '', '', '1537428071', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21431', '', '', '', '', '', '', '', '', '1537428082', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21432', '', '', '', '', '', '', '', '', '1537428193', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21433', '', '', '', '', '', '', '', '', '1537428264', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21434', '', '', '', '', '', '', '', '', '1537428308', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21435', '', '', '', '', '', '', '', '', '1537428331', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21436', '', '', '', '', '', '', '', '', '1537428342', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21437', '', '', '', '', '', '', '', '', '1537428355', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21438', '', '', '', '', '', '', '', '', '1537430567', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21439', '', '', '', '', '', '', '', '', '1537431051', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21440', '', '', '', '', '', '', '', '', '1537431350', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21441', '', '', '', '', '', '', '', '', '1537431381', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21442', '', '', '', '', '', '', '', '', '1537432002', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21443', '', '', '', '', '', '', '', '', '1537432012', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21444', '', '', '', '', '', '', '', '', '1537432029', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21445', '', '', '', '', '', '', '', '', '1537433002', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21446', '', '', '', '', '', '', '', '', '1537433017', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21447', '', '', '', '', '', '', '', '', '1537433112', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21448', '', '', '', '', '', '', '', '', '1537433161', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21449', '', '', '', '', '', '', '', '', '1537433261', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21450', '', '', '', '', '', '', '', '', '1537433269', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21451', '', '', '', '', '', '', '', '', '1537433300', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21452', '', '', '', '', '', '', '', '', '1537433327', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21453', '', '', '', '', '', '', '', '', '1537433430', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21454', '', '', '', '', '', '', '', '', '1539136810', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21455', '', '', '', '', '', '', '', '', '1539222264', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21456', '', '', '', '', '', '', '', '', '1539327108', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21457', '安安', '', '', '', '', '', '', '', '1539327133', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21458', '', '', '', '', '', '', '', '', '1539327156', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21459', '', '', '', '', '', '', '', '', '1539327222', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21460', 'name', '', '', '', '', '', '', '', '1539327295', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21461', '', '', '', '', '', '25006451顶顶顶顶顶97@qq.com', '', '', '1539327325', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21462', '', '', '', '', '', '', '', '', '1539568304', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21463', '', '', '', '', '', '', '', '', '1539568317', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21464', '', '', '', '', '', '', '', '', '1539570065', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21465', 'as', '', '', '', '', '', '', '', '1539570086', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21466', '', '', '', '', '', '', '', '', '1539570152', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21467', '', '', '', '', '', '', '', '', '1539572165', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21468', '', '', '', '', '', '', '', '', '1539762488', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21469', '', '', '', '', '', '', '', '', '1539762498', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21470', '', '', '', '', '', '', '', '', '1539911030', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21471', '1', '3', '4', '', '', '', '', '', '1539911958', null, '2', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21472', '', '', '', '', '', '', '', '', '1539913170', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21473', '', '', '', '', '', '', '', '', '1539921361', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21474', '', '', '', '', '', '', '', '', '1539940605', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21475', '', '', '', '', '', '', '', '', '1540203254', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21476', '', '', '', '', '', '', '', '', '1540203279', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21477', '', '', '', '', '', '111111111111111111', '', '', '1540203395', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21478', '11', '33', '44', 'qq', '123', 'qq@qq.com', '', '', '1540218453', null, '22', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21479', '111', '333', '444', 'qq', 'qqq', 'qq@qq.com', '', '', '1540218517', null, '222', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21480', '01', '03', '04', 'qq', 'qqw', 'qq@qqq.com', '', '', '1540218818', null, '02', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21481', '123', '123', '123', '176', 'tt', '166@163.com', '', '', '1540219230', null, '123', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21482', '', '', '', '', '', '', '', '', '1540219308', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21483', '', '', '', '', '', '', '', '', '1540219335', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21484', '', '', '', '', '', '', '', '', '1540219470', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21485', '啊', '', '', '', '', '', '', '', '1540220530', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21486', '啊', '', '', '', '', '', '', '', '1540220905', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21487', '1', '3', '4', '121', '123', '123@qq.com', '', '', '1540222080', null, '2', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21488', '1', '3', '4', '1', '1', '1@qq.com', '', '', '1540223231', null, '2', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21489', '', '', '', '', '', '', '', '', '1540223295', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21490', '1', '3', '4', '176', '1', '1@qq.com', '', '', '1540263000', null, '2', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21491', '', '', '', '', '', '', '', '', '1540279251', null, '', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21492', 'name', '搞搞搞', '西安万隆制药有限责任公司', '放大', '发啊', '2500645197@qq.com', '', '', '1540534039', null, '放到f', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21493', '1', '123', '3', '1', '123', '123@qq.com', '', '', '1540881839', null, '3', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21494', '12', '12', '12', '13', '14', '11@qq.com', '', '', '1540886520', null, '12', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21495', '1', '12', '12', '13', '14', '11@qq.com', '', '', '1540886555', null, '12', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21496', '123', '123', '123', '123', '123', '123@qq.com', '', '', '1540887585', null, '123', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21497', '插死', '郭翔', '打完', '带娃', '大', '109302@qq.com', '', '', '1540891897', null, '生栋覆屋2', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21498', '123', '789', '000', '88', '88', '99@qq.com', '', '', '1541121600', null, '456', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21499', '123', '789', '000', '88', '88', '99@qq.com', '', '', '1541122163', null, '456', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21500', 'test', 'test', 'test', 'test', 'test', 'test@qq.com', '', '', '1541148676', null, 'test', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21501', 'test', 'test', 'test', 'test', 'test', 'test@qq.com', '', '', '1541148833', null, 'test', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21502', 'test', 'test', 'test', 'test', 'test', 'test@qq.com', '', '', '1541148843', null, 'test', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);
INSERT INTO `sys_viptrial` VALUES ('21503', 'ad阿达', '啊', '舒服点', '发送的', '说', '1324378@qq.com', '', '', '1541387294', null, '温柔', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '1', null);

-- ----------------------------
-- Table structure for sys_viptrial_app
-- ----------------------------
DROP TABLE IF EXISTS `sys_viptrial_app`;
CREATE TABLE `sys_viptrial_app` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `zhanghu` varchar(100) DEFAULT NULL COMMENT '账户',
  `name` varchar(80) DEFAULT '' COMMENT '姓名',
  `company` varchar(200) DEFAULT '' COMMENT '公司',
  `branch` varchar(200) DEFAULT '' COMMENT '部门',
  `position` varchar(200) DEFAULT '' COMMENT '职位',
  `email` varchar(70) DEFAULT '' COMMENT 'Email',
  `phone` varchar(20) DEFAULT '' COMMENT '电话',
  `qq` varchar(20) DEFAULT '' COMMENT 'QQ',
  `addtime` varchar(13) DEFAULT '' COMMENT '添加时间',
  `mobile` varchar(15) DEFAULT NULL COMMENT '手机',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `source` varchar(50) DEFAULT NULL COMMENT '来源',
  `status` int(1) DEFAULT '0' COMMENT '1 表示已处理',
  `qystarttime` varchar(13) DEFAULT NULL COMMENT '签约时间开始时间',
  `qyendtime` varchar(13) DEFAULT NULL COMMENT '签约结束时间',
  `beizhu` varchar(300) DEFAULT NULL COMMENT '备注',
  `qyren` varchar(20) DEFAULT NULL COMMENT '签约人',
  `systarttime` varchar(13) DEFAULT NULL COMMENT '试用开始时间',
  `syendtime` varchar(13) DEFAULT NULL COMMENT '试用结束时间',
  `sygrade` varchar(30) DEFAULT NULL COMMENT '试用等级',
  `qygrade` varchar(30) DEFAULT NULL COMMENT '签约等级',
  `type` int(1) DEFAULT '0',
  `beizhu_refuse` varchar(300) DEFAULT NULL COMMENT '拒绝备注',
  `beizhu_sign` varchar(300) DEFAULT NULL COMMENT '签约备注',
  `admintime` varchar(13) DEFAULT NULL COMMENT '后台编辑提交时间',
  `user` varchar(50) DEFAULT NULL COMMENT '操作人',
  `user_operation_time` int(11) DEFAULT NULL COMMENT '操作时间',
  `beizhu_ing` varchar(300) DEFAULT NULL COMMENT '处理中备注信息',
  `beizhu_not` varchar(300) DEFAULT NULL COMMENT '不试用备注信息',
  `beizhu_gj` varchar(300) DEFAULT NULL COMMENT '跟进中 备注信息',
  `fuzeren` varchar(30) DEFAULT NULL COMMENT '负责人',
  `sjzhanghu` varchar(50) DEFAULT NULL COMMENT '实际开通账户',
  `sourcestatus` int(1) NOT NULL DEFAULT '2' COMMENT '来源状态1为PC 2为APP',
  `viptype` tinyint(1) DEFAULT NULL COMMENT '1专业版，2app，3专业版+app',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_viptrial_app
-- ----------------------------
INSERT INTO `sys_viptrial_app` VALUES ('1', '撒的发生的', '撒地方', '撒地方', '阿斯蒂芬', '撒地方', '阿斯蒂芬', '阿斯蒂芬', '', '1538979225', '阿斯蒂芬', 'a撒地方', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', null);
INSERT INTO `sys_viptrial_app` VALUES ('2', '撒地方', '撒地方', '撒地方', '阿斯蒂芬 ', '阿斯蒂芬', '阿斯蒂芬', '阿斯蒂芬', '', '1538979634', '撒地方', '阿斯蒂芬', null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', null);
INSERT INTO `sys_viptrial_app` VALUES ('3', null, '', '', '', '', '', '', '', '1540278559', null, null, null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', '3');
INSERT INTO `sys_viptrial_app` VALUES ('4', null, '', '', '', '', '', '', '', '1540280246', null, null, null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', '3');
INSERT INTO `sys_viptrial_app` VALUES ('5', null, '', '', '', '', '', '', '', '1540280256', null, null, null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', '3');
INSERT INTO `sys_viptrial_app` VALUES ('6', null, '', '', '', '', '', '', '', '1540280429', null, null, null, '0', null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, '2', '2');
