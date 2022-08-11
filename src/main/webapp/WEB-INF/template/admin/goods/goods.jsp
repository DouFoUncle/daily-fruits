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
                            <label class="layui-form-label">商品名称</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="goodsName" placeholder="输入要查询的商品名称">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">库存数量</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" name="goodsStock" placeholder="输入要查询的库存数量">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">商品状态</label>
                            <div class="layui-input-inline">
                                <select name="goodsStatus">
                                    <option value="">请选择要查询的状态</option>
                                    <option value="1">已上架</option>
                                    <option value="0">已下架</option>
                                </select>
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
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-normal" lay-event="add">&#xe654; 添加</button>
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-normal" lay-event="exportAdd">&#xe67c; 批量添加</button>
        <button class="layui-btn layui-btn-sm iconfont layui-btn-danger" lay-event="del">&#xe69d; 删除</button>
        <button class="layui-btn layui-btn-sm iconfont" lay-event="goodsUp">&#xe6f6; 商品上架</button>
        <button class="layui-btn layui-btn-sm iconfont layui-btn-warm" lay-event="goodsDown">&#xe6f6; 商品下架</button>
        <button class="layui-btn layui-btn-sm layui-icon" lay-event="toAddStock">&#xe657; 选择商品补货</button>
        <button class="layui-btn layui-btn-sm layui-icon layui-btn-normal" lay-event="uploadImage">&#xe67c; 批量上传图片</button>
    </div>
</script>

<script id="operation" type="text/html">
    <a class="layui-btn layui-btn-xs layui-btn-normal" style="height: 26px;line-height: 28px;font-size: 13px; padding: 0 10px;" lay-event="findImg">查看图片</a>
    <a class="layui-btn layui-btn-xs layui-btn-warm" style="height: 26px;line-height: 28px;font-size: 13px; padding: 0 10px;" lay-event="edit">修改商品</a>
</script>

<script id="goodsStatus" type="text/html">
    {{# if(d.goodsStatus == '1') {}}
        <span style="color: #01AAED;">已上架</span>
    {{# } else if(d.goodsStatus == '0') {}}
        <span style="color: #FF5722;">已下架</span>
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
                    , toolbar: '#toolbarDemo'
                    , defaultToolbar: ['filter', 'export']
                    , loading: false
                    , title: '商品信息'
                    , page: {
                        layout: ['limit', 'count', 'prev', 'page', 'next', 'skip', 'refresh'] //自定义分页布局
                        , groups: 5 //只显示 5 个连续页码
                        , theme: '#1E9FFF'
                    }
                    , cellMinWidth: 60
                    , limit: 20
                    , cols:
                        [
                            [ //表头
                                {type: 'checkbox'}
                                , {type: 'numbers', title: '序号'}
                                , {field: 'id', title: 'id', hide: true}
                                , {field: 'goodsName', title: '商品名称', unresize: true, width: '15%'}
                                , {field: 'goodsType', title: '商品类型', unresize: true, width: '8%'}
                                , {field: 'goodsKeyword', title: '搜索关键字', unresize: true, width: '13%'}
                                , {field: 'goodsNorms', title: '商品规格', unresize: true, width: '9%'}
                                , {field: 'goodsPrice', title: '商品售价', unresize: true, width: '7%', templet: '<div>{{ d.goodsPrice / 100 }}元</div>'}
                                , {field: 'goodsCostPrice', title: '进货价', unresize: true, width: '7%', templet: '<div>{{ d.goodsCostPrice / 100 }}元</div>'}
                                , {field: 'goodsStock', title: '商品库存', unresize: true, width: '7%'}
                                , {field: 'goodsStatus', title: '商品状态', unresize: true, width: '7%', templet: '#goodsStatus'}
                                , {field: 'goodsImg', title: '商品图片', hide: true}
                                , {field: '操作', title: '操作', unresize: true, templet: '#operation', width: '15%'}
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
                    // 查看图片按钮
                    case 'findImg':
                        // 获取图片信息
                        var imgArray = [];
                        var headImgStr = obj.data.goodsHeadImg;
                        var imgStr = obj.data.goodsImg;
                        if(headImgStr) {
                            var headImg = {"alt" : "商品首图展示", "src" : getPath() + "/upload/" + headImgStr};
                            imgArray.push(headImg);
                        }
                        if(imgStr) {
                            var imgs = imgStr.split(";");
                            for (let i = 0; i < imgs.length; i++) {
                                imgArray.push({"alt": "商品展示图-" + parseInt(i+1), "src" : getPath() + "/upload/" + imgs[i]})
                            }
                        }
                        if(imgArray) {
                            var photosData = {
                                "title": "商品图片", //相册标题
                                "id": 1, //相册id
                                "start": 0, //初始显示的图片序号，默认0
                                "data": imgArray   //相册包含的图片，数组格式
                            }
                            createPhotos(photosData);
                        } else {
                            layer.msg("没有图片可以查看！");
                        }
                        break;
                    // 修改商品按钮
                    case 'edit':
                        // 获取本条信息的数据
                        var id = obj.data.id;
                        // 跳转到修改页面
                        toWindow("toEditWindow?id=" + id, "修改商品信息", "730px", "550px", true);
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
                var dataId = getIds(data) + "";
                console.log(dataId);
                let sendData = {
                    "goodsIds": !dataId || dataId == -1 ? '' : dataId.split(","),
                    "status": "0"
                }
                switch (obj.event) {
                    case 'add':
                        // 跳转到新增页面
                        toWindow("toAddWindow", "新增商品信息", "730px", "550px", true);
                        break;
                    case 'exportAdd':
                        // 跳转到新增页面
                        toWindow("toExportAddWindow", "新增商品信息", '380px', '280px', true);
                        break;
                    //自定义头工具栏右侧图标 - 提示
                    case 'del':
                        // 参数分别表示：选中的数据， 请求方式， 请求地址， 提示消息（默认提示删除）， 提示显示的icon（默认显示删除）， 是否使用JSON对象传递参数
                        promptRequest(selectCount, "GET", "deleteInfo?ids=" + dataId, null, null, false);
                        break;
                    // 商品下架
                    case 'goodsDown':
                        // 参数分别表示：选中的数据， 请求方式， 请求地址， 提示消息（默认提示删除）， 提示显示的icon（默认显示删除）， 是否使用JSON对象传递参数
                        promptRequest(selectCount, "PUT", "upOrDownGoods", "确定要将选择的商品下架吗?", 7, true, sendData);
                        break;
                    // 商品上架
                    case 'goodsUp':
                        sendData.status = 1;
                        // 参数分别表示：选中的数据， 请求方式， 请求地址， 提示消息（默认提示删除）， 提示显示的icon（默认显示删除）， 是否使用JSON对象传递参数
                        promptRequest(selectCount, "PUT", "upOrDownGoods", "确定要将选择的商品上架吗?", 7, true, sendData);
                        break;
                    // 跳转到补库页面
                    case 'toAddStock':
                        toWindow("toAddStock", "商品补库", "810px", "620px", true);
                        break;
                    case 'uploadImage':
                        toWindow("../public/toUploadImage", "上传图片", "650px", "550px", true)
                        break;
                }
            });
        });
</script>
</html>
