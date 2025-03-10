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

class Profile extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('m_users');
		$this->pk = M_users::$pk;
		$this->table = M_users::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$id = _toInteger(__session('user_id'));
		$this->vars['title'] = 'Ubah Profil';
		$this->vars['user_profile'] = TRUE;
		$this->vars['query'] = $this->model->RowObject($this->pk, $id, $this->table);
		$this->vars['content'] = 'users/profile';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	* save
	* @return Object
	*/
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger(__session('user_id'));
			if (_isNaturalNumber( $id )) {
				if ($this->validation($id)) {
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
			'full_name' => $this->input->post('full_name', true),
			'email' => $this->input->post('email', true)
		];
	}

	/**
	* Validation Form
	* @access public
	* @return Boolean
	*/
	private function validation($id) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('full_name', 'Full Name', 'trim|required');
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
}
