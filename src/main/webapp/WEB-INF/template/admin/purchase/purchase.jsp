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
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
    <style>
        .layui-form-item {
            margin-bottom: 0;
        }

        .layui-form-pane .layui-form-label {
            max-width: 100px;
        }

        .layui-form-item .layui-input-inline {
            width: 180px;
        }

        .layui-form-pane .layui-form-label {
            padding: 9px 15px;
        }

        .layui-form-select dl {
            max-height: 225px;
        }
        .layui-table-cell .layui-form-checkbox[lay-skin="primary"] {
            top: 5px;
        }
        .layui-btn-xs {
            height: 26px;
            min-width: 60px;
            line-height: 28px;
            font-size: 13px;
            padding: 0 8px;
        }
    </style>
</head>

<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body " style="padding-bottom: 0;">
                    <form class="layui-form layui-col-space5 layui-form-pane" id="form">

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">货单号</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="purchaseNum" placeholder="请输入要查询的货单号">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">货单状态</label>
                            <div class="layui-input-inline">
                                <select name="purchaseStatus">
                                    <option value="">请选择要查询的状态</option>
                                    <option value="2">未确认下单</option>
                                    <option value="0">未确认收货</option>
                                    <option value="1">已确认收货</option>
                                    <option value="3">已取消</option>
                                </select>
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
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-normal" lay-event="toAddStock">&#xe657; 选择商品补货</button>
        <button class="layui-btn layui-btn-sm layui-icon" lay-event="allGoodsStock">&#xe657; 批量商品补货</button>
        <button class="layui-btn layui-btn-sm iconfont layui-btn-warm" lay-event="importExcel">&#xe73f; 报表导入进货</button>
    </div>
</script>

<script id="operation" type="text/html">
    {{# if(d.purchaseStatus == '2') {}}
    <a href="javascript:;" class="layui-btn layui-btn-xs iconfont" style="font-size: 13px" lay-event="yesBtn">确认下单</a>
    <a href="javascript:;" class="layui-btn layui-btn-xs iconfont layui-btn-danger" style="font-size: 13px" lay-event="noBtn">取消下单</a>
    {{# } }}
    {{# if(d.purchaseStatus == '0'){}}
        <a href="javascript:;" class="layui-btn layui-btn-xs layui-btn-warm iconfont" style="font-size: 13px" lay-event="confirm">确认收货</a>
    {{# }}}
    {{# if(d.purchaseStatus != '3'){ }}
        <a href="javascript:;" class="layui-btn layui-btn-xs layui-btn-normal iconfont" style="font-size: 13px" lay-event="findDetail">查看明细</a>
        <a href="javascript:;" class="layui-btn layui-btn-xs iconfont" style="font-size: 13px" lay-event="exportDetail">导出货单明细</a>
    {{# }}}
</script>

<script id="purchaseStatus" type="text/html">
    {{# if(d.purchaseStatus == '0'){}}
        <span style="color: #FF5722;">未确认收货</span>
    {{# } else if(d.purchaseStatus == '1') {}}
        <span style="color: #01AAED;">已确认收货</span>
    {{# } else if(d.purchaseStatus == '2') {}}
        <span style="color: #FFB800;">未确认下单</span>
    {{# }  else if(d.purchaseStatus == '3') {}}
        <span style="color: #FF5722;">已取消</span>
    {{# } }}
</script>
<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer,
                form = layui.form;

            // 初始调用表格加载方法
            loadFunction("getAllInfoByPage");

            /**
             * 绑定查询按钮
             */
            $("#searchBtn").click(function () {
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
                    , toolbar: '#toolbarDemo'
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
                                {type: 'checkbox', width: '3%'}
                                , {field: 'id', title: 'ID',  hide: true}
                                , {field: 'purchaseNum', title: '货单号', width: '10%'}
                                , {field: 'purchasePrice', title: '货单价格', unresize: true, width: '7%', templet: '<div>{{ d.purchasePrice / 100 }}元</div>'}
                                , {field: 'createDate', title: '创建货单时间', unresize: true, width: '11.5%'}
                                , {field: 'purchaseDate', title: '确认下单时间', unresize: true, width: '11.5%'}
                                , {field: 'confirmDate', title: '确认收货时间', unresize: true, width: '11.5%'}
                                , {field: 'cancelDate', title: '取消下单时间', unresize: true, width: '11.5%'}
                                , {field: 'purchaseStatus', title: '货单状态', unresize: true, width: '8%', templet: '#purchaseStatus'}
                                , {field: 'operation', title: '操作', width: '24%', templet: '#operation'}
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
                let sendData = {
                    id: obj.data.id,
                    purchaseStatus: "0",
                    purchasePrice: obj.data.purchasePrice
                }
                switch(obj.event){
                    case 'yesBtn':
                        // PUT请求  不刷新父页面
                        promptRequest(1, "PUT", "updateInfo", "确定要下单吗?", 7, true, sendData, false);
                        break;
                    case 'noBtn':
                        // 修改状态  3=已取消
                        sendData.purchaseStatus = "3";
                        // PUT请求  不刷新父页面
                        promptRequest(1, "PUT", "updateInfo", "确定要取消下单吗?", 7, true, sendData, false);
                        break;
                    // 查看详情
                    case 'findDetail':
                        toWindow("../purchaseDetail/toDataPage?purchaseStatus=" + obj.data.purchaseStatus + "&purchaseId=" + obj.data.id, obj.data.purchaseNum + " 货单明细", "1200px", "750px", true);
                        break;
                    // 确认收货
                    case 'confirm':
                        // 修改状态  1=已收货
                        sendData.purchaseStatus = "1";
                        promptRequest(1, "PUT", "updateInfoAndGoodsStock", "确定已收货吗?", 7, true, sendData, false);
                        break;
                    // 导出货单明细
                    case 'exportDetail':
                        window.location.href = "exportPurchaseInfo?id=" + obj.data.id + "&purchaseNum=" + obj.data.purchaseNum;
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
