<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html  class="x-admin-sm">
<head>
	<meta charset="UTF-8">
	<title>果蔬超市</title>
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/login.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
</head>
<body class="login-bg">
    
    <div class="login layui-anim layui-anim-up">
        <div class="message">果蔬超市后台系统</div>
        <div id="darkbannerwrap"></div>
        
        <form method="post" class="layui-form" action="adminLogin">
            <input name="userName" placeholder="用户名"  type="text" lay-verify="required" class="layui-input" >
            <hr class="hr15">
            <input name="password" lay-verify="required" placeholder="密码"  type="password" class="layui-input">
            <hr class="hr15">
            <c:if test="${sessionScope.msg != null}">
                <p style="color: red; text-align: center; font-size: 14px; margin-bottom: 15px">${sessionScope.msg}</p>
            </c:if>
            <input value="登录" lay-submit lay-filter="login" style="width:100%;" type="submit">
            <input value="返回首页" style="width:100%;margin-top: 15px" type="button" onclick="window.location.href = '../webSystem/toWebIndexPage'">
            <hr class="hr20" >
        </form>
    </div>
</body>
</html>