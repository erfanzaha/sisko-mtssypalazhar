<?php defined('BASEPATH') OR exit('No direct script access allowed');
$this->load->view('backend/grid_index');?>
<script type="text/javascript">
    var _grid = 'SUBJECTS', _form = _grid + '_FORM';
	new GridBuilder( _grid , {
        controller:'academic/subjects',
        fields: [
            { 
                header: '<input type="checkbox" class="check-all">', 
                renderer: function( row ) {
                    return CHECKBOX(row.id, 'id');
                },
                exclude_excel: true,
                sorting: false
            },
            { 
                header: '<i class="fa fa-edit"></i>', 
                renderer: function( row ) {
                    return A(_form + '.OnEdit(' + row.id + ')', 'Edit');
                },
                exclude_excel: true,
                sorting: false
            },
            { header:'Mata Pelajaran', renderer:'subject_name' }
    	]
    });

    new FormBuilder( _form , {
	    controller:'academic/subjects',
	    fields: [
            { label:'Mata Pelajaran', name:'subject_name' }
	    ]
  	});
</script>