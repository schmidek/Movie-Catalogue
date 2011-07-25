/**
 * @tag models, home
 * Wraps backend movie services.  Enables 
 * [Movies.Models.Movie.static.findAll retrieving],
 * [Movies.Models.Movie.static.update updating],
 * [Movies.Models.Movie.static.destroy destroying], and
 * [Movies.Models.Movie.static.create creating] movies.
 */
$.Model.extend('Movies.Models.Movie',
/* @Static */
{
	cache: {},
	
	findOne: function( params, success, error ){
		var self = this;
		id = params["id"];
		if ( self.cache[id] ) {
			//Cache hit
			var movie = self.cache[id];
			success(movie);
		} else {
			//Get Movie from server
			$.getJSON('movies/' + id + '.json', function( data ) {
				var wrapped = self.wrap(data.movie);
				self.cache[id] = wrapped;
				success(wrapped);
			});
		}
	},
	
	
	
	/**
	 * Updates a movie's data.
	 * @param {String} id A unique id representing your movie.
	 * @param {Object} attrs Data to update your movie with.
	 * @param {Function} success a callback function that indicates a successful update.
 	 * @param {Function} error a callback that should be called with an object of errors.
     */
	update: function( id, attrs, success, error ){
		var self = this;
		$.ajax({
			url: 'movies/'+id+'.json',
			type: 'post',
			dataType: 'json',
			data: attrs,
			success: function(){
				//INVALIDATE Cache
				delete self.cache[id];
				self.publish("updated");
				if(success){ success(); }
			},
			error: error
		});
	},
	/**
 	 * Destroys a movie's data.
 	 * @param {String} id A unique id representing your movie.
	 * @param {Function} success a callback function that indicates a successful destroy.
 	 * @param {Function} error a callback that should be called with an object of errors.
	 */
	destroy: function( id, success, error ){
		var self = this;
		$.ajax({
			url: 'movies/'+id+'.json',
			type: 'post',
			dataType: 'json',
			data: {'_method':'delete'},
			success: function(){
				//INVALIDATE Cache
				delete self.cache[id];
				self.publish("destroyed");
				if(success){ success(); }
			},
			error: error
		});
	},
	/**
	 * Creates a movie.
	 * @param {Object} attrs A movie's attributes.
	 * @param {Function} success a callback function that indicates a successful create.  The data that comes back must have an ID property.
	 * @param {Function} error a callback that should be called with an object of errors.
	 */
	create: function( attrs, success, error ){
		var self = this;
		$.ajax({
			url: 'movies.json',
			type: 'post',
			dataType: 'json',
			data: attrs,
			success: function(){
				self.publish("created");
				if(success){ success(); }
			},
			error: error
		});
	},
	
	search: function(name,success,error){
		$.getJSON('/tmdb/search?name=' + name, success);
	},
	
	getInfo: function(id,success,error){
		var self = this;
		$.getJSON('/tmdb/getInfo?id=' + id, function( data ) {
			self.parseMovie(data[0],success,error);
		});
	},
	
	parseMovie: function(info,success,error){
		var movie = new Object();
		movie.name = info.name;
		movie.added = new Date();
		for ( var i in info.posters ) {
			var poster = info.posters[i].image;
			if ( poster.size == "cover" ) {
				movie.cover = poster.url;
				break;
			}
		}
		movie.year = info.released;
		movie.summary = info.overview;
		movie.imdb = info.imdb_id;
		movie.trailer = info.trailer;
		var genres = new Array();
		for ( var i in info.genres ) {
			genres.push(info.genres[i].name);
		}
		movie.genres = genres;
		var wrapped = this.wrap(movie);
		success(wrapped);
	}
	
	
},
/* @Prototype */
{});
