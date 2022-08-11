// 标记，防止表单重复提交
var lock = true;

/**
 * 为按钮绑定单击事件，打开弹窗
 * @param url       跳转的控制器
 * @param title     窗口标题
 * @param width     窗口宽度(例如：200px)
 * @param height    窗口高度(例如：200px)
 * @param isClose   点击窗体外是否关闭 默认false
 * @param endFunc   弹窗关闭后的响应事件
 */
function toWindow(url, title, width, height, isClose, endFunc) {
    let openObj = {
        type: 2,
        title: title,
        shadeClose: isClose,
        shade: 0.3,
        // maxmin: true, //开启最大化最小化按钮
        area: [width, height],
        content: url,
        // skin: 'layui-layer-lan'
    };
    if(endFunc) {
        openObj.end = endFunc;
    }
    layer.open(openObj);
};

/**
 * 为查询按钮绑定单击事件，打开弹窗(适用于头部工具条)
 * @param count     选中的数量
 * @param title     窗口标题
 * @param url       跳转的控制器
 * @param width     窗口宽度
 * @param height    窗口高度
 */
function findInfo(count, title, url, width, height) {
    if (count == 0) {
        layer.open({
            title: '错误消息'
            , content: '请先选择一条信息再进行操纵！'
            // , skin: 'layui-layer-lan'
            , shade: 0.1
            , icon: 5
            , anim: 6
            , closeBtn: 0
        })
    } else if (count > 1) {
        layer.open({
            title: '错误消息'
            , content: '您只可选中一条信息操纵！'
            // , skin: 'layui-layer-lan'
            , shade: 0.1
            , icon: 5
            , anim: 6
            , closeBtn: 0
        })
    } else {
        layer.open({
            type: 2,
            title: title,
            shadeClose: true,
            shade: 0.3,
            // maxmin: true, //开启最大化最小化按钮
            area: [width, height],
            content: url,        //跳转至控制器处理
            // skin: 'layui-layer-lan'
        });
    }
};

/**
 * 为查询按钮绑定单击事件，打开弹窗(适用于行内工具条)
 * @param title     窗口标题
 * @param url       跳转的控制器
 * @param width     窗口宽度
 * @param height    窗口高度
 */
function findInfoLineTool(title, url, width, height) {
    layer.open({
        type: 2,
        title: title,
        shadeClose: true,
        shade: 0.3,
        // maxmin: true, //开启最大化最小化按钮
        area: [width, height],
        content: url,        //跳转至控制器处理
        // skin: 'layui-layer-lan'

    });
};

/**
 * 获取选中ID
 * 处理传入的所有数据的数组，获取数据中的ID
 * @param dataArray
 * @returns {*}
 */
function getIds(dataArray) {
    var resultIds = -1;
    if (dataArray.length == 1) {           //如果获取的选中行只有一行，直接获取数组第一个的ID
        resultIds = dataArray[0].id;
        return resultIds;
    } else if (dataArray.length == 0) {     //如果选中行为0，返回-1
        return resultIds;
    } else if (dataArray.length > 1) {      //如果选中行大于1行，可能是删除，循环处理选中ID
        $.each(dataArray, function () {
            var data = $(this).get(0);
            resultIds += data.id + ",";
        });
        //如果flag已经不再是-1，就将前面的-1截取掉，同时截掉最后一个逗号
        if (resultIds != -1) {
            resultIds = resultIds.substring(2, resultIds.length - 1);
        }
        return resultIds;
    }
}

/**
 * 获取选中ID(加单引号)
 * 处理传入的所有数据的数组，获取数据中的ID
 * @param dataArray
 * @returns {*}
 */
function getIdsAddSymbol(dataArray) {
    var resultIds = -1;
    if (dataArray.length == 1) {           //如果获取的选中行只有一行，直接获取数组第一个的ID
        resultIds = "'" + dataArray[0].id + "'";
        return resultIds;
    } else if (dataArray.length == 0) {     //如果选中行为0，返回-1
        return resultIds;
    } else if (dataArray.length > 1) {      //如果选中行大于1行，可能是删除，循环处理选中ID
        $.each(dataArray, function () {
            var data = $(this).get(0);
            resultIds += "'" + data.id + "',";
        });
        //如果flag已经不再是-1，就将前面的-1截取掉，同时截掉最后一个逗号
        if (resultIds != -1) {
            resultIds = resultIds.substring(2, resultIds.length - 1);
        }
        return resultIds;
    }
}

