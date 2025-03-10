<?php defined('BASEPATH') OR exit('No direct script access allowed');
$this->load->view('backend/grid_index');?>
<script type="text/javascript">
var current_semester_id = '<?=$current_semester_id;?>';
var _grid = 'NILAI_SISWA';
new GridBuilder( _grid , {
   controller:'nilai_siswa',
   fields: [
      {
         header: '<i class="fa fa-edit"></i>',
         renderer: function( row ) {
            if (parseInt(current_semester_id) === parseInt(row.academic_year_id)) {
               return Ahref(_BASE_URL + 'tampil_nilai/index/' + row.id, 'Masuk Kelas', '<i class="fa fa-edit"></i>');
            }
            return '';
         },
         exclude_excel: true,
         sorting: false
      },
      { header:'Tahun Pelajaran', renderer:'academic_year' },
      { header:'Semester', renderer:'semester' },
      { header:'Kelas', renderer:'class_name' },
      { header:'Mata Pelajaran', renderer:'subject_name' }
   ],
   resize_column: 2,
   can_add: false,
   can_delete: false,
   can_restore: false
});
</script>
