$(document).ready(function($) {
	"use strict";

	$('.masonry-grid-post').each(function() {
		var $this = $(this);
		var $filter = $this.parents('.site').find('.masonry-filter');
		$this.imagesLoaded(function() {
			$this.isotope({
				itemSelector: '.masonry-item'
			});
		});

		$filter.find('a').on("click", function(e) {
			e.preventDefault();
			$filter.find("a").removeClass('active');
			$(this).addClass('active');
			var data_filter = $(this).data('filter');
			$this.isotope({
				filter: data_filter
			});
		});
	});
});
