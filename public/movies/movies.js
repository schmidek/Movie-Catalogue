steal.plugins('jquery/controller',
'jquery/controller/subscribe', 
'jquery/view/ejs', 
'jquery/view/helpers', 
'jquery/model', 
'javascripts/grid.locale-en', 
'javascripts/jquery.jqGrid.min', 
'javascripts/jquery.raty.min', 
'javascripts/jquery.multiselect.min',
'jquery/dom/form_params')

.css('jquery.multiselect')
.models('movie','genre')
.controllers('movie')
.resources()

.views('//movies/views/movie/addDialog.ejs', 
'//movies/views/movie/create.ejs', 
'//movies/views/movie/edit.ejs', 
'//movies/views/movie/partialSelection.ejs', 
'//movies/views/movie/selection.ejs', 
'//movies/views/movie/show.ejs');