/**
 * 发起带提示的请求
 * @param count
 * @param msg
 * @param method
 * @param jsonObj
 * @param iconNum
 * @param url
 * @param isMethod   true调用传递JSON对象的Ajax请求  false调用拼接URL的Ajax请求
 * @param isRefreshParent   是否刷新父页面  默认不刷新
 */
function promptRequest(count, method, url, msg, iconNum, isMethod, jsonObj, isRefreshParent) {
    msg = !msg ? "真的要删除所选信息吗？" : msg;
    iconNum = !iconNum ? 5 : iconNum;
    method = !method ? "GET" : method;
    if (count == 0) {
        layer.open({
            title: '错误消息'
            , content: '请先选择一条信息再进行操纵！'
            // , skin: 'layui-layer-lan'
            , shade: 0.1
            , icon: 5
            , anim: 6
            , closeBtn: 0
        })
    } else {
        if (lock) {
            lock = false;
            layer.confirm(msg, {
                btn: ['确定', '取消'] //按钮
                , shade: 0.1
                , icon: iconNum
                , anim: 6
                , closeBtn: 0
            }, function () { //确定
                // 调用异步删除方法
                if(isMethod) {
                    sendJsonObjRequest(method, url, jsonObj, isRefreshParent);
                } else {
                    sendUrlRequest(method, url, isRefreshParent);
                }
            }, function () { //取消
                lock = true;
                layer.msg('取消操作！', {
                    icon: 6
                    , time: 2000
                });
            })
        }
    }
}

/**
 * 发起Ajax请求 (传递JSON对象)
 * @param method
 * @param url
 * @param data
 * @param isRefreshParent       是否刷新父页面
 */
function sendJsonObjRequest(method, url, jsonObj, isRefreshParent) {
    $.ajax({
        url: url,
        type: method,
        async: false,
        contentType : 'application/json;charset=utf-8', //设置请求头信息
        data: JSON.stringify(jsonObj),
        success: function(rollData) {
            if (rollData.code == "0") {
                layer.confirm(rollData.msg, {
                    btn: ['确定']  //按钮
                    , icon: 6
                }, function () {
                    if(isRefreshParent) {
                        window.parent.location.reload();    //刷新父页面
                    } else {
                        window.location.reload();
                    }
                });
            } else if(rollData.code == "207") {
                layer.confirm(rollData.msg, {
                    btn: ['确定']  //按钮
                    , icon: 7
                    , anim: 6
                }, function (index) {
                    lock = true;
                    layer.close(index);
                });
            } else {
                layer.confirm(rollData.msg, {
                    btn: ['确定']  //按钮
                    , icon: 5
                    , anim: 6
                }, function (index) {
                    lock = true;
                    layer.close(index);
                });
            }
        },
        error: function(res) {
            layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                btn: ['确定']  //按钮
                , icon: 5
                , anim: 6
            }, function (index) {
                lock = true;
                layer.close(index);
            });
        }
    })

}

/**
 * 发起Ajax请求 (参数拼接URL)
 * @param method
 * @param url
 * @param isRefreshParent   是否刷新父页面
 */
function sendUrlRequest(method, url, isRefreshParent) {
    $.ajax({
        url: url,
        type: method,
        async: false,
        success: function(rollData) {
            if (rollData.code == "0") {
                layer.confirm(rollData.msg, {
                    btn: ['确定']  //按钮
                    , icon: 6
                }, function () {
                    if(isRefreshParent) {
                        window.parent.location.reload();    //刷新父页面
                    } else {
                        window.location.reload();
                    }
                });
            } else {
                layer.confirm(rollData.msg, {
                    btn: ['确定']  //按钮
                    , icon: 5
                    , anim: 6
                }, function (index) {
                    lock = true;
                    layer.close(index);
                });
            }
        },
        error: function(res) {
            layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                btn: ['确定']  //按钮
                , icon: 5
                , anim: 6
            }, function (index) {
                lock = true;
                layer.close(index);
            });
        }
    })

}

/**
 * 渲染一个图片层
 */
function createPhotos(photosData) {
    layer.photos({
        photos: photosData
        ,anim: 5
    });
}

/**
 * 绑定回车事件
 */
$(document).keypress(function (e) {
    //如果当前有类似layer.alert的窗体，点击最上层的确定按钮，并且取消所有焦点
    if ($('.layui-layer-btn0').length > 0) {
        $('.layui-layer-btn0').eq($('.layui-layer-btn0').length - 1)[0].click();
        $("*").blur();
    }
});

