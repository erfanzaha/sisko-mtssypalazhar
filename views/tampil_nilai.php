<?php defined('BASEPATH') OR exit('No direct script access allowed');?>
<style type="text/css">
	input[type="checkbox"] {
		width: 20px;
		height: 20px;
	}
</style>
<script type="text/javascript">
	// Data Source
	DS.Presence = {
		present: 'Hadir',
		sick: 'Sakit',
		permit: 'Izin',
		absent: 'Alpa'
	};
	// Course Class ID
	var course_class_id = '<?=$this->uri->segment(4)?>';

	$( document ).ready( function() {
		// Select2
		$( document ).find( '.select2' ).select2();

		$('#btn-change').on('click', function() {
			$('#date').removeAttr('disabled');
			$('#btn-change, #btn-save-class-meetings, #show-meeting-attendence, #save-meeting-attendence').hide();
			$('#btn-search').show();
			$('#start_time, #end_time, #discussion').val('');
			$('.meeting-attendence').empty();
		});

		// Date Picker
		$( document ).find( 'input.date' ).datetimepicker({
			format: 'yyyy-mm-dd',
			weekStart: 1,
			todayBtn:  1,
			autoclose: 1,
			todayHighlight: 1,
			startView: 2,
			minView: 2,
			forceParse: 0
		});

		// Time Picker
		$( document ).find( 'input.time' ).datetimepicker({
			format: 'hh:ii:ss',
			weekStart: 1,
			autoclose: 1,
			startView: 1,
			minView: 0,
			maxView: 1,
			forceParse: 0
		});
	});

	/**
	* Search Class Meetings by Class Group ID and Date
	*/
	function is_exists() {
		var values = {
			course_class_id: course_class_id,
		}
		if (values['course_class_id']) {
			_H.Loading( true );
			// alert('Test Aja');

			// _H.Loading( false );


			$.post(_BASE_URL + 'tampil_nilai/is_exists', values, function( response ) {
				_H.Loading( false );
				var res = _H.StrToObject( response );
				// console.log(res);
				
				if ( res.is_exists ) {
					
					$('#btn-search').hide();
					$('#btn-change, #btn-save-class-meetings, #show-meeting-attendence').show();
					_get_class_meetings();
				} else {
					eModal.confirm('Tidak ditemukan data Kegiatan Belajar Mengajar (KBM) untuk Mata Pelajaran ' + ($('#subject_name').text()) + '. Apakah Anda akan mengajar di kelas ' + ($('#class_group').text()) + ' dengan Mata Pelajaran ' + ($('#subject_name').text()) + '?', 'Konfirmasi').then(function() {
						_insert_class_meetings();
					});
					// alert('Gagal Mendapatkan Data');
					
				}
			});
		} else {
			_H.Notify('warning', 'Data Kelas Tidak Boleh Kosong');
		}
	}

	/**
	 * Insert/Update Class Meetings by Class Group ID and Date
	 */
	function _insert_class_meetings() {
		var values = {
			course_class_id: course_class_id,
			// date: $('#date').val()
		}
		if (values['course_class_id']) {
			_H.Loading( true );
			$.post(_BASE_URL + 'tampil_nilai/insert', values, function( response ) {
				_H.Loading( false );
				var res = _H.StrToObject( response );
				if (res.status == 'success') {
					// Get Class Meetings
					_get_meeting_attendence();
					_H.Notify('success', 'Proses penginputan data Kegiatan Belajar Mengajar (KBM) di tanggal berhasil disimpan. Silahkan lengkapi data jam mulai, jam selesai, topik, dan presensi siswa.');
				} else {
					_H.Notify('error', 'Proses penginputan data Kegiatan Belajar Mengajar (KBM) di tanggal gagal disimpan. Silahkan periksa kembali data Anda.');
				}
			});
		} else {
			_H.Notify('warning', 'Tanggal harus diisi dengan format YYYY-MM-DD');
		}
	}

	/**
	 * Get Class Meetings
	 */
	function _get_class_meetings() {
		var values = {
			course_class_id: course_class_id,
			date: $('#date').val()
		}
		if (values['date'] && _H.IsValidDate(values['date'])) {
			_H.Loading( true );
			$.post(_BASE_URL + 'teacher/class_meetings/get_class_meetings', values, function( response ) {
				var res = _H.StrToObject( response );
				$('#date').val(res.date);
				$('#start_time').val(res.start_time);
				$('#end_time').val(res.end_time);
				$('#discussion').val(res.discussion || '');
				$('#btn-search').hide();
				$('#btn-change, #btn-save-class-meetings, #show-meeting-attendence').show();
				$('#start_time, #end_time, #discussion').removeAttr('disabled');
				$('#date').attr('disabled', 'disabled');
				_H.Loading( false );
			});
		} else {
			_H.Notify('warning', 'Tanggal harus diisi dengan format YYYY-MM-DD');
		}
	}

	/**
	 * Get Meeting Attendances
	 */
	function _get_meeting_attendence() {
		var values = {
			course_class_id: course_class_id,
		}
		if (values['course_class_id']) {
			_H.Loading( true );
			$.post(_BASE_URL + 'teacher/input_scores/get_grade_attendences', values, function( response ) {
				_H.Loading( false );
				$('#print-meeting-attendence').show();
				var res = _H.StrToObject( response );
				var meeting_attendences = res.grade_attendences;
				var str = '';
				if (meeting_attendences.length) {
					$('#save-meeting-attendence').show();
					str += '<thead class="header">';
					str += '<tr>';
					str += '<th width="30px">NO</th>';
					str += '<th>NIS</th>';
					str += '<th>NAMA LENGKAP</th>';
					str += '<th>L/P</th>';
					str += '<th>Nilai Tugas</th>';
					str += '<th>Nilai UTS</th>';
					str += '<th>Nilai UAS</th>';
					str += '</tr>';
					str += '</thead>';
					str += '<tbody>';
					var no = 1;
					for (var z in meeting_attendences) {
						var row = meeting_attendences[ z ];
						str += '<tr class="siswa" id="ma_'+ row.id + '">';
						str += '<td>' + no + '.</td>';
						str += '<td>' + row.nis + '</td>';
						str += '<td>' + row.full_name + '</td>';
						str += '<td>' + row.gender + '</td>';
						str += '<td>';
						str += '<input type="text" class="form-control assignment" id="ma_'+ row.id + '_assignment" value="' + row.assignment_score +'">';
						str += '</td>';
						str += '<td>';
						str += '<input type="text" class="form-control mid" id="ma_' + row.id + '_mid" value="' + row.mid_score +'">';
						str += '</td>';
						str += '<td >';
						str += '<input type="text" class="form-control exam" id="ma_' + row.id + '_exam" value="' + row.exam_score +'">';
						str += '</td>';
						str += '</tr>';
						no++;
					}
					str += '</tbody>';
					$('.meeting-attendence').empty().html(str);
					$(".select2").select2({ width: '100%' });
					$('#save-meeting-attendence').show();
				} else {
					$('.meeting-attendence').empty();
					$('#save-meeting-attendence').hide();
				}
			});
		} else {
			_H.Notify('warning', 'Tanggal harus diisi dengan format YYYY-MM-DD');
		}
	}

	// /**
	//  * Update Class Meetings
	//  */
	function _update_class_meetings() {
		var values = {
			course_class_id: course_class_id,
			date: $('#date').val(),
			start_time: $('#start_time').val(),
			end_time: $('#end_time').val(),
			discussion: $('#discussion').val()
		}
		if (values['date'] && _H.IsValidDate(values['date'])) {
			_H.Loading( true );
			$.post(_BASE_URL + 'teacher/class_meetings/update', values, function( response ) {
				_H.Loading( false );
				var res = _H.StrToObject( response );
				if (res.status == 'success') {
					var message = 'Proses penginputan data Kegiatan Belajar Mengajar (KBM) di tanggal ' + _H.ToIndonesianDate(values['date']) + ' berhasil disimpan. Silahkan lengkapi data jam mulai, jam selesai, topik, dan presensi siswa.';
					if (res.method == 'update') {
						message = 'Data Kegiatan Belajar Mengajar (KBM) di tanggal ' + _H.ToIndonesianDate(values['date']) + ' berhasil diperbaharui.';
					}
					_H.Notify('success', message);
				} else {
					_H.Notify('error', 'Proses penginputan data Kegiatan Belajar Mengajar (KBM) di tanggal ' + _H.ToIndonesianDate(values['date']) + ' gagal disimpan. Silahkan periksa kembali data Anda.');
				}
			});
		} else {
			_H.Notify('warning', 'Tanggal harus diisi dengan format YYYY-MM-DD');
		}
	}

	/**
	 * Update Meeting Attendences
	 */
	function _update_meeting_attendences() {
		var rows = $('.meeting-attendence').find('.siswa');
		
		var meeting_attendences = [];
		rows.each(function() {
			let assignment_score = $(this).find('.assignment').val();
			let mid_score = $(this).find('.mid').val();
			let exam_score = $(this).find('.exam').val();
			// console.log($(this).);
			
			meeting_attendences.push({
				id:this.id.split('_')[ 1 ],
				assignment_score: assignment_score,
				mid_score: mid_score,
				exam_score: exam_score,
			});
		});

		var values = {
			course_class_id: course_class_id,
			grade_attendences: JSON.stringify(meeting_attendences)
		}

		if (values) {
			_H.Loading( true );
			$.post(_BASE_URL + 'teacher/input_scores/update', values, function( response ) {
				_H.Loading( false );
				var res = _H.StrToObject( response );
				if (res.status == 'success') {
					_H.Notify('success', 'Proses penyimpanan data presensi tanggal berhasil.');
					_get_meeting_attendence();
				} else {
					_H.Notify('warning', 'Terjadi kesalahan dalam proses penyimpanan data presensi tanggal ' + _H.ToIndonesianDate(values['date']) + '. Silahkan periksa kembali data Anda.');
				}
			});
		} else {
			_H.Notify('warning', 'Tanggal harus diisi dengan format YYYY-MM-DD');
		}
	}

	/**
	 * Print Meeting Attendences
	 */
	function _print_meeting_attendance() {
			window.location.href = _BASE_URL + 'teacher/input_scores/print_students_scores/' + course_class_id; 
		
	}
