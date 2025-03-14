<?php defined('BASEPATH') OR exit('No direct script access allowed');?>
<style type="text/css">
legend {
	margin-bottom: 30px;
	margin-top: 30px;
}
</style>
<script type="text/javascript">
$( document ).ready( function() {
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
});

function save_changes() {
	var values = {
		birth_place: $('#birth_place').val(),
		birth_date: $('#birth_date').val(),
		religion_id: $('#religion_id').val(),
		special_need_id: $('#special_need_id').val(),
		street_address: $('#street_address').val(),
		rt: $('#rt').val(),
		rw: $('#rw').val(),
		sub_village: $('#sub_village').val(),
		village: $('#village').val(),
		sub_district: $('#sub_district').val(),
		district: $('#district').val(),
		postal_code: $('#postal_code').val(),
		residence_id: $('#residence_id').val(),
		transportation_id: $('#transportation_id').val(),
		phone: $('#phone').val(),
		mobile_phone: $('#mobile_phone').val(),
		email: $('#email').val(),
		welfare_type: $('#welfare_type').val(),
		welfare_number: $('#welfare_number').val(),
		welfare_name: $('#welfare_name').val(),
		citizenship: $('#citizenship').val(),
		country: $('#country').val(),
		father_name: $('#father_name').val(),
		father_nik: $('#father_nik').val(),
		father_birth_place: $('#father_birth_place').val(),
		father_birth_date: $('#father_birth_date').val(),
		father_education_id: $('#father_education_id').val(),
		father_employment_id: $('#father_employment_id').val(),
		father_monthly_income_id: $('#father_monthly_income_id').val(),
		father_special_need_id: $('#father_special_need_id').val(),
		mother_name: $('#mother_name').val(),
		mother_nik: $('#mother_nik').val(),
		mother_birth_place: $('#mother_birth_place').val(),
		mother_birth_date: $('#mother_birth_date').val(),
		mother_education_id: $('#mother_education_id').val(),
		mother_employment_id: $('#mother_employment_id').val(),
		mother_monthly_income_id: $('#mother_monthly_income_id').val(),
		mother_special_need_id: $('#mother_special_need_id').val(),
		guardian_name: $('#guardian_name').val(),
		guardian_nik: $('#guardian_nik').val(),
		guardian_birth_place: $('#guardian_birth_place').val(),
		guardian_birth_date: $('#guardian_birth_date').val(),
		guardian_education_id: $('#guardian_education_id').val(),
		guardian_employment_id: $('#guardian_employment_id').val(),
		guardian_monthly_income_id: $('#guardian_monthly_income_id').val(),
		mileage: $('#mileage').val(),
		traveling_time: $('#traveling_time').val(),
		height: $('#height').val(),
		weight: $('#weight').val(),
		head_circumference: $('#head_circumference').val(),
		sibling_number: $('#sibling_number').val()
	};
	$.post(_BASE_URL + 'student_profile/save', values, function(response) {
		var res = _H.StrToObject( response );
		_H.Notify(res.status, _H.Message(res.message));
	});
}
</script>
<section class="content">
	<div class="nav-tabs-custom">
		<ul class="nav nav-tabs">
			<li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">REGISTRASI PESERTA DIDIK</a></li>
			<li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">DATA PRIBADI</a></li>
			<li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false">DATA AYAH KANDUNG</a></li>
			<li class=""><a href="#tab_4" data-toggle="tab" aria-expanded="false">DATA IBU KANDUNG</a></li>
			<li class=""><a href="#tab_5" data-toggle="tab" aria-expanded="false">DATA WALI</a></li>
			<li class=""><a href="#tab_6" data-toggle="tab" aria-expanded="false">DATA PERIODIK</a></li>
		</ul>
		<div class="tab-content">
			<div class="tab-pane active" id="tab_1">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="is_transfer" class="col-sm-4 control-label">Jenis Pendaftaran</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="is_transfer" value="<?=$query->is_transfer ? (filter_var($query->is_transfer, FILTER_VALIDATE_BOOLEAN) ? 'Pindahan' : 'Baru') : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="start_date" class="col-sm-4 control-label">Tanggal Masuk Sekolah</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="start_date" value="<?=$query->start_date ? indo_date($query->start_date) : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="prev_exam_number" class="col-sm-4 control-label">Nomor Peserta Ujian</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="prev_exam_number" value="<?=$query->prev_exam_number ? $query->prev_exam_number : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="skhun" class="col-sm-4 control-label">No. SKHUN SMP/MTs Sebelumnya</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="skhun" value="<?=$query->skhun ? $query->skhun : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="prev_diploma_number" class="col-sm-4 control-label">No. Seri Ijazah SMP/MTs</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="prev_diploma_number" value="<?=$query->prev_diploma_number ? $query->prev_diploma_number : '';?>">
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
			<div class="tab-pane" id="tab_2">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="full_name" class="col-sm-4 control-label">Nama Lengkap</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="full_name" value="<?=$query->full_name ? $query->full_name : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="gender" class="col-sm-4 control-label">Jenis Kelamin</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="gender" value="<?=$query->gender ? ($query->gender == 'M' ? 'Laki-laki' : 'Perempuan') : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="nisn" class="col-sm-4 control-label">Nomor Induk Siswa Nasional</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="nisn" value="<?=$query->nisn ? $query->nisn : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="nis" class="col-sm-4 control-label">Nomor Induk Siswa</label>
							<div class="col-sm-8">
								<input readonly="true" type="text" class="form-control" id="nis" value="<?=$query->nis ? $query->nis : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="birth_place" class="col-sm-4 control-label">Tempat Lahir</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="birth_place" value="<?=$query->birth_place ? $query->birth_place : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="birth_date" class="col-sm-4 control-label">Tanggal Lahir</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="form-control date" id="birth_date" value="<?=$query->birth_date ? $query->birth_date : '';?>">
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="religion_id" class="col-sm-4 control-label">Agama</label>
							<div class="col-sm-8">
								<?=form_dropdown('religion_id', $religions, $query->religion_id, 'id="religion_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="special_need_id" class="col-sm-4 control-label">Kebutuhan Khusus</label>
							<div class="col-sm-8">
								<?=form_dropdown('special_need_id', $special_needs, $query->special_need_id, 'id="special_need_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="street_address" class="col-sm-4 control-label">Alamat Jalan</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="street_address" value="<?=$query->street_address ? $query->street_address : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="rt" class="col-sm-4 control-label">RT</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="rt" value="<?=$query->rt ? $query->rt : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="rw" class="col-sm-4 control-label">RW</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="rw" value="<?=$query->rw ? $query->rw : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="sub_village" class="col-sm-4 control-label">Nama Dusun</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="sub_village" value="<?=$query->sub_village ? $query->sub_village : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="village" class="col-sm-4 control-label">Desa/Kelurahan</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="village" value="<?=$query->village ? $query->village : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="sub_district" class="col-sm-4 control-label">Kecamatan</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="sub_district" value="<?=$query->sub_district ? $query->sub_district : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="district" class="col-sm-4 control-label">Kabupaten</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="district" value="<?=$query->district ? $query->district : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="postal_code" class="col-sm-4 control-label">Kode Pos</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="postal_code" value="<?=$query->postal_code ? $query->postal_code : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="residence_id" class="col-sm-4 control-label">Tempat Tinggal</label>
							<div class="col-sm-8">
								<?=form_dropdown('residence_id', $residences, $query->residence_id, 'id="residence_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="transportation_id" class="col-sm-4 control-label">Moda Transportasi</label>
							<div class="col-sm-8">
								<?=form_dropdown('transportation_id', $transportations, $query->transportation_id, 'id="transportation_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="mobile_phone" class="col-sm-4 control-label">Nomor HP</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="mobile_phone" value="<?=$query->mobile_phone ? $query->mobile_phone : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="phone" class="col-sm-4 control-label">Nomor Telepon</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="phone" value="<?=$query->phone ? $query->phone : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="email" class="col-sm-4 control-label">Email Pribadi</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="email" value="<?=$query->email ? $query->email : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="welfare_type" class="col-sm-4 control-label">Jenis Kesejahteraan</label>
							<div class="col-sm-8">
								<?=form_dropdown('welfare_type', welfare_types(), $query->welfare_type, 'id="welfare_type" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="welfare_number" class="col-sm-4 control-label">No. Kartu Kesejahteraan</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="welfare_number" value="<?=$query->welfare_number ? $query->welfare_number : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="welfare_name" class="col-sm-4 control-label">Nama di Kartu Kesejahteraan</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="welfare_name" value="<?=$query->welfare_name ? $query->welfare_name : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="citizenship" class="col-sm-4 control-label">Kewarganegaraan</label>
							<div class="col-sm-8">
								<?=form_dropdown('citizenship', ['WNI' => 'Warga Negara Indonesia', 'WNA' => 'Warga Negara Asing'], $query->citizenship, 'id="citizenship" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="country" class="col-sm-4 control-label">Nama Negara</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="country" value="<?=$query->country ? $query->country : '';?>">
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
			<div class="tab-pane" id="tab_3">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="father_name" class="col-sm-4 control-label">Nama Ayah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="father_name" value="<?=$query->father_name ? $query->father_name : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="father_nik" class="col-sm-4 control-label">NIK Ayah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="father_nik" value="<?=$query->father_nik ? $query->father_nik : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="father_birth_place" class="col-sm-4 control-label">Tempat Lahir Ayah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="father_birth_place" value="<?=$query->father_birth_place ? $query->father_birth_place : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="father_birth_date" class="col-sm-4 control-label">Tanggal Lahir Ayah</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="form-control date" id="father_birth_date" value="<?=$query->father_birth_date ? $query->father_birth_date : '';?>">
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="father_education_id" class="col-sm-4 control-label">Pendidikan Ayah</label>
							<div class="col-sm-8">
								<?=form_dropdown('father_education_id', $educations, $query->father_education_id, 'id="father_education_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="father_employment_id" class="col-sm-4 control-label">Pekerjaan Ayah</label>
							<div class="col-sm-8">
								<?=form_dropdown('father_employment_id', $employments, $query->father_employment_id, 'id="father_employment_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="father_monthly_income_id" class="col-sm-4 control-label">Penghasilan Bulanan Ayah</label>
							<div class="col-sm-8">
								<?=form_dropdown('father_monthly_income_id', $monthly_incomes, $query->father_monthly_income_id, 'id="father_monthly_income_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="father_special_need_id" class="col-sm-4 control-label">Kebutuhan Khusus Ayah</label>
							<div class="col-sm-8">
								<?=form_dropdown('father_special_need_id', $special_needs, $query->father_special_need_id, 'id="father_special_need_id" class="form-control"');?>
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
			<div class="tab-pane" id="tab_4">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="mother_name" class="col-sm-4 control-label">Nama Ibu</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="mother_name" value="<?=$query->mother_name ? $query->mother_name : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="mother_nik" class="col-sm-4 control-label">NIK Ibu</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="mother_nik" value="<?=$query->mother_nik ? $query->mother_nik : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="mother_birth_place" class="col-sm-4 control-label">Tempat Lahir Ayah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="mother_birth_place" value="<?=$query->mother_birth_place ? $query->mother_birth_place : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="mother_birth_date" class="col-sm-4 control-label">Tanggal Lahir Ibu</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="form-control date" id="mother_birth_date" value="<?=$query->mother_birth_date ? $query->mother_birth_date : '';?>">
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="mother_education_id" class="col-sm-4 control-label">Pendidikan Ibu</label>
							<div class="col-sm-8">
								<?=form_dropdown('mother_education_id', $educations, $query->mother_education_id, 'id="mother_education_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="mother_employment_id" class="col-sm-4 control-label">Pekerjaan Ibu</label>
							<div class="col-sm-8">
								<?=form_dropdown('mother_employment_id', $employments, $query->mother_employment_id, 'id="mother_employment_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="mother_monthly_income_id" class="col-sm-4 control-label">Penghasilan Bulanan Ibu</label>
							<div class="col-sm-8">
								<?=form_dropdown('mother_monthly_income_id', $monthly_incomes, $query->mother_monthly_income_id, 'id="mother_monthly_income_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="mother_special_need_id" class="col-sm-4 control-label">Kebutuhan Khusus Ibu</label>
							<div class="col-sm-8">
								<?=form_dropdown('mother_special_need_id', $special_needs, $query->mother_special_need_id, 'id="mother_special_need_id" class="form-control"');?>
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
			<div class="tab-pane" id="tab_5">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="guardian_name" class="col-sm-4 control-label">Nama Wali</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="guardian_name" value="<?=$query->guardian_name ? $query->guardian_name : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_nik" class="col-sm-4 control-label">NIK Wali</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="guardian_nik" value="<?=$query->guardian_nik ? $query->guardian_nik : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_birth_place" class="col-sm-4 control-label">Tempat Lahir Ayah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="guardian_birth_place" value="<?=$query->guardian_birth_place ? $query->guardian_birth_place : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_birth_date" class="col-sm-4 control-label">Tanggal Lahir Wali</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="form-control date" id="guardian_birth_date" value="<?=$query->guardian_birth_date ? $query->guardian_birth_date : '';?>">
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_education_id" class="col-sm-4 control-label">Pendidikan Wali</label>
							<div class="col-sm-8">
								<?=form_dropdown('guardian_education_id', $educations, $query->guardian_education_id, 'id="guardian_education_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_employment_id" class="col-sm-4 control-label">Pekerjaan Wali</label>
							<div class="col-sm-8">
								<?=form_dropdown('guardian_employment_id', $employments, $query->guardian_employment_id, 'id="guardian_employment_id" class="form-control"');?>
							</div>
						</div>
						<div class="form-group">
							<label for="guardian_monthly_income_id" class="col-sm-4 control-label">Penghasilan Bulanan Wali</label>
							<div class="col-sm-8">
								<?=form_dropdown('guardian_monthly_income_id', $monthly_incomes, $query->guardian_monthly_income_id, 'id="guardian_monthly_income_id" class="form-control"');?>
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
			<div class="tab-pane" id="tab_6">
				<form class="form-horizontal">
					<div class="box-body">
						<div class="form-group">
							<label for="mileage" class="col-sm-4 control-label">Jarak Tempat Tinggal ke Sekolah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="mileage" value="<?=$query->mileage ? $query->mileage : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="traveling_time" class="col-sm-4 control-label">Waktu Tempuh ke Sekolah</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="traveling_time" value="<?=$query->traveling_time ? $query->traveling_time : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="height" class="col-sm-4 control-label">Tinggi Badan (Cm)</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="height" value="<?=$query->height ? $query->height : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="weight" class="col-sm-4 control-label">Berat Badan (Kg)</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="weight" value="<?=$query->weight ? $query->weight : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="head_circumference" class="col-sm-4 control-label">Lingkar Kepala (Cm)</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="head_circumference" value="<?=$query->head_circumference ? $query->head_circumference : '';?>">
							</div>
						</div>
						<div class="form-group">
							<label for="sibling_number" class="col-sm-4 control-label">Jumlah Saudara Kandung</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="sibling_number" value="<?=$query->sibling_number ? $query->sibling_number : '';?>">
							</div>
						</div>
					</div>
					<div class="box-footer">
						<div class="col-sm-offset-4 col-sm-8">
							<button type="submit" onclick="save_changes(); return false;" class="btn btn-primary"><i class="fa fa-save"></i> SIMPAN PERUBAHAN</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</section>
