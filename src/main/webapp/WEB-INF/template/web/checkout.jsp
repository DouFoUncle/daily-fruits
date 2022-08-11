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
</head>
<body>
<div class="noo-spinner">
	<div class="spinner">
		<div class="cube1"></div>
		<div class="cube2"></div>
	</div>
</div>
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
						<h2 class="page-title text-center">Checkout</h2>
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
							<li><a href="../webSystem/toShopPage">商品列表</a></li>
							<li>收银台</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="section section-checkout pt-7 pb-7">
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<h3>收货地址</h3>
						<form>
							<input type="hidden" name="addressId" readonly
								   value="${defaultAddress == null ? ''
											   : defaultAddress.id}">
							<input type="hidden" name="locationAddress" readonly
								   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.locationAddress}">
							<input type="hidden" name="provinceNum" readonly
								   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.provinceNum}">
							<input type="hidden" name="cityNum" readonly
								   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.cityNum}">
							<input type="hidden" name="countyNum" readonly
								   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.countyNum}">
							<div class="row">
								<div class="col-md-6">
									<label>收货人</label>
									<div class="form-wrap">
										<input type="text" readonly name="addressName"
											   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.addressName}" size="40" />
									</div>
								</div>
								<div class="col-md-6">
									<label>手机号</label>
									<div class="form-wrap">
										<input type="text" name="phone" readonly
											   value="${defaultAddress.phone == null ? '未检测到您的地址'
											   : defaultAddress.phone}" size="40" />
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-10">
									<label>收货地址</label>
									<div class="form-wrap">
										<input type="text" name="addressShort" readonly
											   value="${defaultAddress == null ? '未检测到您的地址'
											   : defaultAddress.addressShort}" size="40" />
									</div>
								</div>
								<div class="col-md-2">
									<label style="height: 25px"></label>
									<div class="form-wrap">
										<button type="button" id="switchAddress">
											选择地址
										</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				<div class="row">
					<div class="col-md-12">
						<h3 class="mt-3">订单信息</h3>
						<div class="order-review">
							<table class="checkout-review-order-table">
								<thead>
									<tr>
										<th class="product-total">商品信息</th>
										<th class="product-total">数量</th>
										<th class="product-total">单价</th>
										<th class="product-total">小计</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${cartList}" var="item">
									<tr>
										<td class="product-name">
											&emsp;&emsp;${item.goodsName}&nbsp;<strong class="product-quantity"></strong>
										</td>
										<td class="product-total">
											x ${item.goodsCount}
										</td>
										<td class="product-total">
											¥${item.goodsPrice / 100}
										</td>
										<td class="product-total">
											¥${item.goodsTotal / 100}
										</td>
									</tr>
								</c:forEach>
								</tbody>
								<tfoot>
									<tr>
										<th>商品总价</th>
										<td>-</td>
										<td>-</td>
										<td>¥${(totalPrice + disTotal) / 100}</td>
									</tr>
									<tr>
										<th>配送费</th>
										<td>-</td>
										<td>-</td>
										<td colspan="2">
											<ul id="shipping_method">
												<li>
													<span>¥0.00</span>
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th>税收</th>
										<td>-</td>
										<td>-</td>
										<td>¥0.00</td>
									</tr>
									<tr>
										<th>服务费</th>
										<td>-</td>
										<td>-</td>
										<td>¥0.00</td>
									</tr>
									<tr>
										<th>优惠金额</th>
										<td>-</td>
										<td>-</td>
										<td>¥${disTotal / 100}</td>
									</tr>
									<tr class="order-total">
										<th>总计</th>
										<td>-</td>
										<td>-</td>
										<td><strong>¥${totalPrice / 100}</strong></td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div class="checkout-payment">
<%--							<ul class="payment-method">--%>
<%--								<li>--%>
<%--									<input id="payment_method_cod" type="radio" class="input-radio" name="payment_method" value="cod" checked="checked" data-order_button_text="">--%>
<%--									<span>Cash on delivery</span>--%>
<%--									<div class="payment-box">--%>
<%--										<p>Pay with cash upon delivery.</p>--%>
<%--									</div>--%>
<%--								</li>--%>
<%--								<li>--%>
<%--									<input id="payment_method_paypal" type="radio" class="input-radio" name="payment_method" value="paypal" data-order_button_text="Proceed to PayPal">--%>
<%--									PayPal <img src="../images/payment.jpg" alt="">--%>
<%--								</li>--%>
<%--							</ul>--%>
							<div class="text-right text-center-sm">
								<a class="organik-btn mt-6" href="javascript:;"
								   style="margin-top: 0px !important;" onclick="submitOrder()"> 确认支付 </a>
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
<script src="../lib/layer/layer.js" charset="utf-8"></script>
<script src="../js/MyLayuiUtils.js" charset="utf-8"></script>
<script src="../js/web_js/myWebJs/checkout.js" charset="utf-8"></script>
</body>
</html>