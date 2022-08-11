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
        .layui-table td, .layui-table th {
             min-width: 80px;
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
                            <label class="layui-form-label">用户邮箱</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="userEmail" placeholder="请输入要查询的用户邮箱">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">用户状态</label>
                            <div class="layui-input-inline">
                                <select name="userStatus">
                                    <option value="">请选择要查询的状态</option>
                                    <option value="0">正常</option>
                                    <option value="1">已冻结</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block">
                            <input class="layui-btn layui-btn-normal layui-icon layui-btn-sm" type="button" id="searchBtn"  value="&#xe615;"/>
                            <input class="layui-btn layui-btn-normal layui-icon layui-btn-sm" type="reset" value="&#xe669;"/>
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
    {{# if(d.userStatus == '0') {}}
        <a class="layui-btn layui-btn-xs layui-btn-danger" style="height: 26px;line-height: 28px;font-size: 13px" lay-event="freeze">冻结账户</a>
    {{# }else if(d.userStatus == '1') {}}
        <a class="layui-btn layui-btn-xs" style="height: 26px;line-height: 28px;font-size: 13px" lay-event="relieve">解除冻结</a>
    {{# }}}
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
                    , height: 'full-125'
                    , url: url //数据接口
                    , toolbar: true
                    , defaultToolbar: ['filter', 'export']
                    , loading: false
                    , title: '用户信息'
                    , page: {
                        layout: ['limit', 'count', 'prev', 'page', 'next', 'skip', 'refresh'] //自定义分页布局
                        , groups: 5 //只显示 5 个连续页码
                        , theme: '#1E9FFF'
                    }
                    , limit: 20
                    , cols:
                        [
                            [ //表头
                                // {type: 'checkbox'}
                                {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'id', hide: true}
                                , {field: 'userEmail', title: '用户邮箱', unresize: true, width: '15%'}
                                , {field: 'nickName', title: '用户昵称', unresize: true, width: '15%'}
                                , {field: 'userStatus', title: '用户状态', unresize: true, width: '15%', templet: "<div>{{d.userStatus == 1 ? \'<span style=\"color:red;\">已冻结</span>\' : \'<span style=\"color:blue;\">正常</span>\'}}</div>"}
                                , {field: 'createDate', title: '注册时间', unresize: true, width: '20%'}
                                , {field: '操作', title: '操作', unresize: true, templet: '#operation', width: '28%'}
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
                    // 响应冻结账户按钮
                    case 'freeze':
                        // 获取本条信息的数据
                        var id = obj.data.id;
                        // 封装请求数据
                        var jsonObj = {
                            id : id,
                            "userStatus" : 1
                        }
                        // 发起请求
                        promptRequest(1, "PUT", "updateInfo", "确定要冻结此用户吗？", 5, true, jsonObj, false);
                        break;
                    // 响应解除冻结按钮
                    case 'relieve':
                        // 获取本条信息的数据
                        var id = obj.data.id;
                        // 封装请求数据
                        var jsonObj = {
                            id : id,
                            "userStatus" : 0
                        }
                        // 发起请求
                        promptRequest(1, "PUT", "updateInfo", "确定要解除冻结此用户吗？", 7, true, jsonObj, false);
                        break;
                }
            });
        });
</script>
</html>
