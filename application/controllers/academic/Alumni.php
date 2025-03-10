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

class Alumni extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model(['m_alumni', 'm_users']);
		$this->pk = M_alumni::$pk;
		$this->table = M_alumni::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Alumni';
		$this->vars['academic'] = $this->vars['academic_references'] = $this->vars['alumni'] = TRUE;
		$this->vars['content'] = 'academic/alumni';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Profile
	 * @return Void
	 */
	public function profile() {
		$id = _toInteger($this->uri->segment(4));
		if (_isNaturalNumber( $id )) {
			$this->load->model(['m_students', 'm_scholarships', 'm_achievements']);
			$this->vars['student'] = $this->m_students->profile($id);
			$this->vars['scholarships'] = $this->m_scholarships->get_by_student_id($id);
			$this->vars['achievements'] = $this->m_achievements->get_by_student_id($id);
			$this->vars['title'] = 'Profil Alumni';
			$this->vars['photo'] = base_url('media_library/images/no-image.png');
			$photo_name = $this->vars['student']->photo;
			$photo = 'media_library/users/photo/' . $photo_name;
			if ($photo_name && file_exists($_SERVER['DOCUMENT_ROOT'] . '/' . $photo)) {
				$this->vars['photo'] = base_url($photo);
			}
			$this->vars['academic'] = $this->vars['academic_references'] = $this->vars['alumni'] = TRUE;
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
			$query = $this->m_alumni->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_alumni->get_where($keyword);
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
				if (_isNaturalNumber( $id )) {
					if ($dataset['is_alumni'] === 'false') {
						$student_status_id = get_option_id('student_status', 'aktif');
						if (_isNaturalNumber( $student_status_id )) {
							$dataset['student_status_id'] = $student_status_id;
						}
					} else if ($dataset['is_alumni'] == 'unverified') {
						$dataset['is_student'] = 'false';
						$dataset['is_prospective_student'] = 'false';
					}
					$query = $this->model->update($id, $this->table, $dataset);
					if ($query) $this->m_users->activate_account($dataset['email']);
					$this->vars['status'] = $query ? 'success' : 'error';
					$this->vars['message'] = $query ? 'updated' : 'not_updated';
					
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = 'not_updated';
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
	 * Dataset
	 * @return Array
	 */
	private function dataset() {
		return [
			'is_alumni' => $this->input->post('is_alumni', true),
			'nis' => strip_tags($this->input->post('nis', true)),
			'full_name' => $this->input->post('full_name', true),
			'street_address' => $this->input->post('street_address', true),
			'rt' => $this->input->post('rt', true),
			'rw' => $this->input->post('rw', true),
			'sub_village' => $this->input->post('sub_village', true),
			'village' => $this->input->post('village', true),
			'sub_district' => $this->input->post('sub_district', true),
			'district' => $this->input->post('district', true),
			'postal_code' => $this->input->post('postal_code', true),
			'phone' => $this->input->post('phone', true),
			'mobile_phone' => $this->input->post('mobile_phone', true),
			'email' => $this->input->post('email', true) ?? NULL,
			'start_date' => $this->input->post('start_date', true),
			'end_date' => $this->input->post('end_date', true),
			'reason' => $this->input->post('reason', true),
			'birth_place' => $this->input->post('birth_place', true),
			'birth_date' => $this->input->post('birth_date', true)
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation( $id = 0 ) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('full_name', 'Nama Lengkap', 'trim|required');
		$val->set_rules('nis', 'NIS', 'trim|alpha_numeric_spaces|callback_nis_exists[' . $id . ']');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * NIS Exists?
	 * @param String $nis
	 * @return Boolean
	 */
	public function nis_exists( $nis = NULL, $id = 0 ) {
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
		$email_exists = $this->m_users->email_exists( $email, $id );
		if ( $email_exists ) {
			$this->form_validation->set_message('email_exists', 'Email sudah digunakan');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Alumni Reports
	 * @return Object
	 */
	public function alumni_reports() {
		if ($this->input->is_ajax_request()) {
			$query = $this->m_alumni->alumni_reports();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($query->result(), self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}
