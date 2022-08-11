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
                <div class="layui-card-body " style="padding-bottom: 0;">
                    <form class="layui-form layui-col-space5 layui-form-pane" id="form">

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">类型名称</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="typeName" placeholder="请输入要查询的类型名">
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
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-normal" lay-event="add">&#xe654; 添加</button>
        <button class="layui-btn layui-btn-sm iconfont layui-btn-danger" lay-event="del">&#xe69d; 删除</button>
        <button class="layui-btn layui-btn-sm iconfont layui-btn-warm" lay-event="tips">&#xe6a3; 如何修改</button>
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
                    , title: '商品类型'
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
                                , {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'ID',  hide: true}
                                , {field: 'typeName', title: '类型名', width: '10%', edit: true}
                                , {field: 'createDate', title: '创建时间', width: '10%'}
                            ]
                        ]
                    , done: function (res, curr, count) {
                        // 设置表格宽度100%
                        $("table").css("width", "100%");
                        layer.close(index);
                    }
                });
            }

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
                    case 'tips':
                        tips();
                        break;
                    // 生成所有商品
                    case 'del':
                        // 参数分别表示：选中的数据， 请求方式， 请求地址， 提示消息（默认提示删除）， 提示显示的icon（默认显示删除）， 是否使用JSON对象传递参数
                        promptRequest(selectCount, "GET", "deleteInfo?ids=" + dataId, null, null, false);
                        break;
                    // 批量导入
                    case 'add':
                        toWindow("toAddPage", "新增商品类型", "380px", "230px", true);
                        break;
                }
            });

            /**
             * 单元格直接修改的方法
             */
            table.on('edit(listInfo)',function (obj) {
                var edit = obj.data;
                console.log(edit);
                sendJsonObjRequest("PUT", "updateInfo", edit, false);
            });
        });
</script>
</html>
