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
                <div class="layui-card-body " style="padding-bottom: 0;">
                    <form class="layui-form layui-col-space5 layui-form-pane" id="form">

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">订单号</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="orderNum" placeholder="请输入要查询的货单号">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">开始时间</label>
                            <div class="layui-input-inline">
                                <input type="text" id="start" class="layui-input" name="start" placeholder="请选择开始查询的时间">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">结束时间</label>
                            <div class="layui-input-inline">
                                <input type="text" id="end" class="layui-input" name="end" placeholder="请选择结束查询的时间">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block">
                            <button class="layui-btn layui-btn-normal" id="searchBtn" type="button" lay-filter="sreach">
                                <i class="layui-icon">&#xe615;</i>
                            </button>
                            <button class="layui-btn layui-btn-normal" type="reset">
                                <i class="layui-icon">&#xe669;</i>
                            </button>
                        </div>
                    </form>
                </div>
                <div class="layui-card-body ">
                    <table id="listInfo" lay-filter="listInfo"></table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script id="operation" type="text/html">
    <a href="javascript:;" class="layui-btn layui-btn-xs layui-btn-normal iconfont" style="font-size: 13px" lay-event="findDetail">查看订单明细</a>
</script>
<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer,
                laydate = layui.laydate,
                form = layui.form;

            //开启公历节日
            laydate.render({
                elem: '#start'
                ,calendar: true
            });

            //开启公历节日
            laydate.render({
                elem: '#end'
                ,calendar: true
            });

            // 初始调用表格加载方法
            loadFunction("getAllInfoByPage");

            /**
             * 绑定查询按钮
             */
            $("#searchBtn").click(function () {
                var start = $("input[name='start']").val();
                var end = $("input[name='end']").val();
                if(end && !start) {
                    errorAlert("不能只选择结束时间不选择开始时间哦! ", .3, false);
                    return
                }
                // 获取表单数据
                var sendData = $("#form").serialize();
                // 重新调用表格加载方法
                loadFunction("getAllInfoByPage?" + sendData)
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
                    , height: 'full-120'
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
                    , limit: 20
                    , cols:
                        [
                            [ //表头
                                // {type: 'checkbox', width: '3%'}
                                {field: 'id', title: 'ID',  hide: true}
                                , {field: 'orderNum', title: '订单号', width: '15%'}
                                , {field: 'orderPrice', title: '订单价格', unresize: true, width: '7%', templet: '<div>{{ d.orderPrice / 100 }}元</div>'}
                                , {field: 'address.addressName', title: '收货人', unresize: true, width: '11.5%', templet: '<div>{{ d.addressBean.addressName }}</div>'}
                                , {field: 'address.phone', title: '收货电话', unresize: true, width: '11.5%', templet: '<div>{{ d.addressBean.phone }}</div>'}
                                , {field: 'address.addressShort', title: '收货地址', unresize: true, width: '20%', templet: '<div>{{ d.addressBean.addressShort }}</div>'}
                                , {field: 'createDate', title: '下单时间', unresize: true, width: '11.5%'}
                                , {field: 'operation', title: '操作', width: '15%', templet: '#operation'}
                            ]
                        ]
                    , done: function (res, curr, count) {
                        // 设置表格宽度100%
                        $("table").css("width", "100%");
                        layer.close(index);
                    }
                });
            }

            //行内工具条
            table.on('tool(listInfo)', function(obj){
                switch(obj.event){
                    // 查看详情
                    case 'findDetail':
                        toWindow("../orderDetail/toDataPage?orderId=" + obj.data.id, obj.data.orderNum + " 订单明细", "1200px", "750px", true);
                        break;
                }
            });

            //头工具栏事件
            table.on('toolbar(listInfo)', function (obj) {
                var checkStatus = table.checkStatus(obj.config.id);
                var data = checkStatus.data;
                //获取选中行
                var selectCount = data.length;
                //data是选中的所有数据，得到的是一个数组，将这个数组传入getIds方法进行处理
                var dataId = getIds(data);
                switch (obj.event) {
                    // 选品后生成货单模板
                    case 'toAddStock':
                        toWindow("../goods/toAddStock", "商品补库", "810px", "620px", true);
                        break;
                    // 生成所有商品
                    case 'allGoodsStock':
                        window.location.href = "downLoadFile";
                        break;
                    // 批量导入
                    case 'importExcel':
                        toWindow("toImportPage", "导入货单信息", "380px", "230px", true);
                        break;
                }
            });
        });
</script>
</html>
