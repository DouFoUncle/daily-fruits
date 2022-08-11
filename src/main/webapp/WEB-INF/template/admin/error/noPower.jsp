<%@ page import="priv.fruits.util.ServletUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html class="x-admin-sm" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>后台登录-X-admin2.2</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />

    <link rel="stylesheet" href="<%= ServletUtils.getProjectHttpUrl(request)%>/css/font.css">
    <link rel="stylesheet" href="<%= ServletUtils.getProjectHttpUrl(request)%>/css/xadmin.css">
</head>
<body style="padding: 15px; box-sizing: border-box">
<div class="layui-container" style="background-color: #FFF; width: 100%;">
    <div class="fly-panel">
        <div class="fly-none">
            <h2><i class="layui-icon layui-icon-404"></i></h2>
            <p>兄嘚！<a href="javascript:;"> 没有访问该页面的权限哦…… </a></p>
        </div>
    </div>
</div>
<script>
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "https://hm.baidu.com/hm.js?b393d153aeb26b46e9431fabaf0f6190";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
</body>
</html>