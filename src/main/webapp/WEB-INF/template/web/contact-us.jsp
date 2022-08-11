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
<link rel="stylesheet" href="../css/web_css/prettyPhoto.css" type="text/css" media="all">
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
							<img class="logo-image" src="../../images/logo.png" alt="Organik Logo" />
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
						<h2 class="page-title text-center">Contact Us</h2>
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
							<li>联系我们</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="section pt-10 pb-10">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<div class="text-center mb-1 section-pretitle">Get in touch</div>
						<h2 class="text-center section-title mtn-2">果蔬超市</h2>
						<div class="organik-seperator mb-6 center">
							<span class="sep-holder"><span class="sep-line"></span></span>
							<div class="sep-icon"><i class="organik-flower"></i></div>
							<span class="sep-holder"><span class="sep-line"></span></span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-3">
						<div class="contact-info">
							<div class="contact-icon">
								<i class="fa fa-map-marker"></i>
							</div>
							<div class="contact-inner">
								<h6 class="contact-title"> 地址</h6>
								<div class="contact-content">
									XXX省XXX市
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="contact-info">
							<div class="contact-icon">
								<i class="fa fa-phone"></i>
							</div>
							<div class="contact-inner">
								<h6 class="contact-title"> 电话号码</h6>
								<div class="contact-content">
									000-123456
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="contact-info">
							<div class="contact-icon">
								<i class="fa fa-envelope"></i>
							</div>
							<div class="contact-inner">
								<h6 class="contact-title"> 邮箱</h6>
								<div class="contact-content">
									qwertyu@163.com
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="contact-info">
							<div class="contact-icon">
								<i class="fa fa-globe"></i>
							</div>
							<div class="contact-inner">
								<h6 class="contact-title"> 网站</h6>
								<div class="contact-content">
									http://www.xxxx.com
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<hr class="mt-4 mb-7" />
						<div class="text-center mb-1 section-pretitle">给我们留言！</div>
						<div class="organik-seperator mb-6 center">
							<span class="sep-holder"><span class="sep-line"></span></span>
							<div class="sep-icon"><i class="organik-flower"></i></div>
							<span class="sep-holder"><span class="sep-line"></span></span>
						</div>
						<div class="contact-form-wrapper">
							<form class="contact-form">
								<div class="row">
									<div class="col-md-6">
										<label>你的名字 <span class="required">*</span></label>
										<div class="form-wrap">
											<input type="text" name="your-name" value="" size="40" />
										</div>
									</div>
									<div class="col-md-6">
										<label>你的邮箱 <span class="required">*</span></label>
										<div class="form-wrap">
											<input type="email" name="your-email" value="" size="40" />
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<label>留言主题</label>
										<div class="form-wrap">
											<input type="text" name="your-subject" value="" size="40" />
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<label>留言内容</label>
										<div class="form-wrap">
											<textarea name="your-message" cols="40" rows="10"></textarea>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<div class="form-wrap text-center">
											<input type="button" value="马上发送" />
										</div>
									</div>
								</div>
							</form>
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
<script type="text/javascript" src="../js/web_js/jquery.prettyPhoto.js"></script>
<script type="text/javascript" src="../js/web_js/jquery.prettyPhoto.init.min.js"></script>
<script type="text/javascript" src="../js/web_js/script.js"></script>
<script type="text/javascript" src="http://ditu.google.cn/maps/api/js?key=AIzaSyDwtb7cR_XBPEvxtQ_Yq3_xKsOWQroCTPA&sensor=false"></script>
</body>
</html>

