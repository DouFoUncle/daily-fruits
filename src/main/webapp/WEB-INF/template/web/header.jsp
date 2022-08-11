<%--
  Created by IntelliJ IDEA.
  User: byqs
  Date: 2022/2/20
  Time: 14:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>头部导航条</title>
</head>
<body>
<header id="header" class="header header-desktop header-2">
    <div class="top-search">
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <form>
                        <input type="search" class="top-search-input" name="s" placeholder="What are you looking for?" />
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <a href="../webSystem/toWebIndexPage" id="logo">
                    <img class="logo-image" src="../images/logo.png" alt="Organik Logo" />
                </a>
            </div>
            <div class="col-md-9">
                <div class="header-right">
                    <nav class="menu">
                        <ul class="main-menu">
                            <li><a href="../webSystem/toWebIndexPage">首页</a></li>
                            <li><a href="../webSystem/toShopPage">商城</a></li>
                            <li><a href="../webCart/toCartPage">购物车</a></li>
                            <c:if test="${sessionScope.webUserInfo != null}">
                                <li><a href="../webMe/toMePage">个人中心</a></li>
                            </c:if>
<%--                            <li><a href="../webSystem/toContactPage">联系我们</a></li>--%>
                            <li><a href="../system/toAdminLoginPage" target="_blank">网站后台</a></li>
                        </ul>
                    </nav>
                    <c:if test="${isCartPage == null}">
                        <div class="btn-wrap">
                            <div class="mini-cart-wrap">
                                <div class="mini-cart">
                                    <div class="mini-cart-icon" id="cartTips"
                                         data-count="${sessionScope.cartListCount != null ?
                                                       sessionScope.cartListCount : 0}">
                                        <i class="ion-bag"></i>
                                    </div>
                                </div>
                                <div class="widget-shopping-cart-content">

                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</header>
</body>
<script src="../js/jquery.min.js" charset="utf-8"></script>
<script src="../lib/layer/layer.js" charset="utf-8"></script>
<script src="../js/MyLayuiUtils.js" charset="utf-8"></script>
<script>
    jQuery(function($$) {
        var isOpenCart = false;

        // 响应点击购物袋图标的点击事件
        $$(".mini-cart").on("click", function(e) {
            e.stopPropagation();
            $$(".mini-cart-wrap").toggleClass('open');
            cartTopDistance();
            let isShow = $$(".cart-list").css("visibility");
            if(!isOpenCart && (isShow == 'hidden' || !isShow)) {
                // 用EL表达式取出保存在session中的登录信息, 如果为null代表还未登陆
                let isLogin = ${sessionScope.webUserInfo == null};
                let parent = $$(".widget-shopping-cart-content");
                parent.empty();
                if(isLogin) {
                    parent.append("<div style='width: 370px; height: 160px; text-align: center'>\n" +
                        "              <div style='margin-top: 30px'>\n" +
                        "                  <img src='../images/web_img/open.png' alt='' width='80'>\n" +
                        "              </div>\n" +
                        "              <div style='margin-top: 15px'>\n" +
                        "                   您还未登录！请先" +
                        "                   <a href='../webSystem/toLoginPage/login'\n" +
                        "                      style='text-decoration: underline; color: #00A8FF;'> 登录……</a>\n" +
                        "              </div>\n" +
                        "          </div>")
                } else {
                    // Ajax请求购物车数据信息
                    sendAjax("../webCart/getInfoByUserId", "GET", null, function(res) {
                        if(res.code == 0) {
                            let cartData = res.data.cartList;
                            let totalPrice = res.data.totalPrice;
                            let disTotal = res.data.disTotal;
                            let ulHtml = $$('<ul class="cart-list"></ul>');
                            if(cartData && cartData.length > 0) {
                                for (let i = 0; i < cartData.length; i++) {
                                    let disPriceDom = '';
                                    let goodsPriceDom = '       <span>¥' + cartData[i].goodsPrice / 100 + '</span>';
                                    if(cartData[i].disPrice) {
                                        disPriceDom = '<span>¥' + cartData[i].disPrice / 100 + '</span>'
                                        goodsPriceDom = '       <span class="delPrice">¥' + cartData[i].goodsPrice / 100 + '</span>&nbsp;';
                                    }
                                    let liHtml = '\n' +
                                        '<li>\n' +
                                        '   <span><a href="javascript:;" data-id="' + cartData[i].id + '"' +
                                        '      data-goodsTotalPrice="'+cartData[i].goodsTotal+'"' +
                                        '      data-cartTotal="' + totalPrice + '"' +
                                        '      class="remove" onclick="deleteInfo(event)">×</a></span>\n' +
                                        '   <a href="../webSystem/toShopDetailPage?id=' + cartData[i].goodsId + '"' +
                                        '       style="font-size: 14px; font-weight: 400">\n' +
                                        '       <img src="' + cartData[i].goodsHeadImg + '"' +
                                        '        alt="暂无图片" />\n' + cartData[i].goodsName + '' +
                                        '   </a>\n' +
                                        '   <span class="quantity">' + cartData[i].goodsCount + ' x ' +
                                            goodsPriceDom + disPriceDom +
                                        '   </span>\n' +
                                        '</li>\n';
                                    ulHtml.append(liHtml);
                                }
                                // 动态加入生成好的ul列表标签
                                parent.append(ulHtml);
                                let totalPriceDom = '  <span id="headTotal" style="width: 54%">¥' + totalPrice / 100 + '</span>';
                                let disTotalDom = '';
                                if(disTotal) {
                                    totalPriceDom = '  <span class="delPrice" id="headTotal">¥' + (totalPrice + disTotal) / 100 + '</span> &nbsp;';
                                    disTotalDom = '  <span id="headTotal">¥' + totalPrice / 100 + '</span>';
                                }
                                let pHtml = '' +
                                    '<p class="total">\n' +
                                    '  <strong>总计:</strong>\n' +
                                      totalPriceDom + disTotalDom +
                                    '</p>\n' +
                                    '<p class="buttons">\n' +
                                    '  <a href="../webCart/toCartPage" class="view-cart">前往购物车</a>\n' +
                                    '  <a href="javascript:;" onclick="goToPay(\'headPay\')" id="headPay"' +
                                    '     data-totalCount="'+cartData.length+'"' +
                                    '     class="checkout">全部结算</a>\n' +
                                    '</p>';
                                // 动态加入P标签
                                parent.append(pHtml);
                            } else {
                                ulHtml.append("<div style='height: 160px; text-align: center'>\n" +
                                    "              <div style='margin-top: 30px'>\n" +
                                    "                  <img src='../images/web_img/open.png' alt='' width='80'>\n" +
                                    "              </div>\n" +
                                    "              <div style='margin-top: 15px'>\n" +
                                    "                   啊哦！购物车空空如也……\n" +
                                    "              </div>\n" +
                                    "          </div>")
                                // 动态加入生成好的ul列表标签
                                parent.append(ulHtml);
                            }
                        }
                    })
                }
            }
        })
    })
</script>
<script src="../js/web_js/myWebJs/cart.js" charset="utf-8"></script>
</html>
