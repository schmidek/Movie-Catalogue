steal.plugins(	
	'javascripts/grid.locale-en',
	'javascripts/jquery.jqGrid.min'
)
	
	.css()	// loads styles

	.resources('changes.js')					// 3rd party script's (like jQueryUI), in resources folder

	.models()						// loads files in models folder 

	.controllers()					// loads files in controllers folder

	.views();						// adds views to be added to build
