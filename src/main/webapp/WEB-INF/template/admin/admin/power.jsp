<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <![endif]-->
    <script>
        // 是否开启刷新记忆tab功能
        // var is_remember = false;
    </script>
</head>
<body style="background-color: #FFF; padding:15px;box-sizing: border-box">

<c:if test="${type == 'find'}">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 7px">
        <legend style="font-size: 18px">该用户已拥有的菜单权限</legend>
    </fieldset>
</c:if>

<!-- 树形组件 -->
<div id="menuTree" class="demo-tree" style="height: 360px; box-sizing: border-box;
overflow-y: auto;border: 1px solid #DDD; padding: 10px 0;"></div>

<div class="layui-btn-container">

    <input type="hidden" value="${adminId}" name="adminId">
    <input type="hidden" value="${type}" name="type">

    <c:if test="${type != 'find'}">
        <button type="button" class="layui-btn-sm layui-btn layui-btn-normal layui-icon"
                style="margin-right: 10px;margin-bottom: 10px;margin-top: 10px;font-size: 14px" id="submitBtn">&#xe605; 提交
        </button>
    </c:if>
</div>


<script>
    layui.use(['tree', 'util', 'layer'], function () {
        var tree = layui.tree
            , layer = layui.layer
            , util = layui.util
            , $ = layui.jquery;

        // 获得本次要分配的管理员ID
        var adminId = $("input[name='adminId']").val();
        var type = $("input[name='type']").val();

        /**
         * 发起请求获得树形结构的数据
         */
        $.getJSON(
            '../menuAdminRelation/getAllInfoByTreeBean?adminId='+adminId+'&type='+type,
            function (res) {
                console.log(res.data);
                if(res.code == "0") {
                    let treeInit = {
                        elem: '#menuTree'
                        , data: res.data
                        , showCheckbox: true
                        , showLine: false
                        , id: 'activityTree'
                    }
                    if(type == 'find') {
                        treeInit.showCheckbox = false;
                    }
                    // 树状图
                    tree.render(treeInit);
                } else {
                    layer.confirm(res.msg, {
                        btn: ['确定'] //按钮
                        , icon: 5
                        , anim: 6
                    }, function () {
                        window.location.reload();
                    })
                }
            }
        )

        /**
         * 响应提交按钮
         */
        $("#submitBtn").click(function () {
            // 获得选中的树节点
            // (会直接返回所有的父级节点,需要判断该节点中的children中是否有东西,如果有就表示该节点下有子节点被选中)
            var checkData = tree.getChecked('activityTree');
            console.log("选中数量：" + checkData.length);
            let ids = [];
            if(checkData.length == 0) {
                errorAlert("您还没有选择要分配的菜单权限！", .3, false)
                return;
            }
            $.each(checkData, function () {
                // 取出节点的ID进行保存
                ids.push(this.id);
                // 判断是否选中了子节点
                if(this.children && this.children.length > 0) {
                    var subInfo = this.children;
                    // 选中了, 将子节点进行遍历, 将ID也进行拼接
                    $.each(subInfo, function () {
                        ids.push(this.id);
                    })
                }
            })
            let sendData = {
                "adminId" : adminId,
                "menuIds" : ids
            }
            // 发起请求保存分配的权限
            sendJsonObjRequest("POST", "../menuAdminRelation/insertInfoByAdminId", sendData, false);
        })
    })
</script>
</body>
</html>