$(document).ready(function() {
	new ListView();
	new ItemView($("#itemview"));
	new Controller();
	new Model();
	new AddMovie();
});

var AddMovie = function() {
	var self = this;

	$(document).bind('ADD_MOVIE', function( e, data ) {
		self.show();
	});

	self.show = function() {
		div = "#addmovie_form";

		$("body").append($.View('//movies/views/addmovie.ejs', {}));

		$(div).dialog({
			modal: true,
			buttons: {
				"Create": function() {
					var name = $("#addmovie_name").val();
					setTimeout(function() {
						self.search(name);
					}, 10);
					$(this).dialog("close");
				},
				"Cancel": function() {
					$(this).dialog("close");
				}
			},
			close: function() {
				$(div).remove();
			}
		});
	};

	self.search = function( name ) {
		$.getJSON('/tmdb/search?name=' + name, self.showChoices);
	};

	self.showChoices = function( movies ) {

		div = "#choices";

		$("body").append($.View('//movies/views/selection.ejs', {
			movies: movies
		}));
		$(".choice").click(function( e ) {
			var id = $(this).val();
			setTimeout(function() {
				self.getInfo(id);
			}, 10);
			$(div).dialog("close");
		});

		$(div).dialog({
			modal: true,
			buttons: {
				"Cancel": function() {
					$(this).dialog("close");
				}
			},
			close: function() {
				$(div).remove();
			}
		});
	};

	self.getInfo = function( id ) {
		$.getJSON('/tmdb/getInfo?id=' + id, function( data ) {
			self.addMovies(data[0]);
		});
	};

	self.addMovies = function( info ) {
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
		$(document).trigger('CREATE_MOVIE', movie);
	};

};

var ListView = function() {

	var self = this;

	//initialize grid
	jQuery("#moviegrid").jqGrid({
		url: 'movies/grid.json',
		datatype: "json",
		colNames: ['Name', 'Year', 'Date Added'],
		colModel: [{
			name: 'name',
			index: 'name',
			width: 350
		},
		{
			name: 'year',
			index: 'year',
			width: 100
		},
		{
			name: 'added',
			index: 'added',
			width: 100
		}],
		rowNum: 20,
		rownumbers: true,
		pager: '#movienav',
		sortname: 'added',
		viewrecords: true,
		sortorder: "desc",
		//scroll:1,
		caption: "Movies",
		height: '100%',
		//autowidth: true,
		onSelectRow: function( id ) {
			self.handleClick(id);
		},
		loadComplete: function() {
			$("#moviegrid").find("tbody tr:nth-child(2)").click();
		}
	}).jqGrid('navGrid', '#movienav', {
		edit: false,
		del: false,
		addtext: "Add Movie",
		addfunc: function() {
			$(document).trigger('ADD_MOVIE');
		}
	}).filterToolbar();
	$('.ui-jqgrid-titlebar').hide();

	$(window).bind('resize', function() {
		$("#moviegrid").setGridWidth($("#listview").width() - 20, true);
	}).trigger('resize');

	self.currentId = -1;
	self.handleClick = function( id ) {
		if ( self.currentId != id ) {
			self.currentId = id;
			$(document).trigger('MOVIE_SELECTED', id);
		}
	};

};

var ItemView = function( $div ) {

	var self = this;

	var div = $div;

	$(document).bind('CURRENT_MOVIE_CHANGED', function( e, data ) {
		self.updateCurrent(data);
	});
	$(document).bind('CREATE_MOVIE', function( e, data ) {
		self.pendingCreate(data);
	});

	self.updateCurrent = function( movie ) {
		div.html($.View('//movies/views/movie.ejs', {
			movie: movie
		}));
		div.find("button").button();
		$("#rating").raty({
			readOnly: true,
			start: movie.rating,
			number: 10,
			path: '/images/'
		});
		$("#editMovie").click(function() {
			self.editCurrent(movie);
		});
	};

	self.editCurrent = function( movie ) {
		div.html($.View('//movies/views/editmovie.ejs', {
			movie: movie
		}));
		div.find("button,input[type=submit]").button();
		$("#rating").raty({
			start: movie.rating,
			number: 10,
			path: '/images/',
			scoreName: 'movie[rating]',
			showCancel: true
		});
		$("#formatset", div).buttonset();
		$("#cancel").click(function() {
			self.updateCurrent(movie);
		});
		$("#movieForm").submit(function() {
			var $form = $("#movieForm");
			$.post(
			$form.attr("action") + ".json", $form.serialize() + "&_method=put", function( data ) {
				//alert(data.success);
			});
			$(document).trigger('MOVIE_UPDATED', movie.id);
			return false;
		});
	};

	self.pendingCreate = function( movie ) {
		div.html($.View('//movies/views/createmovie.ejs', {
			movie: movie
		}));
		div.find("button,input[type=submit]").button();
		$("#rating").raty({
			number: 10,
			path: '/images/',
			scoreName: 'movie[rating]'
		});
		$("#formatset", div).buttonset();
		$("#cancel").click(function() {
			self.updateCurrent(movie);
		});
		$("#movieForm").submit(function() {
			var $form = $("#movieForm");
			$.post(
			$form.attr("action") + ".json", $form.serialize() + "&_method=post", function( data ) {
				//alert(data.success);
			});
			$(document).trigger('NEW_MOVIE');
			return false;
		});
	};

};

var Controller = function() {

	var self = this;

	$(document).bind('MOVIE_SELECTED', function( e, data ) {
		self.updateSelected(data);
	});
	$(document).bind('MOVIE_RETRIEVED', function( e, data ) {
		self.retrieved(data);
	});

	self.updateSelected = function( id ) {
		$(document).trigger('GET_MOVIE', id);
	};

	self.retrieved = function( movie ) {
		$(document).trigger('CURRENT_MOVIE_CHANGED', movie);
	};

	$(document).bind('MOVIE_UPDATED', function( e, id ) {
		//$("#moviegrid").trigger("reloadGrid"); 
		$(document).trigger('INVALIDATE_CACHE', id);
		self.updateSelected(id);
	});

	$(document).bind('NEW_MOVIE', function( e ) {
		$("#moviegrid").trigger("reloadGrid");
	});

};

var Model = function() {

	var self = this;
	var cache = new Object();

	$(document).bind('GET_MOVIE', function( e, data ) {
		self.getMovie(data);
	});

	self.getMovie = function( id ) {
		//Check if movie is in cache
		if ( cache[id] ) {
			//Cache hit
			var movie = cache[id];
			$(document).trigger('MOVIE_RETRIEVED', movie);
		} else {
			//Get Movie from server
			$.getJSON('movies/' + id + '.json', function( data ) {
				var movie = data.movie;
				cache[id] = movie;
				$(document).trigger('MOVIE_RETRIEVED', movie);
			});
		}
	};

	$(document).bind('INVALIDATE_CACHE', function( e, id ) {
		delete cache[id];
	});

};