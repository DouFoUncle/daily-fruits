<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="utf-8">
    <title>果蔬超市</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css">
    <link rel="stylesheet" href="../../css/web_css/dmaku.css">
    <style>
        body {
            margin: 0;
            padding: 0;
        }
        .title_href:hover {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <input type="hidden" name="type" value="${type}">
    <div class="dowebok" id="dowebok">
        <div class="form-container sign-up-container">
            <form action="#" style="display: none" id="addForm">
                <h2 class="title_href" onclick="window.location.href = '../../webSystem/toWebIndexPage'">果蔬超市</h2>
                <h3 style="margin-top: 0px">注册</h3>
                <input type="text" placeholder="姓名" name="addNickName" autocomplete="off">
                <input type="text" placeholder="电子邮箱" name="addUserEmail" autocomplete="off">
                <input type="password" name="addPassword" placeholder="密码" autocomplete="new-password">
                <input type="text" placeholder="验证码" name="addVerifyCode" autocomplete="off">
                <div>
                    <button style="padding: 12px 26px;" type="button" id="registerSendCode">发送验证码</button>&nbsp;
                    <button type="button" id="registerBtn">注册</button>
                </div>
            </form>
            <form action="#" style="display: none" id="editForm">
                <h2 class="title_href" onclick="window.location.href = '../../webSystem/toWebIndexPage'">果蔬超市</h2>
                <h3 style="margin-top: 0px">忘记密码</h3>
                <input type="text" placeholder="电子邮箱" name="editUserEmail" autocomplete="off">
                <input type="password" name="editPassword" placeholder="设置新密码" autocomplete="new-password">
                <input type="text" placeholder="验证码" name="editVerifyCode" autocomplete="off">
                <div>
                    <button style="padding: 12px 26px;" type="button" id="editSendCode">发送验证码</button>&nbsp;
                    <button style="padding: 12px 32.5px;" id="editPassBtn" type="button">提交修改</button>
                </div>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="#" id="loginForm">
                <h2 class="title_href" onclick="window.location.href = '../../webSystem/toWebIndexPage'">果蔬超市</h2>
                <h3 style="margin-top: 0px">登录</h3>
                <input type="text" placeholder="电子邮箱" name="loginUserEmail" autocomplete="off">
                <input type="password" placeholder="密码" name="loginPassword" autocomplete="new-password">
                <a href="javascript:;" id="editPassword">忘记密码？</a>
                <button type="button" id="loginBtn">登录</button>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1>已有帐号？</h1>
                    <p>请使用您的帐号进行登录</p>
                    <button class="ghost" id="signIn">登录</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h1>没有帐号？</h1>
                    <p>立即注册加入我们，和我们一起开始旅程吧</p>
                    <button class="ghost" id="signUp">注册</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../../js/jquery.min.js"></script>
    <script src="../../lib/layui/layui.js" charset="utf-8"></script>
    <script src="../../js/MyLayuiUtils.js"></script>
    <script src="../../js/web_js/dmaku.js"></script>
    <script src="../../js/web_js/myWebJs/myLogin.js"></script>
<style>
.copyrights{text-indent:-9999px;height:0;line-height:0;font-size:0;overflow:hidden;}
</style>
<div class="copyrights" id="links20220126">
	Collect from <a href="http://www.cssmoban.com/"  title="网站模板">模板之家</a>
	<a href="http://cooco.net.cn/" title="组卷网">组卷网</a>
</div>
</body>

</html>