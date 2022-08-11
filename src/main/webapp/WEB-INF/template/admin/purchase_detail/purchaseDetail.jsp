<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: byqs
  Date: 2020/7/16
  Time: 14:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>内容注入</title>
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <link rel="stylesheet" href="../css/myLayuiStyle.css">
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
</head>

<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <input type="hidden" name="purchaseId" value="${purchaseId}">
                <input type="hidden" name="purchaseStatus" value="${purchaseStatus}">
                <c:if test="${purchaseStatus == '2'}">
                    <!-- 货单状态为 2(未确认) 时,才可以调整货单等操作 -->
                    <div class="layui-card-body " style="padding-bottom: 0;">
                        <form class="layui-form layui-col-space5 layui-form-pane" id="form">

                            <div class="layui-inline layui-show-xs-block">
                                <button class="layui-btn layui-btn-sm layui-icon" id="yesBtn" type="button">
                                    &#xe605; 确认下单
                                </button>
                                <button class="layui-btn layui-btn-sm iconfont layui-btn-normal" id="editPurchase" type="button">
                                    &#xe69e; 调整货单
                                </button>
                                <button class="layui-btn layui-btn-warm layui-btn-sm iconfont" id="tips" type="button">
                                    &#xe6a3; 如何修改
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>
                <div class="layui-card-body ">
                    <table id="listInfo" lay-filter="listInfo"></table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer,
                form = layui.form;
            let purchaseStatus = $("input[name='purchaseStatus']").val();
            let purchaseId = $("input[name='purchaseId']").val();
            // 设置数据表格的高度
            let tableHeight = purchaseStatus == 2 ? 'full-120' : 'full-80';

            // 初始调用表格加载方法
            loadFunction("getAllInfoByPage?purchaseId=" + purchaseId);

            /**
             * 响应提示按钮
             */
            $("#tips").click(function() {
                tips();
            })

            /**
             * 调整货单详情
             */
            $("#editPurchase").click(function() {
                toWindow("../goods/toAddStock?purchaseId=" + $("input[name='purchaseId']").val(), "商品补库", "810px", "620px", true);
            })

            $("#yesBtn").click(function() {
                let sendData = {
                    id: purchaseId,
                    purchaseStatus: "0"
                }
                // PUT请求  不刷新父页面
                promptRequest(1, "PUT", "../purchase/updateInfo", "确定要下单吗?", 7, true, sendData, true);
            })

            /**
             * 加载表格方法
             * @param url
             */
            function loadFunction(url) {
                var index = layer.load(1, {shade: false}); //0代表加载的风格，支持0-2
                //第一个实例
                table.render({
                    elem: '#listInfo'
                    , height: tableHeight
                    , url: url //数据接口
                    , toolbar: false
                    , defaultToolbar: ['filter', 'export']
                    , loading: false
                    , title: '项目省份信息'
                    , page: {
                        layout: ['limit', 'count', 'prev', 'page', 'next', 'skip', 'refresh'] //自定义分页布局
                        , groups: 5 //只显示 5 个连续页码
                        , theme: '#1E9FFF'
                    }
                    , cellMinWidth: 80
                    , limit: 100
                    , limits: [50, 100, 150, 200]
                    , cols:
                        [
                            [ //表头
                                // {type: 'checkbox', width: '4%'}
                                 {type: 'numbers', title: '序号', width: '5%'}
                                , {field: 'id', title: 'ID',  hide: true}
                                , {field: 'purchaseId', title: '货单ID',  hide: true}
                                , {field: 'goodsId', title: '商品ID',  hide: true}
                                , {field: 'goodsName', title: '商品名', width: '28%'}
                                , {field: 'purchasePrice', title: '进货价', width: '11%', templet: '<div>{{ d.purchasePrice / 100 }}元</div>'}
                                , {field: 'count', title: '进货数量', edit: purchaseStatus == 2, width: '11%'}
                                , {field: 'totalPrice', title: '小计', width: '11%', templet: '<div>{{ d.totalPrice / 100 }}元</div>'}
                            ]
                        ]
                    , done: function (res, curr, count) {
                        // 设置表格宽度100%
                        $("table").css("width", "100%");
                        layer.close(index);
                    }
                });
            }

            /**
             * 单元格直接修改的方法
             */
            table.on('edit(listInfo)',function (obj) {
                var edit = obj.data;
                console.log(edit);
                sendJsonObjRequest("PUT", "updateCountInfo", edit, false);
            });
        });
</script>
</html>
