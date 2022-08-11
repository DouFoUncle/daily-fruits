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
<link rel="stylesheet" href="../css/web_css/settings.css" type="text/css" media="all">
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
        <!-- ----------------------------上方轮播大图 Start ------------------------------------- -->
		<div class="section">
			<div class="container-fluid">
				<div class="row">
					<div class="col-sm-12 p-0">
						<div id="rev_slider" class="rev_slider fullscreenbanner">
							<ul>
								<li data-transition="fade" data-slotamount="default" data-hideafterloop="0" data-hideslideonmobile="off" data-easein="default" data-easeout="default" data-masterspeed="300" data-rotate="0" data-saveperformance="off" data-title="Slide">
									<img src="../images/slider/slide_bg_4.jpg" alt="" data-bgposition="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-bgparallax="off" class="rev-slidebg" />
									<div class="tp-caption rs-parallaxlevel-2"
										 data-x="center" data-hoffset=""
										 data-y="center" data-voffset="-80"
										 data-width="['none','none','none','none']"
										 data-height="['none','none','none','none']"
										 data-type="image" data-responsive_offset="on"
										 data-frames='[{"delay":0,"speed":300,"frame":"0","from":"opacity:0;","to":"o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;","ease":"Power3.easeInOut"}]'
										 data-textAlign="['inherit','inherit','inherit','inherit']"
										 data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]"
										 data-paddingbottom="[0,0,0,0]"
										 data-paddingleft="[0,0,0,0]">
											<img src="../images/slider/slide_6.png" alt="" />
									</div>
									<div class="tp-caption rs-parallaxlevel-1"
										 data-x="center" data-hoffset=""
										 data-y="center" data-voffset="-80"
										 data-width="['none','none','none','none']"
										 data-height="['none','none','none','none']"
										 data-type="image" data-responsive_offset="on"
										 data-frames='[{"delay":0,"speed":300,"frame":"0","from":"opacity:0;","to":"o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;","ease":"Power3.easeInOut"}]'
										 data-textAlign="['inherit','inherit','inherit','inherit']"
										 data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]"
										 data-paddingbottom="[0,0,0,0]" data-paddingleft="[0,0,0,0]">
											<img src="../images/slider/slide_7.png" alt="" />
									</div>
									<a class="tp-caption btn-2 hidden-xs" href="../webSystem/toShopPage"
										 data-x="['center','center','center','center']" 
										 data-y="['center','center','center','center']" data-voffset="['260','260','260','260']"
										 data-width="['auto']" data-height="['auto']"
										 data-type="button" data-responsive_offset="on"
										 data-responsive="off"
										 data-frames='[{"delay":0,"speed":300,"frame":"0","from":"opacity:0;","to":"o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;","ease":"Power3.easeInOut"},{"frame":"hover","speed":"300","ease":"Power0.easeIn","to":"o:1;rX:0;rY:0;rZ:0;z:0;","style":"c:rgb(95,189,116);bg:rgba(51, 51, 51, 0);"}]'
										 data-textAlign="['inherit','inherit','inherit','inherit']"
										 data-paddingtop="[16,16,16,16]" data-paddingright="[30,30,30,30]"
										 data-paddingbottom="[16,16,16,16]" data-paddingleft="[30,30,30,30]">前往购物
									</a>
								</li>
								<li data-transition="fade" data-slotamount="default" data-hideafterloop="0" data-hideslideonmobile="off" data-easein="default" data-easeout="default" data-masterspeed="300" data-rotate="0" data-saveperformance="off" data-title="Slide"> 
									<img src="../images/slider/slide_bg_5.jpg"  alt="" data-bgposition="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-bgparallax="off" class="rev-slidebg" />
									<div class="tp-caption rs-parallaxlevel-1"
										 data-x="center" data-hoffset=""
										 data-y="center" data-voffset="-120"
										 data-width="['none','none','none','none']"
										 data-height="['none','none','none','none']"
										 data-type="image" data-responsive_offset="on"
										 data-frames='[{"delay":0,"speed":1500,"frame":"0","from":"z:0;rX:0;rY:0;rZ:0;sX:0.9;sY:0.9;skX:0;skY:0;opacity:0;","to":"o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;","ease":"Power3.easeInOut"}]'
										 data-textAlign="['inherit','inherit','inherit','inherit']"
										 data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]"
										 data-paddingbottom="[0,0,0,0]" data-paddingleft="[0,0,0,0]">
											<img src="../images/slider/slide_8.png" alt="" />
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
        <!-- ---------------------------- 上方轮播大图 End -------------------------------------- -->


        <!-- ---------------------------- 中部前往购物 Start ------------------------------------- -->
		<div class="section section-bg-1 section-cover pt-17 pb-3">
			<div class="container">
				<div class="row">
					<div class="col-sm-6">
						<div class="mt-3 mb-3">
							<img src="../images/oranges.png" alt="" />
						</div>
					</div>
					<div class="col-sm-6">
						<div class="mb-1 section-pretitle default-left">欢迎来到</div>
						<h2 class="section-title mtn-2 mb-3">果蔬超市</h2>
						<p class="mb-4">
                            提供最好的和最广泛的有机食品，我们的使命是促进社区健康，
                            并带来一种发现和冒险的感觉到食品购物。
                        </p>
						<a class="organik-btn arrow" href="../webSystem/toShopPage">前往购物</a>
					</div>
				</div>
			</div>
		</div>
        <!-- ---------------------------- 中部前往购物 End ------------------------------------- -->


        <!-- ---------------------------- 中部我们的优点 Start ------------------------------------- -->
		<div class="section section-bg-3 pt-6 pb-6">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<div class="text-center mb-1 section-pretitle">A friendly</div>
						<h2 class="text-center section-title mtn-2">果蔬超市</h2>
						<div class="organik-seperator mb-9 center">
							<span class="sep-holder"><span class="sep-line"></span></span>
							<div class="sep-icon"><i class="organik-flower"></i></div>
							<span class="sep-holder"><span class="sep-line"></span></span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-4">
						<div class="organik-special-title">
							<div class="number">01</div>
							<div class="title">新鲜的</div>
						</div>
						<p>蔬菜又分为两大种类，一类是只能当蔬菜吃；而另一类即能当作蔬菜吃又能当作水果吃，新鲜的蔬菜就是可以让您把蔬菜当作水果一样吃。</p>
						<div class="mb-8"></div>
						<div class="organik-special-title">
							<div class="number">02</div>
							<div class="title">不含杀虫剂</div>
						</div>
						<p>长期接触或食用含有农药杀虫剂残留的食品，可使农药杀虫剂在体内不断蓄积，对人体健康构成潜在威胁，即慢性中毒，可影响神经系统，破坏肝脏功能。</p>
					</div>
					<div class="col-md-4">
						<div class="mb-8"></div>
					</div>
					<div class="col-md-4">
						<div class="organik-special-title align-right">
							<div class="number">03</div>
							<div class="title">健康的</div>
						</div>
						<p>有些蔬菜里有维生素A，有些蔬菜里有维生素B，而有的蔬菜里有维生素C……吃蔬菜不仅能让你的身体健健康康，还能让你的脸变得红润起来。</p>
						<div class="mb-8"></div>
						<div class="organik-special-title align-right">
							<div class="number">04</div>
							<div class="title">有机的</div>
						</div>
						<p>
                            有机种植的食物比商业种植的食物含有更多的营养素维生素、矿物质、酶和微量营养素，因为土壤是按照负责任的标准通过可持续的实践来管理和滋养的。
                        </p>
					</div>
				</div>
			</div>
		</div>
        <!-- ---------------------------- 中部我们的优点 End ------------------------------------- -->

        <!-- ---------------------------- 中部小Tips Start ------------------------------------- -->
		<div class="section border-bottom mt-6 mb-5">
			<div class="container">
				<div class="row">
					<div class="organik-process">
						<div class="col-md-3 col-sm-6 organik-process-small-icon-step">
							<div class="icon">
								<i class="organik-delivery"></i>
							</div>
							<div class="content">
								<div class="title">免费配送</div>
							</div>
						</div>
						<div class="col-md-3 col-sm-6 organik-process-small-icon-step">
							<div class="icon">
								<i class="organik-hours-support"></i>
							</div>
							<div class="content">
								<div class="title">7*24小时服务</div>
							</div>
						</div>
						<div class="col-md-3 col-sm-6 organik-process-small-icon-step">
							<div class="icon">
								<i class="organik-credit-card"></i>
							</div>
							<div class="content">
								<div class="title">安全支付</div>
							</div>
						</div>
						<div class="col-md-3 col-sm-6 organik-process-small-icon-step">
							<div class="icon">
								<i class="organik-lettuce"></i>
							</div>
							<div class="content">
								<div class="title">用爱制造</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
        <!-- ---------------------------- 中部小Tips End ------------------------------------- -->

        <!-- ---------------------------- 中部部分产品展示 Start ------------------------------------- -->
		<div class="section pt-12 pb-9">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<div class="text-center mb-1 section-pretitle">Discover</div>
						<h2 class="text-center section-title mtn-2">部分产品展示</h2>
						<div class="organik-seperator center">
							<span class="sep-holder"><span class="sep-line"></span></span>
							<div class="sep-icon"><i class="organik-flower"></i></div>
							<span class="sep-holder"><span class="sep-line"></span></span>
						</div>
					</div>
				</div>
				<div class="row" style="margin-top: 40px">
					<div class="product-grid masonry-grid-post">
						<c:forEach items="${goodsList}" var="item">
							<div class="col-md-3 col-sm-6 product-item masonry-item text-center vegetables">
								<div class="product-thumb">
									<a href="../webSystem/toShopDetailPage?id=${item.id}"
									   style="min-width: 256.5px; min-height: 256.5px;">
										<c:if test="${item.goodsStock == 0}">
											<span class="outofstock"><span style="margin-top: 38px">已售尽</span>补货中……</span>
										</c:if>
										<img src="${projectPath}/upload/${item.goodsHeadImg}" alt="暂无图片"/>
									</a>
									<c:if test="${item.goodsStock > 0}">
										<div class="product-action">
											<span class="add-to-cart">
												<a href="javascript:;" data-toggle="tooltip" data-placement="top"
												   data-goodsId="${item.id}" data-goodsCount="1"
												   title="加入购物车" class="addCart"></a>
											</span>
											<span class="quickview">
												<a href="../webSystem/toShopDetailPage?id=${item.id}" data-toggle="tooltip" data-placement="top" title="查看详细"></a>
											</span>
										</div>
									</c:if>
								</div>
								<div class="product-info">
									<a href="../webSystem/toShopDetailPage?id=${item.id}">
										<h2 class="title">${item.goodsName}</h2>
										<span class="price<c:if test="${item.disPrice != null}"> delPrice</c:if>">¥${item.goodsPrice / 100}</span>
										<c:if test="${item.disPrice != null}"><span class="price">¥${item.disPrice / 100}</span></c:if>
									</a>
								</div>
							</div>
						</c:forEach>
					</div>
					<div class="loadmore-contain">
						<a class="organik-btn small" href="../webSystem/toShopPage"> 查看更多 </a>
					</div>
				</div>
			</div>
        </div>
        <!-- ---------------------------- 中部部分产品展示 End ------------------------------------- -->

		<div class="section pt-2 pb-4">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<div class="client-carousel" data-auto-play="true" data-desktop="5" data-laptop="3" data-tablet="3" data-mobile="2">
							<div class="client-item">
								<a href="javascript:;" target="_blank">
									<img src="../images/client/client_1.png" alt="" />
								</a>
							</div>
							<div class="client-item">
								<a href="javascript:;" target="_blank">
									<img src="../images/client/client_2.png" alt="" />
								</a>
							</div>
							<div class="client-item">
								<a href="javascript:;" target="_blank">
									<img src="../images/client/client_3.png" alt="" />
								</a>
							</div>
							<div class="client-item">
								<a href="javascript:;" target="_blank">
									<img src="../images/client/client_4.png" alt="" />
								</a>
							</div>
							<div class="client-item">
								<a href="javascript:;" target="_blank">
									<img src="../images/client/client_5.png" alt="" />
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 引入公共底部文件 -->
	<%@include file="footer.jsp"%>
