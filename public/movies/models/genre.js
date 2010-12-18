
$.Model.extend('Movies.Models.Genre',
/* @Static */
{
	
	findAll: function( params, success, error ){
		var genres = ["Drama","Animation","Adventure","Comedy","Family","Fantasy","Romance","Horror","Thriller","Action","Crime","Mystery","SciFi","Biography","War","Western","Sport","Musical","Music","History","Documentary","Short"].sort();
		return genres;
	}
},
/* @Prototype */
{});
