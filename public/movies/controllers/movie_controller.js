/*global confirm: true */

/**
 * @tag controllers, home
 * Displays a table of movies.	 Lets the user 
 * ["Movies.Controllers.Movie.prototype.form submit" create], 
 * ["Movies.Controllers.Movie.prototype.&#46;edit click" edit],
 * or ["Movies.Controllers.Movie.prototype.&#46;destroy click" destroy] movies.
 */
$.Controller.extend('Movies.Controllers.Movie',
/* @Static */
{
	onDocument: true
},
/* @Prototype */
{
	/**
	 * When the page loads, initialize Grid.
	 */
	load: function() {
		var self = this;
		var currentSelected = 0;
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
				width: 200
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
				if ( currentSelected != id ) {
					Movies.Models.Movie.findOne({
						id: id
					}, function( movie ) {
						self.show(movie);
					});
				}
			},
			loadComplete: function() {
				//Select first movie in list
				$("#moviegrid").find("tbody tr:nth-child(2)").click();
			}
		}).jqGrid('navGrid', '#movienav', {
			edit: false,
			del: false,
			addtext: "Add Movie",
			addfunc: function() {
				self.addDialog();
			}
		}).filterToolbar();
		$('.ui-jqgrid-titlebar').hide();

		$(window).bind('resize', function() {
			$("#moviegrid").setGridWidth($("#listview").width() - 20, true);
		}).trigger('resize');
	},
	/**
	 * Displays a list of movies and the submit form.
	 * @param {Array} movies An array of Movies.Models.Movie objects.
	 */
	list: function( movies ) {
		$('#movie').html(this.view('init', {
			movies: movies
		}));
	},
	/**
	 * Responds to the create form being submitted by creating a new Movies.Models.Movie.
	 * @param {jQuery} el A jQuery wrapped element.
	 * @param {Event} ev A jQuery event whose default action is prevented.
	 */
	'form submit': function( el, ev ) {
		ev.preventDefault();
		Movies.Models.Movie.create(el.serialize());
	},
	/**
	 * Listens for movies being created.	 When a movie is created, displays the new movie.
	 * @param {String} called The open ajax event that was called.
	 * @param {Event} movie The new movie.
	 */
	'movie.created subscribe': function( called, movie ) {
		$("#moviegrid").trigger("reloadGrid");
	},
	/**
	 * Creates and places the edit interface.
	 * @param {jQuery} el The movie's edit link element.
	 */
	'.edit click': function( el ) {
		var div = $("#itemview");
		var movie = el.closest('.movie').model();
		div.html(this.view('edit', movie));
		div.find("button,input[type=submit]").button();
		$("#rating").raty({
			start: movie.rating,
			number: 10,
			path: '/images/',
			scoreName: 'movie[rating]',
			showCancel: true
		});
		$("#formatset", div).buttonset();
		$("#genres_multiselect", div).multiselect(
			{
				header: false,
				selectedList: 4
			}
		);
	},
	/**
	 * Removes the edit interface.
	 * @param {jQuery} el The movie's cancel link element.
	 */
	'.cancel click': function( el ) {
		this.show(el.closest('.movie').model());
	},
	/**
	 * Updates the movie from the edit values.
	 */
	'.update click': function( el ) {
		var $movie = el.closest('.movie');
		Movies.Models.Movie.update($movie.model().id,$movie.serialize());
		//$movie.model().update($movie.formParams());
	},
	/**
	 * Listens for updated movies.	 When a movie is updated, 
	 * update's its display.
	 */
	'movie.updated subscribe': function( called, movie ) {
		$("#moviegrid").trigger("reloadGrid");
		//this.show(movie);
	},

	create: function( movie ) {
		var div = $("#itemview");
		div.html(this.view('create', movie));
		div.find("button,input[type=submit]").button();
		$("#rating").raty({
			start: movie.rating,
			number: 10,
			path: '/images/',
			scoreName: 'movie[rating]',
			showCancel: true
		});
		$("#formatset", div).buttonset();
		$("#genres_multiselect", div).multiselect(
			{
				header: false,
				selectedList: 4
			}
		);
	},
	
	'.cancelcreate click': function(){
		$("#moviegrid").trigger("reloadGrid");
	},

	/**
	 * Shows a movie's information.
	 */
	show: function( movie ) {
		var div = $("#itemview");
		div.html(this.view('show', movie));
		div.find("button").button();
		$("#rating").raty({
			readOnly: true,
			start: movie.rating,
			number: 10,
			path: '/images/'
		});
	},

	/**
	 *	 Handle's clicking on a movie's destroy link.
	 */
	'.destroy click': function( el ) {
		if ( confirm("Are you sure you want to destroy?") ) {
			el.closest('.movie').model().destroy();
		}
	},
	/**
	 *	 Listens for movies being destroyed and removes them from being displayed.
	 */
	"movie.destroyed subscribe": function( called, movie ) {
		movie.elements().remove(); //removes ALL elements
	},

	addDialog: function() {
		var self = this;
		div = "#addmovie_form";

		$("body").append(self.view('addDialog', {}));

		$(div).dialog({
			modal: true,
			buttons: {
				"Create": function() {
					$("form",div).submit();
				},
				"Cancel": function() {
					$(this).dialog("close");
				}
			},
			open: function( event, ui ) {
				$("button:first", ui).focus();
			},
			close: function() {
				$(div).remove();
			}
		});
		$("form",div).submit(function(ev){
			ev.preventDefault();
			var name = $("#addmovie_name").val();
			Movies.Models.Movie.search(name, function( movies ) {
				self.showSelections(movies);
			});
			$(div).dialog("close");
		});
	},

	showSelections: function( movies ) {
		var self = this;
		div = "#choices";

		$("body").append(self.view('selection', {
			movies: movies
		}));
		$(".choice").button().click(function() {
			var id = $(this).val();
			setTimeout(function() {
				Movies.Models.Movie.getInfo(id, function( m ) {
					self.create(m);
				});
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
	}

});
