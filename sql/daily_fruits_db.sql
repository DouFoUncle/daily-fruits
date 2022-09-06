/*
 Navicat Premium Data Transfer

 Source Server         : 腾讯云
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : 106.53.73.30:3306
 Source Schema         : daily_fruits_db

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 21/03/2021 17:25:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ----------------------------
-- Table structure for t_goods_type
-- ----------------------------
DROP TABLE IF EXISTS `t_goods_type`;
CREATE TABLE `t_goods_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键自增',
  `type_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型名',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `is_delete` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '是否删除 0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_goods_type
-- ----------------------------
INSERT INTO `t_goods_type` VALUES (1, '蔬菜', '2021-02-10 11:09:56', '0');
INSERT INTO `t_goods_type` VALUES (2, '肉禽蛋', '2021-02-10 11:10:06', '0');
INSERT INTO `t_goods_type` VALUES (3, '水果', '2021-02-10 11:10:16', '0');
INSERT INTO `t_goods_type` VALUES (4, '海鲜', '2021-02-10 11:10:39', '0');
INSERT INTO `t_goods_type` VALUES (5, '粮油调味', '2021-02-10 11:12:02', '0');
INSERT INTO `t_goods_type` VALUES (6, '其他', '2021-02-10 11:14:33', '0');
INSERT INTO `t_goods_type` VALUES (7, '234', '2021-02-25 13:36:31', '1');

-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_menu`;
CREATE TABLE `t_menu`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父菜单ID',
  `menu_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名',
  `url` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转地址',
  `icon_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标名',
  `menu_position` int(0) NULL DEFAULT NULL COMMENT '菜单位置，该字段控制菜单的展示顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_menu
-- ----------------------------
INSERT INTO `t_menu` VALUES (1, NULL, '用户管理', '../user/toDataPage', '&#xe6b8;', 1);
INSERT INTO `t_menu` VALUES (2, NULL, '收货地址管理', '../address/toDataPage', '&#xe811;', 2);
INSERT INTO `t_menu` VALUES (3, NULL, '果蔬管理', '../goods/toDataPage', '&#xe6af;', 4);
INSERT INTO `t_menu` VALUES (9, 7, '表格统计', '../sale/toDataTablePage', '&#xe6bf;', 8);
INSERT INTO `t_menu` VALUES (10, 7, '图表统计', '../sale/toDataChartPage', '&#xe6b3;', 9);
INSERT INTO `t_menu` VALUES (4, NULL, '货单管理', '../purchase/toDataPage', '&#xe6fc;', 5);
INSERT INTO `t_menu` VALUES (7, NULL, '销售报表', NULL, '&#xe724;', 7);
INSERT INTO `t_menu` VALUES (6, NULL, '订单管理', '../order/toDataPage', '&#xe702;', 6);
INSERT INTO `t_menu` VALUES (8, NULL, '管理员列表', '../admin/toDataPage', '&#xe726;', 10);
INSERT INTO `t_menu` VALUES (56, NULL, '类型管理', '../goodsType/toDataPage', '&#xe6b4;', 3);

-- ----------------------------
-- Table structure for t_menu_admin_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_admin_relation`;
CREATE TABLE `t_menu_admin_relation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '管理员ID',
  `menu_id` int(0) NULL DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单与管理员管理表' ROW_FORMAT = Fixed;



-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `order_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手动生层的订单号',
  `order_price` int(0) NULL DEFAULT NULL COMMENT '订单价格（单位分）',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '对应的用户ID',
  `address_id` int(0) NULL DEFAULT NULL COMMENT '对应的收货地址ID',
  `user_nick_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `address_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '下单时间',
  `address_json_str` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保存地址的JSON串备份',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_order
-- ----------------------------
INSERT INTO `t_order` VALUES (1, '20210207182648483', 1800, 1, 1, '孙悟空', '斗战胜佛', '2021-02-07 18:29:15', '{\"addressName\":\"斗战胜佛\",\"addressShort\":\"北京市东城区景山街道钱粮胡同3号\",\"cityNum\":\"110100\",\"countyNum\":\"110101\",\"id\":1,\"isDefault\":\"1\",\"phone\":\"13555669988\",\"provinceNum\":\"110000\",\"userId\":1,\"userInfo\":{\"id\":1,\"nickName\":\"孙悟空\",\"userEmail\":\"943701114@qq.com\"}}');
INSERT INTO `t_order` VALUES (2, '202102261603541801', 1801, 3, 2, '孙悟天', '悟天克斯', '2021-02-26 16:03:54', '{\"addressName\":\"悟天克斯\",\"addressShort\":\"北京市东城区景山街道钱粮胡同3号\",\"id\":2,\"phone\":\"13555669988\"}');
INSERT INTO `t_order` VALUES (3, '202102261822041778', 1778, 3, 4, '孙悟天', '悟天', '2021-02-26 18:22:04', '{\"addressName\":\"悟天\",\"addressShort\":\"山西省运城市盐湖区涑水街179号\",\"id\":4,\"phone\":\"15566778899\"}');
INSERT INTO `t_order` VALUES (4, '20210226193613851', 851, 3, 4, '孙悟天', '悟天', '2021-02-26 19:36:13', '{\"addressName\":\"悟天\",\"addressShort\":\"山西省运城市盐湖区涑水街179号\",\"id\":4,\"phone\":\"15566778899\"}');

-- ----------------------------
-- Table structure for t_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_order_detail`;
CREATE TABLE `t_order_detail`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `order_id` int(0) NULL DEFAULT NULL COMMENT '对应的订单号',
  `goods_id` int(0) NULL DEFAULT NULL COMMENT '对应的下单商品ID',
  `goods_num` int(0) NULL DEFAULT NULL COMMENT '下单数量',
  `total_price` int(0) NULL DEFAULT NULL COMMENT '小计',
  `goods_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名',
  `goods_price` int(0) NULL DEFAULT NULL COMMENT '商品单价',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_order_detail
-- ----------------------------
INSERT INTO `t_order_detail` VALUES (1, 1, 1, 2, 1300, '白菜 约1kg/份', 650);
INSERT INTO `t_order_detail` VALUES (2, 1, 2, 1, 500, '白菜仔 约300g/份', 500);
INSERT INTO `t_order_detail` VALUES (3, 2, 1, 2, 1300, '白菜 约1kg/份', 650);
INSERT INTO `t_order_detail` VALUES (4, 2, 2, 1, 500, '白菜仔 约300g/份', 500);
INSERT INTO `t_order_detail` VALUES (5, 2, 4, 1, 1, '测试商品', 1);
INSERT INTO `t_order_detail` VALUES (6, 3, 3, 1, 350, '杭白菜 约280g/份', 350);
INSERT INTO `t_order_detail` VALUES (7, 3, 11, 1, 899, '甜玉米 约600g', 899);
INSERT INTO `t_order_detail` VALUES (8, 3, 13, 1, 529, '土豆（黄心） 约1kg', 529);
INSERT INTO `t_order_detail` VALUES (9, 4, 3, 1, 350, '杭白菜 约280g/份', 350);
INSERT INTO `t_order_detail` VALUES (10, 4, 2, 1, 500, '白菜仔 约300g/份', 500);
INSERT INTO `t_order_detail` VALUES (11, 4, 4, 1, 1, '测试商品', 1);

-- ----------------------------
-- Table structure for t_purchase
-- ----------------------------
DROP TABLE IF EXISTS `t_purchase`;
CREATE TABLE `t_purchase`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `purchase_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手动生成的货单号',
  `purchase_price` int(0) NULL DEFAULT NULL COMMENT '货单总价',
  `purchase_status` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态( 0未收货  1已收货  2未确认下单 )',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `purchase_date` datetime(0) NULL DEFAULT NULL COMMENT '确认下单时间',
  `cancel_date` datetime(0) NULL DEFAULT NULL COMMENT '取消货单的时间',
  `confirm_date` datetime(0) NULL DEFAULT NULL COMMENT '确认收货的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '货单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_purchase
-- ----------------------------
INSERT INTO `t_purchase` VALUES (1, '20210123073400', 2750, '1', '2021-01-23 19:34:00', '2021-02-26 16:05:13', NULL, '2021-02-26 16:05:19');
INSERT INTO `t_purchase` VALUES (2, '20210123073401', 20000, '3', '2021-01-23 19:34:01', NULL, '2021-02-04 12:00:49', NULL);
INSERT INTO `t_purchase` VALUES (6, '20210128140002', 2750, '1', '2021-01-28 14:00:02', '2021-02-05 10:13:40', NULL, '2021-02-05 10:13:49');

-- ----------------------------
-- Table structure for t_purchase_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_purchase_detail`;
CREATE TABLE `t_purchase_detail`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '采购ID',
  `purchase_id` int(0) NULL DEFAULT NULL COMMENT '对应的货单ID',
  `goods_id` int(0) NULL DEFAULT NULL COMMENT '商品ID',
  `purchase_price` int(0) NULL DEFAULT NULL COMMENT '采购单价（单位分）',
  `count` int(0) NULL DEFAULT NULL COMMENT '数量',
  `purchase_date` datetime(0) NULL DEFAULT NULL COMMENT '采购日期',
  `total_price` int(0) NULL DEFAULT NULL COMMENT '总价（单位分）',
  `goods_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '进货明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_purchase_detail
-- ----------------------------
INSERT INTO `t_purchase_detail` VALUES (3, 2, 3, 300, 200, '2021-01-23 19:34:01', 60000, '白菜 约1kg/份');
INSERT INTO `t_purchase_detail` VALUES (4, 6, 1, 300, 5, '2021-01-28 14:00:02', 1500, '白菜 约1kg/份');
INSERT INTO `t_purchase_detail` VALUES (5, 6, 2, 250, 5, '2021-01-28 14:00:02', 1250, '白菜仔 约300g/份');
INSERT INTO `t_purchase_detail` VALUES (23, 1, 1, 300, 5, '2021-02-04 17:09:21', 1500, '白菜 约1kg/份');
INSERT INTO `t_purchase_detail` VALUES (29, 1, 2, 250, 5, '2021-02-04 17:16:23', 1250, '白菜仔 约300g/份');

-- ----------------------------
-- Table structure for t_sale
-- ----------------------------
DROP TABLE IF EXISTS `t_sale`;
CREATE TABLE `t_sale`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `sale_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售类型',
  `sale_type_flag` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售标记（0支出，1收入）',
  `sale_price` int(0) NULL DEFAULT NULL COMMENT '销售金额',
  `sale_date` datetime(0) NULL DEFAULT NULL COMMENT '销售时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '营业销售记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sale
-- ----------------------------
INSERT INTO `t_sale` VALUES (1, '进货', '0', 2750, '2021-02-05 10:13:51');
INSERT INTO `t_sale` VALUES (2, '进货', '0', 8500, '2021-02-05 13:59:04');
INSERT INTO `t_sale` VALUES (3, '销售', '1', 1800, '2021-02-07 18:29:15');
INSERT INTO `t_sale` VALUES (4, '销售', '1', 1801, '2021-02-26 16:03:54');
INSERT INTO `t_sale` VALUES (5, '进货', '0', 2750, '2021-02-26 16:05:19');
INSERT INTO `t_sale` VALUES (6, '销售', '1', 1778, '2021-02-26 18:22:04');
INSERT INTO `t_sale` VALUES (7, '销售', '1', 851, '2021-02-26 19:36:13');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_email` varchar(320) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户登录邮箱',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'MD5+密码sha256+盐值sha1+盐值混合加密',
  `salt` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '盐值（UUID）',
  `nick_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `user_status` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户状态：1已冻结  0正常',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '用户注册时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, '943701115@qq.com', '67258b4e6bdea9d4d1a81babadf59c17', 'fcea8be9-2ab2-44f8-b52d-ef688a0bddbb', '孙悟空', '0', '2020-12-20 23:05:46');
INSERT INTO `t_user` VALUES (3, '943701114@qq.com', '8ff0b5e323d35d6e2a10fa828bb8d902', '29680de4-94e6-4bd4-be31-780b4ce60ad3', '孙悟天', '0', '2021-02-21 17:43:32');
INSERT INTO `t_user` VALUES (4, '1244311531@qq.com', 'adbc7d12aefdc682a8ec3d9412ef9b44', '1fcf4615-dc20-40af-a072-3ed3feef35e2', 'xxx', '0', '2021-03-01 23:05:36');

SET FOREIGN_KEY_CHECKS = 1;
