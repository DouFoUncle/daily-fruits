<%--
  Created by IntelliJ IDEA.
  User: byqs
  Date: 2022/2/20
  Time: 11:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>果蔬超市</title>
</head>
<body>
<div class="topbar">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="topbar-text">
                    <span>工作时间：周一 &nbsp;至&nbsp; 周五&nbsp;:&nbsp; 06AM - 06PM</span>
                    <span>周六 &nbsp;至&nbsp; 周日&nbsp;:&nbsp; 08AM - 06PM</span>
                </div>
            </div>
            <div class="col-md-6">
                <div class="topbar-menu">
                    <ul class="topbar-menu">
                        <c:if test="${sessionScope.webUserInfo == null}">
                            <li><a href="../webSystem/toLoginPage/login">登陆</a></li>
                            <li><a href="../webSystem/toLoginPage/register">注册</a></li>
                        </c:if>
                        <c:if test="${sessionScope.webUserInfo != null}">
                            <li><i class="fa fa-user"></i>&nbsp;&nbsp;
                                <a href="javascript:;">欢迎您：${sessionScope.webUserInfo.nickName}</a>
                            </li>
                            <li><a href="javascript:;" id="loginOutBtn">退出</a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script src="../lib/layui/layui.js" charset="utf-8"></script>
<script>
    layui.use(['layer'], function() {
        let layer = layui.layer
            $ = layui.jquery;

        $(function() {

            // 退出按钮绑定单机事件
            $("#loginOutBtn").click(function() {
                $.getJSON(
                    "../webUser/loginOut",
                    function(res) {
                        layer.msg(res.msg, {
                            timer: 1000,
                            end: function() {
                                // 刷新页面
                                window.location.reload();
                            }
                        })
                    }
                )
            })
        })
    })
</script>
</html>
