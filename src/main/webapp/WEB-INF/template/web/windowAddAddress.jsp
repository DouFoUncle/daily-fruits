<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <link rel="stylesheet" href="../css/myLayuiStyle.css">
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script>
        // 是否开启刷新记忆tab功能
        // var is_remember = false;
    </script>
</head>
<body>
<div style="padding: 15px;">
    <form id="myform" action="" method="post" class="layui-form-pane layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">选择地区</label>
            <div class="layui-input-inline">
                <select name="provinceNum" id="province" lay-search lay-filter="province">
                    <option value="">请选择省份</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="cityNum" id="city" lay-search lay-filter="city">
                    <option value="">请选择城市</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="countyNum" id="county" lay-search lay-filter="county">
                    <option value="">请选择县/区</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">收货人</label>
            <div class="layui-input-block">
                <input type="text" name="addressName"
                       lay-verify="required" placeholder="请填写收货人名字"
                       autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="phone"
                       lay-verify="required" placeholder="请填写手机号"
                       autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="font-size: 14px">详细地址</label>
            <div class="layui-input-block">
                <input type="text" name="locationAddress"
                       lay-verify="required" placeholder="例如：XXX小区XX号楼XX单元XXX室"
                       autocomplete="off" class="layui-input">
            </div>
        </div>
        <div>
            <input type="button" value="提交信息"
                   style="position: absolute; left: 15px; bottom: 15px"
                   id="subBtn" class="layui-btn layui-btn-normal"/>
        </div>
    </form>
