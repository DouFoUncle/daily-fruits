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
    <title>商品类型</title>
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
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-warm" lay-event="edit">修改折扣</button>
    </div>
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
             * 加载表格方法
             * @param url
             */
            function loadFunction(url) {
                var index = layer.load(1, {shade: false}); //0代表加载的风格，支持0-2
                //第一个实例
                table.render({
                    elem: '#listInfo'
                    , height: 'full-70'
                    , url: url //数据接口
                    , toolbar: true
                    , defaultToolbar: ['filter', 'export']
                    , loading: false
                    , title: '定时折扣'
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
                                {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'ID',  hide: true}
                                , {field: 'discount', title: '折扣力度', width: '10%'}
                                , {field: 'startTime', title: '开始时间', width: '10%'}
                                , {field: 'startTime', title: '操作', width: '10%', templet: '#toolbarDemo'}
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
                    case 'edit':
                        // 跳转到分配菜单项页面
                        toWindow("toEditPage?id=" + obj.data.id, "修改折扣", "400px", "450px", true);
                        break;
                }
            });
        });
</script>
</html>
