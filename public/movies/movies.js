steal.plugins(	
	'jquery/controller',			// a widget factory
	'jquery/view/ejs',				// client side templates
	'jquery/view/helpers',
	'jquery/model'	,
	'javascripts/grid.locale-en',
	'javascripts/jquery.jqGrid.min',
	'javascripts/jquery.raty.min'
	)		// form data helper
	
	.css()	// loads styles

	.resources('movies.js')					// 3rd party script's (like jQueryUI), in resources folder

	.models()						// loads files in models folder 

	.controllers()					// loads files in controllers folder

	.views('//movies/views/addmovie.ejs','//movies/views/createmovie.ejs','//movies/views/editmovie.ejs','//movies/views/movie.ejs','//movies/views/partialSelection.ejs','//movies/views/selection.ejs');						// adds views to be added to build
