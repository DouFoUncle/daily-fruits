<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
<title>果蔬超市</title>

<link rel="stylesheet" href="../css/web_css/bootstrap.min.css" type="text/css" media="all">
<link rel="stylesheet" href="../css/web_css/font-awesome.min.css" type="text/css" media="all" />
<link rel="stylesheet" href="../css/web_css/ionicons.min.css" type="text/css" media="all" />
<link rel="stylesheet" href="../css/web_css/owl.carousel.css" type="text/css" media="all">
<link rel="stylesheet" href="../css/web_css/owl.theme.css" type="text/css" media="all">
<link rel='stylesheet' href='../css/web_css/prettyPhoto.css' type='text/css' media='all'>
<link rel="stylesheet" href="../css/web_css/style.css" type="text/css" media="all">
<link rel="stylesheet" href="../css/web_css/custom.css" type="text/css" media="all">
<link href="http://fonts.googleapis.com/css?family=Great+Vibes%7CLato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
	<script src="http://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="http://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
	<style>
		/* 取消input  number类型的上下箭头 */
		input::-webkit-outer-spin-button,
		input::-webkit-inner-spin-button {
			-webkit-appearance: none;
		}
		input[type="number"]{
			-moz-appearance: textfield;
		}
	</style>
</head>
<body>
<div class="noo-spinner">
	<div class="spinner">
		<div class="cube1"></div>
		<div class="cube2"></div>
	</div>
</div>
<!-- 引入公共的访问时的头部导航条 -->
<%@include file="phoneHeader.jsp"%>
<div class="site">
	<!-- 引入公共头部登陆条 -->
	<%@include file="loginBar.jsp"%>

	<!-- 引入公共的头部导航条 -->
	<%@include file="header.jsp"%>

	<header class="header header-mobile">
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					<div class="header-left">
						<div id="open-left"><i class="ion-navicon"></i></div>
					</div>
				</div>
				<div class="col-xs-8">
					<div class="header-center">
						<a href="#" id="logo-2">
							<img class="logo-image" src="../images/logo.png" alt="Organik Logo" />
						</a>
					</div>
				</div>
				<div class="col-xs-2">
					<div class="header-right">
						<div class="mini-cart-wrap">
							<a href="../webCart/toCartPage">
								<div class="mini-cart">
									<div class="mini-cart-icon" data-count="2">
										<i class="ion-bag"></i>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</header>
	<div id="main">
		<div class="section section-bg-10 pt-11 pb-17">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<h2 class="page-title text-center">Cart</h2>
					</div>
				</div>
			</div>
		</div>
		<div class="section border-bottom pt-2 pb-2">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<ul class="breadcrumbs">
							<li><a href="../webSystem/toWebIndexPage">首页</a></li>
							<li><a href="../webSystem/toShopPage">商城</a></li>
							<li>购物车</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="section pt-7 pb-7">
			<div class="container">
				<div class="row">
					<div class="col-md-8">
						<table class="table shop-cart">
							<tbody>
								<c:forEach items="${cartGoodsInfo}" var="item">
									<tr class="cart_item">
										<td class="product-remove">
											<a href="javascript:;" data-id="${item.id}"
											   data-goodsTotalPrice="${item.goodsTotal}"
											   data-cartTotal="${totalPrice}"
											   class="remove removeCart">×</a>
										</td>
										<td class="product-thumbnail">
											<a href="../webSystem/toShopDetailPage?id=${item.id}">
												<img src="${projectPath}/upload/${item.goodsHeadImg}" alt="暂无图片"/>
											</a>
										</td>
										<td class="product-info">
											<a href="../webSystem/toShopDetailPage?id=${item.id}">${item.goodsName}</a>
											<span class="amount<c:if test="${item.disPrice != null}"> delPrice</c:if>">¥${item.goodsPrice / 100}</span>
											<c:if test="${item.disPrice != null}"><span class="price">¥${item.disPrice / 100}</span></c:if>
										</td>
										<td class="product-quantity">
											<div class="quantity">
												<input type="number" name="number" data-stock="${item.goodsStock}" autocomplete="off"
													   value="${item.goodsCount}" min="1" size="5" data-oldCount="${item.goodsCount}"
													   data-cartId="${item.id}" data-goodsPrice="${item.goodsPrice}"
													   data-goodsTotal="${totalPrice}" data-disPrice="${item.disPrice}"
													   class="input-text qty text goodsCount" style="border: 1px solid #DDD">
											</div>
										</td>
										<td class="product-subtotal">
											<span class="amount oneTotal">¥${item.disTotal != null ? item.disTotal / 100 : item.goodsTotal / 100}</span>
										</td>
									</tr>
								</c:forEach>
								<tr>
									<td colspan="5" class="actions">
<%--										<a class="continue-shopping" href="javascript:;" --%>
<%--										   onclick="window.location.reload();">更新购物车</a>--%>
										<input type="button" class="update-cart"
											   style="background-color: #5fbd74;color: #FFF;" onclick="window.location.href = '../webSystem/toShopPage'"
											   name="update_cart" value="继续购物" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="col-md-4">
						<div class="cart-totals">
							<table>
								<tbody>
									<tr class="cart-subtotal">
										<th>商品价格</th>
										<td id="cartGoodsTotal">¥${totalPrice / 100}</td>
									</tr>
									<tr class="shipping">
										<th>配送费</th>
										<td>免费</td>
									</tr>
									<tr class="order-total">
										<th>总计</th>
										<td id="cartTotal"><strong>¥${totalPrice / 100}</strong></td>
									</tr>
								</tbody>
							</table>
							<div class="proceed-to-checkout" style="margin-top: 155px">
								<a href="javascript:;" id="goToPay" onclick="goToPay('goToPay')"
								   data-totalCount="${cartGoodsInfo.size()}">去结账</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@include file="footer.jsp"%>
</div>

<script type="text/javascript" src="../js/jquery.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery-migrate.min.js"></script>
<script type="text/javascript" src="../js/web_js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/web_js/modernizr-2.7.1.min.js"></script>
<script type="text/javascript" src="../js/web_js/owl.carousel.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.countdown.min.js"></script>
<script type='text/javascript' src='../js/web_js/jquery.prettyPhoto.js'></script>
<script type='text/javascript' src='../js/web_js/jquery.prettyPhoto.init.min.js'></script>
<script type="text/javascript" src="../js/web_js/script.js"></script>
<script type="text/javascript" src="../js/lib/layui/layui.js"></script>
<script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
<script type="text/javascript" src="../js/web_js/myWebJs/cart.js"></script>
</body>
</html>