/**
 * 导出方法
 * (利用layui的内置导出方法)
 * @param title     表格标题
 * @param data      导出的数据
 * @param type      导出类型(支持：csv和xls两种)
 */
function exportExcelFile(title, data, type) {
    layui.use(['table'], function () {
        var table = layui.table;
        table.exportFile(title, data, type);
    })
}

/**
 * 处理导出时的表头, 将被隐藏的表头筛选
 * 如果表格中有复选框推荐使用 handleTitleDataRemoveCheckbox 方法
 * @param tHead     表头的原生对象(该对象应该是一个数组)
 */
function handleTitleData(tHead) {
    var title = new Array(0);
    // 循环处理表头信息
    for (i = 0; i < tHead.length; i++) {
        // 没有被隐藏
        if (!$(tHead[i]).is(':hidden') && $(tHead[i]).text() != "操作") {
            // 将没有被隐藏的表头加入标题数组中
            title.push($(tHead[i]).text());
        }
    }
    return title;
}

/**
 * 获取表头的data-field属性值
 * 该方法是为了除去表格中的复选框列
 * @param tHead     表头的原生对象(该对象应该是一个数组)
 */
function handleTitleDataRemoveCheckbox(tHead) {
    var title = new Array(0);
    // 循环处理表头信息
    for (i = 0; i < tHead.length; i++) {
        // 没有被隐藏
        if (!$(tHead[i]).is(':hidden') && $(tHead[i]).attr("data-field") != 0 && $(tHead[i]).text() != "操作") {
            // 将没有被隐藏的表头加入标题数组中
            title.push($(tHead[i]).text());
        }
    }
    return title;
}

/**
 * 验证是否有数据可以导出
 * @param exportData
 * @returns {boolean}
 */
function verifyExport(exportData) {
    if (!exportData || exportData.length == 0) {
        layer.open({
            title: '错误消息'
            , content: '抱歉…未找到可以导出的数据！'
            // , skin: 'layui-layer-lan'
            , shade: 0.1
            , icon: 5
            , anim: 6
            , closeBtn: 0
        });
        return false;
    }
    return true;
}

/**
 * Ajax请求出错时进行的提示
 */
$(document).ajaxError(function(event,request, settings){
    layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
        btn: ['确定']  //按钮
        // , skin: 'layui-layer-lan'
        , icon: 5
        , anim: 6
    }, function (index) {
        luck = true;
        layer.close(index);
    });
})

/**
 * 提示窗口
 */
function tips() {
    layer.open({
        title: '消息提示'
        , content: '如需修改直接单击要修改的数据的单元格就可开始修改哦！' +
            '<span style="color: #FF5722;">修改价格时需要注意输入的单位为分而不是元！</span>'
        // , skin: 'layui-layer-lan'
        , shade: 0.1
        , icon: 7
        , closeBtn: 0
    });
}

/**
 * 常用的错误弹窗提示
 */
function errorAlert(content, shade, closeBtn) {
    closeBtn = !closeBtn ? 0 : closeBtn;
    shade = !shade ? 0.1 : shade;
    content = !content ? "出现错误啦! " : content
    lock = true;
    layer.open({
        title: '错误消息'
        , content: content
        , shade: shade
        , icon: 5
        , anim: 6
        , closeBtn: closeBtn
    })
}

/**
 * 初始化一个穿梭框组件
 * @param transfer              Layui的穿梭框对象(transfer模块)
 * @param elemId                要绑定生成穿梭框的DOM元素
 * @param title                 标题, 数组格式, 例如：['活动列表', '已配置的活动']
 * @param leftData              穿梭框左侧展示的数据
 * @param rightData             穿梭框右侧展示的数据
 * @param id                    索引ID
 * @param width                 宽度, 默认 200
 * @param search                是否显示搜索框 true OR false
 * @param height                高度, 默认 360
 */
function createTransfer(transfer, elemId, title, leftData, rightData, id, width, height, search) {
    width = !width ? 200 : width;
    height = !height ? 360 : height;
    transfer.render({
        elem: elemId    //绑定元素
        , title: title
        , data: leftData
        , id: id         //定义索引
        , width: width
        , value: rightData
        , showSearch: search
        , height: height
    });
}

/**
 * 获取项目根目录
 * @returns {string}
 */
function getPath() {
    //获取项目路径
    var curRequestPath = window.document.location.href;
    //获取项目请求路径
    var pathName = window.document.location.pathname;
    var ipAndPort = curRequestPath.indexOf(pathName);
    var localhostPath = curRequestPath.substring(0,ipAndPort);
    var projectName = pathName.substring(0,pathName.substr(1).indexOf('/')+1);
    basePath = localhostPath + projectName;
    return basePath;
}

