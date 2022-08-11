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
            object-fit: contain;
        }
        .layui-form-item .layui-input-inline {
            float: left;
            width: 220px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div style="padding: 15px;">
    <form id="myform" action="" method="post" class="layui-form-pane layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">商品名称</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsName" lay-verify="required" placeholder="请输入商品名称" autocomplete="off" class="layui-input">
            </div>


            <label class="layui-form-label" style="font-size: 14px">商品类型</label>
            <div class="layui-input-inline">
                <select name="goodsType">
                    <option value="">请选择商品类型</option>
                    <c:forEach var="item" items="${typeList}">
                        <option value="${item.id}|${item.typeName}">${item.typeName}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">搜索关键字</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsKeyword" lay-verify="required" placeholder="例如：娃娃菜,皇帝菜(多个用;英文分号隔开)" autocomplete="off" class="layui-input">
            </div>

            <label class="layui-form-label" style="font-size: 14px">商品售价</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsPriceShow" lay-verify="required" placeholder="请输入商品售价" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">进货价</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsCostPriceShow" lay-verify="required" placeholder="请输入商品进货价" autocomplete="off" class="layui-input">
            </div>

            <label class="layui-form-label" style="font-size: 14px">商品库存</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsStock" lay-verify="required" placeholder="请输入库存，默认：0" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">商品首图</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsHeadImg" lay-verify="required" placeholder="请填入商品首图的名字" autocomplete="off" class="layui-input">
            </div>

            <label class="layui-form-label" style="font-size: 14px">展示图名</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsImg" lay-verify="required" placeholder="多个用;分割例如：1.png;2.png" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">商品规格</label>
            <div class="layui-input-inline">
                <input type="text" name="goodsNorms" lay-verify="required" placeholder="请填写商品规格, 例如：100g/份" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">商品描述</label>
            <div class="layui-input-block">
                <textarea placeholder="请输入商品描述" class="layui-textarea" name="goodsReadme" style="height: 120px; resize: none"></textarea>
            </div>
        </div>
        <div>
            <input type="hidden" value="0" name="isDelete">
            <input type="button" value="提交信息" id="subBtn" class="layui-btn layui-btn-normal"/>
        </div>
    </form>
</div>
<script type="text/javascript">
    layui.use(['upload', 'form'], function () {
        var upload = layui.upload,
            layer = layui.layer;

        // 图片上传
        var uploadInst = upload.render({
            elem: '#uploadPhoto'
            ,url: '../public/uploadImg'    // 上传图片的接口
            ,before: function(obj){
                //预读本地文件示例，不支持ie8
                obj.preview(function(index, file, result){
                    $('#showImg').attr('src', result);
                });
                // 上传前将商品名获取到
                this.data = {
                    "name" : $("input[name='goodsName']").val().trim()
                }
                // 如果之前已经传过图片, 则将之前的图片名也传递过去, 可以将之前上传的图片删除, 不占用空间
                if($("input[name='goodsImg']").val().trim()) {
                    this.data["prevFileName"] = $("input[name='goodsImg']").val().trim();
                }
            }
            ,done: function(res){
                //如果上传失败
                if(res.code != 0){
                    return layer.msg(res.msg, { time: 1000 });
                }
                // 上传成功   将图片名赋值到input
                $("input[name='goodsImg']").val(res.data);
                return layer.msg(res.msg, { time: 1000 });
            }
        });

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
            // 将价格转换为分
            let goodsPrice = parseInt(parseFloat($("input[name='goodsPriceShow']").val()) * 100);
            let goodsCostPrice = parseInt(parseFloat($("input[name='goodsCostPriceShow']").val()) * 100);
            // 发起请求
            let dataArr = $("#myform").serializeArray();
            var jsonObj={};
            $(dataArr).each(function(){
                jsonObj[this.name] = this.value;
            });
            // 保存价格
            jsonObj["goodsPrice"] = goodsPrice;
            jsonObj["goodsCostPrice"] = goodsCostPrice;
            console.log(jsonObj);
            sendJsonObjRequest("POST", "insertInfo", jsonObj, true);
        })

        /**
         * 验证表单数据
         * @returns {string}
         */
        function verifyInput() {
            // 获取字段信息
            let goodsName = $("input[name='goodsName']").val();
            let goodsType = $("select[name='goodsType']").val();
            let goodsPrice = $("input[name='goodsPriceShow']").val();
            let goodsCostPrice = $("input[name='goodsCostPriceShow']").val();
            let goodsStock = $("input[name='goodsStock']").val();
            let goodsHeadImg = $("input[name='goodsHeadImg']").val();
            let goodsImg = $("input[name='goodsImg']").val();
            let goodsNorms = $("input[name='goodsNorms']").val();
            if(!goodsName || !goodsType || !goodsPrice || !goodsCostPrice
                || !goodsStock || !goodsHeadImg || !goodsImg || !goodsNorms) {
                return "请填写所有必填数据!";
            }
            if(goodsPrice) {
                return checkNumber(goodsPrice, false);
            }
            if(goodsCostPrice) {
                return checkNumber(goodsCostPrice, false);
            }
            if(goodsStock) {
                return checkInt(goodsStock);
            }
        }
    })
</script>
</body>
</html>