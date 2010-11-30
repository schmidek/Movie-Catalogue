//steal/js movies/scripts/compress.js

load("steal/rhino/steal.js");
steal.plugins('steal/build','steal/build/scripts','steal/build/styles',function(){
	steal.build('movies/scripts/build.html',{to: 'movies'});
});
