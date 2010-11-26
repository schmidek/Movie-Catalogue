//initialize grid
jQuery("#changes-table").jqGrid({        
   	url:'changes.json',
	datatype: "json",
   	colNames:['Type','Movie','Diff','User','Time'],
   	colModel:[
   		{name:'change_type',index:'change_type', width:75},
   		{name:'movie',index:'movies.name',width:200},
   		{name:'diff',index:'diff',width:400},
   		{name:'user',index:'users.login',width:100},
   		{name:'created_at',index:'created_at',width:200}
   	],
   	rowNum:10,
   	//rownumbers: true,
   	pager: '#changes-div',
   	sortname: 'created_at',
    viewrecords: true,
    sortorder: "desc",
    //scroll:1,
	caption: "Changes",
	height: '100%',
	//autowidth: true,
	onSelectRow: function(id){
		//self.handleClick(id);
	}
})
.jqGrid('navGrid','#changes-div',{edit:false,del:false,add:false})
.filterToolbar();
$('.ui-jqgrid-titlebar').hide();
