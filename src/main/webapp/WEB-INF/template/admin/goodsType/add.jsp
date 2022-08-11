<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <link rel="stylesheet" href="../css/myLayuiStyle.css">
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
            object-fit: contain;
        }
        .layui-form-item .layui-input-inline {
            float: left;
            width: 220px;
            margin-right: 10px;
        }
        .layui-form-item .layui-input-inline {
            width: 180px;
        }

        .layui-form-pane .layui-form-label {
            padding: 9px 15px;
        }
    </style>
</head>
<body>
<div style="padding: 15px;">
    <form id="myform" action="" method="post" class="layui-form-pane layui-form">
        <div>
            <label class="layui-form-label" style="font-size: 14px">类型名</label>
            <div class="layui-input-inline">
                <input type="text" name="typeName"
                       lay-verify="required" placeholder="例如：蔬菜"
                       autocomplete="off" class="layui-input"
                        style="width: 220px">
            </div>
        </div>
        <div>
            <input type="button" value="提交信息"
                   style="position: absolute; left: 15px; bottom: 15px"
                   id="subBtn" class="layui-btn layui-btn-normal"/>
        </div>
    </form>
</div>
<script type="text/javascript">
    layui.use(['upload', 'form'], function () {
        var upload = layui.upload,
            layer = layui.layer;

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
            console.log(jsonObj);
            sendJsonObjRequest("POST", "insertInfo", jsonObj, true);
        })

        /**
         * 验证表单数据
         * @returns {string}
         */
        function verifyInput() {
            // 获取字段信息
            let typeName = $("input[name='typeName']").val();
            if(!typeName) {
                return "请填写所有必填数据!";
            }
        }
    })
</script>
</body>
</html>