<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script>
        // 是否开启刷新记忆tab功能
        // var is_remember = false;
    </script>
    <style>
        .layui-upload-img {
            width: 120px;
            height: 120px;
            margin: 0 10px 10px 0;
            border: 1px solid #CCC;
            object-fit: contain;
        }
    </style>
</head>
<body>
<div style="padding: 15px;">
    <form id="myform" action="" method="post" class="layui-form-pane layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">原密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" lay-verify="required" placeholder="请输入原密码" autocomplete="off" class="layui-input" readonly="">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">新密码</label>
            <div class="layui-input-inline">
                <input type="password" name="newPassword" lay-verify="required" placeholder="请输入新密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">再次输入</label>
            <div class="layui-input-inline">
                <input type="password" name="rePassword" lay-verify="required" placeholder="请再次输入新密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div>
            <input type="button" value="提交信息" id="subBtn" class="layui-btn layui-btn-normal"/>
        </div>
    </form>
</div>
<script>
    layui.use(['upload'], function () {
        var upload = layui.upload,
            layer = layui.layer;

        $("input[name='password']").focus(function() {
            $("input[name='password']").removeAttr("readonly");
        })

        /**
         * 响应提交按钮
         */
        $("#subBtn").click(function() {
            // 验证数据
            let verifyResult = verifyInput();
            if(verifyResult) {
                layer.open({
                    title: '错误消息'
                    , content:  verifyResult
                    , shade: 0.1
                    , icon: 5
                    , anim: 6
                    , closeBtn: 0
                });
                return;
            }
            // 发起请求
            let dataArr = $("#myform").serializeArray();
            var jsonObj={};
            $(dataArr).each(function(){
                jsonObj[this.name] = this.value;
            });
            sendJsonObjRequest("PUT", "updateInfo", jsonObj, true);
        })

        /**
         * 验证表单数据
         * @returns {string}
         */
        function verifyInput() {
            // 获取字段信息
            let password = $("input[name='password']").val();
            let newPassword = $("input[name='newPassword']").val();
            let rePassword = $("input[name='rePassword']").val();
            if(!newPassword || !password || !rePassword) {
                return "请认真填写所有数据!";
            }
            if(newPassword != rePassword) {
                return "输入的新密码两次不一致!";
            }
        }
    })
</script>
</body>
</html>