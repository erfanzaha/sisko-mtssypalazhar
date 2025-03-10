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

class Students extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model(['m_students', 'm_majors', 'm_users']);
		$this->pk = M_students::$pk;
		$this->table = M_students::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Peserta Didik';
		$this->vars['academic'] = $this->vars['academic_references'] = $this->vars['students'] = TRUE;
		$majors = [0 => 'Unset'];
		if (__session('major_count') > 0) {
			$majors = [0 => 'Unset'] + $this->m_majors->dropdown();
		}
		$this->vars['major_dropdown'] = json_encode($majors, self::REQUIRED_FLAGS);
		$this->vars['content'] = 'academic/students';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Student Profile
	 * @return Void
	 */
	public function profile() {
		$id = _toInteger($this->uri->segment(4));
		if (_isNaturalNumber( $id )) {
			$this->load->model(['m_students', 'm_scholarships', 'm_achievements']);
			$this->vars['student'] = $this->m_students->profile($id);
			$this->vars['scholarships'] = $this->m_scholarships->get_by_student_id($id);
			$this->vars['achievements'] = $this->m_achievements->get_by_student_id($id);
			$this->vars['title'] = 'Profil Peserta Didik';
			$this->vars['photo'] = base_url('media_library/images/no-image.png');
			$photo_name = $this->vars['student']->photo;
			$photo = 'media_library/users/photo/' . $photo_name;
			if ($photo_name && file_exists($_SERVER['DOCUMENT_ROOT'] . '/' . $photo)) {
				$this->vars['photo'] = base_url($photo);
			}
			$this->vars['academic'] = $this->vars['academic_references'] = $this->vars['students'] = TRUE;
			$this->vars['content'] = 'academic/student_profile';
			$this->load->view('backend/index', $this->vars);
		} else {
			show_404();
		}
	}

	/**
	 * Pagination
	 * @return Object
	 */
	public function pagination() {
		if ($this->input->is_ajax_request()) {
			$keyword = trim($this->input->post('keyword', true));
			$page_number = _toInteger($this->input->post('page_number', true));
			$limit = _toInteger($this->input->post('per_page', true));
			$offset = ($page_number * $limit);
			$query = $this->m_students->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_students->get_where($keyword);
			$total_page = $limit > 0 ? ceil(_toInteger($total_rows) / _toInteger($limit)) : 1;
			$this->vars['total_page'] = _toInteger($total_page);
			$this->vars['total_rows'] = _toInteger($total_rows);
			$this->vars['rows'] = $query->result();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save | Update
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger($this->input->post('id', true));
			if ($this->validation( $id )) {
				$dataset = $this->dataset();
				$query = $this->model->upsert($id, $this->table, $dataset);
				if ($query) $this->m_users->activate_account($dataset['email']);
				$this->vars['status'] = $query ? 'success' : 'error';
				$this->vars['message'] = $query ? 'Data Anda berhasil disimpan.' : 'Terjadi kesalahan dalam menyimpan data';
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
	 * Dataset
	 * @return Array
	 */
	private function dataset() {
		return [
			'is_student' => 'true',
			'is_transfer' => $this->input->post('is_transfer', true),
			'start_date' => $this->input->post('start_date', true) ?? NULL,
			'nis' => $this->input->post('nis') ?? NULL,
			'major_id' => _toInteger($this->input->post('major_id', true)),
			'full_name' => $this->input->post('full_name', true),
			'gender' => $this->input->post('gender', true),
			'nisn' => $this->input->post('nisn') ?? NULL,
			'nik' => $this->input->post('nik') ?? NULL,
			'skhun' => $this->input->post('skhun') ?? NULL,
			'prev_exam_number' => $this->input->post('prev_exam_number') ?? NULL,
			'prev_diploma_number' => $this->input->post('prev_diploma_number') ?? NULL,
			'prev_school_name' => $this->input->post('prev_school_name', true) ?? NULL,
			'birth_place' => $this->input->post('birth_place', true) ?? NULL,
			'birth_date' => $this->input->post('birth_date', true) ?? NULL,
			'family_card_number' => $this->input->post('family_card_number', true) ?? NULL,
			'birth_certificate_number' => $this->input->post('birth_certificate_number', true) ?? NULL,
			'religion_id' => _toInteger($this->input->post('religion_id', true)),
			'special_need_id' => _toInteger($this->input->post('special_need_id', true)),
			'street_address' => $this->input->post('street_address', true) ?? NULL,
			'rt' => $this->input->post('rt', true) ?? NULL,
			'rw' => $this->input->post('rw', true) ?? NULL,
			'sub_village' => $this->input->post('sub_village', true) ?? NULL,
			'village' => $this->input->post('village', true) ?? NULL,
			'sub_district' => $this->input->post('sub_district', true) ?? NULL,
			'district' => $this->input->post('district', true) ?? NULL,
			'postal_code' => $this->input->post('postal_code', true) ?? NULL,
			'residence_id' => _toInteger($this->input->post('residence_id', true)),
			'transportation_id' => _toInteger($this->input->post('transportation_id', true)),
			'child_number' => _toInteger($this->input->post('child_number', true)),
			'phone' => $this->input->post('phone', true) ?? NULL,
			'mobile_phone' => $this->input->post('mobile_phone', true) ?? NULL,
			'email' => $this->input->post('email', true),
			'welfare_type' => $this->input->post('welfare_type', true) ?? NULL,
			'welfare_number' => $this->input->post('welfare_number', true) ?? NULL,
			'welfare_name' => $this->input->post('welfare_name', true) ?? NULL,
			'citizenship' => $this->input->post('citizenship', true) ?? NULL,
			'country' => $this->input->post('country', true) ?? NULL,
			'father_name' => $this->input->post('father_name', true) ?? NULL,
			'father_nik' => $this->input->post('father_nik', true) ?? NULL,
			'father_birth_place' => $this->input->post('father_birth_place', true) ?? NULL,
			'father_birth_date' => $this->input->post('father_birth_date', true) ?? NULL,
			'father_education_id' => _toInteger($this->input->post('father_education_id', true)),
			'father_employment_id' => _toInteger($this->input->post('father_employment_id', true)),
			'father_monthly_income_id' => _toInteger($this->input->post('father_monthly_income_id', true)),
			'father_special_need_id' => _toInteger($this->input->post('father_special_need_id', true)),
			'mother_name' => $this->input->post('mother_name', true) ?? NULL,
			'mother_nik' => $this->input->post('mother_nik', true) ?? NULL,
			'mother_birth_place' => $this->input->post('mother_birth_place', true) ?? NULL,
			'mother_birth_date' => $this->input->post('mother_birth_date', true) ?? NULL,
			'mother_education_id' => _toInteger($this->input->post('mother_education_id', true)),
			'mother_employment_id' => _toInteger($this->input->post('mother_employment_id', true)),
			'mother_monthly_income_id' => _toInteger($this->input->post('mother_monthly_income_id', true)),
			'mother_special_need_id' => _toInteger($this->input->post('mother_special_need_id', true)),
			'guardian_name' => $this->input->post('guardian_name', true) ?? NULL,
			'guardian_nik' => $this->input->post('guardian_nik', true) ?? NULL,
			'guardian_birth_place' => $this->input->post('guardian_birth_place', true) ?? NULL,
			'guardian_birth_date' => $this->input->post('guardian_birth_date', true) ?? NULL,
			'guardian_education_id' => _toInteger($this->input->post('guardian_education_id', true)),
			'guardian_employment_id' => _toInteger($this->input->post('guardian_employment_id', true)),
			'guardian_monthly_income_id' => _toInteger($this->input->post('guardian_monthly_income_id', true)),
			'mileage' => $this->input->post('mileage', true) ?? NULL,
			'traveling_time' => $this->input->post('traveling_time', true) ?? NULL,
			'height' => $this->input->post('height', true) ?? NULL,
			'weight' => $this->input->post('weight', true) ?? NULL,
			'head_circumference' => $this->input->post('head_circumference', true) ?? NULL,
			'sibling_number' => $this->input->post('sibling_number', true) ?? NULL,
			'student_status_id' => _toInteger($this->input->post('student_status_id', true)),
			'end_date' => $this->input->post('end_date', true) ?? NULL,
			'reason' => $this->input->post('reason', true) ?? NULL
		];
	}

	/**
	 * Validation Form
	 * @param Integer $id
	 * @return Boolean
	 */
	private function validation( $id = 0) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('nis', 'NIS', 'trim|required|callback_nis_exists[' . $id . ']');
		$val->set_rules('full_name', 'Nama Lengkap', 'trim|required');
		$val->set_rules('student_status_id', 'Status Peserta Didik', 'trim|required');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
		$val->set_rules('nik', 'NIK', 'trim');
		$val->set_rules('nisn', 'NISN', 'trim');
		$val->set_rules('father_birth_date', 'Tanggal Lahir Ayah', 'trim');
		$val->set_rules('mother_birth_date', 'Tanggal Lahir Ibu', 'trim');
		$val->set_rules('guardian_birth_date', 'Tanggal Lahir Wali', 'trim');
		$val->set_rules('sibling_number', 'Jumlah Saudara Kandung', 'trim|numeric|min_length[1]|max_length[2]');
		$val->set_rules('rt', 'RT', 'trim|numeric');
		$val->set_rules('rw', 'RW', 'trim|numeric');
		$val->set_rules('postal_code', 'Kode Pos', 'trim|numeric');
		$val->set_rules('mileage', 'Jarak Tempat Tinggal ke Sekolah', 'trim|numeric');
		$val->set_rules('traveling_time', 'Waktu Tempuh ke Sekolah', 'trim|numeric');
		$val->set_rules('height', 'Tinggi Badan', 'trim|numeric|min_length[2]|max_length[3]');
		$val->set_rules('weight', 'Berat Badan', 'trim|numeric|min_length[2]|max_length[3]');
		$val->set_rules('head_circumference', 'Lingkar Kepala', 'trim|numeric|min_length[2]|max_length[3]');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('valid_email', '{field} harus diisi dengan format email yang benar');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * NIS Exists?
	 * @param String $nis
	 * @return Boolean
	 */
	public function nis_exists( $nis = NULL, $id = 0 ) {
		$this->load->model('m_users');
		$nis_exists = $this->m_users->nis_exists( $nis, $id );
		if ( $nis_exists ) {
			$this->form_validation->set_message('nis_exists', 'NIS sudah digunakan');
			return FALSE;
		}
		return TRUE;
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
	 * Student Reports
	 * @return Object
	 */
	public function student_reports() {
		if ($this->input->is_ajax_request()) {
			$query = $this->m_students->student_reports();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($query->result(), self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}
