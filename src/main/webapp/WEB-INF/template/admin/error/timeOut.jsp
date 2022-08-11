<%@ page import="priv.fruits.util.ServletUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="<%= ServletUtils.getProjectHttpUrl(request)%>/lib/layui/css/layui.css">
    <script src="<%= ServletUtils.getProjectHttpUrl(request)%>/lib/layui/layui.js"></script>
    <script src="<%= ServletUtils.getProjectHttpUrl(request)%>/js/jquery.min.js"></script>
    <script src="<%= ServletUtils.getProjectHttpUrl(request)%>/js/MyLayuiUtils.js"></script>

    <style type="text/css">
        html {
            height: 100%;
        }
    </style>
</head>
<body style="height: 100%;box-sizing: border-box;margin: 0;padding: 0;">
    <div style="height: 100%">

    </div>
    <script type="text/javascript">
        layui.use(['layer'], function () {

            var layer = layui.layer;

            layer.msg('未检测到登录状态…正在前往登录页面…', {
                icon: 5,
                time: 1500,
                shade: .2,
                end: function () {
                    if (window != top){
                        top.location.href=getPath()+"/system/toAdminLoginPage";
                        return;
                    }
                    window.location.href=getPath()+"/system/toAdminLoginPage";
                }
            });
        })
    </script>
</body>
</html>