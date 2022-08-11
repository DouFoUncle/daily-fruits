/**
 * 去结账
 */
function goToPay(idName) {
    let layer = layui.layer;
    let goToPay = document.getElementById(idName);
    let totalCount = goToPay.getAttribute("data-totalCount");
    if(totalCount <= 0) {
        layer.msg('购物车没有可以结账的商品哦！', {
            timer: 1000
        })
    } else {
        window.location.href = '../webCheckout/toCheckoutPage';
    }
}

/**
 * 删除某条信息
 */
$(".removeCart").click(function() {
    let id = $(this).attr("data-id");
    let totalPrice = parseInt($(this).attr("data-cartTotal"));
    let goodsTotalPrice = parseInt($(this).attr("data-goodsTotalPrice"));
    $(this).parent().parent().remove();
    // 执行删除
    sendAjax("../webCart/deleteInfo?id=" + id,
        "GET", null,
        function(res) {
            if(res.code == 0) {
                // 删除本条信息
                $(this).remove();
                // 更新总计
                $("#cartGoodsTotal").text("¥" + (totalPrice - goodsTotalPrice) / 100);
                $("#cartTotal").text("¥" + (totalPrice - goodsTotalPrice) / 100);
                // 更新购物车展示的价格
                layer.msg(res.msg, {
                    timer: 800
                })
            }
    })
})

/**
 * 小购物袋中删除
 * @param event
 */
function deleteInfo(event) {
    event.stopPropagation();
    let dom = $(event.target);
    let delId = dom.attr("data-id");
    dom.parent().parent().remove();
    let liCount = $(".cart-list li").length;
    let ulHtml = $(".cart-list");
    let parent = $(".widget-shopping-cart-content");
    if(liCount == 0 || !liCount) {
        ulHtml.append("<div style='height: 160px; text-align: center'>\n" +
            "              <div style='margin-top: 30px'>\n" +
            "                  <img src='../images/web_img/open.png' alt='' width='80'>\n" +
            "              </div>\n" +
            "              <div style='margin-top: 15px'>\n" +
            "                   啊哦！购物车空空如也……\n" +
            "              </div>\n" +
            "          </div>")
        // 动态加入生成好的ul列表标签
        parent.empty();
        parent.append(ulHtml);
    }
    // 执行删除
    sendAjax("../webCart/deleteInfo?id=" + delId,
        "GET", null,
        function(res) {
            let data = res.data;
            console.log(res);
            let totalPrice = parseInt(data.totalPrice);
            let cartListCount = data.cartListCount;
            console.log(totalPrice)
            console.log(cartListCount)
            if(res.code == 0) {
                // 删除本条信息
                $(this).remove();
                $("#cartTips").attr("data-count", cartListCount);
                $("#headTotal").text("¥" + totalPrice / 100);
                layer.msg(res.msg, {
                    timer: 800
                })
            }
        })
}

/**
 * 为购物车数量框绑定改变事件
 */
$("input[name='number']").change(function() {
    let val = $(this).val();
    let oldCount = parseInt($(this).attr("data-oldCount"));
    let goodsStock = parseInt($(this).attr("data-stock"));
    let cartId = parseInt($(this).attr("data-cartId"));
    let goodsPrice = parseInt($(this).attr("data-goodsPrice"));
    let disPrice = parseInt($(this).attr("data-disPrice"));
    let goodsTotal = parseInt($(this).attr("data-goodsTotal"));
    let oneTotal = $(this).parent().parent().next().find("span");
    // val为null代表输入的数字不合法
    if(val) {
        // 查看输入的数量是否大于库存
        if(val > goodsStock) {
            layer.msg("当前商品的库存没有这么多啦！", {
                timer: 800
            })
            $(this).val(oldCount);
            return;
        }
        // 数量没问题, 更新购物车信息
        let jsonObj = {
            "id": cartId,
            "goodsCount": val,
            "goodsTotal": goodsPrice * val
        }
        sendAjax("../webCart/updateInfo",
            "PUT",
            jsonObj,
            function(res) {
                if(res.code == 0) {
                    // 更新小计
                    let newTotal = undefined;
                    if(disPrice) {
                        oneTotal.text("¥" + disPrice * val / 100);
                        newTotal = goodsTotal - oldCount * disPrice + val * disPrice;
                    } else {
                        oneTotal.text("¥" + goodsPrice * val / 100);
                        newTotal = goodsTotal - oldCount * goodsPrice + val * goodsPrice;
                    }
                    // 更新总计
                    $("#cartGoodsTotal").text("¥" + newTotal / 100);
                    $("#cartTotal").text("¥" + newTotal / 100);
                } else {
                    layer.msg(res.msg, {
                        timer: 800
                    })
                }
            })
    }
})
