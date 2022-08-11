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
						<h2 class="page-title text-center">
							<c:if test="${type eq 'order'}">
								Me-Order
							</c:if>
							<c:if test="${type eq 'address'}">
								Me-Address
							</c:if>
						</h2>
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
							<c:if test="${type eq 'order'}">
							<li>个人中心 - 我的订单</li>
							</c:if>
							<c:if test="${type eq 'address'}">
							<li>个人中心 - 我的收货地址</li>
							</c:if>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="section pt-7 pb-7">
			<div class="container" style="width: 1366px">
				<div class="row">
					<div class="col-md-10 col-md-push-3" style="left: 20%">
						<div class="product-grid">
							<c:if test="${type eq 'order'}">
								<iframe src="toMeOrderPage" id="myIframe" height="700" frameborder="0"
										scrolling="no"></iframe>
							</c:if>
							<c:if test="${type eq 'address'}">
								<iframe src="toMeAddressPage" id="myIframe" height="700" frameborder="0"
										scrolling="no"></iframe>
							</c:if>
						</div>
					</div>

					<div class="col-md-2 col-md-pull-9" style="right: 80%">
						<div class="sidebar">
							<div class="widget widget-product-categories">
								<h3 class="widget-title">操作菜单</h3>
								<ul class="product-categories">
									<li><a href="../webMe/toMePage?type=order"
										   <c:if test="${type eq 'order'}">
										   	   style="color: #5fbd74;"
										   </c:if>>我的订单</a></li>
									<li><a href="../webMe/toMePage?type=address"
											<c:if test="${type eq 'address'}">
												style="color: #5fbd74;"
											</c:if>>收货地址</a></li>
								</ul>
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

<script type="text/javascript" src="../js/web_js/core.min.js"></script>
<script type="text/javascript" src="../js/web_js/widget.min.js"></script>
<script type="text/javascript" src="../js/web_js/mouse.min.js"></script>
<script type="text/javascript" src="../js/web_js/slider.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.ui.touch-punch.js"></script>
<script type="text/javascript" src="../js/web_js/price-slider.js"></script>
<script src="../lib/layui/layui.js" charset="utf-8"></script>
<script src="../js/MyLayuiUtils.js" charset="utf-8"></script>
</body>
</html>