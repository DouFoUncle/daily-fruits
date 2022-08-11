<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>侧边栏公共页</title>
</head>
<body>
    <div class="sidebar">

        <div class="widget widget-product-search">
            <form class="form-search">
                <input type="text" class="search-field" placeholder="搜索商品…" value=""
                       name="goodsName" style="width: 75%; margin-right: 10px"/>
                <input type="hidden" value="1" name="goodsStatus">
                <button type="submit" style="width: 17%; text-align: center; height: 39px; padding: 0;">
                    <i class="ion-search"></i>
                </button>
            </form>
        </div>

        <div class="widget widget-product-categories">
            <h3 class="widget-title">商品分类</h3>
            <ul class="product-categories">
                <c:forEach items="${goodsTypeList}" var="item">
                    <li><a href="../webSystem/toShopPage?goodsTypeId=${item.id}">${item.typeName}</a> <span class="count">${item.goodsCount}</span></li>
                </c:forEach>
            </ul>
        </div>

        <div class="widget widget-products">
            <h3 class="widget-title">随机推荐</h3>
            <ul class="product-list-widget">
                <c:forEach items="${sideGoods}" var="item">
                    <li>
                        <a href="../webSystem/toShopDetailPage?id=${item.id}" style="min-height: 30px">
                            <img src="${projectPath}/upload/${item.goodsHeadImg}" alt="暂无图片"
                                 style="font-size: 14px; font-weight: normal"/>
                            <span class="product-title">${item.goodsName}</span>
                        </a>
                        <c:if test="${item.goodsStock == 0}">
                            <span class="outofstock" style="font-size: 12px; color: crimson">
                                <span>已售尽…</span>补货中…</span>
                        </c:if>
                        <br>
                        <ins class="price<c:if test="${item.disPrice != null}"> delPrice</c:if>">¥${item.goodsPrice / 100}</ins>
                        <c:if test="${item.disPrice != null}"><ins class="price">¥${item.disPrice / 100}</ins></c:if>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</body>
</html>
