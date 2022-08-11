jQuery( function( $ ) {

	// Get markup ready for slider
	$( 'input#min_price, input#max_price' ).hide();
	$( '.price_slider, .price_label' ).show();

	// Price slider uses jquery ui
	var min_price = $( '.price_slider_amount #min_price' ).data( 'min' ),
		max_price = $( '.price_slider_amount #max_price' ).data( 'max' ),
		current_min_price = parseInt( min_price, 10 ),
		current_max_price = parseInt( max_price, 10 ),
		currency_pos = "left",
		currency_symbol = "$";

	$( document.body ).on( 'price_slider_create price_slider_slide', function( event, min, max ) {
		if ( currency_pos === 'left' ) {

			$( '.price_slider_amount span.from' ).html( currency_symbol + min );
			$( '.price_slider_amount span.to' ).html( currency_symbol + max );

		} else if ( currency_pos === 'left_space' ) {

			$( '.price_slider_amount span.from' ).html( currency_symbol + ' ' + min );
			$( '.price_slider_amount span.to' ).html( currency_symbol + ' ' + max );

		} else if ( currency_pos === 'right' ) {

			$( '.price_slider_amount span.from' ).html( min + currency_symbol );
			$( '.price_slider_amount span.to' ).html( max + currency_symbol );

		} else if ( currency_pos === 'right_space' ) {

			$( '.price_slider_amount span.from' ).html( min + ' ' + currency_symbol );
			$( '.price_slider_amount span.to' ).html( max + ' ' + currency_symbol );

		}

		$( document.body ).trigger( 'price_slider_updated', [ min, max ] );
	});

	$( '.price_slider' ).slider({
		range: true,
		animate: true,
		min: min_price,
		max: max_price,
		values: [ current_min_price, current_max_price ],
		create: function() {

			$( '.price_slider_amount #min_price' ).val( current_min_price );
			$( '.price_slider_amount #max_price' ).val( current_max_price );

			$( document.body ).trigger( 'price_slider_create', [ current_min_price, current_max_price ] );
		},
		slide: function( event, ui ) {

			$( 'input#min_price' ).val( ui.values[0] );
			$( 'input#max_price' ).val( ui.values[1] );

			$( document.body ).trigger( 'price_slider_slide', [ ui.values[0], ui.values[1] ] );
		},
		change: function( event, ui ) {

			$( document.body ).trigger( 'price_slider_change', [ ui.values[0], ui.values[1] ] );
		}
	});

});