/**
 * 发送请求
 * @param url           请求地址
 * @param method        请求方式
 * @param jsonObj       请求参数
 * @param rollFunc      回调函数(可以为空)
 */
function sendAjax(url, method, jsonObj, rollFunc) {
    let sendObj = {
        url: url,
        type: method,
        async: false,
        success: function (res) {
            if(rollFunc) {
                rollFunc(res)
            } else {
                layer.msg(res.msg, {
                    timer: 1000
                })
            }
        },
        error: function (res) {
            layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                btn: ['确定']  //按钮
                , icon: 5
                , anim: 6
            }, function (index) {
                lock = true;
                layer.closeAll();
                layer.close(index);
            });
        }
    }
    if(jsonObj) {
        sendObj.data = JSON.stringify(jsonObj);
        sendObj.contentType = 'application/json;charset=utf-8'; //设置请求头信息
    }
    $.ajax(sendObj)
}

// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证身份证号 Start ------------------------------
// -----------------------------------------------------------------------------------------

/**
 * 验证身份证号
 * @param val
 * @returns {string}
 */
function checkID(val) {
    if(checkCode(val)) {
        var date = val.substring(6,14);
        if(checkDate(date)) {
            if(checkProvince(val.substring(0,2))) {
                return "";
            }
        }
    }
    return "身份证输入格式有误！";
}

/**
 * 验证校验码
 * @param val
 * @returns {boolean}
 */
function checkCode(val) {
    var p = /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
    var factor = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];
    var parity = [ 1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2 ];
    var code = val.substring(17);
    if(p.test(val)) {
        var sum = 0;
        for(var i=0;i<17;i++) {
            sum += val[i]*factor[i];
        }
        if(parity[sum % 11] == code.toUpperCase()) {
            return true;
        }
    }
    return false;
}

/**
 * 验证日期是否合法
 * @param val
 * @returns {boolean}
 */
function checkDate(val) {
    var pattern = /^(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)$/;
    if(pattern.test(val)) {
        var year = val.substring(0, 4);
        var month = val.substring(4, 6);
        var date = val.substring(6, 8);
        var date2 = new Date(year+"-"+month+"-"+date);
        if(date2 && date2.getMonth() == (parseInt(month) - 1)) {
            return true;
        }
    }
    return false;
}

/**
 * 验证省份编号是否正确
 * @param val
 * @returns {boolean}
 */
function checkProvince(val) {
    var pattern = /^[1-9][0-9]/;
    var provs = {11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江 ",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北 ",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏 ",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门"};
    if(pattern.test(val)) {
        if(provs[val]) {
            return true;
        }
    }
    return false;
}
// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证身份证号 End --------------------------------
// -----------------------------------------------------------------------------------------



// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证手机号码 Start ------------------------------
// -----------------------------------------------------------------------------------------
/**
 * 验证手机号
 * @param phoneNum
 * @returns {string}
 */
function checkPhone(phoneNum) {
    // 手机号正则
    var rePhone = /^1[3456789]\d{9}$/;
    if(!phoneNum) {
        return "请填写完整信息";
    } else if(!rePhone.test(phoneNum)) {
        return "手机号格式有误！"
    }
}
// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证手机号码 End --------------------------------
// -----------------------------------------------------------------------------------------


// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证数字 Start ------------------------------
// -----------------------------------------------------------------------------------------
/**
 * 验证是否是正整数
 * @param number
 * @param isZero        是否可以为0
 * @returns {string}
 */
function checkInt(number, isZero) {
    // 正整数正则
    var reNumber = /^[0-9]+$/;
    if(!isZero) {
        reNumber = /^[1-9]+$/;
    }
    if(!number) {
        return "请填写完整信息";
    } else if(!reNumber.test(number)) {
        return "请输入正确的正整数！"
    }
}

/**
 * 验证是否是正数(包括小数和0)
 * @param number
 * @param isZero        是否可以为0
 * @returns {string}
 */
function checkNumber(number, isZero) {
    // 正整数正则
    var reNumber = /^\d+(\.\d+)?$/;
    if(!number) {
        return "请填写完整信息";
    } else if(!reNumber.test(number)) {
        return "请输入正确的正数！"
    } else if(!isZero && number == 0) {
        return "不可以输入0哦！"
    }
}
// -----------------------------------------------------------------------------------------
// -------------------------------------- 正则验证数字 End --------------------------------
// -----------------------------------------------------------------------------------------