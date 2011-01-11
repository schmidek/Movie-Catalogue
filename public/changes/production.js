steal.packs('0', function(){
steal('//jquery/jquery.js'
,'//changes/resources/changes.js'
,'//changes/changes.js');
steal.end();
/* changes/resources/changes.js */
$(document).ready(function(){jQuery("#changes-table").jqGrid({url:"changes.json",datatype:"json",colNames:["Type","Movie","Diff","User","Time"],colModel:[{name:"change_type",index:"change_type",width:75,stype:"select",editoptions:{value:":All;add:Add;update:Update;delete:Delete"}},{name:"movie",index:"movies.name",width:200},{name:"diff",index:"diff",width:400,search:false,sortable:false},{name:"user",index:"users.login",width:100},{name:"created_at",index:"created_at",width:200,search:false}],rowNum:10,
pager:"#changes-div",sortname:"created_at",viewrecords:true,sortorder:"desc",caption:"Changes",height:"100%",onSelectRow:function(){}}).jqGrid("navGrid","#changes-div",{edit:false,del:false,add:false}).filterToolbar();$(".ui-jqgrid-titlebar").hide();$(window).bind("resize",function(){$("#changes-table").setGridWidth($("#changes-parent").width(),true)}).trigger("resize")});
;steal.end();
/* changes/changes.js */
steal.plugins("jquery","javascripts/grid.locale-en","javascripts/jquery.jqGrid.min").css().resources("changes.js").models().controllers().views();

});
