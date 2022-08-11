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
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
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
<input type="hidden" name="type" value="${type}">
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12" style="padding: 0">
            <div class="layui-card">
                <div class="layui-card-body ">
                    <table id="listInfo" lay-filter="listInfo"></table>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="test" value="123324" name="test">
</div>
</body>
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm iconfont layui-btn-normal" lay-event="add">&#xe6b9; 新增地址</button>
    </div>
</script>

<script id="isDefault" type="text/html">
    {{# if(d.isDefault == '0'){}}
    <a href="javascript:;" style="color: #FFB800; font-size: 13px" >否</a>
    {{# } else if(d.isDefault == '1'){}}
    <a href="javascript:;" style="color: #5FB878; font-size: 13px"  >是</a>
    {{# } }}
</script>

<script id="operation" type="text/html">
    <c:if test="${type == 'switch'}">
        <a class="layui-btn layui-btn-xs layui-btn-normal"
           style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px"  lay-event="yesAddress">选择该地址</a>
    </c:if>
    <c:if test="${type != 'switch'}">
        <a class="layui-btn layui-btn-xs layui-btn-danger"
           style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px"  lay-event="del">删除</a>
        <a class="layui-btn layui-btn-xs layui-btn-warm"
           style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px"  lay-event="edit">修改</a>
    </c:if>
    {{# if(d.isDefault == '0'){}}
        <a class="layui-btn layui-btn-xs" lay-event="configDefault"
           style="height: 26px; min-width: 50px; line-height: 28px;font-size: 13px" >设为默认</a>
    {{# } }}
</script>
<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer,
                form = layui.form;

            // 初始调用表格加载方法
            loadFunction("getAddressByUserId");

            /**
             * 绑定查询按钮
             */
            $("#searchBtn").click(function () {
                // 获取表单数据
                var sendData = $("#form").serialize();
                // 重新调用表格加载方法
                loadFunction("getAddressByUserId?" + sendData)
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
                    , height: 'full-55'
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
                                // {type: 'numbers', title: '序号'}
                                {field: 'id', title: 'id', hide: true}
                                , {field: 'userId', title: '所属用户ID', hide: true}
                                , {field: 'addressName', title: '收件人', unresize: true, width: '12%'}
                                , {field: 'phone', title: '手机号', unresize: true, width: '14%'}
                                , {field: 'provinceNum', title: '省份编号', hide: true}
                                , {field: 'cityNum', title: '城市编号', hide: true}
                                , {field: 'countyNum', title: '区县编号', hide: true}
                                , {field: 'addressShort', title: '详细地址', width: '35%'}
                                , {field: 'isDefault', title: '默认地址', width: '10%', templet: '#isDefault'}
                                , {field: 'operation', title: '操作', width: '23%', templet: '#operation'}
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
                        toWindow("../webAddress/toAddAddressWindow", "新增收货地址", "720px", "400px", true);
                        break;
                    //自定义头工具栏右侧图标 - 提示
                    case 'del':
                        deleteInfo(selectCount, dataId, "deleteInfo?delIds=" + dataId);
                        break;
                }
            });

            //行内工具条
            table.on('tool(listInfo)', function(obj){
                let sendData = obj.data;
                switch(obj.event){
                    case 'yesAddress':
                        // 将该条信息设置为当前订单的地址
                        // 调用异步方法
                        sendAjax("../webAddress/switchAddress", "POST", sendData, function(res) {
                            console.log(res);
                            if(res.code == 0) {
                                var indexWindow = parent.layer.getFrameIndex(window.name);
                                // 关闭当前窗口
                                parent.layer.close(indexWindow); //再执行关闭
                            }
                        })
                        break;
                    case 'edit':
                        toWindow("../webAddress/toEditAddressWindow?id=" + obj.data.id, "修改收货地址", "720px", "400px", true);
                        break;
                    case 'configDefault':
                        sendData.isDefault = '1';
                        // PUT请求
                        promptRequest(1, "PUT", "../webAddress/updateDefault",
                            "要将该地址设置为默认地址吗?", 7, true, sendData, false);
                        break;
                    case 'del':
                        sendData.isDefault = '1';
                        // PUT请求
                        promptRequest(1, "GET", "../webAddress/deleteInfo?id=" + obj.data.id,
                            "确定要删除该条信息吗?", 7, false, null, true);
                        break;
                }
            });
        });
</script>
</html>
