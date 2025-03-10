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

class Administrator extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_users',
			'm_user_groups'
		]);
		$this->pk = m_users::$pk;
		$this->table = m_users::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Pengguna Administrator';
		$this->vars['users'] = $this->vars['administrator'] = TRUE;
		$this->vars['user_group_dropdown'] = json_encode($this->m_user_groups->dropdown(), self::REQUIRED_FLAGS);
		$this->vars['content'] = 'users/administrator';
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
			$query = $this->m_users->get_where('admin', $keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_users->get_where('admin', $keyword);
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
	 * dataset
	 * @param Integer
	 * @return Array
	 */
	private function dataset() {
		$data = [];
		$password = $this->input->post('password', true);
		if (!empty($password)) $data['password'] = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
		$data['email'] = $this->input->post('email', true) ? $this->input->post('email', true) : NULL;
		$data['full_name'] = $this->input->post('full_name', true);
		$data['user_group_id'] = $this->input->post('user_group_id', true) ? $this->input->post('user_group_id', true) : 0;
		$data['is_admin'] = 'true';
		return $data;
	}

	/**
	 * Validation Form
	 * @param Integer
	 * @return Boolean
	 */
	private function validation($id = 0) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		if (_isNaturalNumber( $id )) {
			$val->set_rules('password', 'Password', 'trim|min_length[6]');
		} else {
			$val->set_rules('password', 'Password', 'trim|required|min_length[6]');
		}
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists['.$id.']');
		$val->set_rules('full_name', 'Full Name', 'trim|required');
		$val->set_rules('user_group_id', 'Group', 'trim|required');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('valid_email', '{field} harus diisi dengan format email yang benar');
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
}
