//steal/js changes/scripts/compress.js

load("steal/rhino/steal.js");
steal.plugins('steal/build','steal/build/scripts','steal/build/styles',function(){
	steal.build('changes/scripts/build.html',{to: 'changes'});
});
