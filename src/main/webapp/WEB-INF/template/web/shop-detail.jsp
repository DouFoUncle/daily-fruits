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
<link rel='stylesheet' href='../css/web_css/slick.css' type='text/css' media='all'>
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
						<h2 class="page-title text-center">Shop Detail</h2>
					</div>
				</div>
			</div>
		</div>
		<div class="section border-bottom pt-2 pb-2">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<ul class="breadcrumbs">
							<li><a href="../webSystem/toWenIndexPage">首页</a></li>
							<li><a href="../webSystem/toShopPage">商品列表</a></li>
							<li>商品详情</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="section pt-7 pb-7">
			<div class="container">
				<div class="row">
					<div class="col-md-9 col-md-push-3">
						<div class="single-product">
							<div class="col-md-6">
								<div class="image-gallery">
									<div class="image-gallery-inner">
										<c:forEach items="${imgList}" var="item">
											<div>
												<div class="image-thumb">
													<a href="" data-rel="prettyPhoto[gallery]">
														<img src="${projectPath}/upload/${item}" alt="暂无图片" />
													</a>
												</div>
											</div>
										</c:forEach>
										<c:if test="${imgList.size() == 0}">
											<div>
												<div class="image-thumb">
													<a href="" data-rel="prettyPhoto[gallery]">
														<img src="#" alt="暂无图片" />
													</a>
												</div>
											</div>
										</c:if>
									</div>
								</div>
								<div class="image-gallery-nav">
									<c:forEach items="${imgList}" var="item">
										<div class="image-nav-item">
											<div class="image-thumb">
												<img src="${projectPath}/upload/${item}" alt="暂无图片" />
											</div>
										</div>
									</c:forEach>
									<c:if test="${imgList.size() == 0}">
										<div class="image-nav-item">
											<div class="image-thumb">
												<img src="#" alt="暂无图片" />
											</div>
										</div>
										<div class="image-nav-item">
											<div class="image-thumb">
												<img src="#" alt="暂无图片" />
											</div>
										</div>
									</c:if>
								</div>
							</div>
							<div class="col-md-6">
								<div class="summary">
									<h1 class="product-title">${goodsInfo.goodsName}</h1>
									<div class="product-price">
										<ins class="price<c:if test="${goodsInfo.disPrice != null}"> delPrice</c:if>">¥${goodsInfo.goodsPrice / 100}</ins>
										<c:if test="${goodsInfo.disPrice != null}"><ins class="price">¥${goodsInfo.disPrice / 100}</ins></c:if>
									</div>
									<form class="cart" style="padding: 40px 0 0 0; margin-bottom: 40px">
										<div class="quantity-chooser">
											<div class="quantity">
												<span class="qty-minus" data-min="1"><i class="ion-ios-minus-outline"></i></span>
												<input type="text" name="goodsNumber" value="1" title="Qty" class="input-text qty text" size="4">
												<span class="qty-plus" data-max=""><i class="ion-ios-plus-outline"></i></span>
											</div>
										</div>
										<input type="hidden" name="stock" value="${goodsInfo.goodsStock}">
										<input type="hidden" name="goodsId" value="${goodsInfo.id}">
										<button type="button" id="addCart" class="single-add-to-cart">${goodsInfo.goodsStock <= 0 ? '已售尽' : '加入购物车'}</button>
									</form>
									<div class="product-meta" style="padding-bottom: 40px; margin-top: 40px">
										<table>
											<tbody>
												<tr>
													<td class="label">库存</td>
													<td><a href="#">${goodsInfo.goodsStock}</a></td>
												</tr>
												<tr>
													<td class="label">类型</td>
													<td><a href="#">${goodsInfo.goodsType}</a></td>
												</tr>
												<tr>
													<td class="label">规格</td>
													<td><a href="#">${goodsInfo.goodsNorms}</a></td>
												</tr>
												<tr>
													<td class="label">分享</td>
													<td class="share">
														<a target="_blank" href="#"><i class="fa fa-facebook"></i></a> 
														<a target="_blank" href="#"><i class="fa fa-twitter"></i></a> 
														<a target="_blank" href="#"><i class="fa fa-google-plus"></i></a>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="col-md-12">
								<div class="commerce-tabs tabs classic">
									<ul class="nav nav-tabs tabs">
										<li class="active">
											<a data-toggle="tab" href="#tab-description" aria-expanded="true">商品介绍</a>
										</li>
									</ul>
									<div class="tab-content">
										<div class="tab-pane fade active in" id="tab-description">
											<p>
												${goodsInfo.goodsReadme}
											</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-md-3 col-md-pull-9">
						<%@include file="side.jsp"%>
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
<script type='text/javascript' src='../js/web_js/slick.min.js'></script>
<script type="text/javascript" src="../js/web_js/script.js"></script>
<script src="../lib/layui/layui.js" charset="utf-8"></script>
<script src="../js/MyLayuiUtils.js" charset="utf-8"></script>
<script>
	layui.use(['layer'], function() {
		let layer = layui.layer;

		$("#addCart").click(function() {
			let goodsNumber = parseInt($("input[name='goodsNumber']").val());
			let goodsStock = parseInt($("input[name='stock']").val());
			let goodsId = $("input[name='goodsId']").val();
			if(goodsStock <= 0) {
				return;
			}
			if(goodsNumber > goodsStock) {
				layer.msg("加入数量已超出库存！请重新选择", {
					timer: 1500
				})
				return;
			}
			var jsonObj = {
				goodsId: goodsId,
				goodsCount: goodsNumber
			}
			// 数量没问题, 进行加入购物车操作
			sendAjax("../webCart/insertInfo", "POST", jsonObj, function(res) {
				if(res.code == 0) {
					// 更新右上角购物袋的小tips
					$("#cartTips").attr("data-count", res.data)
					layer.msg(res.msg, {
						timer: 1000
					})
				} else {
					layer.msg(res.msg, {
						timer: 1000
					})
				}
			});
		})
	})
</script>
</body>
</html>