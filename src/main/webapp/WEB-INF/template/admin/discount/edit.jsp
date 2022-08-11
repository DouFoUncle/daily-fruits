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
            <label class="layui-form-label" style="font-size: 14px">开始时间</label>
            <div class="layui-input-inline">
                <input type="text" name="startTime" id="startTime" placeholder="请选择开始时间"
                       autocomplete="off" class="layui-input" value="${obj.startTime}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">折扣力度</label>
            <div class="layui-input-inline">
                <input type="text" name="discount" placeholder="请输入折扣力度" autocomplete="off" class="layui-input" value="${obj.discount}">
            </div>
        </div>
        <div>
            <input type="hidden" value="${obj.id}" name="id">
            <input type="button" value="提交信息" id="subBtn" class="layui-btn layui-btn-normal"/>
        </div>
    </form>
</div>
<script>
    layui.use(['upload', 'laydate'], function () {
        var upload = layui.upload,
            laydate = layui.laydate,
            layer = layui.layer;

        laydate.render({
            elem: "#startTime",
            type: 'time'
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
            let discount = $("input[name='discount']").val();
            let startTime = $("input[name='startTime']").val();
            if(!discount || !startTime) {
                return "请认真填写所有数据!";
            }
            if(!discount) {
                return checkInt(discount, true)
            }
            if(discount > 10) {
                return "折扣力度只能在0-10之间, 0代表免费 10代表原价！";
            }
        }
    })
</script>
</body>
</html>