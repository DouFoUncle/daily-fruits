let addressId = 0;

/**
 * 切换地址
 */
$("#switchAddress").click(function () {
    let layer = layui.layer;
    // 打开我的地址弹窗
    toWindow("../webAddress/toAddressWindowPage", "我的收货地址",
        "1000px", "650px", true, function() {
            // 获取用户选择的地址信息
            sendAjax("../webAddress/getSwitchAddress", "GET", null,
                function(res) {
                if(res.code == 0) {
                    if(res.data) {
                        // 赋值新选择的地址
                        $("input[name='addressId']").val(res.data.id);
                        $("input[name='addressShort']").val(res.data.addressShort);
                        $("input[name='addressName']").val(res.data.addressName);
                        $("input[name='phone']").val(res.data.phone);
                    }
                }
            })
        });

})

/**
 * 提交订单
 * (结账)
 */
function submitOrder() {
    // 检查是否输入了地址
    let addressId = $("input[name='addressId']").val();
    let addressName = $("input[name='addressName']").val();
    let phone = $("input[name='phone']").val();
    let addressShort = $("input[name='addressShort']").val();
    let locationAddress = $("input[name='locationAddress']").val();
    let provinceNum = $("input[name='provinceNum']").val();
    let cityNum = $("input[name='cityNum']").val();
    let countyNum = $("input[name='countyNum']").val();
    let sendData = {
        "id": addressId,
        "addressName": addressName,
        "phone": phone,
        "addressShort": addressShort,
        "locationAddress": locationAddress,
        "provinceNum": provinceNum,
        "cityNum": cityNum,
        "countyNum": countyNum
    }
    // 检测地址是否合法
    if(!addressId || !addressName || !phone || !addressShort ||
        !locationAddress || !provinceNum || !cityNum || !countyNum) {
        layer.msg("检测到您没有选择合法的地址信息！", {
            timer: 800
        });
        return;
    }
    let load = layer.load(1, {
        shade: 0.2
    })
    // 提交订单信息
    sendAjax("../webOrder/submitCartInfo", "POST", sendData, function(res) {
        console.log(res)
        layer.close(load);
        if(res.code == 0) {
            layer.open({
                title: '温馨提示'
                , content: '支付成功！您的订单火速配送中……'
                , shade: 0.2
                , icon: 6
                , anim: 6
                , closeBtn: 0
                , end: function() {
                    window.location.href = "../webSystem/toWebIndexPage";
                }
            })
        }
    });
}