</script>
<section class="content-header">
   <div class="header-icon">
      <i class="fa fa-sign-out"></i>
   </div>
   <div class="header-title">
      <p class="table-header"><?=isset($title) ? $title : ''?></p>
      <?=isset($sub_title) ? '<small>'.$sub_title.'</small>' : ''?>
   </div>
</section>
<section class="content">
	<div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
			<div class="box">
				<div class="box-body">
					<div class="row">
						<div class="col-md-5">
							<form class="form-horizontal">
								<div class="form-group">
									<label for="class_group_id" class="col-sm-5 control-label">Mata Pelajaran :</label>
									<div class="col-sm-7">
										<p class="form-control-static" id="subject_name"><?=$query->subject_name?></p>
									</div>
								</div>
								<div class="form-group">
									<label for="academic_year_id" class="col-sm-5 control-label">Tahun Pelajaran :</label>
									<div class="col-sm-7">
										<p class="form-control-static"><?=$query->academic_year?></p>
									</div>
								</div>
								<div class="form-group">
									<label for="semester" class="col-sm-5 control-label">Semester :</label>
									<div class="col-sm-7">
										<p class="form-control-static"><?=$query->semester?></p>
									</div>
								</div>
								<div class="form-group">
									<label for="class_group_id" class="col-sm-5 control-label">Kelas :</label>
									<div class="col-sm-7">
										<p class="form-control-static" id="class_group"><?=$query->class_group?></p>
									</div>
								</div>
							</form>
						</div>
					</div>
					
					<div class="btn-group" style="margin-left:40%">
						<button type="submit" class="btn btn-primary" id="btn-search" onclick="is_exists(); return false;"><i class="fa fa-eye"></i> Tampil Nilai</button>
					</div>
						<!-- <div class="col-md-7">
							<form class="form-inline" style="margin-bottom: 5px">
								<div class="form-group">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" autocomplete="off" class="form-control date" id="date" placeholder="Tanggal">
									</div>
								</div>
							</form>
							<form>
								<div class="form-group">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
										<input disabled="disabled" id="start_time" type="text" autocomplete="off" class="form-control time" placeholder="Jam Mulai">
									</div>
								</div>
								<div class="form-group">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
										<input disabled="disabled" id="end_time" type="text" autocomplete="off" class="form-control time" placeholder="Jam Selesai">
									</div>
								</div>
								<div class="form-group">
									<textarea disabled="disabled" id="discussion" class="form-control" rows="5" placeholder="Topik"></textarea>
								</div>
							</form>
						</div> -->
					
					<div class="btn-group">
						<button id="show-meeting-attendence" style="display: none; margin-bottom: 10px;" type="button" onclick="_get_meeting_attendence(); return false;" class="btn btn-warning"><i class="fa fa-search"></i> TAMPILKAN PESERTA DIDIK</button>
					</div>
					<!-- &nbsp;&nbsp;
					<div class="btn-group">
						<button id="print-meeting-attendence" style="display: none; margin-bottom: 10px;" type="button" onclick="_print_meeting_attendance(); return false;" class="btn btn-primary"><i class="fa fa-file-pdf-o"></i> CETAK</button>
					</div> -->
					<br>
					<br>
					<div class="table-responsive">
						<table class="table table-striped table-condensed meeting-attendence" readonly></table>
					</div>
					
					<!-- <div class="table-responsive">
						<table class="table table-striped table-condensed meeting-attendence">
							<thead class="header">
							<th width="30px">NO</th>
							<th>NIS</th>
							<th>NAMA LENGKAP</th>
							<th>L/P</th>
							<th>Nilai Assignment</th>
							<th>Nilai UTS</th>
							<th>Nilai UAS</th>


							</thead>
							<tbody>
								
							</tbody>
						</table>
					</div> -->
					<!-- <button style="display: none;" id="save-meeting-attendence" type="button" onclick="_update_meeting_attendences(); return false;" class="btn btn-block btn-primary"><i class="fa fa-save"></i> SIMPAN NILAI</button> -->
				</div>
			</div>
		</div>
	 </div>
 </section>
