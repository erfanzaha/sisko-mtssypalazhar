<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Admission_form extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		// If close, redirect
		if (__session('admission')['admission_status'] == 'close') {
			return redirect(base_url());
		}

		// If not in array, redirect
		$admission_start_date = __session('admission_start_date');
		$admission_end_date = __session('admission_end_date');
		if (NULL !== $admission_start_date && NULL !== $admission_end_date) {
			$date_range = array_date($admission_start_date, $admission_end_date);
			if ( ! in_array(date('Y-m-d'), $date_range)) {
				return redirect(base_url());
			}
		}

		$this->load->model('m_registrants');
		$this->pk = M_registrants::$pk;
		$this->table = M_registrants::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper(['string', 'form']);
		$this->load->model('m_majors');
		$this->vars['page_title'] = 'Formulir Penerimaan Peserta Didik Baru Tahun '.__session('admission_year');
		$this->vars['religions'] = ['' => 'Pilih :'] + get_options('religion', FALSE);
		$this->vars['special_needs'] = get_options('special_need', FALSE);
		$this->vars['residences'] = ['' => 'Pilih :'] + get_options('residence', FALSE);
		$this->vars['transportations'] = ['' => 'Pilih :'] + get_options('transportation', FALSE);
		$this->vars['educations'] = ['' => 'Pilih :'] + get_options('education', FALSE);
		$this->vars['employments'] = ['' => 'Pilih :'] + get_options('employment', FALSE);
		$this->vars['monthly_incomes'] = ['' => 'Pilih :'] + get_options('monthly_income', FALSE);
		$this->vars['majors'] = ['' => 'Pilih :'] + $this->m_majors->dropdown();
		$this->vars['admission_types'] = ['' => 'Pilih :'] + get_options('admission_type', FALSE);
		$this->vars['content'] = 'themes/'.theme_folder().'/admission-form';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}

	/**
	* Save
	*/
	public function save() {
		if ($this->input->is_ajax_request()) {
			if (__captchaActivated()) {
				$score = get_recapture_score($this->input->post('g-recaptcha-response'));
				if ($score < 0.9) {
					$this->vars['status'] = 'recaptcha_error';
	    			$this->vars['message'] = 'Recaptcha Error!';
					$this->output
						->set_content_type('application/json', 'utf-8')
						->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
						->_display();
					exit;
				}
			}

			if ($this->validation()) {
				$dataset = $this->dataset();
				$documents = [
					['name' => 'photo', 'upload_status' => false],
					['name' => 'family_card', 'upload_status' => false],
					['name' => 'birth_certificate', 'upload_status' => false],
					['name' => 'father_identity_card', 'upload_status' => false],
					['name' => 'mother_identity_card', 'upload_status' => false],
					['name' => 'guardian_identity_card', 'upload_status' => false]
				];
				foreach($documents as $key => $document) {
					if ( ! empty($_FILES[$document['name']]['name']) ) {
						$upload = $this->upload_file($document['name']);
						if ($upload['status'] == 'success') {
							$documents[ $key ]['upload_status'] = true;
							$dataset[$document['name']] = $upload['file_name'];
						} else {
							$this->vars['status'] = $upload['status'];
							$this->vars['message'] = $upload['message'];
							$this->output
								->set_content_type('application/json', 'utf-8')
								->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
								->_display();
							exit;
						}
					}
				}
				// Get Subject Values / Nilai Mata Pelajaran
				$subject_scores = json_decode($this->input->post('subject_scores'), true);
				$query = $this->m_registrants->save_registration_form($dataset, $subject_scores);
				if ( $query ) {
					$res = $this->m_registrants->find_registrant($dataset['registration_number'], $dataset['birth_date']);
					if ( is_null($res) ) {
						$this->vars['status'] = 'warning';
						$this->vars['message'] = 'Data dengan tanggal lahir '.indo_date($query->birth_date).' dan nomor pendaftaran ' . $res['registration_number'].' tidak ditemukan.';
					} else {
						$this->vars['status'] = 'success';
						$this->vars['id'] = $res['id'];
						$this->vars['registration_number'] = $res['registration_number'];
						$this->vars['birth_date'] = $res['birth_date'];
					}
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = 'Terjadi kesalahan dalam menyimpan data';
				}
				foreach($documents as $document) {
					if ( ! $query && FALSE === $document['upload_status']) {
						@unlink(FCPATH.'media_library/users/photo/' . $document['name'] . '/' . $dataset[$document['name']]);
					}
				}
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = validation_errors();
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	  * Upload File
	  * @return Array
	  */
	private function upload_file( $document_name ) {
		$config['upload_path'] = './media_library/users/' . $document_name . '/';
		$config['allowed_types'] = 'jpg|jpeg|png';
		$config['max_size'] = 512; // 512 KB
		$config['encrypt_name'] = TRUE;
		$this->load->library('upload');
		$this->upload->initialize($config);
		if ( ! $this->upload->do_upload( $document_name ) ) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = $this->upload->display_errors();
			$this->vars['file_name'] = '';
		} else {
			$file = $this->upload->data();
			@chmod(FCPATH.'media_library/users/' . $document_name . '/' . $file['file_name'], 0777);
			if ($document_name === 'photo') $this->image_resize(FCPATH.'media_library/users/' . $document_name . '/', $file['file_name']);
			$this->vars['status'] = 'success';
			$this->vars['message'] = 'uploaded';
			$this->vars['file_name'] = $file['file_name'];
		}
		return $this->vars;
	}

	/**
	 * Image Resize
	 * @param String $path
	 * @param String $file_name
	 * @return Void
	 */
	private function image_resize($path, $file_name) {
		$this->load->library('image_lib');
		$config['image_library'] = 'gd2';
		$config['source_image'] = $path .'/'.$file_name;
		$config['maintain_ratio'] = TRUE;
		$config['width'] = NULL !== __session('media')['user_photo_width'] && __session('media')['user_photo_width'] > 0 ? (int) __session('media')['user_photo_width'] : 250;
		$this->image_lib->initialize($config);
		$this->image_lib->resize();
	}

	/**
	* Get Subject Settings
	*/
	public function get_subject_settings() {
		if ($this->input->is_ajax_request()) {
			$admission_type_id = _toInteger($this->input->post('admission_type_id', true));
			$major_id = _toInteger($this->input->post('major_id', true));
			$this->load->model('m_admission_subject_settings');
			$this->vars['semester_report_subjects'] = $this->m_admission_subject_settings->get_subject_settings($admission_type_id, $major_id, 'semester_report', 'public');
			$this->vars['national_exam_subjects'] = $this->m_admission_subject_settings->get_subject_settings($admission_type_id, $major_id, 'national_exam', 'public');
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Dataset
	 * @return Array
	 */
	private function dataset() {
		$data = [];
		// Wajib diisi :
		$data['registration_number'] = $this->m_registrants->registration_number();
		$data['is_prospective_student'] = 'true';
		$data['is_transfer'] = $this->input->post('is_transfer', true);
		$data['admission_type_id'] = _toInteger($this->input->post('admission_type_id', true));
		$data['admission_phase_id'] = NULL !== __session('admission_phase_id') ? __session('admission_phase_id') : 0;
		if (filter_var(__session('form_first_choice_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['first_choice_id'] = $this->input->post('first_choice_id', true) ? _toInteger($this->input->post('first_choice_id', true)) : 0;
		}
		if (filter_var(__session('form_second_choice_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['second_choice_id'] = $this->input->post('second_choice_id', true) ? _toInteger($this->input->post('second_choice_id', true)) : 0;
		}
		if (filter_var(__session('form_nik')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['nik'] = $this->input->post('nik', true) ? $this->input->post('nik', true) : NULL;
		}
		if (filter_var(__session('form_prev_school_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['prev_school_name'] = $this->input->post('prev_school_name', true) ? $this->input->post('prev_school_name', true) : NULL;
		}
		if (filter_var(__session('form_prev_exam_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['prev_exam_number'] = $this->input->post('prev_exam_number', true) ? $this->input->post('prev_exam_number', true) : NULL;
		}
		if (filter_var(__session('form_skhun')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['skhun'] = $this->input->post('skhun', true) ? $this->input->post('skhun', true) : NULL;
		}
		if (filter_var(__session('form_prev_diploma_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['prev_diploma_number'] = $this->input->post('prev_diploma_number', true) ? $this->input->post('prev_diploma_number', true) : NULL;
		}
		$data['full_name'] = $this->input->post('full_name', true);
		$data['gender'] = $this->input->post('gender', true);
		if (filter_var(__session('form_nisn')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['nisn'] = $this->input->post('nisn', true) ? $this->input->post('nisn', true) : NULL;
		}
		if (filter_var(__session('form_family_card_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['family_card_number'] = $this->input->post('family_card_number', true) ? $this->input->post('family_card_number', true) : NULL;
		}
		if (filter_var(__session('form_birth_place')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['birth_place'] = $this->input->post('birth_place', true) ? $this->input->post('birth_place', true) : NULL;
		}
		$data['birth_date'] = $this->input->post('birth_date', true);
		if (filter_var(__session('form_birth_certificate_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['birth_certificate_number'] = $this->input->post('birth_certificate_number', true) ? $this->input->post('birth_certificate_number', true) : NULL;
		}
		if (filter_var(__session('form_religion_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['religion_id'] = _toInteger($this->input->post('religion_id', true)) ? _toInteger($this->input->post('religion_id', true)) : 0;
		}
		if (filter_var(__session('form_citizenship')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['citizenship'] = $this->input->post('citizenship', true) ? $this->input->post('citizenship', true) : 'WNI';
		}
		if (filter_var(__session('form_country')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['country'] = $this->input->post('country', true) ? $this->input->post('country', true) : NULL;
		}
		if (filter_var(__session('form_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['special_need_id'] = _toInteger($this->input->post('special_need_id', true)) ? _toInteger($this->input->post('special_need_id', true)) : 0;
		}
		if (filter_var(__session('form_street_address')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['street_address'] = $this->input->post('street_address', true) ? $this->input->post('street_address', true) : NULL;
		}
		if (filter_var(__session('form_rt')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['rt'] = $this->input->post('rt', true) ? $this->input->post('rt', true) : NULL;
		}
		if (filter_var(__session('form_rw')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['rw'] = $this->input->post('rw', true) ? $this->input->post('rw', true) : NULL;
		}
		if (filter_var(__session('form_sub_village')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['sub_village'] = $this->input->post('sub_village', true) ? $this->input->post('sub_village', true) : NULL;
		}
		if (filter_var(__session('form_village')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['village'] = $this->input->post('village', true) ? $this->input->post('village', true) : NULL;
		}
		if (filter_var(__session('form_sub_district')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['sub_district'] = $this->input->post('sub_district', true) ? $this->input->post('sub_district', true) : NULL;
		}
		$data['district'] = $this->input->post('district', true);
		if (filter_var(__session('form_postal_code')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['postal_code'] = $this->input->post('postal_code', true) ? $this->input->post('postal_code', true) : NULL;
		}
		if (filter_var(__session('form_latitude')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['latitude'] = $this->input->post('latitude', true) ? $this->input->post('latitude', true) : NULL;
		}
		if (filter_var(__session('form_longitude')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['longitude'] = $this->input->post('longitude', true) ? $this->input->post('longitude', true) : NULL;
		}
		if (filter_var(__session('form_residence_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['residence_id'] = $this->input->post('residence_id', true) ? $this->input->post('residence_id', true) : NULL;
		}
		if (filter_var(__session('form_transportation_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['transportation_id'] = $this->input->post('transportation_id', true) ? $this->input->post('transportation_id', true) : NULL;
		}
		if (filter_var(__session('form_child_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['child_number'] = $this->input->post('child_number', true) ? $this->input->post('child_number', true) : NULL;
		}
		if (filter_var(__session('form_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['employment_id'] = $this->input->post('employment_id', true) ? $this->input->post('employment_id', true) : NULL;
		}
		if (filter_var(__session('form_have_kip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['have_kip'] = $this->input->post('have_kip', true) ? $this->input->post('have_kip', true) : NULL;
		}
		if (filter_var(__session('form_receive_kip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['receive_kip'] = $this->input->post('receive_kip', true) ? $this->input->post('receive_kip', true) : NULL;
		}
		if (filter_var(__session('form_reject_pip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['reject_pip'] = $this->input->post('reject_pip', true) ? $this->input->post('reject_pip', true) : NULL;
		}
		// DATA AYAH KANDUNG
		if (filter_var(__session('form_father_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_name'] = $this->input->post('father_name', true) ? $this->input->post('father_name', true) : NULL;
		}
		if (filter_var(__session('form_father_nik')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_nik'] = $this->input->post('father_nik', true) ? $this->input->post('father_nik', true) : NULL;
		}
		if (filter_var(__session('form_father_birth_place')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_birth_place'] = $this->input->post('father_birth_place', true) ? $this->input->post('father_birth_place', true) : NULL;
		}
		if (filter_var(__session('form_father_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_birth_date'] = $this->input->post('father_birth_date', true) ? $this->input->post('father_birth_date', true) : NULL;
		}
		if (filter_var(__session('form_father_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_education_id'] = $this->input->post('father_education_id', true) ? _toInteger($this->input->post('father_education_id', true)) : 0;
		}
		if (filter_var(__session('form_father_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_employment_id'] = $this->input->post('father_employment_id', true) ? _toInteger($this->input->post('father_employment_id', true)) : 0;
		}
		if (filter_var(__session('form_father_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_monthly_income_id'] = $this->input->post('father_monthly_income_id', true) ? _toInteger($this->input->post('father_monthly_income_id', true)) : 0;
		}
		if (filter_var(__session('form_father_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['father_special_need_id'] = $this->input->post('father_special_need_id', true) ? _toInteger($this->input->post('father_special_need_id', true)) : 0;
		}
		// DATA IBU KANDUNG
		if (filter_var(__session('form_mother_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_name'] = $this->input->post('mother_name', true) ? $this->input->post('mother_name', true) : NULL;
		}
		if (filter_var(__session('form_mother_nik')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_nik'] = $this->input->post('mother_nik', true) ? $this->input->post('mother_nik', true) : NULL;
		}
		if (filter_var(__session('form_mother_birth_place')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_birth_place'] = $this->input->post('mother_birth_place', true) ? $this->input->post('mother_birth_place', true) : NULL;
		}
		if (filter_var(__session('form_mother_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_birth_date'] = $this->input->post('mother_birth_date', true) ? $this->input->post('mother_birth_date', true) : NULL;
		}
		if (filter_var(__session('form_mother_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_education_id'] = $this->input->post('mother_education_id', true) ? _toInteger($this->input->post('mother_education_id', true)) : 0;
		}
		if (filter_var(__session('form_mother_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_employment_id'] = $this->input->post('mother_employment_id', true) ? _toInteger($this->input->post('mother_employment_id', true)) : 0;
		}
		if (filter_var(__session('form_mother_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_monthly_income_id'] = $this->input->post('mother_monthly_income_id', true) ? _toInteger($this->input->post('mother_monthly_income_id', true)) : 0;
		}
		if (filter_var(__session('form_mother_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mother_special_need_id'] = $this->input->post('mother_special_need_id', true) ? _toInteger($this->input->post('mother_special_need_id', true)) : 0;
		}
		// DATA WALI
		if (filter_var(__session('form_guardian_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_name'] = $this->input->post('guardian_name', true) ? $this->input->post('guardian_name', true) : NULL;
		}
		if (filter_var(__session('form_guardian_nik')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_nik'] = $this->input->post('guardian_nik', true) ? $this->input->post('guardian_nik', true) : NULL;
		}
		if (filter_var(__session('form_guardian_birth_place')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_birth_place'] = $this->input->post('guardian_birth_place', true) ? $this->input->post('guardian_birth_place', true) : NULL;
		}
		if (filter_var(__session('form_guardian_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_birth_date'] = $this->input->post('guardian_birth_date', true) ? $this->input->post('guardian_birth_date', true) : NULL;
		}
		if (filter_var(__session('form_guardian_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_education_id'] = $this->input->post('guardian_education_id', true) ? _toInteger($this->input->post('guardian_education_id', true)) : 0;
		}
		if (filter_var(__session('form_guardian_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_employment_id'] = $this->input->post('guardian_employment_id', true) ? _toInteger($this->input->post('guardian_employment_id', true)) : 0;
		}
		if (filter_var(__session('form_guardian_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['guardian_monthly_income_id'] = $this->input->post('guardian_monthly_income_id', true) ? _toInteger($this->input->post('guardian_monthly_income_id', true)) : 0;
		}
		// DATA KONTAK
		if (filter_var(__session('form_phone')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['phone'] = $this->input->post('phone', true) ? $this->input->post('phone', true) : NULL;
		}
		if (filter_var(__session('form_mobile_phone')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mobile_phone'] = $this->input->post('mobile_phone', true) ? $this->input->post('mobile_phone', true) : NULL;
		}
		if (filter_var(__session('form_email')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['email'] = $this->input->post('email', true) ? $this->input->post('email', true) : NULL;
		}
		// DATA PERIODIK
		if (filter_var(__session('form_height')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['height'] = $this->input->post('height', true) ? $this->input->post('height', true) : NULL;
		}
		if (filter_var(__session('form_weight')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['weight'] = $this->input->post('weight', true) ? $this->input->post('weight', true) : NULL;
		}
		if (filter_var(__session('form_head_circumference')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['head_circumference'] = $this->input->post('head_circumference', true) ? $this->input->post('head_circumference', true) : NULL;
		}
		if (filter_var(__session('form_mileage')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['mileage'] = $this->input->post('mileage', true) ? $this->input->post('mileage', true) : NULL;
		}
		if (filter_var(__session('form_traveling_time')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['traveling_time'] = $this->input->post('traveling_time', true) ? _toInteger($this->input->post('traveling_time', true)) : 0;
		}
		if (filter_var(__session('form_sibling_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['sibling_number'] = $this->input->post('sibling_number', true) ? _toInteger($this->input->post('sibling_number', true)) : 0;
		}
		if (filter_var(__session('form_traveling_time')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['traveling_time'] = $this->input->post('traveling_time', true) ? _toInteger($this->input->post('traveling_time', true)) : 0;
		}
		// DATA KESEJAHTERAAN PESERTA DIDIK
		if (filter_var(__session('form_welfare_type')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['welfare_type'] = $this->input->post('welfare_type', true) ? $this->input->post('welfare_type', true) : NULL;
		}
		if (filter_var(__session('form_welfare_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['welfare_number'] = $this->input->post('welfare_number', true) ? $this->input->post('welfare_number', true) : NULL;
		}
		if (filter_var(__session('form_welfare_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$data['welfare_name'] = $this->input->post('welfare_name', true) ? $this->input->post('welfare_name', true) : NULL;
		}
		return $data;
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('is_transfer', 'Jenis Pendaftaran', 'trim|required|in_list[true,false]');
		$val->set_rules('admission_type_id', 'Jenis Pendaftaran', 'trim|is_natural_no_zero|required');
		if (filter_var(__session('form_first_choice_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_first_choice_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('first_choice_id', 'Pilihan Ke-1', $rules);
		}
		if (filter_var(__session('form_second_choice_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_second_choice_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('second_choice_id', 'Pilihan Ke-2', $rules);
		}
		if (filter_var(__session('form_nik')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'max_length[16]'];
			if (filter_var(__session('form_nik')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('nik', 'NIK (Nomor Induk Kependudukan)', $rules);
		}
		if (filter_var(__session('form_prev_school_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_prev_school_name')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('prev_school_name', 'Nama Sekolah Asal ', $rules);
		}
		if (filter_var(__session('form_prev_exam_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_prev_exam_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('prev_exam_number', 'Nomor Peserta UN SMP/MTs', $rules);
		}
		if (filter_var(__session('form_skhun')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_skhun')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('skhun', 'No. SKHUN SMP/MTs', $rules);
		}
		if (filter_var(__session('form_prev_diploma_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_prev_diploma_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('prev_diploma_number', 'No. Seri Ijazah SMP/MTs', $rules);
		}
		$val->set_rules('full_name', 'Nama Lengkap', 'trim|required');
		$val->set_rules('gender', 'Jenis Kelamin', 'trim|required|in_list[M,F]');
		if (filter_var(__session('form_nisn')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_nisn')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('nisn', 'Nomor Induk Siswa Nasional', $rules);
		}
		if (filter_var(__session('form_family_card_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_family_card_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('nisn', 'Nomor Kartu Keluarga', $rules);
		}
		if (filter_var(__session('form_birth_place')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_birth_place')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('birth_place', 'Tempat Lahir', $rules);
		}
		// Wajib diisi karena dipakai untuk pencarian data [birth_date && registration_number]
		$val->set_rules('birth_date', 'Tanggal Lahir', 'trim|required|callback_date_format_check');
		if (filter_var(__session('form_birth_certificate_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_birth_certificate_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('birth_certificate_number', 'Nomor Registasi Akta Lahir', $rules);
		}
		if (filter_var(__session('form_religion_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_religion_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('religion_id', 'Agama', $rules);
		}
		if (filter_var(__session('form_citizenship')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_citizenship')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required', 'in_list[WNI,WNA]');
			}
			$val->set_rules('citizenship', 'Kewarganegaraan', $rules);
		}
		if (filter_var(__session('form_country')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_country')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('country', 'Nama Negara', $rules);
		}
		if (filter_var(__session('form_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_special_need_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('special_need_id', 'Kebutuhan Khusus', $rules);
		}
		if (filter_var(__session('form_street_address')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_street_address')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('street_address', 'Alamat Jalan', $rules);
		}
		if (filter_var(__session('form_rt')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_rt')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('rt', 'RT', $rules);
		}
		if (filter_var(__session('form_rw')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_rw')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('rw', 'RW', $rules);
		}
		if (filter_var(__session('form_sub_village')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_sub_village')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('sub_village', 'Nama Dusun', $rules);
		}
		if (filter_var(__session('form_village')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_village')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('village', 'Desa/Kelurahan', $rules);
		}
		if (filter_var(__session('form_sub_district')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_sub_district')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('sub_district', 'Kecamatan', $rules);
		}
		// Wajib diisi karena dipakai untuk Footer di pencetakan PDF
		$val->set_rules('district', 'Kabupaten', 'trim|required');
		if (filter_var(__session('form_postal_code')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'max_length[5]', 'numeric'];
			if (filter_var(__session('form_postal_code')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('postal_code', 'Kode Pos', $rules);
		}
		if (filter_var(__session('form_latitude')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_latitude')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('latitude', 'Lintang', $rules);
		}
		if (filter_var(__session('form_longitude')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_longitude')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('longitude', 'Bujur', $rules);
		}
		if (filter_var(__session('form_residence_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_residence_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('residence_id', 'Tempat Tinggal', $rules);
		}
		if (filter_var(__session('form_transportation_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_transportation_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('transportation_id', 'Moda Transportasi', $rules);
		}
		if (filter_var(__session('form_child_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_child_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('child_number', 'Anak Ke Berapa', $rules);
		}
		if (filter_var(__session('form_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_employment_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('employment_id', 'Pekerjaan (diperuntukan untuk warga belajar)', $rules);
		}
		if (filter_var(__session('form_have_kip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_have_kip')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('have_kip', 'Apakah Punya KIP', $rules);
		}
		if (filter_var(__session('form_receive_kip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_receive_kip')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('receive_kip', 'Apakah Peserta Didik Tersebut Tetap Akan Menerima KIP', $rules);
		}
		if (filter_var(__session('form_reject_pip')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_reject_pip')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('reject_pip', 'Alasan Menolak PIP', $rules);
		}
		// DATA AYAH KANDUNG
		if (filter_var(__session('form_father_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_father_name')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_name', 'Nama Ayah', $rules);
		}
		if (filter_var(__session('form_father_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_first_choice_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_birth_date', 'Tanggal Lahir Ayah', $rules);
		}
		if (filter_var(__session('form_father_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_father_education_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_education_id', 'Pendidikan Ayah', $rules);
		}
		if (filter_var(__session('form_father_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_father_employment_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_employment_id', 'Pekerjaan Ayah', $rules);
		}
		if (filter_var(__session('form_father_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_father_monthly_income_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_monthly_income_id', 'Penghasilan Bulanan Ayah', $rules);
		}
		if (filter_var(__session('form_father_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_father_special_need_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('father_special_need_id', 'Kebutuhan Khusus Ayah', $rules);
		}
		// DATA IBU KANDUNG
		if (filter_var(__session('form_mother_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_mother_name')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_name', 'Nama Ibu Kandung', $rules);
		}
		if (filter_var(__session('form_mother_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_mother_birth_date')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_birth_date', 'Tanggal Lahir Ibu', $rules);
		}
		if (filter_var(__session('form_mother_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_mother_education_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_education_id', 'Pendidikan Ibu', $rules);
		}
		if (filter_var(__session('form_mother_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_mother_employment_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_employment_id', 'Pekerjaan Ibu', $rules);
		}
		if (filter_var(__session('form_mother_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_mother_monthly_income_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_monthly_income_id', 'Penghasilan Bulanan Ibu', $rules);
		}
		if (filter_var(__session('form_mother_special_need_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_mother_special_need_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mother_special_need_id', 'Kebutuhan Khusus Ibu', $rules);
		}
		// DATA WALI
		if (filter_var(__session('form_guardian_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_guardian_name')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('guardian_name', 'Nama Wali', $rules);
		}
		if (filter_var(__session('form_guardian_birth_date')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_guardian_birth_date')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('guardian_birth_date', 'Tanggal Lahir Wali', $rules);
		}
		if (filter_var(__session('form_guardian_education_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_guardian_education_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('guardian_education_id', 'Pendidikan Wali', $rules);
		}
		if (filter_var(__session('form_guardian_employment_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_guardian_employment_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('guardian_employment_id', 'Pekerjaan Wali', $rules);
		}
		if (filter_var(__session('form_guardian_monthly_income_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric'];
			if (filter_var(__session('form_guardian_monthly_income_id')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('guardian_monthly_income_id', 'Penghasilan Bulanan Wali', $rules);
		}
		// KONTAK
		if (filter_var(__session('form_phone')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_phone')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('phone', 'Telepon', $rules);
		}
		if (filter_var(__session('form_mobile_phone')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_mobile_phone')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mobile_phone', 'Nomor HP', $rules);
		}
		if (filter_var(__session('form_email')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'valid_email', 'callback_email_exists'];
			if (filter_var(__session('form_email')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('email', 'Email', $rules);
		}
		// DATA PERIODIK
		if (filter_var(__session('form_height')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[3]'];
			if (filter_var(__session('form_height')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('height', 'Tinggi Badan', $rules);
		}
		if (filter_var(__session('form_weight')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[3]'];
			if (filter_var(__session('form_weight')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('weight', 'Berat Badan', $rules);
		}
		if (filter_var(__session('form_head_circumference')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[3]'];
			if (filter_var(__session('form_head_circumference')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('head_circumference', 'Lingkar Kepala', $rules);
		}
		if (filter_var(__session('form_mileage')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[5]'];
			if (filter_var(__session('form_mileage')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('mileage', 'Jarak Tempat Tinggal ke Sekolah', $rules);
		}
		if (filter_var(__session('form_traveling_time')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[5]'];
			if (filter_var(__session('form_traveling_time')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('traveling_time', 'Waktu Tempuh ke Sekolah', $rules);
		}
		if (filter_var(__session('form_sibling_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim', 'numeric', 'min_length[1]', 'max_length[2]'];
			if (filter_var(__session('form_sibling_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('sibling_number', 'Jumlah Saudara Kandung', $rules);
		}
		// DATA KESEJAHTERAAN PESERTA DIDIK 
		if (filter_var(__session('form_welfare_type')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_welfare_type')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('welfare_type', 'Jenis Kesejahteraan', $rules);
		}
		if (filter_var(__session('form_welfare_number')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_welfare_number')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('welfare_number', 'Nomor Kartu Kesejahteraan', $rules);
		}
		if (filter_var(__session('form_welfare_name')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$rules = ['trim'];
			if (filter_var(__session('form_welfare_name')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				array_push($rules, 'required');
			}
			$val->set_rules('welfare_name', 'Nama di Kartu Kesejahteraan', $rules);
		}
		// UPLOAD DOKUMEN
		if (filter_var(__session('form_photo')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_photo')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('photo', 'Foto', 'callback_photo_check');
			}
		}
		if (filter_var(__session('form_family_card')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_family_card')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('family_card', 'Kartu Keluarga', 'callback_family_card_check');
			}
		}
		if (filter_var(__session('form_birth_certificate')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_birth_certificate')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('birth_certificate', 'Kartu Keluarga', 'callback_birth_certificate_check');
			}
		}
		if (filter_var(__session('form_father_identity_card')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_father_identity_card')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('father_identity_card', 'KTP Ayah', 'callback_father_identity_card_check');
			}
		}
		if (filter_var(__session('form_mother_identity_card')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_mother_identity_card')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('mother_identity_card', 'KTP Ibu', 'callback_mother_identity_card_check');
			}
		}
		if (filter_var(__session('form_guardian_identity_card')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			if (filter_var(__session('form_guardian_identity_card')['admission_required'], FILTER_VALIDATE_BOOLEAN)) {
				$val->set_rules('guardian_identity_card', 'KTP Wali', 'callback_guardian_identity_card_check');
			}
		}
		$val->set_rules('declaration', 'Pernyataan', 'trim|required|in_list[true]|callback_declaration_check');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('min_length', '{field} Harus Diisi Minimal {param} Karakter');
		$val->set_message('max_length', '{field} harus Diisi Maksimal {param} Karakter');
		$val->set_message('numeric', '{field} harus diisi dengan angka');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * Email Exists?
	 * @param String $email
	 * @param Integer $id
	 * @return Boolean
	 */
	public function email_exists( $email = '', $id = 0 ) {
		$this->load->model('m_users');
		$email_exists = $this->m_users->email_exists( $email, $id );
		if ( $email_exists ) {
			$this->form_validation->set_message('email_exists', 'Email sudah digunakan');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Date Format Check
	 * @param String $date
	 * @return Boolean
	 */
	public function date_format_check($date) {
		if ( ! _isValidDate($date)) {
			 $this->form_validation->set_message('date_format_check', '{field} harus diisi dengan format YYYY-MM-DD');
			 return FALSE;
	   }
		 return TRUE;
	 }

	/**
	 * Declaration Check
	 * @param String $declaration_check
	 * @return Boolean
	 */
	public function declaration_check( $declaration_check ) {
		if ( ! filter_var($declaration_check, FILTER_VALIDATE_BOOLEAN) ) {
			$this->form_validation->set_message('declaration_check', 'Pernyataan Harus Diceklis');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Photo Check
	 * @return Boolean
	 */
	public function photo_check() {
		if ( empty($_FILES['photo']['name']) ) {
			$this->form_validation->set_message('photo_check', 'Foto belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Family Card Check
	 * @return Boolean
	 */
	public function family_card_check() {
		if ( empty($_FILES['family_card']['name']) ) {
			$this->form_validation->set_message('family_card_check', 'Kartu keluarga belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Birth Certificate Check
	 * @return Boolean
	 */
	public function birth_certificate_check() {
		if ( empty($_FILES['birth_certificate']['name']) ) {
			$this->form_validation->set_message('birth_certificate_check', 'Akta lahir belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Father Identity Card Check
	 * @return Boolean
	 */
	public function father_identity_card_check() {
		if ( empty($_FILES['father_identity_card']['name']) ) {
			$this->form_validation->set_message('father_identity_card_check', 'KTP Ayah belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Mother Identity Card Check
	 * @return Boolean
	 */
	public function mother_identity_card_check() {
		if ( empty($_FILES['mother_identity_card']['name']) ) {
			$this->form_validation->set_message('mother_identity_card_check', 'KTP Ibu belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Guardian Identity Card Check
	 * @return Boolean
	 */
	public function guardian_identity_card_check() {
		if ( empty($_FILES['guardian_identity_card']['name']) ) {
			$this->form_validation->set_message('guardian_identity_card_check', 'KTP Wali belum dipilih.');
			return FALSE;
		}
		return TRUE;
	}
}