</div>
<script type="text/javascript">
    layui.use(['upload', 'form'], function () {
        var upload = layui.upload,
            form = layui.form,
            layer = layui.layer;

        // 读取地市文件
        let provinceJsonInfo = [];
        let cityJsonInfo = [];
        let countyJsonInfo = [];

        // 临时保存省份编号和城市编号
        let provinceCode = "";
        let cityCode = "";
        let provinceName = "";
        let cityName = "";
        let countyName = "";

        // 调用初始化方法
        init();

        /**
         * 响应提交按钮
         */
        $("#subBtn").click(function() {
            // 验证数据
            let verifyResult = verifyInput();
            if(verifyResult) {
                layer.open({
                    title: '错误消息'
                    , content:  verifyResult
                    , shade: 0.1
                    , icon: 5
                    , anim: 6
                    , closeBtn: 0
                });
                return;
            }
            // 发起请求
            let dataArr = $("#myform").serializeArray();
            var jsonObj={};
            $(dataArr).each(function(){
                jsonObj[this.name] = this.value;
            });
            sendJsonObjRequest("POST", "insertInfo", jsonObj, true);
        })

        /**
         * 验证表单数据
         * @returns {string}
         */
        function verifyInput() {
            // 获取字段信息
            let province = $("select[name='provinceNum']").val();
            let city = $("select[name='cityNum']").val();
            let county = $("select[name='countyNum']").val();
            let locationAddress = $("input[name='locationAddress']").val();
            let addressName = $("input[name='addressName']").val();
            let phone = $("input[name='phone']").val();
            if(!province || !city || !county || !locationAddress || !addressName || !phone) {
                return "请填写所有必填数据!";
            }
            if(phone) {
                // 验证手机号
                return checkPhone(phone);
            }
        }

        // 初始化方法
        function init() {
            $.ajax({
                url: '../data/areaInfo.json',
                async: false,
                success: function (data) {
                    let areaInfo = data;
                    // 循环筛选数据
                    for (let x in areaInfo) {
                        let proCode = areaInfo[x].code;
                        let proLevel = areaInfo[x].level;
                        let proName = areaInfo[x].name;
                        let province = {
                            "code": proCode,
                            "level": proLevel,
                            "name": proName
                        }
                        provinceJsonInfo.push(province);
                        // 循环市信息
                        let cityArr = areaInfo[x].areaList;
                        for (let c in cityArr) {
                            let cityCode = cityArr[c].code;
                            let cityLevel = cityArr[c].level;
                            let cityName = cityArr[c].name;
                            let city = {
                                "code": cityCode,
                                "level": cityLevel,
                                "name": cityName
                            }
                            cityJsonInfo.push(city);
                            // 循环区县信息
                            let countyArr = cityArr[c].areaList;
                            for (let y in countyArr) {
                                let countyCode = countyArr[y].code;
                                let countyLevel = countyArr[y].level;
                                let countyName = countyArr[y].name;
                                let county = {
                                    "code": countyCode,
                                    "level": countyLevel,
                                    "name": countyName
                                }
                                countyJsonInfo.push(county);
                            }
                        }
                    }
                    // 重新渲染下拉框
                    // 获取显示省份的select元素
                    var provinceSelect = $("#province");
                    provinceSelect.empty();
                    provinceSelect.append(new Option("请选择省份", ""));
                    for (let x in provinceJsonInfo) {
                        provinceSelect.append(new Option(provinceJsonInfo[x].name,
                                            provinceJsonInfo[x].code+"|"+provinceJsonInfo[x].name))
                    }
                    layui.form.render('select');
                }
            });
        }

        // 监听省份下拉框
        form.on('select(province)', function(data){
            // 如果省份code为空, 进行城市下拉框的操作
            if(!provinceCode) {
                provinceCode = data.value;
                console.log(data)
                var citySelect = $("#city");
                var countySelect = $("#county");
                citySelect.empty();
                countySelect.empty();
                citySelect.append(new Option("请选择城市", ""));
                countySelect.append(new Option("请选择县/区", ""));
                for (let x in cityJsonInfo) {
                    if(cityJsonInfo[x].code.substring(0, 2) == data.value.substring(0, 2)) {
                        citySelect.append(new Option(cityJsonInfo[x].name,
                                cityJsonInfo[x].code + "|" + cityJsonInfo[x].name))
                    }
                }
                console.log(citySelect)
                layui.form.render('select');
            } else {
                // 判断本次选择的是否和上次一样, 如果不一样则进行渲染城市下拉框的操作
                if(provinceCode != data.value) {
                    provinceCode = data.value;
                    var citySelect = $("#city");
                    var countySelect = $("#county");
                    citySelect.empty();
                    countySelect.empty();
                    citySelect.append(new Option("请选择城市", ""));
                    countySelect.append(new Option("请选择县/区", ""));
                    for (let x in cityJsonInfo) {
                        if(cityJsonInfo[x].code.substring(0, 2) == data.value.substring(0, 2)) {
                            citySelect.append(new Option(cityJsonInfo[x].name,
                                cityJsonInfo[x].code + "|" + cityJsonInfo[x].name))
                        }
                    }
                    layui.form.render('select');
                }
            }
        });

        // 监听城市下拉框
        form.on('select(city)', function(data){
            // 如果城市code为空, 进行城市下拉框的操作
            if(!cityCode) {
                cityCode = data.value;
                var countySelect = $("#county");
                countySelect.empty();
                countySelect.append(new Option("请选择县/区", ""));
                for (let x in countyJsonInfo) {
                    if(countyJsonInfo[x].code.substring(0, 4) == data.value.substring(0, 4)) {
                        countySelect.append(new Option(countyJsonInfo[x].name,
                                countyJsonInfo[x].code + "|" + countyJsonInfo[x].name))
                    }
                }
                layui.form.render('select');
            } else {
                // 判断本次选择的是否和上次一样, 如果不一样则进行渲染城市下拉框的操作
                if(cityCode != data.value) {
                    cityCode = data.value;
                    var countySelect = $("#county");
                    countySelect.empty();
                    countySelect.append(new Option("请选择县/区", ""));
                    for (let x in cityJsonInfo) {
                        if(countyJsonInfo[x].code.substring(0, 4) == data.value.substring(0, 4)) {
                            countySelect.append(new Option(countyJsonInfo[x].name,
                                countyJsonInfo[x].code + "|" + countyJsonInfo[x].name))
                        }
                    }
                    layui.form.render('select');
                }
            }
        });
    })
</script>
</body>
</html>