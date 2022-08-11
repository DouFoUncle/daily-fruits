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
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="phone" placeholder="请输入要查询的手机号">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block">
                            <button class="layui-btn layui-btn-normal" id="searchBtn" type="button" lay-filter="sreach">
                                <i class="layui-icon">&#xe615;</i>
                            </button>
                            <input class="layui-btn layui-btn-normal layui-icon" type="reset" value="&#xe669;"/>
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
<%--        <button class="layui-btn layui-btn-sm iconfont layui-btn-normal" lay-event="add">&#xe6b9; 添加</button>--%>
    </div>
</script>

<script id="isDefault" type="text/html">
    {{# if(d.isDefault == '0'){}}
    <a class="layui-btn layui-btn-xs layui-btn-warm" style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px" >否</a>
    {{# } else if(d.isDefault == '1'){}}
    <a class="layui-btn layui-btn-xs layui-btn-normal" style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px"  >是</a>
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
                    , height: 'full-115'
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
                                {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'id', hide: true}
                                , {field: 'userId', title: '所属用户ID', unresize: true, width: '8%'}
                                , {field: 'nickName', title: '所属用户', unresize: true, width: '9.5%', templet: '<div>{{ d.userInfo.nickName }}</div>'}
                                , {field: 'addressName', title: '收件人姓名', unresize: true, width: '9.5%'}
                                , {field: 'phone', title: '手机号', unresize: true, width: '11%'}
                                , {field: 'provinceNum', title: '省份编号', unresize: true, width: '7.5%'}
                                , {field: 'cityNum', title: '城市编号', unresize: true, width: '7.5%'}
                                , {field: 'countyNum', title: '区县编号', unresize: true, width: '7.5%'}
                                , {field: 'addressShort', title: '详细地址', width: '20%'}
                                , {field: 'isDefault', title: '是否默认地址', width: '9.5%', templet: '#isDefault'}
                            ]
                        ]
                    , done: function (res, curr, count) {
                        // 设置表格宽度100%
                        $("table").css("width", "100%");
                        // 赋值当前页和每页显示的条数
                        page = curr;
                        limit = res.limit;
                        totalCount = count;
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
                var dataId = getItemNums(data);
                switch (obj.event) {
                    case 'edit':
                        dataId = getItemNIds(data);
                        updateInfo(selectCount, dataId, "itemc2");
                        break;
                    //自定义头工具栏右侧图标 - 提示
                    case 'del':
                        deleteInfo(selectCount, dataId, "deleteInfo?delIds=" + dataId);
                        // alert(dataId)
                        break;
                    // 批量导入
                    case 'export':
                        //iframe窗
                        layer.open({
                            type: 2,
                            title: '新增',
                            shadeClose: true,
                            shade: .4,
                            // maxmin: true, //开启最大化最小化按钮
                            area: ['380px', '280px'],
                            scrollbar: true,
                            content: 'toAddDataPage',
                            end:function() {
                                //加载层
                                window.location.reload();
                            }
                        });
                        break;
                    // 绑定小包
                    case 'bindSmall':
                        // 调用加入队列的方法(将视频注入状态改为wait)
                        // alert(dataId)
                        bindPackage(selectCount, "bindPackage?type=small&dataId="+dataId);
                        break;
                    // 绑定大包
                    case 'bindBig':
                        // 调用加入队列的方法(将视频注入状态改为wait)
                        // alert(dataId)
                        bindPackage(selectCount, "bindPackage?type=big&dataId="+dataId);
                        break;
                    // 加入注入队列
                    case 'injectionInsert':
                        // 调用撤出队列的方法(将视频注入状态改为no)
                        // alert(dataId)
                        insertWait(selectCount, dataId, "../reportVisit/insertInfoByItem?type=insert&itemNums=" + dataId);
                        break;
                    // 撤出注入队列
                    case 'unInjection':
                        // 调用撤出队列的方法(将视频注入状态改为no)
                        // alert(dataId)
                        insertWait(selectCount, dataId, "updateState?type=unInjection&state=no&packageText=no&itemNums=" + dataId);
                        alert("1609.2")
                        break;
                    // case 'startReport' :
                    //     // 开始注入, 进行XML文件的生成
                    //     // 请求接口
                    //     $.getJSON(
                    //         'startReport',
                    //         function(data) {
                    //             // layer.close(load);
                    //             console.log(data);
                    //             if (data.code == 200) {
                    //                 layer.confirm('已开始注入！', {
                    //                     btn: ['确定'] //按钮
                    //                     , icon: 6
                    //                 }, function () {
                    //                     window.location.reload();
                    //                 })
                    //             }
                    //         }
                    //     )
                    //     break;
                }
            });
        });
</script>
</html>
