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

class Student_profile extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('m_students');
		$this->pk = M_students::$pk;
		$this->table = M_students::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$id = _toInteger(__session('user_id'));
		$this->vars['title'] = 'Biodata';
		$this->vars['student_profile'] = TRUE;
		$this->vars['religions'] = ['' => 'Pilih :'] + get_options('religion', FALSE);
		$this->vars['special_needs'] = ['' => 'Pilih :'] + get_options('special_need', FALSE);
		$this->vars['residences'] = ['' => 'Pilih :'] + get_options('residence', FALSE);
		$this->vars['transportations'] = ['' => 'Pilih :'] + get_options('transportation', FALSE);
		$this->vars['educations'] = ['' => 'Pilih :'] + get_options('education', FALSE);
		$this->vars['employments'] = ['' => 'Pilih :'] + get_options('employment', FALSE);
		$this->vars['monthly_incomes'] = ['' => 'Pilih :'] + get_options('monthly_income', FALSE);
		$this->vars['query'] = $this->model->RowObject($this->pk, $id, $this->table);
		$this->vars['content'] = 'students_profile';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Save or Update
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger(__session('user_id'));
			if (_isNaturalNumber( $id )) {
				if ($this->validation( $id )) {
					$dataset = $this->dataset();
					$this->vars['status'] = $this->model->update($id, $this->table, $dataset) ? 'success' : 'error';
					$this->vars['message'] = $this->vars['status'] == 'success' ? 'updated' : 'not_updated';
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = validation_errors();
				}
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = 'not_updated';
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
			'email' => $this->input->post('email') ? $this->input->post('email', true) : NULL,
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
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation($id) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
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
}