</div>

<script type="text/javascript" src="../js/jquery.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery-migrate.min.js"></script>
<script type="text/javascript" src="../js/web_js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/web_js/modernizr-2.7.1.min.js"></script>
<script type="text/javascript" src="../js/web_js/owl.carousel.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.countdown.min.js"></script>
<script type="text/javascript" src="../js/web_js/imagesloaded.pkgd.min.js"></script>
<script type="text/javascript" src="../js/web_js/isotope.pkgd.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.isotope.init.js"></script>
<script type="text/javascript" src="../js/web_js/script.js"></script>

<script type="text/javascript" src="../js/web_js/jquery.themepunch.tools.min.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.themepunch.revolution.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.video.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.slideanims.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.actions.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.layeranimation.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.kenburn.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.navigation.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.migration.min.js"></script>
<script type="text/javascript" src="../js/web_js/extensions/revolution.extension.parallax.min.js"></script>
<script src="../lib/layui/layui.js" charset="utf-8"></script>
<script src="../js/MyLayuiUtils.js" charset="utf-8"></script>
<script>

	layui.use(['layer'], function() {
		var layer = layui.layer;
		// 响应加入购物车按钮
		$(".addCart").click(function () {
			let goodsId = $(this).attr("data-goodsId");
			let goodsCount = $(this).attr("data-goodsCount");
			// 获取数据
			let jsonObj = {
				"goodsId": goodsId,
				"goodsCount": goodsCount
			}
			// 进行加入购物车操作
			sendAjax("../webCart/insertInfo", "POST", jsonObj, function (res) {
				if (res.code == 0) {
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
	});
</script>
</body>
</html>