<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html class="x-admin-sm">
    <head>
        <meta charset="UTF-8">
        <title>果蔬超市</title>
        <meta name="renderer" content="webkit|ie-comp|ie-stand">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
        <meta http-equiv="Cache-Contro.l" content="no-siteapp" />
        <link rel="stylesheet" href="../css/font.css">
        <link rel="stylesheet" href="../css/xadmin.css">
        <link rel="stylesheet" href="../css/theme11black_purple.min.css">
        <!-- <link rel="stylesheet" href="./css/theme5.css"> -->
        <script src="../lib/layui/layui.js" charset="utf-8"></script>
        <script type="text/javascript" src="../js/jquery.min.js"></script>
        <script type="text/javascript" src="../js/xadmin.js"></script>
        <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
        <script>
            // 是否开启刷新记忆tab功能
            // var is_remember = false;
        </script>
    </head>
    <body class="index">
        <!-- 顶部开始 -->
        <div class="container">
            <div class="logo">
                <a href="index.jsp">果蔬超市后台管理</a></div>
            <div class="left_open">
                <a><i title="展开左侧栏" class="iconfont">&#xe699;</i></a>
            </div>
            <ul class="layui-nav left fast-add" lay-filter="">
<%--                <li class="layui-nav-item">--%>
<%--                    <a href="javascript:;">+新增</a>--%>
<%--                    <dl class="layui-nav-child">--%>
<%--                        <!-- 二级菜单 -->--%>
<%--                        <dd>--%>
<%--                            <a onclick="xadmin.open('最大化','http://www.baidu.com','','',true)">--%>
<%--                                <i class="iconfont">&#xe6a2;</i>弹出最大化</a></dd>--%>
<%--                        <dd>--%>
<%--                            <a onclick="xadmin.open('弹出自动宽高','http://www.baidu.com')">--%>
<%--                                <i class="iconfont">&#xe6a8;</i>弹出自动宽高</a></dd>--%>
<%--                        <dd>--%>
<%--                            <a onclick="xadmin.open('弹出指定宽高','http://www.baidu.com',500,300)">--%>
<%--                                <i class="iconfont">&#xe6a8;</i>弹出指定宽高</a></dd>--%>
<%--                        <dd>--%>
<%--                            <a onclick="xadmin.add_tab('在tab打开','member-list.html')">--%>
<%--                                <i class="iconfont">&#xe6b8;</i>在tab打开</a></dd>--%>
<%--                        <dd>--%>
<%--                            <a onclick="xadmin.add_tab('在tab打开刷新','member-del.html',true)">--%>
<%--                                <i class="iconfont">&#xe6b8;</i>在tab打开刷新</a></dd>--%>
<%--                    </dl>--%>
<%--                </li>--%>
            </ul>
        </div>
        <!-- 顶部结束 -->

        <!-- 中部开始 -->
        <!-- 左侧菜单开始 -->
        <div class="left-nav">
            <div id="side-nav">
                <ul id="nav">
                    <c:forEach var="item" items="${sessionScope.parentMenu}">
                        <li>
                            <!-- url != null 代表该一级菜单下没有子菜单 -->
                            <c:if test="${item.menu.url != null}">
                                <a href="javascript:;" onclick="xadmin.add_tab('${item.menu.menuName}','${item.menu.url}')">
                                    <i class="left-nav-li iconfont"
                                       lay-tips="${item.menu.menuName}">${item.menu.iconName}</i>
                                    <cite>${item.menu.menuName}</cite><i class="iconfont nav_right">&#xe697;</i>
                                </a>
                            </c:if>
                            <c:if test="${item.menu.url == null}">
                                <!-- url == null 代表该一级菜单下有子菜单 -->
                                <a href="javascript:;">
                                    <i class="left-nav-li iconfont"
                                       lay-tips="${item.menu.menuName}">${item.menu.iconName}</i>
                                    <cite>${item.menu.menuName}</cite><i class="iconfont nav_right">&#xe697;</i>
                                </a>
                                <ul class="sub-menu">
                                    <!-- 循环找出parent_id与当前以及菜单的id一致的自己菜单 -->
                                    <c:forEach var="sub" items="${sessionScope.subMenu}">
                                        <c:if test="${sub.menu.parentId == item.menu.id}">
                                            <li>
                                                <a href="javascript:;" onclick="xadmin.add_tab('${sub.menu.menuName}','${sub.menu.url}')"
                                                   style="padding: 12px 15px 12px 22px">
                                                    <i class="iconfont left-nav-li" lay-tips="${sub.menu.menuName}">${sub.menu.iconName}</i>
                                                    <cite>${sub.menu.menuName}</cite></a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </li>
                    </c:forEach>
                    <li>
                        <a href="javascript:;" id="toUpdatePwd">
                            <i class="iconfont left-nav-li" lay-tips="修改密码">&#xe82b;</i>
                            <cite>修改密码</cite>
                            <i class="iconfont nav_right">&#xe697;</i></a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="window.location.href = getPath() + '/webSystem/toWebIndexPage'">
                            <i class="iconfont left-nav-li" lay-tips="前台首页">&#xe718;</i>
                            <cite>前台首页</cite>
                            <i class="iconfont nav_right">&#xe697;</i></a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="window.location.href = '../system/adminLoginOut'">
                            <i class="iconfont left-nav-li" lay-tips="退出登录">&#xe69c;</i>
                            <cite>退出登录</cite>
                            <i class="iconfont nav_right">&#xe697;</i></a>
                    </li>
                </ul>
            </div>
        </div>
        <!-- <div class="x-slide_left"></div> -->
        <!-- 左侧菜单结束 -->
        <!-- 右侧主体开始 -->
        <div class="page-content">
            <div class="layui-tab tab" lay-filter="xbs_tab" lay-allowclose="false">
                <ul class="layui-tab-title">
                    <li class="home layui-this">
                        <i class="layui-icon">&#xe68e;</i>我的桌面</li></ul>
                <div class="layui-unselect layui-form-select layui-form-selected" id="tab_right">
                    <dl>
                        <dd data-type="this">关闭当前</dd>
                        <dd data-type="other">关闭其它</dd>
                        <dd data-type="all">关闭全部</dd></dl>
                </div>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <iframe src='toWelcomePage' frameborder="0" scrolling="yes" class="x-iframe"></iframe>
                    </div>
                </div>
                <div id="tab_show"></div>
            </div>
        </div>
        <div class="page-content-bg"></div>
        <style id="theme_style"></style>
        <script>
            layui.use(['form'], function() {
                var $ = layui.jquery;

                $("#toUpdatePwd").click(function() {
                    toWindow("../admin/toUpdatePwdWindows", "修改密码", "400px", "300px", true);
                })
            })
        </script>
    </body>
</html>