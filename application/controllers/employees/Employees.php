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

class Employees extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model(['m_employees', 'm_users']);
		$this->pk = M_employees::$pk;
		$this->table = M_employees::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Guru dan Tenaga Kependidikan';
		$this->vars['employees'] = $this->vars['all_employees'] = TRUE;
		$this->vars['content'] = 'employees/employees';
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
			$query = $this->m_employees->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_employees->get_where($keyword);
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
			'is_employee' => 'true',
			'full_name' => $this->input->post('full_name', true),
			'gender' => $this->input->post('gender', true),
			'nik' => $this->input->post('nik') ?? NULL,
			'birth_place' => $this->input->post('birth_place', true) ?? NULL,
			'birth_date' => $this->input->post('birth_date', true) ?? NULL,
			'street_address' => $this->input->post('street_address', true) ?? NULL,
			'rt' => $this->input->post('rt', true) ?? NULL,
			'rw' => $this->input->post('rw', true) ?? NULL,
			'sub_village' => $this->input->post('sub_village', true) ?? NULL,
			'village' => $this->input->post('village', true) ?? NULL,
			'sub_district' => $this->input->post('sub_district', true) ?? NULL,
			'district' => $this->input->post('district', true) ?? NULL,
			'postal_code' => $this->input->post('postal_code', true) ?? NULL,
			'religion_id' => _toInteger($this->input->post('religion_id', true)),
			'citizenship' => $this->input->post('citizenship', true) ?? NULL,
			'country' => $this->input->post('country', true) ?? NULL,
			'employment_type_id' => _toInteger($this->input->post('employment_type_id', true)),
			'phone' => $this->input->post('phone', true) ?? NULL,
			'mobile_phone' => $this->input->post('mobile_phone', true) ?? NULL,
			'email' => $this->input->post('email', true) ?? NULL
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation( $id = 0 ) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('full_name', 'Full Name', 'trim|required');
		$val->set_rules('nik', 'NIK', 'trim|required');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
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
	 * Employee Reports
	 * @return Object
	 */
	public function employee_reports() {
		if ($this->input->is_ajax_request()) {
			$query = $this->m_employees->employee_reports();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($query->result(), self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}
