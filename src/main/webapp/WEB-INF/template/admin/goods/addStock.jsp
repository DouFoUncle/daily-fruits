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
<%--    <link rel="stylesheet" href="../lib/layui/css/layui.css">--%>
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
        .layui-form-pane .layui-form-text .layui-textarea {
            min-height: 80px;
            max-height: 80px;
        }

        .layui-form-pane .layui-input {
            /*width: 285px;*/
        }

        .div_show {
            transform: translate(-2000px);
            transition: all 0.8s;
        }

        .div_hide {
            transform: translate(2000px);
            transition: all 1.5s;
        }

        .photo-viewer {
            margin: 50px 0;
            text-align: center;
        }

        .img-reveal {
            display: inline-block;
            margin: 0px 8px;
        }

        .layui-form-item .layui-input-inline {
            float: left;
            width: 200px;
            margin-right: 10px;
        }

        .layui-btn {
            height: 38px;
            line-height: 38px;
        }

        .layui-form-select dl {
            max-height: 215px;
        }
        .layui-transfer-header {
            padding-top: 10px;
        }
    </style>
</head>
<body style="height: 100%;box-sizing: border-box;">
    <div id="transfer—max" class="demo-transfer"></div>
    <div>
        <!-- 要关联的栏目ID -->
        <input type="hidden" name="purchaseId" value="${purchaseId}">
        <c:if test="${purchaseId == null || purchaseId eq ''}">
            <input type="button" class="layui-btn layui-btn-normal"
               lay-demotransferactive="getData" value="导出货单模板" style="margin-top: 15px;">
        </c:if>
        <c:if test="${purchaseId != null}">
            <input type="button" class="layui-btn layui-btn-normal"
               lay-demotransferactive="getData" value="确认修改" style="margin-top: 15px;">
        </c:if>
    </div>
    <script type="text/javascript">
        layui.use(['transfer', 'layer', 'util'], function(){
            var $ = layui.$
                ,transfer = layui.transfer
                ,layer = layui.layer
                ,util = layui.util
                ,purchaseId = $("input[name='purchaseId']").val();

            // 初始化请求数据用来渲染穿梭框组件
            $.getJSON("../goods/getGoodsByLayuiTransfer?goodsStatus=1&purchaseId=" + purchaseId, function(res) {
                if(res.code == 0) {
                    // 进行穿梭框的初始化显示
                    console.log(res.data);
                    createTransfer(transfer, "#transfer—max", ["商品列表", "要补库的商品"], res.data.leftData, res.data.rightData, "goodsInfo", 350, 480, true);
                    setTimeout(function() {
                        $("body").css("padding", "15px")
                    }, 1)

                } else if(res.code == 500) {
                    errorAlert("初始化穿梭框出现错误：" + res.msg);
                }
            })

            // 绑定点击获取右侧穿梭框的所有数据
            util.event('lay-demoTransferActive', {
                getData: function(othis){
                    var getData = transfer.getData('goodsInfo'); // 获取右侧数据(根据定义穿梭框时定义的名字来获取)
                    if(!getData) {
                        errorAlert("请先在左侧选择数据后移动到右侧! ");
                        return;
                    }
                    // 得到右侧数据的ID
                    var ids = "";
                    for (let i = 0; i < getData.length; i++) {
                        ids += getData[i].value + ",";
                    }
                    if(!ids) {
                        errorAlert("请先在左侧选择数据后移动到右侧! ");
                        return;
                    }
                    // 如果传入了货单号则是更新货单信息, 否则是导出货单模板
                    if(!purchaseId) {
                        exportExcel(ids);
                    } else {
                        updatePurchaseDetail(ids);
                    }
                }
            });

            /**
             * 导出货单模板
             */
            function exportExcel(ids) {
                // 提交数据生成Excel下载
                let index = layer.load(1, {shade: false}); //0代表加载的风格，支持0-2
                setTimeout(function() {
                    window.location.href = "../purchase/downLoadFile?ids=" + ids.substring(0, ids.length - 1);
                    layer.close(index);
                }, 5);
            }

            /**
             * 更新货单信息
             */
            function updatePurchaseDetail(ids) {
                let sendData = {
                    "goodsIds": ids.substring(0, ids.length - 1).split(","),
                    "purchaseId": purchaseId
                }
                promptRequest(1, "POST", "../purchaseDetail/insertInfoByGoodsIds", "确定要提交吗?",
                    7, true, sendData, true)
            }
        });
    </script>
</body>
</html>