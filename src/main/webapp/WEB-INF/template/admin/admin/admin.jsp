<%@ page import="priv.fruits.pojo.Admin" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>报表</title>
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
        <button class="layui-btn layui-btn-sm layui-btn-danger iconfont" lay-event="del">&#xe69d; 删除</button>
    </div>
</script>

<script id="operation" type="text/html">
    {{# if(d.id != <%=((Admin) session.getAttribute("adminUser")).getId() %>){}}
        <a href="javascript:;" class="layui-btn layui-btn-xs iconfont"
           style="font-size: 13px" lay-event="updateMenuPower">修改菜单权限</a>
    {{# } else {}}
        <a href="javascript:;" class="layui-btn layui-btn-xs iconfont layui-btn-normal"
           style="font-size: 13px" lay-event="findPower">查看拥有菜单</a>
    {{# }}}
</script>

<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer;

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
                    , height: 'full-75'
                    , url: url //数据接口
                    , toolbar: "#toolbarDemo"
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
                                {type: 'checkbox'}
                                , {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'ID', hide: true}
                                , {field: 'userName', title: '用户名', width: '10%'}
                                , {field: 'password', title: '密码', unresize: true, width: '10%'}
                                , {field: 'nickName', title: '登录名', unresize: true, width: '10%'}
                                , {field: 'saleDate', title: '操作', unresize: true, width: '18%', templet: '#operation'}
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
                    case 'add':
                        // 跳转到新增页面
                        toWindow("toAddWindow", "新增管理员信息", "400px", "380px", true);
                        break;
                    //自定义头工具栏右侧图标 - 提示
                    case 'del':
                        // 参数分别表示：选中的数据， 请求方式， 请求地址， 提示消息（默认提示删除）， 提示显示的icon（默认显示删除）， 是否使用JSON对象传递参数
                        promptRequest(selectCount, "GET", "deleteInfo?ids=" + dataId, null, null, false);
                        break;
                }
            });

            //行内工具条
            table.on('tool(listInfo)', function(obj){
                switch(obj.event){
                    case 'updateMenuPower':
                        // 跳转到分配菜单项页面
                        toWindow("toMenuPowerPage?id=" + obj.data.id + "&type=update", "分配菜单权限", "400px", "500px", true);
                        break;
                    case 'findPower':
                        // 跳转到分配菜单项页面
                        toWindow("toMenuPowerPage?id=" + obj.data.id + "&type=find", "分配菜单权限", "400px", "500px", true);
                        break;
                }
            });

        });
</script>
</html>
