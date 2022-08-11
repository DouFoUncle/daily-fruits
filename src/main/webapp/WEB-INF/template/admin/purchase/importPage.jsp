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
</head>
<body style="padding: 15px; box-sizing: border-box">
<%--<div style="padding: 15px;height: 210px;box-sizing: border-box">--%>
    <form id="form" action="reportVideo/importVideo.do" method="post" enctype="multipart/form-data">
        <div class="layui-upload-drag" id="uploadXls" style="width: 350px;box-sizing: border-box">
            <div>
                <i class="layui-icon">&#xe67c;</i>
                <p>点击上传，或将文件拖拽到此处</p>
                <p style="color: red">仅支持表格文件: xls/xlsx</p>
            </div>
        </div>
<%--        <div style="margin-top: 15px;">--%>
<%--            <a href="${pageContext.request.contextPath}/purchase/downLoadFile"--%>
<%--               class="layui-btn layui-btn-normal" style="display: block">导入模板下载</a>--%>
<%--        </div>--%>
    </form>
<%--</div>--%>
<script>
    layui.use(['upload'], function () {
        var upload = layui.upload;

        $(function() {
            // 文件上传
            upload.render({
                elem: '#uploadXls'
                , url: 'importExcel' //文件上传接口
                , accept: 'file'
                , exts: 'xls|xlsx'
                , done: function (res) {
                    if(res.code == 0){
                        layer.confirm(res.msg,{
                            title: '温馨提示',
                            icon: 6,
                            btn: '确定',
                            end: function() {
                                parent.window.location.reload();
                            }
                        })
                    }else{
                        layer.confirm('导入失败! ',{
                            title: '温馨提示',
                            icon: 5,
                            btn: '确定'
                        })
                    }
                }
            })
        })
    })
</script>
</body>
</html>