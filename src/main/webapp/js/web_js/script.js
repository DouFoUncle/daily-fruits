(function (window, document, $) {
	"use strict";
	
	$(window).on('load', function () {
		$(".noo-spinner").remove();
	});
	
	/* On resize */
	$(window).on('resize', function () {
		cartTopDistance();
	});
	
	/* On scroll */
	$(window).on('scroll', function () {
		cartTopDistance();
		
		var isMobile = {
			Android: function() {
				return navigator.userAgent.match(/Android/i);
			},
			BlackBerry: function() {
				return navigator.userAgent.match(/BlackBerry/i);
			},
			iOS: function() {
				return navigator.userAgent.match(/iPhone|iPad|iPod/i);
			},
			Opera: function() {
				return navigator.userAgent.match(/Opera Mini/i);
			},
			Windows: function() {
				return navigator.userAgent.match(/IEMobile/i) || navigator.userAgent.match(/WPDesktop/i);
			},
			any: function() {
				return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
		};
		
		if( !isMobile.any() ) {
			if ($(this).scrollTop() > 51) {
				$('.header').addClass('scrolling-menu');
			} else {
				$('.header').removeClass('scrolling-menu');
			}
		}
	});
	
	$(document).ready(function($) {
		/* Search */
		var topSearch = $('.top-search');
		$('.top-search-btn').on('click', function() {
			if(! topSearch.hasClass('open')) {
				topSearch.addClass('open');
				topSearch.slideDown();
				$('.top-search-input').focus();
			} else {
				topSearch.slideUp();
				topSearch.removeClass('open');
			}
		});
		$(document).on('click', function(e) {
			if(($(e.target).closest(topSearch).length === 0) && ($(e.target).closest('.top-search-btn').length === 0)) {
				if(topSearch.hasClass('open')) {
					topSearch.slideUp();
					topSearch.removeClass('open');
				}
			}
		});
		
		/* Mini cart */
		cartTopDistance();
		var miniCart = $('.mini-cart-wrap');
		// 注释后自己重写显示方法 ----------------------------
		// miniCart.on('click', function(e){
		// 	e.stopPropagation();
		// 	$(this).addClass('open');
		// 	cartTopDistance();
		// });
		// 注释后自己重写显示方法 ----------------------------

		$(document).on('click', function(e){
			if($(e.target).closest(miniCart).length === 0){
				miniCart.removeClass('open');
			}
		});
		
		/* about background */
		var organikAbout = $('.organik-about');
		organikAbout.each(function() {
			$(this).find('.image').css('background-color', $(this).find('.image').attr('data-bg-color'));
		});
		
		/* featured products */
		var featuredProducts = $('.organik-featured-product');
		featuredProducts.each(function() {
			if($(this).attr("data-bg-image")) $(this).css('background-image', 'url("' + $(this).attr("data-bg-image") + '")');
			if($(this).attr("data-bg-color")) $(this).css('background-color', $(this).attr('data-bg-color'));
		});
		
		/* product category */
		var productCategory = $('.organik-featured-category');
		productCategory.each(function() {
			if($(this).find('.bg').attr("data-bg-color")) $(this).find('.bg').css('background-color', $(this).find('.bg').attr('data-bg-color'));
		});
		
		var catItem = $('.cat-item');
		catItem.each(function() {
			if($(this).find('.cats-wrap').attr("data-bg-color")) $(this).find('.cats-wrap').css('background-color', $(this).find('.cats-wrap').attr('data-bg-color'));
		});
		
		/* tooltip */
		$('[data-toggle="tooltip"]').tooltip();
		
		/* accordion */
		var accordionHeading = $('.accordion-heading');
		accordionHeading.on('click', function() {
			$(this).toggleClass("active");
		});
		
		var accordionHeadingDefault = $('.accordion.icon-default .accordion-heading');
		accordionHeadingDefault.on('click', function() {
			var icon = $(this).find('i').attr("class");
			if(icon === "ion-minus-circled") $(this).find('i').removeAttr("class").addClass("ion-plus-circled");
			if(icon === "ion-plus-circled") $(this).find('i').removeAttr("class").addClass("ion-minus-circled");
		});
		
		/* increase or decrease item */
		var qtyPlus = $('.qty-plus');
		var qtyMinus = $('.qty-minus');
		qtyPlus.on('click',function(){
            $(this).siblings('.qty').val(parseInt($(this).siblings('.qty').val())+1);
        });

        qtyMinus.on('click',function(){
            if(parseInt($(this).siblings('.qty').val()) > 1) {
				$(this).siblings('.qty').val(parseInt($(this).siblings('.qty').val())-1);
			}
        });
		
		/* product image slider */
		if($('.image-gallery-inner').length > 0) {
			slideSlick();
		}
		
		/* countdown */
		Countdown();
		
		/* carousel slider */
		owlCarousel();
		
		/* google map */
		googleMap();
		
		/* back to top */
		$('#backtotop').on('click', function() {
			$("html, body").animate({
				scrollTop: 0
			}, 800);
			return false;
		});
		
		/* toggle mobile menu */
		var openLeft = $('#open-left');
		var site = $('.site');
		var slideoutMenu = $('.slideout-menu');
		openLeft.on('click',function(e){
            site.addClass('open');
			slideoutMenu.addClass('open');
        });
		site.on('click',function(e){
            if ($(e.target).closest("#open-left").length === 0) {
				if (site.hasClass("open")) {
					e.preventDefault();
				}
				$(this).removeClass("open");
				slideoutMenu.removeClass('open');
			}
        });
		
		var subMenuToggle = $('.sub-menu-toggle');
		subMenuToggle.on('click',function(e){
            $(this).parent('li').toggleClass('expand');
			$(this).siblings('.sub-menu').slideToggle();
        });
		
		/* init revolution slider */
		if ($("#rev_slider").length > 0) {
			RevolutionInit();
		}
		if ($("#rev_slider_2").length > 0) {
			RevolutionInit2();
		}
	});

})(window, document, jQuery);

/*=================================================================
	cart top distance
===================================================================*/
function cartTopDistance() {
	var headerHeight = $('.header').height();
	$('.widget-shopping-cart-content').css('top', headerHeight + 'px' );
}

/*=================================================================
	countdown function
===================================================================*/
function Countdown() {
	if ($(".pl-clock").length > 0) {
		$(".pl-clock").each(function() {
			var time = $(this).attr("data-time");
			$(this).countdown(time, function(event) {
				var $this = $(this).html(event.strftime('' + '<div class="countdown-item"><div class="countdown-item-value">%D</div><div class="countdown-item-label">Days</div></div>' + '<div class="countdown-item"><div class="countdown-item-value">%H</div><div class="countdown-item-label">Hours</div></div>' + '<div class="countdown-item"><div class="countdown-item-value">%M</div><div class="countdown-item-label">Minutes</div></div>' + '<div class="countdown-item"><div class="countdown-item-value">%S</div><div class="countdown-item-label">Seconds</div></div>'));
			});
		});
	}
}

/*=================================================================
	google map
===================================================================*/
function googleMap() {
	if ($("#googleMap").length > 0) {
		$obj = $("#googleMap");
		var myCenter = new google.maps.LatLng($obj.data("lat"), $obj.data("lon"));
		var myMaker = new google.maps.LatLng($obj.data("lat"), $obj.data("lon"));
		function initialize() {
			var mapProp = {
				center: myCenter,
				zoom: 16,
				scrollwheel: false,
				mapTypeControlOptions: {
					mapTypeIds: [ google.maps.MapTypeId.ROADMAP, "map_style" ]
				}
			};
			var map = new google.maps.Map(document.getElementById("googleMap"), mapProp);
			var marker = new google.maps.Marker({
				position: myMaker,
				icon: $obj.data("icon")
			});
			marker.setMap(map);
		}
		google.maps.event.addDomListener(window, "load", initialize);
	}
}

/*=================================================================
	owl carousel slider function
===================================================================*/
function owlCarousel(){
	if ($(".product-slider").length > 0) {
		$(".product-slider").each(function(){
			$(this).owlCarousel({
				items: 1,
				loop: true,
				mouseDrag: false,
				navigation: true,
				dots: false,
				pagination: false,
				autoplay: true,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				navigationText: ['<i class="ion-chevron-left"></i>', '<i class="ion-chevron-right"></i>'],
				itemsDesktop: [1199, 1],
				itemsDesktopSmall: [979, 1],
				itemsTablet: [768, 1],
				itemsMobile: [479, 1],
				addClassActive: true
			});
		});
	}
	if ($(".client-carousel").length > 0) {
		$(".client-carousel").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: false,
				dots: false,
				pagination: false,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
	if ($(".category-carousel").length > 0) {
		$(".category-carousel").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: true,
				dots: false,
				pagination: false,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
	if ($(".category-carousel-2").length > 0) {
		$(".category-carousel-2").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: false,
				dots: true,
				pagination: true,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
	if ($(".testimonial-carousel").length > 0) {
		$(".testimonial-carousel").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: false,
				dots: true,
				pagination: true,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
	if ($(".product-carousel").length > 0) {
		$(".product-carousel").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: true,
				dots: false,
				pagination: false,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
	if ($(".about-carousel").length > 0) {
		$(".about-carousel").each(function(){
			var autoplay = ($(this).attr("data-auto-play") === "true") ? true : false;
			$(this).owlCarousel({
				items: $(this).attr("data-desktop"),
				loop: true,
				mouseDrag: true,
				navigation: true,
				dots: false,
				pagination: false,
				autoPlay: autoplay,
				autoplayTimeout: 5000,
				autoplayHoverPause: true,
				smartSpeed: 1000,
				autoplayHoverPause: true,
				navigationText: ['<i class="ion-ios-arrow-thin-left"></i>', '<i class="ion-ios-arrow-thin-right"></i>'],
				itemsDesktop: [1199, $(this).attr("data-desktop")],
				itemsDesktopSmall: [979, $(this).attr("data-laptop")],
				itemsTablet: [768, $(this).attr("data-tablet")],
				itemsMobile: [479, $(this).attr("data-mobile")]
			});
		});
	}
}

/*=================================================================
	slick slider
===================================================================*/

function slideSlick() {
	/* sync Horizontal */
	$('.image-gallery-inner').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		arrows: false,
		dots: false,
		infinite: false,
		asNavFor: '.image-gallery-nav',
		responsive: [
			{
				breakpoint: 480,
				settings: {
					dots: true
				}
			}
		]
	});
	
	$('.image-gallery-nav').slick({
		slidesToShow: 3,
		slidesToScroll: 1,
		asNavFor: '.image-gallery-inner',
		arrows: true,
		dots: false,
		infinite: false,
		focusOnSelect: true,
		responsive: [
			{
				breakpoint: 768,
				settings: {
					slidesToShow: 4
				}
			},
		]
	});
	
	$('.slider-single').slick({
		prevArrow: '<div class="slick-prev"><i class="fa fa-long-arrow-left"></i></div>',
		nextArrow: '<div class="slick-next"><i class="fa fa-long-arrow-right"></i></div>',
	});
}

/*=================================================================
	revolution slider function
===================================================================*/
function RevolutionInit() {
	$("#rev_slider").show().revolution({
		sliderType:"standard",
		sliderLayout:"auto",
		dottedOverlay:"none",
		delay:9000,
		navigation: {
			keyboardNavigation:"off",
			keyboard_direction: "horizontal",
			mouseScrollNavigation:"off",
			mouseScrollReverse:"default",
			onHoverStop:"off",
			arrows: {
				style:"hebe",
				enable:true,
				hide_onmobile:true,
				hide_under:768,
				hide_onleave:true,
				hide_delay:200,
				hide_delay_mobile:1200,
				tmp:'<div class="tp-title-wrap">	<span class="tp-arr-titleholder">{{title}}</span>    <span class="tp-arr-imgholder"></span> </div>',
				left: {
					h_align:"left",
					v_align:"center",
					h_offset:20,
					v_offset:0
				},
				right: {
					h_align:"right",
					v_align:"center",
					h_offset:20,
					v_offset:0
				}
			}
		},
		visibilityLevels:[1240,1024,778,480],
		gridwidth:1920,
		gridheight:870,
		lazyType:"none",
		parallax: {
			type:"mouse",
			origo:"enterpoint",
			speed:400,
			levels:[5,10,15,20,25,30,35,40,45,46,47,48,49,50,51,55],
			disable_onmobile:"on"
		},
		shadow:0,
		spinner:"spinner3",
		stopLoop:"off",
		stopAfterLoops:-1,
		stopAtSlide:-1,
		shuffle:"off",
		autoHeight:"off",
		disableProgressBar:"on",
		hideThumbsOnMobile:"off",
		hideSliderAtLimit:0,
		hideCaptionAtLimit:0,
		hideAllCaptionAtLilmit:0,
		debugMode:false,
		fallbacks: {
			simplifyAll:"off",
			nextSlideOnWindowFocus:"off",
			disableFocusListener:false,
		}
	});
}

function RevolutionInit2() {
	$("#rev_slider_2").show().revolution({
		sliderType:"standard",
		sliderLayout:"auto",
		dottedOverlay:"none",
		delay:9000,
		navigation: {
			keyboardNavigation:"off",
			keyboard_direction: "horizontal",
			mouseScrollNavigation:"off",
			mouseScrollReverse:"default",
			onHoverStop:"off",
			arrows: {
				style:"metis",
				enable:true,
				hide_onmobile:false,
				hide_onleave:true,
				hide_delay:200,
				hide_delay_mobile:1200,
				tmp:'',
				left: {
					h_align:"left",
					v_align:"center",
					h_offset:20,
					v_offset:0
				},
				right: {
					h_align:"right",
					v_align:"center",
					h_offset:20,
					v_offset:0
				}
			}
		},
		responsiveLevels:[1240,1024,778,480],
		visibilityLevels:[1240,1024,778,480],
		gridwidth:[1200,1024,778,480],
		gridheight:[910,768,960,720],
		lazyType:"none",
		parallax: {
			type:"mouse",
			origo:"enterpoint",
			speed:400,
			levels:[5,10,15,20,25,30,35,40,45,46,47,48,49,50,51,55],
		},
		shadow:0,
		spinner:"spinner3",
		stopLoop:"off",
		stopAfterLoops:-1,
		stopAtSlide:-1,
		shuffle:"off",
		autoHeight:"off",
		hideThumbsOnMobile:"off",
		hideSliderAtLimit:0,
		hideCaptionAtLimit:0,
		hideAllCaptionAtLilmit:0,
		debugMode:false,
		fallbacks: {
			simplifyAll:"off",
			nextSlideOnWindowFocus:"off",
			disableFocusListener:false,
		}
	});
}