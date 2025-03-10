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

class Employee_profile extends Admin_Controller {

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$id = NULL !== __session('user_id') ? __session('user_id') : 0;
		$this->vars['title'] = 'Biodata';
		$this->vars['employee_profile'] = TRUE;
		$this->vars['religions'] = ['' => 'Pilih :'] + get_options('religion', FALSE);
		$this->vars['employment_types'] = ['' => 'Pilih :'] + get_options('employment_type', FALSE);
		$this->vars['query'] = $this->model->RowObject('id', $id, 'users');
		$this->vars['content'] = 'employee_profile';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * save
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger(__session('user_id'));
			if ($this->validation( $id )) {
				$dataset = $this->dataset();
				$this->vars['status'] = $this->model->update($id, 'users', $dataset) ? 'success' : 'error';
				$this->vars['message'] = $this->vars['status'] == 'success' ? 'updated' : 'not_updated';
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
			'full_name' => $this->input->post('full_name', true),
			'gender' => $this->input->post('gender', true),
			'nik' => $this->input->post('nik') ? $this->input->post('nik', true) : NULL,
			'birth_place' => $this->input->post('birth_place', true),
			'birth_date' => $this->input->post('birth_date', true),
			'mother_name' => $this->input->post('mother_name', true),
			'street_address' => $this->input->post('street_address', true),
			'rt' => $this->input->post('rt', true),
			'rw' => $this->input->post('rw', true),
			'sub_village' => $this->input->post('sub_village', true),
			'village' => $this->input->post('village', true),
			'sub_district' => $this->input->post('sub_district', true),
			'district' => $this->input->post('district', true),
			'postal_code' => $this->input->post('postal_code', true),
			'religion_id' => _toInteger($this->input->post('religion_id', true)),
			'citizenship' => $this->input->post('citizenship', true),
			'country' => $this->input->post('country', true),
			'employment_type_id' => _toInteger($this->input->post('employment_type_id', true)),
			'phone' => $this->input->post('phone', true),
			'mobile_phone' => $this->input->post('mobile_phone', true),
			'email' => $this->input->post('email') ? $this->input->post('email', true) : NULL
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation( $id ) {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('full_name', 'Nama Lengkap', 'trim|required');
		$val->set_rules('nik', 'NIK', 'trim|required');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists[' . $id . ']');
		$val->set_rules('rt', 'RT', 'trim|numeric');
		$val->set_rules('rw', 'RW', 'trim|numeric');
		$val->set_rules('postal_code', 'Kode Pos', 'trim|numeric');
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
