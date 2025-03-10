<?php defined('BASEPATH') or exit('No direct script access allowed');
$this->load->view('backend/grid_index'); ?>
<script type="text/javascript">
    var _grid = 'STUDENT_SCORE';
    new GridBuilder(_grid, {
        controller: 'student_score',
        fields: [
            {
                header: 'Mata Pelajaran',
                renderer: 'subject_name'
            },
            {
                header: 'Guru Pengajar',
                renderer: 'full_name'
            },
            {
                header: 'Kelas',
                renderer: function(row) {
                    return row.class_group + ' - ' + row.sub_class_group;
                },
            },
            {
                header: 'Tahun Ajaran',
                renderer: function(row) {
                    return row.academic_year + ' - ' + row.semester;
                },
            },
            {
                header: 'Nilai Tugas',
                renderer: 'assignment_score'
            },
            {
                header: 'Nilai UTS',
                renderer: 'mid_score'
            },
            {
                header: 'Nilai UAS',
                renderer: 'exam_score'
            },
        ],
        resize_column: 1,
        can_add: false,
        can_delete: false,
        can_restore: false
    });
</script>