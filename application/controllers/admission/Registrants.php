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

class Registrants extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_registrants',
			'm_majors',
			'm_admission_phases',
			'm_users'
		]);
		$this->pk = M_registrants::$pk;
		$this->table = M_registrants::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Calon Peserta Didik Baru';
		$this->vars['admission_year'] = __session('admission_year');
		$this->vars['admission'] = $this->vars['registrants'] = TRUE;
		$this->vars['major_dropdown'] = json_encode([]);
		if (__session('major_count') > 0) {
			$this->vars['major_dropdown'] = json_encode([0 => 'Unset'] + $this->m_majors->dropdown(), self::REQUIRED_FLAGS);
		}
		$this->vars['admission_phase_dropdown'] = json_encode($this->m_admission_phases->dropdown(), self::REQUIRED_FLAGS);
		$this->vars['content'] = 'admission/registrants';
		$this->load->view('backend/index', $this->vars);
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
			$query = $this->m_registrants->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_registrants->get_where($keyword);
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
	 * Verified prospective studnets
	 * @return 	Object
	 */
	public function verified() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger($this->input->post('id', true));
			$dataset['re_registration'] = $this->input->post('re_registration', true);
			$this->vars['status'] = $this->model->update($id, $this->table, $dataset) ? 'success' : 'error';
			$this->vars['message'] = $this->vars['status'] == 'success' ? 'updated' : 'not_updated';
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
			'is_transfer' => $this->input->post('is_transfer', true),
			'admission_type_id' => _toInteger($this->input->post('admission_type_id', true)),
			'first_choice_id' => _toInteger($this->input->post('first_choice_id', true)),
			'second_choice_id' => _toInteger($this->input->post('second_choice_id', true)),
			'nik' => $this->input->post('nik') ?? NULL,
			'prev_school_name' => $this->input->post('prev_school_name', true) ?? NULL,
			'prev_exam_number' => $this->input->post('prev_exam_number', true) ?? NULL,
			'skhun' => $this->input->post('skhun', true) ?? NULL,
			'prev_diploma_number' => $this->input->post('prev_diploma_number', true) ?? NULL,
			'admission_phase_id' => _toInteger($this->input->post('admission_phase_id', true)) ?? NULL,
			'full_name' => $this->input->post('full_name', true),
			'gender' => $this->input->post('gender', true),
			'nisn' => $this->input->post('nisn') ?? NULL,
			'family_card_number' => $this->input->post('family_card_number') ?? NULL,
			'birth_place' => $this->input->post('birth_place', true) ?? NULL,
			'birth_date' => $this->input->post('birth_date', true) ?? NULL,
			'birth_certificate_number' => $this->input->post('birth_certificate_number', true) ?? NULL,
			'religion_id' => _toInteger($this->input->post('religion_id', true)),
			'citizenship' => $this->input->post('citizenship', true) ?? NULL,
			'country' => $this->input->post('country', true) ?? NULL,
			'special_need_id' => _toInteger($this->input->post('special_need_id', true)),
			'street_address' => $this->input->post('street_address', true) ?? NULL,
			'rt' => $this->input->post('rt', true) ?? NULL,
			'rw' => $this->input->post('rw', true) ?? NULL,
			'sub_village' => $this->input->post('sub_village', true) ?? NULL,
			'village' => $this->input->post('village', true) ?? NULL,
			'sub_district' => $this->input->post('sub_district', true) ?? NULL,
			'district' => $this->input->post('district', true) ?? NULL,
			'postal_code' => $this->input->post('postal_code', true) ?? NULL,
			'latitude' => $this->input->post('latitude', true) ?? NULL,
			'longitude' => $this->input->post('longitude', true) ?? NULL,
			'residence_id' => _toInteger($this->input->post('residence_id', true)),
			'transportation_id' => _toInteger($this->input->post('transportation_id', true)),
			'child_number' => $this->input->post('child_number', true) ?? NULL,
			'employment_id' => $this->input->post('employment_id', true) ?? NULL,

			'have_kip' => $this->input->post('have_kip', true) ?? NULL,
			'receive_kip' => $this->input->post('receive_kip', true) ?? NULL,
			'reject_pip' => $this->input->post('reject_pip', true) ?? NULL,

			'father_name' => $this->input->post('father_name', true) ?? NULL,
			'father_nik' => $this->input->post('father_nik', true) ?? NULL,
			'father_birth_date' => $this->input->post('father_birth_date', true) ?? NULL,
			'father_birth_place' => $this->input->post('father_birth_place', true) ?? NULL,
			'father_education_id' => _toInteger($this->input->post('father_education_id', true)),
			'father_employment_id' => _toInteger($this->input->post('father_employment_id', true)),
			'father_monthly_income_id' => _toInteger($this->input->post('father_monthly_income_id', true)),
			'father_special_need_id' => _toInteger($this->input->post('father_special_need_id', true)),

			'mother_name' => $this->input->post('mother_name', true) ?? NULL,
			'mother_nik' => $this->input->post('mother_nik', true) ?? NULL,
			'mother_birth_date' => $this->input->post('mother_birth_date', true) ?? NULL,
			'mother_birth_place' => $this->input->post('mother_birth_place', true) ?? NULL,
			'mother_education_id' => _toInteger($this->input->post('mother_education_id', true)),
			'mother_employment_id' => _toInteger($this->input->post('mother_employment_id', true)),
			'mother_monthly_income_id' => _toInteger($this->input->post('mother_monthly_income_id', true)),
			'mother_special_need_id' => _toInteger($this->input->post('mother_special_need_id', true)),

			'guardian_name' => $this->input->post('guardian_name', true) ?? NULL,
			'guardian_nik' => $this->input->post('guardian_nik', true) ?? NULL,
			'guardian_birth_date' => $this->input->post('guardian_birth_date', true) ?? NULL,
			'guardian_birth_place' => $this->input->post('guardian_birth_place', true) ?? NULL,
			'guardian_education_id' => _toInteger($this->input->post('guardian_education_id', true)),
			'guardian_employment_id' => _toInteger($this->input->post('guardian_employment_id', true)),
			'guardian_monthly_income_id' => _toInteger($this->input->post('guardian_monthly_income_id', true)),

			'phone' => $this->input->post('phone', true) ?? NULL,
			'mobile_phone' => $this->input->post('mobile_phone', true) ?? NULL,
			'email' => $this->input->post('email', true) ? $this->input->post('email', true) : NULL,
			
			'height' => $this->input->post('height', true) ?? NULL,
			'weight' => $this->input->post('weight', true) ?? NULL,
			'head_circumference' => $this->input->post('head_circumference', true) ?? NULL,
			'mileage' => $this->input->post('mileage', true) ?? NULL,
			'traveling_time' => $this->input->post('traveling_time', true) ?? NULL,
			'sibling_number' => $this->input->post('sibling_number', true) ?? NULL,

			'welfare_type' => $this->input->post('welfare_type', true) ?? NULL,
			'welfare_number' => $this->input->post('welfare_number', true) ?? NULL,
			'welfare_name' => $this->input->post('welfare_name', true) ?? NULL,
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation( $id = 0 ) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('admission_type_id', 'Jenis Pendaftaran', 'trim|required|is_natural_no_zero');
		if (__session('major_count') > 0) {
			$val->set_rules('first_choice_id', 'First Choice', 'trim|required');
			$val->set_rules('second_choice_id', 'Second Choice', 'trim');
		}
		$val->set_rules('full_name', 'Full Name', 'trim|required');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
		$val->set_rules('nik', 'NIK', 'trim');
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
		$email_exists = $this->m_users->email_exists( $email, $id );
		if ( $email_exists ) {
			$this->form_validation->set_message('email_exists', 'Email sudah digunakan');
			return FALSE;
		}
		return TRUE;
	}

	/**
	  * Print Admission Form
	  */
	public function print_admission_form() {
		$id = $this->uri->segment(4);
		if ( ! _isNaturalNumber( $id ) ) return show_404();
		$query = $this->model->RowObject($this->pk, $id, $this->table);
		if ( ! is_object($query)) return show_404();
		$res = $this->m_registrants->find_registrant($query->registration_number, $query->birth_date);
		if ( is_null($res) ) return show_404();
		if ( ! filter_var($res['is_prospective_student'], FILTER_VALIDATE_BOOLEAN))  return show_404();
		$file_name = 'formulir-penerimaan-peserta-didik-baru-tahun-' . substr($res['registration_number'] ?? '', 0, 4);
		$file_name .= '-' . $res['birth_date'] . '-' . $res['registration_number'] . '.pdf';
		$this->load->library('admission');
		$this->admission->pdf($res, $file_name);
	}

	/**
	 * Admission Reports
	 * @return Object
	 */
	public function admission_reports() {
		if ($this->input->is_ajax_request()) {
			$query = $this->m_registrants->admission_reports();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($query->result(), self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Profile
	 * @return Void
	 */
	public function profile() {
		$id = _toInteger($this->uri->segment(4));
		if (_isNaturalNumber( $id )) {
			$this->load->model(['m_students', 'm_verification_subject_scores']);
			$this->vars['student'] = $this->m_students->profile($id);
			$this->vars['subjects'] = $this->m_verification_subject_scores->student_subject_scores($id);
			$this->vars['title'] = 'Profil Calon Peserta Didik Baru';
			$this->vars['photo'] = base_url('media_library/images/no-image.png');
			$this->vars['scholarships'] = $this->vars['achievements'] = FALSE;
			$photo_name = $this->vars['student']->photo;
			$photo = 'media_library/users/photo/' . $photo_name;
			if ($photo_name && file_exists($_SERVER['DOCUMENT_ROOT'] . '/' . $photo)) {
				$this->vars['photo'] = base_url($photo);
			}
			$this->vars['admission'] = $this->vars['registrants'] = TRUE;
			$this->vars['content'] = 'academic/student_profile';
			$this->load->view('backend/index', $this->vars);
		} else {
			show_404();
		}
	}
}
